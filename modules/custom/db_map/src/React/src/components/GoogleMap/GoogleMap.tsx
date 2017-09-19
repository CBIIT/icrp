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

  async componentDidMount() {
    this.map = new google.maps.Map(this.mapContainer, DEFAULT_OPTIONS);
  }

  componentWillReceiveProps(nextProps: GoogleMapProps) {
    if (this.map !== null) {
      let { coordinates, locations, zoom } = nextProps;

      this.map.setZoom(zoom);
      this.map.setCenter(coordinates);

      this.map.data.forEach(feature =>
        this.map.data.remove(feature));

      locations.forEach((location: Location) => {
        let { label, coordinates, data } = location;

        let sum = 0;
        for (let key in data || {}) {
          sum += data && data[key];
        }

        addLabel(label, coordinates, this.map);
        addDataMarker(sum, 30, coordinates, this.map);
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