<?php

/**
 * @file
 * Contains \Drupal\external_entities\Plugin\Derivative\ExternalEntitiesMenuLinks.
 */

namespace Drupal\external_entities\Plugin\Derivative;

use Drupal\Component\Plugin\Derivative\DeriverBase;
use Drupal\Core\Plugin\Discovery\ContainerDeriverInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Drupal\Core\Entity\EntityStorageInterface;

/**
 * Provides dynamic local tasks for external entities.
 */
class ExternalEntitiesMenuLinks extends DeriverBase implements ContainerDeriverInterface {

  /**
   * The base plugin ID.
   *
   * @var string
   */
  protected $basePluginId;

  /**
   * The storage handler.
   *
   * @var \Drupal\Core\Entity\EntityStorageInterface.
   */
  protected $storage;

  /**
   * Constructs a new ConfigTranslationMenuLinks.
   *
   * @param string $base_plugin_id
   *   The base plugin ID.
   * @param \Drupal\Core\Entity\EntityStorageInterface $storage
   *   The storage handler.
   */
  public function __construct($base_plugin_id, EntityStorageInterface $storage) {
    $this->basePluginId = $base_plugin_id;
    $this->storage = $storage;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container, $base_plugin_id) {
    return new static(
      $base_plugin_id,
      $container->get('entity.manager')->getStorage('external_entity_type')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function getDerivativeDefinitions($base_plugin_definition) {
    $parent = FALSE;
    foreach ($this->storage->loadMultiple() as $type) {
      $route_name = 'entity.external_entity.' . $type->id();
      $this->derivatives[$route_name] = $base_plugin_definition;
      $this->derivatives[$route_name]['title'] = $type->label() . ' external entities overview';
      $this->derivatives[$route_name]['description'] = $type->label() . ' external entities overview';
      $this->derivatives[$route_name]['route_name'] = $route_name;
      $this->derivatives[$route_name]['parent'] = $parent ? $parent : '<front>';
      if (!$parent) {
        $parent = $route_name;
      }
    }
    return parent::getDerivativeDefinitions($base_plugin_definition);
  }

}
