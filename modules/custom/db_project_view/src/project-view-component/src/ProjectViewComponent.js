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

  state = {
    results: null,
    loading: true,
    error: false,
    table: {
      columns: [],
      data: []
    }
  }

  constructor(props) {
    super(props);
    this.updateResults(props.project);
  }

  async updateResults(project) {
    try {
      let endpoint = `https://icrpartnership-demo.org/project/get/${project}`;
      let response = await fetch(endpoint);

      /** @type {apiResults} */
      let results = await response.json();

      let columns = [
        {
          label: 'Title',
          value: 'project_title',
          link: 'project_funding_url'
        },
        {
          label: 'Category',
          value: 'project_category',
        },
        {
          label: 'Funding Org.',
          value: 'funding_organization',
        },
        {
          label: 'Alt Award Code',
          value: 'alt_award_code',
        },
        {
          label: 'Award Funding Period',
          value: 'award_funding_period',
        },
        {
          label: 'PI',
          value: 'pi_name',
        },
        {
          label: 'Institution',
          value: 'institution',
        },
        {
          label: 'Location',
          value: 'location',
        },
      ];

      let data = results.project_funding_details.map(row => ({
        project_title: row.project_title,
        project_funding_url: `/project/funding-details/${row.project_funding_id}`,
        project_category: row.award_type,
        funding_organization: row.funding_organization,
        alt_award_code: row.alt_award_code,
        award_funding_period: (!row.budget_start_date && !row.budget_end_date)
          ? 'Not specified'
          : (row.budget_start_date || 'N/A') + ' to '
          + (row.budget_end_date || 'N/A'),

        pi_name: [row.pi_last_name, row.pi_first_name].filter(e => e.length).join(', '),
        institution: row.institution,
        location: [row.city, row.state, row.country].filter(e => e.length).join(', '),
      }));

      this.setState({
        loading: false,
        results: results,
        table: {
          columns: columns,
          data: data
        }
      });
    }
    catch (exception) {
      this.setState({
        loading: false,
        error: true,
      })
    }
  }

  render() {

    if (this.state.loading)
      return <div className="native-font">Loading...</div>

    let project_details = this.state.results.project_details[0];
    let cancer_types = this.state.results.cancer_types;
    let cso_research_areas = this.state.results.cso_research_areas;
    let table = this.state.table;

    return <div className="native-font">

      <h3 className="title margin-right">View Project Details</h3>
      <h4 className="h4 grey">{ project_details.project_title }</h4>
      <hr className="less-margins" />

      <dl className="dl-horizontal margin-bottom margin-top">
        <dt>Award Code</dt>
        <dd>{ project_details.award_code || 'Not specified' }</dd>

        <dt>Project Dates</dt>
        <dd>{(project_details.project_start_date || project_details.project_end_date)
            ? `${project_details.project_start_date || 'N/A'} to ${project_details.project_end_date || 'N/A'}`
            : 'Not specified'}
        </dd>
        <dt>Funding Mechanism</dt>
        <dd>{project_details.funding_mechanism || 'Not specified'}</dd>
      </dl>

      <h5 className="h5 margin-top">Award Funding</h5>
      <DataTable columns={ table.columns } data={ table.data } limit="5" />

      { project_details.technical_abstract &&
        <div>
          <h4>Technical Abstract</h4>
          <div>{ project_details.technical_abstract }</div>
          <hr />
        </div>
      }

      { project_details.public_abstract &&
        <div>
          <h4>Public Abstract</h4>
          <div>{ project_details.public_abstract }</div>
          <hr />
        </div>
      }

      <h5 className="h5">Cancer Types</h5>
      <ul>
      { 
        cancer_types.map((row, rowIndex) =>
          <li key={ rowIndex }>
          {
            row.cancer_type_url
            ? <a href={ row.cancer_type_url } target="_blank">{ row.cancer_type }</a>
            : row.cancer_type
          }
          </li>
        )
      }</ul>

      <h5 className="h5">Common Scientific Outline (CSO) Research Areas</h5>
      <ul>{cso_research_areas.map((row, rowIndex) =>
        <li key={rowIndex}><b>{row.cso_code} {row.cso_category}</b> {row.cso_short_name}</li>
      )}</ul>
    </div>


  }
}

export default ProjectViewComponent;

/**
 *  project_funding_details: [
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
 */


/**

<div class="native-font">

{% if project_details %}
<h3 class="title margin-right">View Project Details</h3>
<h4 class="h4 grey">{{ project_details.project_title | raw }}</h4>
<hr class="less-margins">

<dl class="dl-horizontal margin-bottom margin-top">
  <dt>Award Code</dt>
  <dd>{{ project_details.award_code | default('Not specified')}}</dd>

  <dt>Project Dates</dt>
  <dd>
    {% if project_details.project_start_date or project_details.project_end_date %}
      {{ project_details.project_start_date | default('N/A') | raw }}
      to {{ project_details.project_end_date | default('N/A') | raw }}
    {% else %}
      <i>Not specified</i>
    {% endif %}
  <dt>Funding Mechanism</dt>
  <dd>{{ project_details.funding_mechanism | default('Not specified')}}</dd>
</dl>

<h5 class="h5 margin-top" style="margin-top: 20px">Award Funding</h4>
<div class="table-responsive margin-top">
  <table class="project-funding-details">
    <thead>
      <tr>
        <th class="limited-width">Title</th>
        <th>Category</th> 
        <th>Funding Org.</th>
        <th>Alt Award Code</th>
        <th>Award Funding Period</th>
        <th>PI</th>
        <th class="limited-width">Institution</th>
        <th>Location</th>
      </tr>
    </thead>
    <tbody>
      {% for row in project_funding_details %}
        <tr>
          <td class="limited-width">
            <a href="/project/funding-details/{{ row.project_funding_id }}" target="_blank">
              {{ row.project_title | default('Not specified') | raw }}
            </a>
          </td>
          <td>{{ row.award_type | default('Not specified') | raw }}</td>

          <td>{{ row.funding_organization | default('Not specified') | raw }}</td>
          <td>{{ row.alt_award_code | default('Not specified') | raw }}</td>
          <td>
            {% if row.budget_start_date or row.budget_end_date %}
              {{ row.budget_start_date | default('N/A') | raw }}
              to {{ row.budget_end_date | default('N/A') | raw }}
            {% else %}
              <i>Not specified</i>
            {% endif %}
          </td>
          
          <td>{{ row.pi_last_name ~ ', ' ~ row.pi_first_name }}</td>
          <td class="limited-width">{{ row.institution | default('Not specified') | raw }}</td>
          <td>{{ (row.city ? row.city ~ ', ') ~
                 (row.state ? row.state ~ ', ') ~
                  row.country }}</td>
        </tr>
      {% endfor %}
    </tbody>
  </table>
</div>

<div id="google_translate_element" style="text-align: right"></div><script type="text/javascript">
function googleTranslateElementInit() {
  new google.translate.TranslateElement({pageLanguage: 'en', layout: google.translate.TranslateElement.InlineLayout.HORIZONTAL}, 'google_translate_element');
}
</script><script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
        

{% if project_details.technical_abstract %}
<h4>Technical Abstract</h4>
<div>{{ project_details.technical_abstract | raw }}</div>
<hr>
{% endif %}

{% if project_details.public_abstract %}
<h4>Public Abstract</h4>
<div>{{ project_details.public_abstract | raw }}</div>
<hr>
{% endif %}

<h5 class="h5">Cancer Types</h5>
<ul>
  {% for row in cancer_types %}
  <li>
    {% if row.cancer_type_url %}
      <a href="{{ row.cancer_type_url }}" target="_blank">{{ row.cancer_type }}</a>
    {% else %}
      {{ row.cancer_type }}
    {% endif %}
  </li>
  {% endfor %}
</ul>

<h5 class="h5">Common Scientific Outline (CSO) Research Areas</h5>
<ul>
  {% for row in cso_research_areas %}
  <li>

  </li>
  {% endfor %}
</ul>


{% else %}
  <i>No project information found</i>
{% endif %}

</div>




 */