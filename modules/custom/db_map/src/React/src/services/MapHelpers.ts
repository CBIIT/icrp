import { Location } from './DataService';

export const addLabel = (label: string, location: google.maps.LatLngLiteral, map: google.maps.Map) =>
  new google.maps.Marker({
    map: map,
    position: location,
    zIndex: 0,
    label: {
      color: '#2574A9',
      text: label.toLocaleUpperCase(),
      fontSize: '14px',
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

export const addDataMarker = (label: number, scale: number, location: google.maps.LatLngLiteral, map: google.maps.Map) =>
  new google.maps.Marker({
    map: map,
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
              <td>Total Projects</td>
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
