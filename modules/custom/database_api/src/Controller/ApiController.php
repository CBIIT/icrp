<?php

namespace Drupal\database_api\Controller;

use Drupal;
use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;

class ApiController extends ControllerBase {

  function __construct() {
    $this->pdo = $this->getConnection();
  }

  static function getDsn($cfg): string {
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
  function getConnection(string $database = 'icrp_database'): PDO {

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
        PDO::SQLSRV_ATTR_ENCODING               => PDO::SQLSRV_ENCODING_UTF8,
        PDO::ATTR_ERRMODE                       => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE            => PDO::FETCH_ASSOC,
        PDO::ATTR_CASE                          => PDO::CASE_LOWER,
        PDO::SQLSRV_ATTR_FETCHES_NUMERIC_TYPE   => TRUE,
      ]
    );
  }

  function latestNewsletter() {
    $record = $this->pdo->query(
      'EXECUTE GetLatestNewsletter'
    )->fetch();

    return new JsonResponse($record);
  }

  function latestMeetingReport() {
    $record = $this->pdo->query(
      'EXECUTE GetLatestMeetingReport'
    )->fetch();

    return new JsonResponse($record);
  }

  function projectCounts() {
    $counts = $this->pdo->query(
      'SELECT COUNT(*) from Project'
    )->fetchColumn();

    return new JsonResponse($counts);
  }

  function fundingOrganizationCounts() {
    $records = $this->pdo->query(
      'SET NOCOUNT ON; EXECUTE GetFundingOrgs;'
    )->fetchAll();

    return new JsonResponse(count($records));
  }

  function partnerCounts() {
    $records = $this->pdo->query(
      'SET NOCOUNT ON; EXECUTE GetPartners;'
    )->fetchAll();

    return new JsonResponse(count($records));
  }

  function roundedProjectCounts() {
    $counts = $this->pdo->query(
      'SELECT COUNT(*) from Project'
    )->fetchColumn();

    $roundedCounts = round($counts - 500, -3);
    return new JsonResponse($roundedCounts);
  }

  /**
   * Retrieves sample project funding ids for each cso code
   *
   * @param PDO $pdo
   * @return array
   */
  function csoExamples() {
    $records = $this->pdo->query(
      'EXECUTE GetCSOLookup'
    )->fetchAll();

    $examples = array_reduce($records, function($fields = [], $row) {
      $key_format = 'cso-%s-%s-ex%s';
      $value_format = '/project/funding-details/%s';

      $cso_code = $row['code'];
      $project_funding_ids = explode(',', $row['projectfundingids']);

      foreach($project_funding_ids as $index => $project_funding_id) {
        $split_cso_code = explode('.', $cso_code);

        if (count($split_cso_code) === 2) {
          $cso_category = $split_cso_code[0];
          $cso_subcategory = $split_cso_code[1];
          $example_index = $index + 1;

          $key = sprintf($key_format, $cso_category, $cso_subcategory, $example_index);
          $value = sprintf($value_format, $project_funding_id);
          $fields[$key] = $value;
        }
      }
      return $fields;
    });

    return new JsonResponse($examples);
  }
}