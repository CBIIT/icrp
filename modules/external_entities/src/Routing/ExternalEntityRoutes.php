<?php
/**
 * @file
 * Contains \Drupal\external_entities\Routing\ExternalEntityRoutes.
 */

namespace Drupal\external_entities\Routing;
use Symfony\Component\Routing\Route;
use Symfony\Component\Routing\RouteCollection;
use Drupal\Core\Entity\EntityManagerInterface;

/**
 * Defines dynamic routes.
 */
class ExternalEntityRoutes {

  /**
   * The entity storage handler.
   *
   * @var \Drupal\Core\Entity\EntityStorageInterface
   */
  protected $entityStorage;

  /**
   * Creates an ExternalEntityRoutes object.
   *
   * @param \Drupal\Core\Entity\EntityManagerInterface $entity_manager
   *   The entity manager.
   */
  public function __construct(EntityManagerInterface $entity_manager) {
    $this->entityStorage = $entity_manager->getStorage('external_entity_type');
  }

  /**
   * {@inheritdoc}
   */
  public function routes() {
    $route_collection = new RouteCollection();
    $first = TRUE;
    foreach ($this->entityStorage->loadMultiple() as $type) {
      if ($first) {
        $first = FALSE;
        $route = new Route(
          '/external-entities',
          [
            '_controller' => '\Drupal\external_entities\Entity\Controller\ExternalEntityListController::listing',
            'entity_type' => 'external_entity',
            'bundle' => $type->id(),
            '_title' => $type->label() . ' external entities',
          ],
          [
            '_permission' => 'view external entity list page',
          ]
        );
        $route_collection->add('entity.external_entity.collection', $route);
      }
      $route = new Route(
        '/external-entities/' . $type->id(),
        [
          '_controller' => '\Drupal\external_entities\Entity\Controller\ExternalEntityListController::listing',
          'entity_type' => 'external_entity',
          'bundle' => $type->id(),
          '_title' => $type->label() . ' external entities',
        ],
        [
          '_permission' => 'view external entity list page',
        ]
      );
      $route_collection->add('entity.external_entity.' . $type->id(), $route);
    }
    return $route_collection;
  }
}
