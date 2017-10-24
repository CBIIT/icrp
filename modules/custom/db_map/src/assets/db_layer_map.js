drupalSettings.db_map = drupalSettings.db_map||{};
drupalSettings.db_map.layer = {
  currLayer: "",
  initMap: function() {
    var map = new google.maps.Map(document.getElementById('icrp-map'), {
      center: {
        lat: 0,
        lng: 0
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
      zoom: 2
    });
    drupalSettings.db_map.layer.map = map;
    map.data.loadGeoJson('/modules/custom/db_map/src/assets/countries.json');
    drupalSettings.db_map.layer.reset();
    map.controls[google.maps.ControlPosition.LEFT_BOTTOM].push($('#layer_map_legend')[0]);
  },
  map: null,
  reset: function() {
    drupalSettings.db_map.layer.map.data.setStyle({
      fillColor: 'transparent',
      strokeWeight: 0
    });
  },
  update: function(legend,country) {
    var map = drupalSettings.db_map.layer.map;
    console.log(legend);
    var legendHTML = $('<div id="layer_map_legend"><h3>'+$('#db_layer_select').val()+'</h3></div>'),
        legendline;
    legend.forEach(function(entry) {
      legendline = $('<div></div>');
      legendline.append($('<span style="background:'+entry.LegendColor+';">&nbsp;</span>'));
      legendline.append($('<span>'+$('<div/>').text(entry.LegendName).html()+'</span>'));
      legendHTML.append(legendline);
    });
    map.data.setStyle(function(feature) {
      return {
        fillColor: country[feature.getId()],
        strokeWeight: 1
      };
    });
  }
};