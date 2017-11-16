<?php

namespace Drupal\data_load\Controller;

class ContentController {

  /**
   * Returns a render array for the "Import Collaborators" page
   *
   * @return array
   */
  public static function addCollaborators(): array {
    return [
      '#theme' => 'add_collaborators',
      '#attached' => [
        'library'   => [
          'data_load/add_institutions'
        ],
      ],
    ];
  }

  /**
   * Returns a render array for the "Add Institutions" page
   *
   * @return array
   */
  public static function addInstitutions(): array {
    return [
      '#theme' => 'add_institutions',
      '#attached' => [
        'library'   => [
          'data_load/add_institutions'
        ],
      ],
    ];
  }
}