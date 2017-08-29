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

    /* @var \Drupal\snippet_manager\SnippetInterface[] $snippets */
    $snippets = $this->entityTypeManager->getStorage('snippet')->loadByProperties([
      'status' => TRUE,
      'page.status' => TRUE,
    ]);

    $path_index = [];
    $snippet_routes = [];
    foreach ($snippets as $snippet) {
      $route = $this->buildRoute($snippet);
      $snippet_routes[$snippet->id()] = $route;
      $path_index[$snippet->id()] = $route->getPath();
    }

    // First update existing routes.
    foreach ($collection->all() as $route_name => $route) {
      if ($snippet_id = array_search($route->getPath(), $path_index)) {
        $collection->remove($route_name);

        if (!$snippets[$snippet_id]->get('page')['title']) {
          // Try to preserve title of original route.
          if ($title_callback = $route->getDefault('_title_callback')) {
            $snippet_routes[$snippet_id]->setDefault('_title_callback', $title_callback);
          }
          if ($title = $route->getDefault('_title')) {
            $snippet_routes[$snippet_id]->setDefault('_title', $title);
          }
          if ($title_context = $route->getDefault('_title_context')) {
            $snippet_routes[$snippet_id]->setDefault('_title_context', $title_context);
          }
          if ($title_arguments = $route->getDefault('_title_arguments')) {
            $snippet_routes[$snippet_id]->setDefault('_title_arguments', $title_arguments);
          }
        }

        $collection->add($route_name, $snippet_routes[$snippet_id]);
        unset($snippet_routes[$snippet_id]);
      }
    }

    // Create new routes.
    foreach ($snippet_routes as $snippet_id => $route) {
      $collection->add('entity.snippet.page.' . $snippet_id, $route);
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
    $options['snippet_page'] = TRUE;

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
