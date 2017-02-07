<?php

namespace Drupal\clientside_validation\Plugin\CvValidator;

use Drupal\clientside_validation\CvValidatorBase;
use Drupal\Core\Form\FormStateInterface;

/**
 * Provides a 'max' validator.
 *
 * @CvValidator(
 *   id = "max",
 *   name = @Translation("Maximum"),
 *   supports = {
 *     "attributes" = {"max"}
 *   }
 * )
 */
class Max extends CvValidatorBase {

  /**
   * {@inheritdoc}
   */
  protected function getRules($element, FormStateInterface $form_state) {
    // Drupal already adds the max attribute, so we don't need to set the max
    // rule.
    return [
      'messages' => [
        'max' => $this->t('The value in @title has to be less than @max.', ['@title' => $this->getElementTitle($element), '@max' => $this->getAttributeValue($element, 'max')]),
      ],
    ];
  }

}
