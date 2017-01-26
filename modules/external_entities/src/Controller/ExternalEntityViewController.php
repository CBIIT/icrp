<?php

/**
 * @file
 * Contains \Drupal\external_entities\Controller\ExternalEntityViewController.
 */

namespace Drupal\external_entities\Controller;

use Drupal\Component\Utility\SafeMarkup;
use Drupal\Core\Entity\EntityInterface;
use Drupal\Core\Entity\Controller\EntityViewController;

/**
 * Defines a controller to render a single external entity.
 */
class ExternalEntityViewController extends EntityViewController {

  /**
   * {@inheritdoc}
   */
  public function view(EntityInterface $entity, $view_mode = 'full', $langcode = NULL) {
    $build = array('external_entities' => parent::view($entity));

    $build['#title'] = $build['external_entities']['#title'];
    unset($build['external_entities']['#title']);

    foreach ($entity->uriRelationships() as $rel) {
      // Set the node path as the canonical URL to prevent duplicate content.
      $build['#attached']['html_head_link'][] = array(
        array(
          'rel' => $rel,
          'href' => $entity->url($rel),
        ),
        TRUE,
      );

      if ($rel == 'canonical') {
        // Set the non-aliased canonical path as a default shortlink.
        $build['#attached']['html_head_link'][] = array(
          array(
            'rel' => 'shortlink',
            'href' => $entity->url($rel, array('alias' => TRUE)),
          ),
          TRUE,
        );
      }
    }

    return $build;
  }

  /**
   * The _title_callback for the page that renders a single external entity.
   *
   * @param \Drupal\Core\Entity\EntityInterface $entity
   *   The current external entity.
   *
   * @return string
   *   The page title.
   */
  public function title(EntityInterface $entity) {
    return SafeMarkup::checkPlain($this->entityManager->getTranslationFromContext($entity)->label());
  }

}
