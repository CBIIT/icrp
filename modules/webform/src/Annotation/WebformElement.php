<?php

namespace Drupal\webform\Annotation;

use Drupal\Component\Annotation\Plugin;

/**
 * Defines a webform element annotation object.
 *
 * Plugin Namespace: Plugin\WebformElement.
 *
 * For a working example, see
 * \Drupal\webform\Plugin\WebformElement\Email
 *
 * @see hook_webform_element_info_alter()
 * @see \Drupal\webform\WebformElementInterface
 * @see \Drupal\webform\WebformElementBase
 * @see \Drupal\webform\WebformElementManager
 * @see \Drupal\webform\WebformElementManagerInterface
 * @see plugin_api
 *
 * @Annotation
 */
class WebformElement extends Plugin {

  /**
   * The plugin ID.
   *
   * @var string
   */
  public $id;

  /**
   * URL to the element's API documentation.
   *
   * @var string
   */
  public $api;

  /**
   * The human-readable name of the webform element.
   *
   * @var \Drupal\Core\Annotation\Translation
   *
   * @ingroup plugin_translatable
   */
  public $label;

  /**
   * The category in the admin UI where the webform will be listed.
   *
   * @var \Drupal\Core\Annotation\Translation
   *
   * @ingroup plugin_translatable
   */
  public $category = '';

  /**
   * Flag that defines hidden element.
   *
   * @var bool
   */
  public $hidden = FALSE;

  /**
   * Flag that defines multiline element.
   *
   * @var bool
   */
  public $multiline = FALSE;

  /**
   * Flag that defines multiple (value) element.
   *
   * @var bool
   */
  public $multiple = FALSE;

  /**
   * Flag that defines composite element.
   *
   * @var bool
   */
  public $composite = FALSE;

  /**
   * Flag that defines if #states wrapper should applied be to the element.
   *
   * @var bool
   */
  public $states_wrapper = FALSE;

}
