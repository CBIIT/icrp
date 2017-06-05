<?php

/**
 * @file
 * Contains \Drupal\db_export_results\Controller\DatabaseExportController
 */

namespace Drupal\db_export_results\Controller;

require __DIR__ . '/../../vendor/autoload.php';

use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use PDO;

class DatabaseExportController extends ControllerBase {

  private static function createResponse($data) {
    $response = Response::create($data, 200, [
      'Access-Control-Allow-Headers' => 'origin, content-type, accept',
      'Access-Control-Allow-Origin'  => '*',
      'Access-Control-Allow-Methods' => 'GET',
    ]);
    return $response;
  }

  function exportSearchResults(Request $request) {
    $pdo = Database::getConnection();
    $searchID = $request->query->get('search_id', $_SESSION['database_search_id']);
    $uri = (new DatabaseExport())->exportSearchResults($pdo, intval($searchID));
    return self::createResponse($uri);
  }


}
