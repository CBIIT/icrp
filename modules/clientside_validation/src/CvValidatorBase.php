<?php

namespace Drupal\clientside_validation;

use Drupal\Component\Plugin\PluginBase;
use Drupal\Component\Serialization\Json;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Component\Utility\Unicode;
use Drupal\Core\StringTranslation\StringTranslationTrait;
use Drupal\Component\Utility\NestedArray;

abstract class CvValidatorBase extends PluginBase implements CvValidatorInterface {
  use StringTranslationTrait;

  /**
   * {@inheritdoc}
   */
  public function getName() {
    return $this->pluginDefinition['name'];
  }

  /**
   * Get the validation rules for this form element.
   *
   * @return array
   *   An array with following keys:
   *     - rules: An array with the rulename as key and the rule arguments as
   *       value.
   *     - messages: An array with the rulename as key and the message for this
   *       rule as argument.
   */
  abstract protected function getRules($element, FormStateInterface $form_state);

  /**
   * {@inheritdoc}
   */
  public function addValidation(array &$element, FormStateInterface $form_state) {
    $rules = $this->getRules($element, $form_state);
    if (isset($rules['rules'])) {
      foreach ($rules['rules'] as $rulename => $rulearg) {
        $element['#attributes']['data-rule-' . Unicode::strtolower($rulename)] = is_object($rulearg) || is_array($rulearg) ? Json::encode($rulearg) : $rulearg;
      }
    }
    if (isset($rules['messages'])) {
      foreach ($rules['messages'] as $rulename => $message) {
        $element['#attributes']['data-msg-' . Unicode::strtolower($rulename)] = $message;
      }
    }
    if (isset($rules['messages']) || isset($rules['rules'])) {
      if (!isset($element['#attached'])) {
        $element['#attached'] = [];
      }
      $element['#attached'] = NestedArray::mergeDeep($element['#attached'], $this->getPluginDefinition()['attachments']);
    }
  }

  /**
   * Get the value of an attribute of an element.
   *
   * @param array $element
   *   The element to get the attribute from.
   * @param string $attribute
   *   The attribute of which to get the value.
   *
   * @return mixed
   *   The attribute value.
   */
  protected function getAttributeValue(array $element, $attribute) {
    return isset($element['#' . $attribute]) ?
        $element['#' . $attribute]
        : (isset($element['#attributes'][$attribute]) ? $element['#attributes'][$attribute] : NULL);
  }

  protected function getElementTitle(array $element, $default = 'This field') {
    $title = $this->getAttributeValue($element, 'title');
    return $title ? $title : t($default);
  }

}
