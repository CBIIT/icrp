<?php

/**
 * @file
 * Contains \Drupal\external_entities\ExternalEntityAccessControlHandler.
 */

namespace Drupal\external_entities;

use Drupal\Core\Access\AccessResult;
use Drupal\Core\Entity\EntityHandlerInterface;
use Drupal\Core\Entity\EntityTypeInterface;
use Drupal\Core\Field\FieldDefinitionInterface;
use Drupal\Core\Field\FieldItemListInterface;
use Drupal\Core\Language\LanguageInterface;
use Drupal\Core\Entity\EntityAccessControlHandler;
use Drupal\Core\Entity\EntityInterface;
use Drupal\Core\Session\AccountInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Drupal\Core\Entity\EntityManagerInterface;

/**
 * Defines the access control handler for the node entity type.
 *
 * @see \Drupal\external_entities\Entity\ExternalEntity
 * @ingroup external_entity_access
 */
class ExternalEntityAccessControlHandler extends EntityAccessControlHandler implements EntityHandlerInterface {

  /**
   * The entity manager.
   *
   * @var \Drupal\Core\Entity\EntityManagerInterface
   */
  protected $entityManager;

  /**
   * Constructs a ExternalEntityAccessControlHandler object.
   *
   * @param \Drupal\Core\Entity\EntityTypeInterface $entity_type
   *   The entity type definition.
   */
  public function __construct(EntityTypeInterface $entity_type, EntityManagerInterface $entity_manager) {
    parent::__construct($entity_type);
    $this->entityManager = $entity_manager;
  }

  /**
   * {@inheritdoc}
   */
  public static function createInstance(ContainerInterface $container, EntityTypeInterface $entity_type) {
    return new static(
      $entity_type,
      $container->get('entity.manager')
    );
  }


  /**
   * {@inheritdoc}
   */
  public function access(EntityInterface $entity, $operation, AccountInterface $account = NULL, $return_as_object = FALSE) {
    $account = $this->prepareUser($account);
    $result = parent::access($entity, $operation, $account, TRUE);
    if ($result->isForbidden()) {
      return $return_as_object ? $result : $result->isAllowed();
    }
    if ($operation !== 'view') {
      $bundle = $this->entityManager->getStorage($this->entityType->getBundleEntityType())->load($entity->bundle());
      if ($bundle->isReadOnly()) {
        $result = AccessResult::forbidden()->cachePerPermissions();
      }
    }
    if ($result->isForbidden()) {
      return $return_as_object ? $result : $result->isAllowed();
    }
    $permission = $operation === 'update' ? "edit {$entity->bundle()} external entity" : "{$operation} {$entity->bundle()} external entity";
    $result = AccessResult::allowedIfHasPermission($account, $permission);
    return $return_as_object ? $result : $result->isAllowed();
  }

  /**
   * {@inheritdoc}
   */
  public function createAccess($entity_bundle = NULL, AccountInterface $account = NULL, array $context = array(), $return_as_object = FALSE) {
    $account = $this->prepareUser($account);
    $result = parent::createAccess($entity_bundle, $account, $context, TRUE)->cachePerPermissions();
    if ($result->isForbidden()) {
      return $return_as_object ? $result : $result->isAllowed();
    }
    $bundle = $this->entityManager->getStorage($this->entityType->getBundleEntityType())->load($entity_bundle);
    if ($bundle->isReadOnly()) {
      $result = AccessResult::forbidden()->cachePerPermissions();
    }
    if ($result->isForbidden()) {
      return $return_as_object ? $result : $result->isAllowed();
    }
    $permission = "create $entity_bundle external entity";

    $result = AccessResult::allowedIfHasPermission($account, $permission);
    return $return_as_object ? $result : $result->isAllowed();
  }

  /**
   * {@inheritdoc}
   */
  protected function checkAccess(EntityInterface $entity, $operation, AccountInterface $account) {
    $result = parent::checkAccess($entity, $operation, $account);
    if ($result->isForbidden()) {
      return $result;
    }
    if ($operation !== 'view') {
      $bundle = $this->entityManager->getStorage($this->entityType->getBundleEntityType())->load($entity->bundle());
      if ($bundle->isReadOnly()) {
        $result = AccessResult::forbidden()->cachePerPermissions();
      }
    }
    return $result;
  }

  /**
   * {@inheritdoc}
   */
  protected function checkCreateAccess(AccountInterface $account, array $context, $entity_bundle = NULL) {
    $result = parent::checkCreateAccess($account, $context, $entity_bundle);
    if ($result->isForbidden()) {
      return $result;
    }
    if (!is_null($entity_bundle)) {
      return AccessResult::neutral()->cachePerPermissions();
    }
    $bundle = $this->entityManager->getStorage($this->entityType->getBundleEntityType())->load($entity_bundle);
    if ($bundle->isReadOnly()) {
      $result = AccessResult::forbidden()->cachePerPermissions();
    }
    return $result;
  }

  /**
   * {@inheritdoc}
   */
  protected function checkFieldAccess($operation, FieldDefinitionInterface $field_definition, AccountInterface $account, FieldItemListInterface $items = NULL) {
    $result = parent::checkFieldAccess($operation, $field_definition, $account, $items);
    if (!$result) {
      return $result;
    }
    if ($operation !== 'view') {
      $bundle_id = $field_definition->getTargetBundle();
      if ($bundle_id) {
        $bundle = $this->entityManager->getStorage($this->entityType->getBundleEntityType())->load($bundle_id);
        if ($bundle->isReadOnly()) {
          $result = FALSE;
        }
      }
    }
    return $result;
  }
}
