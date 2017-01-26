(function ($) {
  Drupal.behaviors.myModuleBehavior = {
    attach: function (context, settings) {
      //$('h2').css('color', 'red');
      $("#edit-keys").attr("placeholder", "Search Website");
    }
  }
})(window.jQuery);

window['enableResizableTableColumns'] = function() {
  window.setTimeout(function() {
    $('table').resizableColumns();
  }, 0)
}

window['enableTooltips'] = function() {
  window.setTimeout(function() {
    $('[data-toggle="tooltip"]').tooltip({container: 'body'}); 
  }, 0)
}

$(document).ready(function() {
  window.enableResizableTableColumns();
  window.enableTooltips();
});;
/**
 * @file
 * Attaches behaviors for Drupal's active link marking.
 */

(function (Drupal, drupalSettings) {

  'use strict';

  /**
   * Append is-active class.
   *
   * The link is only active if its path corresponds to the current path, the
   * language of the linked path is equal to the current language, and if the
   * query parameters of the link equal those of the current request, since the
   * same request with different query parameters may yield a different page
   * (e.g. pagers, exposed View filters).
   *
   * Does not discriminate based on element type, so allows you to set the
   * is-active class on any element: a, li…
   *
   * @type {Drupal~behavior}
   */
  Drupal.behaviors.activeLinks = {
    attach: function (context) {
      // Start by finding all potentially active links.
      var path = drupalSettings.path;
      var queryString = JSON.stringify(path.currentQuery);
      var querySelector = path.currentQuery ? "[data-drupal-link-query='" + queryString + "']" : ':not([data-drupal-link-query])';
      var originalSelectors = ['[data-drupal-link-system-path="' + path.currentPath + '"]'];
      var selectors;

      // If this is the front page, we have to check for the <front> path as
      // well.
      if (path.isFront) {
        originalSelectors.push('[data-drupal-link-system-path="<front>"]');
      }

      // Add language filtering.
      selectors = [].concat(
        // Links without any hreflang attributes (most of them).
        originalSelectors.map(function (selector) { return selector + ':not([hreflang])'; }),
        // Links with hreflang equals to the current language.
        originalSelectors.map(function (selector) { return selector + '[hreflang="' + path.currentLanguage + '"]'; })
      );

      // Add query string selector for pagers, exposed filters.
      selectors = selectors.map(function (current) { return current + querySelector; });

      // Query the DOM.
      var activeLinks = context.querySelectorAll(selectors.join(','));
      var il = activeLinks.length;
      for (var i = 0; i < il; i++) {
        activeLinks[i].classList.add('is-active');
      }
    },
    detach: function (context, settings, trigger) {
      if (trigger === 'unload') {
        var activeLinks = context.querySelectorAll('[data-drupal-link-system-path].is-active');
        var il = activeLinks.length;
        for (var i = 0; i < il; i++) {
          activeLinks[i].classList.remove('is-active');
        }
      }
    }
  };

})(Drupal, drupalSettings);
;
/**
 * @file
 * Javascript behaviors for details element.
 */

(function ($, Drupal) {

  'use strict';

  /**
   * Attach handler to save details open/close state.
   *
   * @type {Drupal~behavior}
   */
  Drupal.behaviors.yamlFormDetailsSave = {
    attach: function (context) {
      if (!window.localStorage) {
        return;
      }

      // Summary click event handler.
      $('details > summary', context).once('yamlform-details-summary-save').click(function () {
        var $details = $(this).parent();

        var name = Drupal.yamlFormDetailsSaveGetName($details);
        if (!name) {
          return;
        }

        var open = ($details.attr('open') != 'open') ? 1 : 0;
        localStorage.setItem(name, open);
      });

      // Initialize details open state via local storage.
      $('details', context).once('yamlform-details-save').each(function () {
        var $details = $(this);

        var name = Drupal.yamlFormDetailsSaveGetName($details);
        if (!name) {
          return;
        }

        var open = localStorage.getItem(name);
        if (open === null) {
          return;
        }

        if (open == 1) {
          $details.attr('open', 'open');
        }
        else {
          $details.removeAttr('open');
        }
      });
    }

  };

  /**
   * Get the name used to store the state of details element.
   *
   * @param $details
   *   A details element.
   *
   * @returns string
   *   The name used to store the state of details element.
   */
  Drupal.yamlFormDetailsSaveGetName = function($details) {
    if (!window.localStorage) {
      return '';
    }

    // Any details element not included a form must have define its own id.
    var yamlformId = $details.attr('data-yamlform-element-id');
    if (yamlformId) {
      return 'yamlform.' + yamlformId.replace('--', '.');
    }

    var detailsId = $details.attr('id');
    if (!detailsId) {
      return '';
    }

    var $form = $details.parents('form');
    if (!$form.length || !$form.attr('id')) {
      return '';
    }

    var formId = $form.attr('id');
    if (!formId) {
      return '';
    }

    // ISSUE: When Drupal renders a form  in a modal dialog it appends a unique
    // identifier to form ids and details ids. (ie my-form--FeSFISegTUI)
    // WORKAROUND: Remove the unique id that delimited using double dashes.
    formId = formId.replace(/--.+?$/, '').replace(/-/g, '_');
    detailsId = detailsId.replace(/--.+?$/, '').replace(/-/g, '_');
    return 'yamlform.' + formId + '.' + detailsId;
  }


})(jQuery, Drupal);
;
!function(t,a,e){"use strict";a.extlink=a.extlink||{},a.extlink.attach=function(e,n){if(n.data.hasOwnProperty("extlink")){var l,i=/^(([^\/:]+?\.)*)([^\.:]{4,})((\.[a-z]{1,4})*)(:[0-9]{1,5})?$/,s=window.location.host.replace(i,"$3$4"),x=window.location.host.replace(i,"$1");l=n.data.extlink.extSubdomains?"([^/]*\\.)?":"www."===x||""===x?"(www\\.)?":x.replace(".","\\.");var p=new RegExp("^https?://"+l+s,"i"),d=!1;n.data.extlink.extInclude&&(d=new RegExp(n.data.extlink.extInclude.replace(/\\/,"\\"),"i"));var r=!1;n.data.extlink.extExclude&&(r=new RegExp(n.data.extlink.extExclude.replace(/\\/,"\\"),"i"));var k=!1;n.data.extlink.extCssExclude&&(k=n.data.extlink.extCssExclude);var c=!1;n.data.extlink.extCssExplicit&&(c=n.data.extlink.extCssExplicit);var o=[],h=[];t("a:not(."+n.data.extlink.extClass+", ."+n.data.extlink.mailtoClass+"), area:not(."+n.data.extlink.extClass+", ."+n.data.extlink.mailtoClass+")",e).each(function(a){try{var e=this.href.toLowerCase();0!==e.indexOf("http")||(e.match(p)||r&&e.match(r))&&(!d||!e.match(d))||k&&t(this).parents(k).length>0||c&&t(this).parents(c).length<1?"AREA"===this.tagName||0!==e.indexOf("mailto:")||k&&t(this).parents(k).length>0||c&&t(this).parents(c).length<1||h.push(this):o.push(this)}catch(n){return!1}}),n.data.extlink.extClass&&a.extlink.applyClassAndSpan(o,n.data.extlink.extClass),n.data.extlink.mailtoClass&&a.extlink.applyClassAndSpan(h,n.data.extlink.mailtoClass),n.data.extlink.extTarget&&n.data.extlink.extTarget&&t(o).attr("target","_blank"),a.extlink=a.extlink||{},a.extlink.popupClickHandler=a.extlink.popupClickHandler||function(){return n.data.extlink.extAlert?confirm(n.data.extlink.extAlertText):void 0},t(o).click(function(t){return a.extlink.popupClickHandler(t)})}},a.extlink.applyClassAndSpan=function(a,n){var l;if(e.data.extlink.extImgClass)l=t(a);else{var i=t(a).find("img").parents("a");l=t(a).not(i)}l.addClass(n);var s,x=l.length;for(s=0;x>s;s++){var p=t(l[s]);("inline"===p.css("display")||"inline-block"===p.css("display"))&&(n===e.data.extlink.mailtoClass?p.append('<span class="'+n+'"><span class="element-invisible"> '+e.data.extlink.mailtoLabel+"</span></span>"):p.append('<span class="'+n+'"><span class="element-invisible"> '+e.data.extlink.extLabel+"</span></span>"))}},a.behaviors.extlink=a.behaviors.extlink||{},a.behaviors.extlink.attach=function(t,e){"function"==typeof extlinkAttach?extlinkAttach(t):a.extlink.attach(t,e)}}(jQuery,Drupal,drupalSettings);
;
/**
 * @file
 * Bootstrap Popovers.
 */

var Drupal = Drupal || {};

(function ($, Drupal, Bootstrap) {
  "use strict";

  /**
   * Extend the Bootstrap Popover plugin constructor class.
   */
  Bootstrap.extendPlugin('popover', function (settings) {
    return {
      DEFAULTS: {
        animation: !!settings.popover_animation,
        html: !!settings.popover_html,
        placement: settings.popover_placement,
        selector: settings.popover_selector,
        trigger: settings.popover_trigger,
        triggerAutoclose: !!settings.popover_trigger_autoclose,
        title: settings.popover_title,
        content: settings.popover_content,
        delay: parseInt(settings.popover_delay, 10),
        container: settings.popover_container
      }
    };
  });

  /**
   * Bootstrap Popovers.
   *
   * @todo This should really be properly delegated if selector option is set.
   */
  Drupal.behaviors.bootstrapPopovers = {
    attach: function (context) {

      // Popover autoclose.
      if ($.fn.popover.Constructor.DEFAULTS.triggerAutoclose) {
        var $currentPopover = null;
        $(document)
          .on('show.bs.popover', '[data-toggle=popover]', function () {
            var $trigger = $(this);
            var popover = $trigger.data('bs.popover');

            // Only keep track of clicked triggers that we're manually handling.
            if (popover.options.originalTrigger === 'click') {
              if ($currentPopover && !$currentPopover.is($trigger)) {
                $currentPopover.popover('hide');
              }
              $currentPopover = $trigger;
            }
          })
          .on('click', function (e) {
            var $target = $(e.target);
            var popover = $target.is('[data-toggle=popover]') && $target.data('bs.popover');
            if ($currentPopover && !$target.is('[data-toggle=popover]') && !$target.closest('.popover.in')[0]) {
              $currentPopover.popover('hide');
              $currentPopover = null;
            }
          })
        ;
      }

      var elements = $(context).find('[data-toggle=popover]').toArray();
      for (var i = 0; i < elements.length; i++) {
        var $element = $(elements[i]);
        var options = $.extend({}, $.fn.popover.Constructor.DEFAULTS, $element.data());

        // Store the original trigger.
        options.originalTrigger = options.trigger;

        // If the trigger is "click", then we'll handle it manually here.
        if (options.trigger === 'click') {
          options.trigger = 'manual';
        }

        // Retrieve content from a target element.
        var $target = $(options.target || $element.is('a[href^="#"]') && $element.attr('href')).clone();
        if (!options.content && $target[0]) {
          $target.removeClass('visually-hidden hidden').removeAttr('aria-hidden');
          options.content = $target.wrap('<div/>').parent()[options.html ? 'html' : 'text']() || '';
        }

        // Initialize the popover.
        $element.popover(options);

        // Handle clicks manually.
        if (options.originalTrigger === 'click') {
          // To ensure the element is bound multiple times, remove any
          // previously set event handler before adding another one.
          $element
            .off('click.drupal.bootstrap.popover')
            .on('click.drupal.bootstrap.popover', function (e) {
              $(this).popover('toggle');
              e.preventDefault();
              e.stopPropagation();
            })
          ;
        }
      }
    },
    detach: function (context) {
      // Destroy all popovers.
      $(context).find('[data-toggle="popover"]')
        .off('click.drupal.bootstrap.popover')
        .popover('destroy')
      ;
    }
  };

})(window.jQuery, window.Drupal, window.Drupal.bootstrap);
;
/**
 * @file
 * Bootstrap Tooltips.
 */

var Drupal = Drupal || {};

(function ($, Drupal, Bootstrap) {
  "use strict";

  /**
   * Extend the Bootstrap Tooltip plugin constructor class.
   */
  Bootstrap.extendPlugin('tooltip', function (settings) {
    return {
      DEFAULTS: {
        animation: !!settings.tooltip_animation,
        html: !!settings.tooltip_html,
        placement: settings.tooltip_placement,
        selector: settings.tooltip_selector,
        trigger: settings.tooltip_trigger,
        delay: parseInt(settings.tooltip_delay, 10),
        container: settings.tooltip_container
      }
    };
  });

  /**
   * Bootstrap Tooltips.
   *
   * @todo This should really be properly delegated if selector option is set.
   */
  Drupal.behaviors.bootstrapTooltips = {
    attach: function (context) {
      var elements = $(context).find('[data-toggle="tooltip"]').toArray();
      for (var i = 0; i < elements.length; i++) {
        var $element = $(elements[i]);
        var options = $.extend({}, $.fn.tooltip.Constructor.DEFAULTS, $element.data());
        $element.tooltip(options);
      }
    },
    detach: function (context) {
      // Destroy all tooltips.
      $(context).find('[data-toggle="tooltip"]').tooltip('destroy');
    }
  };

})(window.jQuery, window.Drupal, window.Drupal.bootstrap);
;
/**
 * @file
 * Javascript behaviors for custom form #states.
 */

(function ($, Drupal) {

  'use strict';

  // Make absolutely sure the below event handlers are triggered after
  // the state.js event handlers by attaching them after DOM load.
  $(function () {
    var $document = $(document);
    $document.on('state:visible', function (e) {
      if (!e.trigger) {
        return TRUE;
      }

      if (!e.value) {
        // @see https://www.sitepoint.com/jquery-function-clear-form-data/
        $(':input', e.target).andSelf().each(function () {
          var $input = $(this);
          backupValue(this);
          clearValue(this);
          triggerEventHandlers(this);
        });
      }
      else {
        $(':input', e.target).andSelf().each(function () {
          restoreValue(this);
          triggerEventHandlers(this);
        });
      }
    });

    $document.on('state:disabled', function (e) {
      if (e.trigger) {
        $(e.target).trigger('yamlform:disabled')
          .find('select, input, textarea').trigger('yamlform:disabled');
      }
    });
  });

  /**
   * Trigger an input's event handlers.
   *
   * @param input
   *   An input.
   */
  function triggerEventHandlers(input) {
    var $input = $(input);
    var type = input.type;
    var tag = input.tagName.toLowerCase(); // normalize case
    if (type == 'checkbox' || type == 'radio') {
      $input
        .trigger('change')
        .trigger('blur');
    }
    else if (tag == 'select') {
      $input
        .trigger('change')
        .trigger('blur');
    }
    else if (type != 'submit' && type != 'button') {
      $input
        .trigger('input')
        .trigger('change')
        .trigger('keydown')
        .trigger('keyup')
        .trigger('blur');
    }
  }

  /**
   * Backup an input's current value.
   *
   * @param input
   *   An input.
   */
  function backupValue(input) {
    var $input = $(input);
    var type = input.type;
    var tag = input.tagName.toLowerCase(); // normalize case
    if (type == 'checkbox' || type == 'radio') {
      $input.data('yamlform-value', $input.prop('checked'));
    }
    else if (tag == 'select') {
      var values = [];
      $input.find('option:selected').each(function(i, option){
        values[i] = option.value;
      });
      $input.data('yamlform-value', values);
    }
    else if (type != 'submit' && type != 'button') {
      $input.data('yamlform-value', input.value);
    }
  }

  /**
   * Restore an input's value.
   *
   * @param input
   *   An input.
   */
  function restoreValue(input) {
    var $input = $(input);
    var value = $input.data('yamlform-value');
    if (typeof value === 'undefined') {
      return true;
    }

    var type = input.type;
    var tag = input.tagName.toLowerCase(); // normalize case

    if (type == 'checkbox' || type == 'radio') {
      $input.prop('checked', value)
    }
    else if (tag == 'select') {
      $.each(value, function(i, option_value){
        $input.find("option[value='" + option_value + "']").prop("selected", true);
      });
    }
    else if (type != 'submit' && type != 'button') {
      input.value = value;
    }
  }

  /**
   * Clear an input's value.
   *
   * @param input
   *   An input.
   */
  function clearValue(input) {
    var $input = $(input);
    var type = input.type;
    var tag = input.tagName.toLowerCase(); // normalize case
    if (type == 'checkbox' || type == 'radio') {
      $input.prop('checked', false)
    }
    else if (tag == 'select') {
      if ($input.find('option[value=""]').length) {
        $input.val('');
      }
      else {
        input.selectedIndex = -1;
      }
    }
    else if (type != 'submit' && type != 'button') {
      input.value = (type == 'color') ? '#000000' : '';
    }
  }

})(jQuery, Drupal);
;
/**
 * @file
 * Javascript behaviors for forms.
 */

(function ($, Drupal) {

  'use strict';

  /**
   * Autofocus first input.
   *
   * @type {Drupal~behavior}
   *
   * @prop {Drupal~behaviorAttach} attach
   *   Attaches the behavior for the form autofocusing.
   */
  Drupal.behaviors.yamlFormAutofocus = {
    attach: function (context) {
      $(context).find('.yamlform-submission-form.js-yamlform-autofocus :input:visible:enabled:first').focus();
    }
  };

  /**
   * Prevent form autosubmit on wizard pages.
   *
   * @type {Drupal~behavior}
   *
   * @prop {Drupal~behaviorAttach} attach
   *   Attaches the behavior for disabling form autosubmit.
   */
  Drupal.behaviors.yamlFormDisableAutoSubmit = {
    attach: function (context) {
      // @see http://stackoverflow.com/questions/11235622/jquery-disable-form-submit-on-enter
      $(context).find('.yamlform-submission-form.js-yamlform-disable-autosubmit input').once('yamlform-disable-autosubmit').on('keyup keypress', function(e) {
        var keyCode = e.keyCode || e.which;
        if (keyCode === 13) {
          e.preventDefault();
          return false;
        }
      });
    }
  };

  /**
   * Skip client-side validation when submit button is pressed.
   *
   * @type {Drupal~behavior}
   *
   * @prop {Drupal~behaviorAttach} attach
   *   Attaches the behavior for the skipping client-side validation.
   */
  Drupal.behaviors.yamlFormSubmitNoValidate = {
    attach: function (context) {
      $(context).find(':button.js-yamlform-novalidate').once('yamlform-novalidate').on('click', function () {
        $(this.form).attr('novalidate', 'novalidate');
      });
    }
  };

  /**
   * Disable validate when save draft submit button is clicked.
   *
   * @type {Drupal~behavior}
   *
   * @prop {Drupal~behaviorAttach} attach
   *   Attaches the behavior for the form draft submit button.
   */
  Drupal.behaviors.yamlFormDraft = {
    attach: function (context) {
      $(context).find('#edit-draft').once('yamlform-draft').on('click', function () {
        $(this.form).attr('novalidate', 'novalidate');
      });
    }
  };

  /**
   * Filters the form element list by a text input search string.
   *
   * The text input will have the selector `input.yamlform-form-filter-text`.
   *
   * The target element to do searching in will be in the selector
   * `input.yamlform-form-filter-text[data-element]`
   *
   * The text source where the text should be found will have the selector
   * `.yamlform-form-filter-text-source`
   *
   * @type {Drupal~behavior}
   *
   * @prop {Drupal~behaviorAttach} attach
   *   Attaches the behavior for the form element filtering.
   */
  Drupal.behaviors.yamlformFilterByText = {
    attach: function (context, settings) {
      var $input = $('input.yamlform-form-filter-text').once('yamlform-form-filter-text');
      var $table = $($input.attr('data-element'));
      var $filter_rows;

      /**
       * Filters the form element list.
       *
       * @param {jQuery.Event} e
       *   The jQuery event for the keyup event that triggered the filter.
       */
      function filterElementList(e) {
        var query = $(e.target).val().toLowerCase();

        /**
         * Shows or hides the form element entry based on the query.
         *
         * @param {number} index
         *   The index in the loop, as provided by `jQuery.each`
         * @param {HTMLElement} label
         *   The label of the yamlform.
         */
        function toggleEntry(index, label) {
          var $label = $(label);
          var $row = $label.parent().parent();
          var textMatch = $label.text().toLowerCase().indexOf(query) !== -1;
          $row.toggle(textMatch);
        }

        // Filter if the length of the query is at least 2 characters.
        if (query.length >= 2) {
          $filter_rows.each(toggleEntry);
        }
        else {
          $filter_rows.each(function (index) {
            $(this).parent().parent().show();
          });
        }
      }

      if ($table.length) {
        $filter_rows = $table.find('div.yamlform-form-filter-text-source');
        $input.on('keyup', filterElementList);
      }
    }
  };

})(jQuery, Drupal);
;
/**
 * @file
 * Javascript behaviors for details element.
 */

(function ($, Drupal) {

  'use strict';

  /**
   * Attach handler to toggle details open/close state.
   *
   * @type {Drupal~behavior}
   */
  Drupal.behaviors.yamlFormDetailsToggle = {
    attach: function (context) {
      $('.js-yamlform-details-toggle', context).once('yamlform-details-toggle').each(function () {
        var $form = $(this);
        var $details = $form.find('details');

        // Toggle is only useful when there are two or more details elements.
        if ($details.length < 2) {
          return;
        }

        // Add toggle state link to first details element.
        $details.first().before($('<button type="button" class="link yamlform-details-toggle-state"></button>')
          .attr('title', Drupal.t('Toggle details widget state.'))
          .on('click', function (e) {
            var open;
            if (isFormDetailsOpen($form)) {
              $form.find('details').removeAttr('open');
              open = 0;
            }
            else {
              $form.find('details').attr('open', 'open');
              open = 1;
            }
            setDetailsToggleLabel($form);

            // Set the saved states for all the details elements.
            // @see yamlform.element.details.save.js
            if (Drupal.yamlFormDetailsSaveGetName) {
              $form.find('details').each(function() {
                var name = Drupal.yamlFormDetailsSaveGetName($(this));
                if (name) {
                  localStorage.setItem(name, open);
                }
              });
            }
          })
          .wrap('<div class="yamlform-details-toggle-state-wrapper"></div>')
          .parent()
        );

        setDetailsToggleLabel($form);
      });
    }
  };

  /**
   * Determine if a form's details are all opened.
   *
   * @param $form
   *   A form.
   *
   * @returns {boolean}
   *   TRUE if a form's details are all opened.
   */
  function isFormDetailsOpen($form) {
    return ($form.find('details[open]').length == $form.find('details').length)
  }

  /**
   * Set a form's details toggle state widget label.
   *
   * @param $form
   *   A form.
   */
  function setDetailsToggleLabel($form) {
    var label = (isFormDetailsOpen($form)) ? Drupal.t('Collapse all') : Drupal.t('Expand all');
    $form.find('.yamlform-details-toggle-state').html(label);
  }

})(jQuery, Drupal);
;
