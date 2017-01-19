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
//        parent::__construct();
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


        $uuid = '88b5fb9f-e220-444d-92f8-db334f301d59';
        $entity = \Drupal::entityManager()->loadEntityByUuid('user', $uuid);
        //dsm($entity);
        //drupal_set_message("e-mail: ".$entity->getEmail());
        //drupal_set_message("isBlocked: ".$entity->isBlocked());
        //drupal_set_message("isActive: ".$entity->isActive());
        //drupal_set_message(print_f($entity->getRoles(), TRUE));
        $current_uid = \Drupal::currentUser()->id();
        //drupal_set_message($current_uid);

        $uid = 64;
        $user = \Drupal::service('entity_type.manager')->getStorage('user')->load($uid);
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
            '#default_value' => "Kailing",
            '#required' => TRUE,
            '#disabled' => TRUE,
            '#attributes' => array(
                'class' => array('bc-cart-form-container'),
            )
        );
        $form['name']['last_name'] = array(
            '#type' => 'textfield',
            '#title' => t('Last Name:'),
            '#default_value' => "Chen",
            '#required' => TRUE,
            '#disabled' => TRUE,
        );
        $form['name']['organization'] = array(
            '#type' => 'textfield',
            '#title' => t('Organization'),
            '#default_value' => "Susan G. Komen (44)",
            '#required' => TRUE,
            '#disabled' => TRUE,
        );
        $form['name']['email'] = array(
            '#type' => 'email',
            '#title' => t('Email ID:'),
            '#default_value' => $entity->getEmail(),
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
            '#checked' => TRUE,
            '#title' => t('Can Upload Library Files'),
        );

        $form['name']['settings']['status'] = array(
            '#type' => 'radios',
            '#title' => ('Status'),
            '#default_value' => "Blocked",
            '#options' => array(
                'Blocked' => t('Blocked'),
                'Active' => t('Active'),
            ),
        );
        $form['name']['settings']['candidate_confirmation'] = array(
            '#type' => 'checkboxes',
            '#title' => 'Roles',
            '#options' => array(
                'Manager' => t('Manager'),
                'Partner' => t('Partner'),
            ),
        );
        $form['name']['settings']['notify_user'] = array(
            '#type' => 'checkbox',
            '#title' => t('Notify user of new account.'),
            '#checked' => TRUE,
        );
        $form['name']['settings']['actions']['#type'] = 'actions';
        $form['name']['settings']['actions']['submit'] = array(
            '#type' => 'submit',
            '#value' => $this->t('Save'),
            '#button_type' => 'primary',
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

    public function submitForm(array &$form, FormStateInterface $form_state)
    {
        // drupal_set_message($this->t('@can_name ,Your application is being submitted!', array('@can_name' => $form_state->getValue('candidate_name'))));
        /*
        foreach ($form_state->getValues() as $key => $value) {
            drupal_set_message($key . ': ' . $value);
        }
        */
        drupal_set_message("Kailing Chen has been sent an account activation e-mail notification. ");
    }
}