<?php
/**
 * @file
 * Contains \Drupal\icrp\Form\PartnerApplicationReviewForm.
 */
namespace Drupal\icrp\Form;

use Drupal\Component\Utility\Random;
use Drupal\Core\Database\Driver\mysql\Connection;
use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Component\Utility;
use Drupal\Core\Database\Database;
use Drupal\Core\Mail\MailManagerInterface;
use Drupal\Component\Utility\SafeMarkup;
use Drupal\Component\Utility\Html;
use Symfony\Component\EventDispatcher\GenericEvent;

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
            ["label" => 'Organization\'s Address 2', 'field' => 'organization_address_2'],
            ["label" => 'City', 'field' => 'city'],
            ["label" => 'Country', 'field' => 'country'],
            ["label" => 'State/Province/Territory', 'field' => 'state_province_territory'],
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
            ["label" => 'World Bank Income Band', 'field' => 'income_band'],
            );

        $body = $this->addLabelsToBody($labels);
        $this->displaySectionDetail($section, $body, $form, "closed");

        /* Contact Person */
        $section = "Contact Person";
        $labels = array(["label" => 'Name', 'field' => 'name'],
            ["label" => 'Position', 'field' => 'company'],  //Hack: Webform we have to use company field for position
            ["label" => 'Email', 'field' => 'email'],
            ["label" => 'Organization', 'field' => 'organization'],
        );
        $old_contact_labels = $this->addLabelsToBody($labels, 'property');
        $labels = array(["label" => 'Name', 'field' => 'contact_name'],
            ["label" => 'Position', 'field' => 'contact_position'],
            ["label" => 'Email', 'field' => 'contact_email'],
            ["label" => 'Organization', 'field' => 'contact_organization'],
        );

        $new_contact_labels = $this->addLabelsToBody($labels);
        //drupal_set_message("OLD Labels");
        //drupal_set_message($old_contact_labels);
        //drupal_set_message("NEW Labels");
        //drupal_set_message($new_contact_labels);

        $body = strcmp($this->getValue('contact_name'), "Variable not found") == 0 ? $old_contact_labels : $new_contact_labels;
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
                $uri = "";
                $filename = "";
                foreach($results as $row) {
                    $uri = $row['uri'];
                    $uri = str_replace("public://", "/sites/default/files/", $uri);
                    $filename = $row['filename'];
                }
                $link = '<a target="_blank" href="'.$uri.'">'.$filename.'</a>';
                /* In development and Stage some files may be missing so add [empty] if needed */
                /* Production should never have missing files for submissions */
                if(empty($uri) || empty($filename)) {
                    $link = '{empty}';
                }
                //drupal_set_message($filename." uri:".$uri." fid:".$fid);
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

        $random = new Random();
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
        //Lookup income_band code and change to Text Title
        $income_titles = array("H"=>"High Income", "MU"=>"Upper Middle Income", "ML"=>"Lower Middle Income", "L"=>"Low Income");
        //drupal_set_message(print_r($this->results, TRUE));
        /* Get Application Value */
        foreach($this->results as $row) {
            if(($row['name'] == 'email' && $field == 'email') || ($row['name'] == 'contact_email' && $field == 'contact_email')) {
                return '<a href="mailto:'.$row['value'].'">'.$row['value'].'</a>';
            } elseif($row['name'] == 'tier_radio' && $field == 'tier_radio') {
                return $roman[(int)$row['value']-1];
            } elseif($row['name'] == 'tier_radio' && $field == 'tier_radio_budget_range') {
                return $budget_ranges[(int)$row['value']-1];
            } elseif($row['name'] == 'income_band' && $field == 'income_band') {
                //drupal_set_message("income_band: ".$row['value']);
                return in_array($row['value'], array('H', 'MU', 'ML', 'L')) ? $income_titles[$row['value']] : '';
            } elseif($row['name'] == $field) {
                return $row['value'];
            }

        }
        return "";
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
        return "";
    }


    private function bootstrapContatainer($title, $body, $panel_state="collapsed") {
        //drupal_set_message("bootstrapContatainer: ".$title);
        $random = new Random();
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

    public function sendPartnershipApplicationApprovedEmail() {

        $mailManager = \Drupal::service('plugin.manager.mail');
        $module = 'icrp';
        $key = 'approvedPartnershipApplicationMail'; // Replace with Your key
        $to = $this->getValue('name')." <".strip_tags($this->getValue("email")).">";
        $params['message'] = "The message";
        $langcode = \Drupal::currentUser()->getPreferredLangcode();
        $send = true;
        /*
        drupal_set_message("module: ".$module);
        drupal_set_message("key: ".$key);
        drupal_set_message("to: ".$to);
        drupal_set_message("langcode: ".$langcode);
        drupal_set_message("send: ".(string)$send);
        drupal_set_message("params: ".print_r($params, true));
        drupal_set_message("CALLING mail from mailManager");
        */
        $result = $mailManager->mail($module, $key, $to, $langcode, $params, NULL, $send);
        /*
        drupal_set_message("result: ".(string)$result['result']);
        drupal_set_message("result array(): ".print_r($result, true));
        */
        if ($result['result'] != true) {
            $message = t('There was a problem sending your email notification to @email.', array('@email' => $to));
            \Drupal::messenger()->addError($message);
            \Drupal::logger('mail-log')->error($message);
            return;
        }

        $message = t('Partner Application Approved - An email notification has been sent to @email ', array('@email' => $to));
        //drupal_set_message($message);
        \Drupal::logger('mail-log')->notice($message);

    }

    public function submitForm(array &$form, FormStateInterface $form_state) {

        $form_values = $form_state->getValues();
        //drupal_set_message(print_r($form_state->getValues(), TRUE));
        $application_status = $form_values['status'];
        $this->setValue("application_status", $application_status);

        drupal_flush_all_caches();
        //$membership_status = ($form_values['status'] == 0) ? 'Blocked' : 'Active';

        if($application_status == "Completed") {
            $this->sendPartnershipApplicationApprovedEmail();
            $message = "Application for ".$this->getValue('organization_name')." is now completed and an email has been sent to the organization.";
        } else {
            $message = "Application  for ".$this->getValue('organization_name')." is now archived.";
        }

        \Drupal::messenger()->addStatus(t($message));

        $partial_form_values = [
            'id' => $this->sid,
            'is_completed' => $application_status == 'Completed',
        ] + $this->getFormValues([
            'organization_name',
            'country',
            'income_band',
            'email',
            'description_of_the_organization',
        ]);

        \Drupal::service('event_dispatcher')
            ->dispatch('db_admin.add_partner_application', new GenericEvent($partial_form_values));
    }

    /**
     * Retrieves the specified values from the submitted webform
     *
     * @param array $names - The names of the fields to retrieve
     * @return array - An associative array containing key/value pairs for the supplied names
     */
    public function getFormValues(array $names): array {

        $submission_data = array_filter(
            $this->getWebformSubmissionData(),
            function($row) use ($names) {
                return in_array($row['name'], $names);
            }
        );

        return array_reduce(
            $submission_data,
            function($accumulator = [], $row) {
                $accumulator[$row['name']] = $row['value'];
                return $accumulator;
            }
        );
    }
}
