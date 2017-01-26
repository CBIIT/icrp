<?php

/**
 * @file
 * Contains \Drupal\external_entities\Entity\ExternalEntityRouteProvider.
 */

namespace Drupal\external_entities\Entity;

use Drupal\Core\Entity\EntityTypeInterface;
use Drupal\Core\Entity\Routing\EntityRouteProviderInterface;
use Symfony\Component\Routing\Route;
use Symfony\Component\Routing\RouteCollection;

/**
 * Provides routes for nodes.
 */
class ExternalEntityRouteProvider implements EntityRouteProviderInterface {

  /**
   * {@inheritdoc}
   */
  public function getRoutes( EntityTypeInterface $entity_type) {
    $route_collection = new RouteCollection();
    $route = (new Route('/external-entity/{external_entity}'))
      ->addDefaults([
        '_entity_view' => 'external_entity.full',
        '_title' => 'View external entity',
      ])
      ->setRequirement('_entity_access', 'external_entity.view');
    $route_collection->add('entity.external_entity.canonical', $route);

    $route = (new Route('/external-entity/{external_entity}/delete'))
      ->addDefaults([
        '_entity_form' => 'external_entity.delete',
        '_title' => 'Delete',
      ])
      ->setRequirement('_entity_access', 'external_entity.delete')
      ->setOption('_external_entity_operation_route', TRUE);
    $route_collection->add('entity.external_entity.delete_form', $route);

    $route = (new Route('/external-entity/{external_entity}/edit'))
      ->setDefault('_entity_form', 'external_entity.edit')
      ->setRequirement('_entity_access', 'external_entity.update')
      ->setOption('_external_entity_operation_route', TRUE);
    $route_collection->add('entity.external_entity.edit_form', $route);

    return $route_collection;
  }

}
