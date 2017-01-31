<?php
/**
 * @file
 * Contains \Drupal\db_project_view\Controller\FundingOrgController.
 */
namespace Drupal\db_project_view\Controller;
use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;

class FundingOrgController extends ControllerBase {


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

  public function getFundingOrgDetails() {
    $pdo = self::get_connection();
    $stmt = $pdo->prepare("
      SELECT DISTINCT
       Name  AS name,
       Abbreviation AS abbr,
       Country as country,
       SponsorCode as sponsor,
       Currency as currency,
       '' as description,
       CAST(LastImportDate as DATE) import_date,
       CASE WHEN IsAnnualized = 1 THEN 'YES'
            ELSE 'NO'
       END as annual
       FROM FundingOrg
       WHERE LastImportDate IS NOT NULL");
     $stmt->execute();
     return $stmt->fetchAll(PDO::FETCH_ASSOC);
  }
  public function getFundingOrg() {
    $results = self::getFundingOrgDetails();
    return self::add_cors_headers(new JsonResponse($results));
  }  
  public function getFundingOrgContent() {
   return [
     '#theme' => 'funding_org_view',
     '#attached' => [
        'library' => [
          'db_project_view/funding_org_resources'
        ],
     ],
   ];
  }
}
