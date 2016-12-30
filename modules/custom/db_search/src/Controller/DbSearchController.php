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
      '#markup' => t('<icrp-root>Loading...</icrp-root>'),
      '#attached' => array(
        'library' => array(
          'db_search/custom'
        ),
      ),
    );
  }
}