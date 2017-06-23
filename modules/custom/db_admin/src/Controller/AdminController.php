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
    'map_coordinates'           => NULL,
    'is_annualized'             => NULL,
    'country'                   => NULL,
    'currency'                  => NULL,
    'note'                      => NULL,
  ];

  const PARTNER_PARAMETERS = [
    'partner_application_id'    => NULL,
    'partner_name'              => NULL,
    'joined_date'               => NULL,
    'country'                   => NULL,
    'email'                     => NULL,
    'description'               => NULL,
    'sponsor_code'              => NULL,
    'website'                   => NULL,
    'map_coordinates'           => NULL,
    'logo_file'                 => NULL,
    'note'                      => NULL,
    'agree_to_terms'            => NULL,
    'is_funding_organization'   => NULL,
    'organization_type'         => NULL,
    'is_annualized'             => NULL,
    'currency'                  => NULL,
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

    for ($i = 0; $i < 10; $i ++) {
      $event_name = 'db_admin.add_partner_application';
      $event = new GenericEvent([
        'id' => $i,
        'organization_name' => "Sample Organization $i",
        'country' => 'US',
        'email' => "email@organization$i",
        'description_of_the_organization' => "Mission Statement for Organization $i",
        'is_completed' => true,
      ]);

      Drupal::service('event_dispatcher')->dispatch($event_name, $event);
    }
    return self::createResponse(true);
  }

  public static function getFundingOrganizationFields() {
    $connection = PDOBuilder::getConnection();
    $data = FundingOrganizationManager::getFields($connection);
    return self::createResponse($data);
  }

  public static function addFundingOrganization(Request $request) {
    $connection = PDOBuilder::getConnection();
    $parameters = self::array_merge_intersection($request->request->all(), self::FUNDING_ORGANIZATION_PARAMETERS);
    $data = FundingOrganizationManager::addFundingOrganization($connection, $parameters);
    return self::createResponse($data);
  }

  public static function getPartnerFields() {
    $connection = PDOBuilder::getConnection();
    $data = PartnerManager::getFields($connection);
    return self::createResponse($data);
  }

  public static function addPartner(Request $request) {
    $connection = PDOBuilder::getConnection();
    $parameters = self::array_merge_intersection($request->request->all(), self::PARTNER_PARAMETERS);

    $uploaded_file = $request->files->get('logo_file');
    if ($uploaded_file) {
      $upload_directory = getcwd() . '/sites/default/files/uploads/partner-logos';
      $upload_errors = self::moveUploadedFile($upload_directory, $uploaded_file);
      if (!empty($upload_errors)) {
        return self::createResponse($upload_errors);
      }

      $parameters['logo_file'] = $uploaded_file->getClientOriginalName();
    }

    $data = PartnerManager::addPartner($connection, $parameters);
    return self::createResponse($data);
  }

  public static function moveUploadedFile($target_directory, $uploaded_file) {
    if (!file_exists($target_directory)) {
      mkdir($target_directory, 0744, true);
    }

    try {
      $filename = $uploaded_file->getClientOriginalName();
      $file = $uploaded_file->move($target_directory, $filename);
    }

    catch (Exception $e) {
      return [
        ['ERROR' => "The uploaded file could not be saved. Please ensure that the apache user has the appropriate permissions to write to: $target_directory" ]
      ];
    }

    return [];
  }
}

