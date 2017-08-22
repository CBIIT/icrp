<?php


namespace Drupal\data_load\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;
use PDOStatement;

class AddInstitutionsController {

  private static function initializeTable(PDO $pdo): void {
    $pdo->exec("
      DROP TABLE IF EXISTS tmp_LoadIInstitutions;
      CREATE TABLE tmp_LoadIInstitutions (
        Name          VARCHAR(250),
        Type          VARCHAR(25),
        Longitude     DECIMAL(9, 6),
        Latitude      DECIMAL(9, 6),
        Postal        VARCHAR(50),
        City          VARCHAR(50),
        State         VARCHAR(50),
        Country       VARCHAR(3),
        GRID          VARCHAR(250),
      );
    ");
  }

  public static function addInstitutions(PDO $pdo, array $institutions): array {

    self::initializeTable();
    $stmt = $pdo->prepare(
      "INSERT INTO tmp_LoadIInstitutions 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");

    foreach($institutions as $institution) {
      $stmt->exec($institution);
    }

    return $pdo->query("SET NOCOUNT ON; EXEC AddInstitutions")->fetchAll();
  }

  public static function addInstitutionsRoute(Request $request) {
    $institutions = json_decode($request->getContent(), true);
    $data = self::addInstitutions($institutions);
    return new JsonResponse($data);
  }


}