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

export const createDataMarker = (
    label: number,
    scale: number,
    location: google.maps.LatLngLiteral  | google.maps.LatLng,
    fillColor: string = '#0690e0',
    strokeColor: string = '#129DED') =>
  new google.maps.Marker({
    position: location,
    zIndex: 2,
    label: {
      color: 'white',
      text: label.toLocaleString(),
      fontSize: '14px',
      fontWeight: 'bolder',
      fontFamily: `
        -apple-system, system-ui, BlinkMacSystemFont,
        "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell,
        "Fira Sans", "Droid Sans", "Helvetica Neue",
        Arial, sans-serif`,
    },
    icon: {
      path: google.maps.SymbolPath.CIRCLE,
      scale: scale,
      fillOpacity: 0.8,
      strokeOpacity: 0.8,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWeight: 4,
    },
  });

export const createInfoWindow = ({label, counts}: Location, callback?: () => void) => {
  const el = createElement;
  let labelParts = label.split(':').map(e => e.trim());

  let callbackSpan: HTMLElement = el('span', {}, [labelParts[1]]);
  if (callback) {
    callbackSpan = el('span', {
      className: callback ? 'infowindow-link' : '',
      onClick: () => callback && callback()
    }, [labelParts[1]])
  }

  return new google.maps.InfoWindow({
    content: el('div', {}, [
      el('b', {className: 'margin-right'}, [labelParts[0], ':']),
      callbackSpan,

      el('hr', {style: 'margin-top: 5px; margin-bottom: 5px;'}, []),
      el('table', {className: 'popover-table'}, [
        el('tbody', {}, [

          el('tr', {}, [
            el('td', {}, ['Total Related Projects']),
            el('td', {}, [counts.projects.toLocaleString()]),
          ]),

          el('tr', {}, [
            el('td', {}, ['Total PIs']),
            el('td', {}, [counts.primaryInvestigators.toLocaleString()]),
          ]),

          el('tr', {}, [
            el('td', {}, ['Total Collaborators']),
            el('td', {}, [counts.collaborators.toLocaleString()]),
          ]),
        ])
      ])
    ])
  })
}

export const createElement = (type: string | Function, props: {[key: string]: any}, children: (HTMLElement|string)[]) => {

    if (type.constructor === Function)
        return (type as Function)(props);

    let el = document.createElement(type as string);

    for (let propName in props || {}) {
      if (/^on/.test(propName))
        el.addEventListener(
          propName.substring(2).toLowerCase(),
          props[propName]);
      else
        el[propName] = props[propName];
    }


    for (let child of children || []) {
      if (child) {
        if (child.constructor === String)
          el.appendChild(document.createTextNode(child as string));
        else
          el.appendChild(child as HTMLElement);
      }
    }

    return el;
}

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