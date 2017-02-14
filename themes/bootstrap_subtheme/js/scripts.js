(function ($) {
  Drupal.behaviors.myModuleBehavior = {
    attach: function (context, settings) {
      //$('h2').css('color', 'red');
      $("#edit-keys").attr("placeholder", "Search Website");
      switch(window.location.pathname) {
        case "/contact-us":
          var typeOfIssue =decodeURIComponent($.urlParam("type-of-issue"));
          $('#edit-type-of-issue').val(typeOfIssue);
          break;

      }
    }
  }
})(window.jQuery);

(function ($) {
  window['enableTooltips'] = function() {
    window.setTimeout(function() {
      $('[data-toggle="tooltip"]').tooltip({container: 'body'}); 
    }, 0);
  }
  $.urlParam = function(name){
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    return results[1] || 0;
  }

})(window.jQuery);