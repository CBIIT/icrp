<?php

namespace Drupal\clientside_validation;

use Drupal\Component\Plugin\PluginInspectionInterface;
use Drupal\Core\Form\FormStateInterface;

/**
 * Defines an interface for ice cream flavor plugins.
 */
interface CvValidatorInterface extends PluginInspectionInterface {

  /**
   * Makes the necessary changes to the form element so it can be validated.
   *
   * @param array $element
   *   The form element to validate.
   * @param FormStateInterface $form_state
   *   The form state of the form this element belongs to.
   */
  public function addValidation(array &$element, FormStateInterface $form_state);

  /**
   * Return the name of the validator flavor.
   *
   * @return string
   *   The name of the validator.
   */
  public function getName();

}
