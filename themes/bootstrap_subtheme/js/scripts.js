(function ($) {
  Drupal.behaviors.myModuleBehavior = {
    attach: function (context, settings) {
      //$('h2').css('color', 'red');
      $("#edit-keys").attr("placeholder", "Search Website");
      switch(window.location.pathname) {
        case "/contact-us":
          console.log("You are on the /contact-us page.");
          var typeOfIssue =decodeURIComponent($.urlParam("type-of-issue"));
          if(typeOfIssue.length > 0 ) {
            $('#edit-type-of-issue').val(typeOfIssue);
          }
            //Strip anchor from organization.
          var currentOrg = $('#edit-organization').val();
          console.log('currentOrg: '+currentOrg);
          console.log('typeof: '+ typeof currentOrg);
          if(typeof currentOrg ==='string') {
            console.log($(currentOrg).text());
            var rawOrg = $(currentOrg).text();
            $('#edit-organization').val(rawOrg);
          }
          break;
        case "/become-a-partner":
          console.log("You are on the /become-a-partner page.");
          $("#become-a-partner-wells").matchHeight(true);
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
    var return_val;
    if(results == null) {
      return_val = "";
    } else {
      return_val = results[1];
    }
    return return_val;
  }

})(window.jQuery);