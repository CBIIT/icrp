(function ($) {
  Drupal.behaviors.myModuleBehavior = {
    attach: function (context, settings) {
      //$('h2').css('color', 'red');
      $("#edit-keys").attr("placeholder", "Search Website");
      $("#views-bootstrap-carousel-sideshow-block-1 > div.carousel-inner > div.item").click(function(e) {
          $.redirectCarousel(e);
      });
      $("#views-bootstrap-carousel-sideshow-block-1 > div.carousel-inner > div.item > div.carousel-caption").click(function(e) {
          //console.info("You clicked on Caption");
          $.redirectCarousel(e);
      });
      //alert(window.location.pathname);

      switch(window.location.pathname) {
        case "/":
          $.getNewsletter();
          //console.log("You are on the / page.");
          break;
        case "/home":
          $.getNewsletter();
          break;
        case "/partner-application-administration-tool":
          $.partnerApplicationAdminTable();
          break;
        case "/contact-us":
          $.populateContactUsForm();
          break;
        case "/forum/6/No Need":
          $(".action-links").hide();
          $("#main-forum-content").show();
          break;
        case "/forum/7":
          $(".topic-status-legend").show();
          break;
        case "/forum/8":
          $(".topic-status-legend").show();
          break;
        case "/forum/9":
          $(".topic-status-legend").show();
          break;
        case "/forum/10":
          $(".topic-status-legend").show();
          break;
        case "/forum/11":
          $(".topic-status-legend").show();
          break;
        case "/forum/12":
          $(".topic-status-legend").show();
          break;
        case "/forum/13":
          $(".topic-status-legend").show();
          break;
        case "/node/add/forum":
          $.hideCommentStatus();
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
  
  if ($('[data-count]').length) {
    $.ajax('/api/database/counts')
      .then(function(response) {
        for (key in response) {
          $('[data-count="{0}"]'.format(key))
            .html(response[key]);
        }
    });
  }

  $.hideCommentStatus = function(e){
    $("div.form-item.js-form-item.form-type-vertical-tabs.js-form-type-vertical-tabs.form-item-.js-form-item-.form-no-label.form-group").hide();
  }

  $.redirectCarousel = function(e){
    e.preventDefault();

    var target_title = $(e.target).closest(".item.active").find('img').prop('alt')
    //console.dir(e);
    //console.log("You click on the Carousel item");        
    //console.log(target_title);
    //var win = window.open($.imageRoute(target_title), '_self');
    var url = $.imageRoute(target_title); 
    if(url != "/") {
      window.location.href = url;
    }
  }

  $.imageRoute = function(title) {
    /*
    SS-570
    Global Reach -> to "Funding Organization" page
    Explore -> to "Database Search" page
    Connect -> to "Become a Partner" page
    Our Mission -> to library page
    Search the Database -> to Database Search page

    */
    //If anonymous don't redirect to member /FundingOrgs from the Global Reach image.
    /*
    if(title == 'Global Reach' && $("#navbar-collapse").find('a').text() == "Log in") {
      return "/current_partners";
    }
    */
    var routes = [{
        title : 'Global Reach',
        url : '/FundingOrgs'
    },{
        title : 'Explore',
        url : '/db_search'
    },{
        title : 'Connect',
        url : '/become-a-partner'
    },{
        title : 'Our Mission',
        url : '/library'
    },{
        title : 'Search the Database',
        url : '/db_search'
    }];
    //console.dir(routes);
    var index = routes.map(function(o) { return o.title; }).indexOf(title);
    //console.log("Going to: "+routes[index].url);
    if(index >= 0) {
      return routes[index]['url'];   
    } else {
      return '/';
    }
  }

  $.partnerApplicationAdminTable = function() {
    console.log("Datatable Time");
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
    if(window.location.hostname == "localhost") {
      host = "https://icrpartnership-dev.org";
    } else {
      host = window.location.protocol + "//" + window.location.hostname;
    }
    $.ajax({
      url: host + "/getLatestNewsletter"
    })
    .success(function( data ) {
        $.showNewsletter(data[0]);
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

    $("#last_newsletter").append("<div class='row text-center'><div class='newsletter-image'><a href='"+pdf+"' title='Latest Newsleter' target='_blank'><img class='center-block' src='"+thumbnail+"' /></a></div></div>");
    $('#last_newsletter').append("<div class='newsletter-description'>"+newsletter.Description+"</div>");

    $("#newsletter-container").show();
  }
})(window.jQuery);