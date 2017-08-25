<?php


namespace Drupal\data_load\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;

class AddInstitutionsController {

  private static function initializeTable(PDO $pdo): void {
    $pdo->exec("
      DROP TABLE IF EXISTS tmp_LoadInstitutions;
      CREATE TABLE tmp_LoadInstitutions (
        Id            INT IDENTITY (1,1),
        Name          VARCHAR(250),
        City          VARCHAR(50),
        State         VARCHAR(50),
        Country       VARCHAR(3),
        Postal        VARCHAR(50),
        Longitude     DECIMAL(9, 6),
        Latitude      DECIMAL(9, 6),
        GRID          VARCHAR(250)
      );
    ");
  }

  public static function addInstitutions(PDO $pdo, array $institutions): array {

    self::initializeTable($pdo);
    $stmt = $pdo->prepare(
      "INSERT INTO tmp_LoadInstitutions ([Name], [City], [State], [Country], [Postal], [Longitude], [Latitude], [GRID])
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

    foreach($institutions as $institution) {

      $data = array_map(function($value) {
        return strlen($value) > 0 ? $value : NULL;
      }, $institution);

      $stmt->execute($data);
    }

    return $pdo->query("SET NOCOUNT ON; EXEC AddInstitutions")->fetchAll();
  }

    /**
    * Adds CORS Headers to a response
    */
  private static function addCorsHeaders($response) {
    $response->headers->set('Access-Control-Allow-Headers', 'origin, content-type, accept');
    $response->headers->set('Access-Control-Allow-Origin', '*');
    $response->headers->set('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, PATCH, OPTIONS');

    return $response;
  }

  public static function addInstitutionsRoute(Request $request) {
    $institutions = json_decode($request->getContent(), true);

    $pdo = DatabaseAdapter::get_connection();
    $data = self::addInstitutions($pdo, $institutions);
    return self::addCorsHeaders(new JsonResponse($data));
  }


  public static function addInstitutionsApp() {
    return [
    '#theme'    => 'add_institutions',
    '#attached' => [
    'library'   => [
    'data_load/add_institutions'
    ],
    ],
    ];
}

}