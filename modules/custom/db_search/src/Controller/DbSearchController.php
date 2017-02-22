<?php
/**
 * @file
 * Contains \Drupal\db_search\Controller\DbSearchController.
 */
namespace Drupal\db_search\Controller;

use Symfony\Component\HttpFoundation\Response;


class DbSearchController {

  public function content() {
    return array(
      '#type' => 'markup',
      '#markup' => t('<icrp-root><div loading class="center-overlay" ><div class="loading"></div></div></icrp-root>'),
      '#attached' => array(
        'library' => array(
          'db_search/custom'
        ),
      ),
    );
  }

  public function load_content() {
    return array(
      '#type' => 'markup',
      '#markup' => t('<icrp-root><div loading class="center-overlay" ><div class="loading"></div></div></icrp-root>'),
      '#attached' => array(
        'library' => array(
          'db_search/load'
        ),
      ),
    );
  }

  public function authenticate() {
    return new Response('authenticated');
  }
}