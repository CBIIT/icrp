(function($, Drupal, drupalSettings) {

  var getStore = function(storageInterface) {
    return {
      get: function(key) {
        return JSON.parse(storageInterface.getItem(key))
      },
      set: function(key, value) {
        storageInterface.setItem(key, JSON.stringify(value));
      }
    }
  }

  var localStore = getStore(window.localStorage);
  var sessionStore = getStore(window.sessionStorage);

  var surveyDisabled = localStore.get('surveyDisabled');
  var surveyTaken = localStore.get('surveyTaken');
  var surveyShown = sessionStore.get('surveyShown');

  if (!surveyDisabled) {
    $.get('/survey-status').done(function(response) {
      if (JSON.parse(response).isSurveyOpen)
        showSurvey();
    });
  }

  function showSurvey() { // survey invitation code

    // create button to take survey
    var takeSurveyButton = $('<a/>')
      .html('<i class="fas fa-clipboard-list mr1"></i>Take a survey')
      .attr('id', 'take-survey')
      .attr('href', '#')
      .css('background-color', 'steelblue')
      .css('position', 'absolute')
      .css('bottom', '0px')
      .css('right', '25px')
      .css('display', 'inline-block')
      .css('color', 'white')
      .css('padding', '7px 10px')
      .click(showSurveyDialog)

    // only show survey invitation button on non-survey pages
    if (location.pathname !== '/survey') {
      $('header').append(takeSurveyButton.hide())
      if (!surveyTaken && surveyShown)
        $('#take-survey').show();
    }

    // perform the following on the survey
    else if (location.pathname === '/survey') {
      // observe survey and attach click handler when submitted
      var observer = new MutationObserver(function() {
        $('.webform-button--submit').click(function() {
          localStore.set('surveyTaken', true);
          if (window.parent) {
            window.parent.postMessage('survey-complete', '*');
          }
        });
      });

      observer.observe($('[role="main"]')[0], {
        attributes: false,
        childList: true,
        subtree: true
      });
    }

    function showSurveyDialog() {
      bootbox.hideAll();
      var iframe = $('<iframe />')
        .attr('src', '/survey')
        .attr('name', 'surveyFrame')
        .css('border', 'none')
        .css('width', '100%')
        .css('min-height', '600px');

      var dialog = bootbox.dialog({
        className: 'icrp-survey-modal',
        size: 'large',
        message: iframe,
      });

      window.addEventListener('message', function(message) {
        if (message.data === 'survey-complete') {
          $('#take-survey').hide();
          bootbox.hideAll();
          var dialog = bootbox.dialog({
            className: 'icrp-survey-modal',
            size: 'large',
            title: 'ICRP Website Survey',
            message: $('<div>')
              .addClass('text-center')
              .append($('<h1/>').text('Survey Complete'))
              .append($('<p/>').text('Thank you for taking the time to complete this survey. Your responses have been recorded, and will be used to improve your experience on the ICRP Website.')),
            buttons: {
              ok: {
                label: 'Close',
                className: 'btn-primary',
              },
            },
          });
        }
      })
    }

    // show invitation after 5 seconds if it has not been shown before and survey has not been taken
    if (!surveyShown && !surveyTaken) {
      onIdle(function() {
        bootbox.dialog({
          className: 'icrp-survey-modal',
          size: 'large',
          title: 'ICRP Website Survey',
          message: $('<div>')
            .addClass('text-center')
            .append($('<h1/>').text('We welcome your feedback'))
            .append($('<p/>').text('Help us to improve your experience on the ICRP website by taking this short survey.'))
            .append($('<p/>').addClass('small gray').text('Please note that this survey uses cookies to improve user experience. If you do not agree to the use of cookies, please close the survey.')),
          onEscape: function() {
            $('#take-survey').show();
          },
          buttons: {
            cancel: {
              label: 'Cancel',
              className: 'btn-default',
              callback: function() {
                localStore.set('surveyDisabled', true);
                $('#take-survey').hide();
              }
            },
            later: {
              label: 'Maybe Later',
              className: 'btn-warning',
              callback: function() {
                $('#take-survey').show();
              },
            },
            ok: {
              label: 'Take Survey',
              className: 'btn-primary',
              callback: function() {
                $('#take-survey').show();
                showSurveyDialog();
              }
            },
          },
        }).init(function() {
          sessionStore.set('surveyShown', true);
        });
      }, 5000);
    }
  }

})(jQuery, Drupal, drupalSettings);