import React from 'react';
import { LocationSelector, SearchCriteria } from '..'
import { GoogleMap } from '..';

export default class App extends React.Component {

  state = {
    zoom: 2,
    location: {
      latitude: 0,
      longitude: 0,
    },
    locations: [],
    searchId: 0,
    searchCriteria: {
      summary: 'All',
      map: {},
      table: [],
    },
    totalCounts: {
      projects: 0,
      primaryInvestigators: 0,
      collaborators: 0,
    }
  }


  render() {
    return (
      <div>
        <SearchCriteria {...this.state.totalCounts} />
        <div className="text-right" style={{marginBottom: '4px'}}>
          <a href="#">View ICRP Data</a>
        </div>

        <div className="position-relative">
          <MapOverlay>
            <LocationSelector />
          </MapOverlay>
          <GoogleMap />
        </div>
      </div>
    );
  }

}