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
      '#theme' => 'add_partner',
      '#attached' => [
        'library' => [
          'db_admin/add_partner'
        ],
      ],
    ];
  }

  public static function fundingOrganizations() {
    return [
      '#theme' => 'add_funding_organization',
      '#attached' => [
        'library' => [
          'db_admin/add_funding_organization'
        ],
      ],
    ];
  }
}
