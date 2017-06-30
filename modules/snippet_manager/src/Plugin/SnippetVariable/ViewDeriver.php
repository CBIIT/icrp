<?php

namespace Drupal\snippet_manager\Plugin\SnippetVariable;

use Drupal\Component\Plugin\Derivative\DeriverBase;
use Drupal\Core\Plugin\Discovery\ContainerDeriverInterface;
use Drupal\views\Views;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Retrieves snippet variable plugin definitions for all views.
 */
class ViewDeriver extends DeriverBase implements ContainerDeriverInterface {

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container, $base_plugin_id) {
    return new static();
  }

  /**
   * {@inheritdoc}
   */
  public function getDerivativeDefinitions($base_plugin_definition) {

    // Views module is optional.
    if (class_exists('Drupal\views\Views')) {
      foreach (Views::getAllViews() as $view_id => $view) {
        if ($view->status()) {
          $this->derivatives[$view_id] = $base_plugin_definition;
          $this->derivatives[$view_id]['title'] = $view->label();
        }
      }
    }

    return $this->derivatives;
  }

}
