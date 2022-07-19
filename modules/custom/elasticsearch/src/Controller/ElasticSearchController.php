<?php

namespace Drupal\elasticsearch\Controller;

class LibraryController extends ControllerBase {
  public function content() {
    $request = \Drupal::request();
    if ($route = $request->attributes->get(\Symfony\Cmf\Component\Routing\RouteObjectInterface::ROUTE_OBJECT)) {
      $route->setDefault('_title', 'ElasticSearch');
    }
    return [
      '#theme' => 'elasticsearch',
      '#attached' => [
        'elasticsearch' => [
          'elasticsearch/resources'
        ],
      ],
    ];
  }

  public static function get_dsn($cfg): string {
    $dsn = [
      'Server' => "$cfg[host],$cfg[port]",
      'Database' => $cfg['database'],
    ];

    if ($cfg['options']) {
      $dsn += $cfg['options'];
    }

    $dsnString = join(';', array_map(
      fn($k, $v) => "$k=$v", 
      array_keys($cfg['dsn']), 
      array_values($cfg['dsn'])
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
  private function get_connection() {
    $cfg = [];
    $icrp_database = \Drupal::config('icrp_database');
    foreach(['driver', 'host', 'port', 'database', 'username', 'password'] as $key) {
       $cfg[$key] = $icrp_database->get($key);
    }
    // connection string
    $cfg['dsn'] =
      $cfg['driver'] .
      ":Server={$cfg['host']},{$cfg['port']}" .
      ";Database={$cfg['database']};ConnectionPooling=0";
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