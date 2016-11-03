<?php

namespace Drupal\yamlform\Plugin\YamlFormElement;

use Drupal\Core\Form\FormStateInterface;
use Drupal\yamlform\YamlFormElementBase;

/**
 * Provides a 'yamlform_time' element.
 *
 * @YamlFormElement(
 *   id = "yamlform_time",
 *   label = @Translation("Time"),
 *   category = @Translation("Date/time elements"),
 * )
 */
class YamlFormTime extends YamlFormElementBase {

  /**
   * {@inheritdoc}
   */
  public function getDefaultProperties() {
    return parent::getDefaultProperties() + [
      'time_format' => '',
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function formatText(array &$element, $value, array $options = []) {
    if (empty($value)) {
      return '';
    }

    $format = $this->getFormat($element);
    if ($format == 'value') {
      $time_format = (isset($element['#time_format'])) ? $element['#time_format'] : 'H:i';
      return date($time_format, strtotime($value));
    }

    return parent::formatText($element, $value, $options);
  }

  /**
   * {@inheritdoc}
   */
  public function form(array $form, FormStateInterface $form_state) {
    $form = parent::form($form, $form_state);

    // Append supported time input format to #default_value description.
    $form['general']['default_value']['#description'] .= '<br />' . $this->t('Accepts any time in any <a href="https://www.gnu.org/software/tar/manual/html_chapter/tar_7.html#Date-input-formats">GNU Date Input Format</a>. Strings such as now, +2 hours, and 4:30 PM are all valid.');

    // Time.
    $form['time'] = [
      '#type' => 'details',
      '#title' => $this->t('Time settings'),
      '#open' => FALSE,
    ];
    $form['time']['time_format'] = [
      '#type' => 'yamlform_select_other',
      '#title' => $this->t('Time format'),
      '#description' => $this->t("Time format is only applicable for browsers that do not have support for the HTML5 time element. Browsers that support the HTML5 time element will display the time using the user's preferred format. Time format is used to format the submitted value."),
      '#options' => [
        'g:i A' => $this->t('12 hour (@time)', ['@time' => date('g:i A')]),
        'g:i:s A' => $this->t('12 hour with seconds (@time)', ['@time' => date('g:i:s A')]),
        'H:i' => $this->t('24 hour (@time)', ['@time' => date('H:i')]),
        'H:i:s' => $this->t('24 hour with seconds (@time)', ['@time' => date('H:i:s')]),
      ],
      '#other__option_label' => $this->t('Custom...'),
      '#other__placeholder' => $this->t('Custom time format...'),
      '#other__description' => $this->t('Enter time format using <a href="http://php.net/manual/en/function.date.php">Time Input Format</a>.'),
    ];
    return $form;
  }

}
