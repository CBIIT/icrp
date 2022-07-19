<?php
/**
 * @file
 * Contains \Drupal\db_project_view\Controller\DBUtil.
 */
namespace Drupal\db_project_view\Controller;
use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;


class DBUtil {

  public static function get_dsn($cfg): string {
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
   * @param $cfg - An associative array containing connection parameters
   *   driver:    DB Driver
   *   server:    Server Name
   *   database:  Database
   *   user:      Username
   *   password:  Password
   *
   * @return A PDO connection
   * @throws PDOException
   */
  function get_connection() {

    $cfg = [];
    $icrp_database = \Drupal::config('icrp_database');
    foreach(['driver', 'host', 'port', 'database', 'username', 'password'] as $key) {
       $cfg[$key] = $icrp_database->get($key);
    }

    // default configuration options
    $cfg['options'] = [
      PDO::SQLSRV_ATTR_ENCODING    => PDO::SQLSRV_ENCODING_UTF8,
      PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
      PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
  //  PDO::ATTR_EMULATE_PREPARES   => false,
    ];

    // create new PDO object
    return new PDO(
      self::get_dsn($cfg),
      $cfg['username'],
      $cfg['password'],
      $cfg['options']
    );
  }

}
