<?php

use Drupal\Component\Utility\Html;

/**
 * @file
 * Preprocessors for DataTable theming.
 */

/**
 * Prepares variables for DataTable templates.
 *
 * Default template: datatable.html.twig.
 *
 * This function takes the same parameters as theme_table, but also allows the
 * inclusion of DataTable specific information in the $header and $attributes
 * parameters in order to configure a DataTable.  If an id is not set in the
 * $attributes paramater, a unique one is generated.
 *
 * To set features and options for the DataTable, add
 * $variables['attributes']['datatable_options'] as an associative array.
 * For example:
 * @code
 *   $variables['attributes']['datatables_options'] = array(
 *     'bFilter'   => FALSE,  // Disable filtering of data.
 *     'bInfo'     => TRUE,   // Show the table information display.
 *     'aaSorting' => array(  // Sort by 3rd column first, and then 4th column.
 *        array(2, 'asc'),
 *        array(3, 'desc'),
 *      ),
 *   );
 * @endcode
 * See http://datatables.net/usage/features and
 * http://datatables.net/usage/options for a full list of features and options.
 *
 * To enable column specific options, set the datatable_options for each of the
 * columns in the $header parameter.
 * For example:
 * @code
 *   $header = array(
 *     array(
 *       'data' => t('Column 1'),
 *       'datatable_options' => array(
 *         'bSortable' => TRUE,  // Enable sorting on this column.
 *       ),
 *     ),
 *     array(
 *       'data' => t('Column 2'),
 *       'datatable_options' => array(
 *         'bSearchable' => FALSE, // Disable filtering on this column.
 *       ),
 *     ),
 *   );
 * @endcode
 * Note: if the aaColumns option is enabled in $parameters['datatable_options'],
 * then all datatable_options in the $header parameter will be ignored, since
 * the parameters will override column options.  See
 * http://datatables.net/usage/columns for a full list of column options.
 *
 * @param array $variables
 *   An associative array containing:
 *   - header: An array containing the table headers. Each element of the array
 *     can be either a localized string or an associative array with the
 *     following keys:
 *     - data: The localized title of the table column, as a string or render
 *       array.
 *     - field: The database field represented in the table column (required
 *       if user is to be able to sort on this column).
 *     - sort: A default sort order for this column ("asc" or "desc"). Only
 *       one column should be given a default sort order because table sorting
 *       only applies to one column at a time.
 *     - class: An array of values for the 'class' attribute. In particular,
 *       the least important columns that can be hidden on narrow and medium
 *       width screens should have a 'priority-low' class, referenced with the
 *       RESPONSIVE_PRIORITY_LOW constant. Columns that should be shown on
 *       medium+ wide screens should be marked up with a class of
 *       'priority-medium', referenced by with the RESPONSIVE_PRIORITY_MEDIUM
 *       constant. Themes may hide columns with one of these two classes on
 *       narrow viewports to save horizontal space.
 *     - Any HTML attributes, such as "colspan", to apply to the column header
 *       cell.
 *   - rows: An array of table rows. Every row is an array of cells, or an
 *     associative array with the following keys:
 *     - data: An array of cells.
 *     - Any HTML attributes, such as "class", to apply to the table row.
 *     - no_striping: A Boolean indicating that the row should receive no
 *       'even / odd' styling. Defaults to FALSE.
 *     Each cell can be either a string or an associative array with the
 *     following keys:
 *     - data: The string or render array to display in the table cell.
 *     - header: Indicates this cell is a header.
 *     - Any HTML attributes, such as "colspan", to apply to the table cell.
 *     Here's an example for $rows:
 * @code
 *     $rows = array(
 *       // Simple row
 *       array(
 *         'Cell 1', 'Cell 2', 'Cell 3'
 *       ),
 *       // Row with attributes on the row and some of its cells.
 *       array(
 *         'data' => array('Cell 1', array('data' => 'Cell 2', 'colspan' => 2)), 'class' => array('funky')
 *       ),
 *     );
 * @endcode
 *   - footer: An array of table rows which will be printed within a <tfoot>
 *     tag, in the same format as the rows element (see above).
 *   - attributes: An array of HTML attributes to apply to the table tag.
 *   - caption: A localized string to use for the <caption> tag.
 *   - colgroups: An array of column groups. Each element of the array can be
 *     either:
 *     - An array of columns, each of which is an associative array of HTML
 *       attributes applied to the COL element.
 *     - An array of attributes applied to the COLGROUP element, which must
 *       include a "data" attribute. To add attributes to COL elements, set the
 *       "data" attribute with an array of columns, each of which is an
 *       associative array of HTML attributes.
 *     Here's an example for $colgroup:
 * @code
 *     $colgroup = array(
 *       // COLGROUP with one COL element.
 *       array(
 *         array(
 *           'class' => array('funky'), // Attribute for the COL element.
 *         ),
 *       ),
 *       // Colgroup with attributes and inner COL elements.
 *       array(
 *         'data' => array(
 *           array(
 *             'class' => array('funky'), // Attribute for the COL element.
 *           ),
 *         ),
 *         'class' => array('jazzy'), // Attribute for the COLGROUP element.
 *       ),
 *     );
 * @endcode
 *     These optional tags are used to group and set properties on columns
 *     within a table. For example, one may easily group three columns and
 *     apply same background style to all.
 *   - sticky: Use a "sticky" table header.
 *   - empty: The message to display in an extra row if table does not have any
 *     rows.
 *
 * @see template_preprocess_table()
 */
function template_preprocess_datatable(&$variables) {
  $header = &$variables['header'];
  $attributes = &$variables['attributes'];

  if (isset($variables['rows'])) {
    $datatable_options = !empty($attributes['datatable_options']) ? $attributes['datatable_options'] : [];

    // Column settings can either be set with the global options
    // or in each header definition.
    if (!isset($datatable_options['aoColumns'])) {
      foreach ($header as $key => $cell) {
        if (isset($cell['datatable_options'])) {
          $datatable_options['aoColumns'][] = $cell['datatable_options'];
          if (is_array($header[$key])) {
            unset($header[$key]['datatable_options']);
          }
        }
      }
    }

    // Generate unique id.
    if (empty($variables['attributes']['id'])) {
      $variables['attributes']['id'] = Html::getUniqueId('datatable');
    }

    $variables['#attached']['library'][] = 'datatables/datatables';
    $variables['#attached']['library'][] = 'datatables/datatables_core';
    $variables['#attached']['drupalSettings']['datatables']['#' . $variables['attributes']['id']] = $datatable_options;

    unset($attributes['datatable_options']);
  }

  template_preprocess_table($variables);
}