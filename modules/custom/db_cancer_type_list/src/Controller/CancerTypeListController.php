<?php
/**
 * @file
 * Contains \Drupal\db_cancer_type_list\Controller\CancerTypeListController.
 */
namespace Drupal\db_cancer_type_list\Controller;
use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Database\Database;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;

class CancerTypeListController extends ControllerBase {

  /**
  * Adds CORS Headers to a response
  */
  function addCorsHeaders($response) {
    $response->headers->set('Access-Control-Allow-Headers', 'origin, content-type, accept');
    $response->headers->set('Access-Control-Allow-Origin', '*');
    $response->headers->set('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, PATCH, OPTIONS');

    return $response;
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
  function getConnection() {

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

  public function getCancerTypes() {
    $pdo = self::getConnection();
    $stmt = $pdo->prepare('SET NOCOUNT ON; SELECT Name as label, Description as description, ICRPCode as icrp_code, ICD10CodeInfo as icd10_code FROM CancerType ORDER BY SortOrder, Name');
    $results = [];

    if($stmt->execute()) {
      $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    return self::addCorsHeaders(
      new JsonResponse($results)
    );
  }  

  public function content() {
    return [
      '#theme' => 'db_cancer_type_list',
      '#attached' => [
        'library' => [
          'db_cancer_type_list/resources'
        ],
      ],
    ];
  }
}
