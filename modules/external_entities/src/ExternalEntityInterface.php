<?php

/**
 * @file
 * Contains \Drupal\external_entities\ExternalEntityInterface.
 */

namespace Drupal\external_entities;

use Drupal\Core\Entity\ContentEntityInterface;

/**
 * Provides an interface defining a node entity.
 */
interface ExternalEntityInterface extends ContentEntityInterface {

  /**
   * Gets the external entity type.
   *
   * @return string
   *   The external entity type.
   */
  public function getType();

  /**
   * Gets the external identifier.
   *
   * @return string|int|null
   *   The external entity identifier, or NULL if the object does not yet have
   *   an external identifier.
   */
  public function externalId();

  /**
   * Map this entity to a \stdClass object.
   *
   * @return \stdClass
   *   The mapped object.
   */
  public function getMappedObject();

  /**
   * Map a \stdClass object to this entity.
   *
   * @return $this
   */
  public function mapObject(\stdClass $object);

}
