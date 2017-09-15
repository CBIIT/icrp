<?php

/**
 * @file
 * Contains \Drupal\db_map\Controller\MapController.
 */

namespace Drupal\db_map\Controller;

use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;

/**
 * Controller routines for db_map routes.
 */
class MapController extends ControllerBase {

  /**
   * Creates a new JSON response with CORS headers
   *
   * @param any $data
   * @return JSONResponse
   */
  private static function createResponse($data): JSONResponse {
    $responseCode = isset($data['ERROR']) ? 400 : 200;

    $response = JsonResponse::create($data, $responseCode, [
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


  ## Routes for ICRP Mapping Tool
  public static function getContent() {
    return [
      '#theme' => 'db_map',
      '#attached' => [
        'library' => [
          'db_map/default'
        ],
      ],
    ];
  }

  public static function getAllRegions(Request $request) {
    $connection = PDOBuilder::getConnection('icrp_database');
    $parameters = self::array_merge_intersection($request->query->all(), ['searchId' => 0]);
    $data = MappingTool::getAllRegions($connection, $parameters);
    return self::createResponse($data);
  }
  
  public static function getSearchParameters(Request $request) {
    $connection = PDOBuilder::getConnection('icrp_database');
    $parameters = self::array_merge_intersection($request->query->all(), ['searchId' => 0]);
    $data = MappingTool::getSearchParameters($connection, $parameters);
    return self::createResponse($data);
  }
}
