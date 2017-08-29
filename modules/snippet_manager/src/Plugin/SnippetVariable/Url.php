<?php

namespace Drupal\snippet_manager\Plugin\SnippetVariable;

use Drupal\Component\Utility\UrlHelper;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Url as DrupalUrl;
use Drupal\snippet_manager\SnippetVariableBase;

/**
 * Provides URL variable type.
 *
 * @SnippetVariable(
 *   id = "url",
 *   title = @Translation("Url"),
 *   category = @Translation("Other"),
 * )
 */
class Url extends SnippetVariableBase {

  /**
   * {@inheritdoc}
   */
  public function buildConfigurationForm(array $form, FormStateInterface $form_state) {

    $form['path'] = [
      '#type' => 'textfield',
      '#title' => $this->t('Path'),
      '#default_value' => $this->configuration['path'],
      '#autocomplete_route_name' => 'snippet_manager.path_autocomplete',
      '#description' => $this->t('Make sure the path begins with "/".'),
      '#required' => TRUE,
    ];

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function validateConfigurationForm(array &$form, FormStateInterface $form_state) {
    $path = $form_state->getValue('path');
    $parsed_url = UrlHelper::parse($path);
    if ($parsed_url['path'][0] != '/') {
      $form_state->setErrorByName('path', $this->t('The path should begin with "/".'));
    }
  }

  /**
   * {@inheritdoc}
   */
  public function defaultConfiguration() {
    $configuration['path'] = NULL;
    return $configuration;
  }

  /**
   * {@inheritdoc}
   */
  public function build() {
    if ($this->configuration['path']) {
      return DrupalUrl::fromUserInput($this->configuration['path'])->toString();
    }
  }

}
