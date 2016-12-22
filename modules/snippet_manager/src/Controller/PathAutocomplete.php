<?php

namespace Drupal\snippet_manager\Controller;

use Drupal\Core\DependencyInjection\ContainerInjectionInterface;
use Drupal\Core\Routing\RouteProviderInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;

/**
 * Returns autocomplete responses for quick page paths.
 */
class PathAutocomplete implements ContainerInjectionInterface {

  /**
   * The route provider.
   *
   * @var \Drupal\Core\Routing\RouteProviderInterface
   */
  protected $routeProvider;

  /**
   * Constructs the controller.
   *
   * @param \Drupal\Core\Routing\RouteProviderInterface $route_provider
   *   The route provider.
   */
  public function __construct(RouteProviderInterface $route_provider) {
    $this->routeProvider = $route_provider;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    return new static(
      $container->get('router.route_provider')
    );
  }

  /**
   * Retrieves suggestions for path autocompletion.
   *
   * @param \Symfony\Component\HttpFoundation\Request $request
   *   The current request.
   *
   * @return \Symfony\Component\HttpFoundation\JsonResponse
   *   A JSON response containing autocomplete suggestions.
   */
  public function autocomplete(Request $request) {

    $matches = [];
    $typed_path = $request->query->get('q');
    foreach ($this->routeProvider->getAllRoutes() as $route) {
      $path = $route->getPath();
      if (stripos($path, $typed_path) !== FALSE) {
        $matches[] = [
          'value' => $path,
          'label' => $path,
        ];
      }
    }

    return new JsonResponse($matches);
  }

}
