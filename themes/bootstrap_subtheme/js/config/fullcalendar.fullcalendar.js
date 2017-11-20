/**
 * @file
 * Processes the FullCalendar options and passes them to the integration.
 */

(function ($, Drupal, drupalSettings) {

  "use strict";

  Drupal.fullcalendar.plugins.fullcalendar = {
    options: function (fullcalendar, settings) {
      if (settings.ajax) {
        fullcalendar.submitInit(settings);
      }

      var options = {
        eventAfterAllRender: function(view) {
          //console.dir(view);
          var moment = fullcalendar.$calendar.find('.fullcalendar').fullCalendar('getDate');
          var calendar_date = moment.format('YYYY-MM-DD');
          var calendar_year_month = moment.format('YYYY-MM');
          //console.log("calendar_date: "+calendar_date);
          var current_date = new Date();
          var current_year_month = current_date.getFullYear() + "-" + ("0" + (current_date.getMonth()+1)).slice(-2);
          var lastCalendarDate = localStorage.getItem('lastCalendarDate');
          //console.log("current_year_month: "+current_year_month);
          //console.log("lastCalendarDate: "+ lastCalendarDate);
          if(lastCalendarDate == null) {
              localStorage.setItem('lastCalendarDate', calendar_date);
          }
          //Only change if not in the current year month.  This prevents it resetting 
          if(lastCalendarDate) {
            if(current_year_month != lastCalendarDate.substring(0,6)) {
              localStorage.setItem('lastCalendarDate', calendar_date);
              //fullcalendar.$calendar.find('.fullcalendar').fullCalendar('gotoDate', lastCalendarDate);

            } else {
              console.log("current_year_month == lastCalendarDate");
            }
          }
        },
        eventClick: function (event, jsEvent, view) {
          if (settings.sameWindow) {
            //window.open(event.url, '_self');
            var href_events = "/events/" + event.eid;;
            var href_permissions = "/node-permissions/" + event.eid;;

            $.ajax({
                url:  href_events,
                success: function( data ) {
                    $('#calendar-modal').html(data);
                    $.ajax({
                        url:  href_permissions,
                        success: function( data ) {
                          var node_permission = JSON.parse(data);
                          //console.log("I am here");
                          if(node_permission.editable) {
                            $('#event-edit').show();
                          } else {
                            $('#event-edit').hide();
                          }
                          $('#calendar-modal').modal("show");
                        }
                     });
                  }
              });
          }
          else {
            window.open(event.url);
          }
          return false;
        },
        drop: function (date, jsEvent, ui) {
          for (var $plugin in Drupal.fullcalendar.plugins) {
            if (Drupal.fullcalendar.plugins.hasOwnProperty($plugin) && $.isFunction(Drupal.fullcalendar.plugins[$plugin].drop)) {
              try {
                Drupal.fullcalendar.plugins[$plugin].drop(date, jsEvent, ui, this, fullcalendar);
              }
              catch (exception) {
                alert(exception);
              }
            }
          }
        },
        events: function (start, end, timezone, callback) {
          // Fetch new items from Views if possible.
          if (settings.ajax && settings.fullcalendar_fields) {
            fullcalendar.dateChange(settings.fullcalendar_fields);
            if (fullcalendar.navigate) {
              if (!fullcalendar.refetch) {
                fullcalendar.fetchEvents();
              }
              fullcalendar.refetch = false;
            }
          }

          fullcalendar.parseEvents(callback);

          if (!fullcalendar.navigate) {
            // Add events from Google Calendar feeds.
            for (var entry in settings.gcal) {
              if (settings.gcal.hasOwnProperty(entry)) {
                fullcalendar.$calendar.find('.fullcalendar').fullCalendar('addEventSource',
                  $.fullCalendar.gcalFeed(settings.gcal[entry][0], settings.gcal[entry][1])
                );
              }
            }
          }

          // Set navigate to true which means we've starting clicking on
          // next and previous buttons if we re-enter here again.
          fullcalendar.navigate = true;
        },
        eventDrop: function (event, delta, revertFunc) {
          $.post(
            Drupal.url('fullcalendar/ajax/update/drop/' + event.entity_type + '/' + event.eid + '/' + event.field + '/' + event.index),
            'day_delta=' + delta.days() + '&hour_delta=' + delta.hours() + '&minute_delta=' + delta.minutes() + '&dom_id=' + event.dom_id,
            fullcalendar.update
          );
          return false;
        },
        eventResize: function (event, delta, revertFunc) {
          $.post(
            Drupal.url('fullcalendar/ajax/update/resize/' + event.entity_type + '/' + event.eid + '/' + event.field + '/' + event.index),
            'event_start=' + event.start.format() + '&event_end=' + event.end.format() + '&dom_id=' + event.dom_id,
            fullcalendar.update
          );
          return false;
        }
      };
      //Prevent dragable
      options.editable = false;
      options.eventStartEditable = false;
      options.eventDurationEditable = false;
      options.dragRevertDuration = 500;

      var lastCalendarDate = localStorage.getItem('lastCalendarDate');
      //alert(lastCalendarDate);
      if(lastCalendarDate) {
        options.defaultDate = moment(lastCalendarDate);
      }

      //Goto default_date in url
      var default_date = decodeURIComponent($.urlParam("default_date"));
      if(default_date.length > 0 ) {
        options.defaultDate = moment(default_date);
        //console.dir(options);
      }

      // Merge in our settings.
      $.extend(options, settings.fullcalendar);

      // Pull in overrides from URL.
      if (settings.date) {
        $.extend(options, settings.date);
      }

      return options;
    }
  };

})(jQuery, Drupal, drupalSettings);
