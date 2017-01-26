<?php

/**
 * @file
 * Contains \Drupal\external_entities\Entity\ExternalEntityType.
 */

namespace Drupal\external_entities\Entity;

use Drupal\Core\Config\Entity\ConfigEntityBundleBase;
use Drupal\external_entities\ExternalEntityTypeInterface;

/**
 * Defines the External Entity type configuration entity.
 *
 * @ConfigEntityType(
 *   id = "external_entity_type",
 *   label = @Translation("External Entity type"),
 *   handlers = {
 *     "access" = "Drupal\Core\Entity\EntityAccessControlHandler",
 *     "form" = {
 *       "add" = "Drupal\external_entities\ExternalEntityTypeForm",
 *       "edit" = "Drupal\external_entities\ExternalEntityTypeForm",
 *       "delete" = "Drupal\Core\Entity\EntityDeleteForm"
 *     },
 *     "list_builder" = "Drupal\external_entities\ExternalEntityTypeListBuilder",
 *   },
 *   admin_permission = "administer external entity types",
 *   config_prefix = "type",
 *   bundle_of = "external_entity",
 *   entity_keys = {
 *     "id" = "type",
 *     "label" = "label"
 *   },
 *   links = {
 *     "edit-form" = "/admin/structure/external-entity-types/manage/{external_entity_type}",
 *     "delete-form" = "/admin/structure/external-entity-types/manage/{external_entity_type}/delete",
 *     "collection" = "/admin/structure/external-entity-types",
 *   },
 *   config_export = {
 *     "label",
 *     "type",
 *     "description",
 *     "read_only",
 *     "field_mappings",
 *     "endpoint",
 *     "client",
 *     "format",
 *     "pager_settings",
 *     "api_key_settings",
 *     "parameters",
 *   }
 * )
 */
class ExternalEntityType extends ConfigEntityBundleBase implements ExternalEntityTypeInterface {

  /**
   * The machine name of this external entity type.
   *
   * @var string
   */
  protected $type;

  /**
   * The human-readable name of the external entity type.
   *
   * @var string
   */
  protected $label;

  /**
   * A brief description of this external entity type.
   *
   * @var string
   */
  protected $description;

  /**
   * Whether or not entity types of this external entity type are read only.
   *
   * @var boolean
   */
  protected $read_only;

  /**
   * The field mappings for this external entity type.
   *
   * @var array
   */
  protected $field_mappings = array();

  /**
   * The endpoint of this external entity type.
   *
   * @var string
   */
  protected $endpoint;

  /**
   * The external entity storage client id.
   *
   * @var string
   */
  protected $client = 'rest_client';

  /**
   * The format in which to make the requests for this externa entity type.
   *
   * For example: 'json'.
   *
   * @var string
   */
  protected $format = 'json';

  /**
   * An array with the pager settings.
   *
   * The array must contain following keys:
   *   - 'default_limit': default number of items per page.
   *   - 'page_parameter': The name of the page parameter.
   *   - 'page_size_parameter': The name of the page size parameter.
   *   - 'page_parameter_type': Either 'pagenum' or 'startitem'. Use 'pagenum'
   *     when the pager uses page numbers to determine the item to start at, use
   *     'startitem' when the pager uses the item number to start at.
   *   - 'page_size_parameter_type': Either 'pagesize' or 'enditem'. Use
   *     'pagesize' when the pager uses this parameter to determine the amount
   *     of items on each page, use 'enditem' when the pager uses this parameter
   *     to determine the number of the last item on the page.
   *
   * @var array
   */
  protected $pager_settings = [];

  /**
   * API key settings.
   *
   * An array with following keys:
   *   - 'header_name': The HTTP header name for the API key.
   *   - 'key': The value for the API key.
   *
   * @var array
   */
  protected $api_key_settings = [];

  /**
   * The parameters for this external entity type.
   *
   * @var array
   */
  protected $parameters = [];


  /**
   * {@inheritdoc}
   */
  public function __construct(array $values, $entity_type) {
    parent::__construct($values, $entity_type);
    $this->pager_settings += array(
      'default_limit' => 10,
      'page_parameter' => 'page',
      'page_size_parameter' => 'pagesize',
      'page_parameter_type' => 'pagenum',
      'page_size_parameter_type' => 'pagesize',
    );
    $this->api_key_settings += array(
      'header_name' => '',
      'key' => '',
    );
    $this->parameters += array(
      'list' => [],
      'single' => [],
    );
  }
  /**
   * {@inheritdoc}
   */
  public function id() {
    return $this->type;
  }

  /**
   * {@inheritdoc}
   */
  public function getDescription() {
    return $this->description;
  }

  /**
   * {@inheritdoc}
   */
  public function isReadOnly() {
    return $this->read_only;
  }

  /**
   * {@inheritdoc}
   */
  public function getFieldMappings() {
    return $this->field_mappings;
  }

  /**
   * {@inheritdoc}
   */
  public function getFieldMapping($field_name) {
    return isset($this->field_mappings[$field_name]) ? $this->field_mappings[$field_name] : FALSE;
  }

  /**
   * {@inheritdoc}
   */
  public function getEndpoint() {
    return $this->endpoint;
  }

  /**
   * {@inheritdoc}
   */
  public function getClient() {
    return $this->client;
  }

  /**
   * {@inheritdoc}
   */
  public function getFormat() {
    return $this->format;
  }

  /**
   * {@inheritdoc}
   */
  public function getPagerSettings() {
    return $this->pager_settings;
  }

  /**
   * {@inheritdoc}
   */
  public function getApiKeySettings() {
    return $this->api_key_settings;
  }

  /**
   * {@inheritdoc}
   */
  public function getParameters() {
    return $this->parameters;
  }

  /**
   * {@inheritdoc}
   */
  public function getTypeParameters($type) {
    return isset($this->parameters[$type]) ? $this->parameters[$type] : [];
  }

}
