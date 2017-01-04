<?php
/**
 * @file
 * Contains \Drupal\db_project_view\Controller\ProjectViewController.
 */
namespace Drupal\db_project_view\Controller;
use Drupal\Core\Controller\ControllerBase;
USE Drupal\Core\Database\Database;
use PDO;

class ProjectViewController extends ControllerBase {


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

    $cfg = [];
    $sys_cfg = \Drupal::config('icrp_database');
    foreach(['driver', 'host', 'port', 'database', 'username', 'password'] as $key) {
       $cfg[$key] = $drupal_cfg->get($key);
    }

    // connection string
    $cfg['data_source'] =
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
      $cfg['data_source'],
      $cfg['username'],
      $cfg['password'],
      $cfg['options']
    );
  }

  public function get_project_cancer_types($pdo, $project_id) {
    $stmt = $pdo->prepare("
      SELECT DISTINCT
      ct.Name AS cancer_type,
      ct.SiteURL AS cancer_type_url

      FROM Project p
      JOIN ProjectCancerType pct ON pct.ProjectID = p.ProjectID
      JOIN CancerType ct ON ct.CancerTypeID = pct.CancerTypeID
      WHERE p.ProjectID = :project_id");

    $stmt->execute([':project_id' => $project_id]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
  }

  public function get_project_cso_areas($pdo, $project_id) {
    $stmt = $pdo->prepare("
      SELECT DISTINCT
      c.Code AS cso_code,
      c.CategoryName AS cso_category,
      c.Name AS cso_name

      FROM Project p
      JOIN ProjectCSO pc ON pc.ProjectID = p.ProjectID
      JOIN CSO c ON c.Code = pc.CSOCode
      WHERE p.ProjectID = :project_id");
    $stmt->execute([':project_id' => $project_id]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
  }

  public function get_project_details($pdo, $project_id) {
    $stmt = $pdo->prepare("
      SELECT DISTINCT
      pf.Title AS project_title,
      p.ProjectStartDate AS project_start_date,
      p.ProjectEndDate AS project_end_date,
      fm.Title AS funding_mechanism,
      CONCAT(pfi.LastName, ', ', pfi.FirstName) AS principal_investigator,
      i.Name AS institution,
      i.City AS city,
      i.State AS state,
      i.Country AS country,
      p.AwardCode AS award_code,
      fo.Name AS funding_organization,
      pf.AltAwardCode AS alt_award_code,
      pf.BudgetStartDate AS budget_start_date,
      pf.BudgetEndDate AS budget_end_date,
      pa.TechAbstract AS technical_abstract,
      pa.publicAbstract AS public_abstract

      FROM Project p
      JOIN ProjectFunding pf ON pf.ProjectID = p.ProjectID
      JOIN ProjectAbstract pa ON pa.ProjectAbstractID = pf.ProjectAbstractID
      JOIN ProjectFundingInvestigator pfi ON pfi.ProjectFundingID = pf.ProjectFundingID
      JOIN Institution i ON i.InstitutionID = pfi.InstitutionID
      JOIN FundingOrg fo ON fo.FundingOrgID = pf.FundingOrgID
      LEFT JOIN FundingMechanism fm ON fm.FundingMechanismID = p.FundingMechanismID
      WHERE p.ProjectID = :project_id");

    $stmt->execute([':project_id' => $project_id]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
  }

  public function get_project($project_id) {
    $pdo = self::get_connection();

    $results = [
      'project_title' => [],
      'principal_investigator' => [],
      'institution' => [],
      'city' => [],
      'state' => [],
      'country' => [],
      'award_code' => [],
      'funding_organization' => [],
      'alt_award_code' => [],
      'budget_start_date' => [],
      'budget_end_date' => [],
      'project_start_date' => [],
      'project_end_date' => [],
      'funding_mechanism' => [],
      'technical_abstract' => [],
      'public_abstract' => [],
      'cancer_types' => [],
      'cso_areas' => []
    ];

    $project_details = self::get_project_details($pdo, $project_id);

    foreach($project_details as $row) {
      foreach (array_keys($row) as $key) {

        $value = trim($row[$key]);
        if ($value) {
          array_push($results[$key], $value);
        }
      }
    }

    $results['cancer_types'] = self::get_project_cancer_types($pdo, $project_id);
    $results['cso_areas'] = self::get_project_cso_areas($pdo, $project_id);
    return $results;
  }

  public function content($projectID) {
    $results = self::get_project($projectID);

    return [
      '#theme' => 'db_project_view',

      '#project_title' => $results['project_title'],
      '#principal_investigator' => $results['principal_investigator'],
      '#institution' => $results['institution'],
      '#city' => $results['city'],
      '#state' => $results['state'],
      '#country' => $results['country'],
      '#award_code' => $results['award_code'],
      '#alt_award_code' => $results['alt_award_code'],
      '#funding_organization' => $results['funding_organization'],
      '#budget_start_date' => $results['budget_start_date'],
      '#budget_end_date' => $results['budget_end_date'],
      '#project_start_date' => $results['project_start_date'],
      '#project_end_date' => $results['project_end_date'],
      '#funding_mechanism' => $results['funding_mechanism'],
      '#technical_abstract' => $results['technical_abstract'],
      '#public_abstract' => $results['public_abstract'],
      '#cancer_types' => $results['cancer_types'],
      '#cso_areas' => $results['cso_areas'],
      
      '#attached' => [
        'library' => [
          'db_project_view/resources'
        ],
      ],
    ];
  }
}