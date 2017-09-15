<?php

namespace Drupal\db_map\Controller;

use PDO;
use PDOStatement;

/**
 * Static functions for db_search_api routes.
 */
class MappingTool {

  /**
   * Returns data for all regions
   *
   * @param PDO $pdo
   * @param int $searchId
   * @return void
   */
  public static function getAllRegions(PDO $pdo, array $parameters = ['searchId' => 0]): array {
    try {
      $counts = [
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
      
      $regions = PDOBuilder::executePreparedStatement(
        $pdo, 
        'SET NOCOUNT ON; EXECUTE GetMapRegionDataBySearchID
            @SearchID = :searchId,
            @AggregatedProjectCount = :projects,
            @AggregatedPICount = :primaryInvestigators,
            @AggregatedCollabCount = :collaborators',
        $parameters,
        $counts
      )->fetchAll();
      
      // extract the values for each count
      foreach($counts as $key => $entry) {
        $counts[$key] = $entry['value'];
      }
      
      // map regions to standard format
      $regions = array_map(function($region) {
        return [
          'label' => $region['Region'],
          'value' => $region['RegionID'],
          'coordinates' => [
            'latitude' => floatval($region['Latitude']),
            'longitude' => floatval($region['Longitude']),
          ],
          'data' => [
            'relatedProjects' => $region['TotalRelatedProjectCount'],
            'primaryInvestigators' => $region['TotalPICount'],
            'collaborators' => $region['TotalCollaboratorCount'],
          ],
        ];
      }, $regions);

      // sort regions
      usort($regions, function($a, $b) {
        return $a['value'] - $b['value'];
      });      

      return [
        'regions' => $regions,
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
}
