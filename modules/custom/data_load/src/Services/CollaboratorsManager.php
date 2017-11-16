<?php

namespace Drupal\data_load\Services;

use PDO;
use PDOException;

class CollaboratorsManager {

  public static function addCollaborators(PDO $connection, array $parameters): array {
    try {
      return $parameters;
    }

    catch (PDOException $e) {
      return [
        'ERROR' => preg_replace('/^SQLSTATE\[.*\]/', '', $e->getMessage())
      ];
    }
  }
}