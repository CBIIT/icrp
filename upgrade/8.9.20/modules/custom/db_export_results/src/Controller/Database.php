<?php

namespace Drupal\db_export_results\Controller;
use Drupal;
use PDO;

class Database {

  public static function getDsn($cfg): string {
    $dsn = [
      'Server' => "$cfg[host],$cfg[port]",
      'Database' => $cfg['database'],
    ] + ($cfg['dsnOptions'] ?? []);
    
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

    return new PDO(
      self::getDsn($cfg),
      $cfg['username'],
      $cfg['password'],
      [
        PDO::SQLSRV_ATTR_ENCODING    => PDO::SQLSRV_ENCODING_UTF8,
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
//      PDO::ATTR_ERRMODE            => PDO::ERRMODE_SILENT,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
      ]
    );
  }

}