<?php
/**
 * @file
 * Contains \Drupal\icrp\Form\PartnerApplicationReviewForm.
 */
namespace Drupal\icrp\Form;

use Drupal\Core\Database\Driver\mysql\Connection;
use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Component\Utility;
use Drupal\Core\Database\Database;

class PartnerApplicationReviewForm extends FormBase
{

    /**
     * The database connection.
     *
     * @var \Drupal\Core\Database\Connection
     */
    protected $connection;

    /**
    * Webform Submission Data 
    *
    * @var object
    */

    protected $results;
    /**
    * Webform Submission ID 
    *
    * @var integer
    */

    protected $sid;


    public function __construct()
    {
        $this->connection = Database::getConnection();

        $current_uri = \Drupal::request()->getRequestUri();
        $uri_parts = explode("/", $current_uri);
        $this->sid = $uri_parts[2];
        $this->results = $this->getWebformSubmissionData($this->sid);
    }

    /**
     * {@inheritdoc}
     */
    public function getFormId()
    {
        return 'partner_application_review_form';
    }

    public function buildForm(array $form, FormStateInterface $form_state)
    {
        //$webformData = new \Drupal\webform\WebformSubmissionViewsData($this->entityManager);
        //kint($webformData);


        $markup = '<h1>Partner Application Review</h1>';
        $form['title'] = array(
            '#type' => 'markup',
            '#markup' => t($markup),
        );

        $form['container'] = array(
            '#type' => 'fieldset',
            '#title' => t('Application Status'),
            '#prefix' => '<div class="col-sm-12">',
            '#suffix' => '</div>',
            '#collapsed' => FALSE,  // Added
            '#attributes' => array(
                'class' => array(''),
            )
        );

        $form['container']['status'] = array(
            '#type' => 'radios',
            '#title' => ('Status'),
            '#default_value' => 'Pending Review',
            '#options' => array(
                'Completed' => t('Completed'),
                'Archived' => t('Archived'),
            ),
            '#help_text' => 'User Status'
        );
        $form['container']['actions']['#type'] = 'actions';
        $form['container']['actions']['submit'] = array(
            '#type' => 'submit',
            '#value' => $this->t('Save'),
            '#button_type' => 'primary',
        );
        $form = $this->displaySubmission($form);

        return $form;
    }

    private function displaySubmission($form) {

        $labels = [];
        $body;

        /* Organization  Section */
        $section = "Organization Information";
        $labels = array(["label" => 'Organization\'s Name', 'field' => 'organization_name'],
            ["label" => 'Organization\'s Address 1', 'field' => 'organization_address_1'],
            ["label" => 'Adress 2', 'field' => 'organization_address_2'],
            ["label" => 'City', 'field' => 'city'],
            ["label" => 'Country', 'field' => 'country'],
            ["label" => 'Zip/Postal Code', 'field' => 'zip_postal_code'],
            );
        $body = $this->addLabelsToBody($labels);
        $body .= '<div class="webform-header">Executive Director/President/Chairperson</div>';
        $labels = array(["label" => 'Name', 'field' => 'name'],
            ["label" => 'Position', 'field' => 'position'],
            ["label" => 'Telephone number', 'field' => 'telephone_number'],
            ["label" => 'Email Address', 'field' => 'email'],
            ["label" => 'Description of the Organization and its mission, including whether it is a public organization, charity, foundation, etc.', 'field' => 'description_of_the_organization'],
            ["label" => 'Brief description of research profile (disease-specific vs. entire research continuum portfolio', 'field' => 'brief_description_of_research'],
            ["label" => 'Year when initiated research program', 'field' => 'year_initiated'],
            );
        $body .= $this->addLabelsToBody($labels);
        $this->displaySectionDetail($section, $body, $form);

        /* Research Investment Budget Information */
        $section = "Research Investment Budget Information";
        $labels = array(["label" => 'Current annual research investment budget', 'field' => 'current_annual_research_investment_budget'],
            ["label" => 'Reporting period ', 'field' => 'reporting_period'],
            ["label" => 'Approximate number of projects funded per annum', 'field' => 'number_of_projects_funded_per_annum'],
            ["label" => 'Membership contribution tier', 'field' => 'tier_radio'],
            ["label" => 'Research Investment Budget', 'field' => 'current_annual_research_investment_budget'],
            ["label" => 'the preferred date for payment of annual membership contributions', 'field' => 'payment_radio'],
            );
        
        $body = $this->addLabelsToBody($labels);
        $this->displaySectionDetail($section, $body, $form, "closed");
        
        /* Contact Person */
        $section = "Contact Person";
        $labels = array(["label" => 'Name', 'field' => 'name'],
            ["label" => 'Position', 'field' => 'position'],
            ["label" => 'Phone', 'field' => 'phone'],
            ["label" => 'Email', 'field' => 'email'],
            ["label" => 'Address 1', 'field' => 'address'],
            ["label" => 'Address 2', 'field' => 'address_2'],
            ["label" => 'City', 'field' => 'city'],
            ["label" => 'Country', 'field' => 'country'],
            ["label" => 'ZIP/Postal Code', 'field' => 'postal_code'],
            );
        
        $body = $this->addLabelsToBody($labels, 'property');
        $this->displaySectionDetail($section, $body, $form, "closed");

        /* ICRP Terms & Conditions of membership */
        $section = "ICRP Terms & Conditions of membership";
        $body = '<div class="webform-header">Your organization\'s eligibility for membership and acceptance of ICRP\'s terms:</div>';
        $body .= '<ul class="icrp-terms-list">';
        $body .= '<li>Has an external scientific peer review system</li>';
        $body .= '<li>Agrees to the ICR Partners\' mission statement</li>';
        $body .= '<li>Agrees to establish and maintain a system for coding research portfolios to CSO and disease-site codes</li>';
        $body .= '<li>Agrees to post its research portfolio annually on the ICRP website, which entails submission of research portfolio datasets to a US database</li>';
        $body .= '<li>Agrees to contribute financial support annually for the ICRP to provide administrative support for the partnership and portfolio analyses</li>';
        $body .= '<li>Agrees to sustain membership for a minimum of 3 years</li>';
        $body .= '<li>Agrees to abide by the Policies & Procedures of the ICRP</li>';
        $body .= '<li>Has nominated a contact who will participate actively in the ICRP</li>';
        $body .= '</ul>';

        $this->displaySectionDetail($section, $body, $form, "closed");

        /* Supplemental Information */
        $section = "Supplemental Information";
        $body = $this->addSupplementalInformation();
        $this->displaySectionDetail($section, $body, $form, "closed");

        return $form;
    }

    private function addSupplementalInformation() {
        /* Statement of Willingness */
        $links = [];
        $files = ['statement_of_willingness', 'peer_review_process'];
        foreach($files as $file) {
            $fid = $this->getValue($file);
            if(is_numeric($fid)) {
                $sql = "SELECT * FROM file_managed where fid = ".t($fid);
                $data = $this->connection->query($sql);
                //dump($data);
                $results = $data->fetchAll(\PDO::FETCH_ASSOC);
                foreach($results as $row) {
                    $uri = $row['uri'];
                    $uri = str_replace("public://", "/sites/default/files/", $uri);
                    $filename = $row['filename']; 
                }
                $link = '<a target="_blank" href="'.$uri.'">'.$filename.'</a>';
                array_push($links, $link);

            } else {
                array_push($links, "Not uploaded.");
            }

        }

        $i = 1;
        $body = '<div>';
        foreach($links as $link) {
            $body .= '<div class="row">';
            if($i == 1) {
                $body .= '<div class="col col-sm-2">Statement of Willingness:</div>';
                $body .= '<div class="col col-sm-4">'.$links[0].'</div>';
            } elseif($i == 2)  {
                $body .= '<div class="col col-sm-2">Peer Review Process:</div>';
                $body .= '<div class="col col-sm-4">'.$links[1].'</div>';
            }
            $body .= '</div>';
            $i++;
        }
        $body .= '</div>';
        /*
        foreach ($this->results as $row) {
            drupal_set_message("Field a: {$row['name']}");
        }
        */
        return $body;

    }

    private function displaySectionDetail($title, $body, array &$form, $panel_state="collpased") {

        $random = new \Drupal\Component\Utility\Random();
        $uid = $random->name();
        // Make a new container on the form
        $markup = $this->bootstrapContatainer($title, $body, $panel_state);
        //drupal_set_message($markup);

        $form[$uid] = array(
            '#type' => 'markup',
            '#markup' => t($markup),
        );

        return $form;

    }
    private function addLabelsToBody($labels, $lookupField="name") {
        //drupal_set_message(print_r($labels, true));
        $body = '<dl class="dl-horizontal">';

        foreach($labels as $label) {
            foreach($label as $key => $value) {
                if($key == "label") {
                    $body .='<dt>'.t($value).':</dt>';
                }
                if($key == "field") {
                    if($lookupField == "name") {
                        $body .='<dd>'.t($this->getValue($value)).'</dd>';
                    } elseif($lookupField == "property") {
                        $body .='<dd>'.t($this->getValueByProperty($value)).'</dd>';
                    }
                }
            }
        }
        $body .= '</dl>';

        return $body;
    }

    private function getValue($field) {
        $roman = ['I', 'II', 'III', 'IV', 'V', 'VI'];
        /* Get Application Value */
        foreach($this->results as $row) {
            if($row['name'] == 'tier_radio' && $field == 'tier_radio') {
                return $roman[(int)$row['value']-1];
            } elseif($row['name'] == $field) {
                return $row['value'];
            }

        }
        return "Variable not found";
    }

    private function getValueByProperty($field) {
        /* Get Application Value */
        foreach($this->results as $row) {
            if($row['property'] == $field) {
                return $row['value'];
            }

        }
        return "Variable not found";
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

        //drupal_set_message("User account for ".$user->getDisplayName()."  has been saved and is currently ".strtolower($membership_status).".");
    }

    private function bootstrapContatainer($title, $body, $panel_state="collapsed") {
        //drupal_set_message("bootstrapContatainer: ".$title);
        $random = new \Drupal\Component\Utility\Random();
        $uid = $random->name();
        $panel_state = ($panel_state=="collapsed") ? "collapsed" : "";
        //drupal_set_message("panel_state: ".$panel_state);


        $markup = '<div class="icrp-bootstrap-container col-sm-12">
  <div class="form-item js-form-item form-wrapper js-form-wrapper panel panel-default">
    <div class="panel-heading">
        <a href="#'.$uid.'" class="panel-title '.$this->t($panel_state).'" role="button" data-toggle="collapse" aria-pressed="true" aria-expanded="true" aria-controls="edit-organization-information--content">'.$title.'</a>
      
    </div>
    <div id="'.$uid.'" class="panel-body panel-collapse fade collapse in" aria-expanded="true" style="">
    '.$body.'
    </div>
  </div>
</div><br>';
        return $markup;
    }

    private function getWebformSubmissionData() {
        //Connect to database and get submission data
        $sql = "SELECT * FROM webform_submission_data where sid = $this->sid";
        //drupal_set_message($sql);
        $data = $this->connection->query($sql);
        //dump($data);
        return $data->fetchAll(\PDO::FETCH_ASSOC);
        /*
        foreach ($this->results as $row) {
            drupal_set_message("Field a: {$row['name']}");
        }
        */

    }

}