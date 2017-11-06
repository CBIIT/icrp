

type Map = google.maps.Map;
type Marker = google.maps.Marker;
type LatLng = google.maps.LatLng;

import { Location } from '../../services/DataService';

export class Cluster<E extends Location> {
  private elements: E[] = [];

  get(): E[] {
    return this.elements;
  }

  set(elements: E[]): Cluster<E> {
    this.elements = [...elements];
    return this;
  }

  public add(element: E) {
    this.set([...this.get(), element]);
  }

  public getCenter(): LatLng {

    let lat = 0;
    let lng = 0;

    for (let e of this.elements) {
      lat += e.coordinates.lat;
      lng += e.coordinates.lng;
    }

    lat /= this.elements.length;
    lng /= this.elements.length;

    return new google.maps.LatLng(lat, lng);
  }

  public getBounds(): google.maps.LatLngBounds {
    let bounds = new google.maps.LatLngBounds();

    for (let e of this.elements) {
      bounds.extend(e.coordinates);
    }

    return bounds;
  }
}

export class LocationClusterer<E extends Location> {
  private map: Map;
  private elements: E[] = [];
  private clusters: Cluster<E>[] = [];
  private radius: number = 50;
  private overlay = new google.maps.OverlayView();

  constructor(map: Map) {
    this.setMap(map);
    this.overlay.draw = ()=>{};
    this.overlay.setMap(map);
  }

  setRadius(radius: number) {
    this.radius = radius;
  }

  setMap(map: Map) {
    this.map = map;
  }

  getMap(): Map {
    return this.map;
  }

  getElements(): E[] {
    return this.elements;
  }

  setElements(elements: E[]): void {
    this.elements = elements;
    elements.forEach(e => this.addElementToClosestCluster(e));
  }

  public clearElements(): void {
    this.elements = [];
    this.clusters = [];
  }

  public addElement(element: E) {
    this.elements.push(element);
    this.addElementToClosestCluster(element);
  }

  public getClusters() {
    return this.clusters;
  }

  private addElementToClosestCluster(element: E) {

    const projection = this.overlay.getProjection();
    let p = this.map.getProjection();

    // minimum distance, in pixels from the center of the closest cluster to the marker
    let minDistance = Number.MAX_VALUE;
    let closestCluster: Cluster<E> | null = null;

    // find the closest cluster
    for (let cluster of this.clusters) {

      const distance: number = this.distanceBetween(
        projection.fromLatLngToDivPixel(cluster.getCenter()),
        projection.fromLatLngToDivPixel(new google.maps.LatLng(
          element.coordinates.lat,
          element.coordinates.lng
        ))
      );

      if (distance < minDistance) {
        minDistance = distance;
        closestCluster = cluster;
      }
    }

    if (closestCluster === null || minDistance > this.radius) {
      closestCluster = new Cluster();
      this.clusters.push(closestCluster);
      // console.log('created new cluster for element: ', element, closestCluster.getCenter().toJSON(), minDistance);
    }

    else {
      // console.log('found closest cluster for element: ', element, closestCluster.getCenter().toJSON(), minDistance);
    }

    closestCluster.add(element);
  }

  private distanceBetween(a: google.maps.Point, b: google.maps.Point) {
    return Math.sqrt((b.x - a.x) ** 2 + (b.y - a.y) ** 2);
  }
}