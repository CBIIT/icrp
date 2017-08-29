<?php

namespace Drupal\snippet_manager\Plugin\SnippetVariable;

use Drupal\Core\Form\FormStateInterface;
use Drupal\snippet_manager\SnippetVariableBase;

/**
 * Provides file variable type.
 *
 * This plugin is serialized on ajax form submit, so that we cannot save
 * dependency as class properties.
 *
 * @SnippetVariable(
 *   id = "file",
 *   title = @Translation("File"),
 *   category = @Translation("Other"),
 * )
 */
class File extends SnippetVariableBase {

  /**
   * {@inheritdoc}
   */
  public function buildConfigurationForm(array $form, FormStateInterface $form_state) {

    // TODO: Validate file extensions.
    $form['file'] = [
      '#title' => 'File',
      '#type' => 'managed_file',
      '#upload_location' => 'public://snippet',
      '#required' => TRUE,
    ];

    if ($this->configuration['file']) {
      /* @var \Drupal\file\FileInterface $file */
      $file = \Drupal::service('entity.repository')->loadEntityByUuid('file', $this->configuration['file']);
      if ($file) {
        $form['file']['#default_value'] = [$file->id()];
      }
    }

    $form['format'] = [
      '#title' => $this->t('Format'),
      '#type' => 'radios',
      '#options' => [
        'generic' => $this->t('Generic'),
        'url' => $this->t('URL'),
      ],
      '#default_value' => $this->configuration['format'],
      '#required' => TRUE,
    ];

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function submitConfigurationForm(array &$form, FormStateInterface $form_state) {

    $values = $form_state->getValues();
    if (isset($values['file'][0])) {
      /* @var \Drupal\file\FileInterface $file */
      $file = \Drupal::entityTypeManager()->getStorage('file')->load($values['file'][0]);
      $this->configuration['file'] = $file ? $file->uuid() : NULL;
    }

    $this->configuration['format'] = $values['format'];
  }

  /**
   * {@inheritdoc}
   */
  public function defaultConfiguration() {
    return [
      'file' => NULL,
      'format' => 'generic',
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function build() {

    $build = [];

    if ($this->configuration['file']) {
      /** @var \Drupal\file\FileInterface $file */
      $file = \Drupal::service('entity.repository')->loadEntityByUuid('file', $this->configuration['file']);
      if ($file) {
        if ($this->configuration['format'] == 'generic') {
          $build['file'] = [
            '#theme' => 'file_link',
            '#file' => $file,
          ];
        }
        else {
          $build['file'] = [
            '#markup' => file_create_url($file->getFileUri()),
          ];
        }
        $build['file']['#cache']['tags'] = $file->getCacheTags();

      }
    }

    return $build;
  }

}
