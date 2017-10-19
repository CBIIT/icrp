(function($) {

Drupal.fullcalendar.plugins.custom_module = {
  options: function (fullcalendar, settings) {
    return {
      eventClick: function(events) {
        return false;
      }
    };
  }
};


}(jQuery));
