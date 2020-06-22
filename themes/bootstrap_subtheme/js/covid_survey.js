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

  var surveyCanceled = localStore.get('covidSurveyCanceled');
  var surveyTaken = localStore.get('covidSurveyTaken');
  var surveyShown = sessionStore.get('covidSurveyShown');

  if (!surveyCanceled) {
    $.get('/covid-survey-status').done(function(response) {
      if (JSON.parse(response).isSurveyOpen)
        showSurvey();
    });
  }

  function showSurvey() { // survey invitation code

    // create button to take survey
    var takeSurveyButton = $('<a/>')
      .html('<i class="fas fa-clipboard-list mr1"></i>Take the Covid-19 Survey')
      .attr('id', 'take-covid-survey')
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
    if (location.pathname !== '/survey' && location.pathname !== '/covid-survey') {
      $('header').append(takeSurveyButton.hide())
      if (!surveyTaken && surveyShown)
        $('#take-covid-survey').show();
    }

    // perform the following on the survey
    else if (location.pathname === '/covid-survey') {
      // observe survey and attach click handler when submitted
      var observer = new MutationObserver(function() {
        $('.webform-button--submit').click(function() {
          localStore.set('covidSurveyTaken', true);
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
        .attr('src', '/covid-survey')
        .attr('name', 'surveyFrame')
        .css('border', 'none')
        .css('width', '100%')
        .css('min-height', '650px');

      var dialog = bootbox.dialog({
        className: 'icrp-survey-modal',
        size: 'large',
        message: iframe,
      });

      window.addEventListener('message', function(message) {
        if (message.data === 'survey-complete') {
          $('#take-covid-survey').hide();
          bootbox.hideAll();
          var dialog = bootbox.dialog({
            className: 'icrp-survey-modal',
            size: 'large',
            title: 'ICRP Website Survey',
            message: $('<div>')
              .addClass('text-center')
              .append($('<h1/>').text('Survey Complete'))
              .append($('<p/>').text('Thank you for taking the time to complete this survey. Your responses have been recorded, and will be used to help us to better understand the challenges of the pandemic on the cancer research environment and help to advocate for needed responses to ensure the continued robustness of support for cancer research.')),
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
          title: 'ICRP Covid-19 Survey', 
          message: $('<div>')
            .addClass('text-center')
            .append($('<h1/>').text('COVID-19: Impact on Cancer Research Funding'))
	    .append($('<p/>').css('text-align', 'left').text('ICRP is interested in learning more about the potential impacts of COVID-19 on the cancer research funding landscape globally. We are hoping that this will enable us to better understand the challenges of the pandemic on the cancer research environment and help to advocate for needed responses to ensure the continued robustness of support for cancer research.'))

            .append($('<p/>').addClass('small gray').text('Please note that this survey uses cookies to improve user experience. If you do not agree to the use of cookies, please close the survey.')),
          onEscape: function() {
            $('#take-covid-survey').show();
          },
          buttons: {
            cancel: {
              label: 'Never',
              className: 'btn-default',
              callback: function() {
                localStore.set('covidSurveyCanceled', true);
                $('#take-covid-survey').hide();
              }
            },
            later: {
              label: 'Maybe Later',
              className: 'btn-warning',
              callback: function() {
                $('#take-covid-survey').show();
              },
            },
            ok: {
              label: 'Take Survey',
              className: 'btn-primary',
              callback: function() {
                $('#take-covid-survey').show();
                showSurveyDialog();
              }
            },
          },
        }).init(function() {
          sessionStore.set('covidSurveyShown', true);
        });
      }, 5000);
    }
  }

})(jQuery, Drupal, drupalSettings);
