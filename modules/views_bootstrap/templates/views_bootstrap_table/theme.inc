<?php
/**
 * @file
 * Preprocessors and helper functions to make theming easier.
 */

/**
 * Prepares variables for views table templates.
 *
 * Default template: views-bootstrap-table.html.twig.
 *
 * @param array $vars
 *   An associative array containing:
 *   - view: A ViewExecutable object.
 *   - rows: The raw row data.
 */
function template_preprocess_views_bootstrap_table(&$vars) {
  $vars['responsive'] = $vars['view']->style_plugin->options['responsive'];

  $vars['attributes']['class'][] = 'table';

  foreach (array_filter($vars['view']->style_plugin->options['bootstrap_styles']) as $style) {
    $vars['attributes']['class'][] = 'table-' . $style;
  }
}
