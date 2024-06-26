drupalSettings.db_map = drupalSettings.db_map||{};
drupalSettings.db_map.layer = $.extend(drupalSettings.db_map.layer||{},{
  country: null,
  currLayer: "",
  initMap: function(map) {
    var layers = drupalSettings.db_map.layer.layers,
        layerSelect;
    drupalSettings.db_map.layer.map = map;
    map.data.loadGeoJson('/modules/custom/db_map/src/assets/countries.json');
    drupalSettings.db_map.layer.reset();
    map.controls[google.maps.ControlPosition.LEFT_BOTTOM].push($('<div id="layer-map-legend" class="hide"/>')[0]);
    layerSelect = $('<select id="select-layer"></select>').on('change',drupalSettings.db_map.layer.onSelect);
    layerSelect.append('<option value="">(None)</option>');

    var orderedLayers = [];

    layers.forEach(function(layer) {
      if (layer.GroupName == null)
        orderedLayers.push(layer);

      else {
        var matches = orderedLayers.filter(function(target) {
          return target.GroupName == layer.GroupName
            || target.Name == layer.GroupName
        });

        if (matches) {
          var lastMatch = matches[matches.length - 1];
          var index = orderedLayers.indexOf(lastMatch);
          orderedLayers.splice(index + 1, 0, layer);
        }

        else {
          orderedLayers.push(layer);
        }
      }
    })

    orderedLayers.forEach(function(layer) {
      layerSelect.append(
        $('<option value="'+layer.MapLayerID+'">'+layer.Name+'</option>')
          .attr('title', layer.DisplayedName)
          .css('margin-left', layer.GroupName == null ? '0' : '20px')
          .css('font-weight', layer.GroupName == null ? 'bold' : 'normal')
      )
    })

    map.controls[google.maps.ControlPosition.TOP_RIGHT]
      .push($('<div id="layer-map-select"/>')
        .append($('<span>Layer</span>'))
        .append(layerSelect)[0]);

    layerSelect
      .data('width', '280px')
      .data('size', '14')
      .selectpicker({
        dropupAuto: false,
      });

    drupalSettings.db_map.layer.infowindow = new google.maps.InfoWindow({pixelOffset:{height:70,width:0}});
  },
  infowindow: null,
  layers: db_layer_map.layers,
  legend: null,
  map: null,
  onSelect: function(e) {
    e.preventDefault();
    var infowindow = drupalSettings.db_map.layer.infowindow,
        old = drupalSettings.db_map.layer.currLayer,
        val = this.value;
    if (infowindow.getMap() !== null || typeof infowindow.getMap() !== 'undefined') {
      infowindow.close();
    }
    if (old === val) return;
    if (val === "") {
      drupalSettings.db_map.layer.reset();
    } else {
      $.get({
        url: '/map/layer/data/'+val
      }).done(function(resp) {
        drupalSettings.db_map.layer.updateLegend(resp.legend);
        drupalSettings.db_map.layer.updateLayers(resp.country);
      });
    }
    drupalSettings.db_map.layer.currLayer = val;
  },
  reset: function() {
    $('#layer-map-legend').addClass('hide').empty();
    drupalSettings.db_map.layer.map.data.setStyle({
      fillColor: 'transparent',
      strokeWeight: 0
    });
  },
  selectColor: function(e) {
    var spans = $('#layer-map-legend span.selected:first-child');
    if (spans.length == drupalSettings.db_map.layer.legend.length) {
      spans.removeClass('selected');
    }
    $(this).toggleClass('selected');
    if ($('#layer-map-legend span.selected:first-child').length == 0) {
      $('#layer-map-legend span:first-child').addClass('selected');
    }
    drupalSettings.db_map.layer.updateLayers();
  },
  showMoreInfo: function(e) {
    e.preventDefault();
    var infowindow = drupalSettings.db_map.layer.infowindow,
        map = drupalSettings.db_map.layer.map,
        index = drupalSettings.db_map.layer.currLayer,
        layer = drupalSettings.db_map.layer.layers.filter(function(entry) { return entry.MapLayerID == index; });
    if (layer.length != 1) return false;
    layer = layer[0];
    $('#layer_map_info').removeClass('hide');
    if (infowindow.getMap() === null || typeof infowindow.getMap() === 'undefined') {
      infowindow.setPosition(map.getCenter());
      infowindow.setContent(
        '<h4>'+layer.DisplayedName+'</h4>'+
        '<div>'+layer.Summary+'</div>'+
        '<h5>Data Source:</h5>'+
        '<div>'+layer.DataSource+'</div>'
      );
      infowindow.open(map);
    } else {
      infowindow.close();
    }
  },
  updateLayers: function(country) {
    if (country === undefined) {
      country = drupalSettings.db_map.layer.country;
    } else {
      drupalSettings.db_map.layer.country = country;
    }
    var spans = $('#layer-map-legend span.selected:first-child'),
        map = drupalSettings.db_map.layer.map,
        legendColors = {},
        country = {};
    drupalSettings.db_map.layer.legend.forEach(function(entry) {
      var legendId = entry.MapLayerLegendID;
      if ($('#layer-map-legend [data-legend-id="'+legendId+'"]').hasClass('selected')) {
        legendColors[legendId] = entry.LegendColor;
      } else {
        legendColors[legendId] = 'transparent';
      }
    });
    drupalSettings.db_map.layer.country.forEach(function(entry) {
      country[entry.Country.trim()] = legendColors[entry.MapLayerLegendID];
    });
    map.data.setStyle(function(feature) {
      var color = country[feature.getId()]||'transparent',
          weight = color=='transparent'?0:1;
      return {
        fillColor: color,
        fillOpacity: 0.7,
        strokeColor: '#FFFFFF',
        strokeWeight: weight
      };
    });
  },
  updateLegend: function(legend) {
    drupalSettings.db_map.layer.legend = legend;

    var legendContent = '<h4>'+$('#layer-map-select option:selected').attr('title')+'</h4>'
    var legendHTML = $('#layer-map-legend')
      .empty()
      .removeClass('hide')
      .append(legendContent),
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
    legendHTML.append($('<div><a href="#">See More Info</a></div>').on('click',drupalSettings.db_map.layer.showMoreInfo));
  }
});

window.createOverlayForMap = function(map) {
  drupalSettings.db_map.layer.initMap(map);
}