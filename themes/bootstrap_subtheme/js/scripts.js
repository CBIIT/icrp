(function ($) {
  Drupal.behaviors.myModuleBehavior = {
    attach: function (context, settings) {
      //$('h2').css('color', 'red');
      $("#edit-keys").attr("placeholder", "Search Website");
      
      //alert(window.location.pathname);

      switch(window.location.pathname) {
        case "/":
          $.getNewsletter();
          break;
        case "/home":
          $.getNewsletter();
          break;
        case "/contact-us":
          $.populateContactUsForm();
          break;
        case "/become-a-partner":
          //console.log("You are on the /become-a-partner page.");
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
  $.populateContactUsForm = function() {
    //console.log("You are on the /contact-us page.");
    var typeOfIssue =decodeURIComponent($.urlParam("type-of-issue"));
    if(typeOfIssue.length > 0 ) {
      $('#edit-type-of-issue').val(typeOfIssue);
    }
    //Strip anchor from organization.
    var currentOrg = $('#edit-organization').val();
    //console.log('currentOrg: '+currentOrg);
    if(typeof currentOrg ==='string') {
      var regex = /(<([^>]+)>)/ig
      var rawOrg = currentOrg.replace(regex, "");
      if(currentOrg.localeCompare(rawOrg) != 0) {
        //document.getElementById("edit-organization").value = rawOrg;
        $('#edit-organization').val(rawOrg);
      }
    }
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
  $.getNewsletter = function() {
    //console.log("Load the REST");
    $.ajax({
      url: "https://icrpartnership-test.org/getLatestNewsletter"
    })
    .success(function( data ) {
      if ( console && console.log ) {
        $.showNewsletter(data[0]);
      }
    });
  }
  $.showNewsletter = function(newsletter) {
    /*

    The library PDF File location - icrp/sites/default/files/library/uploads
    Thumbnail location (folder path) - icrp/sites/default/files/library/uploads/thumbs

    */
    var pdf = "/sites/default/files/library/uploads/"+newsletter.Filename;
    var thumbnail = "/sites/default/files/library/uploads/thumbs/"+newsletter.ThumbnailFilename;
    $('#last_newsletter').html("<div class='newsletter-title'>"+newsletter.Title+"</div>");
    $('#last_newsletter').append("<div class='row'><div class='newsletter-image center-block'><a href='"+pdf+"' title='Latest Newsleter' target='_blank'><img src='"+thumbnail+"' /></a></div></div>");
    $('#last_newsletter').append("<div class='newsletter-description'>"+newsletter.Description+"</div>");
    $("#newsletter-container").show();

    //console.dir(newsletter);
  }
})(window.jQuery);