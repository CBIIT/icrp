<?php
/**
 * @file
 * Contains \Drupal\icrp\Importer\OrganizationRestClient
 */
namespace Drupal\icrp\Importer;

use \Drupal\icrp\Controller\IcrpController;
use Symfony\Component\HttpFoundation\Request;
use \Drupal\node\Entity\Node;
use PDO;

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
        $organizations = [];
        $connection = self::get_connection();
        $stmt = $connection->prepare(
            "EXECUTE GetPartnerOrgs"
        );
        if ($stmt->execute()) {
            $organizations = array_merge([],$stmt->fetchAll(PDO::FETCH_ASSOC));
        }

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
        //drupal_set_message(print_r($current_organization_ids, true));

        // If Organization doesn't exist then save into database

        foreach ($organizations as $key => $organization) {
            $organization_id = $organization["ID"];
            //drupal_set_message($organization['ID'].", ".$organization['Name'].", ".$organization['IsActive']);
            //Look up Organization $nid
            \Drupal::logger('icrp')->notice("Looking for: ".$organization['ID']);

            if (!in_array(intval($organization['ID']), $current_organization_ids)) {
                //drupal_set_message("Adding: org: ".$organization['ID']);
                self::addOrganization($organization);
            } else {
                //drupal_set_message("Update org: ".$organization['ID']);
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

  /**
   * Returns a PDO connection to a database
   * @param $cfg - An associative array containing connection parameters 
   *   driver:    DB Driver
   *   server:    Server Name
   *   database:  Database
   *   user:      Username
   *   password:  Password
   *
   * @return A PDO connection
   * @throws PDOException
   */
  private static function get_connection() {
    $cfg = [];
    $icrp_database = \Drupal::config('icrp_database');
    foreach(['driver', 'host', 'port', 'database', 'username', 'password'] as $key) {
       $cfg[$key] = $icrp_database->get($key);
    }
    // connection string
    $cfg['dsn'] =
      $cfg['driver'] .
      ":Server={$cfg['host']},{$cfg['port']}" .
      ";Database={$cfg['database']};ConnectionPooling=0";
    // default configuration options
    $cfg['options'] = [
      PDO::SQLSRV_ATTR_ENCODING    => PDO::SQLSRV_ENCODING_UTF8,
      PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
      PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
  //  PDO::ATTR_EMULATE_PREPARES   => false,
    ];
    // create new PDO object
    return new PDO(
      $cfg['dsn'],
      $cfg['username'],
      $cfg['password'],
      $cfg['options']
    );
  }
}