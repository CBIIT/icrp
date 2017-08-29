<?php

namespace Drupal\datetime_extras\Plugin\Field\FieldWidget;

use Drupal\Core\Field\FieldItemListInterface;
use Drupal\Core\Form\FormStateInterface;
use Drupal\datetime\Plugin\Field\FieldWidget\DateTimeDatelistWidget;

/**
 * Plugin implementation of the 'datatime_extras_configurable_list' widget.
 *
 * @FieldWidget(
 *   id = "datatime_extras_configurable_list",
 *   label = @Translation("Configurable list"),
 *   field_types = {
 *     "datetime"
 *   }
 * )
 */
class DateConfigurableListWidget extends DateTimeDatelistWidget {

  /**
   * {@inheritdoc}
   */
  public static function defaultSettings() {
    $settings = parent::defaultSettings();
    return $settings;
  }

  /**
   * {@inheritdoc}
   */
  public function settingsForm(array $form, FormStateInterface $form_state) {
    $elements = parent::settingsForm($form, $form_state);

    $elements['date_order']['#options'] += [
      'Y' => $this->t('Year'),
      'MY' => $this->t('Month/Year'),
      'YM' => $this->t('Year/Month'),
    ];

    return $elements;
  }

  /**
   * {@inheritdoc}
   */
  public function settingsSummary() {
    $summary = parent::settingsSummary();

    return $summary;
  }

  /**
   * {@inheritdoc}
   */
  public function formElement(FieldItemListInterface $items, $delta, array $element, array &$form, FormStateInterface $form_state) {
    $date_order = $this->getSetting('date_order');

    // Set up the date part order array.
    switch ($date_order) {
      case 'Y':
        $date_part_order = ['year'];
        break;

      case 'MY':
        $date_part_order = ['month', 'year'];
        break;

      case 'YM':
        $date_part_order = ['year', 'month'];
        break;
    }

    // Work around core bug.
    // @TODO: Fix after https://www.drupal.org/node/2863897
    if (isset($date_part_order)) {
      $this->setSetting('date_order', 'YMD');
    }

    $element = parent::formElement($items, $delta, $element, $form, $form_state);

    if (isset($date_part_order)) {
      $element['value']['#date_part_order'] = $date_part_order;
    }

    return $element;
  }

}
