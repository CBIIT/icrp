<?php

/**
 * @file
 * Contains \Drupal\db_search_api\Controller\DatabaseSearch
 */

namespace Drupal\db_search_api\Controller;

/**
 * Static functions for db_search_api routes.
 *
 */
class DatabaseSearch {

  const DEFAULT_SORT_PAGINATE_PARAMETERS = [
    'search_id'   => NULL,
    'page_size'   => 50,
    'page_number' => 1,
    'sort_column' => 'title',
    'sort_type'   => 'ASC',
  ];

  const DEFAULT_SEARCH_PARAMETERS = [
    'search_terms'          => NULL,
    'search_type'           => NULL,
    'years'                 => NULL,
    'institution'           => NULL,
    'pi_first_name'         => NULL,
    'pi_last_name'          => NULL,
    'pi_orcid'              => NULL,
    'award_code'            => NULL,
    'countries'             => NULL,
    'states'                => NULL,
    'cities'                => NULL,
    'funding_organizations' => NULL,
    'cancer_types'          => NULL,
    'project_types'         => NULL,
    'cso_research_areas'    => NULL,
  ];

  /**
   * Returns a PDO connection to a database
   * @param string $database - The drupal configuration key for the database to query
   * @return \PDO A PDO connection
   * @throws \PDOException
   * @api
   */
  public static function getConnection(string $database = 'icrp_database'): \PDO {

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
    $cfg = \Drupal::config($database)->get();

    return new \PDO(
      vsprintf('%s:Server=%s,%s;Database=%s', [
        $cfg['driver'],
        $cfg['host'],
        $cfg['port'],
        $cfg['database'],
      ]),
      $cfg['username'],
      $cfg['password'],
      [
        PDO::SQLSRV_ATTR_ENCODING    => PDO::SQLSRV_ENCODING_UTF8,
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
      ]
    );
  }

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
    }, $group_names);

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

      // otherwise, generate children with values based on the contents of the 'value' column
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
   * Maps values from the getSearchResults/getSortedPaginatedSearchResults array
   * to their display keys
   *
   * @param array $row
   * @return array
   */
  private static function mapSearchResults(array $row) {
    return [
      'project_id'            => $row['ProjectID'],
      'project_title'         => $row['Title'],
      'pi_name'               => sprintf('%s, %s', $row['piLastName'], $row['piFirstName']),
      'institution'           => $row['institution'],
      'country'               => $row['country'],
      'funding_organization'  => $row['FundingOrgShort'],
      'award_code'            => $row['AwardCode'],
    ];
  }

  /**
  * Retrieves valid field values to be used as query parameters
  * @param \PDO $pdo - The PDO connection object
  * @return array $fields
  */
  public static function getSearchFields(\PDO $pdo): array {

    $fields = [
      'cities'                => [],
      'states'                => [],
      'countries'             => [],
      'funding_organizations' => [],
      'cancer_types'          => [],
      'project_types'         => [],
      'cso_research_areas'    => [],
      'conversion_years'      => [],
    ];

    $queries = [
      'cities'                => 'SELECT DISTINCT City AS [value], City AS [label], State AS [group_1], Country AS [group_2] FROM Institution WHERE len(City) > 0 ORDER BY [label]',
      'states'                => 'SELECT Abbreviation AS [value], Name AS [label], Country AS [group_1] FROM State ORDER BY [label]',
      'countries'             => 'SELECT Abbreviation AS [value], Name AS [label] FROM Country ORDER BY [label]',
      'funding_organizations' => 'SELECT FundingOrgID AS [value], Name AS [label], SponsorCode AS [group_1], Country AS [group_2], \'Funding\' AS [group_3] FROM FundingOrg WHERE LastImportDate IS NOT NULL',
      'cancer_types'          => 'SELECT CancerTypeID AS [value], Name AS [label] FROM CancerType ORDER BY [value]',
      'project_types'         => 'SELECT ProjectType AS [value], ProjectType AS [label] FROM ProjectType',
      'cso_research_areas'    => 'SELECT Code AS [value], Name AS [label], CategoryName AS [group_1], \'All Areas\' as [group_2] FROM CSO',
      'conversion_years'      => 'SELECT DISTINCT Year AS [value], Year AS [label] FROM CurrencyRate ORDER BY Year DESC',
    ];

    // map query results to field values
    foreach (array_keys($queries) as $key) {
      $stmt = $queries[$key];
      $fields[$key] = $pdo->query($stmt)->fetchAll(\PDO::FETCH_ASSOC);
    }

    // set 'Uncoded' as the last entry in cso_research_areas
    if ($fields['cso_research_areas'][0]['value'] == '0') {
      array_push($fields['cso_research_areas'], array_shift($fields['cso_research_areas']));
    }

    $fields['funding_organizations'] = self::createTree($fields['funding_organizations'], 3, 'group_', 'All %s Organizations');
    $fields['cso_research_areas'] = self::createTree($fields['cso_research_areas'], 2);

    return $fields;
  }

  /**
  * Retrieves search parameters based on a specific search id
  * @param int $search_id - The search ID for this request
  * @param \PDO $pdo - The PDO connection object
  * @return array $results an array containing search parameters for the specified search id
  * @api
  */
  public static function getSearchParameters(int $searchId = -1, \PDO $pdo) {

    $stmt = $pdo->prepare('SELECT * FROM SearchCriteria WHERE SearchCriteriaID=:search_id');

    $results = [];
    if ($stmt->execute([':search_id' => $searchId])) {
        $results = $stmt->fetch(PDO::FETCH_ASSOC);
    }

    function split($str) {
      return empty($str) ? null : explode(',', $str);
    }

    return empty($results) ? $results : [
      'search_terms'          => $results['Terms'],
      'search_type'           => $results['TermSearchType'],
      'years'                 => split($results['YearList']),
      'institution'           => $results['Institution'],
      'pi_first_name'         => $results['piLastName'],
      'pi_last_name'          => $results['piFirstName'],
      'pi_orcid'              => $results['piORCiD'],
      'award_code'            => $results['AwardCode'],
      'countries'             => split($results['CountryList']),
      'states'                => split($results['StateList']),
      'cities'                => split($results['CityList']),
      'funding_organizations' => split($results['FundingOrgList']),
      'cancer_types'          => split($results['CancerTypeList']),
      'project_types'         => split($results['ProjectTypeList']),
      'cso_research_areas'    => split($results['CSOList']),
    ];
  }



  /**
  * Retrieves analytics for a specific facet of the search
  * @param int $searchId - The search ID for this request
  * @param string $type - The type of data to retrieve
  * @param int $year - The year for which this data should be retrieved
  * @param \PDO $pdo - The PDO connection object
  * @return array An array containining analytics data for the specified facet
  * @api
  */
  public static function getAnalytics(int $searchId, string $type, int $year = NULL, \PDO $pdo): array {

    $queryDefaults = 'SET NOCOUNT ON;';

    $queries = [
      'project_counts_by_country'           => 'EXECUTE GetProjectCountryStatsBySearchID    @SearchID = :search_id, @ResultCount = :count',
      'project_counts_by_cso_research_area' => 'EXECUTE GetProjectCSOStatsBySearchID        @SearchID = :search_id, @ResultCount = :count',
      'project_counts_by_cancer_type'       => 'EXECUTE GetProjectCancerTypeStatsBySearchID @SearchID = :search_id, @ResultCount = :count',
      'project_counts_by_type'              => 'EXECUTE GetProjectTypeStatsBySearchID       @SearchID = :search_id, @ResultCount = :count',
      'project_funding_amounts_by_year'     => 'EXECUTE GetProjectAwardStatsBySearchID      @SearchID = :search_id, @Year = :year, @Total = :count',
    ];

    // select which analytics query to perform
    if (!array_key_exists($type, $queries)) { return []; }
    $stmt = $pdo->prepare($queryDefaults . $queries[$type]);

    // define which columns to retrieve
    $column_mappings = [
      'project_counts_by_country'           => ['country', 'Count'],
      'project_counts_by_cso_research_area' => ['categoryName', 'Count'],
      'project_counts_by_cancer_type'       => ['CancerType', 'Count'],
      'project_counts_by_type'              => ['ProjectType', 'Count'],
      'project_funding_amounts_by_year'     => ['Year', 'amount'],
    ];

    // define output object
    $output = [
      'search_id' => intval($search_id),
      'results' => [],
      'count' => 0
    ];

    // bind parameters to statement
    $stmt->bindParam(':search_id', $search_id);
    $stmt->bindParam(':count', $output['count'], \PDO::PARAM_INT | \PDO::PARAM_INPUT_OUTPUT, 1000);
    $type === 'project_funding_amounts_by_year' and $stmt->bindParam(':year', $year);

    // execute statement and update output object
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
        array_push($output['results'], [
          'label' => $row[$column_mappings[$type][0]],
          'value' => floatval($row[$column_mappings[$type][1]]),
        ]);
      }
    }

    return $output;
  }


  /**
  * Retrieves search results for the given parameters
  * @param array $parameters - The search parameters
  * @param \PDO $pdo - The PDO connection object
  * @return array An array containining search results
  * @api
  */
  public static function getSearchResults(array $parameters, \PDO $pdo): array {

    $stmt = $pdo->prepare('SET NOCOUNT ON; EXECUTE GetProjectsByCriteria
      @PageSize         = :page_size,
      @PageNumber       = :page_number,
      @SortCol          = :sort_column,
      @SortDirection    = :sort_type,
      @terms            = :search_terms,
      @termSearchType   = :search_type,
      @yearList         = :years,
      @institution      = :institution,
      @piFirstName      = :pi_first_name,
      @piLastName       = :pi_last_name,
      @piORCiD          = :pi_orcid,
      @awardCode        = :award_code,
      @countryList      = :countries,
      @stateList        = :states,
      @cityList         = :cities,
      @fundingOrgList   = :funding_organizations,
      @cancerTypeList   = :cancer_types,
      @projectTypeList  = :project_types,
      @CSOList          = :cso_research_areas,
      @searchCriteriaID = :search_id,
      @ResultCount      = :results_count');

    $output_parameters = [
      'search_id'     => NULL,
      'results_count' => NULL,
    ];

    foreach(array_keys($parameters) as $input_key) {
      $stmt->bindParam(sprintf(':%s', $input_key), $parameters[$input_key]);
    }

    foreach(array_keys($output_parameters) as $output_key) {
      $stmt->bindParam(sprintf(':%s', $output_key), $output_parameters[$output_key], \PDO::PARAM_INT | \PDO::PARAM_INPUT_OUTPUT, 1000);
    }

    $results = [];
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
        array_push($results, self::mapSearchResults($row));
      }
    }

    $_SESSION['database_search_id'] = $output_parameters['search_id'];

    return [
      'search_id' => $output_parameters['search_id'],
      'results_count' => $output_parameters['results_count'],
      'results' => $results,
    ];
  }


  /**
  * Retrieves sorted and paginated results for an existing search
  * @param array $parameters - The sorting/pagination parameters
  * @param \PDO $pdo - The PDO connection object
  * @return array An array containining analytics data for the specified facet
  * @api
  */
  public static function getSortedPaginatedSearchResults(array $param, \PDO $pdo): array {

    // apply sort column mappings
    $param['sort_column'] = [
      'project_title'         => 'title',
      'pi_name'               => 'pi',
      'institution'           => 'Inst',
      'city'                  => 'city',
      'state'                 => 'state',
      'country'               => 'country',
      'funding_organization'  => 'FO',
      'award_code'            => 'code'
    ][$param['sort_column']];

    $stmt = $pdo->prepare('SET NOCOUNT ON; EXECUTE GetProjectsBySearchID
      @SearchID = :search_id,
      @PageSize = :page_size,
      @PageNumber = :page_number,
      @SortCol = :sort_column,
      @SortDirection = :sort_type,
      @ResultCount = :count');

    $stmt->bindParam(':result_count', $count, \PDO::PARAM_INT | \PDO::PARAM_INPUT_OUTPUT, 1000);
    foreach(array_keys($param) as $key) {
      $stmt->bindParam(sprintf(':%s', $key), $param[$key]);
    }

    $results = [];
    if ($stmt->execute()) {
      while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
        array_push($results, self::mapSearchResults($row));
      }
    }

    return $results;
  }
}
