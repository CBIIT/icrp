import * as React from 'react';
import './SearchCriteria.css';

export interface SearchCriteriaProps {
  searchCriteria: {
    summary: string,
    parsed: {},
    table: (string|number)[][],
  };

  counts: {
    projects: number,
    primaryInvestigators: number,
    collaborators: number,
  };
}

export interface SearchCriteriaState {
  isOpen: boolean;
}

const UndecoratedTable = ({ rows }: {rows: (string|number)[][]}) =>
  <table>
    <tbody>
    {rows.map((row, rowIndex) =>
      <tr key={rowIndex}>
      {row.map((data, columnIndex) =>
        <td
          key={`${rowIndex}_${columnIndex}`}
          style={{
            padding: '4px 10px',
            fontWeight: columnIndex === 0 ? 'bold' : 'normal'
          }}>
          {data}
        </td>)}
      </tr>
    )}
    </tbody>
  </table>

export default class SearchCriteria extends React.Component<SearchCriteriaProps, SearchCriteriaState> {

  state = { isOpen: false };

  render() {
    let { searchCriteria, counts } = this.props;
    let { isOpen } = this.state;

    return (
      <div>
        <div
          className="search-criteria-bar"
          onClick={event => searchCriteria.table.length > 0 && this.setState({isOpen: !isOpen})}>
          <div>
            <div
              className="margin-right inline-block"
              style={{transform: `rotate(${isOpen ? 135: 45}deg)`}}>
              {'\u25E5'}
            </div>
            <b>Search Criteria: </b>
            { searchCriteria.summary }
          </div>

          <div className="blue-text">
            {'Total Related Projects: '}
              {counts.projects.toLocaleString()}

            {` / Total PIs: `}
              {counts.primaryInvestigators.toLocaleString()}

            {` / Total Collabs: `}
              {counts.collaborators.toLocaleString()}
          </div>
        </div>
        {
          isOpen &&
          <div className="search-criteria-panel">
            <UndecoratedTable rows={searchCriteria.table} />
          </div>
        }
        <br />
      </div>
    )
  }
}
