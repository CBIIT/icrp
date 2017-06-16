<?php

/**
 * @file
 * Contains \Drupal\db_admin\Controller\AdminController.
 */

namespace Drupal\db_admin\Controller;

use Drupal;
use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\EventDispatcher\GenericEvent;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use Drupal\db_admin\Helpers\PDOBuilder;
use PDO;

/**
 * Controller routines for db_admin routes.
 */
class AdminController extends ControllerBase {

  const FUNDING_ORGANIZATION_PARAMETERS = [
    'sponsor_code'              => NULL,
    'member_type'               => NULL,
    'organization_name'         => NULL,
    'organization_abbreviation' => NULL,
    'organization_type'         => NULL,
    'annualized_funding'        => NULL,
    'country'                   => NULL,
    'currency'                  => NULL,
    'note'                      => NULL,
  ];

  /**
   * Merges all arrays from right to left - the last array provided contains the
   * full set of properties that will be present on the merged array
   *
   * @param array ...$arrays
   * @return array
   */
  private static function array_merge_intersection(...$arrays) {
    $source = end($arrays);
    $intersection = array_intersect_key(...$arrays);
    return array_merge($source, $intersection);
  }

  private static function createResponse($data = NULL, $status_code = 200) {
    $response = JsonResponse::create($data, $status_code, [
      'Access-Control-Allow-Headers' => 'origin, content-type, accept',
      'Access-Control-Allow-Origin'  => '*',
      'Access-Control-Allow-Methods' => 'GET, POST',
    ]);

    // ensure that the response contains formatted json
    $response->setEncodingOptions($response->getEncodingOptions() | JSON_PRETTY_PRINT);

    return $response;
  }

  public static function dispatchSampleEvent(Request $request) {
    $event_name = 'db_admin.add_partner_application';
    $event = new GenericEvent([
      'id' => 1,
      'organization_name' => 'Sample Organization One',
      'country' => 'AA',
      'email' => 'contact@organization',
      'description_of_the_organization' => 'Mission Statement',
      'is_completed' => true,
    ]);

    Drupal::service('event_dispatcher')->dispatch($event_name, $event);
    return self::createResponse();
  }

  public static function getFundingOrganizationFields() {
    $connection = PDOBuilder::getConnection();
    $data = FundingOrganizationManager::getFields($connection);
    return self::createResponse($data);
  }

  public static function addFundingOrganization(Request $request) {
    $connection = PDOBuilder::getConnection();
    $parameters = self::array_merge_intersection($request->query->all(), self::FUNDING_ORGANIZATION_PARAMETERS);
    $data = FundingOrganizationManager::addFundingOrganization($connection, $parameters);
    return self::createResponse($data);
  }
}

