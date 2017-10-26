$(document).ready(function(){
  $('#layer_map_select').on('change',function(e) {
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
        drupalSettings.db_map.layer.updateLegend(resp.legend);
        drupalSettings.db_map.layer.updateLayers(resp.country);
      });
    }
    drupalSettings.db_map.layer.currLayer = val;
  });
});