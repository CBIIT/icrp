import * as React from 'react';
import { DEFAULT_OPTIONS, MAP_LABELED, MAP_DEFAULT_STYLE } from '../../services/MapConstants';
import { addLabel, addDataMarker } from '../../services/MapHelpers';
import { Location } from '../../services/DataService';
import './GoogleMap.css';

export interface GoogleMapProps {
  zoom: number;
  coordinates: google.maps.LatLngLiteral;
  autofit: boolean;
  locations: Location[];
  showDataLabels: boolean;
  showMapLabels: boolean;
  onSelect: (location: Location) => void;
}

class GoogleMap extends React.Component<GoogleMapProps, {}> {

  map: google.maps.Map;
  mapContainer: HTMLDivElement | null = null;

  locations: Location[];
  markers: google.maps.Marker[] = [];
  labels: google.maps.Marker[] = [];
  infoWindows: google.maps.InfoWindow[] = [];

  async componentDidMount() {
    this.map = new google.maps.Map(this.mapContainer, DEFAULT_OPTIONS);

    this.map.addListener('click', () => {
      this.infoWindows.forEach(window => window.close());
    });
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



  componentWillReceiveProps({ coordinates, locations, zoom, showDataLabels, showMapLabels }: GoogleMapProps) {

    if (this.map !== null && locations !== this.locations) {

      this.locations = locations;
      let { onSelect} = this.props;

      let map = this.map;
      let bounds = new google.maps.LatLngBounds();

      if (!this.props.autofit) {
        map.setZoom(zoom);
        map.setCenter(coordinates);
      }

      map.data.forEach(feature => {
        console.log(feature);
      });

      this.markers.forEach(marker => {
        marker.setMap(null);
      })

      this.labels.forEach(labels => {
        labels.setMap(null);
      })

      this.map.setOptions({
        styles: showMapLabels ? MAP_LABELED : MAP_DEFAULT_STYLE
      });

      let dataMarkerSize = locations.length > 10 ? 22 : 30;

      locations.forEach((location: Location) => {
        let { label, coordinates, data } = location;

        if (this.props.autofit) {
          bounds.extend(coordinates);
          map.fitBounds(bounds);
        }

        let sum = 0;
        for (let key in data) {
          sum += data && data[key];
        }

        if (showDataLabels) {
          let labelMarker = addLabel(label, coordinates, map);
          window.setTimeout(() => this.labels.push(labelMarker), 0);
        }

        let marker = addDataMarker(sum, dataMarkerSize, coordinates, map);
        let infoWindow = this.createInfoWindow(location);

        window.setTimeout(() => {
          this.infoWindows.push(infoWindow);
          this.markers.push(marker);
        }, 0);

        marker.addListener('click', () => {
          this.infoWindows.forEach(window => window.close());
          infoWindow.open(map, marker);
        });

        marker.addListener('dblclick', event => {
          infoWindow.close();
          onSelect(location);
        });
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