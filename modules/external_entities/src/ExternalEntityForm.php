<?php

/**
 * @file
 * Definition of Drupal\external_entities\ExternalEntityForm.
 */

namespace Drupal\external_entities;

use Drupal\Core\Entity\ContentEntityForm;
use Drupal\Core\Form\FormStateInterface;

/**
 * Form controller for the node edit forms.
 */
class ExternalEntityForm extends ContentEntityForm {

  /**
   * {@inheritdoc}
   */
  public function form(array $form, FormStateInterface $form_state) {
    if ($this->operation == 'edit') {
      $form['#title'] = $this->t('<em>Edit @type</em> @title', array('@type' => $this->entityManager->getStorage($this->entity->getEntityType()->getBundleEntityType())->load($this->entity->bundle())->label(), '@title' => $this->entity->label()));
    }
    return parent::form($form, $form_state);
  }

  /**
   * {@inheritdoc}
   */
  public function save(array $form, FormStateInterface $form_state) {
    parent::save($form, $form_state);
    $external_entity = $this->entity;
    if ($external_entity->access('view')) {
      $form_state->setRedirect(
        'entity.external_entity.canonical',
        array('external_entity' => $external_entity->id())
      );
    }
    else {
      $form_state->setRedirect('<front>');
    }
  }

}
