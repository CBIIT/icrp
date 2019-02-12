<?php

namespace Drupal\db_admin\Controller;
use PDO;

class Institutions {

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
