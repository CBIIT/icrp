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

}
