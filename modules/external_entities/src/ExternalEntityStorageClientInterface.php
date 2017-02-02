<?php

/**
 * @file
 * Contains Drupal\external_entities\ExternalEntityStorageClientInterface.
 */

namespace Drupal\external_entities;

use Drupal\Component\Plugin\PluginInspectionInterface;
use Drupal\external_entities\ExternalEntityInterface;

/**
 * Defines an interface for external entity storage client plugins.
 */
interface ExternalEntityStorageClientInterface extends PluginInspectionInterface {
  /**
   * Return the name of the external entity storage client.
   *
   * @return string
   *   The name of the external entity storage client.
   */
  public function getName();

  /**
   * Loads one entity.
   *
   * @param mixed $id
   *   The ID of the entity to load.
   *
   * @return \Drupal\external_entities\ExternalEntityInterface|null
   *   An external entity object. NULL if no matching entity is found.
   */
  public function load($id);

  /**
   * Saves the entity permanently.
   *
   * @param \Drupal\external_entities\ExternalEntityInterface $entity
   *   The entity to save.
   *
   * @return int
   *   SAVED_NEW or SAVED_UPDATED is returned depending on the operation
   *   performed.
   */
  public function save(ExternalEntityInterface $entity);

  /**
   * Deletes permanently saved entities.
   *
   * @param \Drupal\external_entities\ExternalEntityInterface $entity
   *   The external entity object to delete.
   */
  public function delete(ExternalEntityInterface $entity);

  /**
   * Query the external entities.
   *
   * @param array $parameters
   *   Key-value pairs of fields to query.
   */
  public function query(array $parameters);

  /**
   * Get HTTP headers to add.
   *
   * @return array
   *   Associative array of headers to add to the request.
   */
  public function getHttpHeaders();

}
