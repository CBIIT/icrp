<?php

namespace Drupal\snippet_manager\EventSubscriber;

use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\Core\Routing\RouteSubscriberBase;
use Drupal\snippet_manager\SnippetInterface;
use Symfony\Component\Routing\Route;
use Symfony\Component\Routing\RouteCollection;

/**
 * Route subscriber.
 */
class RouteSubscriber extends RouteSubscriberBase {

  /**
   * The entity type manager.
   *
   * @var \Drupal\Core\Entity\EntityTypeManagerInterface
   */
  protected $entityTypeManager;

  /**
   * Constructs a new SnippetManagerRouteSubscriber.
   *
   * @param \Drupal\Core\Entity\EntityTypeManagerInterface $entity_type_manager
   *   The entity type manager.
   */
  public function __construct(EntityTypeManagerInterface $entity_type_manager) {
    $this->entityTypeManager = $entity_type_manager;
  }

  /**
   * {@inheritdoc}
   */
  protected function alterRoutes(RouteCollection $collection) {
    $snippets = $this->entityTypeManager->getStorage('snippet')->loadByProperties([
      'status' => TRUE,
      'page.status' => TRUE,
    ]);
    foreach ($snippets as $snippet) {
      $collection->add('entity.snippet.page.' . $snippet->id(), $this->buildRoute($snippet));
    }
  }

  /**
   * Builds page route for a given snippet.
   *
   * @param \Drupal\snippet_manager\SnippetInterface $snippet
   *   The snippet.
   *
   * @return \Symfony\Component\Routing\Route
   *   The route.
   */
  protected function buildRoute(SnippetInterface $snippet) {

    $page = $snippet->get('page');

    $defaults = [
      '_entity_view' => 'snippet.page',
      '_title' => $page['title'] ?: $snippet->label(),
      'snippet' => $snippet->id(),
    ];

    $requirements['_entity_access'] = 'snippet.view-published';

    $options['parameters']['snippet']['type'] = 'entity:snippet';

    $bits = explode('/', $page['path']);

    $entity_type_definitions = $this->entityTypeManager->getDefinitions();
    foreach ($bits as $position => $bit) {
      if ($bit == '%') {
        $bits[$position] = '{arg_' . $position . '}';
      }
      elseif (strpos($bit, '%') === 0) {
        $name = substr($bit, 1);
        $bits[$position] = '{' . $name . '}';
        // Tell parameter converter to turn the entity ID into entity object.
        if (isset($entity_type_definitions[$name])) {
          if ($entity_type_definitions[$name]->hasViewBuilderClass()) {
            $options['parameters'][$name]['type'] = 'entity:' . $name;
          }
        }
      }
    }

    $path = '/' . implode('/', $bits);

    return new Route($path, $defaults, $requirements, $options);
  }

}
