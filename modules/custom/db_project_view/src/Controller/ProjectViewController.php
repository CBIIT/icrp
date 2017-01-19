<?php
/**
 * @file
 * Contains \Drupal\db_project_view\Controller\ProjectViewController.
 */
namespace Drupal\db_project_view\Controller;
use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;

class ProjectViewController extends ControllerBase {

  /** Field mappings of database results to template variables */
  const FIELD_MAP = [
    'project_details' => [
      'Title' => 'project_title',
      'AwardCode' => 'award_code',
      'ProjectStartDate' => 'project_start_date',
      'ProjectEndDate' => 'project_end_date',
      'TechAbstract' => 'technical_abstract',
      'PublicAbstract' => 'public_abstract',
      'FundingMechanism' => 'funding_mechanism'
    ],
    'project_funding_details' => [
      'ProjectFundingID' => 'project_funding_id',
      'title' => 'project_title',
      'piLastName' => 'pi_last_name',
      'piFirstName' => 'pi_first_name',
      'Institution' => 'institution',
      'City' => 'city',
      'State' => 'state', 
      'Country' => 'country', 
      'AwardType' => 'award_type', 
      'AltAwardCode' => 'alt_award_code', 
      'FundingOrganization' => 'funding_organization', 
      'BudgetStartDate' => 'budget_start_date', 
      'BudgetEndDate' => 'budget_end_date', 
    ],
    'cancer_types' => [
      'CancerType' => 'cancer_type',
      'SiteURL' => 'cancer_type_url',
    ],
    'cso_research_areas' => [
      'CSOCode' => 'cso_code',
      'CategoryName' => 'cso_category',
      'CSOName' => 'cso_name',
      'ShortName' => 'cso_short_name'
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

  public function get_project($project_id) {
    $pdo = self::get_connection();

    $queries = [
      'project_details' => 'GetProjectDetail :project_id',
      'project_funding_details' => 'GetProjectFunding :project_id',
      'cancer_types' => 'GetProjectCancerType :project_id',
      'cso_research_areas' => 'GetProjectCSO :project_id',
    ];

    // map queries to return values
    return array_reduce(
      array_map(function($key, $value) use ($pdo, $project_id) {
        $stmt = $pdo->prepare($value);
        $stmt->execute([':project_id' => $project_id]);

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


  public function getProjectDetails($project_id) {
    $results = self::get_project($project_id);
    return self::add_cors_headers(new JsonResponse($results));
  }


  public function getProjectFundingDetails() {
    
  }


  public function getProjectDetailsContent($project_id) {
    return [
      '#type' => 'markup',
//      '#markup' => "<div id=\"project-view-component\" data-project=\"{$project_id}\"></div>",
      '#theme' => 'project_view_component',
      '#project_id' => $project_id,
      '#attached' => [
        'library' => [
          'db_project_view/project_view_resources'
        ],
      ],
    ];
  }  

  public function getProjectDetailsContentDeprecated($project_id) {
    $results = self::get_project($project_id);
    return [
      '#theme' => 'db_project_view',
      '#project_details' => $results['project_details'][0],
      '#project_funding_details' => $results['project_funding_details'],
      '#cancer_types' => $results['cancer_types'],
      '#cso_research_areas' => $results['cso_research_areas'],
      '#attached' => [
        'library' => [
          'db_project_view/resources'
        ],
      ],
    ];
  }

  public function getProjectFundingDetailsContent() {

  }
}