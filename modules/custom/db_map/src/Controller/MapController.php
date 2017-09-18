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
    return JsonResponse::create(
      $data,
      isset($data['ERROR']) ? 400 : 200, [
      'Access-Control-Allow-Headers' => 'origin, content-type, accept',
      'Access-Control-Allow-Origin'  => '*',
      'Access-Control-Allow-Methods' => 'GET, POST',
    // ensure that the response contains formatted json
    ])->setEncodingOptions((new JsonResponse())->getEncodingOptions() | JSON_PRETTY_PRINT);
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


  /**
   * Returns the Drupal render array for the index page for this module
   *
   * @return array
   */
  public static function getContent(): array {
    return [
      '#theme' => 'db_map',
      '#attached' => [
        'library' => [
          'db_map/default'
        ],
      ],
    ];
  }


  /**
   * Retrieves all regions for the given search id.
   *
   * @param Request $request A GET request that contains the searchId parameter
   * @return JSONReponse
   */
  public static function getRegions(Request $request): JSONResponse {
    $connection = PDOBuilder::getConnection('icrp_database');
    $parameters = self::array_merge_intersection($request->query->all(), ['searchId' => 0]);
    $data = MappingTool::getRegions($connection, $parameters);
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
   * Creates an arbitrary excel report based on the supplied json object.
   *
   * For example:
   * [
   *    {title: 'Sheet one', data: ['A', 'B', 'C']},
   *    {title: 'Sheet two', data: ['D', 'E', 'F']},
   * ];
   *
   * @param Request $request Contains a json body that will be converted to an excel document
   * @return JSONResponse
   */
  public static function getExcelExport(Request $request): JSONResponse {
    $sheets = json_decode($request->getContent(), true);
    $filename = sprintf("Map_Export_%s.xlsx", uniqid());
    $uri = ExcelBuilder::create($filename, $sheets);
    return self::createResponse($uri);
  }
}