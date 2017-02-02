<?php

namespace Drupal\feeds\Feeds\Target;

use Drupal\Core\Datetime\DrupalDateTime;
use Drupal\feeds\Plugin\Type\Target\FieldTargetBase;

/**
 * Defines a dateime field mapper.
 *
 * @FeedsTarget(
 *   id = "datetime",
 *   field_types = {"datetime"}
 * )
 */
class DateTime extends FieldTargetBase {

  /**
   * The datetime storage format.
   *
   * @var string
   */
  protected $storageFormat;

  /**
   * {@inheritdoc}
   */
  public function __construct(array $configuration, $plugin_id, array $plugin_definition) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);
    $this->storageFormat = $this->settings['datetime_type'] === 'date' ? DATETIME_DATE_STORAGE_FORMAT : DATETIME_DATETIME_STORAGE_FORMAT;
  }

  /**
   * {@inheritdoc}
   */
  protected function prepareValue($delta, array &$values) {
    $value = trim($values['value']);

    // This is a year value.
    if (ctype_digit($value) && strlen($value) === 4) {
      $value = 'January ' . $value;
    }

    if (is_numeric($value)) {
      $date = DrupalDateTime::createFromTimestamp($value, DATETIME_STORAGE_TIMEZONE);
    }
    elseif (strtotime($value)) {
      $date = new DrupalDateTime($value, DATETIME_STORAGE_TIMEZONE);
    }

    if (isset($date) && !$date->hasErrors()) {
      $values['value'] = $date->format($this->storageFormat);
    }
    else {
      $values['value'] = '';
    }
  }

}
