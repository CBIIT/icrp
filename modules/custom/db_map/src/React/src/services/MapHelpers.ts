import { Location } from './DataService';

export const createLabel = (label: string, location: google.maps.LatLngLiteral | google.maps.LatLng) =>
  new google.maps.Marker({
    position: location,
    zIndex: 0,
    label: {
      color: '#336E7B',
      text: label.toLocaleUpperCase(),
      fontSize: '17px',
      fontWeight: '500',
      fontFamily: `
        -apple-system, system-ui, BlinkMacSystemFont,
        "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell,
        "Fira Sans", "Droid Sans", "Helvetica Neue",
        Arial, sans-serif`,
    },
    icon: {
      path: 'M 0 0',
      strokeOpacity: 0,
    },
  });

export const createDataMarker = (label: number, scale: number, location: google.maps.LatLngLiteral  | google.maps.LatLng) =>
  new google.maps.Marker({
    position: location,
    zIndex: 2,
    label: {
      color: 'white',
      text: label.toLocaleString(),
      fontSize: '13px',
      fontWeight: '500',
      fontFamily: `
        -apple-system, system-ui, BlinkMacSystemFont,
        "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell,
        "Fira Sans", "Droid Sans", "Helvetica Neue",
        Arial, sans-serif`,
    },
    icon: {
      path: google.maps.SymbolPath.CIRCLE,
      scale: scale,
      fillOpacity: 0.6,
      strokeOpacity: 0.4,
      fillColor: '#2574A9',
      strokeColor: '#52B3D9',
      strokeWeight: 4,
    },
  });

export const createInfoWindow = ({label, counts}: Location) =>
  new google.maps.InfoWindow({
    content: `
      <div>
        <b>${label}</b>
        <hr style="margin-top: 5px; margin-bottom: 5px" />
        <table class="popover-table">
          <tbody>
            <tr>
              <td>Total Related Projects</td>
              <td>${counts.projects.toLocaleString()}</td>
            </tr>

            <tr>
              <td>Total PIs</td>
              <td>${counts.primaryInvestigators.toLocaleString()}</td>
            </tr>

            <tr>
              <td>Total Collaborators</td>
              <td>${counts.collaborators.toLocaleString()}</td>
            </tr>
          </tbody>
        </table>
      </div>
  `});


export const mapLabels = [
  {
      "label": "North America",
      "coordinates": {
          "lat": 42.611695,
          "lng": -104.326171
      },
  },
  {
      "label": "Europe \u0026 Central Asia",
      "coordinates": {
          "lat": 48.613534,
          "lng": 21.335449
      },
  },
  {
      "label": "Australia \u0026 New Zealand",
      "coordinates": {
          "lat": -31.353637,
          "lng": 149.414063
      },
  },
  {
      "label": "East Asia \u0026 Pacific",
      "coordinates": {
          "lat": 29.451519,
          "lng": 116.674819
      },
  },
  {
      "label": "Middle East \u0026 North Africa",
      "coordinates": {
          "lat": 26.187443,
          "lng": 29.61914
      },
  },
  {
      "label": "Latin America \u0026 Caribbean",
      "coordinates": {
          "lat": -17.902996,
          "lng": -58.974609
      },
  },
  {
      "label": "Sub-Saharan Africa",
      "coordinates": {
          "lat": -17.232669,
          "lng": 25.751953
      },
  },
  {
      "label": "South Asia",
      "coordinates": {
          "lat": 19.532168,
          "lng": 77.585449
      },
  }
];