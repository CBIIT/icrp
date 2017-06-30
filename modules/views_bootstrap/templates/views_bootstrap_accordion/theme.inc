<?php
/**
 * @file
 * Preprocessors and helper functions to make theming easier.
 */
 
/**
 * Prepares variables for views accordion templates.
 *
 * Default template: views-bootstrap-accordion.html.twig.
 *
 * @param array $vars
 *   An associative array containing:
 *   - view: A ViewExecutable object.
 *   - rows: The raw row data.
 */
function template_preprocess_views_bootstrap_accordion(&$vars) {
  $title_field = $vars['view']->style_plugin->options['title_field'];
  
  $vars['attributes']['class'][] = 'panel-group';
  
  foreach ($vars['rows'] as $id => $row) {
    $vars['rows'][$id] = array();
    $vars['rows'][$id]['content'] = $row;
    $vars['rows'][$id]['title'] = $vars['view']->style_plugin->getField($id, $title_field);
  }
 
  //@TODO: Make sure that $vars['rows'] is rendered array.
  //@SEE: Have a look template_preprocess_views_view_unformatted() and views-view-unformatted.html.twig  
}
