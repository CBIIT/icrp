(function (drupalSettings) {

  'use strict';

  Drupal.behaviors.ToolbarThemesGruniticonLoad = {
    attach: function () {
      var path = drupalSettings.toolbar.path;
      grunticon([
        path + "/themes/base/grunticons/processed/icons.data.svg.css",
        path + "/themes/base/grunticons/processed/icons.data.png.css",
        path + "/themes/base/grunticons/processed/icons.fallback.css"
        ],
        grunticon.svgLoadedCallback
      );
    }
  };

})(drupalSettings);
