<?php

namespace Drupal\feeds\Access;

use Drupal\Core\Access\AccessResult;
use Drupal\Core\Entity\EntityManagerInterface;
use Drupal\Core\Routing\Access\AccessInterface;
use Drupal\Core\Session\AccountInterface;

/**
 * Access check for feeds link add list routes.
 */
class FeedAddAccessCheck implements AccessInterface {

  /**
   * The entity manager.
   *
   * @var \Drupal\Core\Entity\EntityManagerInterface
   */
  protected $entityManager;

  /**
   * Constructs a FeedAddAccessCheck object.
   *
   * @param \Drupal\Core\Entity\EntityManagerInterface $entity_manager
   *   The entity manager.
   */
  public function __construct(EntityManagerInterface $entity_manager) {
    $this->entityManager = $entity_manager;
  }

  /**
   * {@inheritdoc}
   */
  public function access(AccountInterface $account) {
    // @todo Perhaps read config directly rather than load all feed types.
    $access_control_handler = $this->entityManager->getAccessControlHandler('feeds_feed');

    foreach ($this->entityManager->getStorage('feeds_feed_type')->loadByProperties(['status' => TRUE]) as $feed_type) {
      $access = $access_control_handler->createAccess($feed_type->id(), $account, [], TRUE);
      if ($access->isAllowed()) {
        return $access;
      }
    }

    return AccessResult::neutral();
  }

}
