(function ($) {
  Drupal.behaviors.myModuleBehavior = {
    attach: function (context, settings) {
      //$('h2').css('color', 'red');
      $("#edit-keys").attr("placeholder", "Search Website");
    }
  }
})(window.jQuery);

(function ($) {
  window['enableTooltips'] = function() {
    window.setTimeout(function() {
      $('[data-toggle="tooltip"]').tooltip({container: 'body'}); 
    }, 0);
  }
})(window.jQuery);