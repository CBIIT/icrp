<?php

namespace Drupal\yamlform;

use Drupal\Component\Plugin\Discovery\CachedDiscoveryInterface;
use Drupal\Component\Plugin\PluginManagerInterface;
use Drupal\Component\Plugin\FallbackPluginManagerInterface;
use Drupal\Component\Plugin\CategorizingPluginManagerInterface;

/**
 * Collects available results exporters.
 */
interface YamlFormExporterManagerInterface extends PluginManagerInterface, CachedDiscoveryInterface, FallbackPluginManagerInterface, CategorizingPluginManagerInterface {

  /**
   * Get exporter plugins as options.
   *
   * @return array
   *   An associative array of options keyed by plugin id.
   */
  public function getOptions();

}
