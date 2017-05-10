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
      '#markup' => t('<icrp-root data-component-type="search"><div loading class="center-overlay" ><div class="loading"></div></div></icrp-root>'),
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
      '#markup' => t('<h1>Data Review Tool</h1><icrp-root data-component-type="review"><div loading class="center-overlay" ><div class="loading"></div></div></icrp-root>'),
      '#attached' => array(
        'library' => array(
          'db_search/default'
        ),
      ),
    );
  }

  public function authenticate() {
    return new Response('authenticated');
  }
}