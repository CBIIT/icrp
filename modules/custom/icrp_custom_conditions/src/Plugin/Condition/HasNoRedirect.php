<?php

namespace Drupal\icrp_custom_conditions\Plugin\Condition;

use Drupal\Core\Condition\ConditionPluginBase;

/**
 * Provides a 'Has No Redirect' condition.
 *
 * @Condition(
 *   id = "icrp_has_no_redirect",
 *   label = @Translation("Has No Redirect"),
 *   category = @Translation("ICRP")
 * )
 */
class HasNoRedirect extends ConditionPluginBase {

  /**
   * Evaluates the condition.
   *
   * @return bool
   *   TRUE when there is no destination query parameter.
   */
  public function evaluate() {
    return !\Drupal::request()->query->has('destination');
  }

  /**
   * Summary shown in block UI.
   */
  public function summary() {
    return $this->t('Checks whether the destination query parameter is absent.');
  }

}
