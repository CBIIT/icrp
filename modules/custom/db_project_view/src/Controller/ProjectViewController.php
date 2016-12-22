<?php
/**
 * @file
 * Contains \Drupal\db_project_view\Controller\ProjectViewController.
 */
namespace Drupal\db_project_view\Controller;
use Drupal\Core\Controller\ControllerBase;
USE Drupal\Core\Database\Database;
use PDO;

class ProjectViewController extends ControllerBase {

  public function getProjectCancerTypes($connection, $projectID) {
    return $connection->query(
      "CALL GetProjectCancerTypes(:projectID)", 
      array(':projectID' => $projectID)
    )->fetchAll(PDO::FETCH_ASSOC);
  }

  public function getProjectCSOAreas($connection, $projectID) {
    return $connection->query(
      "CALL GetProjectCSOCodes(:projectID)", 
      array(':projectID' => $projectID)
    )->fetchAll(PDO::FETCH_ASSOC);
  }

  public function getProjectInfo($projectID) {
    $connection = Database::getConnection('default', 'projects');

    $results = array(
      'project_title' => array(),
      'principal_investigator' => array(),
      'institution' => array(),
      'city' => array(),
      'state' => array(),
      'country' => array(),
      'award_code' => array(),
      'funding_organization' => array(),
      'budget_start_date' => array(),
      'budget_end_date' => array(),
      'project_start_date' => array(),
      'project_end_date' => array(),
      'funding_mechanism' => array(),
      'technical_abstract' => array(),
      'public_abstract' => array(),
      'cancer_types' => array(),
      'cso_areas' => array()
    );

    $query_results = $connection->query(
      "CALL GetProjectInfo(:projectID)", 
      array(':projectID' => $projectID)
    )->fetchAll(PDO::FETCH_ASSOC);

    foreach($query_results as $row) {
      foreach (array_keys($row) as $key) {
        array_push($results[$key], $row[$key]);
      }
    }

    $results['cancer_types'] = self::getProjectCancerTypes($connection, $projectID);
    $results['cso_areas'] = self::getProjectCSOAreas($connection, $projectID);
    return $results;
  }

  public function content($projectID) {
    $results = self::getProjectInfo($projectID);

    return array(
      '#theme' => 'db_project_view',

      '#project_title' => $results['project_title'],
      '#principal_investigator' => $results['principal_investigator'],
      '#institution' => $results['institution'],
      '#city' => $results['city'],
      '#state' => $results['state'],
      '#country' => $results['country'],
      '#award_code' => $results['award_code'],
      '#funding_organization' => $results['funding_organization'],
      '#budget_start_date' => $results['budget_start_date'],
      '#budget_end_date' => $results['budget_end_date'],
      '#project_start_date' => $results['project_start_date'],
      '#project_end_date' => $results['project_end_date'],
      '#funding_mechanism' => $results['funding_mechanism'],
      '#technical_abstract' => $results['technical_abstract'],
      '#public_abstract' => $results['public_abstract'],
      '#cancer_types' => $results['cancer_types'],
      '#cso_areas' => $results['cso_areas'],
      
      '#attached' => array(
        'library' => array(
          'db_project_view/resources'
        ),
      ),
    );
  }
}