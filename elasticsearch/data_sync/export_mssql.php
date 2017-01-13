<?php

namespace Export;
use PDO;

/**
 * Controller routines for db_search_api routes.
 */
class MSSQL_Export  {

  private static $connection_ini = 'connection.ini';

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

    $cfg = parse_ini_file(self::$connection_ini);

    // connection string
    $cfg['data_source'] =
      $cfg['driver'] .
      ":Server={$cfg['server']},{$cfg['port']}" .
      ";Database={$cfg['database']}";

    // default configuration options
    $cfg['options'] = [
      PDO::SQLSRV_ATTR_ENCODING    => PDO::SQLSRV_ENCODING_UTF8,
      PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
      PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
  //  PDO::ATTR_EMULATE_PREPARES   => false,
    ];

    // create new PDO object
    return new PDO(
      $cfg['data_source'],
      $cfg['username'],
      $cfg['password'],
      $cfg['options']
    );
  }
}
ini_set('memory_limit','1024M');
$instance = new MSSQL_Export();
$pdo=$instance->get_connection();

$tsql = "SELECT * FROM ProjectDocument";
$stmt = $pdo->prepare($tsql);
$stmt->execute();
$result = $stmt->fetchAll();
file_put_contents("projectDocument.json", json_encode($result));

$tsql = "SELECT  * FROM ProjectDocument_JP";
$stmt = $pdo->prepare($tsql);
$stmt->execute();
$result = $stmt->fetchAll();
file_put_contents("projectDocumentJP.json", json_encode($result));
