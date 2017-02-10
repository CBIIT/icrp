<?php

namespace Drupal\clientside_validation\Annotation;

use Drupal\Component\Annotation\Plugin;

/**
 * Defines a clientside validation validator.
 *
 * Plugin Namespace: Plugin\clientside_validation\CvValidator
 *
 * @see \Drupal\clientside_validation\ValidatorManager
 * @see plugin_api
 *
 * @Annotation
 */
class CvValidator extends Plugin {

  /**
   * The plugin ID.
   *
   * @var string
   */
  public $id;

  /**
   * The name of the validator.
   *
   * @var \Drupal\Core\Annotation\Translation
   *
   * @ingroup plugin_translatable
   */
  public $name;

  /**
   * An array with keys 'types' and 'attributes'.
   *
   * Each value is an array of types and attributes (respectively) this plugin
   * supports.
   *
   * @var array
   */
  public $supports = [
    'types' => [],
    'attributes' => [],
  ];

  /**
   * An array of assets that can be #attached to a form element.
   */
  public $attachments = [];

}
