<?php
/**
 * @file
 * Contains \Drupal\icrp\Form\MyProfileForm.
 */
namespace Drupal\icrp\Form;
use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;

class MyProfileForm extends FormBase
{

    public function __construct() {
        //parent::__construct();
        //drupal_set_message("In SubClass constructor\n");

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
        /* Load User Data */

        $uid = \Drupal::currentUser()->id();
        //drupal_set_message("uid:".$uid);
        //$uid = (int)$entity->id();
        $user = \Drupal::service('entity_type.manager')->getStorage('user')->load($uid);
        $field_first_name = $user->get('field_first_name');
        $field_last_name = $user->get('field_last_name');
        //drupal_set_message("Setting for ".$field_first_name." ".$field_last_name);

        /* Email */
        $email = $user->getEmail();

        /* Get Upload Library permission */
        $field_can_upload_library_files = $user->get("field_can_upload_library_files");
        $can_upload_library_files = $field_can_upload_library_files->value;

        /* Get status */
        $field_status = $user->get("status");
        $status = $field_status->value;

        /* Get Roles */
        $field_roles = $user->get("roles");
        //drupal_set_message(print_r($field_roles->getValue()));

        $roles = array();
        $role_types = array("manager", "partner");
        foreach ($role_types as $role) {
            if($role != "administrator") {
                if ($user->hasRole($role)) {
                    array_push($roles, $role);
                }
            }
        }

        //$field_organization_parent = $field_organization->parent();
        //kint($field_organization->getName());
        //kint($field_organization_parent);

        //dsm($user);

        //$var['36: ReflectionProperty->getValue()']['args'][getName()]

        //drupal_set_message(print_r($user, TRUE));
        //drupal_set_message($user->getRoles());
        //drupal_set_message(print_r("email:", TRUE));
        //dsm($user);

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
            '#title' => t('First Name:'),
            '#default_value' => $field_first_name->value,
            '#required' => TRUE,
            '#attributes' => array(
                'class' => array(''),
            )
        );
        $form['name']['last_name'] = array(
            '#type' => 'textfield',
            '#title' => t('Last Name:'),
            '#default_value' => $field_last_name->value,
            '#required' => TRUE,
        );
        $form['name']['email'] = array(
            '#type' => 'email',
            '#title' => t('Email:'),
            '#default_value' => $email,
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
            '#default_value' => $field_first_name->value,
        );
        $form['name']['password']['new'] = array(
            '#type' => 'password',
            '#title' => t('New Password'),
            '#default_value' => $field_first_name->value,
        );
        $form['name']['password']['confirm'] = array(
            '#type' => 'password',
            '#title' => t('Confirm Password'),
            '#default_value' => $field_first_name->value,
        );

        $form['committee'] = array(
            '#type' => 'fieldset',
            '#title' => 'ICRP Subcommittees',
        );

        $subcommittee = array();
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

        $form['committee']["sub0"] = array(
            '#type' => 'checkbox',
            '#title' => t($subcommittee[0]),
            '#default_value' => $can_upload_library_files,
        );
        $form['committee']["sub1"] = array(
            '#type' => 'checkbox',
            '#title' => t($subcommittee[1]),
            '#default_value' => $can_upload_library_files,
        );
        $form['committee']["sub2"] = array(
            '#type' => 'checkbox',
            '#title' => t($subcommittee[2]),
            '#default_value' => $can_upload_library_files,
        );
        $form['committee']["sub3"] = array(
            '#type' => 'checkbox',
            '#title' => t($subcommittee[3]),
            '#default_value' => $can_upload_library_files,
        );
        $form['committee']["sub4"] = array(
            '#type' => 'checkbox',
            '#title' => t($subcommittee[4]),
            '#default_value' => $can_upload_library_files,
        );
        $form['committee']["sub5"] = array(
            '#type' => 'checkbox',
            '#title' => t($subcommittee[5]),
            '#default_value' => $can_upload_library_files,
        );
        $form['committee']["sub6"] = array(
            '#type' => 'checkbox',
            '#title' => t($subcommittee[6]),
            '#default_value' => $can_upload_library_files,
        );
        $form['committee']["sub7"] = array(
            '#type' => 'checkbox',
            '#title' => t($subcommittee[7]),
            '#default_value' => $can_upload_library_files,
        );

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


        return $form;
    }

    public function validateForm(array &$form, FormStateInterface $form_state)
    {
        /*
        if (strlen($form_state->getValue('candidate_number')) < 10) {
            $form_state->setErrorByName('candidate_number', $this->t('Mobile number is too short.'));
        }
        */
    }
    /*
        public function hasManagerRole() {
            return TRUE;
        }
    */
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