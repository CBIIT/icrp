<?php

namespace Drupal\snippet_manager\Form;

use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Form\ConfigFormBase;

/**
 * Configure Snippet manager settings for this site.
 */
class SettingsForm extends ConfigFormBase {

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
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {

    $settings = $this->config('snippet_manager.settings')->get();

    $form['codemirror'] = [
      '#type' => 'details',
      '#title' => t('CodeMirror'),
      '#open' => TRUE,
      '#tree' => TRUE,
    ];

    $form['codemirror']['cdn'] = [
      '#type' => 'checkbox',
      '#title' => t('Load the library from CDN'),
      '#default_value' => $settings['codemirror']['cdn'],
    ];

    $form['codemirror']['toolbar'] = [
      '#type' => 'checkbox',
      '#title' => t('Enable editor toolbar'),
      '#default_value' => $settings['codemirror']['toolbar'],
    ];

    $codemirror_themes = $this->getCodeMirrorThemes();
    $form['codemirror']['theme'] = [
      '#type' => 'select',
      '#title' => t('Theme'),
      '#options' => array_combine($codemirror_themes, $codemirror_themes),
      '#default_value' => $settings['codemirror']['theme'],
    ];

    $form['codemirror']['mode'] = [
      '#type' => 'select',
      '#title' => t('Syntax mode'),
      '#options' => [
        'html_twig' => t('HTML/Twig'),
        'text/html' => t('HTML'),
        'twig' => t('Twig'),
        'javascript' => t('Javascript'),
        'css' => t('CSS'),
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
    \Drupal::service('cache_tags.invalidator')->invalidateTags(['library_info']);

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
