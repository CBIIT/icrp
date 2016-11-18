<?php
/**
 * @file
 * Preprocessors and helper functions to make theming easier.
 */

use Drupal\Component\Utility\Html;

/**
 * Prepares variables for views carousel template.
 *
 * Default template: views-bootstrap-carousel.html.twig.
 *
 * @param array $vars
 *   An associative array containing:
 *   - view: A ViewExecutable object.
 *   - rows: The raw row data.
 */
function template_preprocess_views_bootstrap_carousel(&$vars) {
  $id = $vars['view']->element['#name'] . '-' . $vars['view']->element['#display_id'];
  $vars['id'] = Html::getUniqueId('views-bootstrap-carousel-' . $id);

  // Carousel options.
  $vars['interval'] = $vars['view']->style_plugin->options['interval'];
  $vars['navigation'] = $vars['view']->style_plugin->options['navigation'];
  $vars['indicators'] = $vars['view']->style_plugin->options['indicators'];
  $vars['pause'] = $vars['view']->style_plugin->options['pause'] ? 'hover' : FALSE;
  $vars['wrap'] = $vars['view']->style_plugin->options['wrap'];

  // Carousel rows.
  $image = $vars['view']->style_plugin->options['image'];
  $title = $vars['view']->style_plugin->options['title'];
  $description = $vars['view']->style_plugin->options['description'];

  foreach ($vars['rows'] as $id => $row) {
    $vars['rows'][$id] = array();
    $vars['rows'][$id]['image'] = $vars['view']->style_plugin->getField($id, $image);
    $vars['rows'][$id]['title'] = $vars['view']->style_plugin->getField($id, $title);
    $vars['rows'][$id]['description'] = $vars['view']->style_plugin->getField($id, $description);
  }
}
