<?php

namespace Drupal\icrp_custom_conditions\Plugin\Condition;

use Drupal\rules\Core\RulesConditionBase;

/**
 * Provides a 'Data comparison' condition.
 *
 * @Condition(
 *   id = "icrp_has_no_redirect",
 *   label = @Translation("Has No Redirect"),
 *   category = @Translation("ICRP")
 * )
 *
 * @todo: Add access callback information from Drupal 7.
 * @todo: Find a way to port rules_condition_data_is_operator_options() from Drupal 7.
 */
class HasNoRedirect extends RulesConditionBase {

  /**
   * Check for Redirect.
   *
   * @return bool
   *   Return true if the 'destination' query parameter exists.
   */
  protected function doEvaluate() {
      return !\Drupal::request()->query->has('destination');
  }
}
