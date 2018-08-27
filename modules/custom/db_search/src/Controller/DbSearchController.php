<?php
/**
 * @file
 * Contains \Drupal\db_search\Controller\DbSearchController.
 */
namespace Drupal\db_search\Controller;

use Symfony\Component\HttpFoundation\Response;

class DbSearchController {

  public function search_database() {
    return [
      '#theme' => 'search_database',
      '#user_roles' => \Drupal::currentUser()->getRoles(),
      '#attached' => [
        'library' => [
          'db_search/default'
        ],
      ],
    ];
  }

  public function review_database() {
    return [
      '#theme' => 'review_database',
      '#user_roles' => \Drupal::currentUser()->getRoles(),
      '#attached' => [
        'library' => [
          'db_search/default'
        ],
      ],
    ];
  }
}