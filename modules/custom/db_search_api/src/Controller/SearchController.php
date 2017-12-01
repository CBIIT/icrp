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
    'investigator_type'          => NULL,
    'pi_first_name'              => NULL,
    'pi_last_name'               => NULL,
    'pi_orcid'                   => NULL,
    'award_code'                 => NULL,
    'regions'                    => NULL,
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
    'project_counts_by_year',

    'project_funding_amounts_by_country',
    'project_funding_amounts_by_cso_research_area',
    'project_funding_amounts_by_cancer_type',
    'project_funding_amounts_by_type',
    'project_funding_amounts_by_year',
  ];


  /**
   * Creates a new JSON response with CORS headers
   *
   * @param any $data
   * @return JSONResponse
   */
  private static function createResponse($data): JSONResponse {
    $response = JsonResponse::create($data, 200, [
      'Access-Control-Allow-Headers' => 'origin, content-type, accept',
      'Access-Control-Allow-Origin'  => '*',
      'Access-Control-Allow-Methods' => 'GET',
    ]);

    // ensure that the response contains formatted json
    $response->setEncodingOptions($response->getEncodingOptions() | JSON_PRETTY_PRINT);

    return $response;
  }


  /**
   * Merges all arrays from right to left - the last array provided contains the
   * full set of properties that will be present on the merged array
   *
   * @param array ...$arrays
   * @return array
   */
  private static function array_merge_intersection(...$arrays): array {
    $source = end($arrays);
    $intersection = array_intersect_key(...$arrays);
    return array_merge($source, $intersection);
  }


  ## Routes for Database Search Tool
  public static function getFields() {
    $data = DatabaseSearch::getSearchFields(PDOBuilder::getConnection());
    return self::createResponse($data);
  }


  public static function getSearchResults(Request $request) {
    $parameters = self::array_merge_intersection($request->query->all(), self::DEFAULT_SEARCH_PARAMETERS);
    $data = DatabaseSearch::getSearchResults(PDOBuilder::getConnection(), $parameters);
    return self::createResponse($data);
  }


  public static function getSortedPaginatedResults(Request $request) {
    $parameters = self::array_merge_intersection($request->query->all(), self::DEFAULT_SORT_PAGINATE_PARAMETERS);
    $data = DatabaseSearch::getSortedPaginatedResults(PDOBuilder::getConnection(), $parameters);
    return self::createResponse($data);
  }


  public static function getAnalytics(Request $request) {
    $parameters = $request->query->all();

    $data = in_array($parameters['type'], self::PUBLIC_ANALYTICS_TYPES)
      ? DatabaseSearch::getAnalytics(PDOBuilder::getConnection(), $parameters)
      : [];

    return self::createResponse($data);
  }


  public static function getAnalyticsForPartners(Request $request) {
    $parameters = $request->query->all();

    $data = in_array($parameters['type'], self::PARTNER_ANALYTICS_TYPES)
      ? DatabaseSearch::getAnalytics(PDOBuilder::getConnection(), $parameters)
      : [];

    return self::createResponse($data);
  }


  public static function getSearchParameters(Request $request) {
    $connection = PDOBuilder::getConnection('icrp_database');
    $parameters = self::array_merge_intersection($request->query->all(), ['search_id' => -1]);
    $data = DatabaseSearch::getSearchParameters($connection, $parameters);
    return self::createResponse($data);
  }


  public static function getSearchSummary(Request $request) {
    $connection = PDOBuilder::getConnection('icrp_database');
    $parameters = self::array_merge_intersection($request->query->all(), ['search_id' => -1]);
    $data = DatabaseSearch::getSearchSummary($connection, $parameters);
    return self::createResponse($data);
  }


  public static function getCounts(Request $request) {
    $connection = PDOBuilder::getConnection('icrp_database');
    $data = DatabaseMethods::getCounts($connection);
    return self::createResponse($data);
  }


  public static function getExamples(Request $request) {
    $connection = PDOBuilder::getConnection('icrp_database');
    $data = DatabaseMethods::getExamples($connection);
    return self::createResponse($data);
  }


  public static function getCsoExamples(Request $request) {
    $connection = PDOBuilder::getConnection('icrp_database');
    $data = DatabaseMethods::getCsoExamples($connection);
    return self::createResponse($data);
  }




  ## Routes for Data Upload Review Tool
  public static function reviewFields() {
    $connection = PDOBuilder::getConnection('icrp_load_database');
    $data = DatabaseReview::reviewFields($connection);
    return self::createResponse($data);
  }


  public static function reviewAnalytics(Request $request) {
    $connection = PDOBuilder::getConnection('icrp_load_database');
    $parameters = $request->query->all();

    if (!array_key_exists('year', $parameters)) {
      $year = DatabaseReview::reviewFields($connection)['conversion_years'][0]['value'];
      $parameters['year'] = $year;
    }

    $data = in_array($parameters['type'], self::PARTNER_ANALYTICS_TYPES)
      ? DatabaseSearch::getAnalytics($connection, $parameters)
      : [];

    return self::createResponse($data);
  }


  public static function reviewSearchResults(Request $request) {
    $connection = PDOBuilder::getConnection('icrp_load_database');
    $parameters = self::array_merge_intersection($request->query->all(), self::DEFAULT_DATA_UPLOAD_REVIEW_PARAMETERS);
    $data = DatabaseReview::reviewSearchResults($connection, $parameters);
    return self::createResponse($data);
  }


  public static function reviewSponsorUploads(Request $request) {
    $connection = PDOBuilder::getConnection('icrp_load_database');
    $data = DatabaseReview::reviewSponsorUploads($connection);
    return self::createResponse($data);
  }


  public static function reviewSearchSummary(Request $request) {
    $connection = PDOBuilder::getConnection('icrp_load_database');
    $parameters = self::array_merge_intersection($request->query->all(), ['search_id' => -1]);
    $data = DatabaseSearch::getSearchSummary($connection, $parameters);
    return self::createResponse($data);
  }


  public static function reviewSyncProd(Request $request) {
    $connection = PDOBuilder::getConnection('icrp_load_database');
    $parameters = self::array_merge_intersection($request->query->all(), ['data_upload_id' => -1]);
    $data = DatabaseReview::reviewSyncProd($connection, $parameters);
    return self::createResponse($data);
  }
}
