import * as React from 'react';
import './SearchCriteria.css';

const SearchCriteria = (props: {projects: number, primaryInvestigators: number, collaborators: number}) =>
  <div className="search-criteria-bar">
    <div>
      <span className="rotate-45 margin-right">{'\u25E5'}</span>
      <b>Search Criteria: </b>
      All
    </div>

    <div className="blue-text">
      Total Related Projects: {props.projects.toLocaleString()}
      {` / Total PIs: `}{props.primaryInvestigators.toLocaleString()}
      {` / Total Collabs: `}{props.collaborators.toLocaleString()}
    </div>

  </div>

export default SearchCriteria;
