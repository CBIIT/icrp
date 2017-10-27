import * as React from 'react';
import { DEFAULT_OPTIONS, LABELED_MAP, UNLABELED_MAP } from '../../services/MapConstants';
import { createLabel, createDataMarker, createInfoWindow, mapLabels } from '../../services/MapHelpers';
import { getNextLocationFilters, Location, ViewLevel, LocationFilters, LocationCounts } from '../../services/DataService';
import { LocationClusterer } from './LocationClusterer';
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
  clusterer: LocationClusterer<Location>;

  locations: Location[];
  markers: google.maps.Marker[] = [];
  labels: google.maps.Marker[] = [];
  infoWindows: google.maps.InfoWindow[] = [];
  shouldRedraw: boolean = false;
  shouldFitBounds: boolean = false;

  async componentDidMount() {
    this.map = new google.maps.Map(this.mapContainer, DEFAULT_OPTIONS);
    this.clusterer = new LocationClusterer(this.map);
    this.clusterer.setRadius(70);

    this.map.addListener('click', (event: google.maps.MouseEvent) => {
      this.infoWindows.forEach(window => window.close());
      // console.log(event.latLng.lat(), event.latLng.lng());
    });

    this.map.addListener('zoom_changed', () => {
      this.shouldFitBounds = false;

      // we should redraw clusters by default
      if (this.shouldRedraw) {
        this.redrawMap();
      }
    });

    window['createOverlayForMap'](this.map);
  }

  componentWillReceiveProps(props: GoogleMapProps) {
    this.props = props;

    // redraw this map when recieving new properties
    if (this.map !== null && props.locations !== this.locations) {
      this.shouldFitBounds = true;
      this.shouldRedraw = false;

      this.locations = props.locations;

      // clear all region labels
      this.labels.forEach(label => label.setMap(null));
      this.labels = [];

      // fit to bounds before redrawing map
      let bounds = new google.maps.LatLngBounds();
      props.locations.map(loc => loc.coordinates)
        .filter(coords => coords.lat != 0 && coords.lng != 0)
        .forEach(latlng => bounds.extend(latlng));
      this.map.fitBounds(bounds);

      console.log('fitted map to bounds: ', bounds);

      this.shouldRedraw = true;
      this.redrawMap();
    }
  }

  redrawMap() {
    const { viewLevel, locationFilters, showDataLabels, showMapLabels, onSelect } = this.props;
    let { map, clusterer, locations, labels, markers, infoWindows } = this;

    if (map !== null) {
      // let bounds = new google.maps.LatLngBounds();
      let dataMarkerSize = 24 - 3.5 / Math.floor(Math.log10(
        Math.max(... locations.map(location => location.counts.projects))
      ));

      // display google map labels if showMapLabels is true
      this.map.setOptions({
        styles: showMapLabels ? LABELED_MAP : UNLABELED_MAP
      });

      // clear all region labels
      labels.forEach(label => label.setMap(null));
      labels = [];

      // clear all markers
      markers.forEach(marker => marker.setMap(null));
      markers = [];

      // recreate location clusters
      clusterer.clearElements();
      clusterer.setElements(locations
        .filter(({coordinates}) =>
          coordinates.lat != 0 && coordinates.lng != 0
        ))

      // draw each cluster
      this.clusterer.getClusters().forEach(cluster => {
        let clusterLocations = cluster.get();

        // show a single location
        if (clusterLocations.length === 1) {
          let location = clusterLocations[0];
          let { coordinates, counts } = location;
          let marker = createDataMarker(counts.projects, dataMarkerSize, coordinates);
          marker.setMap(map);

          // add an info window containing the data
          let infoWindow = createInfoWindow(location);

          // store these references so we can delete them later
          setTimeout(() => {
            this.infoWindows.push(infoWindow);
            this.markers.push(marker);
          }, 0);

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

          let clusteredLocation: Location = {
            label: `${clusterLocations.length} ${viewLevel}`,
            value: '',
            coordinates: {lat: center.lat(), lng: center.lng()},
            counts: counts
          };

          let marker = createDataMarker(
            counts.projects,
            dataMarkerSize,
            clusteredLocation.coordinates,
            '#EB9532',
            '#EB974E',
          );

          marker.setMap(map);

          // add an info window containing the data
          let infoWindow = createInfoWindow(clusteredLocation);

          // store these references so we can delete them later
          setTimeout(() => {
            this.infoWindows.push(infoWindow);
            this.markers.push(marker);
          }, 0);

          // close all other info windows when this marker is clicked
          marker.addListener('click', () => {
            this.infoWindows.forEach(window => window.close());
            infoWindow.open(map, marker);
          });

          marker.addListener('dblclick', event => {
            infoWindow.close();
            this.shouldRedraw = false;
            map.fitBounds(cluster.getBounds())
            this.redrawMap();
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
            let point = projection.fromLatLngToPoint(latLng);
            point.y -= 10 / (this.map.getZoom() - 0.5);

            let labelCoordinates = map.getProjection().fromPointToLatLng(point);
            let labelMarker = createLabel(label, labelCoordinates);
            labelMarker.setMap(map);

            window.setTimeout(() => this.labels.push(labelMarker), 0);
          }
        })
      }

      if (viewLevel === 'regions') {
        map.setCenter({
          lat: 25,
          lng: 0,
        })
      }

      if (clusterer.getElements().length === 1) {
        this.shouldRedraw = false;
        map.setZoom(4);
        map.setCenter(clusterer.getElements()[0].coordinates);
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