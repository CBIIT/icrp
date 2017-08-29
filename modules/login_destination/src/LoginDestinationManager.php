<?php

namespace Drupal\login_destination;

use Drupal\Component\Utility\Unicode;
use Drupal\Core\Config\ConfigFactoryInterface;
use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\Core\Path\AliasManagerInterface;
use Drupal\Core\Path\CurrentPathStack;
use Drupal\Core\Path\PathMatcherInterface;
use Drupal\Core\Routing\RedirectDestinationInterface;
use Drupal\Core\Session\AccountInterface;
use Drupal\Core\Url;
use Drupal\login_destination\Entity\LoginDestination;
use Symfony\Component\HttpFoundation\RequestStack;

/**
 * Defines a login destination manager service.
 */
class LoginDestinationManager implements LoginDestinationManagerInterface {

  /**
   * The entity type manager.
   *
   * @var \Drupal\Core\Entity\EntityTypeManagerInterface
   */
  protected $entityTypeManager;

  /**
   * The alias manager that caches alias lookups based on the request.
   *
   * @var \Drupal\Core\Path\AliasManagerInterface
   */
  protected $aliasManager;

  /**
   * The path matcher.
   *
   * @var \Drupal\Core\Path\PathMatcherInterface
   */
  protected $pathMatcher;

  /**
   * The current path.
   *
   * @var \Drupal\Core\Path\CurrentPathStack
   */
  protected $currentPath;

  /**
   * The redirect destination service.
   *
   * @var \Drupal\Core\Routing\RedirectDestinationInterface
   */
  protected $redirectDestination;

  /**
   * The configuration factory.
   *
   * @var \Drupal\Core\Config\ConfigFactoryInterface
   */
  protected $configFactory;

  /**
   * The request stack.
   *
   * @var \Symfony\Component\HttpFoundation\RequestStack
   */
  protected $requestStack;

  /**
   * Constructor.
   *
   * @param \Drupal\Core\Entity\EntityTypeManagerInterface $entity_type_manager
   *   The entity type manager.
   * @param \Drupal\Core\Path\AliasManagerInterface $alias_manager
   *   The alias manager.
   * @param \Drupal\Core\Path\PathMatcherInterface $path_matcher
   *   The path matcher.
   * @param \Drupal\Core\Path\CurrentPathStack $current_path
   *   The current path.
   * @param \Drupal\Core\Routing\RedirectDestinationInterface $redirect_destination
   *   The redirect destination service.
   * @param \Drupal\Core\Config\ConfigFactoryInterface $config_factory
   *   The configuration factory.
   * @param \Symfony\Component\HttpFoundation\RequestStack $request_stack
   *   The request stack.
   */
  public function __construct(EntityTypeManagerInterface $entity_type_manager, AliasManagerInterface $alias_manager, PathMatcherInterface $path_matcher, CurrentPathStack $current_path, RedirectDestinationInterface $redirect_destination, ConfigFactoryInterface $config_factory, RequestStack $request_stack) {
    $this->entityTypeManager = $entity_type_manager;
    $this->aliasManager = $alias_manager;
    $this->pathMatcher = $path_matcher;
    $this->currentPath = $current_path;
    $this->redirectDestination = $redirect_destination;
    $this->configFactory = $config_factory;
    $this->requestStack = $request_stack;
  }

  /**
   * {@inheritdoc}
   */
  public function findDestination($trigger, AccountInterface $account) {
    $destinations = $this->entityTypeManager->getStorage('login_destination')
      ->loadMultiple();
    uasort($destinations, '\Drupal\login_destination\Entity\LoginDestination::sort');

    $path = $this->getCurrentPath();
    $path_alias = Unicode::strtolower($this->aliasManager->getAliasByPath($path));

    // Get user roles.
    $user_roles = $account->getRoles();

    /** @var LoginDestination $destination */
    foreach ($destinations as $destination) {
      if (!$destination->isEnabled()) {
        continue;
      }

      // Determine if the trigger matches that of the login destination rule.
      $destination_triggers = $destination->getTriggers();
      if (!in_array($trigger, $destination_triggers)) {
        continue;
      }
      $destination_roles = $destination->getRoles();

      $role_match = array_intersect($user_roles, $destination_roles);
      // Ensure the user logging in has a role allowed by the login destination rule.
      // Or Login Destination Rule does not have any selected roles.
      if (empty($role_match) && !empty($destination_roles)) {
        continue;
      }

      $pages = Unicode::strtolower($destination->getPages());
      if (!empty($pages)) {
        $type = $destination->getPagesType();
        $page_match = $this->pathMatcher->matchPath($path_alias, $pages) || $this->pathMatcher->matchPath($path, $pages);

        // Make sure the page matches(or does not match if the rule specifies that).
        if (($page_match && $type == $destination::REDIRECT_LISTED) || (!$page_match && $type == $destination::REDIRECT_NOT_LISTED)) {

          return $destination;
        }
        continue;
      }

      return $destination;
    }

    return FALSE;
  }

  /**
   * {@inheritdoc}
   */
  public function prepareDestination(LoginDestination $destination) {
    // Get config with settings.
    $config = $this->configFactory->get('login_destination.settings');
    // Get current destination value.
    $drupal_destination = $this->redirectDestination->getAsArray();

    // Determine if a destination exist in the URL.
    if (!empty($drupal_destination['destination']) && $config->get('preserve_destination')) {
      return;
    }

    // Prepare destination path.
    $path = $destination->getDestination();
    $path_destination = Url::fromUri($path)->toString();

    // Set destination to current request.
    $this->requestStack->getCurrentRequest()->query->set('destination', $path_destination);
  }

  /**
   * Get current path.
   *
   * @return string
   */
  protected function getCurrentPath() {
    $current = $this->requestStack->getCurrentRequest()->get('current', '');
    if (empty($current)) {
      $current = $this->currentPath->getPath();
    }
    return $current;
  }

}
