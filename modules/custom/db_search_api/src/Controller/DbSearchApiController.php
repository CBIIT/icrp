<?php

/**
 * @file
 * Contains \Drupal\db_search_api\Controller\DbSearchAPIController.
 */

namespace Drupal\db_search_api\Controller;

use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Database\Database;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;

/**
 * Controller routines for db_search_api routes.
 */
class DbSearchApiController extends ControllerBase {


  /**
  * Adds CORS Headers to a response
  */
  public function addCorsHeaders($response) {
    $response->headers->set('Access-Control-Allow-Headers', 'origin, content-type, accept');
    $response->headers->set('Access-Control-Allow-Origin', '*');
    $response->headers->set('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, PATCH, OPTIONS');

    return $response;
  }


  /**
  * Extracts valid fields from a request object 
  */
  public function getFields(Request $request) {

    $fields = array();
    foreach(array(
      'project_title',
      'institution',
      'pi_last_name',
      'pi_first_name',
      'pi_orcid',
      'award_code',
      'country',
      'state',
      'city',
      'funding_organization_id',
      'cancer_type_id',
      'project_type',
      'cso_code',
      'page_size',
      'page_offset',
      'order_by',
      'order_type'
    ) as $field) {
      $fields[$field] = $request->query->get($field);
    }

    return $fields;
  }

  /**
  * Creates a query from parameters
  * By default, selects columns that will appear in the projects results table
  */
  public function createQuery(
    $param, 
    $columns = array(
      'project_id',
      'project_title',
      'pi_name',
      'institution',
      'city',
      'state',
      'country',
      'funding_organization',
      'award_code'
    )) {

    $connection = Database::getConnection('default', 'projects');

    $results = array();
    $fields = array();
    foreach(array(
      'project_title',
      'institution',
      'pi_last_name',
      'pi_first_name',
      'pi_orcid',
      'award_code',
      'country',
      'state',
      'city',
      'funding_organization_id',
      'cancer_type_id',
      'project_type',
      'cso_code'
    ) as $field) {
      if (isset($param[$field])) {
        $fields[$field] = $param[$field];
      }
    }

    $query = $connection
      ->select('ProjectSearch', 'ps')
      ->distinct()
      ->fields('ps', $columns);
    

    foreach(array_keys($fields) as $key) {
      $query->condition($key, '%' . $fields[$key] . '%', 'like');
    }

    return $query;
  }

  /**
  * Counts the total number of results from a search
  */
  public function countResults($param) {
    return self::createQuery($param, array('project_id'))
      ->countQuery()
      ->__toString();
//      ->execute()
//      ->fetch();
  }

  public function groupResults($param, $group) {
    return self::createQuery($param)
      ->addExpression('count')
      ->execute()
      ->fetch();
  }

  public function searchDatabase($param) {

    $query = self::createQuery($param);

    if (isset($param['order_by']) && isset($param['order_type'])) {
      $query->orderBy($param['order_by'], $param['order_type']);
    }

    if ( isset($param['page_offset']) && isset($param['page_size']) ) {
      $query->range($param['page_offset'], $param['page_size']);
    }

    else {
      $query->range(0, 50);
    }

    return $query->execute()->fetchAll(PDO::FETCH_ASSOC);
  }

  /**
   * Callback for `db/public/search/` API method.
   */
  public function publicSearch( Request $request ) {
    $param = self::getFields($request);
    $response = new JSONResponse( self::searchDatabase($param) );
    return self::addCorsHeaders($response);
  }

  /**
   * Callback for `db/public/analytics/` API method.
   */
  public function publicAnalytics( Request $request, $type ) {

    $param = self::getFields($request);
    $response = array();

    if ($type === 'count') {
      $response = new JSONResponse( self::countResults($param) );
    }

    else if (in_array(
      $type, 
      array(
        'institution',
        'country',
        'funding_organization_id',
        'cancer_type_id',
        'project_type',
        'cso_code')
    )) {
      $response = new JSONResponse( self::groupResults($param, $type) );
    }

    return self::addCorsHeaders($response);
  }


  /**
   * Callback for `db/partner/search/` API method.
   */
  public function partnerSearch( Request $request ) {

    $param = self::getFields($request);
    $response = new JSONResponse( self::searchDatabase($param) );
    return self::addCorsHeaders($response);
  }

  /**
   * Callback for `db/partner/analytics/` API method.
   */
  public function partnerAnalytics( Request $request, $type ) {
    $param = self::getFields($request);


    if ($type === 'count') {
      $response = new JSONResponse( self::countResults($param) );
    }

    else if ( in_array($type, array('')) ) {
      $response = new JSONResponse( self::groupResults($param, $type) );
    }

    return self::addCorsHeaders($response);
  }
}
