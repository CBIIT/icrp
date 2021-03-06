<?php

namespace Drupal\db_admin\Controller;
use PDO;

class Institutions {

  public static function getFields(PDO $pdo) {
    return [
      'institutions' => $pdo->query(
        'SELECT
          InstitutionID as id,
          name,
          country,
          city,
          state,
          postal,
          latitude,
          longitude,
          grid
        from Institution
        order by name'
       )->fetchAll(),

      'countries' => $pdo->query(
          'SELECT
              RTRIM(abbreviation) as abbreviation,
              name
              FROM Country
              ORDER BY name'
        )->fetchAll(),

      'states' => $pdo->query(
          'SELECT
              StateID as id,
              RTRIM(abbreviation) as abbreviation,
              name,
              RTRIM(country) as country
              FROM State
              ORDER BY name'
        )->fetchAll(),
      ];
  }

  public static function add(PDO $pdo, array $parameters): bool {
    return PDOBuilder::createPreparedStatement(
      $pdo,
      "EXECUTE AddInstitution
        @Name = :name,
        @Country = :country,
        @City = :city,
        @State = :state,
        @Postal = :postal,
        @Longitude = :longitude,
        @Latitude = :latitude,
        @GRID = :grid,
        @Type = NULL;",
      $parameters
    )->execute();
  }

  public static function update(PDO $pdo, array $parameters): bool {
    return PDOBuilder::createPreparedStatement(
      $pdo,
      "EXECUTE UpdateInstitution
        @InstitutionID = :institutionId,
        @Name = :name,
        @Country = :country,
        @City = :city,
        @State = :state,
        @Postal = :postal,
        @Longitude = :longitude,
        @Latitude = :latitude,
        @GRID = :grid,
        @Type = NULL;",
      $parameters
    )->execute();
  }

  public static function merge(PDO $pdo, array $parameters) {
    if ($parameters['keptInstitutionId'] == $parameters['deletedInstitutionId']) {
      throw new \Exception('The institutions to be merged must be different from each other.');
    }

    return PDOBuilder::executePreparedStatement(
      $pdo,
      "SET NOCOUNT ON;
      DECLARE @resultsCount INT;
      EXECUTE MergeInstitutions
        @InstitutionID_Old = :deletedInstitutionId,
        @InstitutionID_New = :keptInstitutionId,
        @Count = @resultsCount OUTPUT;
      SELECT @resultsCount;",
      $parameters
    )->fetchColumn();
  }

}
