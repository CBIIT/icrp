<?php

namespace Drupal\snippet_manager\Plugin\Block;

use Drupal\Component\Plugin\Derivative\DeriverBase;
use Drupal\Core\Entity\EntityStorageInterface;
use Drupal\Core\Plugin\Discovery\ContainerDeriverInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Retrieves block plugin definitions for all snippet blocks.
 */
class SnippetBlockDeriver extends DeriverBase implements ContainerDeriverInterface {

  /**
   * The snippet storage.
   *
   * @var \Drupal\Core\Entity\EntityStorageInterface
   */
  protected $snippetStorage;

  /**
   * Constructs a Snippet object.
   *
   * @param \Drupal\Core\Entity\EntityStorageInterface $snippet_storage
   *   The snippet storage.
   */
  public function __construct(EntityStorageInterface $snippet_storage) {
    $this->snippetStorage = $snippet_storage;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container, $base_plugin_id) {
    $entity_manager = $container->get('entity.manager');
    return new static(
      $entity_manager->getStorage('snippet')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function getDerivativeDefinitions($base_plugin_definition) {
    $snippets = $this->snippetStorage->loadMultiple();

    /** @var \Drupal\snippet_manager\Entity\Snippet $snippet */
    foreach ($snippets as $snippet) {
      if ($snippet->status() && $snippet->get('block')['status']) {
        $delta = $snippet->id();
        $this->derivatives[$delta] = $base_plugin_definition;
        $this->derivatives[$delta]['admin_label'] = $snippet->get('block')['name'] ?: $snippet->label();
      }
    }
    return parent::getDerivativeDefinitions($base_plugin_definition);
  }

}
