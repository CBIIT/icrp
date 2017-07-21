<?php

namespace Drupal\snippet_manager\Form;

use Drupal\Core\Cache\CacheTagsInvalidatorInterface;
use Drupal\Core\Config\ConfigFactoryInterface;
use Drupal\Core\Form\ConfigFormBase;
use Drupal\Core\Form\FormStateInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Configure Snippet manager settings for this site.
 */
class SettingsForm extends ConfigFormBase {
  /**
   * The cache tags invalidator.
   *
   * @var \Drupal\Core\Cache\CacheTagsInvalidatorInterface
   */
  protected $cacheTagsInvalidator;

  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'snippet_manager_settings';
  }

  /**
   * {@inheritdoc}
   */
  protected function getEditableConfigNames() {
    return ['snippet_manager.settings'];
  }

  /**
   * Constructs a \Drupal\system\ConfigFormBase object.
   *
   * @param \Drupal\Core\Config\ConfigFactoryInterface $config_factory
   *   The factory for configuration objects.
   * @param \Drupal\Core\Cache\CacheTagsInvalidatorInterface $cache_tags_invalidator
   *   The cache tags invalidator.
   */
  public function __construct(ConfigFactoryInterface $config_factory, CacheTagsInvalidatorInterface $cache_tags_invalidator) {
    parent::__construct($config_factory);
    $this->cacheTagsInvalidator = $cache_tags_invalidator;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    return new static(
      $container->get('config.factory'),
      $container->get('cache_tags.invalidator')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {

    $settings = $this->config('snippet_manager.settings')->get();

    $form['codemirror'] = [
      '#type' => 'details',
      '#title' => $this->t('CodeMirror'),
      '#open' => TRUE,
      '#tree' => TRUE,
    ];

    $form['codemirror']['cdn'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Load the library from CDN'),
      '#default_value' => $settings['codemirror']['cdn'],
    ];

    $form['codemirror']['toolbar'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Enable editor toolbar'),
      '#default_value' => $settings['codemirror']['toolbar'],
    ];

    $codemirror_themes = $this->getCodeMirrorThemes();
    $form['codemirror']['theme'] = [
      '#type' => 'select',
      '#title' => $this->t('Theme'),
      '#options' => array_combine($codemirror_themes, $codemirror_themes),
      '#default_value' => $settings['codemirror']['theme'],
    ];

    $form['codemirror']['mode'] = [
      '#type' => 'select',
      '#title' => $this->t('Syntax mode'),
      '#options' => [
        'html_twig' => $this->t('HTML/Twig'),
        'text/html' => $this->t('HTML'),
        'twig' => $this->t('Twig'),
        'javascript' => $this->t('Javascript'),
        'css' => $this->t('CSS'),
      ],
      '#default_value' => $settings['codemirror']['mode'],
    ];

    return parent::buildForm($form, $form_state);
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {

    $this->config('snippet_manager.settings')
      ->set('codemirror', $form_state->getValue('codemirror'))
      ->save();

    // Invalidate discovery caches to rebuild asserts.
    $this->cacheTagsInvalidator->invalidateTags(['library_info']);

    parent::submitForm($form, $form_state);
  }

  /**
   * Returns CodeMirror themes.
   *
   * @return array
   *   CodeMirror themes.
   */
  protected function getCodeMirrorThemes() {
    return [
      'default',
      '3024-day',
      '3024-night',
      'abcdef',
      'ambiance-mobile',
      'ambiance',
      'base16-dark',
      'base16-light',
      'bespin',
      'blackboard',
      'cobalt',
      'colorforth',
      'dracula',
      'eclipse',
      'elegant',
      'erlang-dark',
      'hopscotch',
      'icecoder',
      'isotope',
      'lesser-dark',
      'liquibyte',
      'material',
      'mbo',
      'mdn-like',
      'midnight',
      'monokai',
      'neat',
      'neo',
      'night',
      'paraiso-dark',
      'paraiso-light',
      'pastel-on-dark',
      'railscasts',
      'rubyblue',
      'seti',
      'solarized',
      'the-matrix',
      'tomorrow-night-bright',
      'tomorrow-night-eighties',
      'ttcn',
      'twilight',
      'vibrant-ink',
      'xq-dark',
      'xq-light',
      'yeti',
      'zenburn',
    ];
  }

}
