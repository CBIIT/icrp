<?php

/**
 * @file
 * Contains \Drupal\faq\Form\GeneralForm.
 */

namespace Drupal\faq\Form;

use Drupal\Core\Form\ConfigFormBase;
use Drupal\Core\Form\FormStateInterface;

/**
 * Form for the FAQ settings page - general tab.
 */
class GeneralForm extends ConfigFormBase {

  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'faq_general_settings_form';
  }

  /**
   * {@inheritdoc}
   */
  protected function getEditableConfigNames() {
    return [];
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {
    $faq_settings = $this->config('faq.settings');

    $form['faq_title'] = array(
      '#type' => 'textfield',
      '#title' => $this->t('Title'),
      '#default_value' => $faq_settings->get('title')
    );

    $form['body_filter']['faq_description'] = array(
      '#type' => 'textarea',
      '#title' => $this->t('FAQ Description'),
      '#default_value' => $faq_settings->get('description'),
      '#description' => $this->t('Your FAQ description.  This will be placed at the top of the page, above the questions and can serve as an introductory text.'),
      '#rows' => 5
    );

    $form['faq_custom_breadcrumbs'] = array(
      '#type' => 'checkbox',
      '#title' => $this->t('Create custom breadcrumbs for the FAQ'),
      '#description' => $this->t('This option set the breadcrumb path to "%home > %faqtitle > category trail".', array(
        '%home' => $this->t('Home'),
        '%faqtitle' => $faq_settings->get('title')
        )
      ),
      '#default_value' => $faq_settings->get('custom_breadcrumbs')
    );

    return parent::buildForm($form, $form_state);
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    // Remove unnecessary values.
    $form_state->cleanValues();

    $this->configFactory()->getEditable('faq.settings')
      ->set('title', $form_state->getValue('faq_title'))
      ->set('description', $form_state->getValue('faq_description'))
      ->set('custom_breadcrumbs', $form_state->getValue('faq_custom_breadcrumbs'))
      ->save();

    parent::submitForm($form, $form_state);
  }

}
