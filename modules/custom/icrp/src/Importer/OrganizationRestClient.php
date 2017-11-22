<?php
/**
 * @file
 * Contains \Drupal\icrp\Importer\OrganizationRestClient
 */
namespace Drupal\icrp\Importer;

use \Drupal\icrp\Controller\IcrpController;
use Symfony\Component\HttpFoundation\Request;
use \Drupal\node\Entity\Node;

class OrganizationRestClient {
    /*
    * Add organizatins from a remote REST service to the organization entity.
    *  * Example usage:
    * @code
    * \Drupal\icrp\Importer\OrganizationRestClient::populateOrganization();
    * @endcode
    */
    public static function populateOrganizations() {
        //drupal_set_message("populateOrganizations");
        /*
        * STEP 1: Write an AJAX call to retrieve url above
        * Search Drupal 8 Ajax call
        */

        $organizations = self::getRestOrganizations();
        //\Drupal::logger('icrp')->notice($organizations);
        //drupal_set_message("gettype(organizations): ".gettype($organizations));

        /*
        * STEP 2: Save into enitity type Organization
        * Ignore if array is empty
        */
        if (sizeof($organizations) > 0) {
            self::checkOrganizations($organizations);
        }
    }

    /*
    * Returns list of organizations from a rest service
    * @returns array $organizations
    *   If the rest service does not work an empty array is returned.
    */
    private static function getRestOrganizations() {
        //Example: http://drupal.stackexchange.com/questions/128274/consuming-restful-web-services
        //Documentation: http://docs.guzzlephp.org/en/latest/

        //Use ajax to pull url
        //$host = "https://icrpartnership-test.org";
        //if host is localhost then point to a known address

        if(strcmp(\Drupal::request()->getHttpHost(), "localhost") ==0) {
            $host = "https://icrpartnership-dev.org";
        } else {
            $host = \Drupal::request()->getSchemeAndHttpHost();
        }

        $url = $host . "/getFundingOrgNames";

        \Drupal::logger('icrp')->notice("getRestOrganization pulling url: " . $url);
        try {
            $client = \Drupal::service('http_client');
            //$result = $client->get($url, ['Accept' => 'application/json']);
            $result = $client->get($url, ['Accept' => 'text/plain']);
            $status = $result->getStatusCode();
            \Drupal::logger('icrp')->warning("url: ".$url);
            //\Drupal::logger('icrp')->warning("result: ".print_r($result, true));
            //\Drupal::logger('icrp')->warning("status: " . $status);
            if ($status != 200) {
                \Drupal::logger('icrp')->warning("getRestOrganization failed: Status Code: " . $status);
                return array();
            }
        } catch (Exception $e) {
            \Drupal::logger('icrp')->warning("Rest Service failed: " . $e->getMessage());
            return array();
        }

        //drupal_set_message($status);

        $output = $result->getBody();
        //drupal_set_message($output);
        /* "auto" is expanded to "ASCII,JIS,UTF-8,EUC-JP,SJIS" */
        /*
        $output = '
        [{"ID":"1","Name":"ACS - American Cancer Society is the best","IsActive":"0"},
        {"ID":"2","Name":"AICR (USA) - American Institute for Cancer Research","IsActive":"0"},
        {"ID":"3","Name":"AVONFDN - AVON Foundation","IsActive":"1"},
        {"ID":"4","Name":"AVONFDN - Avon Foundation for Women","IsActive":"1"},
        {"ID":"5","Name":"CAC2 - Alex\'s Lemonade Stand Foundation is great","IsActive":"1"},
        {"ID":"6","Name":"CAC2 - Braden\'s Hope For Childhood Cancer","IsActive":"1"},
        {"ID":"7","Name":"CAC2 - Taking over this org.","IsActive":"0"},
        {"ID":"8","Name":"CAC2 - CSCN Alliance","IsActive":"0"},
        {"ID":"9","Name":"CAC2 - Luck2Tuck","IsActive":"1"},
        {"ID":"11","Name":"We got this.","IsActive":"1"},
        {"ID":"10","Name":"CAC2 - Noah\'s Light","IsActive":"1"}]';
        */
        //drupal_set_message($output);
        $organizations = json_decode($output, true);

        return $organizations;
    }

    /*
    * Check organizations enitty to see if any organizations need to be added to the organization entity
     * @params array $organizations
    */
    private static function checkOrganizations(array $organizations) {
        // Get a list of current organizations
        $sql = "SELECT field_organization_id_value FROM node__field_organization_id;";
        $current_organization_ids = db_query($sql)->fetchCol();
        drupal_set_message(print_r($current_organization_ids, true));

        // If Organization doesn't exist then save into database

        foreach ($organizations as $key => $organization) {
            $organization_id = $organization["ID"];
            drupal_set_message($organization['ID'].", ".$organization['Name'].", ".$organization['IsActive']);
            //Look up Organization $nid
            \Drupal::logger('icrp')->notice("Looking for: ".$organization['ID']);

            if (!in_array(intval($organization['ID']), $current_organization_ids)) {
                drupal_set_message("Adding: org: ".$organization['ID']);
                self::addOrganization($organization);
            } else {
                drupal_set_message("Update org: ".$organization['ID']);
                self::updateOrganization($organization);
            }

        }
    }

    /*
    * Update an existing organization to organization entity.
    * @param array $organization
    */
    private static function updateOrganization(array $organization) {
        //Lookup node by organization ID
        $query = \Drupal::entityQuery('node')
            ->condition('type', 'organization', '=')
            ->condition('field_organization_id', $organization['ID'], '=');
        $nids = $query->execute();
        //drupal_set_message("nids = ".print_r($nids, true));
        $nid = 0;
        foreach($nids as $key => $value) {
            //drupal_set_message($key." => ".$value);
            $nid = $value;
        }
        if($nid != 0) {
            //\Drupal::logger('icrp')->notice("Updataing Organization: ID: " . $organization['ID']);
            //drupal_set_message("Updataing Organization: ID: " . $organization['ID'], 'notice');
            //drupal_set_message("Organization Details: " .print_r($organization, true), 'notice');
            $node = Node::load($nid);
            $node->set('title', $organization['Name']);
            $node->set('body', $organization['Name']);
            $node->set('status', intval($organization['IsActive']));
            $node->save();
            //drupal_set_message("SAVED A NODE:");

        } else {
            \Drupal::logger('icrp')->warning("Organization Not found: ID:" . $organization['ID']);
            //drupal_set_message("Organization not found nid: ".$nid, 'warning');
        }

    }
    /*
    * Add new organization to organization entity.
    * @param array $organization
    */
    private static function addOrganization(array $organization) {

        \Drupal::logger('icrp')->notice("Adding " . $organization['Name'] . " to organization.");
        $node = Node::create(array('title' => $organization['Name'],
                                    'body' => $organization['Name'],
                                    'field_organization_id' => $organization['ID'],
                                    'status' => $organization['IsActive'],
                                    'type' => 'organization'));
        $node->save();
    }
}