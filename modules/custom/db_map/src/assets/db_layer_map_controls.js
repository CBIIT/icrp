$(document).ready(function(){
  $('#db_layer_select').on('change',function(e) {
    e.preventDefault();
    var old = drupalSettings.db_map.layer.currLayer,
        val = this.value;
    if (old === val) return;
    if (val === "") {

    } else {
      $.get({
        url: '/map/layer/'+val
      }).done(function(resp) {
        console.log(resp);
      });
    }
    drupalSettings.db_map.layer.currLayer = val;
  });
});