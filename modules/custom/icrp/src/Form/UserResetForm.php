<?php
/**
 * @file
 * Contains \Drupal\icrp\Form\MyProfileForm.
 */
namespace Drupal\icrp\Form;

use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;
use \Drupal\icrp\Controller\ProfileUpdateController;

class UserResetForm extends FormBase
{

    /**
     * Constructs a UserAuth object.
     *
     * @param \Drupal\Core\Entity\EntityManagerInterface $entity_manager
     *   The entity manager.
     * @param \Drupal\Core\Password\PasswordInterface $password_checker
     *   The password service.
     */
    public function __construct() {
        //$uid = \Drupal::currentUser()->id();
        //drupal_set_message("uid: ".$uid);
        //$this->entityManager = \Drupal::service('entity_type.manager')->getStorage('user')->load($uid);
    }

    /**
     * {@inheritdoc}
     */

    public function getFormId()
    {
        return 'user_reset_form';
    }

    /**
     * {@inheritdoc}
     */
    public function buildForm(array $form, FormStateInterface $form_state)
    {
        $form['#theme'] = "user_reset_form";

        /* Password Form */

        $form['container']['name']['password'] = array(
            '#type' => 'details',
            '#title' => t('Reset Password'),
            '#open' => TRUE,
            '#attributes' => array(
                'class' => array(''),
            )
        );
        $form['container']['name']['password']['password_new'] = array(
            '#type' => 'password',
            '#title' => t('New Password'),
            '#default_value' => "",
        );
        $form['container']['name']['password']['password_confirm'] = array(
            '#type' => 'password',
            '#title' => t('Confirm New Password'),
            '#default_value' => "",
        );
        $markup = '<div class="description" id="edit-pass--description">To change the current user password, enter the new password in both fields.</div>';
        $form['container']['name']['password']['markup_password'] = array(
            '#type' => 'markup',
            '#markup' => t($markup),
        );

    $btn = '<div id="edit-actions" class="form-actions form-group js-form-wrapper form-wrapper" data-drupal-selector="edit-actions">
<button value="Log in" name="op" id="edit-submit" type="submit" class="button js-form-submit form-submit btn-primary btn icon-before" data-drupal-selector="edit-submit"><span aria-hidden="true" class="icon glyphicon glyphicon-log-in"></span>
    Log in</button>
</div>';
        $markup = $btn;

        $form['button'] = array(
            '#type' => 'markup',
            '#markup' => t($markup),
        );

        $form['actions']['#type'] = 'actions';
        $form['actions']['submit'] = array(
            '#type' => 'submit',
            '#value' => $this->t('Log in'),
            '#button_type' => 'primary',
        );


        return $form;
    }

    public function validateForm(array &$form, FormStateInterface $form_state)
    {

        //$profile = new ProfileUpdateController($this->passwordHasher, $user);
        //kint($profile);

        //drupal_set_message("validateForm");
        foreach ($form_state->getValues() as $key => $value) {
            //drupal_set_message($key . ': ' . $value);
        }
        $min_length = 7;
        /*
        drupal_set_message("form_state->getValue('password_new'): ".$form_state->getValue('password_new'));
        drupal_set_message("form_state->getValue('password_confirm'): ".$form_state->getValue('password_confirm'));
        drupal_set_message("length: ".strlen($form_state->getValue('password_new')));
        drupal_set_message("boolean:  ".(strlen($form_state->getValue('password_new')) < $min_length));
        if(7<$min_length) {
            drupal_set_message("7 is less than $min_length");
        }
        //$form_state->setErrorByName('password_new', $this->t('Password must have '.$min_length.' or more characters.'));
        */

        if (strlen($form_state->getValue('password_new')) > 0) {
            /* Check Password Length */
            $hasError = false;
            if(strlen($form_state->getValue('password_new')) < $min_length) {
                $form_state->setErrorByName('password_new', $this->t('Password must have '.$min_length.' or more characters.'));
                $hasError = true;

            }
            /* Check Password Confirmation */
            if (strcmp($form_state->getValue('password_new'), $form_state->getValue('password_confirm')) != 0) {
                $form_state->setErrorByName('password_confirm', $this->t('Passwords does not match.  Please confirm password.'));
                $hasError = true;
            }
            if($hasError) {
                // drupal_set_message("PASSWORD ERROR:  Let's do something", 'error');
                /*
                                $form['container']['name']['password'] = array(
                                    '#open' => TRUE,
                                    //'#title' => t('Change the title Change Password'),
                                    //'#collapsed' => FALSE,  // Added
                                );
                */

            }

        }

        // kint($form_state);
        //$newErrors = $form_state->hasAnyErrors();
        //drupal_set_message(print_r($newErrors, True));

    }

    public function submitForm(array &$form, FormStateInterface $form_state)
    {
/*
        $form_values = $form_state->getValues();

        $this->entityManager->set("field_first_name", $form_state->getValue('field_first_name'));
        $this->entityManager->set("field_last_name", $form_state->getValue('field_last_name'));
        $this->entityManager->setEmail($form_state->getValue('email'));
        foreach($this->subCommittees as $key => $field) {
            $this->entityManager->set($field, $form_values[$field]);
        }
        if (strlen($form_state->getValue('password_new')) > 0) {
            drupal_set_message("Your new password has been saved.");
            //drupal_set_message("NEW PASSWORD: ".$form_state->getValue('password_new'));
            $this->entityManager->setPassword($form_state->getValue('password_new'));
        }
        $this->entityManager->save();
*/
        foreach ($form_state->getValues() as $key => $value) {
             drupal_set_message($key . ': ' . $value);
        }

        drupal_set_message("Your new password has been saved.");

    }

}