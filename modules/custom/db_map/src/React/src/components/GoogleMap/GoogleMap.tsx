import * as React from 'react';
import * as qs from 'query-string';
import { LocationSelector, SearchCriteria } from '..'
import { DEFAULT_OPTIONS } from '../../services/MapConstants';
import { addLabel, addDataMarker } from '../../services/MapHelpers';
import * as DataService from '../../services/DataService';
import './GoogleMap.css';

class GoogleMap extends React.Component<
  object,
  {
    counts: {
      projects: number,
      primaryInvestigators: number,
      collaborators: number,
    }
  }
> {

  map: google.maps.Map;
  mapContainer: HTMLDivElement | null = null;
  state = {
    counts: {
      projects: 0, 
      primaryInvestigators: 0, 
      collaborators: 0,
    }
  }


  async componentDidMount() {
    this.map = new google.maps.Map(this.mapContainer, DEFAULT_OPTIONS);
    let searchId = qs.parse(window.location.search).sid || 0;

    let data = await DataService.getAllRegions(searchId);
    let regions = data.regions;
    let counts = data.counts;

    regions.forEach(region => {
      let location = {
        lat: region.coordinates.latitude,
        lng: region.coordinates.longitude,
      };

      let total: number = Object.keys(region.data)
        .map(key => region.data[key])
        .reduce((acc, curr) => acc + curr, 0)

      addLabel(region.label, location, this.map);
      addDataMarker(total, 30, location, this.map);
    });

    this.setState({counts});
  }

  render() {
    return (

      <div>
        <SearchCriteria {...this.state.counts} />
        <div className="text-right" style={{marginBottom: '4px'}}>
          <a href="#">View ICRP Data</a>
        </div>

        <div className="position-relative">
          <div className="map-overlay position-absolute translucent">
          </div>
          <div className="map-overlay position-absolute">
            <LocationSelector />
          </div>


          <div className="map-container position-relative" ref={el => this.mapContainer = el} />
        </div>
      </div>
    );
  }
}

export default GoogleMap;