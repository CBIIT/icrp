<?php

namespace Drupal\snippet_manager\EventSubscriber;

use Drupal\Core\Render\PageDisplayVariantSelectionEvent;
use Drupal\Core\Render\RenderEvents;
use Drupal\snippet_manager\SnippetInterface;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpFoundation\RequestStack;

/**
 * Selects the display variant for snippet pages.
 */
class DisplayVariantSubscriber implements EventSubscriberInterface {

  /**
   * The request stack.
   *
   * @var \Symfony\Component\HttpFoundation\RequestStack
   */
  protected $requestStack;

  /**
   * Constructs subscriber object.
   *
   * @param \Symfony\Component\HttpFoundation\RequestStack $request_stack
   *   The request stack.
   */
  public function __construct(RequestStack $request_stack) {
    $this->requestStack = $request_stack;
  }

  /**
   * Event callback.
   *
   * @param \Drupal\Core\Render\PageDisplayVariantSelectionEvent $event
   *   The event to process.
   */
  public function onSelectPageDisplayVariant(PageDisplayVariantSelectionEvent $event) {

    if ($event->getRouteMatch()->getRouteObject()->getOption('snippet_page')) {
      $snippet = $this->requestStack->getCurrentRequest()->get('snippet');
      if ($snippet && $snippet instanceof SnippetInterface) {
        $display_variant = $snippet->get('page')['display_variant'];
        if ($display_variant['id']) {
          $event->setPluginId($display_variant['id']);
          $event->setPluginConfiguration($display_variant['configuration']);
        }
      }
    }

  }

  /**
   * {@inheritdoc}
   */
  public static function getSubscribedEvents() {
    $events[RenderEvents::SELECT_PAGE_DISPLAY_VARIANT][] = ['onSelectPageDisplayVariant'];
    return $events;
  }

}
