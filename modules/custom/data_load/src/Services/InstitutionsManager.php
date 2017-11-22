<?php

namespace Drupal\data_load\Services;

use PDO;
use PDOException;
use Exception;

class InstitutionsManager {

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

  public static function importInstitutions(PDO $pdo, array $institutions) {
    $index = 1;
    try {
      self::initializeTable($pdo);
      $stmt = $pdo->prepare(
        "INSERT INTO tmp_LoadInstitutions ([Name], [City], [State], [Country], [Postal], [Longitude], [Latitude], [GRID])
          VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

      foreach($institutions as $institution) {
        $index ++;
        $data = array_map(function($value) {
          return strlen($value) > 0 ? $value : NULL;
        }, $institution);

        $stmt->execute($data);
      }

      return $pdo
        ->query("SET NOCOUNT ON; EXEC ImportInstitutions")
        ->fetchAll();
    }

    catch (PDOException $e) {

      $message = preg_replace('/^SQLSTATE\[.*\]/', '', $e->getMessage());

      if ($index < count($data)) {
         $message = "An error occured while reading row $index: $message";
      }

      return ['ERROR' => $message];
    }

    catch (Exception $e) {
      return [
        'ERROR' => $e->getMessage()
      ];
    }
  }
}