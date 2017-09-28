import * as React from 'react';
import { ComponentBase  } from 'resub';
import { locations } from '../../stores/Locations';
import { locationFilters } from '../../stores/LocationFilters';

import { Location, ViewLevel, LocationApiRequest } from '../../services/DataService';

interface SummaryGridProps {
  onSelect: (props: LocationApiRequest) => void;
}

interface SummaryGridState {
  locations: Location[];
  locationFilters: LocationApiRequest;
  viewLevel: ViewLevel;
}

export default class SummaryGrid extends ComponentBase<SummaryGridProps & React.Props<any>, SummaryGridState> {
  _buildState(): SummaryGridState {
    return {
      locations: locations.get(),
      viewLevel: locationFilters.getViewLevel(),
      locationFilters: locationFilters.getApiRequest(),
    }
  }

  selectLocation(location: Location) {
    const { onSelect } = this.props;
    const { viewLevel, locationFilters } = this.state;

    let nextViewLevel: ViewLevel = 'regions';

    if (viewLevel === 'regions') {
      nextViewLevel = 'countries';
    }

    else if (viewLevel == 'countries') {
      nextViewLevel = 'cities';
    }

    let locationApiRequest: LocationApiRequest = {
      type: nextViewLevel,
      ...locationFilters
    }

    if (viewLevel === 'regions') {
      delete locationApiRequest.region;
      delete locationApiRequest.country;
    }

    if (viewLevel === 'countries') {
      locationApiRequest.region = location.value;
      delete locationApiRequest.country;
    }

    else if (viewLevel === 'cities') {
      locationApiRequest.country = location.value;
    }

    onSelect(locationApiRequest);
  }

  render() {
    const { locations, viewLevel } = this.state;

    return (
      <div className="table-responsive">
        <table className="table table-bordered table-striped table-hover table-nowrap">
          <thead>
            <tr>
              <th>{{regions: 'Region', countries: 'Country', cities: 'City'}[viewLevel || 'regions']}</th>
              <th>Total Projects</th>
              <th>Total PIs</th>
              <th>Total Collaborators</th>
            </tr>
          </thead>
          <tbody>
          {
            locations.map((location: Location, index: number) =>
              <tr key={index}>
                <td>
                  <a className="cursor-pointer" onClick={event => this.selectLocation(location)}>
                    {location.label}
                  </a>
                </td>
                <td>{location.data.projects.toLocaleString()}</td>
                <td>{location.data.primaryInvestigators.toLocaleString()}</td>
                <td>{location.data.collaborators.toLocaleString()}</td>
              </tr>
            )
          }
          </tbody>
        </table>
      </div>
    );
  }
}