<?php

namespace Drupal\db_search_api\Controller;

use PDO;

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

  public static function reviewFields(PDO $pdo): array {

    $fields = [];
    $queries = [
      'conversion_years' => 'SELECT DISTINCT Year AS [value], Year AS [label] FROM CurrencyRate ORDER BY Year DESC'
    ];

    foreach ($queries as $key => $value) {
      $fields[$key] = $pdo->query($value)->fetchAll(PDO::FETCH_ASSOC);
    }

    return $fields;
  }

  public static function reviewSearchResults(PDO $pdo, array $parameters): array {

    $search_id = null;

    $parameters['sort_column'] = self::SORT_COLUMN_MAP[$parameters['sort_column']] ?? 'title';

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
      $output_parameters
    );

    $results = [];

    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {

        $results[] = [
          'project_id'            => $row['ProjectID'] ?? NULL,
          'project_title'         => $row['Title'] ?? '',
          'pi_name'               => implode(', ', array_filter([
                                          $row['piLastName'] ?? '',
                                          $row['piFirstName'] ?? ''
                                        ])),
          'institution'           => $row['institution'] ?? '',
          'country'               => $row['country'] ?? '',
          'country_name'          => $row['CountryName'] ?? '', // ✅ FIXED
          'funding_organization'  => $row['FundingOrgShort'] ?? '',
          'funding_org_name'      => $row['FundingOrg'] ?? '',
          'award_code'            => $row['AwardCode'] ?? '',
        ];
      }
    }

    return [
      'data_upload_id' => $parameters['data_upload_id'] ?? NULL,
      'search_id'      => $output_parameters['search_id']['value'] ?? NULL,
      'results'        => $results,
    ];
  }

  public static function reviewSponsorUploads(PDO $pdo) {

    $results = [];
    $stmt = $pdo->prepare('SET NOCOUNT ON; EXECUTE GetDataUploadInStaging');

    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {

        $results[] = [
          'data_upload_id'    => $row['DataUploadID'] ?? NULL,
          'type'              => $row['Type'] ?? '',
          'sponsor_code'      => $row['SponsorCode'] ?? '',
          'funding_year'      => $row['FundingYear'] ?? '',
          'project_count'     => $row['ProjectFundingCount'] ?? 0,
          'received_date'     => $row['ReceivedDate'] ?? '',
          'stage_upload_date' => $row['UploadToStageDate'] ?? '',
          'note'              => $row['Note'] ?? '',
          'counts'            => [],
        ];
      }
    }

    foreach ($results as &$result) {

      $stmt = $pdo->prepare('SET NOCOUNT ON; EXECUTE GetDataUploadSummary @DataUploadID = :data_upload_id');
      $stmt->bindParam(':data_upload_id', $result['data_upload_id']);

      if ($stmt->execute()) {
        $counts = $stmt->fetch(PDO::FETCH_ASSOC) ?: [];

        $result['counts'] = [
          'project_count'                      => $counts['ProjectCount'] ?? 0,
          'project_funding_count'              => $counts['ProjectFundingCount'] ?? 0,
          'project_funding_investigator_count' => $counts['ProjectFundingInvestigatorCount'] ?? 0,
          'project_cso_count'                  => $counts['ProjectCSOCount'] ?? 0,
          'project_cancer_type_count'          => $counts['ProjectCancerTypeCount'] ?? 0,
          'project_type_count'                 => $counts['Project_ProjectTypeCount'] ?? 0,
          'project_abstract_count'             => $counts['ProjectAbstractCount'] ?? 0,
        ];
      }
    }

    return $results;
  }

  public static function reviewSyncProd(PDO $pdo, array $parameters) {
    try {
      $stmt = $pdo->prepare('SET NOCOUNT ON; EXECUTE DataUpload_SyncProd @DataUploadID=:data_upload_id');
      $stmt->bindParam(':data_upload_id', $parameters['data_upload_id']);

      return $stmt->execute();
    }
    catch (\PDOException $e) {
      error_log($e->getMessage());
      return false;
    }
  }

  public static function reviewDeleteImport(PDO $pdo, array $parameters) {
    try {
      $stmt = $pdo->prepare('SET NOCOUNT ON; EXECUTE DataUpload_DeleteDataImportFromStaging @DataUploadStatusID=:data_upload_id');
      $stmt->bindParam(':data_upload_id', $parameters['data_upload_id'], PDO::PARAM_INT);

      return $stmt->execute();
    }
    catch (\PDOException $e) {
      error_log($e->getMessage());
      return false;
    }
  }
}
