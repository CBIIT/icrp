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
   * Expects the following form data keys:
   *   locale: 'en-us' or 'en-gb'
   *   file: uploaded file
   *
   * @param Request $request
   * @return JSONResponse
   */
  public static function loadProjects(Request $request): JSONResponse {
    $parameters = $request->request->all();
    $connection = PDOBuilder::getConnection('icrp_load_database');
    $uploadsFolder = \Drupal::config('exports')->get('data_load') ?? 'data/uploads/data_load';

    if (!file_exists($uploadsFolder))
      mkdir($uploadsFolder, 0744, true);

    $file = $request->files->get('file')->move($uploadsFolder, uniqid() . '.csv');
    $data = DataUpload::loadProjects($connection, $parameters, $file->getRealPath());
    return self::createResponse($data);
  }


  /**
   * Retrieves sorted and paginated rows from the uploaded workbook
   * Expects a json object with the followiing schema:
   * {
   *   page: The page to retrieve
   *   sortDirection: 'ASC' or 'DESC'
   *   sortColumn: The column to sort by
   * }
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
   * Expects a json object with the following schema:
   * {
   *   partnerCode: A partner code (from getSponsorCodes)
   *   fundingYears: The year range as a string (eg: '2016 - 2017')
   *   importNotes: Import notes (optional)
   *   receivedDate: The date this import was received ('YYYY-MM-DD')
   *   type: The type of import ('UPDATE' or 'NEW')
   * }
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
   * Retrieves data validation rules for the integrity check
   *
   * @return JSONResponse
   */
  public static function getValidationRules(): JSONResponse {
    $connection = PDOBuilder::getConnection('icrp_load_database');
    $data = DataUpload::getValidationRules($connection);
    return self::createResponse($data);
  }


  /**
   * Retrieves partner sponsor codes
   *
   * @return JSONResponse
   */
  public static function getPartners(): JSONResponse {
    $connection = PDOBuilder::getConnection('icrp_load_database');
    $data = DataUpload::getPartners($connection);
    return self::createResponse($data);
  }


  /**
   * Executes an integrity check for a specific partner
   * Expects a json object with the following schema:
   * {
   *   type: 'UPDATE' or 'NEW'
   *   partnerCode: a valid sponsor code
   * }
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
   * Retrieves integrity check details for a specific rule
   * Expects a json object with the following schema:
   * {
   *   ruleId: The rule id (from 'getValidationRules')
   *   partnerCode: a valid sponsor code
   * }
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


  public static function ping() {
    return self::createResponse('ping you back!');
  }
}