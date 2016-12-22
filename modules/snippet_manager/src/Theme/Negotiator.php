<?php

namespace Drupal\snippet_manager\Theme;

use Drupal\Core\Routing\RouteMatchInterface;
use Drupal\Core\Theme\ThemeNegotiatorInterface;

/**
 * A class which determines the active theme of the page.
 */
class Negotiator implements ThemeNegotiatorInterface {

  /**
   * {@inheritdoc}
   */
  public function applies(RouteMatchInterface $route_match) {
    return $route_match->getRouteName() == 'entity.snippet.canonical';
  }

  /**
   * {@inheritdoc}
   */
  public function determineActiveTheme(RouteMatchInterface $route_match) {
    $snippet = $route_match->getParameter('snippet');
    return $snippet->get('page')['theme'];
  }

}
