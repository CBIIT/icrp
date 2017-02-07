<?php

namespace Drupal\clientside_validation;

use Drupal\Component\Plugin\PluginManagerInterface;
use Drupal\Component\Plugin\Discovery\CachedDiscoveryInterface;
use Drupal\Core\Form\FormStateInterface;

interface ValidatorManagerInterface extends PluginManagerInterface, CachedDiscoveryInterface {

  /**
   * Get validators for a form element.
   *
   * @param array $element
   *   The form element to get the validators for.
   * @param FormStateInterface $form_state
   *   The form state of the form this element belongs to.
   */
  public function getValidators(array $element, FormStateInterface $form_state);

}
