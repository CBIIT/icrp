<?php

namespace Drupal\clientside_validation\Plugin\CvValidator;

use Drupal\clientside_validation\CvValidatorBase;
use Drupal\Core\Form\FormStateInterface;

/**
 * Provides a 'required' validator.
 *
 * @CvValidator(
 *   id = "required",
 *   name = @Translation("Required"),
 *   supports = {
 *     "attributes" = {"required"}
 *   }
 * )
 */
class Required extends CvValidatorBase {

  /**
   * {@inheritdoc}
   */
  protected function getRules($element, FormStateInterface $form_state) {
    // Drupal already adds the required attribute, so we don't need to set the
    // required rule.
    if ($this->getAttributeValue($element, 'required')) {
      return [
        'messages' => [
          'required' => $this->t('@title is required.', ['@title' => $this->getElementTitle($element)]),
        ],
      ];
    }
  }

}
