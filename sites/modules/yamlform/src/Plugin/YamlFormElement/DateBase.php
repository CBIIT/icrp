<?php

namespace Drupal\yamlform\Plugin\YamlFormElement;

use Drupal\Component\Serialization\Json;
use Drupal\Core\Datetime\Entity\DateFormat;
use Drupal\Core\Form\FormStateInterface;
use Drupal\yamlform\YamlFormElementBase;
use Drupal\yamlform\YamlFormSubmissionInterface;

/**
 * Provides a base 'date' class.
 */
abstract class DateBase extends YamlFormElementBase {

  /**
   * {@inheritdoc}
   */
  public function getDefaultProperties() {
    return parent::getDefaultProperties() + [
      'min' => '',
      'max' => '',
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function prepare(array &$element, YamlFormSubmissionInterface $yamlform_submission) {
    // Don't used 'datetime_wrapper', instead use 'form_element' wrapper.
    // Note: Below code must be executed before parent::prepare().
    // @see \Drupal\Core\Datetime\Element\Datelist
    // @see \Drupal\yamlform\Plugin\YamlFormElement\DateTime
    $element['#theme_wrappers'] = ['form_element'];

    // Must manually process #states.
    // @see drupal_process_states().
    if (isset($element['#states'])) {
      $element['#attached']['library'][] = 'core/drupal.states';
      $element['#wrapper_attributes']['data-drupal-states'] = Json::encode($element['#states']);
    }

    parent::prepare($element, $yamlform_submission);

    // Parse #default_value date input format.
    $this->parseInputFormat($element, '#default_value');

    // Parse #min and #max date input format.
    $this->parseInputFormat($element, '#min');
    $this->parseInputFormat($element, '#max');

    // Override min/max attributes.
    if (!empty($element['#min'])) {
      $element['#attributes']['min'] = $element['#min'];
    }
    if (!empty($element['#max'])) {
      $element['#attributes']['max'] = $element['#max'];
    }

    $element['#element_validate'][] = [get_class($this), 'validateDate'];
  }

  /**
   * {@inheritdoc}
   */
  public function formatText(array &$element, $value, array $options = []) {
    $timestamp = strtotime($value);
    if (empty($timestamp)) {
      return $value;
    }

    $format = $this->getFormat($element) ?: $this->getHtmlDateFormat($element);
    if (DateFormat::load($format)) {
      return \Drupal::service('date.formatter')->format($timestamp, $format);
    }
    else {
      return date($format, $timestamp);
    }
  }

  /**
   * {@inheritdoc}
   */
  public function getFormat(array $element) {
    if (isset($element['#format'])) {
      return $element['#format'];
    }
    else {
      return parent::getFormat($element);
    }
  }

  /**
   * {@inheritdoc}
   */
  public function getDefaultFormat() {
    return 'fallback';
  }

  /**
   * {@inheritdoc}
   */
  public function getFormats() {
    $formats = parent::getFormats();
    $date_formats = DateFormat::loadMultiple();
    foreach ($date_formats as $date_format) {
      $formats[$date_format->id()] = $date_format->label();
    }
    return $formats;
  }

  /**
   * {@inheritdoc}
   */
  public function form(array $form, FormStateInterface $form_state) {
    $form = parent::form($form, $form_state);

    // Append supported date input format to #default_value description.
    $form['general']['default_value']['#description'] .= '<br />' . $this->t('Accepts any date in any <a href="https://www.gnu.org/software/tar/manual/html_chapter/tar_7.html#Date-input-formats">GNU Date Input Format</a>. Strings such as today, +2 months, and Dec 9 2004 are all valid.');

    // Allow custom date formats to be entered.
    $form['display']['format']['#type'] = 'yamlform_select_other';
    $form['display']['format']['#other__option_label'] = $this->t('Custom date format...');
    $form['display']['format']['#other__description'] = $this->t('A user-defined date format. See the <a href="http://php.net/manual/function.date.php">PHP manual</a> for available options.');

    // Add min/max validation.
    $form['validation']['min'] = [
      '#type' => 'textfield',
      '#title' => $this->t('Min'),
      '#description' => $this->t('Specifies the minimum date.') . '<br />' . $this->t('Accepts any date in any <a href="https://www.gnu.org/software/tar/manual/html_chapter/tar_7.html#Date-input-formats">GNU Date Input Format</a>. Strings such as today, +2 months, and Dec 9 2004 are all valid.'),
    ];
    $form['validation']['max'] = [
      '#type' => 'textfield',
      '#title' => $this->t('Max'),
      '#description' => $this->t('Specifies the maximum date.') . '<br />' . $this->t('Accepts any date in any <a href="https://www.gnu.org/software/tar/manual/html_chapter/tar_7.html#Date-input-formats">GNU Date Input Format</a>. Strings such as today, +2 months, and Dec 9 2004 are all valid.'),
    ];

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function validateConfigurationForm(array &$form, FormStateInterface $form_state) {
    $properties = $this->getConfigurationFormProperties($form, $form_state);

    // Validate #default_value GNU Date Input Format.
    if ($properties['#default_value'] && strtotime($properties['#default_value']) === FALSE) {
      $this->setInputFormatError($form['properties']['general']['default_value'], $form_state);
    }

    // Validate #min and #max GNU Date Input Format.
    $input_formats = ['min', 'max'];
    foreach ($input_formats as $input_format) {
      if (!empty($properties["#$input_format"]) && strtotime($properties["#$input_format"]) === FALSE) {
        $this->setInputFormatError($form['properties']['date'][$input_format], $form_state);
      }
    }

    parent::validateConfigurationForm($form, $form_state);
  }

  /**
   * Get an HTML date/time format for an element.
   *
   * @param array $element
   *   An element.
   *
   * @return string
   *   An HTML date/time format string.
   */
  protected function getHtmlDateFormat(array $element) {
    if ($element['#type'] == 'datelist') {
      return (isset($element['#date_part_order']) && !in_array('hour', $element['#date_part_order'])) ? 'html_date' : 'html_datetime';
    }
    else {
      return 'html_' . $element['#type'];
    }
  }

  /**
   * Parse GNU Date Input Format.
   *
   * @param array $element
   *   An element.
   * @param string $property
   *   The element's date property.
   */
  protected function parseInputFormat(array &$element, $property) {
    if (!isset($element[$property])) {
      return;
    }

    $timestamp = strtotime($element[$property]);
    if ($timestamp === FALSE) {
      $element[$property] = NULL;
    }
    else {
      $element[$property] = \Drupal::service('date.formatter')->format($timestamp, $this->getHtmlDateFormat($element));
    }
  }

  /**
   * Set GNU input format error.
   *
   * @param array $element
   *   The property element.
   * @param \Drupal\Core\Form\FormStateInterface $form_state
   *   The current state of the form.
   */
  protected function setInputFormatError(array $element, FormStateInterface $form_state) {
    $t_args = [
      '@title' => $element['#title'] ?: $element['#key'],
    ];
    $form_state->setError($element, $this->t('The @title could not be interpreted in <a href="https://www.gnu.org/software/tar/manual/html_chapter/tar_7.html#Date-input-formats">GNU Date Input Format</a>.', $t_args));
  }

  /**
   * Form element validation handler for base elements.
   *
   * Note that #required is validated by _form_validate() already.
   *
   * @see \Drupal\Core\Render\Element\Number::validateNumber
   */
  public static function validateDate(&$element, FormStateInterface $form_state, &$complete_form) {
    $value = $element['#value'];

    // Convert DrupalDateTime array and object to ISO datetime.
    if (is_array($value)) {
      /** @var \Drupal\Core\Datetime\DrupalDateTime $datetime */
      if ($datetime = $value['object']) {
        $value = $datetime->format('c');
      }
      else {
        $value = '';
      }
      $form_state->setValueForElement($element, $value);
    }

    if ($value === '') {
      return;
    }

    $name = empty($element['#title']) ? $element['#parents'][0] : $element['#title'];

    // Ensure the input is valid date.
    // @see http://stackoverflow.com/questions/10691949/check-if-variable-is-a-valid-date-with-php
    $date = date_parse($value);
    if ($date["error_count"] || !checkdate($date["month"], $date["day"], $date["year"])) {
      $form_state->setError($element, t('%name must be a valid date.', ['%name' => $name]));
    }

    $time = strtotime($value);
    $date_date_format = (!empty($element['#date_date_format'])) ? $element['#date_date_format'] : DateFormat::load('html_date')->getPattern();

    // Ensure that the input is greater than the #min property, if set.
    if (isset($element['#min'])) {
      $min = strtotime($element['#min']);
      if ($time < $min) {
        $form_state->setError($element, t('%name must be on or after %min.', [
          '%name' => $name,
          '%min' => date($date_date_format, $min),
        ]));
      }
    }

    // Ensure that the input is less than the #max property, if set.
    if (isset($element['#max'])) {
      $max = strtotime($element['#max']);
      if ($time > $max) {
        $form_state->setError($element, t('%name must be on or before %max.', [
          '%name' => $name,
          '%max' => date($date_date_format, $max),
        ]));
      }
    }
  }

}
