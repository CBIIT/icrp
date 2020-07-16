(function ($, Drupal, drupalSettings) {
  Drupal.behaviors.icrpBehavior = {
    attach: function (context, settings) {
      $("#edit-keys").attr("placeholder", "Search Website");
      $('#search-block-form [type="submit"]').css('width', '50px');      
      $("#views-bootstrap-sideshow-block-1 > div.carousel-inner > div.item").click(function(e) {
          console.info("You clicked on Caption - item");
          $.redirectCarousel(e);
      });
      $("#views-bootstrap-sideshow-block-1 > div.carousel-inner > div.item > div.carousel-caption").click(function(e) {
          console.info("You clicked on Caption");
          setTimeout(function(){ $.redirectCarousel(e); }, 3000);

      });
      /*
      $(".nav-tabs > li > a").click(function(e) {
          console.info("You clicked on Tab. Whoa!");
          console.dir(e);
          $.tweekHomePageRefreshTwitterBlock();
          //$.redirectCarousel(e);
      });
      */
      $("#logout").click(function(e) {
          console.info("You clicked on logout.  Clear Session");
          sessionStorage.clear();
      });
      var url_path = window.location.pathname;
      if(url_path.substring(0, 9).toLowerCase() == '/calendar') {
        url_path = '/calendar';
      }

      if(url_path.substring(0, 6).toLowerCase() == '/forum' && !(url_path.substring(7, 8) == '6')) {
        url_path = '/forum';
      }
      alert(url_path);
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
          //var sectionHeight = $('[role="main"] section').height();
          //var twitterHeight = $('#twitter-container').height();
          //var newsletterHeight = $('#newsletter-container').height();
          if($('#welcome').length) {
            $.tweekHomePage();
            var timeout = 100;
            var inTimeOut = false;
            $(window).resize(function(){
              var newSectionHeight = $('[role="main"] section').height();
              var newAsideHeight = $('aside').height();
              //console.log("newSectionHeight: "+newSectionHeight);
              //console.log("newAsideHeight: "+newAsideHeight);
              if((Math.abs(newSectionHeight - newAsideHeight) > 1) && !inTimeOut) {
                //console.log("Resize");
                //console.log($(window).width());
                inTimeOut = true;
                setTimeout(function(){ inTimeOut = false; }, timeout);
                if($(window).width() < 768){
                  //Only change the height of the Twitter scroll.
                  $('aside').attr('height', "800px");
                } else {
                  $.tweekHomePageRefreshTwitterBlock();
                }
              }
            });
          } else {
            $.getNewsletter();
          }
          break;
        case "/partner-application-administration-tool":
          $.partnerApplicationAdminTable();
          break;
        case "/contact-us":
          $.populateContactUsForm();
          break;
        case "/forum":
          $.preprocessForum();
          alert("Watch what happens.")
          $("#funding-opportunities-forum-container").matchHeight(true);
        break;
        case "/node/add/forum":
          $.hideCommentStatus();
          break;
        case "/become-a-partner":
          //console.log("You are on the /become-a-partner page.");
          $("#become-a-partner-wells").matchHeight(true);
          break;
        case "/forum/27":
            console.log("You are on the /become-a-partner page.");
            alert("Watch what happens.")
            $("#funding-opportunities-forum-container").matchHeight(true);
            break;          
        case "/calendar":
          $.preprocessCalendar();
          $.rememberTabs();
          break;
        case "/events":
          $.getLastMeetingReport();
          break;
        case "/survey":
          $('.alert.alert-success.alert-dismissible').css('display', 'none');
        case "/survey-results":
          google.charts.load('current', {packages: ['corechart', 'bar']});
          google.charts.setOnLoadCallback($.surveyCharts);
      }
    }
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
  $.surveyCharts = function() {
    
    //Return if charts are already created
    if($('#chart_reasons > div').length) {
      return;
    }
    //var obj = JSON.parse(my_data);

    var survey_responses = $("#survey-responses").data('responses');
    console.log(survey_responses);

    if(parseInt(survey_responses) == 0) {
      $('#survey-download-btn').addClass('disabled');
    }
    setTimeout(function (){
      $('.survey-results').slideDown('slow');
    }, 1500);

    var chart_reasons = $("#chart_reasons").data('table');
    var chart_background = $("#chart_background").data('table');
    var chart_familiarity = $("#chart_familiarity").data('table');
    var chart_region = $("#chart_region").data('table');
    var chart_helpful = $("#chart_helpful").data('table');
    var chart_feedback = $("#chart_feedback").data('table');

    var d1 = JSON.parse("["+chart_reasons+"]");
    var d2 = JSON.parse("["+chart_background+"]");
    var d3 = JSON.parse("["+chart_familiarity+"]");
    var d4 = JSON.parse("["+chart_region+"]");
    var d5 = JSON.parse("["+chart_helpful+"]");
    var d6 = JSON.parse("["+chart_feedback+"]");
    
    //var data1 = google.visualization.arrayToDataTable(chart_reasons);
    var data1 = google.visualization.arrayToDataTable(d1);
    var data2 = google.visualization.arrayToDataTable(d2);
    var data3 = google.visualization.arrayToDataTable(d3);
    var data4 = google.visualization.arrayToDataTable(d4);
    var data5 = google.visualization.arrayToDataTable(d5);
    var data6 = google.visualization.arrayToDataTable(d6);
// chartArea: {width: 300},
    var options = {
      width: 400,
      height:240,

      hAxis: {
        minValue: 0
      },
      vAxis: {
        minValue: 0
      },
      pieSliceTextStyle: { color: 'black', fontName: 'Arial', fontSize: 14 }, 
      backgroundColor: 'transparent',
      legend: { textStyle: { color: 'black', fontName: 'Arial', fontSize: 14 } },
      enableInteractivity: true       
    };

    var chart1 = new google.visualization.BarChart(document.getElementById('chart_reasons'));
    var chart2 = new google.visualization.BarChart(document.getElementById('chart_background'));
    var chart3 = new google.visualization.PieChart(document.getElementById('chart_familiarity'));
    var chart4 = new google.visualization.BarChart(document.getElementById('chart_region'));
    var chart5 = new google.visualization.PieChart(document.getElementById('chart_helpful'));
    var chart6 = new google.visualization.PieChart(document.getElementById('chart_feedback'));

    options.legend.position = 'top';
    chart1.draw(data1, options);
    chart2.draw(data2, options);
    options.legend.position = 'right';
    chart3.draw(data3, options);
    options.legend.position = 'top';
    chart4.draw(data4, options);
    options.legend.position = 'right';
    chart5.draw(data5, options);
    chart6.draw(data6, options);
  }
  $.preprocessForum = function(e) {
    if(!$('#new-forum-breadcrumb > #forum-breadcrumb').length) {
      $( "#forum-breadcrumb" ).clone().prependTo( "#new-forum-breadcrumb" );
      $( "#new-forum-breadcrumb > #forum-breadcrumb" ).show();
    }
    $(".topic-status-legend").show();
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
      //console.log("function: advanceEndDateTime");
      var eventDuration = 2; //Number of hours between events
      //var startDate = new Date($('#edit-field-event-date-range-0-value-date').val()+' '+$('#edit-field-event-date-range-0-value-time').val());
      var startDate = new Date($('#edit-field-event-date-range-0-value-date').val()+' '+$('#edit-field-event-date-range-0-value-time').val());
      var endDateOnly = new Date($('#edit-field-event-date-range-0-end-value-date').val()+' '+$('#edit-field-event-date-range-0-end-value-time').val());
      //console.dir(endDateOnly);
      //console.log(endDate instanceof Date && !isNaN(endDate.valueOf()));
      if(startDate instanceof Date && !isNaN(startDate.valueOf())) {
        //console.log("BEFORE CHANGE");
        //console.log("Start Date: "+$('#edit-field-event-date-range-0-value-date').val()+' '+$('#edit-field-event-date-range-0-value-time').val());
        //console.log("End Date: "+$('#edit-field-event-date-range-0-end-value-date').val()+' '+$('#edit-field-event-date-range-0-end-value-time').val());

        startDate.setHours(startDate.getHours()+eventDuration);
        //console.log(startDate.getUTCDate());
        startDateOnly = new Date(startDate.getUTCFullYear() + "-"+ (startDate.getUTCMonth()+1) + "-" + (startDate.getUTCDate()));
        //console.log("What is this: "+startDate.getUTCFullYear() + "-"+ (startDate.getUTCMonth()+1) + "-" + (startDate.getUTCDate()));
        //console.log("Start Date Only : "+startDateOnly.getUTCFullYear() + "-" + ("0" + (startDateOnly.getUTCMonth()+1)).slice(-2) + "-" + ("0" + startDateOnly.getUTCDate()).slice(-2));
        //console.log("End Date Only : "+endDateOnly.getUTCFullYear() + "-" + ("0" + (endDateOnly.getUTCMonth()+1)).slice(-2) + "-" + ("0" + endDateOnly.getUTCDate()).slice(-2));

        if(startDateOnly > endDateOnly) {
          //console.log("startDateOnly is larger then endDateOnly");
          finalEndDateOnly = new Date(startDateOnly.getUTCFullYear() + "-"+ (startDateOnly.getUTCMonth()+1) + "-" + (startDateOnly.getUTCDate()));
        } else {
          finalEndDateOnly = new Date(endDateOnly.getUTCFullYear() + "-"+ (endDateOnly.getUTCMonth()+1) + "-" + (endDateOnly.getUTCDate()));
        }
        //console.log("Final End Date Only : "+finalEndDateOnly.getUTCFullYear() + "-" + ("0" + (finalEndDateOnly.getUTCMonth()+1)).slice(-2) + "-" + ("0" + finalEndDateOnly.getUTCDate()).slice(-2));
        //console.log("END DATE OBJECT");
        //console.dir(endDate);
        //var endDateFormatted = $.datepicker.formatDate(formatDate, endDate);
        var endDateFormattedWithDuration = finalEndDateOnly.getUTCFullYear() + "-" + ("0" + (finalEndDateOnly.getUTCMonth()+1)).slice(-2) + "-" + ("0" + finalEndDateOnly.getUTCDate()).slice(-2);
        var endTimeFormattedWithDuration = ("0" + startDate.getHours()).slice(-2) + ":" + ("0" + startDate.getMinutes()).slice(-2);

        $('#edit-field-event-date-range-0-end-value-date').val(endDateFormattedWithDuration);
        $('#edit-field-event-date-range-0-end-value-time').val(endTimeFormattedWithDuration);
      }
  }

  $.preprocessFixDateRangeEvents = function(e) {
    $('#edit-field-event-date-range-0-value-date').on('change', function(e) {
      var newDate = new Date($('#edit-field-event-date-range-0-value-date').val());
      var oldDate = new Date($('#edit-field-event-date-range-0-end-value-date').val());
      //console.log("New Date Only : "+newDate.getFullYear() + "-" + ("0" + (newDate.getMonth()+1)).slice(-2) + "-" + ("0" + newDate.getUTCDate()).slice(-2));
      //console.log("Old Date Only : "+oldDate.getFullYear() + "-" + ("0" + (oldDate.getMonth()+1)).slice(-2) + "-" + ("0" + oldDate.getUTCDate()).slice(-2));
        //console.log($('#edit-field-event-date-range-0-value-date').val());
      if(newDate > oldDate) {
        $('#edit-field-event-date-range-0-end-value-date').val($('#edit-field-event-date-range-0-value-date').val());
      }
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
      $("#edit-field-event-group option[value='Funding Opportunities']").remove();
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
              console.log("data returned")
              console.dir(data);
              var roles = JSON.parse(data);
              console.dir(roles);
              if(!$('#add-event-meeting').length && (($.inArray("administrator", roles)>=0) || ($.inArray("manager", roles)>=0))) {
                  $('div.view-full-calendar-meetings > div.view-content > div.fullcalendar > div.fc-toolbar > div.fc-right > .fc-listYear-button').before('<span id="add-event-meeting" style="margin-top:7px;font-weight:bold;"><a href="/node/add/events?calendar_type=Partner Meetings&destination=/calendar">+ Add Event</a></span>');
              }
              //Always add this one.  This is for authenticated users who can see the calendar.
              if(!$('#add-external-event').length) {
                console.log("Are you here");
                //setTimeout($.calendarExternalEvents, 1500);
                $('div.view-full-calendar-external-events > div.view-content > div.fullcalendar > div.fc-toolbar > div.fc-right > .fc-listYear-button').before('<span id="add-external-event" style="margin-top:7px;font-weight:bold;"><a href="/node/add/events?calendar_type=External Events&destination=/calendar">+ Add Event</a></span>');
              }

          }
       });
    }


  }
  $.calendarExternalEvents = function() {
    $('div.view-full-calendar-external-events > div.view-content > div.fullcalendar > div.fc-toolbar > div.fc-right > .fc-listYear-button').before('<span id="add-external-event" style="margin-top:7px;font-weight:bold;"><a href="/node/add/events?calendar_type=External Events&destination=/calendar">+ Add Event</a></span>');
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
    //If anonymous don't redirect to member /partners from the Global Reach image.
    /*
    if(title == 'Global Reach' && $("#navbar-collapse").find('a').text() == "Log in") {
      return "/partners";
    }
    */
    var routes = [{
        title : 'Global Reach',
        url : '/'
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
    console.log("You are on the /contact-us page.");
    var typeOfIssue =decodeURIComponent($.urlParam("type-of-issue"));
    if(typeOfIssue.length > 0 ) {
      $('#edit-type-of-issue').val(typeOfIssue);
    }
    var currentName = $('#edit-name').val();
    //console.log("currentName: "+currentName);
    if(currentName == "[current-user:field_first_name] [current-user:field_last_name]") {
      console.info("We got a match");
      $('#edit-name').val('');
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

  $.getLastMeetingReport = function() {
    $.ajax({
      url: "/api/latest/meeting-report",
      success: function( meetingReport ) {
/*        var data = [ {
      url: "https://icrpartnership-dev.org/api/latest/meeting-report",
  "libraryid": 7274,
  "filename": "ICRP_AnnualMeeting2017_Report.txt",
  "thumbnailfilename": "free-map-pin-icons.7371.jpg",
  "title": "ICRP 2017 Annual Meeting Report - Brief Summary",
  "description": "Summary of the ICRP 2017 annual meeting, hosted by the UK National Cancer Research Institute. Meeting theme: \"Global collaboration in cancer research: impact and policy\""
}];
var meetingReport = data[0];
  console.dir(meetingReport);
*/
        var pdf = "/library/file/"+(meetingReport.libraryid || 0)+"/"+meetingReport.filename;
        var thumbnail = "/library/file/thumb/"+meetingReport.thumbnailfilename;
        $("#events-and-resources-card > .card-header:eq(0)").text(meetingReport.title);
        $("#last-meeting-report-img").attr('src', thumbnail);
        $("#last-meeting-report-a-img").attr('href', pdf);
        $("#last-meeting-report-text").text(meetingReport.description);
        $("#last-meeting-report-pdf").attr('href', pdf);
        $('#last-meeting-report-pdf').text('Download ' + pdf.split('.').pop().toUpperCase());
        $('#events-and-resources-card').show();
        //setTimeout(function() { $.tweekHomePageRefreshTwitterBlock(); }, 250);
      }
    });
  }

  $.getNewsletter = function() {
    //console.log("Get Newsletter");
    //console.log("section height");
    //console.log($( "section.col-sm-9" ).height());
    //$('section:first, aside[role="complementary"]').matchHeight(true);
    //$('section.col-sm-9, aside[role="complementary"]').matchHeight(true);
    var host = "";
    $.get('/api/latest/newsletter').then(function(newsletter) {
      if(window.location.hostname == "localhost") {
        var data = [{"libraryid":7430,"filename":"7430.pdf","thumbnailfilename":"7430.jpg","title":"ICRP 2018 Annual Meeting - Summary and Highlights","description":"Find out more about the ICRP\u0027s 2018 Annual Meeting held at the US National Cancer Institute on 11 April, 2018 on the theme of \u0022Advancing cancer research through global partnership: identifying gaps and opportunities\u0022"}];
        var newsletter = data[0];
        host = "https://icrpartnership-dev.org";
      } 

      console.dir(newsletter);
      var pdf = host+"/library/file/"+(newsletter.libraryid || 0)+"/"+newsletter.filename;
      var thumbnail = host+"/library/file/thumb/"+newsletter.thumbnailfilename;

      $('#last_newsletter').html("<div class='newsletter-title'>"+newsletter.title+"</div>");
      $("#last_newsletter").append("<div class='row text-center'><div class='newsletter-image'><a href='"+pdf+"' title='Latest Newsleter' target='_blank'><img class='center-block' src='"+thumbnail+"' /></a></div></div>");
      $('#last_newsletter').append("<div id='newsletter-description-container' ><div class='newsletter-description'>"+newsletter.description+"</div></div>");
      //$('#last_newsletter').append("<div class='newsletter-description'>"+newsletter.description+"</div>");
      $("#newsletter-container").show();
    });
  }

  $.tweekHomePage = function () {
    $('article').remove();
    $.tweekHomePageRefreshTwitterBlock();
  }

  $.tweekHomePageRefreshTwitterBlock = function() {
    // set the height of the aside to the same as the section height
    var sectionHeight = $('[role="main"] section').height();
    $('[role="main"] aside').height(sectionHeight);
    // set the height of the first child in the aside to 100%
    $('[role="main"] aside > div:first').css('height', '100%');
    // set the height of the twitter panel to fill the remaining space (minus the padding)
    $('#twitter-container').height(sectionHeight - $('#newsletter-container').height() - 140);
    // set the height of the Newsletter Description
    // .newsletter-description height: =  aside.height - newsletter_desc.top + aside.top - offset;
    const nloffset = 20;
    var asideHeight = $('aside').height();
    var aside = $("aside").offset();
    /*
    if($(".newsletter-description").length) {
      //console.info("On FRONT PAGE anonymous");
      var newsletter_desc = $(".newsletter-description").offset();
      var nlheight = asideHeight - newsletter_desc.top + aside.top - nloffset;
      $('.newsletter-description').css('height', nlheight);
    } 
    */
    
    if($("#newsletter-container > .views-element-container").length) {
      var newsletter_container = $("#newsletter-container").offset();
      var nlheight = asideHeight - newsletter_container.top + aside.top - nloffset;
      //console.info("On WELCOME PAGE partner");
      //console.log(nlheight);
      var a = $('#newsletter-container > div:first').height();
      var b = $('.views-field-nothing').height();
      var c = $('.views-field-nothing-1').height();
      $('.views-field-body').css('height', nlheight-a-b-c-20);
      $('.views-field-body').css('overflow', 'hidden');
    }
  }
})(window.jQuery, window.Drupal, window.drupalSettings);