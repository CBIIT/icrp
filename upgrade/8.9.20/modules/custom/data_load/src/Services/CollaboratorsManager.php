<?php

namespace Drupal\data_load\Services;

use PDO;
use PDOException;
use Exception;

class CollaboratorsManager {

  /**
   * Imports collaborators into the database
   *
   * @param PDO $connection
   * @param array $data A non-associative array containing the records to be inserted
   * @return array
   */
  public static function importCollaborators(PDO $connection, array $data): array {
    try {
      // create a new collaborator import log id
      $stmt = $connection->prepare(
        'SET NOCOUNT ON;
        DECLARE @ImportCollaboratorLogID INT;
        EXECUTE AddImportCollaboratorLog
          @Count = :count,
          @ImportCollaboratorLogID = @ImportCollaboratorLogID OUTPUT;
        SELECT @ImportCollaboratorLogID');
      $stmt->execute(['count' => count($data)]);
      $logId = $stmt->fetchColumn();

      // insert records into ImportCollaboratorStaging
      $stmt = $connection->prepare(
        'INSERT INTO ImportCollaboratorStaging (
          [ImportCollaboratorLogID],
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
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');

      foreach($data as $index => $row) {
        $parameters = array_map(function($value) {
          return strlen($value) > 0 ? $value : NULL;
        }, $row);

        // prepend rows with the import log id
        array_unshift($parameters, $logId);
        $stmt->execute($parameters);
      }

      // return any collaborators that were not successfully imported
      $stmt = $connection->prepare(
        'SET NOCOUNT ON;
        EXECUTE ImportCollaborators
          @ImportCollaboratorLogID = :logId,
          @count = NULL');
      $stmt->execute(['logId' => $logId]);
      return $stmt->fetchAll();
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