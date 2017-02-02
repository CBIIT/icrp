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

    public function buildForm(array $form, FormStateInterface $form_state)
    {
        /*
        $form['container'] = array(
            '#type' => 'container',
            '#title' => "Main"
            '#weight' => 5,
            '#attributes' => array(
                'class’ => array(
                    ‘contact-info’,
                ),
            ),
        );

*/
        $current_uri = \Drupal::request()->getRequestUri();
        $uri_parts = explode("/", $current_uri);
        $uuid = $uri_parts[2];
        $uuid = "cbe73f10-f532-41ee-8a38-78b7633f18df";
        $entity = \Drupal::entityManager()->loadEntityByUuid('user', $uuid);

        /* Load User Data */
        $uid = (int)$entity->id();
        $user = \Drupal::service('entity_type.manager')->getStorage('user')->load($uid);
        $field_first_name = $user->get('field_first_name');
        $field_last_name = $user->get('field_last_name');

        /* Get Organization Title */
        $field_organization = $user->get("field_organization");
        $field_organization_nid = $field_organization->getValue()[0]["target_id"];
        //drupal_set_message("Organization nid: ".$field_organization->getValue()[0]["target_id"]);
        $node = \Drupal\node\Entity\Node::load($field_organization_nid);
        $title_field = $node->get('title');
        $organization_title = $title_field->value;

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

        /*
        $user_roles = $user->get("roles");

        }

        print_r($user_roles->getValue());
        drupal_set_message($user_roles->value);
        */
        //$field_organization_parent = $field_organization->parent();
        //kint($field_organization->getName());
        //kint($field_organization_parent);

        //dsm($user);

        //$var['36: ReflectionProperty->getValue()']['args'][getName()]

        //drupal_set_message(print_r($user, TRUE));
        //drupal_set_message($user->getRoles());
        //drupal_set_message(print_r("email:", TRUE));
        //dsm($user);

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
            '#disabled' => TRUE,
            '#attributes' => array(
                'class' => array('bc-cart-form-container'),
            )
        );
        $form['name']['last_name'] = array(
            '#type' => 'textfield',
            '#title' => t('Last Name:'),
            '#default_value' => $field_last_name->value,
            '#required' => TRUE,
            '#disabled' => TRUE,
        );
        $form['name']['organization'] = array(
            '#type' => 'textfield',
            '#title' => t('Organization'),
            '#default_value' => $organization_title,
            '#required' => TRUE,
            '#disabled' => TRUE,
        );
        $form['name']['email'] = array(
            '#type' => 'email',
            '#title' => t('Email:'),
            '#default_value' => $email,
            '#required' => TRUE,
            '#disabled' => TRUE,
        );
        $form['name']['settings'] = array(
            '#type' => 'fieldset',
            '#title' => t('User Settings'),
            '#attributes' => array(
                'class' => array(''),
            )
        );
        $form['name']['settings']['upload_files'] = array(
            '#type' => 'checkbox',
            '#title' => t('Can Upload Library Files'),
            '#default_value' => $can_upload_library_files,
        );

        $form['name']['settings']['status'] = array(
            '#type' => 'radios',
            '#title' => ('Status'),
            '#options' => array(
                0 => t('Blocked'),
                1 => t('Active'),
            ),
            '#default_value' => $status,

        );
        $form['name']['settings']['roles'] = array(
            '#type' => 'checkboxes',
            '#title' => 'Roles',
            '#options' => array(
                'manager' => t('Manager'),
                'partner' => t('Partner'),
            ),
            '#default_value' => $roles,
        );
        $form['name']['settings']['actions']['#type'] = 'actions';
        $form['name']['settings']['actions']['submit'] = array(
            '#type' => 'submit',
            '#value' => $this->t('Save'),
            '#button_type' => 'primary',
        );
        /*
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

        */

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