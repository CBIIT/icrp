import * as React from 'react';
import { LocationCounts, summarizeCriteria } from '../../services/DataService';
import { BorderlessTable } from './BorderlessTable';
import './SearchCriteria.css';

interface SearchCriteriaProps {
  searchCriteria: any[][];
  counts: LocationCounts;
}

interface SearchCriteriaState {
  isOpen: boolean;
}

export default class SearchCriteria extends React.Component<SearchCriteriaProps, SearchCriteriaState> {

  state = { isOpen: false };

  render() {
    let { searchCriteria, counts } = this.props;
    let { isOpen } = this.state;

    return (
      <div>
        <div
          className="search-criteria-bar"
          onClick={event => searchCriteria.length > 0 && this.setState({isOpen: !isOpen})}>
          <div>
            <div
              className="margin-right inline-block"
              style={{transform: `rotate(${isOpen ? 135 : 45}deg)`}}>
              {'\u25E5'}
            </div>
            <b>Search Criteria: </b>
            { summarizeCriteria(searchCriteria) }
          </div>

          <div className="blue-text">
            {'Total Projects: '}
              {counts.projects.toLocaleString()}

            {` / Total PIs: `}
              {counts.primaryInvestigators.toLocaleString()}

            {` / Total Collabs: `}
              {counts.collaborators.toLocaleString()}
          </div>
        </div>
        {
          isOpen && searchCriteria.length > 0 &&
          <div className="search-criteria-panel">
            <BorderlessTable rows={searchCriteria} />
          </div>
        }
      </div>
    )
  }
}
