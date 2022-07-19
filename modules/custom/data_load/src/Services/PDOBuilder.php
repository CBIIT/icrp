<?php

namespace Drupal\data_load\Services;

use Drupal;
use PDO;
use PDOStatement;

class PDOBuilder {

  public static function getDsn($cfg): string {
    $dsn = [
      'Server' => "$cfg[host],$cfg[port]",
      'Database' => $cfg['database'],
    ];

    if ($cfg['options']) {
      $dsn += $cfg['options'];
    }

    $dsnString = join(';', array_map(
      fn($k, $v) => "$k=$v", 
      array_keys($dsn), 
      array_values($dsn)
    ));

    return "$cfg[driver]:$dsnString";
  }

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

    // default configuration options
    $cfg['options'] = [
      'sqlsrv' => [
        PDO::SQLSRV_ATTR_ENCODING    => PDO::SQLSRV_ENCODING_UTF8,
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::SQLSRV_ATTR_FETCHES_NUMERIC_TYPE => TRUE,
        PDO::SQLSRV_ATTR_QUERY_TIMEOUT => 0,
      ],
      'mysql' => [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::MYSQL_ATTR_LOCAL_INFILE => TRUE
      ]
    ][$cfg['driver']];

    return new PDO(
      self::getDsn($cfg),
      $cfg['username'],
      $cfg['password'],
      $cfg['options']
    );
  }


  /**
   * Creates a prepared statement
   *
   * @param PDO $pdo
   * @param string $query
   * @param array $input_parameters
   * @param array $output_parameters
   * @return PDOStatement
   */
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


  /**
   * Executes a prepared statement given a pdo connection object,
   * the query string, the input parameters (optional) and any
   * output parameters (optional).
   *
   * Returns the statement that was executed.
   *
   * @param PDO $pdo
   * @param string $query
   * @param array $input_parameters
   * @param array $output_parameters
   * @return PDOStatement
   */
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

}
