import * as React from 'react';
import { DEFAULT_OPTIONS, LABELED_MAP, UNLABELED_MAP } from '../../services/MapConstants';
import { createLabel, createDataMarker, createInfoWindow, mapLabels } from '../../services/MapHelpers';
import { getNextLocationFilters, Location, ViewLevel, LocationFilters } from '../../services/DataService';
import { MarkerClusterer } from './MarkerClusterer';
import './GoogleMap.css';

export interface GoogleMapProps {
  locations: Location[];
  viewLevel: ViewLevel;
  locationFilters: LocationFilters;
  showDataLabels: boolean;
  showMapLabels: boolean;
  onSelect: (locationFilters: LocationFilters) => void;
}

class GoogleMap extends React.Component<GoogleMapProps, {}> {

  map: google.maps.Map;
  mapContainer: HTMLDivElement | null = null;

  markerClusterer: MarkerClusterer

  locations: Location[];
  markers: google.maps.Marker[] = [];
  labels: google.maps.Marker[] = [];
  infoWindows: google.maps.InfoWindow[] = [];

  async componentDidMount() {
    this.map = new google.maps.Map(this.mapContainer, DEFAULT_OPTIONS);
    this.markerClusterer = new MarkerClusterer(this.map);

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
      this.markerClusterer.clearMarkers();

      // clear all labels
      this.labels.forEach(label => {
        label.setMap(null);
      });

      this.labels = [];

      // conditionally display map lables
      this.map.setOptions({
        styles: showMapLabels ? LABELED_MAP : UNLABELED_MAP
      });

//      let numShownLocations = 0;

/**
 * export interface Location {
  label: string;
  value: string;
  coordinates: google.maps.LatLngLiteral;
  counts: LocationCounts
}

/**

export interface LocationFilters {
  searchId: number;
  type: ViewLevel;
  region?: string;
  country?: string;
  city?: string;
}

 */



      locations.forEach(location => {
        let { coordinates, counts } = location;
        let marker = createDataMarker(counts.projects, dataMarkerSize, coordinates);
        this.markerClusterer.addMarker(marker);
      });

      this.markerClusterer.getClusters().forEach(cluster => {

        let center = cluster.getCenter();
        let marker = createDataMarker(Math.floor(Math.random() * 5), dataMarkerSize, center);
        marker.setMap(map);
        marker.addListener('dblclick', event =>
          onSelect(
            getNextLocationFilters({
              label: 'US',
              value: 'US',
              coordinates: {lat: center.lat(), lng: center.lng()},
              counts: {
                projects: 0,
                primaryInvestigators: 0,
                collaborators: 0,
              },
            }, {
              searchId: 0,
              type: 'countries',
              region: '1',
            })
          )
        )
      })

      createLabel;
      createInfoWindow;
      mapLabels;
      getNextLocationFilters;
      bounds;
      onSelect;

      // // for each location, do the following:
      // locations.forEach((location: Location) => {

      //   // extract label, data, and coordinates from location
      //   let { coordinates, counts } = location;

      //   if (coordinates.lat === 0 && coordinates.lng === 0)
      //     return;

      //   numShownLocations ++;

      //   // expand the bounds for this map
      //   bounds.extend(coordinates);

      //   // add a marker at the specified location
      //   let marker = createDataMarker(counts.projects, dataMarkerSize, coordinates);

      //   this.markerClusterer.addMarker(marker);

      //   // add an info window containing the data
      //   let infoWindow = createInfoWindow(location);

      //   // store these references so we can delete them later
      //   setTimeout(() => {
      //     this.infoWindows.push(infoWindow);
      //     this.markers.push(marker);
      //   }, 0);

      //   // close all other info windows when this marker is clicked
      //   marker.addListener('click', () => {
      //     this.infoWindows.forEach(window => window.close());
      //     infoWindow.open(map, marker);
      //   });

      //   // open a new location when this is clicked
      //   if (viewLevel !== 'institutions')
      //     marker.addListener('dblclick', event => {
      //       infoWindow.close();
      //       onSelect(
      //         getNextLocationFilters(location, locationFilters)
      //       );
      //     });
      // });

      // console.log(this.markerClusterer.getClusters());

      // // if we are displaying data labels,
      // // display them above the circles
      // if (showDataLabels) {
      //   mapLabels.forEach( ({coordinates, label}) => {
      //     let latLng = new google.maps.LatLng(coordinates.lat, coordinates.lng);
      //     let projection = map.getProjection();

      //     if (projection) {
      //       let point = projection.fromLatLngToPoint(latLng);
      //       point.y -= 10 / (this.map.getZoom() - 0.5);

      //       let labelCoordinates = map.getProjection().fromPointToLatLng(point);


      //       let labelMarker = createLabel(label, labelCoordinates);
      //       labelMarker.setMap(map);

      //       window.setTimeout(() => this.labels.push(labelMarker), 0);
      //     }
      //   })
      // }

      // map.fitBounds(bounds);
      // map.setOptions({
      //   maxZoom: 15
      // });

      // if (viewLevel === 'regions') {
      //   map.setCenter({
      //     lat: 25,
      //     lng: 0,
      //   })
      //   map.setOptions({
      //     maxZoom: 4
      //   })
      //   map.setOptions({
      //     minZoom: 2
      //   })
      //   map.setZoom(2);
      // }

      // if (viewLevel === 'regions' && map.getZoom() > 3) {
      //   map.setZoom(3);
      // }

      // if (viewLevel === 'countries' && map.getZoom() > 5) {
      //   map.setZoom(5);
      // }

      // if (viewLevel === 'cities' && map.getZoom() > 7) {
      //   map.setZoom(7);
      // }

      // if (numShownLocations <= 1) {
      //   map.setZoom(2);
      //   map.setCenter({
      //     lat: 25,
      //     lng: 0,
      //   })
      // }

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