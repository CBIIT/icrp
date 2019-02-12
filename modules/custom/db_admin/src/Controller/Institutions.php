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
        from Institution'
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
        @Grid = :grid;",
      $parameters
    )->execute();
  }

  public static function update(PDO $pdo, array $parameters): bool {
    return PDOBuilder::createPreparedStatement(
      $pdo,
      "EXECUTE UpdateInstitution
        @Id = :id,
        @Country = :country,
        @City = :city,
        @State = :state,
        @Postal = :postal,
        @Longitude = :longitude,
        @Latitude = :latitude,
        @Grid = :grid;",
      $parameters
    )->execute();
  }

}
