(function ($) {
  Drupal.behaviors.icrpBehavior = {
    attach: function (context, settings) {
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
      $("#logout").click(function(e) {
          console.info("You clicked on logout.  Clear Session");
          sessionStorage.clear();
      });

      //$('#edit-field-event-date-range-0-value-date').on('change')
      /*
      $('body').on('change', '#edit-field-event-date-range-0-value-date', function(e) {
        // Action goes here.
        console.log("You changed the start date");
        console.dir(e);
        //edit-field-event-date-range-0-value-date
      });
      */
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

      if(url_path.substring(0, 6).toLowerCase() == '/forum' && !(url_path.substring(7, 8) == '6')) {
        url_path = '/forum';
      }
      //alert(url_path);
      var source = decodeURIComponent($.urlParam("source"));
      if(source  == "Edit Event") {
          $.preprocessAddEvents();
          $.preprocessAddTitle();
          $.preprocessFixDateRangeEvents();
          //$.preprocessCloneEndDateCheckbox();

      }
      switch(url_path) {
        case "/node/add/events":
          $.preprocessAddEvents();
          $.preprocessAddTitle();
          $.preprocessFixDateRangeEvents();
          //$.preprocessCloneEndDateCheckbox();
          break;
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
        /*
        case "/forum/6/No Need":
          $(".action-links").hide();
          $("#main-forum-content").show();
          break;
        */
        case "/forum":
          $.preprocessForum();
          break;
        case "/node/add/forum":
          $.hideCommentStatus();
          break;
        case "/become-a-partner":
          //console.log("You are on the /become-a-partner page.");
          $("#become-a-partner-wells").matchHeight(true);
          break;
        case "/calendar":
          $.preprocessCalendar();
          $.rememberTabs();

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
/*
  $.preprocessCloneEndDateCheckbox = function(e) {

    $("#edit-field-show-end-date-wrapper").clone().insertBefore("#edit-field-event-date-range-0 > div.panel-body  > label:first-child");
    $('#edit-field-show-end-date-wrapper:nth-child(2)').remove();
    //$('<h2>Hello</h2>'.before($('#edit-field-event-date-range-0 > legend');
    if($('#edit-field-show-end-date-value').val() == "1") {
      //alert("Hide end time and label. Set end time to start time");
      $("#edit-field-show-end-date-wrapper > label:nth-child(3)").hide();
      $('#edit-field-event-date-range-0-end-value').hide();
      $('#edit-field-event-date-range-0--description').text("Enter start time for the event.");
    } else {
      $('#edit-field-event-date-range-0--description').text("Enter start and end time for the event.");
    }
    //$('#edit-field-show-end-date-value').parent().hide();
  }
*/
  $.preprocessForum = function(e) {
    /*
    if(!$('#new-forum-breadcrumb > #forum-breadcrumb').length) {
      $( "#forum-breadcrumb" ).clone().prependTo( "#new-forum-breadcrumb" );
      $( "#new-forum-breadcrumb > #forum-breadcrumb" ).show();
    }
    $(".topic-status-legend").show();
    */
  }

  $.rememberTabs = function() {
    //for bootstrap 3 use 'shown.bs.tab' instead of 'shown' in the next line
    $('a[data-toggle="tab"]').on('click', function (e) {
      //save the latest tab; use cookies if you like 'em better:
      localStorage.setItem('lastCalendarTab', $(e.target).attr('href'));
    });
    //go to the latest tab, if it exists:
    var open_tab = decodeURIComponent($.urlParam("open_tab"));
    var lastTab = localStorage.getItem('lastCalendarTab');
    if (lastTab && open_tab != 'partner-meetings') {
      //console.log("lastTab"+lastTab);
      $('a[href="'+lastTab+'"]').click();
    } else {
      $('a[href="#partner-meetings"]').click();
    }
  }

  $.advanceEndDateTime = function() {
      var eventDuration = 1; //Number of hours between events
      //var startDate = new Date($('#edit-field-event-date-range-0-value-date').val()+' '+$('#edit-field-event-date-range-0-value-time').val());
      var endDate = new Date($('#edit-field-event-date-range-0-value-date').val()+' '+$('#edit-field-event-date-range-0-value-time').val());
      //console.log(endDate instanceof Date && !isNaN(endDate.valueOf()));
      if(endDate instanceof Date && !isNaN(endDate.valueOf())) {      
        endDate.setHours(endDate.getHours()+eventDuration);
        //var endDateFormatted = $.datepicker.formatDate(formatDate, endDate);
        var endDateFormatted = endDate.getFullYear() + "-" + ("0" + (endDate.getMonth()+1)).slice(-2) + "-" + ("0" + endDate.getDate()).slice(-2);
        var endTimeFormatted = ("0" + endDate.getHours()).slice(-2) + ":" + ("0" + endDate.getMinutes()).slice(-2);
        //console.log(endDateFormatted);
        //console.log(endTimeFormatted);
        $('#edit-field-event-date-range-0-end-value-date').val(endDateFormatted);
        $('#edit-field-event-date-range-0-end-value-time').val(endTimeFormatted);
      }
  }

  $.preprocessFixDateRangeEvents = function(e) {

    var eventDuration = 1;

    $('#edit-field-event-date-range-0-value-date').on('change', function(e) {
        //console.log($('#edit-field-event-date-range-0-value-date').val());
        $('#edit-field-event-date-range-0-end-value-date').val($('#edit-field-event-date-range-0-value-date').val());
    });

    $('#edit-field-event-date-range-0-value-time').on('change', function(e) {
      $.advanceEndDateTime();
    });
    
    // Fix Date Time Range if avalable.

    var ids = ["edit-field-event-date-range-0-value-time", "edit-field-event-date-range-0-end-value-time"];
    $.each( ids, function( key, id ) {
      var time = $('#'+id).attr('value');
      // Remove seconds from time
      if(window.location.pathname == '/node/add/events') {
        $('#'+id).attr('value', time.substring(0, 3)+"00");  //Round to nearest hour for a new Event
      } else {
        $('#'+id).attr('value', time.substring(0, 5));
      }
      $('#'+id).attr('step', "900");  //Set step size to 15 minutes
      $('#'+id).attr('size', "10");  //Change size on time box
      //$('#'+id).attr('title', "Time (e.g. 08:30 PM)");
    });
    //If a new event add one hour to initial hour and then add an hour for end time.
    if(window.location.pathname == '/node/add/events') {
      $.advanceEndDateTime();
    }

  }

  $.preprocessAddEvents = function(e){
    var calendar_type = decodeURIComponent($.urlParam("calendar_type"));
    if(calendar_type == "Partner Meetings") {
      $("#edit-field-event-group option[value='Conference/Meeting']").remove();
      $("#edit-field-event-group option[value='Twitter Promotional Event']").remove();
      $("#edit-field-event-group option[value='Webinar']").remove();
      $("#edit-field-event-group option[value='Other']").remove();
    } else {
      $("#edit-field-event-group option[value='Partner News and Announcements']").remove();
      $("#edit-field-event-group option[value='Annual Meetings']").remove();
      $("#edit-field-event-group option[value='Communications and Membership']").remove();
      $("#edit-field-event-group option[value='CSO and Coding']").remove();
      $("#edit-field-event-group option[value='Evaluations and Analyses']").remove();
      $("#edit-field-event-group option[value='Partner Operations']").remove();
      $("#edit-field-event-group option[value='Website and Database']").remove();
    }
  }

  $.preprocessAddTitle = function(e) {
      /* Add Title to calendar*/
      var calendar_type = decodeURIComponent($.urlParam("calendar_type"));
      $('#edit-field-calendar-type').val(calendar_type);
      if(!$('#calendar-title').length) {
        $('<h4 id="calendar-title">'+calendar_type+' Calendar</h4>').insertBefore("div.well");
      }
      /* Remove required * from this field */
      $('#edit-field-event-date-range-0 > div.panel-heading > div.panel-title').removeClass('form-required');
  }

  $.preprocessCalendar = function(e){
    $('.fc-listYear-button').text('Year');
    $('.nav-tabs a').on('shown.bs.tab', function(event){
       // $('#external_events > div > div.fullcalendar').fullCalendar('render');
        $('.fc-today-button').click();
    });
    //console.log("Calendar Page");
    if(!$('#add-event-meeting').length) {
      var href = "/user-roles";
      $.ajax({
          url:  href,
          success: function( data ) {
              //console.log("data returned")
              //console.dir(data);
              var roles = JSON.parse(data);
              //console.dir(roles);
              if(!$('#add-event-meeting').length && (($.inArray("administrator", roles)>=0) || ($.inArray("manager", roles)>=0))) {
                  $('div.view-full-calendar-meetings > div.view-content > div.fullcalendar > div.fc-toolbar > div.fc-right > .fc-listYear-button').before('<span id="add-event-meeting" style="margin-top:7px;"><a href="/node/add/events?calendar_type=Partner Meetings&destination=/calendar">+ Add Event</a></span>');
              }
          }
       });
    }

    if(!$('#add-external-event').length) {
      $('div.view-full-calendar-external-events > div.view-content > div.fullcalendar > div.fc-toolbar > div.fc-right > .fc-listYear-button').before('<span id="add-external-event" style="margin-top:7px;"><a href="/node/add/events?calendar_type=External Events&destination=/calendar">+ Add Event</a></span>');
    }

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
      url: host + "/api/database/examples/cso",
      success: function( data ) {
        $.gotoCSOUrl(data, id);
      }   
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
      url: host + "/getLatestNewsletter", 
      success: function( data ) {
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

    $("#last_newsletter").append("<div class='row text-center'><div class='newsletter-image'><a href='"+pdf+"' title='Latest Newsleter' target='_blank'><img class='center-block' src='"+thumbnail+"' /></a></div></div>");
    $('#last_newsletter').append("<div class='newsletter-description'>"+newsletter.Description+"</div>");

    $("#newsletter-container").show();
  }
})(window.jQuery);