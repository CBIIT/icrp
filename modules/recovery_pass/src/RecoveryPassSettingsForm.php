<?php
/**
 * @file
 * Contains \Drupal\recovery_pass\RecoveryPassSettingsForm
 */
namespace Drupal\recovery_pass;

use Drupal\Core\Form\ConfigFormBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Form\FormValidator;

/**
 * Configure recovery_pass settings for this site.
 */
class RecoveryPassSettingsForm extends ConfigFormBase {
  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'recovery_pass_admin_settings';
  }

  /**
   * {@inheritdoc}
   */
  protected function getEditableConfigNames() {
    return [
      'recovery_pass.settings',
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {
    $config = $this->config('recovery_pass.settings');

    $form['recovery_pass_help_text'] = array(
      '#type' => 'item',
      '#markup' => t('Edit the e-mail messages sent to users who request a new password. The list of available tokens that can be used in e-mails is provided below. For displaying new password please use <strong>[user_new_password]</strong> placeholder.'),
    );

    $form['recovery_pass_email_subject'] = array(
      '#type' => 'textfield',
      '#title' => t('Subject'),
      '#required' => TRUE,
      '#default_value' => $config->get('email_subject'),
    );

    $form['recovery_pass_email_body'] = array(
      '#type' => 'textarea',
      '#title' => t('Email Body'),
      '#required' => TRUE,
      '#default_value' => $config->get('email_body'),
    );

    if (\Drupal::moduleHandler()->moduleExists("htmlmail")) {
      // Adding description incase HTMLMAIL module exists.
      $form['recovery_pass_email_text']['#description'] = t('Supports HTML Mail provided HTMLMAIL module is enabled.');
    }

    if (\Drupal::moduleHandler()->moduleExists("token")) {
      $form['token_help'] = array(
        '#type' => 'markup',
        '#token_types' => array('user'),
        '#theme' => 'token_tree_link',
      );
    }

    $form['recovery_pass_old_pass_show'] = array(
      '#type' => 'checkbox',
      '#title' => t('Show Warning message to users for trying old password at login form.'),
      '#default_value' => $config->get('old_pass_show'),
    );

    $form['recovery_pass_old_pass_warning'] = array(
      '#type' => 'textarea',
      '#rows' => 2,
      '#title' => t('Old Password Warning Message'),
      '#description' => t('Warning message to be shown, if user after resetting the password uses the old password again.'),
      '#default_value' => $config->get('old_pass_warning'),
    );

    $form['recovery_pass_fpass_redirect'] = array(
      '#type' => 'textfield',
      '#title' => t('Redirect Path after Forgot Password Page'),
      '#maxlength' => 255,
      '#default_value' => $config->get('fpass_redirect'),
      '#description' => t('The path to redirect user, after forgot password form. This can be an internal Drupal path such as %add-node or an external URL such as %drupal. Enter %front to link to the front page.',
        array(
          '%front' => '<front>',
          '%add-node' => 'node/add',
          '%drupal' => 'http://drupal.org',
        )
      ),
      '#required' => TRUE,
      '#element_validate' => array('_recovery_pass_validate_path'),
    );

    $form['recovery_pass_expiry_period'] = array(
      '#type' => 'textfield',
      '#title' => t('Expiry Period'),
      '#description' => t('Please enter expiry period in weeks. After these many weeks the record for old password warning to be shown to that particular user would be deleted.'),
      '#default_value' => $config->get('expiry_period'),
      '#element_validate' =>  array('_recovery_pass_validate_integer_positive'),
    );

    return parent::buildForm($form, $form_state);
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    $config = $this->config('recovery_pass.settings');
    $config->set('email_subject', $form_state->getValue('recovery_pass_email_subject'))->save();
    $config->set('email_body', $form_state->getValue('recovery_pass_email_body'))->save();
    $config->set('old_pass_show', $form_state->getValue('recovery_pass_old_pass_show'))->save();
    $config->set('old_pass_warning', $form_state->getValue('recovery_pass_old_pass_warning'))->save();
    $config->set('fpass_redirect', $form_state->getValue('recovery_pass_fpass_redirect'))->save();
    $config->set('expiry_period', $form_state->getValue('recovery_pass_expiry_period'))->save();
    parent::submitForm($form, $form_state);
  }
}
