<?php

/**
 * @file
 * Contains \Drupal\external_entities\ExternalEntityStorage.
 */

namespace Drupal\external_entities;

use Symfony\Component\DependencyInjection\ContainerInterface;
use Drupal\Core\Entity\EntityTypeInterface;
use Drupal\Core\Entity\EntityManagerInterface;
use Drupal\Core\Entity\EntityStorageException;
use Drupal\Component\Plugin\PluginManagerInterface;
use Drupal\external_entities\ResponseDecoderFactoryInterface;
use GuzzleHttp\ClientInterface;
use Drupal\Core\Entity\ContentEntityStorageBase;
use Drupal\Core\Field\FieldDefinitionInterface;
use Drupal\Core\Entity\ContentEntityInterface;
use Drupal\Core\Cache\CacheBackendInterface;

/**
 * Defines the controller class for nodes.
 *
 * This extends the base storage class, adding required special handling for
 * node entities.
 */
class ExternalEntityStorage extends ContentEntityStorageBase {

  /**
   * The external storage client manager.
   *
   * @var \Drupal\Component\Plugin\PluginManagerInterface
   */
  protected $storageClientManager;

  /**
   * Storage client instances.
   *
   * @var \Drupal\external_entities\ExternalEntityStorageClientInterface[]
   */
  protected $storageClients = [];

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
   * {@inheritdoc}
   */
  public static function createInstance(ContainerInterface $container, EntityTypeInterface $entity_type) {
    return new static(
      $entity_type,
      $container->get('entity.manager'),
      $container->get('cache.entity'),
      $container->get('plugin.manager.external_entity_storage_client'),
      $container->get('external_entity.storage_client.response_decoder_factory'),
      $container->get('http_client')
    );
  }

  /**
   * Constructs a new ExternalEntityStorage object.
   *
   * @param \Drupal\Core\Entity\EntityTypeInterface $entity_type
   *   The entity type definition.
   * @param \Drupal\Core\Entity\EntityManagerInterface $entity_manager
   *   The entity manager.
   * @param \Drupal\Core\Cache\CacheBackendInterface $cache
   *   The cache backend to be used.
   * @param \Drupal\Component\Plugin\PluginManagerInterface $storage_client_manager
   *   The storage client manager.
   */
  public function __construct(EntityTypeInterface $entity_type, EntityManagerInterface $entity_manager, CacheBackendInterface $cache, PluginManagerInterface $storage_client_manager, ResponseDecoderFactoryInterface $decoder, ClientInterface $http_client) {
    parent::__construct($entity_type, $entity_manager, $cache);
    $this->storageClientManager = $storage_client_manager;
    $this->decoder = $decoder;
    $this->httpClient = $http_client;
  }

  /**
   * Get the storage client for a bundle.
   *
   * @param string $bundle_id
   *   The bundle to get the storage client for.
   *
   * @return \Drupal\external_entities\ExternalEntityStorageClientInterface
   *   The external entity storage client.
   */
  protected function getStorageClient($bundle_id) {
    if (!isset($this->storageClients[$bundle_id])) {
      $bundle = $this->entityManager->getStorage('external_entity_type')->load($bundle_id);
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
      $this->storageClients[$bundle_id] = $this->storageClientManager->createInstance(
        $bundle->getClient(),
        $config
      );
    }
    return $this->storageClients[$bundle_id];
  }

  /**
   * Acts on entities before they are deleted and before hooks are invoked.
   *
   * Used before the entities are deleted and before invoking the delete hook.
   *
   * @param \Drupal\Core\Entity\EntityInterface[] $entities
   *   An array of entities.
   *
   * @throws EntityStorageException
   */
  public function preDelete(array $entities) {
    foreach ($entities as $entity) {
      $bundle = $this->entityManager->getStorage('external_entity_type')->load($entity->bundle());
      if ($bundle && $bundle->isReadOnly()) {
        throw new EntityStorageException($this->t('Can not delete read-only external entities.'));
      }
    }
  }

  /**
   * {@inheritdoc}
   */
  protected function doDelete($entities) {
    // Do the actual delete.
    foreach ($entities as $entity) {
      $this->getStorageClient($entity->bundle())->delete($entity);
    }
  }

  /**
   * {@inheritdoc}
   */
  protected function doLoadMultiple(array $ids = NULL) {
    $entities = array();

    foreach ($ids as $id) {
      if (strpos($id, '-')) {
        list($bundle, $external_id) = explode('-', $id);
        if ($external_id) {
          $entities[$id] = $this->create([$this->entityType->getKey('bundle') => $bundle])->mapObject($this->getStorageClient($bundle)->load($external_id))->enforceIsNew(FALSE);
        }
      }
    }
    return $entities;
  }


  /**
   * Acts on an entity before the presave hook is invoked.
   *
   * Used before the entity is saved and before invoking the presave hook.
   *
   * @param \Drupal\Core\Entity\EntityInterface $entity
   *   The entity object.
   *
   * @throws EntityStorageException
   */
  public function preSave(\Drupal\Core\Entity\EntityInterface $entity) {
    $bundle = $this->entityManager->getStorage('external_entity_type')->load($entity->bundle());
    if ($bundle && $bundle->isReadOnly()) {
      throw new EntityStorageException($this->t('Can not save read-only external entities.'));
    }
  }
  /**
   * {@inheritdoc}
   */
  protected function doSave($id, \Drupal\Core\Entity\EntityInterface $entity) {
    return $this->getStorageClient($entity->bundle())->save($entity);
  }

  /**
   * {@inheritdoc}
   */
  protected function getQueryServiceName() {
    return 'entity.query.external';
  }

  /**
   * {@inheritdoc}
   */
  protected function has($id, \Drupal\Core\Entity\EntityInterface $entity) {
    return !$entity->isNew();
  }

  /**
   * {@inheritdoc}
   */
  protected function doDeleteFieldItems($entities) {
  }

  /**
   * {@inheritdoc}
   */
  protected function doDeleteRevisionFieldItems(ContentEntityInterface $revision) {
  }

  /**
   * {@inheritdoc}
   */
  protected function doLoadRevisionFieldItems($revision_id) {
  }

  /**
   * {@inheritdoc}
   */
  protected function doSaveFieldItems(ContentEntityInterface $entity, array $names = array()) {
  }

  /**
   * {@inheritdoc}
   */
  protected function readFieldItemsToPurge(FieldDefinitionInterface $field_definition, $batch_size) {
    return array();
  }

  /**
   * {@inheritdoc}
   */
  protected function purgeFieldItems(ContentEntityInterface $entity, FieldDefinitionInterface $field_definition) {
  }

  /**
   * {@inheritdoc}
   */
  public function countFieldData($storage_definition, $as_bool = FALSE) {
    return $as_bool ? 0 : FALSE;
  }

  /**
   * {@inheritdoc}
   */
  public function hasData() {
    return FALSE;
  }

}
