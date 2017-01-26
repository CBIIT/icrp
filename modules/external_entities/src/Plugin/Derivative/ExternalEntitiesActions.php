<?php

/**
 * @file
 * Contains \Drupal\external_entities\Plugin\Derivative\ExternalEntitiesActions.
 */

namespace Drupal\external_entities\Plugin\Derivative;

use Drupal\Component\Plugin\Derivative\DeriverBase;
use Drupal\Core\Plugin\Discovery\ContainerDeriverInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Drupal\Core\Entity\EntityStorageInterface;

/**
 * Provides dynamic local actions for external entities.
 */
class ExternalEntitiesActions extends DeriverBase implements ContainerDeriverInterface {

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
   * Constructs a new ConfigTranslationLocalTasks.
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
    $types = $this->storage->loadMultiple();
    if ($types) {
      $action_name = 'external_entities.add_page';
      $this->derivatives[$action_name] = $base_plugin_definition;
      $this->derivatives[$action_name]['title'] = 'Add external entity';
      $this->derivatives[$action_name]['route_name'] = 'external_entities.add_page';
      foreach ($types as $type) {
        $this->derivatives[$action_name]['appears_on'][] = 'entity.external_entity.' . $type->id();
      }
    }
    return parent::getDerivativeDefinitions($base_plugin_definition);
  }

}
