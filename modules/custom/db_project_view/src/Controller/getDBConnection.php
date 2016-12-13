<?php

/**
 * Returns a PDO connection to a MySQL Database
 * @param $cfg - An associative array containing connection parameters 
 *   driver:  DB Connector Driver
 *   host:    Server Name
 *   dbname:  Database
 *   user:    Username
 *   pass:    Password
 *   charset: Character Set
 *
 * @return A PDO connection
 * @throws PDOException
 */
function getDBConnection($cfg) {

  // connection string
  $cfg['dsn'] = 
    $cfg['driver'] .
    ":host="    . $cfg['host'] .
    ";dbname="  . $cfg['dbname'] .
    ";charset=" . $cfg['charset'];

  // default configuration options
  $cfg['opt'] = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
  ];

  // create new PDO object
  return new PDO(
    $cfg['dsn'], 
    $cfg['user'], 
    $cfg['pass'], 
    $cfg['opt']);
}