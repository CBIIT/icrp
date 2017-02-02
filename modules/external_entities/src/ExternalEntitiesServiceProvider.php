<?php

/**
 * @file
 * Contains Drupal\external_entities\ExternalEntitiesServiceProvider.
 */

namespace Drupal\external_entities;

use Drupal\Core\DependencyInjection\ContainerBuilder;
use Drupal\Core\DependencyInjection\ServiceProviderBase;

/**
 * Modifies the serialization services.
 */
class ExternalEntitiesServiceProvider extends ServiceProviderBase {

  /**
   * {@inheritdoc}
   */
  public function alter(ContainerBuilder $container) {
    $container->getDefinition('serialization.json')->addTag('external_entity_response_decoder');
    $container->getDefinition('serialization.phpserialize')->addTag('external_entity_response_decoder');
    $container->getDefinition('serialization.yaml')->addTag('external_entity_response_decoder');
  }
}
