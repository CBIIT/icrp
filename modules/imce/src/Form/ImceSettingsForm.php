<?php

namespace Drupal\imce\Form;

use Drupal\Core\Form\ConfigFormBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\StreamWrapper\StreamWrapperInterface;
use Drupal\Component\Utility\Html;
use Drupal\user\RoleInterface;

/**
 * Imce settings form.
 */
class ImceSettingsForm extends ConfigFormBase {

  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'imce_settings_form';
  }

  /**
   * {@inheritdoc}
   */
  protected function getEditableConfigNames() {
    return array('imce.settings');
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {
    $config = $this->config('imce.settings');
    $form['roles_profiles'] = $this->buildRolesProfilesTable($config->get('roles_profiles', array()));
    // Common settings container
    $form['common'] = array(
      '#type' => 'details',
      '#title' => $this->t('Common settings'),
    );
    $form['common']['abs_urls'] = array(
      '#type' => 'checkbox',
      '#title' => t('Enable absolute URLs'),
      '#description' => t('Make the file manager return absolute file URLs to other applications.'),
      '#default_value' => $config->get('abs_urls'),
    );
    $form['#attached']['library'][] = 'imce/drupal.imce.admin';
    return parent::buildForm($form, $form_state);
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    $config = $this->config('imce.settings');
    // Absolute URLs
    $config->set('abs_urls', $form_state->getValue('abs_urls'));
    // Role-profile assignments.
    $old_roles_profiles = $config->get('roles_profiles');
    $roles_profiles = $form_state->getValue('roles_profiles');
    // Filter empty values
    foreach ($roles_profiles as $rid => &$profiles) {
      if (!$profiles = array_filter($profiles)) {
        unset($roles_profiles[$rid]); 
      }
    }
    $config->set('roles_profiles', $roles_profiles);
    $config->save();
    // Warn about anonymous access
    if (!empty($roles_profiles[RoleInterface::ANONYMOUS_ID])) {
      drupal_set_message(t('You have enabled anonymous access to the file manager. Please make sure this is not a misconfiguration.'), 'warning');
    }
    parent::submitForm($form, $form_state);
  }

  /**
   * Returns roles-profiles table.
   */
  public function buildRolesProfilesTable(array $roles_profiles) {
    $rp_table = array('#type' => 'table');
    // Prepare roles. Reverse the role order to prioritize the permissive ones.
    $roles = array_reverse(user_roles());
    $wrappers = \Drupal::service('stream_wrapper_manager')->getNames(StreamWrapperInterface::WRITE_VISIBLE);
    // Prepare profile options
    $options = array('' => '-' . $this->t('None') . '-');
    foreach (\Drupal::entityTypeManager()->getStorage('imce_profile')->loadMultiple() as $pid => $profile) {
      $options[$pid] = $profile->label();
    }
    // Build header
    $imce_url = \Drupal::url('imce.page');
    $rp_table['#header'] = array($this->t('Role'));
    $default = file_default_scheme();
    foreach ($wrappers as $scheme => $name) {
      $url = $scheme === $default ? $imce_url : $imce_url . '/' . $scheme;
      $rp_table['#header'][]['data'] = array('#markup' => '<a href="' . $url . '">' . Html::escape($name) . '</a>');
    }
    // Build rows
    foreach ($roles as $rid => $role) {
      $rp_table[$rid]['role_name'] = array(
        '#plain_text' => $role->label(),
      );
      foreach ($wrappers as $scheme => $name) {
        $rp_table[$rid][$scheme] = array(
          '#type' => 'select',
          '#options' => $options,
          '#default_value' => isset($roles_profiles[$rid][$scheme]) ? $roles_profiles[$rid][$scheme] : '',
        );
      }
    }
    // Add description
    $rp_table['#prefix'] = '<h3>' . $this->t('Role-profile assignments') . '</h3>';
    $rp_table['#suffix'] = '<div class="description">' . $this->t('Assign configuration profiles to user roles for available file systems. The default file system %name is accessible at :url path.', array('%name' => $wrappers[file_default_scheme()], ':url' => $imce_url)) . '</div>';
    return $rp_table;
  }

}
