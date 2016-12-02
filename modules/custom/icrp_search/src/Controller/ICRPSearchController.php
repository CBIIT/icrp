<?php

/**
 * @file
 * Contains \Drupal\icrp_search\Controller\ICRPSearchController.
 */

namespace Drupal\icrp_search\Controller;

use Drupal\Core\Controller\ControllerBase;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;

/**
 * Controller routines for icrp_search routes.
 */
class ICRPSearchController extends ControllerBase {

  /**
   * Callback for `icrpsearchREST/search` API method.
   */
  public function search( Request $request ) {
    $config = $this->config('icrp_search.settings');

    $response['data'] = $request->getQueryString();
    $response['config'] = $config->get('icrp_search_hostname');

    return new JsonResponse( $response );
  }


  /**
   * Callback for `icrpsearchREST/post.json` API method.
   */
  public function post_example( Request $request ) {

    // This condition checks the `Content-type` and makes sure to 
    // decode JSON string from the request body into array.
    if ( 0 === strpos( $request->headers->get( 'Content-Type' ), 'application/json' ) ) {
      $data = json_decode( $request->getContent(), TRUE );
      $request->request->replace( is_array( $data ) ? $data : [] );
    }

    $response['data'] = 'Some test data to return';
    $response['method'] = 'POST';

    return new JsonResponse( $response );
  }

  /**
   * Returns markup for our custom page just for testing purpose.
   */
  public function customPage() {
    return [
    '#markup' => t('Welcome to ICRP Search RESTFul API cutom page!'),
    ];
  }
}
