<?php

/**
 * @file
 * Contains \Drupal\db_map\Controller\MapController.
 */

namespace Drupal\db_map\Controller;

use Drupal;
use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;

/**
 * Controller routines for db_map routes.
 */
class MapController extends ControllerBase {
  const FUNDING_FIELD_MAP = [
    'project_funding_details' => [
      'Title' => 'project_title',
      'piName' => 'pi_name',
      'ORC_ID' => 'pi_orcid',
      'IsPrincipalInvestigator' => 'is_pi',
      'Institution' => 'institution',
      'City' => 'city',
      'State' => 'state',
      'Country' => 'country',
      'Latitude' => 'lat',
      'Longitude' => 'long',
      'Region' => 'region',
      'Category' => 'award_type',
      'AltAwardCode' => 'alt_award_code',
      'FundingOrg' => 'funding_organization',
      'BudgetStartDate' => 'budget_start_date',
      'BudgetEndDate' => 'budget_end_date',
      'Amount' => 'funding_amount',
      'TechAbstract' => 'technical_abstract',
      'PublicAbstract' => 'public_abstract',
      'Source_ID' => 'source_id',
      'currency' => 'currency',
      'MechanismCode' => 'mechanism_code',
      'MechanismTitle' => 'mechanism_title',
      'FundingMechanism' => 'funding_mechanism',
      'FundingContact' => 'funding_contact',
    ],
  ];

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


  /**
   * Creates a new JSON response with CORS headers
   *
   * @param any $data
   * @return JSONResponse
   */
  private static function createResponse($data): JsonResponse {
    return JsonResponse::create(
      $data,
      (is_array($data) && isset($data['ERROR'])) ? 400 : 200, [
      'Access-Control-Allow-Headers' => 'origin, content-type, accept',
      'Access-Control-Allow-Origin'  => '*',
      'Access-Control-Allow-Methods' => 'GET, POST',
    // ensure that the response contains formatted json
    ])->setEncodingOptions((new JsonResponse())->getEncodingOptions() | JSON_PRETTY_PRINT);
  }


  /**
   * Returns the Drupal render array for the index page for this module
   *
   * @return array
   */
  public static function getContent(): array {
    $results = self::get_map_layers('icrp_database');
    return [
      '#theme' => 'db_map',
      '#api_key' => \Drupal::config('google-maps')->get('api-key'),
      '#layers' => $results,
      '#attached' => [
        'library' => [
          'db_map/default'
        ],
        ## https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21Render%21HtmlResponseAttachmentsProcessor.php/function/HtmlResponseAttachmentsProcessor%3A%3AprocessAttachments/
        'http_header' => [
          ['Cache-Control', 'no-cache, max-age=0, must-revalidate, no-store'],
          ['custom-header', 'browser-specific-string'],
        ],
      ],
    ];
  }


  public static function getPeopleMap($funding_id): array {
    \Drupal::service('page_cache_kill_switch')->trigger();
    $results = self::get_funding($funding_id, 'icrp_database');
    $layers = self::get_map_layers('icrp_database');
    return [
      '#theme' => 'db_people_map',
      '#api_key' => \Drupal::config('google-maps')->get('api-key'),
      '#funding_details' => $results['project_funding_details'],
      '#layers' => $layers,
      '#pi_count' => $results['pi_count'],
      '#funding_id' => $funding_id,
      '#attached' => [
        'library' => [
          'db_map/map.people'
        ],
      ],
    ];
  }


  public static function getLayers(): array {
    $results = self::get_map_layers('icrp_database');
    return [
      '#theme' => 'db_layer_map',
      '#api_key' => \Drupal::config('google-maps')->get('api-key'),
      '#layers' => $results,
      '#attached' => [
        'library' => [
          'db_map/map.layer'
        ],
      ],
    ];
  }


  public function getLayerMap($layer_id): JsonResponse {
    $map_layer_legend = self::get_map_layer_legend($layer_id,'icrp_database');
    $map_layer_country = self::get_map_layer_by_country($layer_id,'icrp_database');
    return new JsonResponse(array(
      'legend' => $map_layer_legend,
      'country' => $map_layer_country
    ));
  }


  /**
   * Retrieves all locations for the given search id.
   *
   * @param Request $request A GET request that contains the searchId parameter
   * @return JSONReponse
   */
  public static function getLocations(Request $request): JSONResponse {
    $connection = PDOBuilder::getConnection('icrp_database');
    $parameters = self::array_merge_intersection(
      $request->query->all(),
      [
        'searchId' => 0,
        'type' => 'regions',
        'region' => 1,
        'country' => '',
        'state' => '',
        'city' => '',
      ]
    );
    $data = MappingTool::getLocations($connection, $parameters);
    return self::createResponse($data);
  }


  /**
   * Retrieves search parameters for the given search id
   *
   * @param Request $request A GET request that contains the searchId parameter
   * @return JSONResponse
   */
  public static function getSearchParameters(Request $request): JSONResponse {
    $connection = PDOBuilder::getConnection('icrp_database');
    $parameters = self::array_merge_intersection($request->query->all(), ['searchId' => 0]);
    $data = MappingTool::getSearchParameters($connection, $parameters);
    return self::createResponse($data);
  }


  /**
   * Retrieves search parameters for the given search id
   *
   * @param Request $request A GET request that contains the following parameters:
   *  searchId - the original search id from the database search page (or 0, if we have )
   * @return JSONResponse
   */
  public static function getNewSearchId(Request $request): JSONResponse {
    $connection = PDOBuilder::getConnection('icrp_database');
    $parameters = self::array_merge_intersection($request->query->all(), [
      'searchId' => 0,
      'region' => NULL,
      'country' => NULL,
      'city' => NULL,
      'institution' => NULL,
    ]);
    $data = MappingTool::getNewSearchId($connection, $parameters);
    return self::createResponse($data);
  }


  public static function get_map_layers($config_key = 'icrp_database') {
    $connection = PDOBuilder::getConnection('icrp_database');

    $stmt = $connection->prepare("EXECUTE GetMapLayers");
    $stmt->execute();
    return $stmt->fetchAll();
  }


  public function get_map_layer_legend($layer_id,$config_key = 'icrp_database') {
    $connection = PDOBuilder::getConnection('icrp_database');

    $stmt = $connection->prepare("EXECUTE GetMapLayerLegend :layer_id");
    $stmt->execute([':layer_id' => $layer_id]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
  }


  public function get_map_layer_by_country($layer_id,$config_key = 'icrp_database') {
    $connection = PDOBuilder::getConnection('icrp_database');

    $stmt = $connection->prepare("EXECUTE GetMapLayerByCountry :layer_id");
    $stmt->execute([':layer_id' => $layer_id]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
  }


  public static function get_funding($funding_id, $config_key = 'icrp_database') {
    $connection = PDOBuilder::getConnection('icrp_database');

    $queries = [
      'project_funding_details' => 'GetProjectFundingDetail :funding_id',
    ];

    // map queries to return values
    $results = array_reduce(
      array_map(function($key, $value) use ($connection, $funding_id) {
        $stmt = $connection->prepare($value);
        $stmt->execute([':funding_id' => $funding_id]);
        // map the result of each query to each template key
        return [$key => array_map(function($row) use ($key) {

          // map each field in the row to a template variable
          return array_reduce(
            array_map(function($row_key, $row_value) use ($key) {
                return [self::FUNDING_FIELD_MAP[$key][$row_key] => $row_value];
            }, array_keys($row), $row)
          , 'array_merge', []);
        }, $stmt->fetchAll(PDO::FETCH_ASSOC))];
      }, array_keys($queries), $queries),
    'array_merge', []);
    $results['pi_count'] = count(array_filter($results['project_funding_details'], function($detail) {
      return $detail['is_pi'] > 0;
    }));
    return $results;
  }


  /**
   * Creates an arbitrary excel report based on the supplied json object.
   *
   * For example:
   * [
   *    {title: 'Sheet one', rows: ['A', 'B', 'C']},
   *    {title: 'Sheet two', rows: ['D', 'E', 'F']},
   * ];
   *
   * @param Request $request Contains a json body that will be converted to an excel document
   * @return JSONResponse
   */
  public static function getExcelExport(Request $request, string $prefix): JSONResponse {
    $sheets = json_decode($request->getContent(), true);
    $filename = sprintf("%s_%s.xlsx", $prefix, uniqid());
    $uri = ExcelBuilder::create($filename, $sheets);
    return self::createResponse($uri);
  }
}