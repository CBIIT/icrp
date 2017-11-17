<?php

namespace Drupal\data_load\Controller;

use Drupal;
use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;

use Drupal\data_load\Services\PDOBuilder;
use Drupal\data_load\Services\CollaboratorsManager;
use Drupal\data_load\Services\InstitutionsManager;
use Drupal\data_load\Services\DataLoad\MSSQL\DataLoad;
// use this class instead once migration to MySQL is complete
// use Drupal\data_load\Services\DataLoad\MYSQL\DataLoad;

class ImportController extends ControllerBase {

  /**
   * Creates a JSON response with CORS headers from the given data
   *
   * @param [type] $data
   * @return void
   */
  private static function createResponse($data = NULL) {
    $status_code = array_key_exists('ERROR', $data) ? 400 : 200;
    $response = JsonResponse::create($data, $status_code, [
      'Access-Control-Allow-Headers' => 'origin, content-type, accept',
      'Access-Control-Allow-Origin'  => '*',
      'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS',
    ]);

    // pretty print response json
    $response->setEncodingOptions($response->getEncodingOptions() | JSON_PRETTY_PRINT);

    return $response;
  }


  /**
   * Retrieves sorted and paginated data from the tmp table
   *
   * @param Request $request
   * @return JSONResponse
   */
  public static function getData(Request $request): JSONResponse {
    $parameters = json_decode($request->getContent(), true);
    $connection = PDOBuilder::getConnection();

    $data = DataLoad::getData($connection, $parameters);
    return self::createResponse($data);
  }


  /**
   * Loads data into the tmp table so it can be validated
   *
   * @param Request $request
   * @return JSONResponse
   */
  public static function loadData(Request $request): JSONResponse {
    $parameters = json_decode($request->getContent(), true);
    $connection = PDOBuilder::getConnection();

    // $request->files

    $data = DataLoad::loadData($connection, $parameters, $filePath);
    return self::createResponse($data);
  }


  /**
   * Gets validation rules for the data import
   *
   * @param Request $request
   * @return JSONResponse
   */
  public static function getValidationRules(Request $request): JSONResponse {
    $parameters = json_decode($request->getContent(), true);
    $connection = PDOBuilder::getConnection();

    $data = DataLoad::getValidationRules($connection, $parameters);
    return self::createResponse($data);
  }


  /**
   * Gets partners from the database
   *
   * @return JSONResponse
   */
  public static function getPartners(): JSONResponse {
    $parameters = json_decode($request->getContent(), true);
    $connection = PDOBuilder::getConnection();

    $data = DataLoad::getPartners($connection, $parameters);
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
    $connection = PDOBuilder::getConnection();

    $data = DataLoad::integrityCheck($connection, $parameters);
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
    $connection = PDOBuilder::getConnection();

    $data = DataLoad::integrityCheckDetails($connection, $parameters);
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
    $connection = PDOBuilder::getConnection();

    $data = DataLoad::importProjects($connection, $parameters);
    return self::createResponse($data);
  }


  /**
   * Import Institutions
   *
   * @param Request $request
   * @return JsonResponse
   */
  public static function importInstitutions(Request $request): JsonResponse {
    $parameters = json_decode($request->getContent(), true);
    $connection = PDOBuilder::getConnection();
    $data = InstitutionsManager::importInstitutions($connection, $parameters);
    return self::createResponse($data);
  }


  /**
   * Import Collaborators
   *
   * @param Request $request
   * @return JsonResponse
   */
  public static function importCollaborators(Request $request): JsonResponse {
    $parameters = json_decode($request->getContent(), true);
    $connection = PDOBuilder::getConnection();
    $data = CollaboratorsManager::importCollaborators($connection, $parameters);
    return self::createResponse($data);
  }
}