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
        eventClick: function (event, jsEvent, view) {
          if (settings.sameWindow) {
            //window.open(event.url, '_self');
            var href = "/events/581";
            href = "/events/" + event.eid;;
            console.log("New href");
            console.log(href);
            console.dir(event);
            console.dir(jsEvent);
            $.ajax({
                url:  href
            })
            .success(function( data ) {
              console.dir(data);
                //$('#myModal > div.modal-dialog > div.modal-header').html("London Holiday");
                $('#myModal').html(data);
                /*
                $("#dialog-form").dialog("option", "position", {
                  my: "center",
                  at: "center",
                  of: window
                });
                */
                
                $('#myModal').modal("show");
            });


            /*
            $("#dialog-form").load(href, function() {
                  console.log('Load was performed.');
            });
            */
            /*
            $("#dialog-form").load(href, function(responseTxt, statusTxt, xhr){
                console.log("We got a hit");
                console.log(responseTxt);
                //if(statusTxt == "success")
                   // alert("External content loaded successfully!");
                //if(statusTxt == "error")
                   // alert("Error: " + xhr.status + ": " + xhr.statusText);
            });
            */
            /*
              var host;
              if(window.location.hostname == "localhost") {
                host = "https://icrpartnership-dev.org";
              } else {
                host = window.location.protocol + "//" + window.location.hostname;
              }
              console.log("Hello");
              $.ajax({
                  url:  href
              })
              .success(function( data ) {
                console.dir(data);
                  $('#dialog-form').html(data);

              });
              
            $("#dialog-form").dialog("open");
*/
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
      $.extend(options, settings.fullcalendar);

      // Pull in overrides from URL.
      if (settings.date) {
        $.extend(options, settings.date);
      }

      return options;
    }
  };

})(jQuery, Drupal, drupalSettings);
