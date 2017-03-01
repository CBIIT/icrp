import React, { Component } from 'react';
import DataTable from './DataTable';
import './ProjectViewComponent.css';

class ProjectViewComponent extends Component {

  /**
   * @typedef apiResults
   * @type {Object}
   * @property {Object[]} project_details Project details 
   * @property {Object[]} project_funding_details Project funding details
   * @property {Object[]} cancer_types Project cancer types
   * @property {Object[]} cso_research_areas Project CSO research areas
   */

  /** @type {apiResults} */
  apiResults = {
    project_details: [
      {
        project_title: null,
        project_start_date: null,
        project_end_date: null,
        technical_abstract: null,
        public_abstract: null,
        funding_mechanism: null,
      }
    ],
    project_funding_details: [
      {
        project_funding_id: null,
        project_title: null,
        pi_last_name: null,
        pi_first_name: null,
        institution: null,
        city: null,
        state: null,
        country: null,
        award_type: null,
        alt_award_code: null,
        funding_organization: null,
        budget_start_date: null,
        budget_end_date: null,
      }
    ],
    cancer_types: [
      {
        cancer_type: null,
        cancer_type_url: null,
      }
    ],
    cso_research_areas: [
      {
        cso_code: null,
        cso_category: null,
        cso_name: null,
        cso_short_name: null
      }
    ]
  }

  constructor(props) {
    super(props);
    this.state = {
      results: null,
      loading: true,
      error: false,
      table: {
        columns: [],
        data: []
      }
    }
    this.updateResults(props.project);
  }

  async updateResults(project) {
    try {
      let endpoint = `${this.props.source}/project/get/${project}`;
      let response = await fetch(endpoint);

      /** @type {apiResults} */
      let results = await response.json();
      
      let table = {
        columns: [
          {
            label: 'Title',
            value: 'project_title',
            link: 'project_funding_url',
            tooltip: 'Title of Award',
          },
          {
            label: 'Category',
            value: 'project_category',
            tooltip: 'A project may be a Parent Project, Supplement, or Sub-Project',
          },
          {
            label: 'Funding Org.',
            value: 'funding_organization',
            tooltip: 'Funding Organization of Award (abbreviated name shown)',
          },
          {
            label: 'Alt Award Code',
            value: 'alt_award_code',
            tooltip: 'Full award code/grant number',
          },
          {
            label: 'Award Funding Period',
            value: 'award_funding_period',
            tooltip: 'The award has been funded through these dates. Some projects receive funding for multiple years and some projects receive funding one year at a time.',
          },
          {
            label: 'PI',
            value: 'pi_name',
            tooltip: 'Principal Investigator',
          },
          {
            label: 'Institution',
            value: 'institution',
            tooltip: 'PI Institution',
          },
          {
            label: 'Location',
            value: 'location',
            tooltip: 'City and Country of Principal Investigator',
          },
        ],

        data: results.project_funding_details.map(row => ({
          project_title: row.project_title,
          project_funding_url: `${this.props.source}/project/funding-details/${row.project_funding_id}`,
          project_category: row.award_type,
          funding_organization: row.funding_organization,
          alt_award_code: row.alt_award_code,
          award_funding_period: row.budget_start_date || row.budget_end_date
            ? `${row.budget_start_date || 'N/A'} to ${row.budget_end_date || 'N/A'}`
            : 'Not specified',
          pi_name: [row.pi_last_name, row.pi_first_name].filter(e => e && e.length).join(', '),
          institution: row.institution,
          location: [row.city, row.state, row.country].filter(e => e && e.length).join(', '),
        }))
      }

      this.setState({
        loading: false,
        results: results,
        table: table
      });
    }
    catch (exception) {
      console.error(exception);
      this.setState({
        loading: false,
        error: true,
      })
    }
  }

  componentDidUpdate() {
    this.appendGoogleTranslateScript();
  }

  appendGoogleTranslateScript() {
    window.googleTranslateElementInit = 
    window.googleTranslateElementInit || function() {
      new window.google.translate.TranslateElement({
        pageLanguage: 'en', 
        layout: window.google.translate.TranslateElement.InlineLayout.HORIZONTAL
      }, 'google_translate_element');
    }

    let node = document.getElementById('google-translate-script');
    if (node)
      document.body.removeChild(node);

    let script = document.createElement('script');
    script.src = 'https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit';
    script.async = true;
    script.id = 'google-translate-script'
    document.body.appendChild(script);
  }

  render() {
    if (!this.state.loading && this.state.results) {
      let project_details = this.state.results.project_details[0];
      let cancer_types = this.state.results.cancer_types;
      let cso_research_areas = this.state.results.cso_research_areas;
      let table = this.state.table;

      return <div>

        <div className="clearfix">
          <h1 className="title">{ this.props.title }</h1>
          <span className="pull-right" id="google_translate_element" />
        </div>

        <div className="description">
          The project details page contains information on the Parent Project, as well as any related Supplements or Sub-Projects, for each year the project has been funded. Multiple records may be showing in the table below, and these can occur if the project is funded annually, and if the project has related subprojects or supplements (there will be a record for each year the project, sub-project or supplement is funded). Sub-projects or Supplements may have different Titles or PIs than the Parent Project, and are linked by a shared Award Code with the Parent Project. Users can “drill-through” to the project details page for each record in the table.
        </div>


        <dl className="dl-horizontal margin-bottom margin-top">

          <dt>Title</dt>
          <dd>{ project_details.project_title || 'Not specified' }</dd>

          <dt>Award Code</dt>
          <dd>{ project_details.award_code || 'Not specified' }</dd>

          <dt>Project Dates</dt>
          <dd>
          {
            (project_details.project_start_date || project_details.project_end_date)
            ? `${project_details.project_start_date || 'N/A'} to ${project_details.project_end_date || 'N/A'}`
            : 'Not specified'
          }
          </dd>

          <dt>Funding Mechanism</dt>
          <dd>{ project_details.funding_mechanism || 'Not specified' }</dd>

        </dl>

        <h5 className="h5 margin-top">Award Funding</h5>
        <DataTable columns={ table.columns } data={ table.data } limit="5" />

        {
          project_details.technical_abstract &&
          <div className="margin-top">
            <h4 >Technical Abstract</h4>
            <div dangerouslySetInnerHTML={{ __html: project_details.technical_abstract }} />
            <hr />
          </div>
        }

        {
          project_details.public_abstract &&
          <div className="margin-top">
            <h4>Public Abstract</h4>
            <div dangerouslySetInnerHTML={{ __html: project_details.public_abstract }} />
            <hr />
          </div>
        }

        <h5 className="h5">Cancer Types</h5>
        <ul>
        { 
          cancer_types.map((row, rowIndex) =>
            <li key={ rowIndex }>
            {
              row.cancer_type
            }
            </li>
          )
        }
        </ul>

        <h5 className="h5">Common Scientific Outline (CSO) Research Areas</h5>
        <ul>
        {
          cso_research_areas.map((row, rowIndex) =>
            <li key={rowIndex}>
              <b>{ row.cso_code } { row.cso_category }</b> { row.cso_short_name }
            </li>
          )
        }
        </ul>
      </div>
    }

    return <div>Loading...</div>
  }
}

export default ProjectViewComponent;