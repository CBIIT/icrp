(function ($) {
  Drupal.behaviors.myModuleBehavior = {
    attach: function (context, settings) {
      //$('h2').css('color', 'red');
      $("#edit-keys").attr("placeholder", "Search Website");
      switch(window.location.pathname) {
        case "/contact-us":
          var typeOfIssue =decodeURIComponent($.urlParam("type-of-issue"));
          $('#edit-type-of-issue').val(typeOfIssue);
            //Strip anchor from organization.
          var currentOrg = $('#edit-organization').val();
            //alert(current_org);
            //alert($(current_org).text());
          var currentOrgStr = $(currentOrg).text();
          if(typeof currentOrgStr ==='string') {
            $('#edit-organization').text(currentOrgStr);
            $('#edit-organization').val(currentOrgStr);
          }

          //alert(typeof(currentOrgStr));
          console.log(currentOrgStr);
          //$('#edit-organization').val(currentOrgStr);


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
    return results[1] || 0;
  }

})(window.jQuery);