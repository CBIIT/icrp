<?php

namespace Drupal\layout_plugin_views;


use Drupal\layout_plugin\Plugin\Layout\LayoutPluginManagerInterface;
use Drupal\layout_plugin_views\Plugin\views\row\Fields;

class FieldsPluginOptions {

  /**
   * @var \Drupal\layout_plugin_views\Plugin\views\row\Fields
   */
  private $plugin;
  /**
   * @var \Drupal\layout_plugin\Plugin\Layout\LayoutPluginManagerInterface
   */
  private $layoutPluginManager;

  public static function fromFieldsPlugin(LayoutPluginManagerInterface $layoutPluginManager, Fields $plugin) {
    return new static($layoutPluginManager, $plugin);
  }

  private function __construct(LayoutPluginManagerInterface $layoutPluginManager, Fields $plugin) {
    $this->plugin = $plugin;
    $this->layoutPluginManager = $layoutPluginManager;
  }

  /**
   * Retrieves the machine name of the selected layout.
   *
   * @return string
   */
  public function getLayout() {
    return $this->plugin->options['layout'];
  }

  /**
   * Retrieves the machine name of the region set to be the default region.
   *
   * @return string
   */
  public function getDefaultRegion() {
    return $this->plugin->options['default_region'];
  }

  /**
   * Retrieves the region machine name that was assigned to the given field.
   *
   * @param string $field_machine_name
   *
   * @return string
   *  The machine name of the region that the given field is assigned to or an
   *  empty string if the field is not assigned to a region.
   */
  public function getAssignedRegion($field_machine_name) {
    if (isset($this->plugin->options['assigned_regions'][$field_machine_name])) {
      return $this->plugin->options['assigned_regions'][$field_machine_name];
    }
    else {
      return '';
    }
  }

  /**
   * @return bool
   */
  public function hasValidSelectedLayout() {
    return $this->layoutPluginManager->hasDefinition($this->getLayout());
  }

  /**
   * Retrieves the definition of the selected layout.
   *
   * @return array
   */
  public function getSelectedLayoutDefinition() {
    return $this->hasValidSelectedLayout() ? $this->layoutPluginManager->getDefinition($this->getLayout()) : [];
  }

  /**
   * @return bool
   */
  public function layoutFallbackIsPossible() {
    return count($this->layoutPluginManager->getDefinitions()) > 0;
  }

  /**
   * @return array
   */
  public function getFallbackLayoutDefinition() {
    $definitions = $this->layoutPluginManager->getDefinitions();
    return array_shift($definitions);
  }
}
