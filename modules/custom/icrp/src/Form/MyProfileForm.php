<?php
/**
 * @file
 * Contains \Drupal\icrp\Form\MyProfileForm.
 */
namespace Drupal\icrp\Form;

use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;
use \Drupal\icrp\Controller\ProfileUpdateController;

//use Drupal\Core\Entity\EntityManagerInterface;
use Drupal\Core\Password\PasswordInterface;

//use Symfony\Component\HttpFoundation\JsonResponse;
use Drupal\Core\Password\PhpassHashedPassword;
//use Drupal\Core\Password\PasswordInterface;


class MyProfileForm extends FormBase
{

    /**
     * The entity manager.
     *
     * @var \Drupal\Core\Entity\EntityManagerInterface
     */
    protected $entityManager;

    /**
     * The password hashing service.
     *
     * @var \Drupal\Core\Password\PasswordInterface
     */
    protected $passwordHasher;

    /**
     * @var array of subCommittees
     */
    protected $passwordSubcommitties;
    /**
     * Constructs a UserAuth object.
     *
     * @param \Drupal\Core\Entity\EntityManagerInterface $entity_manager
     *   The entity manager.
     * @param \Drupal\Core\Password\PasswordInterface $password_checker
     *   The password service.
     */
    public function __construct() {
        $uid = \Drupal::currentUser()->id();
        $this->entityManager = \Drupal::service('entity_type.manager')->getStorage('user')->load($uid);
        $this->passwordHasher = new PhpassHashedPassword(1);
        /* TODO: Search PEOPLE fields for field_subcommittee* then populate the array below */
        /* Get ICRP Subcommittees */
        /*
         *
New Fields
    Annual meetings
    Communications and Membership
    CSO and Coding
    Evaluations and Analyses
    Partner Operations
    Website and Database

x(keep)         Annual Meeting
x(del)          Data Report & Data Quality
x(Change title) Evaluation & Outcomes
x(add)         CSO and Coding
x(del)         External Communcations
x(del)         Internal Communications
(del)         Membership
(keep)         Partner Operations
(Change Title) Site & Database

         */
        $this->subCommittees = array(
            "field_subcommittee_partner_news",
            "field_subcommittee_annual_meetin",
            "field_subcommittee_membership",
            "field_subcommittee_cso_coding",
            "field_subcommittee_evaluation",
            "field_subcommittee_partner_opera",
            "field_subcommittee_web_site",
        );
        $this->notifications = array(
            "field_notify_new_posts",
            //"field_notify_new_events",
        );

    }

/*
function system_user_timezone(&$form, FormStateInterface $form_state) {
  $user = \Drupal::currentUser();

  $account = $form_state->getFormObject()->getEntity();
  $form['timezone'] = [
    '#type' => 'details',
    '#title' => t('Locale settings'),
    '#open' => TRUE,
    '#weight' => 6,
  ];
  $form['timezone']['timezone'] = [
    '#type' => 'select',
    '#title' => t('Time zone'),
    '#default_value' => $account->getTimezone() ? $account->getTimezone() : \Drupal::config('system.date')->get('timezone.default'),
    '#options' => system_time_zones($account->id() != $user->id()),
    '#description' => t('Select the desired local time and time zone. Dates and times throughout this site will be displayed using this time zone.'),
  ];
  $user_input = $form_state->getUserInput();
  if (!$account->getTimezone() && $account->id() == $user->id() && empty($user_input['timezone'])) {
    $form['timezone']['#attached']['library'][] = 'core/drupal.timezone';
    $form['timezone']['timezone']['#attributes'] = ['class' => ['timezone-detect']];
  }
}
*/

    /**
     * {@inheritdoc}
     */

    public function getFormId()
    {
        return 'my_profile_form_old';
    }

    /**
     * {@inheritdoc}
     */
    public function buildForm(array $form, FormStateInterface $form_state)
    {
        $user = $this->entityManager;

        $form['#theme'] = "my_profile_form_old";

        $form['container'] = array(
            '#type' => 'container',
            '#attributes' => array(
                'class' => array('form--inline clearfix form-group'),
            )
        );

        $form['container']['name'] = array(
            '#type' => 'fieldset',
            '#title' => t('User Info'),
            '#prefix' => '<div class="col-sm-6">',
            '#suffix' => '</div>',
            '#attributes' => array(
                'class' => array(''),
            )
        );

        $form['container']['name']['field_first_name'] = array(
            '#type' => 'textfield',
            '#title' => t('First Name'),
            '#default_value' => $user->get('field_first_name')->value,
            '#required' => TRUE,
            '#attributes' => array(
                'class' => array(''),
            )
        );
        $form['container']['name']['field_last_name'] = array(
            '#type' => 'textfield',
            '#title' => t('Last Name'),
            '#default_value' =>  $user->get('field_last_name')->value,
            '#required' => TRUE,
        );
        $form['container']['name']['email'] = array(
            '#type' => 'email',
            '#title' => t('Email'),
            '#default_value' => $user->getEmail(),
            '#required' => TRUE,
        );
        
  //$user = \Drupal::currentUser();
/*
  $account = $form_state->getFormObject()->getEntity();
  $form['timezone'] = [
    '#type' => 'details',
    '#title' => t('Locale settings'),
    '#open' => TRUE,
    '#weight' => 6,
  ];
  $form['timezone']['timezone'] = [
    '#type' => 'select',
    '#title' => t('Time zone'),
    '#default_value' => $account->getTimezone() ? $account->getTimezone() : \Drupal::config('system.date')->get('timezone.default'),
    '#options' => system_time_zones($account->id() != $user->id()),
    '#description' => t('Select the desired local time and time zone. Dates and times throughout this site will be displayed using this time zone.'),
  ];
  $user_input = $form_state->getUserInput();
  if (!$account->getTimezone() && $account->id() == $user->id() && empty($user_input['timezone'])) {
    $form['timezone']['#attached']['library'][] = 'core/drupal.timezone';
    $form['timezone']['timezone']['#attributes'] = ['class' => ['timezone-detect']];
  }
*/
        /* Password Form */
        $form['container']['name']['password'] = array(
            '#type' => 'details',
            '#title' => t('Change Password'),
            '#open' => TRUE,
            '#attributes' => array(
                'class' => array(''),
            )
        );
/*
        $form['container']['name']['password']['password_current'] = array(
            '#type' => 'password',
            '#title' => t('Current Password'),
            '#default_value' =>"",
        );
        $markup = '<div class="description" style="padding-bottom:25px;">
        Required if you want to change the <em class="placeholder">Email address</em> or <em class="placeholder">Password</em> below. <a title="Send password reset instructions via email." href="/user/password">Reset your password</a>.
    </div>';
        $form['container']['name']['password']['markup_reset'] = array(
            '#type' => 'markup',
            '#markup' => t($markup),
            '#attributes' => array(
                'class' => array(''),
            )
        );
*/
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

        /* Notification Settings */
        $form['container']['notify'] = array(
            '#type' => 'fieldset',
            '#prefix' => '<div class="col-sm-6">',
            '#suffix' => '</div>',
            '#title' => 'Notification Settings',
        );

        //kint($user);

        /* Notifications */
        foreach($this->notifications as $key => $field_notify) {
            $form['container']['notify'][$field_notify] = array(
                '#type' => 'checkbox',
                '#prefix' => '<div title="'.t($user->get($field_notify)->getFieldDefinition()->getDescription()).'">',
                '#suffix' => '</div>',
                '#title' => t($user->get($field_notify)->getFieldDefinition()->getLabel()),
                '#default_value' => (int)$user->get($field_notify)->value,
                '#attributes' => array(
                    'id' => array($field_notify),
                    'title' => array(t($user->get($field_notify)->getFieldDefinition()->getLabel())),
                )

            );
        }

        /* Container Committee */
        $form['container']['committee'] = array(
            '#type' => 'fieldset',
            '#prefix' => '<div class="col-sm-6"  style="margin-top:20px;">',
            '#suffix' => '</div>',
            '#title' => 'ICRP Subcommittees',
        );

        /* COMMITTEE */
        foreach($this->subCommittees as $key => $field_subcommittee) {
            $form['container']['committee'][$field_subcommittee] = array(
                '#type' => 'checkbox',
                '#prefix' => '<div title="'.t($user->get($field_subcommittee)->getFieldDefinition()->getDescription()).'">',
                '#suffix' => '</div>',
                '#title' => t($user->get($field_subcommittee)->getFieldDefinition()->getLabel()),
                '#default_value' => (int)$user->get($field_subcommittee)->value,
                '#attributes' => array(
                    'id' => array($field_subcommittee),
                )

            );
        }
        $form['actions']['#type'] = 'actions';
        $form['actions']['submit'] = array(
            '#type' => 'submit',
            '#value' => $this->t('Save'),
            '#button_type' => 'primary',
        );

        return $form;
    }

    public function validateForm(array &$form, FormStateInterface $form_state)
    {
        //$user = $this->entityManager;

        //$profile = new ProfileUpdateController($this->passwordHasher, $user);
        //kint($profile);

        //drupal_set_message("validateForm");
        foreach ($form_state->getValues() as $key => $value) {
            //drupal_set_message($key . ': ' . $value);
        }
        /*
        $password_current = $form_state->getValue('password_current');
        drupal_set_message("password_current: ".$password_current);
        $password_new = $form_state->getValue('password_new');
        $password_confirm = $form_state->getValue('password_confirm');
        $md5HashedPassword = 'U'.$this->passwordHasher->hash(md5($password_current));
        $password_check = $this->passwordHasher->check($password_current, $md5HashedPassword);
        $check = ($password_check) ? 'true' : 'false';


        drupal_set_message("password_check : ".$check);

        if($password_check) {
            drupal_set_message("Password id GOOD: ".$check);
        } else {
            drupal_set_message("Password is BAD: ".$check, 'error');

        }
        */
        /* Check to see if e-mail has changed.  If so then Password is required */
        /*
        drupal_set_message("New Email: ".$form_state->getValue('email'));
        drupal_set_message("Stored Email: ".$user->getEmail());
        drupal_set_message("Stored Password:     ".$user->getPassword());
        //$hashedPassword = $this->passwordHasher->hash('test1');
        drupal_set_message("md5 Hashed Password: ".$md5HashedPassword);
        $password_check = $this->passwordHasher->check('test', $md5HashedPassword);
        drupal_set_message("Password Check: ".$password_check);
        */

        //$ret = \Drupal\Core\Password\PasswordInterface::check('secret', $user);
        //kint($ret);

        /*
        if($form_state->getValue('email') === $user->getEmail()) {
            drupal_set_message("Email MATCHES... Do nothing");
        } else {
            drupal_set_message("Email not match, check PASSWORD", 'warning');
        }
        */
        //$form_state->setErrorByName('candidate_number', $this->t('Mobile number is too short.'));
        //drupal_set_message("Sending Form 2");
        /*
        if (strlen($form_state->getValue('candidate_number')) < 10) {
            $form_state->setErrorByName('candidate_number', $this->t('Mobile number is too short.'));
        }
        */
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

        $form_values = $form_state->getValues();

        $this->entityManager->set("field_first_name", $form_state->getValue('field_first_name'));
        $this->entityManager->set("field_last_name", $form_state->getValue('field_last_name'));
        $this->entityManager->setEmail($form_state->getValue('email'));
        foreach($this->notifications as $key => $field) {
            $this->entityManager->set($field, $form_values[$field]);
        }
        foreach($this->subCommittees as $key => $field) {
            $this->entityManager->set($field, $form_values[$field]);
        }
        if (strlen($form_state->getValue('password_new')) > 0) {
            drupal_set_message("Your new password has been saved.");
            //drupal_set_message("NEW PASSWORD: ".$form_state->getValue('password_new'));
            $this->entityManager->setPassword($form_state->getValue('password_new'));
        }
        $this->entityManager->save();

        foreach ($form_state->getValues() as $key => $value) {
           // drupal_set_message($key . ': ' . $value);
        }

        drupal_set_message("Your profile changes have been saved.");

    }

}