import * as React from 'react';
import { DEFAULT_OPTIONS, LABELED_MAP, UNLABELED_MAP } from '../../services/MapConstants';
import { addLabel, addDataMarker, createInfoWindow } from '../../services/MapHelpers';
import { Location, ViewLevel } from '../../services/DataService';
import './GoogleMap.css';

export interface GoogleMapProps {
  locations: Location[];
  viewLevel: ViewLevel;
  showDataLabels: boolean;
  showMapLabels: boolean;
  onSelect: (location: Location) => void;
}

const sum = (object: any): number => {
  let sum = 0;
  for (let key in object) {
    sum += object && object[key];
  }
  return sum;
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



  componentWillReceiveProps({ viewLevel, locations, showDataLabels, showMapLabels }: GoogleMapProps) {

    if (this.map !== null && locations !== this.locations) {

      this.locations = locations;

      let map = this.map;
      let bounds = new google.maps.LatLngBounds();
      let dataMarkerSize = locations.length > 10 ? 22 : 30;
      let { onSelect} = this.props;

      // clear all markers
      this.markers.forEach(marker => {
        marker.setMap(null);
      })

      // clear all labels
      this.labels.forEach(labels => {
        labels.setMap(null);
      })

      // conditionally display map lables
      this.map.setOptions({
        styles: showMapLabels ? LABELED_MAP : UNLABELED_MAP
      });


      // for each location, do the following:
      locations.forEach((location: Location) => {

        // extract label, data, and coordinates from location
        let { coordinates, data, label } = location;

        // expand the bounds for this map
        bounds.extend(coordinates);

        // if we are displaying data labels,
        // display them above the circles
        if (showDataLabels) {
          let labelCoordinates: google.maps.LatLngLiteral = {
            lng: coordinates.lng + dataMarkerSize + 5,
            ...coordinates
          }
          let labelMarker = addLabel(label, labelCoordinates, map);
          window.setTimeout(() => this.labels.push(labelMarker), 0);
        }

        // add a marker at the specified location
        let marker = addDataMarker(sum(data), dataMarkerSize, coordinates, map);

        // add an info window containing the data
        let infoWindow = createInfoWindow(location);

        // store these references so we can delete them later
        window.setTimeout(() => {
          this.infoWindows.push(infoWindow);
          this.markers.push(marker);
        }, 0);

        // close all other info windows when this marker is clicked
        marker.addListener('click', () => {
          this.infoWindows.forEach(window => window.close());
          infoWindow.open(map, marker);
        });

        // open a new location when this is clicked
        marker.addListener('dblclick', event => {
          infoWindow.close();
          onSelect(location);
        });
      });

      map.fitBounds(bounds);
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