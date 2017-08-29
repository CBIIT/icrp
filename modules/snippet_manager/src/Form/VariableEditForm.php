<?php

namespace Drupal\snippet_manager\Form;

use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Form\SubformState;
use Drupal\Core\Url;

/**
 * Form builder for "Edit variable" form.
 */
class VariableEditForm extends VariableFormBase {

  /**
   * {@inheritdoc}
   */
  public function form(array $form, FormStateInterface $form_state) {
    $form = parent::form($form, $form_state);

    $form['#title'] = $this->t(
      'Edit variable %variable',
      ['%variable' => $this->getVariableName()]
    );

    $form['#tree'] = TRUE;

    $form['configuration'] = [];
    $sub_form_state = SubformState::createForSubform($form['configuration'], $form, $form_state);
    $form['configuration'] = $this
      ->getPlugin()
      ->buildConfigurationForm($form['configuration'], $sub_form_state);

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function validateForm(array &$form, FormStateInterface $form_state) {
    parent::validateForm($form, $form_state);
    $sub_form_state = SubformState::createForSubform($form['configuration'], $form, $form_state);
    $this->getPlugin()->validateConfigurationForm($form['configuration'], $sub_form_state);
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    parent::submitForm($form, $form_state);
    $sub_form_state = SubformState::createForSubform($form['configuration'], $form, $form_state);
    $this->getPlugin()->submitConfigurationForm($form['configuration'], $sub_form_state);
  }

  /**
   * {@inheritdoc}
   */
  protected function actionsElement(array $form, FormStateInterface $form_state) {
    $element = parent::actionsElement($form, $form_state);

    $route_parameters = [
      'snippet' => $this->entity->id(),
      'variable' => $this->getVariableName(),
    ];

    $element['delete']['#url'] = Url::fromRoute('snippet_manager.variable_delete_form', $route_parameters);

    return $element;
  }

  /**
   * {@inheritdoc}
   */
  public function save(array $form, FormStateInterface $form_state) {
    $variable_name = $this->getVariableName();
    $variable = $this->entity->getVariable($variable_name);
    $variable['configuration'] = $this->plugin->getConfiguration();
    $this->entity->setVariable($variable_name, $variable);

    $result = $this->entity->save();

    drupal_set_message(t('The variable has been updated.'));

    $redirect_url = $this->entity->toUrl('template-edit-form');
    $form_state->setRedirectUrl($redirect_url);

    return $result;
  }

}
