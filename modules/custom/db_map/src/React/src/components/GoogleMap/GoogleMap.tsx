import * as React from 'react';
import { DEFAULT_OPTIONS, LABELED_MAP, UNLABELED_MAP } from '../../services/MapConstants';
import { createLabel, addDataMarker, createInfoWindow } from '../../services/MapHelpers';
import { getNextLocationFilters, Location, ViewLevel, LocationFilters } from '../../services/DataService';
import './GoogleMap.css';

declare const MarkerClusterer: object;

export interface GoogleMapProps {
  locations: Location[];
  viewLevel: ViewLevel;
  locationFilters: LocationFilters;
  showDataLabels: boolean;
  showMapLabels: boolean;
  onSelect: (locationFilters: LocationFilters) => void;
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

  componentWillReceiveProps({ viewLevel, locations, locationFilters, showDataLabels, showMapLabels }: GoogleMapProps) {

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
      this.labels.forEach(label => {
        label.setMap(null);
      });

      this.labels = [];

      // conditionally display map lables
      this.map.setOptions({
        styles: showMapLabels ? LABELED_MAP : UNLABELED_MAP
      });

      MarkerClusterer;

      // for each location, do the following:
      locations.forEach((location: Location) => {

        // extract label, data, and coordinates from location
        let { coordinates, counts, label } = location;

        if (coordinates.lat === 0 && coordinates.lng === 0)
          return;

        // expand the bounds for this map
        bounds.extend(coordinates);

        // if we are displaying data labels,
        // display them above the circles
        if (showDataLabels) {
          let latLng = new google.maps.LatLng(coordinates.lat, coordinates.lng);

          let projection = map.getProjection();

          if (projection) {
            let point = projection.fromLatLngToPoint(latLng);
            point.y -= 10 / (this.map.getZoom() - 0.5);
  
            let labelCoordinates = map.getProjection().fromPointToLatLng(point);
            let labelMarker = createLabel(label, labelCoordinates);
            labelMarker.setMap(map);
            window.setTimeout(() => this.labels.push(labelMarker), 0);
          }
        }

        // add a marker at the specified location
        let marker = addDataMarker(sum(counts), dataMarkerSize, coordinates, map);

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
        if (viewLevel !== 'cities')
          marker.addListener('dblclick', event => {
            infoWindow.close();
            onSelect(
              getNextLocationFilters(location, locationFilters)
            );
          });
      
        });

      map.fitBounds(bounds);
      map.setOptions({
        maxZoom: 15
      });

      if (viewLevel === 'regions') {
        map.setCenter({
          lat: 25,
          lng: 0,
        })
        map.setOptions({
          maxZoom: 4
        })
        map.setOptions({
          minZoom: 2
        })
        map.setZoom(2);
      }

      if (viewLevel === 'regions' && map.getZoom() > 3) {
        map.setZoom(3);
      }

      if (viewLevel === 'countries' && map.getZoom() > 5) {
        map.setZoom(5);
      }


      if (viewLevel === 'cities' && map.getZoom() > 7) {
        map.setZoom(7);
      }

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