$(document).ready(function(){
  $('#db_layer_select').on('change',function(e) {
    e.preventDefault();
    var old = drupalSettings.db_map.layer.currLayer,
        val = this.value;
    if (old === val) return;
    if (val === "") {
      drupalSettings.db_map.layer.reset();
    } else {
      $.get({
        url: '/map/layer/data/'+val
      }).done(function(resp) {
        var legendColors = {},
            country = {};
        resp.legend.forEach(function(entry) {
          legendColors[entry.MapLayerLegendID] = entry.LegendColor;
        });
        resp.country.forEach(function(entry) {
          country[entry.Country.trim()] = legendColors[entry.MapLayerLegendID];
        });
        drupalSettings.db_map.layer.update(resp.legend,country);
      });
    }
    drupalSettings.db_map.layer.currLayer = val;
  });
});