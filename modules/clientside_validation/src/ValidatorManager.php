<?php

namespace Drupal\clientside_validation;

use Drupal\Core\Plugin\DefaultPluginManager;
use Drupal\Core\Cache\CacheBackendInterface;
use Drupal\Core\Extension\ModuleHandlerInterface;
use Drupal\Core\Form\FormStateInterface;

/**
 * Validator plugin manager.
 */
class ValidatorManager extends DefaultPluginManager implements ValidatorManagerInterface {

  /**
   * Constructs an ValidatorManager object.
   *
   * @param \Traversable $namespaces
   *   An object that implements \Traversable which contains the root paths
   *   keyed by the corresponding namespace to look for plugin implementations,
   * @param \Drupal\Core\Cache\CacheBackendInterface $cache_backend
   *   Cache backend instance to use.
   * @param \Drupal\Core\Extension\ModuleHandlerInterface $module_handler
   *   The module handler to invoke the alter hook with.
   */
  public function __construct(\Traversable $namespaces, CacheBackendInterface $cache_backend, ModuleHandlerInterface $module_handler) {
    parent::__construct('Plugin/CvValidator', $namespaces, $module_handler, 'Drupal\clientside_validation\CvValidatorInterface', 'Drupal\clientside_validation\Annotation\CvValidator');
    $this->alterInfo('clientside_validation_validator_info');
    $this->setCacheBackend($cache_backend, 'clientside_validation_validators');
  }

  /**
   * {@inheritdoc}
   */
  public function getValidators(array $element, FormStateInterface $form_state) {
    $instances = [];
    $validators = $this->getDefinitionsForElement($element, $form_state);
    foreach ($validators as $validator) {
      $instances[] = $this->createInstance($validator['id']);

    }
    return $instances;
  }

  /**
   * Get plugin definitions that apply to a form element.
   *
   * @param array $element
   *   The form element to get the validators for.
   * @param FormStateInterface $form_state
   *   The form state of the form this element belongs to.
   *
   * @return array
   *   The plugin definitions that support this element.
   */
  protected function getDefinitionsForElement(array $element, FormStateInterface $form_state) {
    $validators = $this->getDefinitions();
    $element_validators = [];
    foreach ($validators as $validator) {
      if (isset($element['#type']) && in_array($element['#type'], $validator['supports']['types'])) {
        $element_validators[$validator['id']] = $validator;
      }
      foreach ($validator['supports']['attributes'] as $attribute) {
        if (isset($element['#' . $attribute]) || isset($element['#attributes'][$attribute])) {
          $element_validators[$validator['id']] = $validator;
          continue;
        }
      }
    }
    return $element_validators;
  }
}
