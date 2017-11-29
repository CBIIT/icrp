<?php

namespace Drupal\data_load\Controller;

use Drupal;
use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;

use Drupal\data_load\Services\PDOBuilder;
use Drupal\data_load\Services\CollaboratorsManager;
use Drupal\data_load\Services\InstitutionsManager;

class ImportController extends ControllerBase {

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