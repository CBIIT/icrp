<?php

/**
 * @file
 * Contains \Drupal\db_search_api\Controller\DatabaseSearchAPIController.
 */

namespace Drupal\db_search_api\Controller;
use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Database\Database;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;

/**
 * Controller routines for db_search_api routes.
 */
class SearchController extends ControllerBase {

  const DEFAULT_DATA_UPLOAD_REVIEW_PARAMETERS = [
    'data_upload_id'             => NULL,
    'page_size'                  => 50,
    'page_number'                => 1,
    'sort_column'                => 'project_title',
    'sort_direction'             => 'asc',
  ];

  const DEFAULT_SORT_PAGINATE_PARAMETERS = [
    'search_id'                  => NULL,
    'page_size'                  => 50,
    'page_number'                => 1,
    'sort_column'                => 'project_title',
    'sort_direction'             => 'asc',
  ];

  const DEFAULT_SEARCH_PARAMETERS = [
    'page_size'                  => 50,
    'page_number'                => 1,
    'sort_column'                => 'project_title',
    'sort_direction'             => 'asc',
    'search_terms'               => NULL,
    'search_type'                => NULL,
    'years'                      => NULL,
    'institution'                => NULL,
    'pi_first_name'              => NULL,
    'pi_last_name'               => NULL,
    'pi_orcid'                   => NULL,
    'award_code'                 => NULL,
    'countries'                  => NULL,
    'states'                     => NULL,
    'cities'                     => NULL,
    'funding_organization_types' => NULL,
    'funding_organizations'      => NULL,
    'cancer_types'               => NULL,
    'project_types'              => NULL,
    'is_childhood_cancer'        => NULL,
    'cso_research_areas'         => NULL,
  ];

  const PUBLIC_ANALYTICS_TYPES = [
    'project_counts_by_country',
    'project_counts_by_cso_research_area',
    'project_counts_by_cancer_type',
    'project_counts_by_type',
  ];

  const PARTNER_ANALYTICS_TYPES = [
    'project_counts_by_country',
    'project_counts_by_cso_research_area',
    'project_counts_by_cancer_type',
    'project_counts_by_type',
    'project_funding_amounts_by_year',
  ];

  private static function createResponse($data) {
    $response = JsonResponse::create($data, 200, [
      'Access-Control-Allow-Headers' => 'origin, content-type, accept',
      'Access-Control-Allow-Origin'  => '*',
      'Access-Control-Allow-Methods' => 'GET',
    ]);

    $response->setEncodingOptions($response->getEncodingOptions() | JSON_PRETTY_PRINT);

    return $response;
  }


  /**
   * The last parameter is the array containing the set of default keys that will be replaced
   */
  private static function array_merge_intersection(...$arrays) {
    $source = end($arrays);
    $intersection = array_intersect_key(...$arrays);
    return array_merge($source, $intersection);
  }

  /**
   * Returns a PDO connection to a database
   * @param string $database - The drupal configuration key for the database to query
   * @return PDO A PDO connection
   * @throws PDOException
   * @api
   */
  public static function getConnection(string $database = 'icrp_database'): PDO {

    /**
     * Drupal configuration object for the specified database
     *
     * Contains the following keys:
     * - driver (Database driver)
     * - host (Database host)
     * - port (Host port)
     * - database (Database)
     * - username (Username)
     * - password (Password)
     * @var string[]
     */
    $cfg = \Drupal::config($database)->get();

    return new PDO(
      vsprintf('%s:Server=%s,%s;Database=%s', [
        $cfg['driver'],
        $cfg['host'],
        $cfg['port'],
        $cfg['database'],
      ]),
      $cfg['username'],
      $cfg['password'],
      [
        PDO::SQLSRV_ATTR_ENCODING    => PDO::SQLSRV_ENCODING_UTF8,
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
//      PDO::ATTR_ERRMODE            => PDO::ERRMODE_SILENT,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
      ]
    );
  }


  ## Routes for Database Search Tool

  public static function getFields() {
    $data = DatabaseSearch::getSearchFields(self::getConnection());
    return self::createResponse($data);
  }

  public static function getSearchResults(Request $request) {
    $parameters = self::array_merge_intersection($request->query->all(), self::DEFAULT_SEARCH_PARAMETERS);
    $data = DatabaseSearch::getSearchResults(self::getConnection(), $parameters);
    return self::createResponse($data);
  }


  public static function getSortedPaginatedResults(Request $request) {
    $parameters = self::array_merge_intersection($request->query->all(), self::DEFAULT_SORT_PAGINATE_PARAMETERS);
    $data = DatabaseSearch::getSortedPaginatedResults(self::getConnection(), $parameters);
    //return self::createResponse($parameters);
    return self::createResponse($data);
  }


  public static function getAnalytics(Request $request) {
    $parameters = $request->query->all();
    $data = in_array($parameters['type'], self::PUBLIC_ANALYTICS_TYPES)
      ? DatabaseSearch::getAnalytics(self::getConnection(), $parameters)
      : [];

    return self::createResponse($data);
  }


  public static function getAnalyticsForPartners(Request $request) {
        $parameters = $request->query->all();

    $data = in_array($parameters['type'], self::PARTNER_ANALYTICS_TYPES)
      ? DatabaseSearch::getAnalytics(self::getConnection(), $parameters)
      : [];

    return self::createResponse($data);
  }


  public static function getSearchParameters(Request $request) {
    $connection = self::getConnection('icrp_database');
    $parameters = self::array_merge_intersection($request->query->all(), ['search_id' => -1]);
    $data = DatabaseSearch::getSearchParameters($connection, $parameters);
    return self::createResponse($data);
  }



  ## Routes for Data Upload Review Tool
  public static function reviewFields() {
    $connection = self::getConnection('icrp_load_database');
    $data = DatabaseReview::reviewFields($connection);
    return self::createResponse($data);
  }


  public static function reviewAnalytics(Request $request) {
    $connection = self::getConnection('icrp_load_database');
    $parameters = $request->query->all();

    if ($parameters['type'] === 'project_funding_amounts_by_year' 
        && !array_key_exists('year', $parameters)) {
      
      $year = DatabaseReview::reviewFields($connection)['conversion_years'][0]['value'];
      $parameters['years'] = DatabaseReview::reviewFields($connection);
    }

    $data = in_array($parameters['type'], self::PARTNER_ANALYTICS_TYPES)
      ? DatabaseSearch::getAnalytics($connection, $parameters)
      : [];

    return self::createResponse($data);
  }


  public static function reviewSearchResults(Request $request) {
    $connection = self::getConnection('icrp_load_database');
    $parameters = self::array_merge_intersection($request->query->all(), self::DEFAULT_DATA_UPLOAD_REVIEW_PARAMETERS);
    $data = DatabaseReview::reviewSearchResults($connection, $parameters);
    return self::createResponse($data);
  }


  public static function reviewSponsorUploads(Request $request) {
    $connection = self::getConnection('icrp_load_database');
    $data = DatabaseReview::reviewSponsorUploads($connection);
    return self::createResponse($data);
  }
}

