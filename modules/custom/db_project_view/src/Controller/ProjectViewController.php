<?php
/**
 * @file
 * Contains \Drupal\db_project_view\Controller\ProjectViewController.
 */
namespace Drupal\db_project_view\Controller;
include 'getProjectInfo.php';

use Drupal\Core\Controller\ControllerBase;
class ProjectViewController extends ControllerBase {
  public function content($projectID) {
    $results = getProjectInfo($projectID);

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