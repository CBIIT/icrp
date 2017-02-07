<?php

namespace Drupal\clientside_validation\Plugin\CvValidator;

use Drupal\clientside_validation\CvValidatorBase;
use Drupal\Core\Form\FormStateInterface;

/**
 * Provides a 'step' validator.
 *
 * @CvValidator(
 *   id = "step",
 *   name = @Translation("Step"),
 *   supports = {
 *     "attributes" = {"step"}
 *   }
 * )
 */
class Step extends CvValidatorBase {

  /**
   * {@inheritdoc}
   */
  protected function getRules($element, FormStateInterface $form_state) {
    $step = $this->getAttributeValue($element, 'step');
    if ($step !== 'any') {
      if (($min = $this->getAttributeValue($element, 'min'))) {
        return [
          'messages' => [
            'step' => $this->t('The value in @title has to be greater than @min by steps of @step.', ['@title' => $this->getElementTitle($element), '@step' => $step, '@min' => $min]),
          ],
        ];
      }
      return [
        'messages' => [
          'step' => $this->t('The value in @title has to be divisible by @step.', ['@title' => $this->getElementTitle($element), '@step' => $step]),
        ],
      ];
    }
  }

}
