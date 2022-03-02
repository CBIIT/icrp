import * as React from 'react';
import { DEFAULT_OPTIONS, LABELED_MAP, UNLABELED_MAP, DETAILED_MAP } from '../../services/MapConstants';
import { createLabel, createDataMarker, createInfoWindow, mapLabels } from '../../services/MapHelpers';
import { getNextLocationFilters, Location, ViewLevel, LocationFilters, LocationCounts, parseViewLevel } from '../../services/DataService';
import { LocationClusterer } from './LocationClusterer';
import {
  MapOverlay,
  ViewLevelSelector
} from '..';
import './GoogleMap.css';
import { store } from '../../services/Store';

export interface GoogleMapProps {
  children?: JSX.Element;
  locations: Location[];
  viewLevel: ViewLevel;
  locationFilters: LocationFilters;
  showDataLabels: boolean;
  showMapLabels: boolean;
  onSelect: (locationFilters: LocationFilters) => void;
}

class GoogleMap extends React.Component<GoogleMapProps, {}> {

  map: google.maps.Map;
  overlay: google.maps.OverlayView;
  mapContainer: HTMLDivElement | null = null;
  clusterer: LocationClusterer<Location>;

  locations: Location[];
  markers: google.maps.Marker[] = [];
  labels: google.maps.Marker[] = [];
  infoWindows: google.maps.InfoWindow[] = [];
  shouldRedraw: boolean = false;
  shouldFitBounds: boolean = false;
  clusterClicked: boolean = false;
  // override = false;

  componentDidMount() {
    this.map = new google.maps.Map(this.mapContainer, DEFAULT_OPTIONS);
    this.clusterer = new LocationClusterer(this.map);
    this.clusterer.setRadius(45);

    this.overlay = new google.maps.OverlayView();
    this.overlay.setMap(this.map);
    this.overlay.draw = () => {};

    this.map.addListener('click', (event: google.maps.MouseEvent) => {
      this.infoWindows.forEach(window => window.close());
      // console.log(event.latLng.lat(), event.latLng.lng());
    });

    this.map.addListener('idle', (event) => {
      if (this.shouldRedraw) {
        this.redrawMap();
        this.shouldRedraw = false;
      }
    })

    this.map.addListener('zoom_changed', () => {
      // this.shouldFitBounds = false;

      if (this.map.getZoom() < 3) {
        this.map.setOptions({
          styles: UNLABELED_MAP
        });
      }

      else {
        this.map.setOptions({
          styles: DETAILED_MAP
        });
      }

      // we should redraw clusters by default
      if (this.shouldRedraw || !this.clusterClicked) {
        setTimeout(() => {
          this.redrawMap()
        }, 200);
      }

      // markers do not display sometimes unless the map is panned slightly
      setTimeout(() => {
        var center = this.map.getCenter();
        this.map.panTo({lng: center.lng(), lat: center.lat() + 0.000001});
        this.map.panTo({lng: center.lng(), lat: center.lat() - 0.000001});
      }, 400);
    });

    this.map.controls[google.maps.ControlPosition.TOP_LEFT].push(this.refs.mapoverlay['childNodes'][0]);
    window['createOverlayForMap'] && window['createOverlayForMap'](this.map);
  }

  componentWillReceiveProps(props: GoogleMapProps) {
    this.props = props;

    // console.log('recieved new map props', props);

    // redraw this map when recieving new properties
    if (this.map !== null && this.overlay && props.locations !== this.locations) {
      // console.log('drawing');

      // this.override = false;
      this.shouldFitBounds = true;
      this.shouldRedraw = false;

      this.locations = props.locations;

      // clear all region labels
      this.labels.forEach(label => label.setMap(null));
      this.labels = [];

      // fit to bounds before redrawing map
      if (this.locations.length > 1) {
        let bounds = new google.maps.LatLngBounds();
        let projection = this.map.getProjection();
        let proj = this.overlay.getProjection();

        if (!proj || !projection) {
          window.location.reload();
        }

        props.locations.map(loc => loc.coordinates)
          .filter(coords => coords.lat != 0 && coords.lng != 0)
          .filter(coords => coords.lat >= -90 && coords.lat <= 90)
          .filter(coords => coords.lng >= -180 && coords.lng <= 180)
          .forEach(latlng => bounds.extend(latlng));

        let northEast = bounds.getNorthEast();
        let southWest = bounds.getSouthWest();

        let diagonalDistance = google.maps.geometry.spherical.computeDistanceBetween(northEast, southWest);

        let northEastPoint = proj.fromLatLngToDivPixel(northEast);
        let southWestPoint = proj.fromLatLngToDivPixel(southWest);

        let length = northEastPoint.x - southWestPoint.x;
        let height = southWestPoint.y - northEastPoint.y;

        // console.log('length, height', length, height, diagonalDistance);

        let scaleX = 1.0;
        let scaleY = 1.0;

        if (diagonalDistance > 100) {
          let scaleFactor = Math.log(diagonalDistance) / 1000;
          // console.log('increasing scale:', scaleFactor);

          if (diagonalDistance > 1000000) {
            scaleX += scaleFactor * 5;
            scaleY += scaleFactor * 5;
          }

          else if (scaleFactor > 0.01) {
            scaleX += scaleFactor;
            scaleY += scaleFactor;
          }

          else {
            scaleX += scaleFactor / 10;
            scaleY += scaleFactor / 10;
          }
        }

        northEastPoint.x *= scaleX;
        northEastPoint.y /= scaleY;

        southWestPoint.x /= scaleX;
        southWestPoint.y *= scaleY;

        northEast = proj.fromDivPixelToLatLng(northEastPoint);
        southWest = proj.fromDivPixelToLatLng(southWestPoint);
        bounds.extend(northEast);
        bounds.extend(southWest);

        this.map.fitBounds(bounds);
      }

      else {
        // this.applyDefaultView();
      }

      this.shouldRedraw = true;

      if (props.locations.length === 1) {
        this.map.setCenter(props.locations[0].coordinates);

        if (props.viewLevel === 'countries') {
          this.map.setZoom(4);
          return;
        }

        else {
          this.map.setZoom(this.map.getZoom() + 1);
          return;
        }
      }

      if (props.viewLevel === 'regions') {
        this.applyDefaultView();
        return;
      }

      this.shouldRedraw = true;
      this.map.setZoom(this.map.getZoom());
    }
  }

  applyDefaultView() {
    this.map.setCenter({
      lat: 25,
      lng: 0
    });
    this.map.setZoom(2);
  }

  redrawMap() {
    const { viewLevel, locationFilters, showDataLabels, showMapLabels, onSelect } = this.props;
    let { map, clusterer, locations, labels, markers, infoWindows } = this;

    if (map !== null) {
      let dataMarkerSize = 25;

      // clear all region labels
      labels.forEach(label => label.setMap(null));
      labels = [];

      // clear all markers
      markers.forEach(marker => marker.setMap(null));
      markers = [];

      // recreate location clusters
      clusterer.clearElements();
      clusterer.setElements(
        locations
        .filter(({coordinates}) => coordinates.lat != 0 && coordinates.lng != 0)
        .filter(({coordinates}) => coordinates.lat >= -90 && coordinates.lat <= 90)
        .filter(({coordinates}) => coordinates.lng >= -180 && coordinates.lng <= 180)
      );

      // console.log(clusterer.getClusters());

      // draw each cluster
      let clusters = this.clusterer.getClusters();
      clusters.forEach(cluster => {
        let clusterLocations = cluster.get();

        // show a single location
        if (clusterLocations.length === 1) {
          let location = clusterLocations[0];
          let { coordinates, counts } = location;

          let fillColor = '#0690e0';
          let strokeColor = '#89C4F4';
          let textColor = '#ffffff';
          let strokeWeight = 4;

          if (viewLevel === 'institutions') {
            fillColor = '#ffffff';
            strokeColor = '#0690e0';
            textColor = '#0690e0';
            strokeWeight = 6;
          }

          let marker = createDataMarker(
            counts.projects,
            this.calculateMarkerSize(counts.projects),
            coordinates,
            fillColor,
            strokeColor,
            textColor,
            strokeWeight
          );
          marker.setMap(map);

          let infowindowLabel = `${parseViewLevel(viewLevel)}: ${location.label}`
          let locationInfo = {
            ...location,
            label: infowindowLabel
          }

          // add an info window containing the data
          let infoWindowCallback: undefined | (() => void)  =
            viewLevel !== 'institutions'
              ? () => onSelect(getNextLocationFilters(location, locationFilters))
              : undefined;

          let infoWindow = createInfoWindow(locationInfo, infoWindowCallback);

          // store these references so we can delete them later
          // setTimeout(() => {
            this.infoWindows.push(infoWindow);
            this.markers.push(marker);
          // }, 0);

          // close all other info windows when this marker is clicked
          marker.addListener('click', () => {
            this.infoWindows.forEach(window => window.close());
            infoWindow.open(map, marker);
          });

          // open a new location when this is clicked
          if (viewLevel !== 'institutions')
            marker.addListener('dblclick', event => {
              infoWindow.close();
              onSelect(
                getNextLocationFilters(location, locationFilters)
              );
            });
        }

        // show a clustered location
        else if (clusterLocations.length > 1) {
          let center = cluster.getCenter();

          let counts = clusterLocations.reduce((acc: LocationCounts, location: Location) => {
            const {projects, primaryInvestigators, collaborators} = location.counts;

            acc.projects += projects;
            acc.primaryInvestigators += primaryInvestigators;
            acc.collaborators += collaborators;

            return acc;
          }, {
            projects: 0,
            primaryInvestigators: 0,
            collaborators: 0
          });

          let maxLocation = clusterLocations.reduce((acc: Location, curr: Location) =>
            curr.counts.projects > acc.counts.projects
              ? curr
              : acc
          , clusterLocations[0]);

          let topLocation = maxLocation.label;
          let numLocations = clusterLocations.length - 1;

          let viewLevelNoun = viewLevel;

          if (numLocations === 1) {
            viewLevelNoun = {
              regions: 'region',
              countries: 'country',
              cities: 'city',
              institutions: 'institution',
            }[viewLevelNoun] as ViewLevel || viewLevelNoun;
          }


          let clusteredLocation: Location = {
            label: `${parseViewLevel(viewLevel)} Cluster: ${topLocation} and ${numLocations} other ${viewLevelNoun}`,
            value: '',
            coordinates: {lat: center.lat(), lng: center.lng()},
            counts: counts
          };

          let marker = createDataMarker(
            counts.projects,
            this.calculateMarkerSize(counts.projects),
            clusteredLocation.coordinates,
            '#F4BD00',
            '#FFE280'
          );

          marker.setMap(map);

          // add an info window containing the data
          let infoWindowCallback = () => {
            this.shouldRedraw = false;
            store.setMapLocations(cluster.get());
            this.shouldRedraw = true;
          }

          let infoWindow = createInfoWindow(clusteredLocation, infoWindowCallback);

          // store these references so we can delete them later
          // setTimeout(() => {
            this.infoWindows.push(infoWindow);
            this.markers.push(marker);
          // }, 0);

          // close all other info windows when this marker is clicked
          marker.addListener('click', () => {
            this.infoWindows.forEach(window => window.close());
            infoWindow.open(map, marker);
          });

          marker.addListener('dblclick', event => {
            infoWindow.close();
            this.shouldRedraw = false;
            store.setMapLocations([...cluster.get()]);
            this.shouldRedraw = true;
          });
        }
      });

      // if we are displaying data labels,
      // display them above the circles
      if (showDataLabels) {
        mapLabels.forEach( ({coordinates, label}) => {
          let latLng = new google.maps.LatLng(coordinates.lat, coordinates.lng);
          let projection = map.getProjection();

          if (projection) {
            // let point = projection.fromLatLngToPoint(latLng);
            // point.y -= 10 / (this.map.getZoom() - 0.5);
            // let labelCoordinates = map.getProjection().fromPointToLatLng(point);

            let labelMarker = createLabel(label, {lat: latLng.lat() + 6, lng: latLng.lng()});
            labelMarker.setMap(map);

            // window.setTimeout(() =>
              this.labels.push(labelMarker)
            // , 0);
          }
        })
      }

      this.shouldRedraw = true;
    }
  }

  calculateMarkerSize(count: number) {
    return 16 + Math.floor(Math.log10(count)) * 2.9;
  }

  render() {
    return (
      <div ref="mapoverlay">
        <MapOverlay>
          <ViewLevelSelector onSelect={locationFilters => this.props.onSelect(locationFilters)} />
        </MapOverlay>
        <div
          className="map-container position-relative"
          ref={el => this.mapContainer = el}
        />
      </div>
    );
  }
}

export default GoogleMap;
