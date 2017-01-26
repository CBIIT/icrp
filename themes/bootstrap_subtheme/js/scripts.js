(function ($) {
  Drupal.behaviors.myModuleBehavior = {
    attach: function (context, settings) {
      //$('h2').css('color', 'red');
      $("#edit-keys").attr("placeholder", "Search Website");
    }
  }
})(window.jQuery);

window['enableResizableTableColumns'] = function() {
  window.setTimeout(function() {
    $('table').resizableColumns();
  }, 0)
}

window['enableTooltips'] = function() {
  window.setTimeout(function() {
    $('[data-toggle="tooltip"]').tooltip({container: 'body'}); 
  }, 0)
}

$(document).ready(function() {
  window.enableResizableTableColumns();
  window.enableTooltips();
});