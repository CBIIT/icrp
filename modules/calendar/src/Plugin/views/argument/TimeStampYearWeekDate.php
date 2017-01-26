<?php

namespace Drupal\calendar\Plugin\views\argument;


use Drupal\views\Plugin\views\argument\Date as NumericDate;

/**
 * Argument handler for a day.
 *
 * @ViewsArgument("date_year_week")
 */
class TimeStampYearWeekDate extends NumericDate{

  /**
   * {@inheritdoc}
   */
  protected $argFormat = 'YW';

}
