<?php

namespace Drupal\webform\Plugin\WebformElement;

use Drupal\webform\WebformSubmissionInterface;

/**
 * Provides a 'checkboxes_other' element.
 *
 * @WebformElement(
 *   id = "webform_checkboxes_other",
 *   label = @Translation("Checkboxes other"),
 *   category = @Translation("Options elements"),
 *   multiple = TRUE,
 * )
 */
class WebformCheckboxesOther extends Checkboxes {

  /**
   * {@inheritdoc}
   */
  public function getDefaultProperties() {
    return parent::getDefaultProperties() + self::getOtherProperties();
  }

  /**
   * {@inheritdoc}
   */
  public function prepare(array &$element, WebformSubmissionInterface $webform_submission) {
    parent::prepare($element, $webform_submission);
    $element['#element_validate'][] = [get_class($this), 'validateMultipleOptions'];
  }

  /**
   * {@inheritdoc}
   */
  public function getElementSelectorOptions(array $element) {
    $title = $this->getAdminLabel($element);
    $name = $element['#webform_key'];

    $selectors = [];
    foreach ($element['#options'] as $input_name => $input_title) {
      $selectors[":input[name=\"{$name}[checkboxes][{$input_name}]\"]"] = $input_title . ' [' . $this->t('Checkboxes') . ']';
    }
    $selectors[":input[name=\"{$name}[other]\"]"] = $title . ' [' . $this->t('Textfield') . ']';
    return [$title => $selectors];
  }

}
