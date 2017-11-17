<?php

namespace Drupal\data_load\Services;

use PDO;
use PDOException;

class CollaboratorsManager {

  private static function initializeTable(PDO $pdo): void {
    $pdo->exec("
      IF OBJECT_ID('tmp_LoadCollaborators') IS NOT NULL
        DELETE FROM tmp_LoadCollaborators;

      ELSE
        CREATE TABLE tmp_LoadCollaborators (
          AwardCode VARCHAR(75) NOT NULL,
          AltAwardCode VARCHAR(75) NOT NULL,
          LastName VARCHAR(100),
          FirstName VARCHAR(100),
          Institution VARCHAR(250) NOT NULL,
          City VARCHAR(50) NOT NULL,
          ORC_ID VARCHAR(19),
          OtherResearchID INT,
          OtherResearchType VARCHAR(50)
        );
    ");
  }

  public static function importCollaborators(PDO $connection, array $parameters): array {
    try {
      self::initializeTable($connection);

      $stmt = $pdo->prepare(
        "INSERT INTO tmp_LoadCollaborators (
          [AwardCode],
          [AltAwardCode],
          [LastName],
          [FirstName],
          [Institution],
          [City],
          [ORC_ID],
          [OtherResearchID],
          [OtherResearchType])
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");

      foreach($parameters as $row) {

        $data = array_map(function($value) {
          return strlen($value) > 0 ? $value : NULL;
        }, $row);

        $stmt->execute($data);
      }

      return $pdo->query("SET NOCOUNT ON; EXEC ImportCollaborators @ImportCount = NULL")->fetchAll();
    }

    catch (PDOException $e) {
      return [
        'ERROR' => preg_replace('/^SQLSTATE\[.*\]/', '', $e->getMessage())
      ];
    }
  }

}