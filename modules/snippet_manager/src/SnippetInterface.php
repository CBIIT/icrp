<?php

namespace Drupal\snippet_manager;

use Drupal\Core\Config\Entity\ConfigEntityInterface;

/**
 * Provides an interface defining a snippet entity type.
 */
interface SnippetInterface extends ConfigEntityInterface {

  /**
   * Variable getter.
   */
  public function getVariable($key);

  /**
   * Variable setter.
   */
  public function setVariable($key, $variable);

  /**
   * Removes variable.
   */
  public function removeVariable($key);

  /**
   * Determines if the variable already exists.
   *
   * @param string $key
   *   The name of the variable.
   *
   * @return bool
   *   TRUE if the variable exists, FALSE otherwise.
   */
  public function variableExists($key);

}
