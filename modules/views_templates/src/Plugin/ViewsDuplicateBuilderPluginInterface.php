<?php
/**
 * @file
 * Contains \Drupal\views_templates\Plugin\ViewsDuplicateBuilderPluginInterface.
 */


namespace Drupal\views_templates\Plugin;

/**
 * Creates a common interface for Builders that use a View Template entity for
 * a starting point.
 *
 * This allows Views to be exported to CMI and then manually changed to Views
 * Templates by changing the
 */
interface ViewsDuplicateBuilderPluginInterface extends ViewsBuilderPluginInterface {

  /**
   * Return the View Template id to be used by this Plugin.
   *
   * @return string
   */
  public function getViewTemplateId();

}
