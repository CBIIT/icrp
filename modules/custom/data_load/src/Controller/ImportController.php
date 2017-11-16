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

  public static function addInstitutions(Request $request): JsonResponse {
    $parameters = json_decode($request->getContent(), true);
    $connection = PDOBuilder::getConnection();

    $data = InstitutionsManager::addInstitutions($connection, $parameters);
    return self::createResponse($data);
  }

  public static function addCollaborators(Request $request): JsonResponse {
    $parameters = json_decode($request->getContent(), true);
    $connection = PDOBuilder::getConnection();

    $data = CollaboratorsManager::addCollaborators($connection, $parameters);
    return self::createResponse($data);
  }
}