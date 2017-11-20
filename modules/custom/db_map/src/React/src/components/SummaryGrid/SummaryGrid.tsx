import * as React from 'react';
import { ComponentBase  } from 'resub';
import { store } from '../../services/Store';
import { Location, ViewLevel, LocationFilters, parseViewLevel, getNextLocationFilters } from '../../services/DataService';
import { Pagination, OverlayTrigger, Tooltip } from 'react-bootstrap';

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

  handlePageSizeChange(value: any) {
    store.setTablePage(1);
    store.setTablePageSize(+value);
  }

  render() {
    const { onSelect, children } = this.props;
    const { locations, viewLevel, locationFilters, tablePageSize, tablePage } = this.state;

    console.log(this.state);

    let numItems = Math.ceil(
      (locations && locations.length || 0) / tablePageSize);

    let showPagination = numItems > 1 || (locations && locations.length > 25);
    showPagination = true;

    return !locations || !locations.length ? null : (
      <div>
        <div className="margin-top pagination-container">

          {showPagination &&
            <div className="pagination-select-container">
              <div style={{marginRight: '100px'}}>
                {'Show '}
                <select value={tablePageSize} onChange={event => this.handlePageSizeChange(+event.target.value)}>
                  <option value={25}>25</option>
                  <option value={50}>50</option>
                  <option value={100}>100</option>
                  <option value={150}>150</option>
                  <option value={200}>200</option>
                  <option value={250}>250</option>
                  <option value={300}>300</option>
                </select>

                {` out of `}
                <b>{locations && locations.length}</b>
                {` entries`}
              </div>

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
            </div>
          }

          <div style={{marginBottom: '5px'}}>{ children }</div>
        </div>
        <div className="table-responsive">
          <table className="table table-bordered table-striped table-hover table-nowrap">
            <thead>
              <tr>
                <th>{parseViewLevel(viewLevel)}</th>
                <th>
                  <OverlayTrigger placement="top" overlay={
                    <Tooltip id="total-projects">
                      Total projects with PI or collaborators in this {parseViewLevel(viewLevel).toLowerCase()}
                    </Tooltip>
                  }>
                    <div>Total Projects</div>
                  </OverlayTrigger>
                </th>
                <th>
                  <OverlayTrigger placement="top" overlay={
                    <Tooltip id="projects-with-pi">
                      Projects with PI in this {parseViewLevel(viewLevel).toLowerCase()}
                    </Tooltip>
                  }>
                    <div>Projects with PI</div>
                  </OverlayTrigger>
                </th>
                <th>
                  <OverlayTrigger placement="top" overlay={
                    <Tooltip id="projects-with-collaborators">
                      Projects with collaborator(s) in this {parseViewLevel(viewLevel).toLowerCase()}
                    </Tooltip>
                  }>
                    <div>Projects with Collaborators</div>
                  </OverlayTrigger>
                </th>
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


          {showPagination &&
            <div className="pagination-select-container">
              <div style={{marginRight: '100px'}}>
                {'Show '}
                <select value={tablePageSize} onChange={event => this.handlePageSizeChange(+event.target.value)}>
                  <option value={25}>25</option>
                  <option value={50}>50</option>
                  <option value={100}>100</option>
                  <option value={150}>150</option>
                  <option value={200}>200</option>
                  <option value={250}>250</option>
                  <option value={300}>300</option>
                </select>

                {` out of `}
                <b>{locations && locations.length}</b>
                {` entries`}
              </div>

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
            </div>
          }
      </div>
    );
  }
}