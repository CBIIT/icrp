<?php

namespace Drupal\webform\Plugin\WebformElement;

use Drupal\Core\Form\FormState;
use Drupal\Core\Render\Element;
use Drupal\webform\Element\WebformName as WebformNameElement;

/**
 * Provides an 'name' element.
 *
 * @WebformElement(
 *   id = "webform_name",
 *   label = @Translation("Name"),
 *   category = @Translation("Composite elements"),
 *   multiline = TRUE,
 *   composite = TRUE,
 * )
 */
class WebformName extends WebformCompositeBase {

  /**
   * {@inheritdoc}
   */
  protected function getCompositeElements() {
    return WebformNameElement::getCompositeElements();
  }

  /**
   * {@inheritdoc}
   */
  protected function getInitializedCompositeElement(array &$element) {
    $form_state = new FormState();
    $form_completed = [];
    return WebformNameElement::processWebformComposite($element, $form_state, $form_completed);
  }

  /**
   * {@inheritdoc}
   */
  protected function formatLines(array $element, array $value) {
    $name_parts = [];
    $composite_elements = $this->getCompositeElements();
    foreach (Element::children($composite_elements) as $name_part) {
      if (!empty($value[$name_part])) {
        $delimiter = (in_array($name_part, ['suffix', 'degree'])) ? ', ' : ' ';
        $name_parts[] = $delimiter . $value[$name_part];
      }
    }

    return [
      'name' => trim(implode('', $name_parts)),
    ];
  }

}
