<?php
/**
 * @file
 * Contains \Drupal\db_project_view\Controller\CurrentPartnersController
 */
namespace Drupal\db_project_view\Controller;
use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;

class CurrentPartnersController extends ControllerBase {

  /** Field mappings of database results to template variables */
  const FIELD_MAP = [
    'current_partners' => [
      'Name' => 'name',
      'SponsorCode' => 'sponsor_code',
      'Description' => 'description',
      'Country' => 'country',
      'Website' => 'website',
      'JoinDate' => 'join_date',
    ],
  ];


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

    // connection string
    $cfg['dsn'] =
      $cfg['driver'] .
      ":Server={$cfg['host']},{$cfg['port']}" .
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
      $cfg['dsn'],
      $cfg['username'],
      $cfg['password'],
      $cfg['options']
    );
  }

  /**
  * Adds CORS Headers to a response
  */
  public function add_cors_headers($response) {
    $response->headers->set('Access-Control-Allow-Headers', 'origin, content-type, accept');
    $response->headers->set('Access-Control-Allow-Origin', '*');
    $response->headers->set('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, PATCH, OPTIONS');

    return $response;
  }

  public function get_current_partners() {
    $pdo = self::get_connection();

    $queries = [
      'current_partners' => 'GetPartners',
    ];

    // map queries to return values
    return array_reduce(
      array_map(function($key, $value) use ($pdo) {
        $stmt = $pdo->prepare($value);
        $stmt->execute();

        // map the result of each query to each template key
        return [$key => array_map(function($row) use ($key) {

          // map each field in the row to a template variable
          return array_reduce( 
            array_map(function($row_key, $row_value) use ($key) {
                return [self::FIELD_MAP[$key][$row_key] => $row_value];
            }, array_keys($row), $row)
          , 'array_merge', []);
        }, $stmt->fetchAll(PDO::FETCH_ASSOC))];
      }, array_keys($queries), $queries), 
    'array_merge', []);
  }


  public function getCurrentPartners() {
    $results = self::get_current_partners();
    return [
      '#theme' => 'current_partners_view',
      '#current_partners' => $results['current_partners'],
      '#attached' => [
        'library' => [
          'db_project_view/resources'
        ],
      ],
    ];
  }

}
