(function ($, drupalSettings) {

  'use strict';

  Drupal.behaviors.ToolbarThemes = {
    attach: function () {

      // Remove titles, they obscure drop menu items.
      $('#toolbar-bar a').removeAttr('title');

      // Wrap menu link text.
      $('#toolbar-bar .toolbar-menu a').wrapInner('<span class="toolbar__link-label">');

      if (drupalSettings.toolbar.icons == 1) {
        // Remove toolbar tab-icon classes.
        $("#toolbar-bar .toolbar-tab a").removeClass(function (index, css) {
            return (css.match (/(^|\s)toolbar-ico\S+/g) || []).join(' ');
        });

        // Move icons into anchors so we can style active/hover states etc.
        if (drupalSettings.toolbar.tabs == 1) {
          $('#toolbar-bar .toolbar-tab__items-wrapper i.toolbar-icon').each(function () {
            var t = $(this).prev();
            $(this).prependTo(t);
          });
        }

        if ($('#toolbar-bar').hasClass('has-icons')) {
          $('#toolbar-bar .toolbar-tray-horizontal i.toolbar-icon').each(function() {
            var h = $(this).prev();
            $(this).prependTo(h);
          });

          $('#toolbar-bar .toolbar-tray-vertical i.toolbar-icon').each(function() {
            if ($(this).parents('.toolbar-tab').find('.trigger').hasClass('is-active')) {
              var v = $(this).siblings('.toolbar-box').find('a.toolbar-menu__link');
            } else {
              var v = $(this).prev();
            }
            $(this).prependTo(v);
          });
        }
      }
    }
  };

})(jQuery, drupalSettings);
