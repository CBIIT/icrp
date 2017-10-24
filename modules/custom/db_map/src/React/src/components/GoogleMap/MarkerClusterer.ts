

type Map = google.maps.Map;
type Marker = google.maps.Marker;
type LatLng = google.maps.LatLng;

export class Cluster {
  private markers: Marker[] = [];

  getMarkers(): Marker[] {
    return this.markers;
  }

  setMarkers(markers: Marker[]): Cluster {
    this.markers = [...markers];
    return this;
  }

  /**
   * Adds a marker to the marker clusterer
   *
   * @param {Marker} marker
   * @memberof MarkerClusterer
   */
  public addMarker(marker: Marker) {
    this.setMarkers([...this.getMarkers(), marker]);
  }

  public getCenter(): LatLng {
    let lat = 0;
    let lng = 0;

    for (let marker of this.markers) {
      lat += marker.getPosition().lat();
      lng += marker.getPosition().lng();
    }

    lat /= this.markers.length;
    lng /= this.markers.length;

    return new google.maps.LatLng(lat, lng);
  }
}

export class MarkerClusterer {
  private map: Map;
  private markers: Marker[] = [];
  private clusters: Cluster[] = [];
  private radius: number = 5;

  constructor(map: Map) {
    this.setMap(map);
  }

  setMap(map: Map) {
    this.map = map;
  }

  getMap(): Map {
    return this.map;
  }

  getMarkers(): Marker[] {
    return this.markers;
  }

  setMarkers(markers: Marker[]): void {
    this.markers = [...markers];
  }

  /**
   * Removes all markers from the map
   * @memberof MarkerClusterer
   */
  public clearMarkers(): void {
    for (let marker of this.getMarkers()) {
      marker.setMap(null);
    }
    this.markers = [];
    this.clusters = [];
  }

  /**
   * Adds a marker to the marker clusterer
   *
   * @param {Marker} marker
   * @memberof MarkerClusterer
   */
  public addMarker(marker: Marker) {
    //marker.setMap(this.getMap());
    this.setMarkers([...this.getMarkers(), marker]);
    this.addMarkerToClosestCluster(marker);
  }

  private addMarkerToClosestCluster(marker: google.maps.Marker) {

    const projection = this.map.getProjection();

    // minimum distance, in pixels from the center of the closest cluster to the marker
    let minDistance = Number.MAX_VALUE;

    // find the closest cluster (or null, if there are no clusters)
    let closestCluster = this.clusters.reduce((closest: Cluster | null, cluster: Cluster) => {
      const distance: number = this.distanceBetween(
        projection.fromLatLngToPoint(cluster.getCenter()),
        projection.fromLatLngToPoint(marker.getPosition())
      );

      if (distance < minDistance) {
        minDistance = distance;
        return cluster;
      }

      return closest;
    }, null);

    if (closestCluster === null || minDistance > this.radius) {
      closestCluster = new Cluster();
      this.clusters.push(closestCluster);
      console.log('created new cluster for marker: ', marker.getLabel().text, closestCluster.getCenter().toJSON(), minDistance);
    }

    else {
      console.log('found closest cluster for marker: ', marker.getLabel().text, closestCluster.getCenter().toJSON(), minDistance);
    }

    closestCluster.addMarker(marker);
  }

  public getClusters() {
    return this.clusters;
  }


  private distanceBetween(a: google.maps.Point, b: google.maps.Point) {
    return Math.sqrt((b.x - a.x) ** 2 + (b.y - a.y) ** 2);
  }

  /**
   * Creates a matrix of clusters containing Markers pertaining
   * to each grid location
   *
   * @returns {Cluster[][]}
   * @memberof MarkerClusterer
  public getClusters(): Cluster[][] {
    let width = this.map.getDiv().clientWidth;
    let height = this.map.getDiv().clientHeight;
    let clusters: Cluster[][] = [[]];

    let maxRow = Math.ceil(height / this.gridSize);
    let maxCol = Math.ceil(width / this.gridSize);

    console.log(`creating clusters from div of size, (${width}, ${height})
      Max_Row: ${maxRow},
      Max_Col: ${maxCol},
    `);

    // assign an array of markers to each grid in the cluster
    for (let row = 0; row < maxRow; row ++) {
      clusters[row] = [];
      for (let col = 0; col < maxCol; col ++) {
        let cluster = new Cluster();

        let southWest = new google.maps.Point(
          (col) * this.gridSize,
          (row + 1) * this.gridSize,
        );

        let northEast = new google.maps.Point(
          (col + 1) * this.gridSize,
          (row) * this.gridSize,
        );

        let div = document.createElement('div');
        div.style.position = 'absolute';
        div.style.left = `${southWest.x}px`;
        div.style.top = `${northEast.y}px`;
        div.style.width = `${this.gridSize}px`
        div.style.height = `${this.gridSize}px`
        div.textContent = `(${row}, ${col})`;
        div.style.borderRight = '1px solid #555';
        div.style.borderBottom = '1px solid #555';
        div.style.backgroundColor = '#fff';
        div.style.opacity = '0.5';
        div.style.zIndex = '99999';
        div.style.pointerEvents = 'none';

        this.map.getDiv().appendChild(div);

        let bounds = new google.maps.LatLngBounds(
          this.pointToLatLng(southWest),
          this.pointToLatLng(northEast)
        );


        cluster.setMarkers(
          this.getMarkers().filter(marker =>
            bounds.contains(marker.getPosition())
          )
        );

        clusters[row][col] = cluster;
      }
    }

    this.createDebugGrid(0, 0);

    return clusters;
  }

  private createDebugGrid(x: number, y: number) {

  }

  private pointToLatLng(point: google.maps.Point) {
    return this.getMap()
      .getProjection()
      .fromPointToLatLng(point);
  }
   */

}