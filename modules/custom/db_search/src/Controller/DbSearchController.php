<?php
/**
 * @file
 * Contains \Drupal\db_search\Controller\DbSearchController.
 */
namespace Drupal\db_search\Controller;
class DbSearchController {
  public function content() {
    return array(
      '#type' => 'markup',
      '#markup' => t('<app-root>Loading...</app-root>'),
      '#attached' => array(
        'library' => array(
          'db_search/custom'
        ),
      ),
    );
  }
}