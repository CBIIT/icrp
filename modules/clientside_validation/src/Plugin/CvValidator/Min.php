<?php

namespace Drupal\clientside_validation\Plugin\CvValidator;

use Drupal\clientside_validation\CvValidatorBase;
use Drupal\Core\Form\FormStateInterface;

/**
 * Provides a 'min' validator.
 *
 * @CvValidator(
 *   id = "min",
 *   name = @Translation("Minimum"),
 *   supports = {
 *     "attributes" = {"min"}
 *   }
 * )
 */
class Min extends CvValidatorBase {

  /**
   * {@inheritdoc}
   */
  protected function getRules($element, FormStateInterface $form_state) {
    // Drupal already adds the min attribute, so we don't need to set the min
    // rule.
    return [
      'messages' => [
        'min' => $this->t('The value in @title has to be greater than @min.', ['@title' => $this->getElementTitle($element), '@min' => $this->getAttributeValue($element, 'min')]),
      ],
    ];
  }

}
