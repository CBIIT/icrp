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
  * Creates a tree from an array of data that contains groups indexed by columns
  * @param array $data - an array containing value-label pairs, as well as group identifiers
  * @param int $height - the current level of the tree being generated
  * @param string $prefix - the group prefix
  * @param string $format - the formatting string used to generate group node labels
  * @return An array containining search parameters
  */
  private static function createTree(array $data, int $height, string $prefix = 'group_', string $format = '%s'): array {

    // get group column containing root elements
    $group_key = $prefix . $height;

    // get unique group names from column
    $group_names = array_unique(array_column($data, $group_key));

    // populate the current level of the tree with group nodes
    $root = array_map(function($group_name) use ($format) {
      return [
        'value'    => $group_name,
        'label'    => sprintf($format, $group_name),
        'children' => [],
      ];
    }, array_values($group_names));

    // populate each node's children
    foreach($root as &$node) {

      // fetch rows with groups filtered by the current node's value
      $rows = array_filter($data, function($row) use ($group_key, $node) {
        return $row[$group_key] == $node['value'];
      });

      // if this is not a leaf node, generate a subtree with values based on the child group column
      if ($height > 1) {
        $node['children'] = self::createTree($rows, $height - 1, $prefix, $format);
      }

      // if this is a leaf node, generate children with values based on the contents of the 'value' column
      else {
        foreach($rows as $row) {
          array_push($node['children'], [
            'value' => $row['value'],
            'label' => $row['label'],
            'children' => [],
          ]);
        }
      }
    }

    return $root;
  }

  /**
   * Flattens nodes with only one child
   *
   */
  private static function flattenTree(&$node) {

    $children = &$node['children'];

    if (count($children) === 1 && count($children[0]['children']) === 0) {
      $node = &$children[0];
      $children = &$node['children'];
    }

    foreach($children as &$child) {
      $child = self::flattenTree($child);
    }

    return $node;
  }

  private static function countChildren($node) {
    $children = $node['children'];
    $total = count($children);

    foreach($children as $child) {
      $total += self::countChildren($child);
    }

    return $total;
  }

  private static function sortTree(&$node) {
    usort($node['children'], function ($a, $b) {
      $countA = self::countChildren($a);
      $countB = self::countChildren($b);

      if ($countA != $countB)
        return $countB - $countA;

      return strcasecmp($a['label'], $b['label']);
    });

    foreach($node['children'] as &$child) {
      $child = self::sortTree($child);
    }

    return $node;
  }

  /**
  * Retrieves valid field values to be used as query parameters
  * @param PDO $pdo - The PDO connection object
  * @return array $fields
  */
  public static function getSearchFields(PDO $pdo): array {

    $fields = [
      'years'                       => [],
      'countries'                   => [],
      'states'                      => [],
      'cities'                      => [],
      'funding_organization_types'  => [],
      'funding_organizations'       => [],
      'cancer_types'                => [],
      'is_childhood_cancer'         => [],
      'project_types'               => [],
      'cso_research_areas'          => [],
      'conversion_years'            => [],
    ];

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

    $funding_organizations = self::flattenTree(self::createTree($fields['funding_organizations'], 3, 'group_', 'All %s Organizations')[0]);
    $fields['funding_organizations'] = [self::sortTree($funding_organizations)];
    $fields['cso_research_areas'] = [self::flattenTree(self::createTree($fields['cso_research_areas'], 2)[0])];
    $fields['is_childhood_cancer'] = [
      ['value' => 1, 'label' => 'Yes'],
      ['value' => 0, 'label' => 'No'],
    ];

    $min_year = $fields['years'][0]['min_year'];
    $max_year = $fields['years'][0]['max_year'];

    $fields['years'] = array_map(function($year) {
      return [
        'value' => intval($year),
        'label' => strval($year),
      ];
    }, range($max_year, $min_year, -1));

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

    $stmt = $pdo->prepare('SELECT * FROM SearchCriteria WHERE SearchCriteriaID=:search_id');

    $results = [];
    if ($stmt->execute([':search_id' => $parameters['search_id']])) {
        $results = $stmt->fetch(PDO::FETCH_ASSOC);
    }

    function split($str) {
      return empty($str) ? null : explode(',', $str);
    }

    return empty($results) ? [false] : [
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
    ];
  }

  public static function getSearchParametersForDisplay(PDO $pdo, array $parameters = ['search_id' => -1]): array {

    $stmt = $pdo->prepare('SET NOCOUNT ON; EXECUTE GetSearchCriteriaBySearchID @SearchID=:search_id');

    $results = [];
    if ($stmt->execute([':search_id' => $parameters['search_id']])) {
        $results = $stmt->fetchAll(PDO::FETCH_NUM);
    }

    return $results;
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

    $search_id = $parameters['search_id'];
    $type      = $parameters['type'];

    $queryDefaults = 'SET NOCOUNT ON;';

    $queries = [
      'project_counts_by_country'           => 'EXECUTE GetProjectCountryStatsBySearchID    @SearchID = :search_id, @ResultCount = :results_count, @ResultAmount = :results_amount, @Year = :year, @Type = Count',
      'project_counts_by_cso_research_area' => 'EXECUTE GetProjectCSOStatsBySearchID        @SearchID = :search_id, @ResultCount = :results_count, @ResultAmount = :results_amount, @Year = :year, @Type = Count',
      'project_counts_by_cancer_type'       => 'EXECUTE GetProjectCancerTypeStatsBySearchID @SearchID = :search_id, @ResultCount = :results_count, @ResultAmount = :results_amount, @Year = :year, @Type = Count',
      'project_counts_by_type'              => 'EXECUTE GetProjectTypeStatsBySearchID       @SearchID = :search_id, @ResultCount = :results_count, @ResultAmount = :results_amount, @Year = :year, @Type = Count',
      'project_counts_by_year'              => 'EXECUTE GetProjectAwardStatsBySearchID      @SearchID = :search_id, @ResultCount = :results_count, @ResultAmount = :results_amount, @Year = :year',

      'project_funding_amounts_by_country'            => 'EXECUTE GetProjectCountryStatsBySearchID      @SearchID = :search_id, @ResultCount = :results_count, @ResultAmount = :results_amount, @Year = :year, @Type = Amount',
      'project_funding_amounts_by_cso_research_area'  => 'EXECUTE GetProjectCSOStatsBySearchID          @SearchID = :search_id, @ResultCount = :results_count, @ResultAmount = :results_amount, @Year = :year, @Type = Amount',
      'project_funding_amounts_by_cancer_type'        => 'EXECUTE GetProjectCancerTypeStatsBySearchID   @SearchID = :search_id, @ResultCount = :results_count, @ResultAmount = :results_amount, @Year = :year, @Type = Amount',
      'project_funding_amounts_by_type'               => 'EXECUTE GetProjectTypeStatsBySearchID         @SearchID = :search_id, @ResultCount = :results_count, @ResultAmount = :results_amount, @Year = :year, @Type = Amount',
      'project_funding_amounts_by_year'               => 'EXECUTE GetProjectAwardStatsBySearchID        @SearchID = :search_id, @ResultCount = :results_count, @ResultAmount = :results_amount, @Year = :year',
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

      'project_counts_by_year' => [
        'label' => 'Year',
        'data' => [
          'count' => 'Count',
        ],
      ],



      'project_funding_amounts_by_country' => [
        'label' => 'country',
        'data' => [
          'amount' => 'USDAmount',
        ],
      ],


      'project_funding_amounts_by_cso_research_area' => [
        'label' => 'categoryName',
        'data' => [
          'amount' => 'USDAmount',
        ],
      ],


      'project_funding_amounts_by_cancer_type' => [
        'label' => 'CancerType',
        'data' => [
          'amount' => 'USDAmount',
        ],
      ],


      'project_funding_amounts_by_type' => [
        'label' => 'ProjectType',
        'data' => [
          'amount' => 'USDAmount',
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
      'search_id'      => intval($search_id),
      'results'        => [],
      'results_count'  => NULL,
      'results_amount' => NULL,
    ];

    // bind parameters to statement
    $stmt->bindParam(':search_id', $search_id);
    $stmt->bindParam(':year', $parameters['year']);
    $stmt->bindParam(':results_count', $results_count, PDO::PARAM_INT  | PDO::PARAM_INPUT_OUTPUT, 1000);
    $stmt->bindParam(':results_amount', $results_amount, PDO::PARAM_STR  | PDO::PARAM_INPUT_OUTPUT, 1000);


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

    $output['results_count'] = floatval($results_count);
    $output['results_amount'] = floatval($results_amount);

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
    $stmt = $pdo->prepare('SET NOCOUNT ON; EXECUTE GetProjectsByCriteria
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
      @ResultCount          = :results_count,
      @LastBudgetYear       = :last_budget_year');

    $output_parameters = [
      'search_id'         => NULL,
      'results_count'     => NULL,
      'last_budget_year'  => NULL,
    ];

    foreach($parameters as $input_key => &$input_value) {
      $stmt->bindParam(":$input_key", $input_value);
    }

    foreach($output_parameters as $output_key => &$output_value) {
      $stmt->bindParam(":$output_key", $output_value, PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT, 1000);
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

    $_SESSION['database_search_id'] = $output_parameters['search_id'];

    return [
      'search_id'           => $output_parameters['search_id'],
      'results_count'       => $output_parameters['results_count'],
      'last_budget_year'    => $output_parameters['last_budget_year'],
      'results'             => $results,
      'display_parameters'  => self::getSearchParametersForDisplay($pdo, ['search_id' => $output_parameters['search_id']]),
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
    $stmt = $pdo->prepare('SET NOCOUNT ON; EXECUTE GetProjectsBySearchID
      @SearchID       = :search_id,
      @PageSize       = :page_size,
      @PageNumber     = :page_number,
      @SortCol        = :sort_column,
      @SortDirection  = :sort_direction,
      @ResultCount    = :results_count
      ');

    $output_parameters = [
      'results_count'     => NULL,
    ];

    foreach($parameters as $key => &$value) {
      $stmt->bindParam(":$key", $value);
    }

    foreach($output_parameters as $output_key => &$output_value) {
      $stmt->bindParam(":$output_key", $output_value, PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT, 1000);
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

    $_SESSION['database_search_id'] = $parameters['search_id'];

    return [
      'search_id'           => $parameters['search_id'],
      'results_count'       => $output_parameters['results_count'],
      'last_budget_year'    => $output_parameters['last_budget_year'],
      'display_parameters'  => self::getSearchParametersForDisplay($pdo, ['search_id' => $parameters['search_id']]),
      'results'             => $results,
    ];
  }
}
