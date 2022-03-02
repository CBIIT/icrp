<?php

namespace Drupal\icrp;

use Drupal\Core\DependencyInjection\ContainerBuilder;
use Drupal\Core\DependencyInjection\ServiceModifierInterface;
use Symfony\Component\DependencyInjection\Definition;
use Symfony\Component\DependencyInjection\Reference;

class IcrpServiceProvider implements ServiceModifierInterface {

  /**
   * Modifies existing service definitions.
   *
   * @param ContainerBuilder $container
   *   The ContainerBuilder whose service definitions can be altered.
   */
  public function alter(ContainerBuilder $container) {

    for ($id = 'entity.autocomplete_matcher'; $container->hasAlias($id); $id = (string) $container->getAlias($id));
    $definition = $container->getDefinition($id);
    $definition->setClass('Drupal\icrp\Entity\EntityAutocompleteMatcherCustom');
    $container->setDefinition($id, $definition);
  }

}