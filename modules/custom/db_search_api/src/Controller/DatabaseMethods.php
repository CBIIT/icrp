<?php

/**
 * @file
 * Contains \Drupal\db_search_api\Controller\DatabaseMethods
 */
namespace Drupal\db_search_api\Controller;

use PDO;
use PDOStatement;

/**
 * Static functions for db_search_api routes.
 */
class DatabaseMethods {

  /**
   * Retrieves the number of partners and funding organizations
   *
   * @param PDO $pdo
   * @return array
   */
  public static function getCounts(PDO $pdo): array {

    $fields = [];
    $queries = [
      'funding_organizations' => "SELECT COUNT(*) FROM FundingOrg WHERE MemberStatus = 'Current'",
      'partners'              => 'SELECT COUNT(*) FROM Partner',
    ];

    // map query results to field values
    foreach ($queries as $key => $value) {
      $fields[$key] = intval($pdo->query($value)->fetch(PDO::FETCH_NUM)[0]);
    }

    return $fields;
  }

  /**
   * Retrieves sample project funding ids for each cso code
   *
   * @param PDO $pdo
   * @return array
   */
  public static function getExamples(PDO $pdo): array {

    $query_definitions = [
      'cso_codes' => [
        'query'     => 'EXECUTE GetCSOLookup',
        'columns'   => [
          'Code'                => 'cso_code',
          'ProjectFundingIDs'   => 'project_funding_ids',
        ],
        'mapped_column_callbacks' => [
          'project_funding_ids' => function($row) { return explode(',', $row); },
        ],
      ]
    ];

    $fields = [];

    // map query results to field values
    foreach ($query_definitions as $key => $definition) {
      $query = $definition['query'];
      $columns = $definition['columns'];
      $mapped_column_callbacks = $definition['mapped_column_callbacks'];

      $stmt = $pdo->prepare($query);
      
      // initialize the current field to an empty array
      $fields[$key] = [];

      if ($stmt->execute()) {
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
          $mapped_row = [];

          // iterate over each of the columns we will retrieve
          foreach ($columns as $database_column => $mapped_column) {
            
            // retrieve the value of the current column
            $database_value = $row[$database_column];

            // apply any callbacks to transform the returned value
            if ($mapped_column_callbacks[$mapped_column]) {
              $callback = $mapped_column_callbacks[$mapped_column];
              $database_value = $callback($database_value);
            }

            // append the value of the mapped column to the mapped row
            $mapped_row[$mapped_column] = $database_value;
          }

          // append the mapped row to the current field
          array_push($fields[$key], $mapped_row);
        }
      }
    }

    return $fields;
  }
}
