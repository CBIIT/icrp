(function ($) {
  /*
  Drupal.fullcalendar.plugins.fullcalendar = {
    options: function (fullcalendar, settings) {
      if (settings.ajax) {
        fullcalendar.submitInit(settings);
      }
      var options = {
        eventClick: function (event, jsEvent, view) {
          if (settings.sameWindow) {
            //window.open(event.url, '_self');
            var href = "/events/581";
            alert("This is the global script.js I have access too");


            }
          }
      }
    }
  }
  */
  Drupal.behaviors.icrpBehavior = {
    attach: function (context, settings) {
      //alert("Your document is ready.  ");
      /*
      $(window).load(function() {
       // executes when complete page is fully loaded, including all frames, objects and images
        var calendar_ids = Object.keys(Drupal.fullcalendar.cache);
        console.dir(calendar_ids);
        console.log(calendar_ids[0]);
        console.log(calendar_ids[1]);
        var meeting_calendar = $(calendar_ids[1]);
        console.dir(meeting_calendar);
        var view = meeting_calendar.fullCalendar('getView');
        console.dir(view);
        window.view = view;
        //alert("The view's title is " + view.title);
        //var fullcalendar_meeting = meeting_calendar;

        console.log("Here is the meeting calendar");
        //console.dir(fullcalendar_meeting);
        //fullcalendar_meeting.fullCalendar('next');
      });
      */

      // Get calendar id
      /*
      var calendar_ids = Object.keys(Drupal.fullcalendar.cache);
      console.dir(calendar_ids);
      console.log(calendar_ids[0]);
      console.log(calendar_ids[1]);
      var meeting_calendar = $(calendar_ids[0]);
      console.dir(meeting_calendar);
      var fullcalendar_meeting = meeting_calendar.fullCalendar({});

      console.log("Here is the meeting calendar");
      console.dir(fullcalendar_meeting);
      alert("About to go next");
      setTimeout(function(){  
         alert("Hello"); 
        fullcalendar_meeting.fullCalendar('next');
       }, 3000);
       */

//      meeting_calendar.fullCalendar('next');

      // Set it to a variable.
      // Create an eventClick object
      // Write the object to the fullcalendar object.

      //console.dir(context);
      //console.dir(settings);
      //$('h2').css('color', 'red');
      $("#edit-keys").attr("placeholder", "Search Website");
      $("#views-bootstrap-sideshow-block-1 > div.carousel-inner > div.item").click(function(e) {
          console.info("You clicked on Caption - item");
          $.redirectCarousel(e);
      });
      $("#views-bootstrap-sideshow-block-1 > div.carousel-inner > div.item > div.carousel-caption").click(function(e) {
          console.info("You clicked on Caption");
          $.redirectCarousel(e);
      });
      /*
      $("#dialog").dialog({
        autoOpen: false,
        resizable: true,
        width: "auto",
        show: {
          effect: "blind",
          duration: 1000
        },
        hide: {
          effect: "explode",
          duration: 1000
        }

      });
      $("#dialog-form").dialog({
        modal: true,
        autoOpen: false,
        resizable: false,
        width: "auto",
        show: {
          effect: "blind",
          duration: 1000
        },
        hide: {
          effect: "explode",
          duration: 1000
        },  
        buttons: [{
          text: "Edit Event",
            click: function() {
              $( this ).dialog( "close" );
              window.location.href = '/node/585/edit?destination=/calendar';
            }
          // Uncommenting the following line would hide the text,
          // resulting in the label being used as a tooltip
          //showText: false
         }]
      });

      $("#dialog-form .ui-dialog-titlebar").hide();
        buttons: [
          {
            text: "Ok",
            icon: "ui-icon-heart",
            click: function() {
              $( this ).dialog( "close" );
            }

            // Uncommenting the following line would hide the text,
            // resulting in the label being used as a tooltip
            //showText: false
          }
        ]
      */
      /*
      $('body .fullcalendar').on('click', 'a', function() {
          alert( $(this).attr('href') );
      });
      */
      //$('body .fullcalendar').on('click', 'a', function() {

      //$("body").on(".fullcalendar a", function(e) {
        /*
      $('.fullcalendar').on('click', 'a', function(e) {
        //alert( $(this).attr('href') );
        e.preventDefault();
        e.stopPropagation();
        //$("#dialog-form").html("<img src='" + $(this).prop("href") + "' width='" + $(this).attr("data-width") + "' height='" + $(this).attr("data-height") + "'>");
        $("#dialog-form").dialog("option", "position", {
          my: "center",
          at: "center",
          of: window
        });

        if ($("#dialog-form").dialog("isOpen") == false) {
          $("#dialog-form").dialog("open");
        }
      });
      */

      //uid = Drupal.settings.currentUser;

      //alert(window.location.pathname);
      /*
      $("li.disabled a").click(function() {
       return false;
      });
      */
      var url_path = window.location.pathname;
      if(url_path.substring(0, 9).toLowerCase() == '/calendar') {
        url_path = '/calendar';
      }
      switch(url_path) {
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
        case "/calendar":
          $('.fc-listYear-button').text('Year');
          $('.nav-tabs a').on('shown.bs.tab', function(event){
             // $('#external_events > div > div.fullcalendar').fullCalendar('render');
              $('.fc-today-button').click();
          });
          //console.log("Calendar Page");
          if(!$('#add-event-meeting').length) {
            var href = "/user-roles";
            $.ajax({
                url:  href
            })
            .success(function( data ) {
              //console.log("data returned")
              //console.dir(data);
              var roles = JSON.parse(data);
              //console.dir(roles);
              if(!$('#add-event-meeting').length && (($.inArray("administrator", roles)>=0) || ($.inArray("manager", roles)>=0)))
                  $('div.view-full-calendar-meetings > div.view-content > div.fullcalendar > div.fc-toolbar > div.fc-right > .fc-listYear-button').before('<span id="add-event-meeting" style="margin-top:7px;"><a href="/node/add/events?calendar_type=ICRP Meeting">+ Add Event</a></span>');
            });
          }

          if(!$('#add-external-event').length)
            $('div.view-full-calendar-external-events > div.view-content > div.fullcalendar > div.fc-toolbar > div.fc-right > .fc-listYear-button').before('<span id="add-external-event" style="margin-top:7px;"><a href="/node/add/events?calendar_type=External Event">+ Add Event</a></span>');

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
  
  // sets tags with the data-count attribute to be dynamic
  if ($('[data-count]').length) {
    $.ajax('/api/database/counts')
      .then(function(response) {
        for (key in response) {
          $('[data-count="{0}"]'.format(key))
            .html(response[key]);
        }
    });
  }

  // attaches cso example hrefs to each button
  if ($('a[id^="cso"]').length) {
    $.ajax('/api/database/examples/cso')
      .then(function(response) {
        for (key in response) {
          var element = document.getElementById(key);
          element.href = response[key];
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

  $.gotoCSOUrl = function(data, id) {
    //console.info("gotoCSOUrl");
    //console.info("id: "+id);
    //console.dir(data);
    var url = data[id];
    //alert(url);
    if (typeof url === 'undefined' || url === null) {
        // variable is undefined or null
        console.log('Unable to lookup url with id of '+id);
    } else {
      //window.location.href = url;
      window.open(url, id);
    }
  }

  $.getCSOLink = function(id) {
    if(window.location.hostname == "localhost") {
      host = "https://icrpartnership-dev.org";
    } else {
      host = window.location.protocol + "//" + window.location.hostname;
    }
    $.ajax({
      url: host + "/api/database/examples/cso"
    })
    .success(function( data ) {
        $.gotoCSOUrl(data, id);
    });
  }

  $.redirectCSOExample = function(e){
    e.preventDefault();
    var id = e.target.id;
    //console.log("You click on the CSO Example");
    //console.log(e.target.id);
    //alert(id);
    $.getCSOLink(id);
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
        title : 'ICRP Map',
        url : '/map'
    },{
        title : 'Connect',
        url : '/about-us'
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