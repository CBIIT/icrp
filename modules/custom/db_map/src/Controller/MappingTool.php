<?php

namespace Drupal\db_map\Controller;

use PDO;
use PDOStatement;

/**
 * Static functions for db_search_api routes.
 */
class MappingTool {

  const QUERY_MAP = [
    'regions' => [
      'sql' => '
        SET NOCOUNT ON;
        EXECUTE GetMapRegionsBySearchID
          @SearchID = :searchId,
          @AggregatedProjectCount = :projects,
          @AggregatedPICount = :primaryInvestigators,
          @AggregatedCollabCount = :collaborators',

      'inputParameters' => [
        'searchId'
      ],

      'columns' => [
        'value' => 'RegionID',
        'label' => 'Region',
      ],
    ],

    'countries' => [
      'sql' => '
        SET NOCOUNT ON;
        EXECUTE GetMapCountriesBySearchID
          @SearchID = :searchId,
          @RegionID = :region,
          @AggregatedProjectCount = :projects,
          @AggregatedPICount = :primaryInvestigators,
          @AggregatedCollabCount = :collaborators',

      'inputParameters' => [
        'searchId',
        'region',
      ],

      'columns' => [
        'value' => 'Abbreviation',
        'label' => 'Country',
      ],
    ],

    'cities' => [
      'sql' => '
        SET NOCOUNT ON;
        EXECUTE GetMapCitiesBySearchID
          @SearchID = :searchId,
          @RegionID = :region,
          @Country = :country,
          @AggregatedProjectCount = :projects,
          @AggregatedPICount = :primaryInvestigators,
          @AggregatedCollabCount = :collaborators',

      'inputParameters' => [
        'searchId',
        'region',
        'country',
      ],

      'columns' => [
        'value' => 'City',
        'label' => 'City',
      ],
    ],

    'institutions' => [
      'sql' => '
        SET NOCOUNT ON;
        EXECUTE GetMapInstitutionsBySearchID
          @SearchID = :searchId,
          @RegionID = :region,
          @Country = :country,
          @City = :city,
          @AggregatedProjectCount = :projects,
          @AggregatedPICount = :primaryInvestigators,
          @AggregatedCollabCount = :collaborators',

      'inputParameters' => [
        'searchId',
        'region',
        'country',
        'city',
      ],

      'columns' => [
        'value' => 'InstitutionID',
        'label' => 'Institution',
      ],
    ],

  ];

  /**
   * Returns data for a specific type of map view (level).
   *
   * @param PDO $pdo
   * @param array $parameters
   * {
   *  searchId: number
   *  level: 'region' | 'country' | 'city'
   *  region: number;
   *  country: string;
   *  city: state;
   * }
   *
   * @return array
   * An array containing Locations
   * Each Location is comprised of the following keys:
   *   label: the display name for this location
   *   value: the internal name for this location (used to query db)
   *   coordinates: a latitude/longitude literal
   *   data: any data associated with this location
   *         required keys:
   *           relatedProjects: Number of related projects
   *           primaryInvestigators: Number of PIs
   *           collaborators: Number of collaborators
   */
  public static function getLocations(
    PDO $pdo,
    array $parameters = ['searchId' => 0, 'type' => 'region']
  ): array {
    try {
      $output = [
        'projects' => [
          'type' => PDO::PARAM_INT,
          'value' => 0,
        ],
        'primaryInvestigators' => [
          'type' => PDO::PARAM_INT,
          'value' => 0,
        ],
        'collaborators' => [
          'type' => PDO::PARAM_INT,
          'value' => 0,
        ],
      ];

      if (!in_array($parameters['type'], array_keys(self::QUERY_MAP))) {
        $parameters['type'] = array_keys(self::QUERY_MAP)[0];
      }

      $query = self::QUERY_MAP[$parameters['type']];
      $locations = PDOBuilder::executePreparedStatement(
        $pdo,
        $query['sql'],
        self::filterArray($parameters, $query['inputParameters']),
        $output
      )->fetchAll();

      // extract the values for each count
      $counts = [];
      foreach($output as $key => $entry) {
        $counts[$key] = $entry['value'];
      }

      // map to standard Location format
      $locations = array_map(function($location) use ($query) {
        $columns = $query['columns'];
        return [
          'label' => trim(strval($location[$columns['label']])),
          'value' => trim(strval($location[$columns['value']])),
          'coordinates' => [
            'lat' => floatval($location['Latitude']),
            'lng' => floatval($location['Longitude']),
          ],
          'counts' => [
            'projects' => $location['TotalRelatedProjectCount'],
            'primaryInvestigators' => $location['TotalPICount'],
            'collaborators' => $location['TotalCollaboratorCount'],
          ],
        ];
      }, $locations);

      return [
        'locations' => $locations,
        'counts' => $counts,
      ];
    }

    catch (PDOException $ex) {
      $message = $ex->getMessage();
      error_log($message);
      return ['ERROR' => $message];
    }
  }


  /**
   * Retrieves search parameters as a table suitable for display to the client
   *
   * @param PDO $pdo
   * @param array $parameters
   * @return array
   */
  public static function getSearchParameters(PDO $pdo, array $parameters = ['searchId' => -1]): array {

    try {
      return PDOBuilder::executePreparedStatement(
        $pdo,
        'SET NOCOUNT ON; EXECUTE GetSearchCriteriaBySearchID
          @SearchID = :searchId',
        $parameters
      )->fetchAll(PDO::FETCH_NUM);
    }

    catch (PDOException $ex) {
      $message = $ex->getMessage();
      error_log($message);
      return ['ERROR' => $message];
    }
  }

  /**
   * Retrieves search criteria id based on current search id
   * region, country, and city
   *
   * @param PDO $pdo
   * @param array $parameters
   * @return array
   */
  public static function getNewSearchId(
    PDO $pdo,
    array $parameters = [
      'searchId' => 0,
      'region' => NULL,
      'country' => NULL,
      'city' => NULL
  ]) {
    try {
      $output = [
        'newSearchId' => [
          'type' => PDO::PARAM_INT,
          'value' => 0,
        ],
      ];

      PDOBuilder::executePreparedStatement(
        $pdo,
        'SET NOCOUNT ON; EXECUTE GetProjectsFromMapBySearchID
            @SearchID = :searchId,
            @RegionID = :region,
            @Country = :country,
            @City = :city,
            @SearchCriteriaID = :newSearchId,
            @ResultCount = NULL',
        $parameters,
        $output
      )->fetchAll();

      return $output['newSearchId']['value'];
    }

    catch (PDOException $ex) {
      $message = $ex->getMessage();
      error_log($message);
      return ['ERROR' => $message];
    }
  }

  /**
   * Creates a new array from an existing array with only the specified keys
   *
   * @param array $input
   * @param array $allowedKeys
   * @return void
   */
  private static function filterArray(array $input, array $allowedKeys): array {
    return array_filter(
      $input,
      function($key) use ($allowedKeys) {
        return in_array($key, $allowedKeys);
      },
      ARRAY_FILTER_USE_KEY
    );
  }
}
