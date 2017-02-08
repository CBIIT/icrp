<?php
/**
 * @file
 * Contains \Drupal\icrp\Form\MyProfileForm.
 */
namespace Drupal\icrp\Form;

use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Entity\EntityManagerInterface;
use Drupal\Core\Password\PasswordInterface;

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
    protected $passwordChecker;

    /**
     * Constructs a UserAuth object.
     *
     * @param \Drupal\Core\Entity\EntityManagerInterface $entity_manager
     *   The entity manager.
     * @param \Drupal\Core\Password\PasswordInterface $password_checker
     *   The password service.
     */
    //public function __construct( PasswordInterface $password_checker) {
    public function __construct() {
        $uid = \Drupal::currentUser()->id();
        $this->entityManager = \Drupal::service('entity_type.manager')->getStorage('user')->load($uid);
        //$this->passwordChecker = $password_checker;
    }

    /**
     * {@inheritdoc}
     */
    public function getFormId()
    {
        return 'my_profile_form';
    }

    /**
     * {@inheritdoc}
     */
    public function buildForm(array $form, FormStateInterface $form_state)
    {
        $user = $this->entityManager;

        /* TODO: Search PEOPLE fields for field_subcommittee* then populate the array below */
        /* Get ICRP Subcommittees */
        $sub = array("field_subcommittee_annual_meetin");
        $sub_committees = array(
            "field_subcommittee_annual_meetin",
            "field_subcommittee_data_report",
            "field_subcommittee_evaluation",
            "field_subcommittee_external_comm",
            "field_subcommittee_internal_comm",
            "field_subcommittee_membership",
            "field_subcommittee_partner_opera",
            "field_subcommittee_web_site",
        );

        $form['#theme'] = "my_profile_form";

        $form['name'] = array(
            '#type' => 'fieldset',
            '#title' => t('User Info'),
            '#attributes' => array(
                'class' => array(''),
            )
        );

        $form['name']['first_name'] = array(
            '#type' => 'textfield',
            '#title' => t('First Name'),
            '#default_value' => $user->get('field_first_name')->value,
            '#required' => TRUE,
            '#attributes' => array(
                'class' => array(''),
            )
        );
        $form['name']['last_name'] = array(
            '#type' => 'textfield',
            '#title' => t('Last Name'),
            '#default_value' =>  $user->get('field_last_name')->value,
            '#required' => TRUE,
        );
        $form['name']['email'] = array(
            '#type' => 'email',
            '#title' => t('Email'),
            '#default_value' => $user->getEmail(),
            '#required' => TRUE,
        );

        $form['name']['password'] = array(
            '#type' => 'details',
            '#title' => t('Change Password'),
            '#attributes' => array(
                'class' => array(''),
            )
        );

        $form['name']['password']['current'] = array(
            '#type' => 'password',
            '#title' => t('Current Password'),
            '#default_value' =>"",
        );
        $markup = '<div class="description" style="padding-bottom:25px;">
        Required if you want to change the <em class="placeholder">Email address</em> or <em class="placeholder">Password</em> below. <a title="Send password reset instructions via email." href="/user/password">Reset your password</a>.
    </div>';
        $form['name']['password']['markup_reset'] = array(
            '#type' => 'markup',
            '#markup' => t($markup),
            '#attributes' => array(
                'class' => array(''),
            )
        );

        $form['name']['password']['new'] = array(
            '#type' => 'password',
            '#title' => t('New Password'),
            '#default_value' => "",
        );
        $form['name']['password']['confirm'] = array(
            '#type' => 'password',
            '#title' => t('Confirm New Password'),
            '#default_value' => "",
        );
        $markup = '<div class="description" id="edit-pass--description">To change the current user password, enter the new password in both fields.</div>';
        $form['name']['password']['markup_password'] = array(
            '#type' => 'markup',
            '#markup' => t($markup),
        );


        $form['committee'] = array(
            '#type' => 'fieldset',
            '#title' => 'ICRP Subcommittees',
        );

        $subcommittee = array(
            "Internal Communication",
            "External Communication",
            "Membership",
            "Annual Meeting",
            "Evaluation & Outcomes",
            "Web Site & Database",
            "Data Report & Data Quality",
            "Partner Operations"
        );
        $config = $this->config('recovery_pass.settings');

        //$mytype = gettype($subcommittee[0]);
        //druapl_set_message("Type: ".$mytype);

        /* COMMITTEE */

        foreach($sub_committees as $key => $field_subcommittee) {
            //drupal_set_message($key. " => ". $field_subcommittee);
            $form['committee'][$field_subcommittee] = array(
                '#type' => 'checkbox',
                '#title' => t($user->get($field_subcommittee)->getFieldDefinition()->getLabel()),
                '#default_value' => (int)$user->get($field_subcommittee)->getValue(),
            );

        }

        $form['action']['submit'] = array(
            '#type' => 'submit',
            '#value' => $this->t('Save'),
            '#button_type' => 'primary',
        );

        return $form;
    }

    public function validateForm(array &$form, FormStateInterface $form_state)
    {
        $form_values = $form_state->getValues();
        //drupal_set_message(print_r($form_state->getValues(), TRUE));
        kint($form);
        /*
        if (strlen($form_state->getValue('candidate_number')) < 10) {
            $form_state->setErrorByName('candidate_number', $this->t('Mobile number is too short.'));
        }
        */
    }

    public function submitForm(array &$form, FormStateInterface $form_state)
    {

        $form_values = $form_state->getValues();
        //drupal_set_message(print_r($form_state->getValues(), TRUE));

        $current_uri = \Drupal::request()->getRequestUri();
        $uri_parts = explode("/", $current_uri);
        $uuid = $uri_parts[2];
        $entity = \Drupal::entityManager()->loadEntityByUuid('user', $uuid);

        /* Load User Data */
        $uid = (int)$entity->id();
        $user = \Drupal::service('entity_type.manager')->getStorage('user')->load($uid);
        //Example Role:
        // Array ( [0] => Array ( [target_id] => administrator ) [1] => Array ( [target_id] => manager ) [2] => Array ( [target_id] => partner ) )

        /* Get Roles */
        /*
                drupal_set_message("getRoles(TRUE):");
                $roles = $user->getRoles(TRUE);
                drupal_set_message(print_r($roles, TRUE));
                $current_roles = $user->get("roles")->getValue();
                drupal_set_message(print_r($current_roles, TRUE));
        */
        //*Remove Roles */

        $user->removeRole('manager');
        $user->removeRole('partner');

        //Add Roles
        foreach ($form_values['roles'] as $assign_role) {
            if($assign_role === "manager") {
                $user->addRole("manager");
            }
            if($assign_role === "partner") {
                $user->addRole("partner");
            }
        }
        //drupal_set_message(print_r($user->getRoles(TRUE), TRUE));
        //drupal_set_message(print_r($user->getRoles(), TRUE));

        // If current user is manager, add that back
        /*
        $manager = $user->hasRole('manager');
        $current_uid =  \Drupal::currentUser()->id();
        if($current_uid == $uid  && $manager) {
            drupal_set_message("USER IS EDITING SELF and is a MANGER adding manager role");
            $user->addRole('manager');
        }
        */
        /* Disabled for TESTING ONLY */
        $membership_status = ($form_values['status'] == 0) ? 'Blocked' : 'Active';
        $user->set("field_membership_status", $membership_status);

        $user->set("field_can_upload_library_files", $form_values['upload_files']);
        $user->set("status", $form_values['status']);
        $user->save();

        drupal_set_message("User accout for ".$user->getDisplayName()."  has been saved and is currently ".strtolower($membership_status).".");
    }

}