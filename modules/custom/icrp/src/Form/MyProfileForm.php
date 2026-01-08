<?php

/**
 * @file
 * Contains \Drupal\icrp\Form\MyProfileForm.
 */

namespace Drupal\icrp\Form;

use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\user\Entity\User;
use Drupal\Core\Datetime\TimeZoneFormHelper;
use Drupal\Core\StringTranslation\StringTranslationTrait;

/**
 * Form for editing the current user's profile.
 */
class MyProfileForm extends FormBase {

  use StringTranslationTrait;

  /**
   * The subcommittees fields.
   *
   * @var array
   */
  protected $subCommittees = [
    "field_subcommittee_partner_news",
    "field_subcommittee_funding",
    "field_subcommittee_annual_meetin",
    "field_subcommittee_membership",
    "field_subcommittee_cso_coding",
    "field_subcommittee_evaluation",
    "field_subcommittee_partner_opera",
    "field_subcommittee_web_site",
  ];

  /**
   * The notification fields.
   *
   * @var array
   */
  protected $notifications = [
    "field_notify_new_posts",
    "field_notify_new_events",
  ];

  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'my_profile_form';
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {
    $user = User::load($this->currentUser()->id());

    $form['container'] = [
      '#type' => 'container',
      '#attributes' => ['class' => ['form--inline', 'clearfix', 'form-group']],
    ];

    $form['container']['name'] = [
      '#type' => 'fieldset',
      '#title' => $this->t('User Info'),
      '#prefix' => '<div class="col-sm-6">',
      '#suffix' => '</div>',
    ];

    $form['container']['name']['field_first_name'] = [
      '#type' => 'textfield',
      '#title' => $this->t('First Name'),
      '#default_value' => $user->get('field_first_name')->value,
      '#required' => TRUE,
    ];

    $form['container']['name']['field_last_name'] = [
      '#type' => 'textfield',
      '#title' => $this->t('Last Name'),
      '#default_value' => $user->get('field_last_name')->value,
      '#required' => TRUE,
    ];

    $form['container']['name']['email'] = [
      '#type' => 'email',
      '#title' => $this->t('Email'),
      '#default_value' => $user->getEmail(),
      '#required' => TRUE,
    ];

    $form['container']['name']['timezone'] = [
      '#type' => 'select',
      '#title' => $this->t('Time zone'),
      '#default_value' => $user->getTimeZone() ?: \Drupal::config('system.date')->get('timezone.default'),
      '#options' => TimeZoneFormHelper::getOptionsList(),
      '#description' => $this->t('Select the desired local time and time zone. Dates and times throughout this site will be displayed using this time zone.'),
      '#required' => TRUE,
    ];

    /* Password Section */
    $form['container']['name']['password'] = [
      '#type' => 'details',
      '#title' => $this->t('Change Password'),
      '#open' => TRUE,
    ];

    $form['container']['name']['password']['password_new'] = [
      '#type' => 'password',
      '#title' => $this->t('New Password'),
      '#default_value' => '',
    ];

    $form['container']['name']['password']['password_confirm'] = [
      '#type' => 'password',
      '#title' => $this->t('Confirm New Password'),
      '#default_value' => '',
    ];

    $form['container']['name']['password']['markup_password'] = [
      '#type' => 'markup',
      '#markup' => '<div class="description" id="edit-pass--description">' . $this->t('To change the current user password, enter the new password in both fields.') . '</div>',
    ];

    /* Notification Settings */
    $form['container']['notify'] = [
      '#type' => 'fieldset',
      '#title' => $this->t('Notification Settings'),
      '#prefix' => '<div class="col-sm-6">',
      '#suffix' => '</div>',
    ];

    foreach ($this->notifications as $field_notify) {
      $form['container']['notify'][$field_notify] = [
        '#type' => 'checkbox',
        '#title' => $user->get($field_notify)->getFieldDefinition()->getLabel(),
        '#description' => $user->get($field_notify)->getFieldDefinition()->getDescription(),
        '#default_value' => (int) $user->get($field_notify)->value,
      ];
    }

    /* Committees */
    $form['container']['committee'] = [
      '#type' => 'fieldset',
      '#title' => $this->t('ICRP Committees and Forums'),
      '#prefix' => '<div class="col-sm-6" style="margin-top:20px;">',
      '#suffix' => '</div>',
    ];

    foreach ($this->subCommittees as $field_subcommittee) {
      $form['container']['committee'][$field_subcommittee] = [
        '#type' => 'checkbox',
        '#title' => $user->get($field_subcommittee)->getFieldDefinition()->getLabel(),
        '#description' => $user->get($field_subcommittee)->getFieldDefinition()->getDescription(),
        '#default_value' => (int) $user->get($field_subcommittee)->value,
      ];
    }

    $form['actions']['#type'] = 'actions';
    $form['actions']['submit'] = [
      '#type' => 'submit',
      '#value' => $this->t('Save'),
      '#button_type' => 'primary',
    ];

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function validateForm(array &$form, FormStateInterface $form_state) {
    $min_length = 7;

    if (!empty($form_state->getValue('password_new'))) {
      if (strlen($form_state->getValue('password_new')) < $min_length) {
        $form_state->setErrorByName('password_new', $this->t('Password must have @min or more characters.', ['@min' => $min_length]));
      }

      if ($form_state->getValue('password_new') !== $form_state->getValue('password_confirm')) {
        $form_state->setErrorByName('password_confirm', $this->t('Passwords do not match. Please confirm password.'));
      }
    }
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    $user = User::load($this->currentUser()->id());

    $user->set('field_first_name', $form_state->getValue('field_first_name'));
    $user->set('field_last_name', $form_state->getValue('field_last_name'));
    $user->setEmail($form_state->getValue('email'));
    $user->set('timezone', $form_state->getValue('timezone'));

    foreach ($this->notifications as $field) {
      $user->set($field, $form_state->getValue($field));
    }

    foreach ($this->subCommittees as $field) {
      $user->set($field, $form_state->getValue($field));
    }

    if (!empty($form_state->getValue('password_new'))) {
      $user->setPassword($form_state->getValue('password_new'));
      $this->messenger()->addStatus($this->t('Your new password has been saved.'));
    }

    $user->save();

    $this->messenger()->addStatus($this->t('Your profile changes have been saved.'));
  }

}