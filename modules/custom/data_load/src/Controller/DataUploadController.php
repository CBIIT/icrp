<?php

namespace Drupal\data_load\Controller;

use Drupal;
use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;

use Drupal\data_load\Services\ExcelBuilder;
use Drupal\data_load\Services\PDOBuilder;
use Drupal\data_load\Services\CollaboratorsManager;
use Drupal\data_load\Services\InstitutionsManager;
use Drupal\data_load\Services\DataUpload\MSSQL\DataUpload;
// use this class instead once migration to MySQL is complete
// use Drupal\data_load\Services\DataUpload\MYSQL\DataUpload;

class DataUploadController extends ControllerBase {

  /**
   * Creates a JSON response with CORS headers from the given data
   *
   * @param [type] $data
   * @return void
   */
  private static function createResponse($data = NULL) {
    $status = 200;
    if (is_array($data) && array_key_exists('ERROR', $data)) {
      $data = $data['ERROR'];
      $status = 400;
    }

    $response = JsonResponse::create($data, $status, [
      'Access-Control-Allow-Headers' => 'origin, content-type, accept',
      'Access-Control-Allow-Origin'  => '*',
      'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS',
    ]);

    // pretty-print response json
    $response->setEncodingOptions($response->getEncodingOptions() | JSON_PRETTY_PRINT);

    return $response;
  }


  /**
   * Loads data into the tmp table so it can be validated
   *
   * @param Request $request
   * @return JSONResponse
   */
  public static function loadProjects(Request $request): JSONResponse {
    $parameters = json_decode($request->getContent(), true);
    $connection = PDOBuilder::getConnection('icrp_load_database');

    // $request->files
    $data = DataUpload::loadProjects($connection, $parameters, $filePath);
    return self::createResponse($data);
  }


  /**
   * Retrieves sorted and paginated data from the tmp table
   *
   * @param Request $request
   * @return JSONResponse
   */
  public static function getProjects(Request $request): JSONResponse {
    $parameters = json_decode($request->getContent(), true);
    $connection = PDOBuilder::getConnection('icrp_load_database');

    $data = DataUpload::getProjects($connection, $parameters);
    return self::createResponse($data);
  }


  /**
   * Imports projects from the data_load database
   *
   * @param Request $request
   * @return JsonResponse
   */
  public static function importProjects(Request $request): JsonResponse {
    $parameters = json_decode($request->getContent(), true);
    $connection = PDOBuilder::getConnection('icrp_load_database');

    $data = DataUpload::importProjects($connection, $parameters);
    return self::createResponse($data);
  }


  /**
   * Gets validation rules for the data import
   *
   * @param Request $request
   * @return JSONResponse
   */
  public static function getValidationRules(Request $request): JSONResponse {
    $connection = PDOBuilder::getConnection('icrp_load_database');
    $data = DataUpload::getValidationRules($connection);
    return self::createResponse($data);
  }


  /**
   * Gets partners from the database
   *
   * @return JSONResponse
   */
  public static function getPartners(): JSONResponse {
    $connection = PDOBuilder::getConnection('icrp_load_database');
    $data = DataUpload::getPartners($connection);
    return self::createResponse($data);
  }


  /**
   * Performs an integrity check for a specific partner
   *
   * @param Request $request
   * @return JsonResponse
   */
  public static function integrityCheck(Request $request): JsonResponse {
    $parameters = json_decode($request->getContent(), true);
    $connection = PDOBuilder::getConnection('icrp_load_database');

    $data = DataUpload::integrityCheck($connection, $parameters);
    return self::createResponse($data);
  }


  /**
   * Performs an integrity check for a specific rule
   *
   * @param Request $request
   * @return JsonResponse
   */
  public static function integrityCheckDetails(Request $request): JsonResponse {
    $parameters = json_decode($request->getContent(), true);
    $connection = PDOBuilder::getConnection('icrp_load_database');

    $data = DataUpload::integrityCheckDetails($connection, $parameters);
    return self::createResponse($data);
  }
}