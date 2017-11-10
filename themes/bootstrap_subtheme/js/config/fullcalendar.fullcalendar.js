/**
 * @file
 * Processes the FullCalendar options and passes them to the integration.
 */

(function ($, Drupal, drupalSettings) {

  "use strict";

  Drupal.fullcalendar.plugins.fullcalendar = {
    options: function (fullcalendar, settings) {
      console.log("Running FULLCALENDAR settings");
      console.dir(settings);
      //alert("Fullcalendar options");
      if (settings.ajax) {
        fullcalendar.submitInit(settings);
      }

      var options = {
        eventClick: function (event, jsEvent, view) {
          if (settings.sameWindow) {
            //window.open(event.url, '_self');
            var href_events = "/events/" + event.eid;;
            var href_permissions = "/node-permissions/" + event.eid;;

            $.ajax({
                url:  href_events,
                success: function( data ) {
                    console.log(data);
                    //var node_data =  $('<div/>').html(data).text(); 
                    //console.log(node_data);
                    //node_data = JSON.parse(node_data);
                    //console.dir(node_data);
                    $('#calendar-modal').html(data);
                    $.ajax({
                        url:  href_permissions,
                        success: function( data ) {
                          //console.log("User Permissions");
                          //console.log(data);
                          var node_permission = JSON.parse(data);
                          //console.dir(node_permission);
                          if(node_permission.editable) {
                            //alert("Show Edit");
                            $('#event-edit').show();
                          } else {
                            //alert("Hide Edit");
                            $('#event-edit').hide();
                          }
                          $('#calendar-modal').modal("show");
                        }
                    //new Element("script", {src: "core/misc/dialog/dialog.ajax.js", type: "text/javascript"});
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

      // Merge in our settings.
      console.dir(settings.fullcalendar);
      $.extend(options, settings.fullcalendar);

      // Pull in overrides from URL.
      if (settings.date) {
        $.extend(options, settings.date);
      }

      return options;
    }
  };

})(jQuery, Drupal, drupalSettings);
