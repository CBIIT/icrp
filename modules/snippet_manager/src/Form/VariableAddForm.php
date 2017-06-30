<?php

namespace Drupal\snippet_manager\Form;

use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Url;

/**
 * Form builder for 'Add variable" form.
 */
class VariableAddForm extends VariableFormBase {

  /**
   * {@inheritdoc}
   */
  public function form(array $form, FormStateInterface $form_state) {

    $form = parent::form($form, $form_state);

    $variable_definitions = $this->variableManager->getDefinitions();

    $options = [];
    foreach ($variable_definitions as $plugin_id => $definition) {
      $options[(string) $definition['category']][$plugin_id] = $definition['title'];
    }

    ksort($options);

    $form['plugin_id'] = [
      '#type' => 'select',
      '#title' => t('Type of the variable'),
      '#options' => $options,
      '#required' => TRUE,
    ];

    $form['name'] = [
      '#type' => 'machine_name',
      '#title' => t('Name of the variable'),
      '#machine_name' => [
        'exists' => [$this->entity, 'variableExists'],
      ],
      '#size' => 25,
      '#description' => t('Can only contain lowercase letters, numbers, and underscores.'),
      '#required' => TRUE,
    ];

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  protected function actionsElement(array $form, FormStateInterface $form_state) {
    $element = parent::actionsElement($form, $form_state);

    $element['submit']['#value'] = t('Save and continue');
    $element['delete']['#access'] = FALSE;

    return $element;
  }

  /**
   * {@inheritdoc}
   */
  public function save(array $form, FormStateInterface $form_state) {

    $variable = [
      'plugin_id' => $form_state->getValue('plugin_id'),
      'configuration' => [],
    ];

    $this->entity->setVariable(
      $form_state->getValue('name'),
      $variable
    );

    $result = $this->entity->save();

    drupal_set_message(t('The variable has been created.'));

    $redirect_url = Url::fromRoute(
      'snippet_manager.variable_edit_form',
      [
        'snippet' => $this->entity->id(),
        'variable' => $form_state->getValue('name'),
      ]
    );
    $form_state->setRedirectUrl($redirect_url);

    return $result;
  }

}
