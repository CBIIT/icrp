<?php

namespace Drupal\data_load\Controller;

use \Drupal;
use \PDO;

class DatabaseAdapter {

    /**
     * Creates a PDO connection object for the icrp load database
     *
     * @return PDO The PDO object
     */
    public static function get_connection(): PDO {
        $cfg = Drupal::config('icrp_load_database')->get();

        // connection string
        $cfg['dsn'] = vsprintf('%s:Server=%s,%s;Database=%s', [
          $cfg['driver'],
          $cfg['host'],
          $cfg['port'],
          $cfg['database'],
        ]);

        // pdo options
        $options = [
          'sqlsrv' => [
            PDO::SQLSRV_ATTR_ENCODING    => PDO::SQLSRV_ENCODING_UTF8,
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
          ],

          'mysql' => [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::MYSQL_ATTR_LOCAL_INFILE => TRUE,
          ],
        ];

        // set pdo options
        $cfg['options'] = $options[$cfg['driver']];

        // create new PDO object
        return new PDO(
          $cfg['dsn'],
          $cfg['username'],
          $cfg['password'],
          $cfg['options']
        );
    }
}