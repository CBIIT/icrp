<?php

/**
 * @file
 * Contains \Drupal\external_entities\ExternalEntityPermissions.
 */

namespace Drupal\external_entities;

use Drupal\Core\Routing\UrlGeneratorTrait;
use Drupal\Core\StringTranslation\StringTranslationTrait;
use Drupal\external_entities\Entity\ExternalEntityType;

/**
 * Defines a class containing permission callbacks.
 */
class ExternalEntityPermissions {

  use StringTranslationTrait;
  use UrlGeneratorTrait;

  /**
   * Gets an array of external entity type permissions.
   *
   * @return array
   *   The external entity type permissions.
   *   @see \Drupal\user\PermissionHandlerInterface::getPermissions()
   */
  public function ExternalEntityTypePermissions() {
    $perms = array();
    // Generate node permissions for all node types.
    foreach (ExternalEntityType::loadMultiple() as $type) {
      $perms += $this->buildPermissions($type);
    }

    return $perms;
  }

  /**
   * Builds a standard list of external entity permissions for a given type.
   *
   * @param \Drupal\external_entities\Entity\ExternalEntityType $type
   *   The machine name of the external entity type.
   *
   * @return array
   *   An array of permission names and descriptions.
   */
  protected function buildPermissions(ExternalEntityType $type) {
    $type_id = $type->id();
    $type_params = array('%type_name' => $type->label());

    return array(
      "view $type_id external entity" => array(
        'title' => $this->t('%type_name: View any external entity', $type_params),
      ),
      "create $type_id external entity" => array(
        'title' => $this->t('%type_name: Create new external entity', $type_params),
      ),
      "edit $type_id external entity" => array(
        'title' => $this->t('%type_name: Edit any external entity', $type_params),
      ),
      "delete $type_id external entity" => array(
        'title' => $this->t('%type_name: Delete any external entity', $type_params),
      ),
    );
  }

}
