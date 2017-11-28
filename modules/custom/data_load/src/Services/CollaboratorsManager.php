<?php

namespace Drupal\data_load\Services;

use PDO;
use PDOException;
use Exception;

class CollaboratorsManager {

  private static function initializeTable(PDO $pdo): void {
    $pdo->exec("
      DROP TABLE IF EXISTS tmp_LoadCollaborators;
      CREATE TABLE tmp_LoadCollaborators (
        AwardCode VARCHAR(75) NOT NULL,
        AltAwardCode VARCHAR(75) NOT NULL,
        LastName VARCHAR(100),
        FirstName VARCHAR(100),
        SubmittedInstitution VARCHAR(250),
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

    try {

      self::initializeTable($connection);

      $stmt = $connection->prepare(
        "INSERT INTO tmp_LoadCollaborators (
          [AwardCode],
          [AltAwardCode],
          [LastName],
          [FirstName],
          [SubmittedInstitution],
          [Institution],
          [City],
          [ORC_ID],
          [OtherResearchID],
          [OtherResearchType])
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

      foreach($data as $index => $row) {
        $parameters = array_map(function($value) {
          return strlen($value) > 0 ? $value : NULL;
        }, $row);

        $stmt->execute($parameters);
      }

      // return any collaborators that were not successfully imported
      return $connection
        ->query("SET NOCOUNT ON; EXEC ImportCollaborators @count = NULL")
        ->fetchAll();

      // // number of institutions successfully imported
      // $imported = [
      //   'count' => [
      //     'value' => 0,
      //     'type' => PDO::PARAM_INT
      //   ]
      // ];

      // // institutions that were not successfully imported
      // $errors = PDOBuilder::executePreparedStatement(
      //   $connection,
      //   'SET NOCOUNT ON; EXEC ImportCollaborators @count = NULL',
      //   [],
      //   $output
      // )->fetchAll();

      // return [
      //   'imported' => $imported['count']['value'],
      //   'errors' => $errors
      // ];
    }

    catch (PDOException $e) {
      $message = preg_replace('/^SQLSTATE\[.*\]/', '', $e->getMessage());

      if ($index++ < count($data)) {
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