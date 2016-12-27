<?php

namespace Drupal\snippet_manager\EventSubscriber;

use Drupal\Core\Render\PageDisplayVariantSelectionEvent;
use Drupal\Core\Render\RenderEvents;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Drupal\snippet_manager\SnippetInterface;

/**
 * Selects the display variant for snippet pages.
 */
class DisplayVariantSubscriber implements EventSubscriberInterface {

  /**
   * Event callback.
   *
   * @param \Drupal\Core\Render\PageDisplayVariantSelectionEvent $event
   *   The event to process.
   */
  public function onSelectPageDisplayVariant(PageDisplayVariantSelectionEvent $event) {

    if ($event->getRouteMatch()->getRouteName() == 'entity.snippet.canonical') {
      $snippet = \Drupal::request()->get('snippet');
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
