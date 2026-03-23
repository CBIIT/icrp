<?php

namespace Drupal\icrp\Form;

use Drupal\node\Entity\Node;
use Drupal\user\Entity\User;
use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

class UserReviewForm extends FormBase {

  public function getFormId() {
    return 'user_review_form';
  }

  public function buildForm(array $form, FormStateInterface $form_state) {

    $current_uri = \Drupal::request()->getRequestUri();
    $uri_parts = explode("/", $current_uri);
    $uuid = $uri_parts[2] ?? NULL;

    if (!$uuid) {
      throw new NotFoundHttpException('Missing user UUID.');
    }

    $entity = \Drupal::service('entity.repository')->loadEntityByUuid('user', $uuid);

    if (!$entity) {
      throw new NotFoundHttpException('User not found.');
    }

    /* Load User Data */
    $uid = (int) $entity->id();
    $user = \Drupal::entityTypeManager()->getStorage('user')->load($uid);

    if (!$user) {
      throw new NotFoundHttpException('User could not be loaded.');
    }

    $field_first_name = $user->get('field_first_name');
    $field_last_name = $user->get('field_last_name');

    /* Organization */
    $field_organization = $user->get("field_organization");
    $organization_title = '';

    $field_organization_nid = $field_organization->target_id ?? NULL;
    if ($field_organization_nid) {
      $node = Node::load($field_organization_nid);
      if ($node) {
        $organization_title = $node->label();
      }
    }

    $field_membership_status = $user->get('field_membership_status');

    /* Email */
    $email = $user->getEmail();

    /* Upload permission */
    $field_can_upload_library_files = $user->get("field_can_upload_library_files");
    $can_upload_library_files = $field_can_upload_library_files->value ?? 0;

    /* Library access */
    $field_library_access = $user->get("field_library_access");
    $library_access = array_map(function($record) {
      return $record['value'];
    }, $field_library_access->getValue());

    /* Status */
    $field_status = $user->get("status");
    $status = $field_status->value ?? 0;

    if (($field_membership_status->value ?? '') == "Registering") {
      $status = -1;
    }

    /* Roles */
    $roles = [];
    foreach (["manager", "partner"] as $role) {
      if ($user->hasRole($role)) {
        $roles[] = $role;
      }
    }

    /* ===== FORM ===== */

    $form['markup_password'] = [
      '#type' => 'markup',
      '#markup' => '<h1>User Review</h1>',
    ];

    $form['container']['name'] = [
      '#type' => 'fieldset',
      '#title' => $this->t('User Info'),
      '#prefix' => '<div class="col-sm-6">',
      '#suffix' => '</div>',
    ];

    $form['container']['name']['first_name'] = [
      '#type' => 'textfield',
      '#title' => $this->t('First Name:'),
      '#default_value' => $field_first_name->value ?? '',
      '#disabled' => TRUE,
    ];

    $form['container']['name']['last_name'] = [
      '#type' => 'textfield',
      '#title' => $this->t('Last Name:'),
      '#default_value' => $field_last_name->value ?? '',
      '#disabled' => TRUE,
    ];

    $form['container']['name']['organization'] = [
      '#type' => 'textfield',
      '#title' => $this->t('Organization'),
      '#default_value' => $organization_title,
      '#disabled' => TRUE,
    ];

    $form['container']['name']['email'] = [
      '#type' => 'email',
      '#title' => $this->t('Email:'),
      '#default_value' => $email,
      '#disabled' => TRUE,
    ];

    /* Right side */
    $form['container2'] = [
      '#type' => 'container',
      '#prefix' => '<div class="col-sm-6">',
      '#suffix' => '</div>',
    ];

    $form['container2']['settings'] = [
      '#type' => 'fieldset',
      '#title' => $this->t('User Settings'),
    ];

    $form['container2']['settings']['status'] = [
      '#type' => 'radios',
      '#title' => 'Status',
      '#options' => [
        0 => $this->t('Blocked'),
        1 => $this->t('Active'),
      ],
      '#default_value' => $status,
    ];

    $form['container2']['settings']['roles'] = [
      '#type' => 'checkboxes',
      '#title' => 'Roles',
      '#options' => [
        'manager' => $this->t('Manager'),
        'partner' => $this->t('Partner'),
      ],
      '#default_value' => $roles,
    ];

    $form['container2']['settings']['library_access'] = [
      '#type' => 'checkboxes',
      '#title' => 'Library Access',
      '#options' => [
        'general' => $this->t('General'),
        'finance' => $this->t('Finance'),
        'operations_and_contracts' => $this->t('Operations and Contracts'),
      ],
      '#default_value' => $library_access,
    ];

    $form['container2']['settings']['upload_files'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Can Upload Library Files'),
      '#default_value' => $can_upload_library_files,
    ];

    $form['container2']['settings']['actions']['#type'] = 'actions';
    $form['container2']['settings']['actions']['submit'] = [
      '#type' => 'submit',
      '#value' => $this->t('Save'),
      '#button_type' => 'primary',
    ];

    return $form;
  }

  public function validateForm(array &$form, FormStateInterface $form_state) {
    $values = $form_state->getValues();

    if (!array_filter($values['roles'])) {
      $form_state->setErrorByName('roles', $this->t('User needs at least one role.'));
    }

    if ($values['status'] < 0) {
      $form_state->setErrorByName('status', $this->t('Select a valid status.'));
    }
  }

  public function submitForm(array &$form, FormStateInterface $form_state) {

    $values = $form_state->getValues();

    $current_uri = \Drupal::request()->getRequestUri();
    $uri_parts = explode("/", $current_uri);
    $uuid = $uri_parts[2] ?? NULL;

    $entity = \Drupal::service('entity.repository')->loadEntityByUuid('user', $uuid);
    if (!$entity) {
      throw new NotFoundHttpException();
    }

    $user = \Drupal::entityTypeManager()->getStorage('user')->load($entity->id());
    if (!$user) {
      throw new NotFoundHttpException();
    }

    /* Reset roles */
    $user->removeRole('manager');
    $user->removeRole('partner');

    foreach ($values['roles'] as $role) {
      if ($role === "manager") {
        $user->addRole("manager");
      }
      if ($role === "partner") {
        $user->addRole("partner");
      }
    }

    $membership_status = ($values['status'] == 0) ? 'Blocked' : 'Active';

    $user->set("field_membership_status", $membership_status);
    $user->set("field_can_upload_library_files", $values['upload_files']);
    $user->set("status", $values['status']);

    $library_access = array_filter(array_values($values['library_access']));
    $user->set("field_library_access", $library_access);

    $user->save();

    \Drupal::messenger()->addStatus(
      "User account for " . $user->getDisplayName() . " has been saved and is currently " . strtolower($membership_status) . "."
    );
  }
}
