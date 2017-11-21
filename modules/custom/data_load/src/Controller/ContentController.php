<?php

namespace Drupal\data_load\Controller;

class ContentController {

  /**
   * Returns a render array for the "Data Load Tool" page
   *
   * @return array
   */
  public static function dataLoad(): array {
    return [
      '#theme' => 'data_load',
      '#attached' => [
        'library' => [
          'data_load/resources'
        ],
      ],
    ];
  }


  /**
   * Returns a render array for the "Import Collaborators" page
   *
   * @return array
   */
  public static function importCollaborators(): array {
    return [
      '#theme' => 'import_collaborators',
      '#attached' => [
        'library'   => [
          'data_load/import_collaborators'
        ],
      ],
    ];
  }

  /**
   * Returns a render array for the "Import Institutions" page
   *
   * @return array
   */
  public static function importInstitutions(): array {
    return [
      '#theme' => 'import_institutions',
      '#attached' => [
        'library'   => [
          'data_load/import_institutions'
        ],
      ],
    ];
  }
}