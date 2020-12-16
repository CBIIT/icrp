<?php

/**
 * @file
 * Contains \Drupal\db_admin\Controller\PageController.
 */

namespace Drupal\db_admin\Controller;

use Drupal\Core\Controller\ControllerBase;

/**
 * Controller routines for db_admin pages.
 */
class PageController extends ControllerBase {
  public static function partners() {
    return [
      '#theme' => 'partners',
      '#attached' => [
        'library' => [
          'db_admin/partners'
        ],
      ],
    ];
  }

  public static function fundingOrganizations() {
    return [
      '#theme' => 'funding_organizations',
      '#attached' => [
        'library' => [
          'db_admin/funding_organizations'
        ],
      ],
    ];
  }

  public static function updateOrganizationName() {
    $fields = OrganizationNames::getFields(PDOBuilder::getConnection());
    return [
      '#theme' => 'update_organization_name',
      '#fields' => $fields,
      '#attached' => [
        'drupalSettings' => [
          'db_admin' => [
            'update_organization_name' => [
              'fields' => $fields
            ],
          ],
        ],
        'library' => [
          'db_admin/update_organization_name'
        ],
      ],
    ];
  }  

  public static function institutions() {
    return [
      '#theme' => 'institutions',
      '#attached' => [
        'library' => [
          'db_admin/institutions'
        ],
      ],
    ];
  }

  public static function mergeInstitutions() {
    return [
      '#theme' => 'merge_institutions',
      '#attached' => [
        'library' => [
          'db_admin/merge_institutions'
        ],
      ],
    ];
  }


}
