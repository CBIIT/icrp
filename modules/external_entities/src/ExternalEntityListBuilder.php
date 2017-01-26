<?php

/**
 * @file
 * Contains \Drupal\external_entities\ExternalEntityListBuilder.
 */

namespace Drupal\external_entities;

use Drupal\Component\Utility\SafeMarkup;
use Drupal\Core\Entity\EntityInterface;
use Drupal\Core\Entity\EntityListBuilder;
use Drupal\Core\Entity\EntityStorageInterface;
use Drupal\Core\Entity\EntityTypeInterface;
use Drupal\Core\Entity\EntityManagerInterface;
use Drupal\Core\Routing\RedirectDestinationInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Defines a class to build a listing of external entities.
 *
 * @see \Drupal\external_entities\Entity\ExternalEntity
 */
class ExternalEntityListBuilder extends EntityListBuilder {

  /**
   * The redirect destination service.
   *
   * @var \Drupal\Core\Routing\RedirectDestinationInterface
   */
  protected $redirectDestination;

  /**
   * The entity manager.
   *
   * @var \Drupal\Core\Entity\EntityManagerInterface
   */
  protected $entityManager;

  protected $bundle;

  /**
   * Constructs a new ExternalEntityListBuilder object.
   *
   * @param \Drupal\Core\Entity\EntityTypeInterface $entity_type
   *   The entity type definition.
   * @param \Drupal\Core\Entity\EntityStorageInterface $storage
   *   The entity storage class.
   * @param \Drupal\Core\Routing\RedirectDestinationInterface $redirect_destination
   *   The redirect destination service.
   * @param \Drupal\Core\Entity\EntityManagerInterface $entity_manager
   *   The entity manager.
   */
  public function __construct(EntityTypeInterface $entity_type, EntityStorageInterface $storage, RedirectDestinationInterface $redirect_destination, EntityManagerInterface $entity_manager) {
    parent::__construct($entity_type, $storage);
    $this->redirectDestination = $redirect_destination;
    $this->entityManager = $entity_manager;
  }

  public function setBundle($bundle) {
    $this->bundle = $bundle;
    return $this;
  }

  /**
   * Loads entity IDs using a pager sorted by the entity id.
   *
   * @return array
   *   An array of entity IDs.
   */
  protected function getEntityIds() {
    $query = $this->getStorage()->getQuery();
    $keys = $this->entityType->getKeys();
    $query
      ->condition($keys['bundle'], $this->bundle)
      ->sort($keys['id']);

    $bundle = $this->entityManager->getStorage($this->entityType->getBundleEntityType())->load($this->bundle);
    $pager_settings = $bundle->getPagerSettings();
    if (!empty($pager_settings['page_parameter']) && !empty($pager_settings['page_size_parameter'])) {
      $query->pager($pager_settings['default_limit']);
    }

    return $query->execute();
  }

  /**
   * {@inheritdoc}
   */
  public static function createInstance(ContainerInterface $container, EntityTypeInterface $entity_type) {
    return new static(
      $entity_type,
      $container->get('entity.manager')->getStorage($entity_type->id()),
      $container->get('redirect.destination'),
      $container->get('entity.manager')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function buildHeader() {
    // Enable language column and filter if multiple languages are added.
    $header = array(
      'title' => $this->t('Title'),
      'type' => array(
        'data' => $this->t('External entity type'),
        'class' => array(RESPONSIVE_PRIORITY_MEDIUM),
      ),
    );
    return $header + parent::buildHeader();
  }

  /**
   * {@inheritdoc}
   */
  public function buildRow(EntityInterface $entity) {
    $uri = $entity->toUrl();
    $options = $uri->getOptions();
    $uri->setOptions($options);
    $row['title']['data'] = array(
      '#type' => 'link',
      '#title' => $entity->label(),
      '#url' => $uri,
    );
    $row['type'] = SafeMarkup::checkPlain($this->entityManager->getStorage($this->entityType->getBundleEntityType())->load($entity->bundle())->label());
    return $row + parent::buildRow($entity);
  }

  /**
   * {@inheritdoc}
   */
  protected function getDefaultOperations(EntityInterface $entity) {
    $operations = parent::getDefaultOperations($entity);

    $destination = $this->redirectDestination->getAsArray();
    foreach ($operations as $key => $operation) {
      $operations[$key]['query'] = $destination;
    }
    return $operations;
  }

}
