<?php

namespace Drupal\snippet_manager;

use Drupal\Component\Plugin\PluginInspectionInterface;
use Drupal\Core\Plugin\PluginFormInterface;
use Drupal\Component\Plugin\ConfigurablePluginInterface;

/**
 * Interface definition for 'snippet_variable' plugins.
 */
interface SnippetVariableInterface extends PluginFormInterface, PluginInspectionInterface, ConfigurablePluginInterface {

  /**
   * Returns variable type.
   */
  public function getType();

  /**
   * Builds and returns variable content.
   */
  public function build();

  /**
   * Returns variable operations.
   *
   * @return array
   *   List of operation links.
   */
  public function getOperations();

}
