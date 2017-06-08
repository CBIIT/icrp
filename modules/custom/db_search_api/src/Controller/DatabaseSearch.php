<?php

/**
 * @file
 * Contains \Drupal\db_search_api\Controller\DatabaseSearch
 */
namespace Drupal\db_search_api\Controller;

use PDO;
use PDOStatement;

/**
 * Static functions for db_search_api routes.
 */
class DatabaseSearch {

  private const SEARCH_PARAMETER_MAP = [
    'page_size'                  => 'PageSize',
    'page_number'                => 'PageNumber',
    'sort_column'                => 'SortCol',
    'sort_direction'             => 'SortDirection',
    'search_terms'               => 'Terms',
    'search_type'                => 'TermSearchType',
    'years'                      => 'YearList',
    'institution'                => 'Institution',
    'pi_first_name'              => 'piFirstName',
    'pi_last_name'               => 'piLastName',
    'pi_orcid'                   => 'piORCiD',
    'award_code'                 => 'AwardCode',
    'countries'                  => 'CountryList',
    'states'                     => 'StateList',
    'cities'                     => 'CityList',
    'funding_organization_types' => 'FundingOrgTypeList',
    'funding_organizations'      => 'FundingOrgList',
    'is_childhood_cancer'        => 'IsChildhood',
    'cancer_types'               => 'CancerTypeList',
    'project_types'              => 'ProjectTypeList',
    'cso_research_areas'         => 'CSOList',
  ];

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
  public static function getSearchFields(PDO $pdo): array {

    $fields = [];
    $queries = [
      'years'                       => 'SELECT MIN(CalendarYear) AS min_year, MAX(CalendarYear) AS max_year FROM ProjectFundingExt',
      'countries'                   => 'SELECT Abbreviation AS [value], Name AS [label] FROM Country ORDER BY [label]',
      'states'                      => 'SELECT Abbreviation AS [value], Name AS [label], Country AS [group_1] FROM State ORDER BY [label]',
      'cities'                      => 'SELECT DISTINCT City AS [value], City AS [label], State AS [group_1], Country AS [group_2] FROM Institution WHERE len(City) > 0 ORDER BY [label]',
      'funding_organization_types'  => 'SELECT FundingOrgType AS [value], FundingOrgType AS [label] FROM lu_FundingOrgType',
      'funding_organizations'       => 'SELECT FundingOrgID AS [value], Name AS [label], SponsorCode AS [group_1], Country AS [group_2], \'Funding\' AS [group_3] FROM FundingOrg WHERE LastImportDate IS NOT NULL',
      'cancer_types'                => 'SELECT CancerTypeID AS [value], Name AS [label] FROM CancerType ORDER BY [label]',
      'project_types'               => 'SELECT ProjectType AS [value], ProjectType AS [label] FROM ProjectType',
      'cso_research_areas'          => 'SELECT Code AS [value], Code + \' \' + Name AS [label], CategoryName AS [group_1], \'All Areas\' as [group_2] FROM CSO ORDER BY sortOrder, value',
      'conversion_years'            => 'SELECT DISTINCT Year AS [value], Year AS [label] FROM CurrencyRate ORDER BY Year DESC',
    ];

    // map query results to field values
    foreach ($queries as $key => $value) {
      $fields[$key] = $pdo->query($value)->fetchAll(PDO::FETCH_ASSOC);
    }

    // create trees for funding organizations and cso research areas
    $funding_organizations = TreeBuilder::flattenTree(TreeBuilder::createTree($fields['funding_organizations'], 3, 'group_', 'All %s Organizations')[0]);
    $fields['funding_organizations'] = [TreeBuilder::sortTree($funding_organizations)];
    $fields['cso_research_areas'] = [TreeBuilder::flattenTree(TreeBuilder::createTree($fields['cso_research_areas'], 2)[0])];

    // provide an array of years
    $min_year = $fields['years'][0]['min_year'];
    $max_year = $fields['years'][0]['max_year'];

    $fields['years'] = array_map(function($year) {
      return [
        'value' => intval($year),
        'label' => strval($year),
      ];
    }, range($max_year, $min_year, -1));

    // provide parameters for is_childhood_cancer
    $fields['is_childhood_cancer'] = [
      ['value' => 1, 'label' => 'Yes'],
      ['value' => 0, 'label' => 'No'],
    ];

    return $fields;
  }

  /**
  * Retrieves search parameters based on a specific search id
  * @param int $search_id - The search ID for this request
  * @param PDO $pdo - The PDO connection object
  * @return array $results an array containing search parameters for the specified search id
  * @api
  */
  public static function getSearchParameters(PDO $pdo, array $parameters = ['search_id' => -1]): array {

    $stmt = PDOBuilder::createPreparedStatement(
      $pdo,
      'SELECT * FROM SearchCriteria
        WHERE SearchCriteriaID = :search_id',
      $parameters
    );

    $results = [];
    if ($stmt->execute())
      $results = $stmt->fetch(PDO::FETCH_ASSOC);

    function split($string) {
      return $string ? explode(',', $string) : null;
    }

    return $results ? array_filter([
      'search_terms'                 => $results['Terms'],
      'search_type'                  => $results['TermSearchType'],
      'years'                        => split($results['YearList']),
      'institution'                  => $results['Institution'],
      'pi_first_name'                => $results['piLastName'],
      'pi_last_name'                 => $results['piFirstName'],
      'pi_orcid'                     => $results['piORCiD'],
      'award_code'                   => $results['AwardCode'],
      'countries'                    => split($results['CountryList']),
      'states'                       => split($results['StateList']),
      'cities'                       => split($results['CityList']),
      'funding_organizations'        => split($results['FundingOrgList']),
      'funding_organization_types'   => split($results['FundingOrgTypeList']),
      'is_childhood_cancer'          => $results['IsChildhood'],
      'cancer_types'                 => split($results['CancerTypeList']),
      'project_types'                => split($results['ProjectTypeList']),
      'cso_research_areas'           => split($results['CSOList']),
    ]) : [];
  }

  /**
   * Retrieves search parameters as a table suitable for display to the client
   *
   * @param PDO $pdo
   * @param array $parameters
   * @return array
   */
  public static function getSearchParametersAsTable(PDO $pdo, array $parameters = ['search_id' => -1]): array {

    $query_defaults = 'SET NOCOUNT ON; ';
    $stmt = PDOBuilder::createPreparedStatement(
      $pdo,
      $query_defaults .
      'EXECUTE GetSearchCriteriaBySearchID
        @SearchID=:search_id',
      $parameters
    );

    if ($stmt->execute()) {
        return $stmt->fetchAll(PDO::FETCH_NUM);
    }

   return [];
  }

  /**
  * Retrieves analytics for a specific facet of the search
  * @param int $searchId - The search ID for this request
  * @param string $type - The type of data to retrieve
  * @param int $year - The year for which this data should be retrieved
  * @param PDO $pdo - The PDO connection object
  * @return array An array containining analytics data for the specified facet
  * @api
  */
  public static function getAnalytics(PDO $pdo, array $parameters): array {

    $pdo->setAttribute(PDO::SQLSRV_ATTR_FETCHES_NUMERIC_TYPE, true);
    $pdo->setAttribute(PDO::SQLSRV_ATTR_ENCODING, PDO::SQLSRV_ENCODING_SYSTEM);

    // define queries to be performed for each type
    $queries = [
      'project_counts_by_country'                     => 'EXECUTE GetProjectCountryStatsBySearchID      @SearchID = :search_id, @Year = :year, @ResultCount = :results_count, @ResultAmount = :results_amount, @Type = Count',
      'project_counts_by_cso_research_area'           => 'EXECUTE GetProjectCSOStatsBySearchID          @SearchID = :search_id, @Year = :year, @ResultCount = :results_count, @ResultAmount = :results_amount, @Type = Count',
      'project_counts_by_cancer_type'                 => 'EXECUTE GetProjectCancerTypeStatsBySearchID   @SearchID = :search_id, @Year = :year, @ResultCount = :results_count, @ResultAmount = :results_amount, @Type = Count',
      'project_counts_by_type'                        => 'EXECUTE GetProjectTypeStatsBySearchID         @SearchID = :search_id, @Year = :year, @ResultCount = :results_count, @ResultAmount = :results_amount, @Type = Count',
      'project_counts_by_year'                        => 'EXECUTE GetProjectAwardStatsBySearchID        @SearchID = :search_id, @Year = :year, @ResultCount = :results_count, @ResultAmount = :results_amount',

      'project_funding_amounts_by_country'            => 'EXECUTE GetProjectCountryStatsBySearchID      @SearchID = :search_id, @Year = :year, @ResultCount = :results_count, @ResultAmount = :results_amount, @Type = Amount',
      'project_funding_amounts_by_cso_research_area'  => 'EXECUTE GetProjectCSOStatsBySearchID          @SearchID = :search_id, @Year = :year, @ResultCount = :results_count, @ResultAmount = :results_amount, @Type = Amount',
      'project_funding_amounts_by_cancer_type'        => 'EXECUTE GetProjectCancerTypeStatsBySearchID   @SearchID = :search_id, @Year = :year, @ResultCount = :results_count, @ResultAmount = :results_amount, @Type = Amount',
      'project_funding_amounts_by_type'               => 'EXECUTE GetProjectTypeStatsBySearchID         @SearchID = :search_id, @Year = :year, @ResultCount = :results_count, @ResultAmount = :results_amount, @Type = Amount',
      'project_funding_amounts_by_year'               => 'EXECUTE GetProjectAwardStatsBySearchID        @SearchID = :search_id, @Year = :year, @ResultCount = :results_count, @ResultAmount = :results_amount',
    ];

    // define which columns to retrieve from the query results
    $column_maps = [
      'project_counts_by_country' => [
        'label' => 'country',
        'data'  => [
          'project_count'   => 'Count',
        ],
      ],

      'project_counts_by_cso_research_area' => [
        'label' => 'categoryName',
        'data'  => [
          'project_count'   => 'ProjectCount',
          'relevance'       => 'Relevance',
        ],
      ],

      'project_counts_by_cancer_type' => [
        'label' => 'CancerType',
        'data'  => [
          'project_count'   => 'ProjectCount',
          'relevance'       => 'Relevance',
        ],
      ],

      'project_counts_by_type' => [
        'label' => 'ProjectType',
        'data'  => [
          'project_count'   => 'Count',
        ],
      ],

      'project_counts_by_year' => [
        'label' => 'Year',
        'data'  => [
          'project_count'   => 'Count',
        ],
      ],


      'project_funding_amounts_by_country' => [
        'label' => 'country',
        'data'  => [
          'funding_amount'  => 'USDAmount',
        ],
      ],

      'project_funding_amounts_by_cso_research_area' => [
        'label' => 'categoryName',
        'data' => [
          'funding_amount'  => 'USDAmount',
        ],
      ],

      'project_funding_amounts_by_cancer_type' => [
        'label' => 'CancerType',
        'data' => [
          'funding_amount'  => 'USDAmount',
        ],
      ],

      'project_funding_amounts_by_type' => [
        'label' => 'ProjectType',
        'data' => [
          'funding_amount'  => 'USDAmount',
        ],
      ],

      'project_funding_amounts_by_year' => [
        'label' => 'Year',
        'data' => [
          'funding_amount'  => 'amount',
        ],
      ],
    ];

    $type = $parameters['type'];

    // select which query to perform
    if (!array_key_exists($type, $queries)) return [];

    $output_parameters = [
      'results_count'  => [
        'value' => 0,
        'type'  => PDO::PARAM_INT,
      ],
      'results_amount' => [
        'value' => 0,
        'type'  => PDO::PARAM_STR,
      ],
    ];

    $query_defaults = 'SET NOCOUNT ON; ';
    $stmt = PDOBuilder::createPreparedStatement(
      $pdo,
      $query_defaults . $queries[$type],
      $parameters,
      $output_parameters
    );

    // execute statement and update output object
    $results = [];
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {

        $column_map = $column_maps[$type];
        $item = [
          'label' => $row[$column_map['label']],
          'data' => [],
        ];

        foreach($column_map['data'] as $key => $database_column)
          $item['data'][$key] = floatval($row[$database_column]);

        array_push($results, $item);
      }
    }

    $output = [
      'search_id'      => intval($parameters['search_id']),
      'results'        => $results,
    ];

    // add either results_count or results_amount to the output
    if (strpos($type, 'project_counts') !== false)
      $key = 'results_count';

    else if (strpos($type, 'project_funding_amounts') !== false)
      $key = 'results_amount';

    $output[$key] = floatval($output_parameters[$key]['value']);

    return $output;
  }


  /**
  * Retrieves search results for the given parameters
  * @param array $parameters - The search parameters
  * @param PDO $pdo - The PDO connection object
  * @return array An array containining search results
  * @api
  */
  public static function getSearchResults(PDO $pdo, array $parameters): array {

    $parameters['sort_column'] = self::SORT_COLUMN_MAP[$parameters['sort_column']];
    $output_parameters = [
      'search_id' => [
        'value' => 0,
        'type'  => PDO::PARAM_INT,
      ],
    ];

    $query_defaults = 'SET NOCOUNT ON; ';
    $query_string = '
      EXECUTE GetProjectsByCriteria
        @PageSize             = :page_size,
        @PageNumber           = :page_number,
        @SortCol              = :sort_column,
        @SortDirection        = :sort_direction,
        @terms                = :search_terms,
        @termSearchType       = :search_type,
        @yearList             = :years,
        @institution          = :institution,
        @piFirstName          = :pi_first_name,
        @piLastName           = :pi_last_name,
        @piORCiD              = :pi_orcid,
        @awardCode            = :award_code,
        @countryList          = :countries,
        @stateList            = :states,
        @cityList             = :cities,
        @FundingOrgTypeList   = :funding_organization_types,
        @fundingOrgList       = :funding_organizations,
        @cancerTypeList       = :cancer_types,
        @projectTypeList      = :project_types,
        @IsChildhood          = :is_childhood_cancer,
        @CSOList              = :cso_research_areas,
        @searchCriteriaID     = :search_id,
        @ResultCount          = NULL';

    $stmt = PDOBuilder::createPreparedStatement(
      $pdo,
      $query_defaults . $query_string,
      $parameters,
      $output_parameters);

    $results = [];
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $results[] = [
          'project_id'            => $row['ProjectID'],
          'project_title'         => $row['Title'],
          'pi_name'               => "$row[piLastName], $row[piFirstName]",
          'institution'           => $row['institution'],
          'country'               => $row['country'],
          'funding_organization'  => $row['FundingOrgShort'],
          'award_code'            => $row['AwardCode'],
        ];
      }
    }

    $search_id = $output_parameters['search_id']['value'];

    return [
      'search_id'           => $search_id,
      'results'             => $results,
      'search_parameters'   => self::getSearchParametersAsTable($pdo, ['search_id' => $search_id]),
    ];
  }


  /**
  * Retrieves sorted and paginated results for an existing search
  * @param array $parameters - The sorting/pagination parameters
  * @param PDO $pdo - The PDO connection object
  * @return array An array containining search results
  * @api
  */
  public static function getSortedPaginatedResults(PDO $pdo, array $parameters): array {

    $parameters['sort_column'] = self::SORT_COLUMN_MAP[$parameters['sort_column']];

    $query_defaults = 'SET NOCOUNT ON; ';
    $query_string = '
      EXECUTE GetProjectsBySearchID
        @SearchID       = :search_id,
        @PageSize       = :page_size,
        @PageNumber     = :page_number,
        @SortCol        = :sort_column,
        @SortDirection  = :sort_direction,
        @ResultCount    = NULL';

    $stmt = PDOBuilder::createPreparedStatement(
      $pdo,
      $query_defaults . $query_string,
      $parameters);

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

    $search_id = intval($parameters['search_id']);
    return [
      'search_id'           => $search_id,
      'results'             => $results,
      'search_parameters'   => self::getSearchParametersAsTable($pdo, ['search_id' => $search_id]),
    ];
  }

  /**
   * Retrieves a summary of the search results given a particular search id
   *
   * @param PDO $pdo
   * @param array $parameters
   * @return array
   */
  public static function getSearchSummary(PDO $pdo, array $parameters = ['search_id' => -1]): array {

    $query_defaults = 'SET NOCOUNT ON; ';
    $stmt = PDOBuilder::createPreparedStatement(
      $pdo,
      $query_defaults .
      'EXECUTE GetProjectSearchSummaryBySearchID
        @SearchID = :search_id',
      $parameters);

    if ($stmt->execute()) {
      $summary = $stmt->fetch(PDO::FETCH_ASSOC);
      return [
        'project_count'         => $summary['TotalProjectCount'],
        'related_project_count' => $summary['TotalRelatedProjectCount'],
        'last_budget_year'      => $summary['LastBudgetYear'],
      ];
    }

    return [];
  }
}
