<?php

namespace Drupal\snippet_manager;

use Drupal\Component\Plugin\Exception\PluginNotFoundException;
use Drupal\Component\Utility\Timer;
use Drupal\Core\Cache\Cache;
use Drupal\Core\Entity\EntityInterface;
use Drupal\Core\Entity\EntityViewBuilder;

/**
 * Provides snippet view builder.
 */
class SnippetViewBuilder extends EntityViewBuilder {

  /**
   * {@inheritdoc}
   */
  public function view(EntityInterface $entity, $view_mode = 'full', $langcode = NULL) {

    /** @var \Drupal\snippet_manager\SnippetInterface $entity */
    if ($view_mode == 'source') {
      $build = $this->viewSource($entity);
    }
    else {
      $build['snippet'] = [
        '#cache' => [
          'keys' => ['snippet', $entity->id()],
          'tags' => Cache::mergeTags($this->getCacheTags(), $entity->getCacheTags()),
        ],
        '#lazy_builder' => [static::class . '::lazyBuilder', [$entity->id()]],
      ];
    }

    return $build;
  }

  /**
   * Builds the render array for the provided snippet using source view mode.
   */
  public function viewSource(EntityInterface $entity) {

    $build['snippet']['content']['#type'] = 'textarea';
    Timer::start('snippet');
    $value = $this->view($entity);

    // Render the snippet right here to get correct render time value.
    $build['snippet']['content']['#value'] = render($value);
    $render_time = Timer::read('snippet');
    $build['snippet']['content']['#attributes']['class'][] = 'snippet-html-source';

    $build['snippet']['#attributes']['class'][] = 'snippet-editor';

    $build['render_time_wrapper'] = [
      '#type' => 'container',
      '#attributes' => ['class' => 'snippet-render-time'],
    ];
    $build['render_time_wrapper']['render_time'] = [
      '#markup' => $this->t('Render time: %time ms', ['%time' => $render_time]),
    ];

    $build['#attached']['library'][] = 'snippet_manager/editor';

    return $build;
  }

  /**
   * Lazy builder callback; builds a #pre_render-able snippet.
   *
   * @param int $entity_id
   *   A snippet config entity ID.
   *
   * @return array
   *   A render array with a #pre_render callback to render the snippet.
   */
  public static function lazyBuilder($entity_id) {
    return static::buildRenderArray($entity_id);
  }

  /**
   * Builds render array.
   *
   * @param int $entity_id
   *   A snippet config entity ID.
   *
   * @return array
   *   Snippet content as render array.
   */
  public static function buildRenderArray($entity_id) {

    /** @var \Drupal\snippet_manager\SnippetInterface $snippet */
    $snippet = \Drupal::entityTypeManager()
      ->getStorage('snippet')
      ->load($entity_id);

    /** @var \Drupal\snippet_manager\SnippetVariablePluginManager $variable_manager */
    $variable_manager = \Drupal::service('plugin.manager.snippet_variable');

    $module_handler = \Drupal::moduleHandler();
    // The context is an array of processed twig variables.
    $context = $module_handler->invokeAll('snippet_context', [$snippet]);
    foreach ($snippet->get('variables') as $variable_name => $variable) {
      try {
        $plugin = $variable_manager->createInstance(
          $variable['plugin_id'],
          $variable['configuration']
        );
        $context[$variable_name] = $plugin->build();
      }
      catch (PluginNotFoundException $exception) {
        $context[$variable_name] = '';
      }
    }
    $module_handler->alter('snippet_context', $context, $snippet);

    $template = $snippet->get('template');

    $build['snippet'] = [
      '#type' => 'inline_template',
      '#template' => check_markup($template['value'], $template['format']),
      '#context' => $context,
    ];

    if ($snippet->get('css')['status'] || $snippet->get('js')['status']) {
      $build['snippet']['#attached']['library'][] = 'snippet_manager/snippet_' . $entity_id;
    }

    return $build;
  }

}
