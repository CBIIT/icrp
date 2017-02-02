<?php

/**
 * @file
 * Contains \Drupal\external_entities\Entity\Query\External\Query.
 */

namespace Drupal\external_entities\Entity\Query\External;

use Drupal\Core\Entity\EntityManagerInterface;
use Drupal\Core\Entity\EntityTypeInterface;
use Drupal\Core\Entity\Query\QueryBase;
use Drupal\Core\Entity\Query\QueryException;
use Drupal\Core\Entity\Query\QueryInterface;
use Drupal\Component\Plugin\PluginManagerInterface;
use Drupal\external_entities\ResponseDecoderFactoryInterface;
use GuzzleHttp\ClientInterface;

/**
 * The SQL storage entity query class.
 */
class Query extends QueryBase implements QueryInterface {

  /**
   * The parameters to send to the external entity storage client.
   *
   * @var array
   */
  protected $parameters = array();

  /**
   * An array of fields keyed by the field alias.
   *
   * Each entry correlates to the arguments of
   * \Drupal\Core\Database\Query\SelectInterface::addField(), so the first one
   * is the table alias, the second one the field and the last one optional the
   * field alias.
   *
   * @var array
   */
  protected $fields = array();

  /**
   * An array of strings added as to the group by, keyed by the string to avoid
   * duplicates.
   *
   * @var array
   */
  protected $groupBy = array();

  /**
   * Stores the entity manager used by the query.
   *
   * @var \Drupal\Core\Entity\EntityManagerInterface
   */
  protected $entityManager;

  /**
   * The external storage client manager.
   *
   * @var \Drupal\Component\Plugin\PluginManagerInterface
   */
  protected $storageClientManager;

  /**
   * The decoder.
   *
   * @var \Drupal\external_entities\ResponseDecoderFactoryInterface
   */
  protected $decoder;

  /**
   * The HTTP client to fetch the data with.
   *
   * @var \GuzzleHttp\ClientInterface
   */
  protected $httpClient;

  /**
   * Storage client instance.
   *
   * @var \Drupal\external_entities\ExternalEntityStorageClientInterface
   */
  protected $storageClient;

  /**
   * Constructs a query object.
   *
   * @param \Drupal\Core\Entity\EntityTypeInterface $entity_type
   *   The entity type definition.
   * @param string $conjunction
   *   - AND: all of the conditions on the query need to match.
   * @param array $namespaces
   *   List of potential namespaces of the classes belonging to this query.
   */
  public function __construct(EntityTypeInterface $entity_type, $conjunction, array $namespaces, PluginManagerInterface $storage_client_manager, ResponseDecoderFactoryInterface $decoder, ClientInterface $http_client, EntityManagerInterface $entity_manager) {
    parent::__construct($entity_type, $conjunction, $namespaces);
    $this->storageClientManager = $storage_client_manager;
    $this->decoder = $decoder;
    $this->httpClient = $http_client;
    $this->entityManager = $entity_manager;
  }


  /**
   * Implements \Drupal\Core\Entity\Query\QueryInterface::execute().
   */
  public function execute() {
    return $this
      ->prepare()
      ->compile()
      ->addSort()
      ->finish()
      ->result();
  }

  /**
   * Prepares the basic query with proper metadata/tags and base fields.
   *
   * @throws \Drupal\Core\Entity\Query\QueryException
   *   Thrown if the base table does not exists.
   *
   * @return \Drupal\Core\Entity\Query\Sql\Query
   *   Returns the called object.
   */
  protected function prepare() {
    if ($this->amountOfBundleConditions() !== 1) {
      throw new QueryException("You must specify a single bundle for external entity queries.");
    }
    $this->checkConditions();
    return $this;
  }

  /**
   * Check if all conditions are valid.
   *
   * @param \Drupal\Core\Entity\Query\ConditionInterface $condition
   *   The conditions to check.
   *
   * @throws QueryException
   */
  protected function checkConditions(\Drupal\Core\Entity\Query\ConditionInterface $condition = NULL) {
    if (is_null($condition)) {
      $condition = $this->condition;
    }
    foreach ($condition->conditions() as $c) {
      if ($c['field'] instanceOf ConditionInterface) {
        $this->checkConditions($c['field']);
      }
      elseif ($c['operator'] && !in_array($c['operator'], $this->supportedOperators())) {
        throw new QueryException("Operator {$c['operator']} is not supported by external entity queries.");
      }
    }
  }

  /**
   * Returns the supported condition operators.
   *
   * @return array
   *   The supported condition operators.
   */
  protected function supportedOperators() {
    return array(
      '=',
      'IN',
    );
  }

  /**
   * Get the amount of bundle conditions.
   */
  protected function amountOfBundleConditions(\Drupal\Core\Entity\Query\ConditionInterface $condition = NULL) {
    $amount = 0;
    if (is_null($condition)) {
      $condition = $this->condition;
    }
    foreach ($condition->conditions() as $c) {
      if ($c['field'] instanceOf ConditionInterface) {
        $amount += $this->numberOfBundleConditions($c['field']);
      }
      else {
        if ($c['field'] == $this->entityType->getKey('bundle')) {
          $amount += is_array($c['value']) ? count($c['value']) : 1;
        }
      }
    }
    return $amount;
  }

  /**
   * Compiles the conditions.
   *
   * @return \Drupal\Core\Entity\Query\Sql\Query
   *   Returns the called object.
   */
  protected function compile() {
    $this->condition->compile($this);
    return $this;
  }

  /**
   * Adds the sort to the build query.
   *
   * @return \Drupal\Core\Entity\Query\Sql\Query
   *   Returns the called object.
   */
  protected function addSort() {
    // TODO.
    return $this;
  }

  /**
   * Finish the query by adding fields, GROUP BY and range.
   *
   * @return \Drupal\Core\Entity\Query\Sql\Query
   *   Returns the called object.
   */
  protected function finish() {
    $bundle_id = $this->getBundle();
    $bundle = $this->entityManager->getStorage($this->entityType->getBundleEntityType())->load($bundle_id);
    $pager_settings = $bundle->getPagerSettings();

    $this->initializePager();

    if (!empty($pager_settings['page_parameter']) && !empty($pager_settings['page_size_parameter'])) {
      if ($this->range) {
        $start = $this->range['start'];
        $end = $this->range['length'];
        if ($pager_settings['page_parameter_type'] === 'pagenum') {
          $start = $this->range['start'] / $this->range['length'];
        }
        if ($pager_settings['page_size_parameter_type'] === 'enditem') {
          $end = $this->range['start'] + $this->range['length'];
        }
        $this->setParameter($pager_settings['page_parameter'], $start);
        $this->setParameter($pager_settings['page_size_parameter'], $end);
      }
    }
    return $this;
  }

  /**
   * Executes the query and returns the result.
   *
   * @return int|array
   *   Returns the query result as entity IDs.
   */
  protected function result() {
    if ($this->count) {
      return count($this->getStorageClient()->query($this->parameters));
    }
    // Return a keyed array of results. The key is either the revision_id or
    // the entity_id depending on whether the entity type supports revisions.
    // The value is always the entity id.
    // TODO.
    $query_results = $this->getStorageClient()->query($this->parameters);
    $result = array();
    $bundle_id = $this->getBundle();
    $bundle = $this->entityManager->getStorage($this->entityType->getBundleEntityType())->load($bundle_id);
    foreach ($query_results as $query_result) {
      $id = $bundle_id . '-' . $query_result->{$bundle->getFieldMapping('id')};
      $result[$id] = $id;
    }
    return $result;
  }

  /**
   * Get the storage client for a bundle.
   *
   * @return \Drupal\external_entities\ExternalEntityStorageClientInterface
   *   The external entity storage client.
   */
  protected function getStorageClient() {
    if (!$this->storageClient) {
      $bundle = $this->entityManager->getStorage($this->entityType->getBundleEntityType())->load($this->getBundle());
      $config = [
        'http_client' => $this->httpClient,
        'decoder' => $this->decoder,
        'endpoint' => $bundle->getEndpoint(),
        'format' => $bundle->getFormat(),
        'http_headers' => [],
        'parameters' => $bundle->getParameters(),
      ];
      $api_key_settings = $bundle->getApiKeySettings();
      if (!empty($api_key_settings['header_name']) && !empty($api_key_settings['key'])) {
        $config['http_headers'][$api_key_settings['header_name']] = $api_key_settings['key'];
      }
      $this->storageClient = $this->storageClientManager->createInstance(
        $bundle->getClient(),
        $config
      );

    }
    return $this->storageClient;
  }

  /**
   * Determines whether the query requires GROUP BY and ORDER BY MIN/MAX.
   *
   * @return bool
   */
  protected function isSimpleQuery() {
    return (!$this->pager && !$this->range && !$this->count);
  }

  /**
   * Implements the magic __clone method.
   *
   * Reset fields and GROUP BY when cloning.
   */
  public function __clone() {
    parent::__clone();
    $this->fields = array();
    $this->groupBy = array();
  }

  /**
   * Set a parameter.
   */
  public function setParameter($key, $value) {
    if ($key == $this->entityType->getKey('bundle')) {
      return FALSE;
    }
    $this->parameters[$key] = is_array($value) ? implode($value, ',') : $value;
  }

  /**
   * Get the bundle for this query.
   */
  protected function getBundle(\Drupal\Core\Entity\Query\ConditionInterface $condition = NULL) {
    if (is_null($condition)) {
      $condition = $this->condition;
    }
    foreach ($condition->conditions() as $c) {
      if ($c['field'] instanceOf ConditionInterface) {
        $bundle = $this->getBundle($c['field']);
        if ($bundle) {
          return $bundle;
        }
      }
      else {
        if ($c['field'] == $this->entityType->getKey('bundle')) {
          return is_array($c['value']) ? reset($c['value']) : $c['value'];
        }
      }
    }
    return FALSE;
  }
}
