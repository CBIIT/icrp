/**
 * @file
 * Snippet filter.
 */

(function ($, Drupal) {

  'use strict';

  /**
   * Filters the snippets list by a text input search string.
   */
  Drupal.behaviors.snippetsFilterByName = {
    attach: function () {

      var $input = $('[data-drupal-selector="sm-snippet-filter"]');
      var $table = $('[data-drupal-selector="sm-snippet-list"]');
      var $rows = $table.find('tbody tr');

      $table.find('tbody').append('<tr class="empty-row"/>');
      var $emptyRow = $('.empty-row');
      $emptyRow
        .hide()
        .append('<td colspan="' + $table.find('th').length + '">' + Drupal.t('No snippets were found.') + '</td>');

      function filterSnippetList(event) {
        var query = $(event.target).val();
        var regExp = new RegExp(query, 'i');

        if (query.length >= 0) {
          $rows.each(function (index, row) {
            var $row = $(row);
            var name = $row.find('td:eq(0)').text();
            var id = $row.find('td:eq(1)').text();
            $row.toggle(name.search(regExp) !== -1 || id.search(regExp) !== -1);
          });
        }

        $emptyRow.toggle($rows.filter(':visible').length === 0);
      }

      $input.on({keyup: Drupal.debounce(filterSnippetList, 100)});
    }
  };

} (jQuery, Drupal));
