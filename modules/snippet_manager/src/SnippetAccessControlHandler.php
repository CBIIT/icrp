<?php

namespace Drupal\snippet_manager;

use Drupal\Core\Access\AccessResult;
use Drupal\Core\Entity\EntityAccessControlHandler;
use Drupal\Core\Entity\EntityInterface;
use Drupal\Core\Session\AccountInterface;

/**
 * Snippet access control handler.
 */
class SnippetAccessControlHandler extends EntityAccessControlHandler {

  /**
   * {@inheritdoc}
   */
  public function access(EntityInterface $entity, $operation, AccountInterface $account = NULL, $return_as_object = FALSE) {

    $account = $this->prepareUser($account);

    /** @var \Drupal\snippet_manager\Entity\Snippet $entity */
    if ($operation == 'view-published' && $entity->status() && !$account->hasPermission('administer snippets')) {

      $access = $entity->get('access');

      $access_result = AccessResult::forbidden();
      switch ($access['type']) {
        case 'all':
          $access_result = AccessResult::allowed();
          break;

        case 'permission':
          $access_result = AccessResult::allowedIfHasPermission($account, $access['permission']);
          break;

        case 'role':
          $access_result = AccessResult::allowedIf(array_intersect($access['role'], $account->getRoles()));
          break;
      }

      $access_result->addCacheTags($entity->getCacheTags());

      return $return_as_object ? $access_result : $access_result->isAllowed();
    }

    return parent::access($entity, $operation, $account, $return_as_object);
  }

}
