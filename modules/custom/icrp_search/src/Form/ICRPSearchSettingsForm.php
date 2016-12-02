<?php

/**
 * @file
 * Contains \Drupal\icrp_search\Form\TestAPISettingForm
 */

namespace Drupal\icrp_search\Form;

use Drupal\Core\Form\ConfigFormBase;
use Drupal\Core\Form\FormStateInterface;

/**
 * Provides the site configuration form.
 */
class ICRPSearchSettingsForm extends ConfigFormBase {

  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'icrp_search_settings_form';
     }

  /**
   * {@inheritdoc}
   */
  protected function getEditableConfigNames() {
    return ['icrp_search.settings'];
  }
  public function buildForm(array $form, FormStateInterface $form_state) {
    $config = $this->config('icrp_search.settings');

    $form['icrp_search_dbconfig'] = array(
      '#type' => 'fieldgroup',
      '#title' => $this->t('ICRP Search Database Configuration'),
    );
    $form['icrp_search_dbconfig']['icrp_search_hostname'] = array(
      '#type' => 'textfield',
      '#title' => $this->t('Database Hostname and Port'),
      '#default_value' => $config->get('icrp_search_hostname'),
      '#required' => TRUE,
      '#weight' => -20,
    );
    $form['icrp_search_dbconfig']['icrp_search_username'] = array(
      '#type' => 'textfield',
      '#title' => $this->t('Database Username'),
      '#default_value' => $config->get('icrp_search_username'),
      '#required' => TRUE,
      '#weight' => -20,
    );
    $form['icrp_search_dbconfig']['icrp_search_password'] = array(
      '#type' => 'textfield',
      '#title' => $this->t('Database Password'),
      '#default_value' => $config->get('icrp_search_password'),
      '#required' => TRUE,
      '#weight' => -20,
    );

    return parent::buildForm($form, $form_state);
  }
  public function submitForm(array &$form, FormStateInterface $form_state) {
    $this->config('icrp_search.settings')
            ->set('icrp_search_hostname', $form_state->getValue('icrp_search_hostname'));

    $this->config('icrp_search.settings')
            ->set('icrp_search_username', $form_state->getValue('icrp_search_username'));

    $this->config('icrp_search.settings')
            ->set('icrp_search_password', $form_state->getValue('icrp_search_password'));

    $this->config('icrp_search.settings')
            ->save();

    parent::submitForm($form, $form_state);
  }
}
?>
