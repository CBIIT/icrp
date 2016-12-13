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
    $searchResults = getProjectInfo($projectID);

    return array(
      '#theme' => 'db_project_view',
      
      '#title' => $this->t($searchResults['Title']),
      '#piFirstName' => $this->t($searchResults['PiFirstName']),
      '#piLastName' => $this->t($searchResults['PiLastName']),
      '#institution' => $this->t($searchResults['Institution']),
      '#city' => $this->t($searchResults['City']),
      '#state' => $this->t($searchResults['State']),
      '#country' => $this->t($searchResults['Country']),
      '#awardCode' => $this->t($searchResults['AwardCode']),
      '#fundingOrg' => $this->t($searchResults['FundingOrg']),
      '#budgetStartDate' => $this->t($searchResults['BudgetStartDate']),
      '#budgetEndDate' => $this->t($searchResults['BudgetEndDate']),
      '#projectStartDate' => $this->t($searchResults['ProjectStartDate']),
      '#projectEndDate' => $this->t($searchResults['ProjectEndDate']),
      '#fundingMechanism' => $this->t($searchResults['FundingMechanism']),
      '#techAbstract' => $this->t($searchResults['TechAbstract']),
      '#publicAbstract' => $this->t($searchResults['PublicAbstract']),
      '#cancerTypes' => $this->t($searchResults['CancerTypes']),
      '#csoAreas' => $this->t($searchResults['CsoAreas']),

      '#attached' => array(
        'library' => array(
          'db_project_view/resources'
        ),
      ),
    );
  }
}