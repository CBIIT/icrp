<?php
/**
 * @file
 * Contains \Drupal\icrp\Form\UserReviewForm.
 */
namespace Drupal\icrp\Form;
use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;

class UserReviewForm extends FormBase
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
        return 'user_review_form';
    }

    public function buildForm(array $form, FormStateInterface $form_state)
    {
        $current_uri = \Drupal::request()->getRequestUri();
        $uri_parts = explode("/", $current_uri);
        $uuid = $uri_parts[2];
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

        $markup = '<h1>User Review</h1>';
        $form['markup_password'] = array(
            '#type' => 'markup',
            '#markup' => t($markup),
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

        $form['container']['name']['first_name'] = array(
            '#type' => 'textfield',
            '#title' => t('First Name:'),
            '#default_value' => $field_first_name->value,
            '#required' => TRUE,
            '#disabled' => TRUE,
            '#attributes' => array(
                'class' => array('bc-cart-form-container'),
            )
        );
        $form['container']['name']['last_name'] = array(
            '#type' => 'textfield',
            '#title' => t('Last Name:'),
            '#default_value' => $field_last_name->value,
            '#required' => TRUE,
            '#disabled' => TRUE,
        );
        $form['container']['name']['organization'] = array(
            '#type' => 'textfield',
            '#title' => t('Organization'),
            '#default_value' => $organization_title,
            '#required' => TRUE,
            '#disabled' => TRUE,
        );
        $form['container']['name']['email'] = array(
            '#type' => 'email',
            '#title' => t('Email:'),
            '#default_value' => $email,
            '#required' => TRUE,
            '#disabled' => TRUE,
        );

        /* Container 2 */
        $form['container2'] = array(
            '#type' => 'container',
            '#prefix' => '<div class="col-sm-6">',
            '#suffix' => '</div>',
            '#attributes' => array(
                'class' => array(''),
            )
        );


        $form['container2']['name']['settings'] = array(
            '#type' => 'fieldset',
            '#title' => t('User Settings'),
            '#attributes' => array(
                'class' => array(''),
            )
        );
        $form['container2']['name']['settings']['upload_files'] = array(
            '#type' => 'checkbox',
            '#title' => t('Can Upload Library Files'),
            '#default_value' => $can_upload_library_files,
            '#help_text' => 'Allow user ability to upload files to the ICRP Library'
        );

        $form['container2']['name']['settings']['status'] = array(
            '#type' => 'radios',
            '#title' => ('Status'),
            '#options' => array(
                0 => t('Blocked'),
                1 => t('Active'),
            ),
            '#default_value' => $status,
            '#help_text' => 'User Status'

        );
        $form['container2']['name']['settings']['roles'] = array(
            '#type' => 'checkboxes',
            '#title' => 'Roles',
            '#options' => array(
                'manager' => t('Manager'),
                'partner' => t('Partner'),
            ),
            '#default_value' => $roles,
            '#help_text' => 'User application roles'
        );
        $form['container2']['name']['settings']['actions']['#type'] = 'actions';
        $form['container2']['name']['settings']['actions']['submit'] = array(
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
        //Add Roles
        $hasNoRole = true;
        foreach ($form_values['roles'] as $assign_role) {
            if($assign_role === "manager") {
                $hasNoRole = false;
            }
            if($assign_role === "partner") {
                $hasNoRole = false;
            }
        }

        if ($hasNoRole) {
            $form_state->setErrorByName('roles', $this->t('User needs to be assigned at lease one Role.'));
        }
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

        $membership_status = ($form_values['status'] == 0) ? 'Blocked' : 'Active';
        $user->set("field_membership_status", $membership_status);

        $user->set("field_can_upload_library_files", $form_values['upload_files']);
        $user->set("status", $form_values['status']);
        $user->save();

        drupal_set_message("User account for ".$user->getDisplayName()."  has been saved and is currently ".strtolower($membership_status).".");
    }

}