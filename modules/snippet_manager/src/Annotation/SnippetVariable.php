<?php

namespace Drupal\snippet_manager\Annotation;

use Drupal\Component\Annotation\Plugin;

/**
 * Defines a snippet variable annotation object.
 *
 * @Annotation
 */
class SnippetVariable extends Plugin {

  /**
   * The plugin ID.
   *
   * @var string
   */
  public $id;

  /**
   * The human-readable name of the plugin.
   *
   * @var \Drupal\Core\Annotation\Translation
   *
   * @ingroup plugin_translatable
   */
  public $title;

  /**
   * The category of the plugin.
   *
   * @var \Drupal\Core\Annotation\Translation
   *
   * @ingroup plugin_translatable
   */
  public $category;

}
