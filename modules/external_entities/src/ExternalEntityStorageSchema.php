<?php

/**
 * @file
 * Contains \Drupal\external_entities\ExternalEntityStorageSchema.
 */

namespace Drupal\external_entities;

use Drupal\Core\Entity\Schema\DynamicallyFieldableEntityStorageSchemaInterface;
use Drupal\Core\Field\FieldStorageDefinitionInterface;

/**
 * Defines the node schema handler.
 */
class ExternalEntityStorageSchema implements DynamicallyFieldableEntityStorageSchemaInterface {
  /**
   * {@inheritdoc}
   */
  public function finalizePurge(FieldStorageDefinitionInterface $storage_definition) {
  }

  /**
   * {@inheritdoc}
   */
  public function onEntityTypeCreate(\Drupal\Core\Entity\EntityTypeInterface $entity_type) {
  }

  /**
   * {@inheritdoc}
   */
  public function onEntityTypeDelete(\Drupal\Core\Entity\EntityTypeInterface $entity_type) {
  }

  /**
   * {@inheritdoc}
   */
  public function onEntityTypeUpdate(\Drupal\Core\Entity\EntityTypeInterface $entity_type, \Drupal\Core\Entity\EntityTypeInterface $original) {
  }

  /**
   * {@inheritdoc}
   */
  public function onFieldStorageDefinitionCreate(FieldStorageDefinitionInterface $storage_definition) {
  }

  /**
   * {@inheritdoc}
   */
  public function onFieldStorageDefinitionDelete(FieldStorageDefinitionInterface $storage_definition) {
  }

  /**
   * {@inheritdoc}
   */
  public function onFieldStorageDefinitionUpdate(FieldStorageDefinitionInterface $storage_definition, FieldStorageDefinitionInterface $original) {
  }

  /**
   * {@inheritdoc}
   */
  public function requiresEntityDataMigration(\Drupal\Core\Entity\EntityTypeInterface $entity_type, \Drupal\Core\Entity\EntityTypeInterface $original) {
    return FALSE;
  }

  /**
   * {@inheritdoc}
   */
  public function requiresEntityStorageSchemaChanges(\Drupal\Core\Entity\EntityTypeInterface $entity_type, \Drupal\Core\Entity\EntityTypeInterface $original) {
    return FALSE;
  }

  /**
   * {@inheritdoc}
   */
  public function requiresFieldDataMigration(FieldStorageDefinitionInterface $storage_definition, FieldStorageDefinitionInterface $original) {
    return FALSE;
  }

  /**
   * {@inheritdoc}
   */
  public function requiresFieldStorageSchemaChanges(FieldStorageDefinitionInterface $storage_definition, FieldStorageDefinitionInterface $original) {
    return FALSE;
  }

}
