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
        $application_status = $this->getValue("application_status");

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
            '#default_value' => $application_status,
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

        /* Director */
        //$body .= '<div class="webform-header">Executive Director/President/Chairperson</div>';
        $body .= '<dl class="dl-horizontal">';
        $body .= '<dt>Executive Director/President/Chairperson</dt>';
        $body .= '<dd></dd>';
        $body .= '</dl>';

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
            ["label" => 'Research Investment Budget', 'field' => 'tier_radio_budget_range'],
            ["label" => 'the preferred date for payment of annual membership contributions', 'field' => 'payment_radio'],
            );
        
        $body = $this->addLabelsToBody($labels);
        $this->displaySectionDetail($section, $body, $form, "closed");
        
        /* Contact Person */
        $section = "Contact Person";
        $labels = array(["label" => 'Name', 'field' => 'name'],
            ["label" => 'Position', 'field' => 'company'],  //Hack: Webform we have to use company field for position
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
        $labels = ['Statement of Willingness', 'Peer Review Process'];
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

        $i = 0;
        $body = '<div>';
        foreach($links as $link) {
            $body .= '<div class="row">';
                $body .= '<div class="col col-lg-3 col-md-3 col-sm-4">'.$labels[$i].':</div>';
                $body .= '<div class="col col-sm-4">'.$links[$i].'</div>';
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
        $budget_ranges = ["Less than $5M", "$5M-$9M", "$10M-$24M", "$25M-$149M", "$150M-$250M", "$250M or over"];
        /* Get Application Value */
        foreach($this->results as $row) {
            if($row['name'] == 'email' && $field == 'email') {
                return '<a href="mailto:'.$row['value'].'">'.$row['value'].'</a>';
            } elseif($row['name'] == 'tier_radio' && $field == 'tier_radio') {
                return $roman[(int)$row['value']-1];
            } elseif($row['name'] == 'tier_radio' && $field == 'tier_radio_budget_range') {
                return $budget_ranges[(int)$row['value']-1];
            } elseif($row['name'] == $field) {
                return $row['value'];
            }

        }
        return "Variable not found";
    }

    private function getValueByProperty($field) {
        /* Get Application Value */
        foreach($this->results as $row) {
            if($row['property'] == 'email' && $field == 'email') {
                return '<a href="mailto:'.$row['value'].'">'.$row['value'].'</a>';
            } elseif($row['property'] == $field) {
                return $row['value'];
            }

        }
        return "[Variable not found]";
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
        $sql = "SELECT * FROM webform_submission_data where sid = ".t($this->sid)
            ." and webform_id = 'icrp_partnership_applicaion_form';";
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
    
    public function validateForm(array &$form, FormStateInterface $form_state)
    {
        $form_values = $form_state->getValues();
        //drupal_set_message(print_r($form_state->getValues(), TRUE));
        $application_status = $form_values['status'];
        if($application_status != "Archived" && $application_status != "Completed") {
            $form_state->setErrorByName('Application Review', t('Select an application status before saving.'));
            $form_state->setErrorByName('status', t('Select an application status before saving.'));
        }

    }
    private function setValue($field, $value) {
        //Connect to database and get submission data
        $sql = "UPDATE webform_submission_data 
            SET value = '{$value}'
            where sid = ".t($this->sid)
            ." and webform_id = 'icrp_partnership_applicaion_form'
               and name = '{$field}'";
        //drupal_set_message($sql);
        $data = $this->connection->query($sql);
        //dump($data);
        return;

    }
    public function submitForm(array &$form, FormStateInterface $form_state)
    {

        $form_values = $form_state->getValues();
        //drupal_set_message(print_r($form_state->getValues(), TRUE));
        $application_status = $form_values['status'];
        $this->setValue("application_status", $application_status);
        
        drupal_flush_all_caches();
        //$membership_status = ($form_values['status'] == 0) ? 'Blocked' : 'Active';

        drupal_set_message(t("Partner Applicaion Status for ".$this->getValue('organization_name')."  has been saved and currently has a status of ".$application_status."."));
    }

}