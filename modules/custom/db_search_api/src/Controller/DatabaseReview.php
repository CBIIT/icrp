<?php

/**
 * @file
 * Contains \Drupal\db_search_api\Controller\DatabaseSearch
 */
namespace Drupal\db_search_api\Controller;

use PDO;

/**
 * Static functions for db_search_api routes.
 *
 */
class DatabaseReview {

  private const SORT_COLUMN_MAP = [
    'project_title'              => 'title',
    'pi_name'                    => 'pi',
    'institution'                => 'Inst',
    'city'                       => 'city',
    'state'                      => 'state',
    'country'                    => 'country',
    'funding_organization'       => 'FO',
    'award_code'                 => 'code',
  ];

  /**
  * Retrieves valid field values to be used as query parameters
  * @param PDO $pdo - The PDO connection object
  * @return array $fields
  */
  public static function reviewFields(PDO $pdo): array {

    $fields = [];
    $queries = ['conversion_years' => 'SELECT DISTINCT Year AS [value], Year AS [label] FROM CurrencyRate ORDER BY Year DESC'];

    // map query results to field values
    foreach ($queries as $key => $value) {
      $fields[$key] = $pdo->query($value)->fetchAll(PDO::FETCH_ASSOC);
    }

    return $fields;
  }


  /**
  * Retrieves analytics for a specific facet of the search
  * @param int $data_upload_id - The search ID for this request
  * @param string $type - The type of data to retrieve
  * @param int $year - The year for which this data should be retrieved
  * @param PDO $pdo - The PDO connection object
  * @return array An array containining analytics data for the specified facet
  * @api
  */
  public static function reviewAnalytics(PDO $pdo, array $parameters): array {

    $data_upload_id = $parameters['data_upload_id'];
    $type           = $parameters['type'];
    $year           = $parameters['year'];

    $queryDefaults = 'SET NOCOUNT ON;';

    $queries = [
      'project_counts_by_country'           => 'EXECUTE GetProjectCountryStatsByDataUploadID    @DataUploadID = :data_upload_id, @ResultCount = :total',
      'project_counts_by_cso_research_area' => 'EXECUTE GetProjectCSOStatsByDataUploadID        @DataUploadID = :data_upload_id, @ResultCount = :total',
      'project_counts_by_cancer_type'       => 'EXECUTE GetProjectCancerTypeStatsByDataUploadID @DataUploadID = :data_upload_id, @ResultCount = :total',
      'project_counts_by_type'              => 'EXECUTE GetProjectTypeStatsByDataUploadID       @DataUploadID = :data_upload_id, @ResultCount = :total',
      'project_funding_amounts_by_year'     => 'EXECUTE GetProjectAwardStatsByDataUploadID      @DataUploadID = :data_upload_id, @Year = :year, @Total = :total',
    ];

    // select which query to perform
    if (!array_key_exists($type, $queries)) { return []; }
    $stmt = $pdo->prepare($queryDefaults . $queries[$type]);

    // define which columns to retrieve
    $column_mappings = [
      'project_counts_by_country' => [
        'label' => 'country',
        'data' => [
          'count' => 'Count',
        ],
      ],
      
      'project_counts_by_cso_research_area' => [
        'label' => 'categoryName', 
        'data' => [
          'count' => 'ProjectCount', 
          'relevance' => 'Relevance',
        ],
      ],
      
      'project_counts_by_cancer_type' => [
        'label' => 'CancerType',     
        'data' => [
          'count' => 'ProjectCount',
          'relevance' => 'Relevance',
        ],
      ],
      
      'project_counts_by_type' => [
        'label' => 'ProjectType',
        'data' => [
          'count' => 'Count',
        ],
      ],
      
      'project_funding_amounts_by_year' => [
        'label' => 'Year',
        'data' => [
          'amount' => 'amount',
        ],
      ],
    ];

    // define output object
    $output = [
      'data_upload_id' => intval($data_upload_id),
      'results' => [],
      'total' => 0
    ];

    // bind parameters to statement
    $stmt->bindParam(':data_upload_id', $data_upload_id);
    $stmt->bindParam(':total', $output['total'], PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT, 1000);
    $type === 'project_funding_amounts_by_year' and $stmt->bindParam(':year', $year);

    // execute statement and update output object
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {

        $column_map = $column_mappings[$type];
        $label = $row[$column_map['label']];

        $data = [];
        foreach($column_map['data'] as $key => $value)
          $data[$key] = floatval($row[$value]);

        array_push($output['results'], [
          'label' => $label,
          'data' => $data,
        ]);
      }
    }

    return $output;
  }


  /**
  * Retrieves sorted and paginated results given a data upload id
  * @param array $parameters - The sorting/pagination parameters
  * @param PDO $pdo - The PDO connection object
  * @return array An array containining search results
  * @api
  */
  public function reviewSearchResults(PDO $pdo, array $parameters): array {

    $parameters['sort_column'] = self::SORT_COLUMN_MAP[$parameters['sort_column']];
    $stmt = $pdo->prepare('SET NOCOUNT ON; EXECUTE GetProjectsByDataUploadID
      @DataUploadID       = :data_upload_id,
      @PageSize           = :page_size,
      @PageNumber         = :page_number,
      @SortCol            = :sort_column,
      @SortDirection      = :sort_direction,
      @ResultCount        = :results_count,
      @searchCriteriaID   = :search_id');

    $stmt->bindParam(':results_count', $results_count, PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT, 1000);
    $stmt->bindParam(':search_id', $search_id, PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT, 1000);

    foreach($parameters as $key => &$value) {
      $stmt->bindParam(":$key", $value);
    }

    $results = [];
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        array_push($results, [
          'project_id'            => $row['ProjectID'],
          'project_title'         => $row['Title'],
          'pi_name'               => "$row[piLastName], $row[piFirstName]",
          'institution'           => $row['institution'],
          'country'               => $row['country'],
          'funding_organization'  => $row['FundingOrgShort'],
          'award_code'            => $row['AwardCode'],
        ]);
      }
    }

    $_SESSION['database_search_id'] = $search_id;

    return [
      'data_upload_id' => $parameters['data_upload_id'],
      'results_count'  => $results_count,
      'results'        => $results,
    ];    
  }



  /**
  * Retrieves a table containing available data uploads for review
  * @param array $parameters - The sorting/pagination parameters
  * @param PDO $pdo - The PDO connection object
  * @api
  */
  public function reviewSponsorUploads(PDO $pdo) {

    $results = [];
    $stmt = $pdo->prepare('SET NOCOUNT ON; EXECUTE GetDataUploadInStaging');
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        array_push($results, [
          'data_upload_id' => $row['DataUploadID'],
          'type'           => $row['Type'],
          'sponsor_code'   => $row['SponsorCode'],
          'funding_year'   => $row['FundingYear'],
          'received_date'  => $row['ReceivedDate'],
          'note'           => $row['Note'],
          'counts'         => [],
        ]);
      }
    }

    // get projects counts
    foreach($results as &$result) {
      $stmt = $pdo->prepare('SET NOCOUNT ON; EXECUTE GetDataUploadSummary @DataUploadID = :data_upload_id');
      $stmt->bindParam(':data_upload_id', $result['data_upload_id']);

      if ($stmt->execute()) {
        $counts = $stmt->fetch(PDO::FETCH_ASSOC);
        $result['counts'] = [
          'project_count'                       => $counts['ProjectCount'],
          'project_funding_count'               => $counts['ProjectFundingCount'],
          'project_funding_investigator_count'  => $counts['ProjectFundingInvestigatorCount'],
          'project_cso_count'                   => $counts['ProjectCSOCount'],
          'project_cancer_type_count'           => $counts['ProjectCancerTypeCount'],
          'project_type_count'                  => $counts['Project_ProjectTypeCount'],
          'project_abstract_count'              => $counts['ProjectAbstractCount'],
          'project_search_count'                => $counts['ProjectSearchCount'],
        ];
      }
    }

    return $results;
  }
}
