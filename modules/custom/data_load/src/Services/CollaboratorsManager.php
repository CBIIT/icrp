<?php

namespace Drupal\data_load\Services;

use PDO;
use PDOException;
use Exception;

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

  /**
   * Imports collaborators into the database
   *
   * @param PDO $connection
   * @param array $data A non-associative array containing the records to be inserted
   * @return array
   */
  public static function importCollaborators(PDO $connection, array $data): array {

    $index = 1;
    try {

      self::initializeTable($connection);

      $stmt = $connection->prepare(
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

      foreach($data as $row) {
        $index ++;
        $parameters = array_map(function($value) {
          return strlen($value) > 0 ? $value : NULL;
        }, $row);

        $stmt->execute($parameters);
      }

      return $connection
        ->query("SET NOCOUNT ON; EXEC ImportCollaborators @ImportCount = NULL")
        ->fetchAll();
    }

    catch (PDOException $e) {
      return [
        'ERROR' => "An error occured while reading row $index: "
          . preg_replace('/^SQLSTATE\[.*\]/', '', $e->getMessage())
      ];
    }

    catch (Exception $e) {
      return [
        'ERROR' => $e->getMessage()
      ];
    }

  }
}