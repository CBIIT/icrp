<?php

/**
 * @file
 * Contains \Drupal\external_entities\Annotation\ExternalEntityStorageClient.
 */

namespace Drupal\external_entities\Annotation;

use Drupal\Component\Annotation\Plugin;

/**
 * Defines an external entity storage client annotation object
 *
 * @see \Drupal\external_entities\ExternalEntityStorageClientManager
 * @see plugin_api
 *
 * @Annotation
 */
class ExternalEntityStorageClient extends Plugin {
  /**
   * The plugin ID.
   *
   * @var string
   */
  public $id;

  /**
   * The name of the storage client.
   *
   * @var \Drupal\Core\Annotation\Translation
   *
   * @ingroup plugin_translatable
   */
  public $name;

}
