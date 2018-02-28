/*! DataTables Bootstrap 3 integration
 * ©2011-2015 SpryMedia Ltd - datatables.net/license
 */

(function (factory) {
  if (typeof define === 'function' && define.amd) {
    // AMD
    define([
      'jquery', 'datatables.net'
    ], function ($) {
      return factory($, window, document);
    });
  } else if (typeof exports === 'object') {
    // CommonJS
    module.exports = function (root, $) {
      if (!root) {
        root = window;
      }

      if (!$ || !$.fn.dataTable) {
        // Require DataTables, which attaches to jQuery, including jQuery if needed and
        // have a $ property so we can access the jQuery object that is used
        $ = require('datatables.net')(root, $).$;
      }

      return factory($, root, root.document);
    };
  } else {
    // Browser
    factory(jQuery, window, document);
  }
}(function ($, window, document, undefined) {
  'use strict';
  var DataTable = $.fn.dataTable;

  /* Set the defaults for DataTables initialisation */
  $.extend(true, DataTable.defaults, {
    dom: "<'row'<'col-sm-6'l><'col-sm-6'f>>'"
      + "<'row'<'col-sm-12'tr>>"
      + "<'row'<'col-sm-5'i><'col-sm-7'p>>",
    renderer: 'bootstrap'
  });

  /* Default class modification */
  $.extend(DataTable.ext.classes, {
    sWrapper: "dataTables_wrapper form-inline dt-bootstrap",
    sFilterInput: "form-control input-sm d-inline-block",
    sLengthSelect: "form-control input-sm d-inline-block",
    sLength: "dataTables_length d-inline-block",
    sInfo: "dataTables_info d-inline-block",
    sProcessing: "dataTables_processing panel panel-default",
  });

  /* Bootstrap paging button renderer */
  DataTable.ext.renderer.pageButton.bootstrap = function (settings, host, idx, buttons, page, pages) {
    var api = new DataTable.Api(settings);
    var classes = settings.oClasses;
    var lang = settings.oLanguage.oPaginate;
    var aria = settings.oLanguage.oAria.paginate || {};
    var btnDisplay,
      btnClass,
      counter = 0;

    var attach = function (container, buttons) {
      var i,
        ien,
        node,
        button;
      var clickHandler = function (e) {
        e.preventDefault();
        if (!$(e.currentTarget).hasClass('disabled') && api.page() != e.data.action) {
          api
            .page(e.data.action)
            .draw('page');
        }
      };

      for (i = 0, ien = buttons.length; i < ien; i++) {
        button = buttons[i];

        if ($.isArray(button)) {
          attach(container, button);
        } else {
          btnDisplay = '';
          btnClass = '';

          switch (button) {
            case 'ellipsis':
              btnDisplay = '&#x2026;';
              btnClass = 'disabled';
              break;

            case 'first':
              btnDisplay = "«";
              btnClass = button + (page > 0
                ? ''
                : ' disabled');
              break;

            case 'previous':
              btnDisplay = "‹";
              btnClass = button + (page > 0
                ? ''
                : ' disabled');
              break;

            case 'next':
              btnDisplay = "›";
              btnClass = button + (page < pages - 1
                ? ''
                : ' disabled');
              break;

            case 'last':
              btnDisplay = "»";
              btnClass = button + (page < pages - 1
                ? ''
                : ' disabled');
              break;

            default:
              btnDisplay = button + 1;
              btnClass = page === button
                ? 'active'
                : '';
              break;
          }

          if (btnDisplay) {
            node = $('<li>', {
              'class': classes.sPageButton + ' ' + btnClass,
              'id': idx === 0 && typeof button === 'string'
                ? settings.sTableId + '_' + button
                : null
            }).append($('<a>', {
              'href': '#',
              'aria-controls': settings.sTableId,
              'aria-label': aria[button],
              'data-dt-idx': counter,
              'tabindex': settings.iTabIndex
            }).html(btnDisplay)).appendTo(container);

            settings
              .oApi
              ._fnBindAction(node, {
                action: button
              }, clickHandler);

            counter++;
          }
        }
      }
    };

    // IE9 throws an 'unknown error' if document.activeElement is used inside an
    // iframe or frame.
    var activeEl;

    try {
      // Because this approach is destroying and recreating the paging elements, focus
      // is lost on the select button which is bad for accessibility. So we want to
      // restore focus once the draw has completed
      activeEl = $(host)
        .find(document.activeElement)
        .data('dt-idx');
    } catch (e) {}

    attach($(host).empty().html('<ul class="pagination pagination-sm"/>').children('ul'), buttons);

    if (activeEl !== undefined) {
      $(host)
        .find('[data-dt-idx=' + activeEl + ']')
        .focus();
    }
  };

  /**
   * _fnFeatureHtmlCustomDom (using 'C')
   */
  DataTable.ext.feature.push({
    cFeature: 'C',
    fnInit: function _fnFeatureHtmlCustomDom(settings) {
      return settings.oInit.customDom(settings)
    }
  })

  return DataTable;
}));
