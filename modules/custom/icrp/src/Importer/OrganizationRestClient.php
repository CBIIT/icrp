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
        $sql = "SELECT field_organization_id_value, entity_id FROM node__field_organization_id;";
        $current_organization_ids = db_query($sql)->fetchAllAssoc('field_organization_id_value',PDO::FETCH_ASSOC);
        $query = \Drupal::entityQuery('node')
                   ->condition('type', 'organization', '=')
                   ->condition('field_organization_id', array_map('self::mapEntityID',$organizations), 'NOT IN');
        $non_extant_org_ids = array_values($query->execute());
        foreach ($organizations as $key=>$organization) {
            if (array_key_exists($organization['ID'],$current_organization_ids)) {
                $node = Node::load($current_organization_ids[$organization['ID']]['entity_id']);
                $nodeArray = $node->toArray();
                if (($nodeArray['title'][0]['value'] != $organization['Name']) || ($nodeArray['body'][0]['value'] != $organization['Name']) || ($nodeArray['status'][0]['value'] != $organization['IsActive'])) {
                    $node->set('title', $organization['Name']);
                    $node->set('body', $organization['Name']);
                    $node->set('status', intval($organization['IsActive']));
                    $node->save();
                }
            } else {
                self::addOrganization($organization);
            }
        }
        $nodes_to_delete = Node::loadMultiple($non_extant_org_ids);
        foreach($nodes_to_delete as $node) {
            $node->delete();
        }
    }

    private static function mapEntityID($entity) {
        return $entity['ID'];
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

    public static function get_dsn($cfg): string {
        $dsn = [
          'Server' => "$cfg[host],$cfg[port]",
          'Database' => $cfg['database'],
        ];
    
        if ($cfg['options']) {
          $dsn += $cfg['options'];
        }
    
        $dsnString = join(';', array_map(
          fn($k, $v) => "$k=$v", 
          array_keys($cfg['dsn']), 
          array_values($cfg['dsn'])
        ));
    
        return "$cfg[driver]:$dsnString";
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
  private static function get_connection($database_name='icrp_database') {
    $cfg = \Drupal::config($database_name)->get();
    // default configuration options
    $cfg['options'] = [
      PDO::SQLSRV_ATTR_ENCODING    => PDO::SQLSRV_ENCODING_UTF8,
      PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
      PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
  //  PDO::ATTR_EMULATE_PREPARES   => false,
    ];
    // create new PDO object
    return new PDO(
      self::get_dsn($cfg),
      $cfg['username'],
      $cfg['password'],
      $cfg['options']
    );
  }
}