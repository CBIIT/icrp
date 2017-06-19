<?php

/**
 * @file
 * Contains \Drupal\db_admin\Controller\ContentController.
 */

namespace Drupal\db_admin\Controller;

use Drupal;
use Drupal\Core\Controller\ControllerBase;


/**
 * Controller routines for db_admin pages.
 */
class ContentController extends ControllerBase {
  public static function addPartnerPage() {
    return [
      '#theme' => 'add_partner',
      '#attached' => [
        'library' => [
          'db_admin/add_partner'
        ],
      ],
    ];
  }

  public static function addFundingOrganizationPage() {
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

