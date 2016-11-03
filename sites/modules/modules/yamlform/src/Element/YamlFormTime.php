<?php

namespace Drupal\yamlform\Element;

use Drupal\Core\Render\Element\FormElement;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Render\Element;

/**
 * Provides a form element for time selection.
 *
 * @code
 * $form['time'] = array(
 *   '#type' => 'time',
 *   '#title' => $this->t('Time'),
 *   '#default_value' => '12:00 AM'
 * );
 * @endcode
 *
 * @FormElement("yamlform_time")
 */
class YamlFormTime extends FormElement {

  /**
   * {@inheritdoc}
   */
  public function getInfo() {
    $class = get_class($this);
    return [
      '#input' => TRUE,
      '#theme' => 'input__time',
      '#process' => [[$class, 'processYamlFormTime']],
      '#pre_render' => [[$class, 'preRenderYamlFormTime']],
      '#element_validate' => [[$class, 'validateYamlFormTime']],
      '#theme_wrappers' => ['form_element'],
      '#time_format' => 'H:i',
      '#size' => 10,
      '#maxlength' => 10,
    ];
  }

  /**
   * {@inheritdoc}
   */
  public static function valueCallback(&$element, $input, FormStateInterface $form_state) {
    if ($input === FALSE) {
      // Set default value using GNU PHP date format.
      // @see https://www.gnu.org/software/tar/manual/html_chapter/tar_7.html#Date-input-formats.
      if (!empty($element['#default_value'])) {
        $element['#default_value'] = date('H:i', strtotime($element['#default_value']));
        return $element['#default_value'];
      }
    }

    return $input;
  }

  /**
   * Processes a time form element.
   *
   * @param array $element
   *   The form element to process. Properties used:
   *   - #time_format: The time format used in PHP formats.
   * @param \Drupal\Core\Form\FormStateInterface $form_state
   *   The current state of the form.
   * @param array $complete_form
   *   The complete form structure.
   *
   * @return array
   *   The processed element.
   */
  public static function processYamlFormTime(&$element, FormStateInterface $form_state, &$complete_form) {
    // Attach JS support for the time field, if we can determine which time
    // format should be used.
    if (!empty($element['#time_format'])) {
      $element['#attached']['library'][] = 'yamlform/yamlform.element.time';
      $element['#attributes']['data-yamlform-time-format'] = [$element['#time_format']];
    }
    return $element;
  }

  /**
   * Form element validation handler for #type 'yamlform_time'.
   *
   * Note that #required is validated by _form_validate() already.
   */
  public static function validateYamlFormTime(&$element, FormStateInterface $form_state, &$complete_form) {
    $value = $element['#value'];
    if ($value === '') {
      return;
    }

    $time = strtotime($value);
    if ($time === FALSE) {
      if (isset($element['#title'])) {
        $form_state->setError($element, t('%name must be a valid time.', ['%name' => $element['#title']]));
      }
      else {
        $form_state->setError($element);
      }
      return;
    }

    $form_state->setValueForElement($element, date('H:i:s', $time));

  }

  /**
   * Adds form-specific attributes to a 'date' #type element.
   *
   * @param array $element
   *   An associative array containing the properties of the element.
   *
   * @return array
   *   The $element with prepared variables ready for #theme 'input__time'.
   */
  public static function preRenderYamlFormTime($element) {
    $element['#attributes']['type'] = 'time';
    Element::setAttributes($element, ['id', 'name', 'type', 'value', 'size']);
    static::setAttributes($element, ['form-time']);
    return $element;
  }

}
