<?php

namespace Drupal\layout_plugin_views;

use Drupal\layout_plugin_views\Plugin\views\row\Fields;

class RegionMap {

  /**
   * @var \Drupal\layout_plugin_views\Plugin\views\row\Fields
   */
  private $plugin;

  /**
   * @var array
   */
  private $map;

  /**
   * @var \Drupal\layout_plugin_views\FieldsPluginOptions
   */
  private $pluginOptions;

  public function __construct(Fields $plugin, FieldsPluginOptions $plugin_options) {
    $this->plugin = $plugin;
    $this->pluginOptions = $plugin_options;
    $this->generateRegionMap();
  }

  /**
   * Generates the region map.
   */
  public function generateRegionMap() {
    $this->map = [];
    foreach ($this->plugin->view->field as $field_name => $field_definition) {
      $region_machine_name = $this->fieldHasValidAssignment($field_name) ? $this->pluginOptions->getAssignedRegion($field_name) : $this->pluginOptions->getDefaultRegion();
      $this->map[$region_machine_name][$field_name] = $field_definition;
    }
  }

  /**
   * Determines if the given field is assigned to an existing region.
   *
   * @param string $field_name
   *
   * @return bool
   */
  private function fieldHasValidAssignment($field_name) {
    return $this->selectedLayoutHasRegion($this->pluginOptions->getAssignedRegion($field_name));
  }

  /**
   * Determines if the given machine name is a region in the selected layout.
   *
   * @param string $region_name
   *
   * @return bool
   */
  private function selectedLayoutHasRegion($region_name) {
    return in_array($region_name, $this->getRegionNamesForSelectedLayout());
  }

  /**
   * Gets the machine names of all regions in the selected layout.
   *
   * @return string[]
   */
  private function getRegionNamesForSelectedLayout() {
    $definition = $this->pluginOptions->getSelectedLayoutDefinition();
    $available_regions = array_keys($definition['region_names']);
    return $available_regions;
  }

  /**
   * Retrieves an array of region machine names for all regions that contain
   * fields to be rendered.
   *
   * @return array
   */
  public function getNonEmptyRegionNames() {
    $non_empty = [];

    foreach ($this->map as $region => $fields) {
      if (!empty($fields)) {
        $non_empty[] = $region;
      }
    }

    return $non_empty;
  }

  /**
   * Returns the fields to be rendered for the given region.
   *
   * @param string $region_name
   *
   * @return \Drupal\views\Plugin\views\field\FieldPluginBase[]
   */
  public function getFieldsForRegion($region_name) {
    return !empty($this->map[$region_name]) ? $this->map[$region_name] : [];
  }
}
