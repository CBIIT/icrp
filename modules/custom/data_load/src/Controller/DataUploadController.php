<?php

namespace Drupal\data_load\Controller;

use Exception;
use Drupal;
use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;

use Drupal\data_load\Services\ExcelBuilder;
use Drupal\data_load\Services\PDOBuilder;
use Drupal\data_load\Services\FileHandler;
use Drupal\data_load\Services\CollaboratorsManager;
use Drupal\data_load\Services\InstitutionsManager;
use Drupal\data_load\Services\MSSQL\DataUpload;
// use this class instead once migration to MySQL is complete
// use Drupal\data_load\Services\MYSQL\DataUpload;

class DataUploadController extends ControllerBase {

  /**
   * Creates a JSON response with CORS headers from the given data
   */
  private static function createResponse($data = NULL): JsonResponse {
    $status = 200;

    if (is_array($data) && array_key_exists('ERROR', $data)) {
      $data = $data['ERROR'];
      error_log($data);
      $status = 400;
    }

    // ✅ FIX: JsonResponse::create() → new JsonResponse()
    $response = new JsonResponse($data, $status, [
      'Access-Control-Allow-Headers' => 'origin, content-type, accept',
      'Access-Control-Allow-Origin'  => '*',
      'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS',
    ]);

    // pretty-print response json
    $response->setEncodingOptions(
      $response->getEncodingOptions() | JSON_PRETTY_PRINT
    );

    return $response;
  }

  /**
   * Loads data into the tmp table so it can be validated
   */
  public static function loadProjects(Request $request): JsonResponse {
    $parameters = $request->request->all();
    $connection = PDOBuilder::getConnection('icrp_load_database');
    $uploadsFolder = \Drupal::config('icrp-tmp')->get('workbooks') ?? 'data/tmp/workbooks';

    if (!file_exists($uploadsFolder)) {
      mkdir($uploadsFolder, 0744, true);
    }

    $file = $request->files->get('file')->move($uploadsFolder, uniqid() . '.csv');
    $data = DataUpload::loadProjects($connection, $parameters, $file->getRealPath());

    return self::createResponse($data);
  }

  /**
   * Retrieves sorted and paginated rows
   */
  public static function getProjects(Request $request): JsonResponse {
    $parameters = json_decode($request->getContent(), true);
    $connection = PDOBuilder::getConnection('icrp_load_database');

    $data = DataUpload::getProjects($connection, $parameters);
    return self::createResponse($data);
  }

  /**
   * Imports projects
   */
  public static function importProjects(Request $request): JsonResponse {
    $parameters = json_decode($request->getContent(), true);
    $connection = PDOBuilder::getConnection('icrp_load_database');

    $data = DataUpload::importProjects($connection, $parameters);
    return self::createResponse($data);
  }

  /**
   * Retrieves validation rules
   */
  public static function getValidationRules(): JsonResponse {
    $connection = PDOBuilder::getConnection('icrp_load_database');
    $data = DataUpload::getValidationRules($connection);

    return self::createResponse($data);
  }

  /**
   * Retrieves partner sponsor codes
   */
  public static function getPartners(): JsonResponse {
    $connection = PDOBuilder::getConnection('icrp_load_database');
    $data = DataUpload::getPartners($connection);

    return self::createResponse($data);
  }

  /**
   * Executes integrity check
   */
  public static function integrityCheck(Request $request): JsonResponse {
    $parameters = json_decode($request->getContent(), true);
    $connection = PDOBuilder::getConnection('icrp_load_database');

    $data = DataUpload::integrityCheck($connection, $parameters);
    return self::createResponse($data);
  }

  /**
   * Retrieves integrity check details
   */
  public static function integrityCheckDetails(Request $request): JsonResponse {
    $parameters = json_decode($request->getContent(), true);
    $connection = PDOBuilder::getConnection('icrp_load_database');

    $data = DataUpload::integrityCheckDetails($connection, $parameters);
    return self::createResponse($data);
  }

  /**
   * Calculates funding amounts
   */
  public static function calculateFundingAmounts(Request $request): JsonResponse {
    $connection = PDOBuilder::getConnection('icrp_load_database');
    $data = DataUpload::calculateFundingAmounts($connection);

    return self::createResponse($data);
  }

  public static function ping(): JsonResponse {
    return self::createResponse('ping you back!');
  }

}