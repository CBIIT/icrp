<?php

/**
 * @file
 * Contains \Drupal\db_search_api\Controller\DatabaseSearchAPIController.
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
class DatabaseSearchAPIController extends ControllerBase {

  private static $connection_ini = "connection.ini";

  private static $parameter_mappings = array(
    'page_size' => 'PageSize',
    'page_number' => 'PageNumber',
    'sort_column' => 'SortCol',
    'sort_type' => 'SortDirection',
    'search_terms' => 'terms',
    'search_type' => 'termSearchType',
    'years' => NULL,
    'institution' => 'institution',
    'pi_first_name' => 'piFirstName',
    'pi_last_name' => 'piLastName',
    'pi_orcid' => 'piORCiD' ,
    'award_code' => 'awardCode',
    'countries' => 'countryList',
    'states' => 'stateList',
    'cities' => 'cityList',
    'funding_organizations' => 'fundingOrgList',
    'cancer_types' => 'cancerTypeList',
    'project_types' => 'projectTypeList',
    'cso_codes' => 'CSOList'
  );

  private static $sort_column_mappings = array(
    'project_title' => 'title',
    'pi_name' => 'pi',
    'institution' => 'Inst',
    'city' => '',
    'state' => '',
    'country' => '',
    'funding_organization' => 'FO',
    'award_code' => 'code'
  );


  /**
   * Returns a PDO connection to a database
   * @param $cfg - An associative array containing connection parameters 
   *   driver:    DB Driver
   *   server:    Server Name
   *   database:  Database
   *   user:      Username
   *   password:  Password
   *
   * @return A PDO connection
   * @throws PDOException
   */
  function get_connection() {

    $cfg = parse_ini_file(self::$connection_ini);

    // connection string
    $cfg['dsn'] =
      $cfg['driver'] .
      ":Server="    . $cfg['server'] . ',' . $cfg['port'] .
      ";Database="  . $cfg['database'];

    // default configuration options
    $cfg['opt'] = [
      PDO::SQLSRV_ATTR_ENCODING    => PDO::SQLSRV_ENCODING_UTF8,
      PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
      PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
  //  PDO::ATTR_EMULATE_PREPARES   => false,
    ];

    // create new PDO object
    return new PDO(
      $cfg['dsn'],
      $cfg['username'],
      $cfg['password'],
      $cfg['opt']
    );
  }

  /**
  * Creates a PDO prepared statement for searching projects
  * @param $pdo - The PDO connection oject
  * @param $parameters - An associative array containing 
  * parameters to bind to the statement (from parse_input())
  */
  function create_prepared_statement($pdo, $parameters) {
    $stmt_conditions = array();
    $stmt_parameters = array();

    foreach (array_keys($parameters) as $key) {
      $query_key = ":".$key;
      $param_key = "@".$key;

      $stmt_parameters[$query_key] = $parameters[$key];
      array_push($stmt_conditions, $param_key."=".$query_key);
    }

    $stmt = $pdo->prepare("SET NOCOUNT ON; EXECUTE GetProjects " . implode(",", $stmt_conditions));
    self::bind_parameters($stmt, $stmt_parameters);

    return $stmt;
  }

  /**
  * Binds parameters to a PDO prepared statement
  * @param $stmt - The PDO prepared statement to modify
  * @param $param - An associative array containing 
  * parameters to bind to the statement
  */
  function bind_parameters($stmt, $param) {
    
   foreach (array_keys($param) as $key) {

      // convert sort_column using mappings
      if ($key == ":".self::$parameter_mappings['sort_column']) {
        $value = self::$sort_column_mappings[$param[$key]];
        $stmt->bindParam($key, $value);
      } else {
        $stmt->bindParam($key, $param[$key]);
      }
    }
  }
  
  /**
  * Queries the database for projects
  * @param $parameters - An associative array of parameters
  */
  function search_database($parameters) {
    $pdo = self::get_connection();
    $stmt = self::create_prepared_statement($pdo, $parameters);
    if ($stmt->execute()) {
      $rows = array();
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {

        $result = array(
          'project_id' => $row['ProjectID'],
          'project_title' => $row['Title'],
          'pi_name' => $row['piLastName'].", ".$row['piFirstName'],
          'institution' => $row['institution'],
          'city' => $row['City'],
          'state' => $row['State'],
          'country' => $row['country'],
          'funding_organization' => $row['FundingOrg'],
          'award_code' => $row['AwardCode']
        );

        array_push($rows, $result);
      }

      return $rows;
    }

    return array("No results found");
  }

  /**
  * Aggregates unique values from each column
  * @param $parameters - An associative array containing 
  * search parameters  (from parse_input())
  */
  function count_database_groups($parameters) {
    $pdo = self::get_connection();

    $groups = array(
      'count' => 0,
      'projects_by_country' => array(),
      'projects_by_cso_category' => array(),
      'projects_by_cancer_type' => array(),
      'projects_by_type' => array()
    );

    foreach (array('PageSize', 'PageNumber', 'SortCol', 'SortDirection') as $key) {
      if (isset($parameters[$key])) {
        unset($parameters[$key]);
      }
    }

    $stmt = self::create_prepared_statement($pdo, $parameters);
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {

        $country = $row['country'];
        $cso_category = $row['CSOCode'][0];
        $cancer_type = $row['CancerType'];
        $project_type = $row['ProjectType'];

        if (!isset($groups['projects_by_country'][$country])) {
          $groups['projects_by_country'][$country] = 0;
        }

        if (!isset($groups['projects_by_cso_category'][$cso_category])) {
          $groups['projects_by_cso_category'][$cso_category] = 0;
        }

        if (!isset($groups['projects_by_cancer_type'][$cancer_type])) {
          $groups['projects_by_cancer_type'][$cancer_type] = 0;
        }

        if (!isset($groups['projects_by_type'][$project_type])) {
          $groups['projects_by_type'][$project_type] = 0;
        }

        $groups['projects_by_country'][$country]++;
        $groups['projects_by_cso_category'][$cso_category]++;
        $groups['projects_by_cancer_type'][$cancer_type]++;
        $groups['projects_by_type'][$project_type]++;
        $groups['count']++;
      }
    }

    arsort($groups['projects_by_country']);
    arsort($groups['projects_by_cso_category']);
    arsort($groups['projects_by_cancer_type']);
    arsort($groups['projects_by_type']);

    return $groups;
  }



  /**
  * Adds CORS Headers to a response
  */
  public function add_cors_headers($response) {
    $response->headers->set('Access-Control-Allow-Headers', 'origin, content-type, accept');
    $response->headers->set('Access-Control-Allow-Origin', '*');
    $response->headers->set('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, PATCH, OPTIONS');

    return $response;
  }

  /**
  * Extracts valid fields from a request object
  * and maps them to sql parameters
  */
  public function get_fields(Request $request) {
    $fields = array();
    foreach(array(
      'page_size',
      'page_number',
      'sort_column',
      'sort_type',
      'search_terms',
      'search_type',
      'year',
      'institution',
      'pi_first_name',
      'pi_last_name',
      'pi_orcid',
      'award_code',
      'countries',
      'states',
      'cities',
      'funding_organizations',
      'cancer_types',
      'project_types',
      'cso_codes'
    ) as $field) {
      $value = $request->query->get($field);
      if ($value) {

        // retrieve the mapped field value
        $mapped_field = self::$parameter_mappings[$field];
        
        // apply mapping to values in sort_column
        if ($field == 'sort_column') {
            $mapped_value = self::$sort_column_mappings[$value];
            if ($mapped_value) {
                $fields[$mapped_field] = $mapped_value;
            }
        }

        // do not modify values in other fields
        elseif ($mapped_field) {
            $fields[$mapped_field] = $value;
        }
      }
    }

    return $fields;
  }

  /**
   * Callback for `db/public/search/` API method.
   */
  public function public_search( Request $request ) {
    $param = self::get_fields($request);
    $response = new JSONResponse( self::search_database($param) );
    return self::add_cors_headers($response);
  }

  /**
   * Callback for `db/public/analytics/` API method.
   */
  public function public_analytics( Request $request ) {
    $param = self::get_fields($request);
    $response = new JSONResponse( self::count_database_groups($param) );
    return self::add_cors_headers($response);
  }

  /**
   * Callback for `db/partner/search/` API method.
   */
  public function partner_search( Request $request ) {
    $param = self::get_fields($request);
    $response = new JSONResponse( self::search_database($param) );
    return self::add_cors_headers($response);
  }

  /**
   * Callback for `db/partner/analytics/` API method.
   */
  public function partner_analytics( Request $request, $type ) {
    $param = self::get_fields($request);
    $response = new JSONResponse( self::count_database_groups($param) );
    return self::add_cors_headers($response);
  }
}
