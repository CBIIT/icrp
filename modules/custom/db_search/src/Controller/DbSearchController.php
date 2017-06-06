<?php
/**
 * @file
 * Contains \Drupal\db_search\Controller\DbSearchController.
 */
namespace Drupal\db_search\Controller;

use Symfony\Component\HttpFoundation\Response;

class DbSearchController {

  public function database_search_content() {
    return [
      '#theme' => 'database_search',
      '#attached' => [
        'library' => [
          'db_search/default'
        ],
      ],
    ];
  }

  public function data_upload_review_content() {
    return [
      '#theme' => 'data_upload_review',
      '#attached' => [
        'library' => [
          'db_search/default'
        ],
      ],
    ];
  }

  public function authenticate() {
    return new Response('authenticated');
  }
}