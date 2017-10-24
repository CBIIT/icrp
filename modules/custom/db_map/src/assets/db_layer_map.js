drupalSettings.db_map = drupalSettings.db_map||{};
drupalSettings.db_map.layer = {
  country: null,
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
  legend: null,
  map: null,
  reset: function() {
    $('#layer_map_legend').addClass('hide').empty();
    drupalSettings.db_map.layer.map.data.setStyle({
      fillColor: 'transparent',
      strokeWeight: 0
    });
  },
  selectColor: function(e) {
    var spans = $('#layer_map_legend span.selected:first-child');
    if (spans.size() == drupalSettings.db_map.layer.legend.length) {
      spans.removeClass('selected');
    }
    $(this).toggleClass('selected');
    if ($('#layer_map_legend span.selected:first-child').size() == 0) {
      $('#layer_map_legend span:first-child').addClass('selected');
    }
    drupalSettings.db_map.layer.updateLayers();
  },
  updateLayers: function(country) {
    if (country === undefined) {
      country = drupalSettings.db_map.layer.country;
    } else {
      drupalSettings.db_map.layer.country = country;
    }
    var spans = $('#layer_map_legend span.selected:first-child'),
        map = drupalSettings.db_map.layer.map,
        legendColors = {},
        country = {};
    drupalSettings.db_map.layer.legend.forEach(function(entry) {
      var legendId = entry.MapLayerLegendID;
      if ($('#layer_map_legend [data-legend-id="'+legendId+'"]').hasClass('selected')) {
        legendColors[legendId] = entry.LegendColor;
      } else {
        legendColors[legendId] = 'transparent';
      }
    });
    drupalSettings.db_map.layer.country.forEach(function(entry) {
      country[entry.Country.trim()] = legendColors[entry.MapLayerLegendID];
    });
    map.data.setStyle(function(feature) {
      var color = country[feature.getId()],
          weight = color=='transparent'?0:1;
      return {
        fillColor: color,
        strokeWeight: weight
      };
    });
  },
  updateLegend: function(legend) {
    drupalSettings.db_map.layer.legend = legend;
    var legendHTML = $('#layer_map_legend').empty().removeClass('hide').append('<h3>'+$('#db_layer_select option:selected').text()+'</h3>'),
        legendline,
        legendcolor;
    legend.forEach(function(entry) {
      legendline = $('<div></div>');
      legendcolor = $('<span class="selected" style="background:'+entry.LegendColor+';" data-legend-id="'+entry.MapLayerLegendID+'">&nbsp;</span>');
      legendcolor.on('click',drupalSettings.db_map.layer.selectColor);
      legendline.append(legendcolor);
      legendline.append($('<span>'+$('<div/>').text(entry.LegendName).html()+'</span>'));
      legendHTML.append(legendline);
    });
  }
};