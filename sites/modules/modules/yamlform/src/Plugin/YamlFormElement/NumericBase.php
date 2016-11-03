<?php

namespace Drupal\yamlform\Plugin\YamlFormElement;

use Drupal\Core\Form\FormStateInterface;
use Drupal\yamlform\YamlFormElementBase;
use Drupal\yamlform\YamlFormSubmissionInterface;

/**
 * Provides a base 'numeric' class.
 */
abstract class NumericBase extends YamlFormElementBase {

  /**
   * {@inheritdoc}
   */
  public function getDefaultProperties() {
    return parent::getDefaultProperties() + [
      'size' => '',
      'maxlength' => '',
      'placeholder' => '',
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function prepare(array &$element, YamlFormSubmissionInterface $yamlform_submission) {
    parent::prepare($element, $yamlform_submission);
    if ($this->hasProperty('step') && !isset($element['#step'])) {
      $element['#step'] = 'any';
    }
  }

  /**
   * {@inheritdoc}
   */
  public function form(array $form, FormStateInterface $form_state) {
    $form = parent::form($form, $form_state);
    $form['form']['min'] = [
      '#type' => 'number',
      '#title' => $this->t('Min'),
      '#description' => $this->t('Specifies the minimum value.'),
      '#step' => 'any',
      '#size' => 4,
    ];
    $form['form']['max'] = [
      '#type' => 'number',
      '#title' => $this->t('Max'),
      '#description' => $this->t('Specifies the maximum value.'),
      '#step' => 'any',
      '#size' => 4,
    ];
    $form['form']['step'] = [
      '#type' => 'number',
      '#title' => $this->t('Steps'),
      '#description' => $this->t('Specifies the legal number intervals. Leave blank to support any number interval.'),
      '#step' => 'any',
      '#size' => 4,
    ];
    return $form;
  }

}
