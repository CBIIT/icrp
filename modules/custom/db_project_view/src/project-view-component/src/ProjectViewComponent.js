import React, { Component } from 'react';
import './ProjectViewComponent.css';

class ProjectViewComponent extends Component {

  /**
   * @type { {projectDetails: { {projectTitle: "string", projectStartDate: "string", projectEndDate: "string"} }    } } 
   */
  state: {

  } =  {
    title: 'default title',

  }

/*
'project_details' => [
      'Title' => 'project_title',
      'ProjectStartDate' => 'project_start_date',
      'ProjectEndDate' => 'project_end_date',
      'TechAbstract' => 'technical_abstract',
      'PublicAbstract' => 'public_abstract',
      'FundingMechanism' => 'funding_mechanism'
    ],
    'project_funding_details' => [
      'piLastName' => 'pi_last_name',
      'piFirstName' => 'pi_first_name',
      'Institution' => 'institution',
      'City' => 'city',
      'State' => 'state',
      'Country' => 'country',
      'AwardType' => 'award_type',
      'AltAwardCode' => 'alt_award_code',
      'FundingOrganization' => 'funding_organization',
      'BudgetStartDate' => 'budget_start_date',
      'BudgetEndDate' => 'budget_end_date',
    ],
    'cancer_types' => [
      'CancerType' => 'cancer_type',
      'SiteURL' => 'cancer_type_url',
    ],
    'cso_research_areas' => [
      'CSOCode' => 'cso_code',
      'CategoryName' => 'cso_category',
      'CSOName' => 'cso_name',
      'ShortName' => 'cso_short_name'
    ]
*/
  
  render() {
    return (
      <div>
        <h2>{ this.state.title }</h2>

      </div>
    );
  }
}

export default ProjectViewComponent;
