


export const addLabel = (label: string, location: {lat: number, lng: number}, map: google.maps.Map) =>
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
  })

export const addDataMarker = (data: number, scale: number, location: {lat: number, lng: number}, map: google.maps.Map) =>
  new google.maps.Marker({
    map: map,
    position: location,
    zIndex: 2,
    label: {
      color: 'white',
      text: data.toLocaleString(),
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
  })