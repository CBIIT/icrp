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

  async componentDidMount() {
    this.map = new google.maps.Map(this.mapContainer, DEFAULT_OPTIONS);
    this.clusterer = new LocationClusterer(this.map);

    this.map.addListener('click', (event: google.maps.MouseEvent) => {
      this.infoWindows.forEach(window => window.close());
      console.log(event.latLng.lat(), event.latLng.lng());
    });

    this.map.addListener('zoom_changed', () => {
      console.log('zoom changed')
      if (this.shouldRedraw) {
        this.redrawMap();
      }

      else {
        this.shouldRedraw = true;
      }
    })
  }

  componentWillReceiveProps(props: GoogleMapProps) {
    this.props = props;

    if (this.map !== null && props.locations !== this.locations) {
      this.redrawMap();
    }
  }


  redrawMap() {
    const { viewLevel, locations, locationFilters, showDataLabels, showMapLabels, onSelect } = this.props;
    const map = this.map;

    if (this.map !== null) {
      this.locations = locations;

      let bounds = new google.maps.LatLngBounds();

      let dataMarkerScale = Math.floor(Math.log10(
        Math.max(... locations.map(location => location.counts.projects))
      ));

///      let dataMarkerSize = dataMarkerScale * 6;
      let dataMarkerSize = 24 - 3.5 / dataMarkerScale;

      // display google map labels if showMapLabels is true
      this.map.setOptions({
        styles: showMapLabels ? LABELED_MAP : UNLABELED_MAP
      });

      // clear all region labels
      this.labels.forEach(label => label.setMap(null));
      this.labels = [];

      this.markers.forEach(marker => marker.setMap(null));
      this.markers = [];

      this.clusterer.clearElements();
      locations.forEach(location => {
        if (location.coordinates.lat != 0 && location.coordinates.lng != 0)
          this.clusterer.addElement(location)
      });

      this.clusterer.getClusters().forEach(cluster => {
        let clusterLocations = cluster.get();
        bounds.extend(cluster.getCenter());

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
            '#E08283',
            '#F64747',
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

            let proj = map.getProjection();
            let pos = marker.getPosition()
            console.log(pos.lat(), pos.lng());

            let pt = proj.fromLatLngToPoint(pos);
            console.log(pt);

            console.log(cluster);

            this.infoWindows.forEach(window => window.close());
            infoWindow.open(map, marker);
          });

          marker.addListener('dblclick', event => {
            infoWindow.close();
            //map.setZoom(map.getZoom() + 1);
            this.shouldRedraw = false;
            map.fitBounds(cluster.getBounds())
            this.redrawMap();
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

      this.shouldRedraw = false;

      // bounds.extend({
      //   lat: bounds.getNorthEast().lat() + 5,
      //   lng: bounds.getNorthEast().lng() + 5
      // });

      // bounds.extend({
      //   lat: bounds.getSouthWest().lat() - 5,
      //   lng: bounds.getSouthWest().lng() - 5
      // });

      map.fitBounds(bounds);
    //   map.setOptions({
    //     maxZoom: 15
    //   });

    //   if (viewLevel === 'regions') {
    //     this.shouldRedraw = false;
    //     map.setCenter({
    //       lat: 25,
    //       lng: 0,
    //     })
    //     map.setOptions({
    //       maxZoom: 4
    //     })
    //     map.setOptions({
    //       minZoom: 2
    //     })
    //     this.shouldRedraw = false;
    //     map.setZoom(2);
    //   }

    //   if (viewLevel === 'regions' && map.getZoom() > 3) {
    //     map.setZoom(3);
    //   }

    //   if (viewLevel === 'countries' && map.getZoom() > 5) {
    //     map.setZoom(5);
    //   }

    //   if (viewLevel === 'cities' && map.getZoom() > 7) {
    //     map.setZoom(7);
    //   }

    //   if (false || true) {
    //     map.setZoom(2);
    //     map.setCenter({
    //       lat: 25,
    //       lng: 0,
    //     })
    //   }
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