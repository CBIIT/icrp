<?php

namespace Drupal\snippet_manager\Plugin\SnippetVariable;

use Drupal\Core\Form\FormStateInterface;
use Drupal\snippet_manager\SnippetVariableBase;

/**
 * Provides text variable type.
 *
 * @SnippetVariable(
 *   id = "text",
 *   title = @Translation("Text"),
 *   category = @Translation("Other"),
 * )
 */
class Text extends SnippetVariableBase {

  /**
   * {@inheritdoc}
   */
  public function buildConfigurationForm(array $form, FormStateInterface $form_state) {

    $form['content'] = [
      '#title' => $this->t('Content'),
      '#type' => 'text_format',
      '#default_value' => $this->configuration['content']['value'],
      '#format' => $this->configuration['content']['format'],
      '#rows' => 10,
      '#editor' => FALSE,
    ];

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function defaultConfiguration() {
    $configuration['content'] = [
      'value' => '',
      'format' => filter_default_format(),
    ];
    return $configuration;
  }

  /**
   * {@inheritdoc}
   */
  public function build() {
    return [
      '#type' => 'processed_text',
      '#text' => $this->configuration['content']['value'],
      '#format' => $this->configuration['content']['format'],
    ];
  }

}
