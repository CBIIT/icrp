import * as React from 'react';
import { ComponentBase  } from 'resub';
import { store } from '../../services/Store';
import { Location, ViewLevel, LocationFilters, parseViewLevel, getNextLocationFilters } from '../../services/DataService';

interface SummaryGridProps {
  onSelect: (locationFilters: LocationFilters) => void | Promise<void>;
}

interface SummaryGridState {
  locations: Location[];
  locationFilters: LocationFilters;
  viewLevel: ViewLevel;
}

export default class SummaryGrid extends ComponentBase<SummaryGridProps & React.Props<any>, SummaryGridState> {
  _buildState(): SummaryGridState {
    return {
      locations: store.getLocations(),
      viewLevel: store.getViewLevel(),
      locationFilters: store.getLocationFilters(),
    }
  }

  render() {
    const { onSelect } = this.props;
    const { locations, viewLevel, locationFilters } = this.state;

    return !locations || !locations.length ? null : (
      <div className="table-responsive">
        <table className="table table-bordered table-striped table-hover table-nowrap">
          <thead>
            <tr>
              <th>{parseViewLevel(viewLevel)}</th>
              <th>Total Related Projects</th>
              <th>Total PIs</th>
              <th>Total Collaborators</th>
            </tr>
          </thead>
          <tbody>
          {
            locations.map((location: Location, index: number) =>
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
          }
          </tbody>
        </table>
      </div>
    );
  }
}