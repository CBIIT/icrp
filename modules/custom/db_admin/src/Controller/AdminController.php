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
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;
use Exception;

/**
 * Controller routines for db_admin routes.
 */
class AdminController extends ControllerBase {

  private static function createResponse($data = NULL, $status = 200) {
    return JsonResponse::create($data, $status, [
      'Access-Control-Allow-Headers' => 'origin, content-type, accept',
      'Access-Control-Allow-Origin'  => '*',
      'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS',
    ]);
  }

  public static function dispatchSampleEvent(Request $request) {
    for ($i = 0; $i < 10; $i ++) {
      $event_name = 'db_admin.add_partner_application';
      $event = new GenericEvent([
        'id' => $i,
        'organization_name' => "Sample Organization $i",
        'country' => 'Italy',
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
    $data = FundingOrganizations::getFields($connection);
    return self::createResponse($data);
  }

  public static function addFundingOrganization(Request $request) {
    try {
      $connection = PDOBuilder::getConnection();
      $parameters = $request->request->all();
      $data = FundingOrganizations::add($connection, $parameters);
      return self::createResponse($data);
    }

    catch (Exception $e) {
      $message = preg_replace('/^SQLSTATE\[.*\]/', '', $e->getMessage());
      return self::createResponse($message, 500);
    }
  }

  public static function updateFundingOrganization(Request $request) {
    try {
      $connection = PDOBuilder::getConnection();
      $parameters = $request->request->all();
      $data = FundingOrganizations::update($connection, $parameters);
      return self::createResponse($data);
    }

    catch (Exception $e) {
      $message = preg_replace('/^SQLSTATE\[.*\]/', '', $e->getMessage());
      return self::createResponse($message, 500);
    }
  }

  public static function getPartnerFields() {
    $connection = PDOBuilder::getConnection();
    $data = Partners::getFields($connection);
    return self::createResponse($data);
  }

  public static function addPartner(Request $request) {
    $parameters = $request->request->all();
    $uploadedFile = $request->files->get('logoFile');

    try {
      if ($uploadedFile) {
        $uploadedFile->move('data/uploads/partner-logos');
        $parameters['logo_file'] = $uploadedFile->getClientOriginalName();
      }

      $connection = PDOBuilder::getConnection();
      $data = FundingOrganizations::add($connection, $parameters);
      return self::createResponse($data);
    }

    catch (Exception $e) {
      $message = preg_replace('/^SQLSTATE\[.*\]/', '', $e->getMessage());
      return self::createResponse($message, 500);
    }
  }
}

