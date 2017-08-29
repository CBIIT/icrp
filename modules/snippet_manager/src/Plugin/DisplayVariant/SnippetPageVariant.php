<?php

namespace Drupal\snippet_manager\Plugin\DisplayVariant;

use Drupal\Core\Display\PageVariantInterface;
use Drupal\Core\Display\VariantBase;
use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Logger\LoggerChannelInterface;
use Drupal\Core\Plugin\ContainerFactoryPluginInterface;
use Drupal\Core\Render\RendererInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Provides a page display variant that render a snippet to as the main content.
 *
 * @PageDisplayVariant(
 *   id = "snippet_page",
 *   admin_label = @Translation("Snippet page")
 * )
 */
class SnippetPageVariant extends VariantBase implements PageVariantInterface, ContainerFactoryPluginInterface {

  /**
   * Snippet storage.
   *
   * @var \Drupal\Core\Config\Entity\ConfigEntityStorageInterface
   */
  protected $snippetStorage;


  /**
   * Snippet renderer.
   *
   * @var \Drupal\Core\Logger\LoggerChannelInterface
   */
  protected $logger;

  /**
   * The render array representing the main content.
   *
   * @var array
   */
  protected $mainContent;

  /**
   * The page title: a string (plain title) or a render array (formatted title).
   *
   * @var string|array
   */
  protected $title = '';

  /**
   * The renderer service.
   *
   * @var \Drupal\Core\Render\RendererInterface
   */
  protected $renderer;

  /**
   * SnippetPageVariant constructor.
   *
   * @param array $configuration
   *   A configuration array containing information about the plugin instance.
   * @param string $plugin_id
   *   The plugin ID for the plugin instance.
   * @param mixed $plugin_definition
   *   The plugin implementation definition.
   * @param \Drupal\Core\Entity\EntityTypeManagerInterface $entity_manager
   *   The entity manager.
   * @param \Drupal\Core\Logger\LoggerChannelInterface $logger
   *   The logger channel.
   * @param \Drupal\Core\Render\RendererInterface $renderer
   *   The renderer service.
   */
  public function __construct(array $configuration, $plugin_id, $plugin_definition, EntityTypeManagerInterface $entity_manager, LoggerChannelInterface $logger, RendererInterface $renderer) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);
    $this->snippetStorage = $entity_manager->getStorage('snippet');
    $this->logger = $logger;
    $this->renderer = $renderer;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition) {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get('entity.manager'),
      $container->get('logger.channel.snippet_manager'),
      $container->get('renderer')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function setMainContent(array $main_content) {
    $this->mainContent = $main_content;
    return $this;
  }

  /**
   * {@inheritdoc}
   */
  public function setTitle($title) {
    $this->title = $title;
    return $this;
  }

  /**
   * {@inheritdoc}
   */
  public function defaultConfiguration() {
    $configuration = parent::defaultConfiguration();
    $configuration['snippet'] = NULL;
    return $configuration;
  }

  /**
   * {@inheritdoc}
   */
  public function buildConfigurationForm(array $form, FormStateInterface $form_state) {

    /** @var \Drupal\snippet_manager\SnippetInterface $snippet */
    $snippet = $this->snippetStorage->load($this->configuration['snippet']);

    if (!$snippet) {
      drupal_set_message(
        $this->t('Could not load snippet: #%snippet', ['%snippet' => $this->configuration['snippet']]),
        'error'
      );
    }

    $form['snippet'] = [
      '#type' => 'entity_autocomplete',
      '#title' => $this->t('Snippet'),
      '#default_value' => $snippet,
      '#maxlength' => 1024,
      '#required' => TRUE,
      // @todo: exclude disabled snippets.
      '#target_type' => 'snippet',
    ];

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function submitConfigurationForm(array &$form, FormStateInterface $form_state) {
    parent::submitConfigurationForm($form, $form_state);
    $this->configuration['snippet'] = $form_state->getValue('snippet');
  }

  /**
   * {@inheritdoc}
   */
  public function build() {
    $build = [];

    /** @var \Drupal\snippet_manager\SnippetInterface $snippet */
    $snippet = $this->snippetStorage->load($this->configuration['snippet']);
    if ($snippet) {

      /** @var \Drupal\snippet_manager\SnippetViewBuilder $view_builder */
      $view_builder = \Drupal::service('entity.manager')->getViewBuilder('snippet');

      // We don't use lazy builder here because of main content context.
      $build['content'] = $view_builder->buildRenderArray($snippet->id());
      $build['content']['snippet']['#context']['main_content'] = $this->mainContent;
    }
    else {
      $this->logger->error('Could not load snippet: #%snippet', ['%snippet' => $this->configuration['snippet']]);
    }

    return $build;
  }

}
