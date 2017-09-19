import * as React from 'react';
import { DEFAULT_OPTIONS } from '../../services/MapConstants';
import { addLabel, addDataMarker } from '../../services/MapHelpers';
import { Location } from '../../services/DataService';
import './GoogleMap.css';

export interface GoogleMapProps {
  zoom: number;
  coordinates: google.maps.LatLngLiteral;
  locations: Location[];
}

class GoogleMap extends React.Component<GoogleMapProps, {}> {

  map: google.maps.Map;
  mapContainer: HTMLDivElement | null = null;
  infoWindows: google.maps.InfoWindow[] = [];

  async componentDidMount() {
    this.map = new google.maps.Map(this.mapContainer, DEFAULT_OPTIONS);
  }

  createInfoWindow({label, data}: Location) {
    return new google.maps.InfoWindow({
      content: `
        <div>
          <b>${label}</b>
          <hr style="margin-top: 5px; margin-bottom: 5px" />
          <table class="popover-table">
            <tbody>
              <tr>
                <td>Total Projects</td>
                <td>${data.relatedProjects.toLocaleString()}</td>
              </tr>

              <tr>
                <td>Total PIs</td>
                <td>${data.primaryInvestigators.toLocaleString()}</td>
              </tr>

              <tr>
                <td>Total Collaborators</td>
                <td>${data.collaborators.toLocaleString()}</td>
              </tr>
            </tbody>
          </table>
        </div>
    `});
  }

  componentWillReceiveProps({ coordinates, locations, zoom }: GoogleMapProps) {
    if (this.map !== null) {
      let map = this.map;

      map.setZoom(zoom);
      map.setCenter(coordinates);

      map.data.forEach(feature => {
        console.log(feature);
        map.data.remove(feature);
      });

      locations.forEach((location: Location) => {
        let { label, coordinates, data } = location;

        let sum = 0;
        for (let key in data) {
          sum += data && data[key];
        }

        addLabel(label, coordinates, map);
        let marker = addDataMarker(sum, 30, coordinates, map);
        let infoWindow = this.createInfoWindow(location);
        this.infoWindows.push(infoWindow);

        marker.addListener('click', () => {
          this.infoWindows.forEach(window => window.close());
          infoWindow.open(map, marker);
        });
        marker.addListener('dblclick', event => {
          infoWindow.close();
        })
        map.addListener('click', () => infoWindow.close());
      });
    }
  }

  render() {
    return (
      <div
        className="map-container position-relative"
        ref={el => this.mapContainer = el}
      />
    );
  }
}

export default GoogleMap;