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
      '#markup' => t('<h1>Search ICRP Database</h1>
        <div class="form-group">
This search page features a variety of criteria to allow the user to access and manipulate the data contained in the ICRP database. Users should be aware that data contained in the ICRP database is updated throughout the year, and due to differing data upload schedules, recent years may not yet include all partner and associate organizations’ data. <a _ngcontent-ory-45="" href="/contact-us?type-of-issue=Data Issue" target="_blank">Contact us</a> if you have any questions.
        </div>
        <icrp-root data-component-type="search">Loading...</icrp-root>'),
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
      '#markup' => t('<h1>Data Review Tool</h1><icrp-root data-component-type="review">Loading...</icrp-root>'),
      '#attached' => array(
        'library' => array(
          'db_search/custom'
        ),
      ),
    );
  }

  public function authenticate() {
    return new Response('authenticated');
  }
}