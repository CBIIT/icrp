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
  * Retrieves sorted and paginated results given a data upload id
  * @param array $parameters - The sorting/pagination parameters
  * @param PDO $pdo - The PDO connection object
  * @return array An array containining search results
  * @api
  */
  public static function reviewSearchResults(PDO $pdo, array $parameters): array {

    $parameters['sort_column'] = self::SORT_COLUMN_MAP[$parameters['sort_column']];
    $output_parameters = [
      'search_id' => [
        'value' => $search_id,
        'type'  => PDO::PARAM_INT,
      ],
    ];

    $query_defaults = 'SET NOCOUNT ON; ';
    $query_string = '
      EXECUTE GetProjectsByDataUploadID
        @DataUploadID       = :data_upload_id,
        @PageSize           = :page_size,
        @PageNumber         = :page_number,
        @SortCol            = :sort_column,
        @SortDirection      = :sort_direction,
        @searchCriteriaID   = :search_id,
        @ResultCount        = NULL';

    $stmt = PDOBuilder::createPreparedStatement(
      $pdo,
      $query_defaults . $query_string,
      $parameters,
      $output_parameters);

    $results = [];
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        array_push($results, [
          'project_id'            => $row['ProjectID'],
          'project_title'         => $row['Title'],
          'pi_name'               => implode(', ', array_filter([$row['piLastName'], $row['piFirstName']])),
          'institution'           => $row['institution'],
          'country'               => $row['country'],
          'funding_organization'  => $row['FundingOrgShort'],
          'award_code'            => $row['AwardCode'],
        ]);
      }
    }

    return [
      'data_upload_id'    => $parameters['data_upload_id'],
      'search_id'         => $output_parameters['search_id']['value'],
      'results'           => $results,
    ];
  }



  /**
  * Retrieves a table containing available data uploads for review
  * @param array $parameters - The sorting/pagination parameters
  * @param PDO $pdo - The PDO connection object
  * @api
  */
  public static function reviewSponsorUploads(PDO $pdo) {

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
//        'project_search_count'                => $counts['ProjectSearchCount'],
        ];
      }
    }

    return $results;
  }

  /**
  * Calls the DataUpload_SyncProd stored procedure with the given data upload id
  * @param array $parameters - The data upload id (data_upload_id)
  * @param PDO $pdo - The PDO connection object
  * @api
  */
  public static function reviewSyncProd(PDO $pdo, array $parameters) {
    try {
      $stmt = $pdo->prepare('SET NOCOUNT ON; EXECUTE DataUpload_SyncProd @DataUploadID=:data_upload_id');
      $stmt->bindParam(':data_upload_id', $parameters['data_upload_id']);
     if ($stmt->execute()) { 
        return true;
      }
      return false; 
    } 
    catch(\PDOException $e) {
      error_log($e->getMessage());
      return false;
    }
  }
}
