import * as React from 'react';
import { ComponentBase  } from 'resub';
import { store } from '../../services/Store';
import { Location, ViewLevel, LocationFilters, parseViewLevel, getNextLocationFilters } from '../../services/DataService';
import { Pagination } from 'react-bootstrap';

import './SummaryGrid.css';

interface SummaryGridProps {
  onSelect: (locationFilters: LocationFilters) => void | Promise<void>;
  children?: JSX.Element;
}

interface SummaryGridState {
  locations: Location[];
  locationFilters: LocationFilters;
  viewLevel: ViewLevel;
  tablePage: number;
  tablePageSize: number;
}

export default class SummaryGrid extends ComponentBase<SummaryGridProps & React.Props<any>, SummaryGridState> {
  _buildState(): SummaryGridState {
    return {
      locations: store.getLocations(),
      viewLevel: store.getViewLevel(),
      locationFilters: store.getLocationFilters(),
      tablePage: store.getTablePage(),
      tablePageSize: store.getTablePageSize(),
    }
  }

  handleSelect(page: any) {
    store.setTablePage(page);
  }

  render() {
    const { onSelect, children } = this.props;
    const { locations, viewLevel, locationFilters, tablePageSize, tablePage } = this.state;

    let numItems = Math.ceil(
      (locations && locations.length || 0) / tablePageSize);

    return !locations || !locations.length ? null : (
      <div>
        <div className="margin-top" style={{display: 'flex', justifyContent: 'space-between', alignContent: 'flex-end', alignItems: 'center', marginBottom: '5px'}}>
          <div>{ children }</div>
          {numItems > 1 &&
            <Pagination
              bsSize="small"
              items={numItems}
              activePage={tablePage}
              onSelect={this.handleSelect}
              boundaryLinks={true}
              ellipsis={true}
              maxButtons={5}
              prev
              next
            />
          }
        </div>
        <div className="table-responsive">
          <table className="table table-bordered table-striped table-hover table-nowrap">
            <thead>
              <tr>
                <th>{parseViewLevel(viewLevel)}</th>
                <th>Total Projects</th>
                <th>Total PIs</th>
                <th>Total Collaborators</th>
              </tr>
            </thead>
            <tbody>
            {
              locations.map((location: Location, index: number) =>
                (!(index >= (tablePage - 1) * tablePageSize && index < tablePage * tablePageSize) ? null :
                  <tr key={index}>
                    <td>
                      <a className="cursor-pointer"
                        onClick={event => onSelect(
                          getNextLocationFilters(location, locationFilters)
                        )}>
                        {location.label}
                      </a>
                    </td>
                    <td>{location.counts.projects.toLocaleString()}</td>
                    <td>{location.counts.primaryInvestigators.toLocaleString()}</td>
                    <td>{location.counts.collaborators.toLocaleString()}</td>
                  </tr>
                )
              )
            }
            </tbody>
          </table>
        </div>
      </div>
    );
  }
}