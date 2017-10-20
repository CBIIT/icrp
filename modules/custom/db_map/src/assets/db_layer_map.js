drupalSettings.db_map = drupalSettings.db_map||{};
drupalSettings.db_map.layer = {
  currLayer: "",
  initMap: function() {
    var map = new google.maps.Map(document.getElementById('icrp-map'), {
          center: {
            lat: 43,
            lng: 20
          },
          styles: [
            {
              "elementType": "geometry",
              "stylers": [
                {
                  "color": "#f5f5f5"
                }
              ]
            },
            {
              "elementType": "labels",
              "stylers": [
                {
                  "lightness": 40
                }
              ]
            },
            {
              "featureType": "administrative.country",
              "elementType": "geometry.stroke",
              "stylers": [
                {
                  "color": "#a0cce7"
                }
              ]
            },
            {
              "featureType": "poi",
              "stylers": [
                {
                  "visibility": "off"
                }
              ]
            },
            {
              "featureType": "road",
              "stylers": [
                {
                  "visibility": "off"
                }
              ]
            },
            {
              "featureType": "transit",
              "stylers": [
                {
                  "visibility": "off"
                }
              ]
            },
            {
              "featureType": "water",
              "elementType": "geometry.fill",
              "stylers": [
                {
                  "color": "#64aad8"
                }
              ]
            }
          ],
          zoom: 8
        });
    map.data.loadGeoJson('/modules/custom/db_map/src/assets/countries.json');
    map.data.setStyle(function(obj) {
      if (obj.getId()=="AQ") console.log(obj);
      return {
        fillColor: 'green',
        strokeWeight: 1
      };
    });
    console.log(map);
  }
};