<?php

/**
 * @file
 * Contains \Drupal\external_entities\Access\ExternalEntityAddAccessCheck.
 */

namespace Drupal\external_entities\Access;

use Drupal\Core\Access\AccessResult;
use Drupal\Core\Entity\EntityManagerInterface;
use Drupal\Core\Routing\Access\AccessInterface;
use Drupal\Core\Session\AccountInterface;
use Drupal\external_entities\ExternalEntityTypeInterface;

/**
 * Determines access to for external entity add pages.
 *
 * @ingroup external_entity_access
 */
class ExternalEntityAddAccessCheck implements AccessInterface {

  /**
   * The entity manager.
   *
   * @var \Drupal\Core\Entity\EntityManagerInterface
   */
  protected $entityManager;

  /**
   * Constructs a EntityCreateAccessCheck object.
   *
   * @param \Drupal\Core\Entity\EntityManagerInterface $entity_manager
   *   The entity manager.
   */
  public function __construct(EntityManagerInterface $entity_manager) {
    $this->entityManager = $entity_manager;
  }

  /**
   * Checks access to the node add page for the node type.
   *
   * @param \Drupal\Core\Session\AccountInterface $account
   *   The currently logged in account.
   * @param \Drupal\external_entities\ExternalEntityTypeInterface $external_entity_type
   *   (optional) The node type. If not specified, access is allowed if there
   *   exists at least one node type for which the user may create a node.
   *
   * @return string
   *   A \Drupal\Core\Access\AccessInterface constant value.
   */
  public function access(AccountInterface $account, ExternalEntityTypeInterface $external_entity_type = NULL) {
    $access_control_handler = $this->entityManager->getAccessControlHandler('external_entity');
    // Checking whether a external entity of a particular type may be created.
    if ($external_entity_type) {
      return $access_control_handler->createAccess($external_entity_type->id(), $account, [], TRUE);
    }

    $types = $this->entityManager->getStorage('external_entity_type')->loadMultiple();
    foreach ($types as $node_type) {
      if (($access = $access_control_handler->createAccess($node_type->id(), $account, [], TRUE)) && $access->isAllowed()) {
        return $access;
      }
    }
    if ($types && $account->hasPermission('administer external entity types')) {
      return AccessResult::allowed()->cachePerPermissions();
    }

    if (!$types) {
      return AccessResult::forbidden();
    }

    // No opinion.
    return AccessResult::neutral();
  }

}
