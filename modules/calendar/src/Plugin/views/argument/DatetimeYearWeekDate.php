<?php

namespace Drupal\calendar\Plugin\views\argument;

use Drupal\datetime\Plugin\views\argument\Date as DateTimeDate;

/**
 * Argument handler for a day.
 *
 * @ViewsArgument("datetime_year_week")
 */
class DatetimeYearWeekDate extends DateTimeDate{

  /**
   * {@inheritdoc}
   */
  protected $argFormat = 'YW';

}
