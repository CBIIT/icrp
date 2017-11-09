<?php

namespace Drupal\db_admin\Controller;

use Drupal;
use PDO;
use PDOStatement;

class PDOBuilder {

  /**
   * Returns a PDO connection to a database
   * @param string $database - The drupal configuration key for the database to query
   * @return PDO A PDO connection
   * @throws PDOException
   * @api
   */
  public static function getConnection(string $database = 'icrp_database'): PDO {

    /**
     * Drupal configuration object for the specified database
     *
     * Contains the following keys:
     * - driver (Database driver)
     * - host (Database host)
     * - port (Host port)
     * - database (Database)
     * - username (Username)
     * - password (Password)
     * @var string[]
     */
    $cfg = Drupal::config($database)->get();

    return new PDO(
      vsprintf('%s:Server=%s,%s;Database=%s', [
        $cfg['driver'],
        $cfg['host'],
        $cfg['port'],
        $cfg['database'],
      ]),
      $cfg['username'],
      $cfg['password'],
      [
        PDO::SQLSRV_ATTR_ENCODING    => PDO::SQLSRV_ENCODING_UTF8,
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
//      PDO::ATTR_ERRMODE            => PDO::ERRMODE_SILENT,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::SQLSRV_ATTR_FETCHES_NUMERIC_TYPE => TRUE,
      ]
    );
  }


  public static function executePreparedStatement(
    PDO $pdo,
    string $query,
    array $input_parameters = NULL,
    array &$output_parameters = NULL
  ): PDOStatement {

    $stmt = $pdo->prepare($query);
    $stmt = PDOBuilder::bindParameters($stmt, $input_parameters, $output_parameters);
    $stmt->execute();
    return $stmt;
  }


  public static function createPreparedStatement(
    PDO $pdo,
    string $query,
    array $input_parameters = NULL,
    array &$output_parameters = NULL
  ): PDOStatement {

    $stmt = $pdo->prepare($query);
    return PDOBuilder::bindParameters($stmt, $input_parameters, $output_parameters);
  }


  /**
   * Binds paramters to a PDOStatement
   *
   * @param PDOStatement $stmt
   * @param array $input_parameters
   * @param array $output_parameters
   * @return void
   */
  public static function bindParameters(PDOStatement &$stmt, array $input_parameters = NULL, array &$output_parameters = NULL): PDOStatement {

    // retrieves the query string used to create the statement
    $query_string = $stmt->queryString;

    // binds input parameters to the query string if they exist
    if ($input_parameters) {
      foreach($input_parameters as $key => &$value) {
        if (strpos($query_string, ":$key") !== false)
          $stmt->bindParam($key, $value);
      }
    }

    // binds output parameters to the query string if they exist
    if ($output_parameters) {
      foreach($output_parameters as $key => &$output) {
        if (strpos($query_string, ":$key") !== false)
          $stmt->bindParam($key, $output['value'], $output['type'] | PDO::PARAM_INPUT_OUTPUT, 2048);
      }
    }

    return $stmt;
  }

}
