<?php

namespace Drupal\snippet_manager\Form;

use Drupal\Core\Form\FormStateInterface;

/**
 * Form builder for 'Delete variable' form.
 */
class VariableDeleteForm extends VariableFormBase {

  /**
   * {@inheritdoc}
   */
  public function form(array $form, FormStateInterface $form_state) {

    $form = parent::form($form, $form_state);

    $form['#title'] = t(
      'Are you sure you want to delete the variable %title?',
      ['%title' => $this->getVariableName()]
    );

    $form['#attributes']['class'][] = 'confirmation';
    $form['description'] = [
      '#markup' => t('This action cannot be undone.'),
    ];

    $form['name'] = [
      '#type' => 'value',
      '#value' => $this->getVariableName(),
    ];

    if (!isset($form['#theme'])) {
      $form['#theme'] = 'confirm_form';
    }

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  protected function actionsElement(array $form, FormStateInterface $form_state) {
    $element = parent::actionsElement($form, $form_state);

    $element['submit']['#value'] = t('Delete');
    $element['delete']['#access'] = FALSE;

    $element['cancel'] = [
      '#type' => 'link',
      '#title' => t('Cancel'),
      '#attributes' => ['class' => ['button']],
      '#url' => $this->entity->toUrl('edit-form'),
      '#weight' => 10,
    ];

    return $element;
  }

  /**
   * {@inheritdoc}
   */
  public function buildEntity(array $form, FormStateInterface $form_state) {
    /** @var \Drupal\snippet_manager\Entity\Snippet $entity */
    $entity = parent::buildEntity($form, $form_state);
    $entity->removeVariable($form_state->getValue('name'));
    return $entity;
  }

  /**
   * {@inheritdoc}
   */
  public function save(array $form, FormStateInterface $form_state) {

    $this->entity->removeVariable($form_state->getValue('name'));

    $result = $this->entity->save();

    drupal_set_message(t('The variable has been removed.'));

    $redirect_url = $this->entity->toUrl('template-edit-form');
    $form_state->setRedirectUrl($redirect_url);

    return $result;
  }

}
