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
      'FundingMechanism' => 'funding_mechanism',
      'LastProjectFundingID' => 'project_funding_id',
    ],
    'project_funding_details' => [
      'ProjectFundingID' => 'project_funding_id',
      'title' => 'project_title',
      'piLastName' => 'pi_last_name',
      'piFirstName' => 'pi_first_name',
      'ORC_ID' => 'pi_orcid',
      'Institution' => 'institution',
      'City' => 'city',
      'State' => 'state', 
      'Country' => 'country', 
      'Category' => 'award_type', 
      'AltAwardCode' => 'alt_award_code', 
      'FundingOrganization' => 'funding_organization', 
      'BudgetStartDate' => 'budget_start_date', 
      'BudgetEndDate' => 'budget_end_date', 
    ],
    'cancer_types' => [
      'CancerType' => 'cancer_type',
      'Description' => 'description',
      'ICRPCode' => 'icrp_code',
      'ICD10CodeInfo' => 'icd10_code',
      'SiteURL' => 'cancer_type_url',
    ],
    'cso_research_areas' => [
      'CSOCode' => 'cso_code',
      'CategoryName' => 'cso_category',
      'CSOName' => 'cso_name',
      'ShortName' => 'cso_short_name'
    ],
  ];


  const FUNDING_FIELD_MAP = [
    'project_funding_details' => [
      'Title' => 'project_title',
      'piName' => 'pi_name',
      'ORC_ID' => 'pi_orcid',
      'Institution' => 'institution',
      'City' => 'city',
      'State' => 'state',
      'Country' => 'country',
      'Category' => 'award_type',
      'AltAwardCode' => 'alt_award_code',
      'FundingOrg' => 'funding_organization',
      'BudgetStartDate' => 'budget_start_date',
      'BudgetEndDate' => 'budget_end_date',
      'Amount' => 'funding_amount',
      'TechAbstract' => 'technical_abstract',
      'PublicAbstract' => 'public_abstract',
    ],
    'cancer_types' => [
      'CancerType' => 'cancer_type',
      'Description' => 'description',
      'ICRPCode' => 'icrp_code',
      'ICD10CodeInfo' => 'icd10_code',
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
  function get_connection($config_key = 'icrp_database') {

    $cfg = [];
    $icrp_database = \Drupal::config($config_key);
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

  public function get_project($project_id, $config_key = 'icrp_database') {
    $pdo = self::get_connection($config_key);

    $queries = [
      'project_details' => 'GetProjectDetail :project_id',
      'project_funding_details' => 'GetProjectFunding :project_id',
      'cancer_types' => 'GetProjectCancerType :project_funding_id',
      'cso_research_areas' => 'GetProjectCSO :project_funding_id',
    ];

    $stmt = $pdo->prepare($queries['project_details']);
    $stmt->execute([':project_id' => $project_id]);
    $project_funding_id = $stmt->fetch(PDO::FETCH_ASSOC)['LastProjectFundingID'];

    // map queries to return values
    return array_reduce(
      array_map(function($key, $value) use ($pdo, $project_id, $project_funding_id) {
        $stmt = $pdo->prepare($value);
        
        if (in_array($key, ['project_details', 'project_funding_details'])) {
          $stmt->execute([':project_id' => $project_id]);
        }

        elseif (in_array($key, ['cancer_types', 'cso_research_areas'])) {
          $stmt->execute([':project_funding_id' => $project_funding_id]);
        }

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


  public function get_funding($funding_id, $config_key = 'icrp_database') {
    $pdo = self::get_connection($config_key);

    $queries = [
      'project_funding_details' => 'GetProjectFundingDetail :funding_id',
      'cso_research_areas' => 'GetProjectCSO :funding_id',
      'cancer_types' => 'GetProjectCancerType :funding_id',
    ];

    // map queries to return values
    return array_reduce(
      array_map(function($key, $value) use ($pdo, $funding_id) {
        $stmt = $pdo->prepare($value);
        $stmt->execute([':funding_id' => $funding_id]);

        // map the result of each query to each template key
        return [$key => array_map(function($row) use ($key) {

          // map each field in the row to a template variable
          return array_reduce(
            array_map(function($row_key, $row_value) use ($key) {
                return [self::FUNDING_FIELD_MAP[$key][$row_key] => $row_value];
            }, array_keys($row), $row)
          , 'array_merge', []);
        }, $stmt->fetchAll(PDO::FETCH_ASSOC))];
      }, array_keys($queries), $queries),
    'array_merge', []);
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










  public function getProjectDetails($project_id) {
    $results = self::get_project($project_id);
    return self::add_cors_headers(new JsonResponse($results));
  }

  public function getProjectDetailsReview($project_id) {
    $results = self::get_project($project_id, 'icrp_load_database');
    return self::add_cors_headers(new JsonResponse($results));
  }


  public function getProjectDetailsContent($project_id) {
    return [
      '#type' => 'markup',
      '#theme' => 'project_view_component',
      '#project_id' => $project_id,
      '#data_title' => 'Project Details',
      '#data_source' => '',
      '#attached' => [
        'library' => [
          'db_project_view/project_view_resources'
        ],
      ],
    ];
  }  

  public function getProjectDetailsReviewContent($project_id) {
    return [
      '#type' => 'markup',
      '#theme' => 'project_view_component',
      '#project_id' => $project_id,
      '#data_title' => 'Data Review - Project Details',
      '#data_source' => '/review',
      '#attached' => [
        'library' => [
          'db_project_view/project_view_resources'
        ],
      ],
    ];
  }

  public function getProjectFundingDetailsContent($project_id) {
    $results = self::get_funding($project_id);
    return [
      '#theme' => 'db_funding_view',
      '#page_title' => 'Project Funding Details',
      '#funding_details' => $results['project_funding_details'][0],
      '#cancer_types' => $results['cancer_types'],
      '#cso_research_areas' => $results['cso_research_areas'],
      '#attached' => [
        'library' => [
          'db_project_view/funding_view_resources'
        ],
      ],
    ];
  }

  public function getProjectFundingDetailsReviewContent($project_id) {
    $results = self::get_funding($project_id, 'icrp_load_database');
    return [
      '#theme' => 'db_funding_view',
      '#page_title' => 'Data Review - Project Funding Details',
      '#funding_details' => $results['project_funding_details'][0],
      '#cancer_types' => $results['cancer_types'],
      '#cso_research_areas' => $results['cso_research_areas'],
      '#attached' => [
        'library' => [
          'db_project_view/funding_view_resources'
        ],
      ],
    ];

  }




}
