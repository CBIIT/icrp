export const DEFAULT_STYLES: google.maps.MapTypeStyle[] = [
  {
    'elementType': 'geometry',
    'stylers': [
      {
        'color': '#f5f5f5'
      }
    ]
  },
  {
    'elementType': 'labels',
    'stylers': [
      {
        'visibility': 'off'
      }
    ]
  },
  {
    'featureType': 'administrative.country',
    'elementType': 'geometry.stroke',
    'stylers': [
      {
        'color': '#a0cce7'
      },
    ]
  },
  {
    'featureType': 'poi',
    'stylers': [
      {
        'visibility': 'off'
      }
    ]
  },
  {
    'featureType': 'road',
    'stylers': [
      {
        'visibility': 'off'
      }
    ]
  },
  {
    'featureType': 'transit',
    'stylers': [
      {
        'visibility': 'off'
      }
    ]
  },
  {
    'featureType': 'water',
    'elementType': 'geometry.fill',
    'stylers': [
      {
        'color': '#64aad8'
      }
    ]
  },
];

export const DEFAULT_OPTIONS: google.maps.MapOptions = {
  center: {lat: 25, lng: 0},
  zoom: 2,
  minZoom: 2,
  disableDefaultUI: true,
  zoomControl: true,
  backgroundColor: '#64aad8',
  styles: DEFAULT_STYLES,
}