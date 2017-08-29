<?php

namespace Drupal\snippet_manager;

use Drupal\Core\Cache\CacheBackendInterface;
use Drupal\Core\Extension\ModuleHandlerInterface;
use Drupal\Core\Plugin\DefaultPluginManager;

/**
 * Snippet variable plugin manager.
 */
class SnippetVariablePluginManager extends DefaultPluginManager {

  /**
   * Constructs a SnippetVariablePluginManager object.
   *
   * @param \Traversable $namespaces
   *   An object that implements \Traversable which contains the root paths
   *   keyed by the corresponding namespace to look for plugin implementations.
   * @param \Drupal\Core\Cache\CacheBackendInterface $cache_backend
   *   Cache backend instance to use.
   * @param \Drupal\Core\Extension\ModuleHandlerInterface $module_handler
   *   The module handler to invoke the alter hook with.
   */
  public function __construct(\Traversable $namespaces, CacheBackendInterface $cache_backend, ModuleHandlerInterface $module_handler) {
    parent::__construct(
      'Plugin/SnippetVariable',
      $namespaces,
      $module_handler,
      'Drupal\snippet_manager\SnippetVariableInterface',
      'Drupal\snippet_manager\Annotation\SnippetVariable'
    );
    $this->alterInfo('snippet_variable_info');
  }

}
