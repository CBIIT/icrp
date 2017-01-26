<?php

namespace Drupal\snippet_manager;

use Drupal\Core\Config\Entity\ConfigEntityInterface;

/**
 * Provides an interface defining a snippet entity type.
 */
interface SnippetInterface extends ConfigEntityInterface {

  /**
   * Code getter.
   */
  public function getCode();

  /**
   * Code setter.
   */
  public function setCode(array $code);

  /**
   * Variables getter.
   */
  public function getVariables();

  /**
   * Variables getter.
   */
  public function setVariables($variables);

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

  /**
   * Determines if the associated page is published.
   *
   * @return bool
   *   TRUE if associated page is published.
   */
  public function pageIsPublished();

}
