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

  function __construct() {
    $partnerLogosFolder = \Drupal::config('icrp-data')->get('partner-logos') ?? 'data/uploads/partner-logos';
    if (!file_exists($partnerLogosFolder))
      mkdir($partnerLogosFolder, 0744, true);
  }


  private static function createResponse($data = NULL, $status = 200) {
    return JsonResponse::create($data, $status, [
      'Access-Control-Allow-Headers' => 'origin, content-type, accept',
      'Access-Control-Allow-Origin'  => '*',
      'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS',
    ]);
  }

  private static function emptyToNull() {
    return function($value) {
      switch($value) {
        case 'undefined':
        case 'null':
        case '':
          return null;
        case 'true':
          return true;
        case 'false':
          return false;
      }
      return $value;
    };
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
    try {
      $connection = PDOBuilder::getConnection();
      $data = FundingOrganizations::getFields($connection);
      return self::createResponse($data);
    }

    catch (Exception $e) {
      $message = preg_replace('/^SQLSTATE\[.*\]:?/', '', $e->getMessage());
      return self::createResponse($message, 500);
    }
  }

  public static function addFundingOrganization(Request $request) {
    try {
      $connection = PDOBuilder::getConnection();
      $parameters = array_map(self::emptyToNull(), $request->request->all());
      $data = FundingOrganizations::add($connection, $parameters);
      return self::createResponse($parameters);
    }

    catch (Exception $e) {
      $message = preg_replace('/^SQLSTATE\[.*\]:?/', '', $e->getMessage());
      return self::createResponse($message, 500);
    }
  }

  public static function updateFundingOrganization(Request $request) {
    try {
      $connection = PDOBuilder::getConnection();
      $parameters = array_map(self::emptyToNull(), $request->request->all());
      $data = FundingOrganizations::update($connection, $parameters);
      return self::createResponse($data);
    }

    catch (Exception $e) {
      $message = preg_replace('/^SQLSTATE\[.*\]:?/', '', $e->getMessage());
      return self::createResponse($message, 500);
    }
  }

  public static function getPartnerFields() {
    try {
      $connection = PDOBuilder::getConnection();
      $data = Partners::getFields($connection);
      return self::createResponse($data);
    }

    catch (Exception $e) {
      $message = preg_replace('/^SQLSTATE\[.*\]:?/', '', $e->getMessage());
      return self::createResponse($message, 500);
    }
  }

  public static function addPartner(Request $request) {
    try {
      $parameters = array_map(self::emptyToNull(), $request->request->all());
      $uploadedFile = $request->files->get('logoFileInput');

      if ($uploadedFile) {
        $parameters['logoFile'] = $uploadedFile->getClientOriginalName();
        $partnerLogosFolder = \Drupal::config('icrp-data')->get('partner-logos') ?? 'data/uploads/partner-logos';
        $uploadedFile->move($partnerLogosFolder, $parameters['logoFile']);
      }

      $connection = PDOBuilder::getConnection();
      $data = Partners::add($connection, $parameters);
      return self::createResponse($data);
    }

    catch (Exception $e) {
      error_log($e->getMessage());
      $message = preg_replace('/^SQLSTATE\[.*\]:?/', '', $e->getMessage());
      // return self::createResponse($parameters, 500);
      return self::createResponse($message, 500);
    }
  }

  public static function updatePartner(Request $request) {
    try {
      $parameters = array_map(self::emptyToNull(), $request->request->all());
      $uploadedFile = $request->files->get('logoFileInput');

      if ($uploadedFile) {
        $parameters['logoFile'] = $uploadedFile->getClientOriginalName();
        $partnerLogosFolder = \Drupal::config('icrp-data')->get('partner-logos') ?? 'data/uploads/partner-logos';
        $uploadedFile->move($partnerLogosFolder, $parameters['logoFile']);
      }

      $connection = PDOBuilder::getConnection();
      $data = Partners::update($connection, $parameters);
      return self::createResponse($data);
    }

    catch (Exception $e) {
      $message = preg_replace('/^SQLSTATE\[.*\]:?/', '', $e->getMessage());
      // return self::createResponse($parameters, 500);
      return self::createResponse($message, 500);
    }
  }


  public static function addNonPartner(Request $request) {
    try {
      $parameters = array_map(self::emptyToNull(), $request->request->all());
      $uploadedFile = $request->files->get('logoFileInput');

      if ($uploadedFile) {
        $parameters['logoFile'] = $uploadedFile->getClientOriginalName();
        $partnerLogosFolder = \Drupal::config('icrp-data')->get('partner-logos') ?? 'data/uploads/partner-logos';
        $uploadedFile->move($partnerLogosFolder, $parameters['logoFile']);
      }

      $connection = PDOBuilder::getConnection();
      $data = NonPartners::add($connection, $parameters);
      return self::createResponse($data);
    }

    catch (Exception $e) {
      $message = preg_replace('/^SQLSTATE\[.*\]:?/', '', $e->getMessage());
      return self::createResponse($message, 500);
    }
  }

  public static function updateNonPartner(Request $request) {
    try {
      $parameters = array_map(self::emptyToNull(), $request->request->all());
      $uploadedFile = $request->files->get('logoFileInput');

      if ($uploadedFile) {
        $parameters['logoFile'] = $uploadedFile->getClientOriginalName();
        $partnerLogosFolder = \Drupal::config('icrp-data')->get('partner-logos') ?? 'data/uploads/partner-logos';
        $uploadedFile->move($partnerLogosFolder, $parameters['logoFile']);
      }

      $connection = PDOBuilder::getConnection();
      $data = NonPartners::update($connection, $parameters);
      return self::createResponse($data);
    }

    catch (Exception $e) {
      $message = preg_replace('/^SQLSTATE\[.*\]:?/', '', $e->getMessage());
      return self::createResponse($parameters, 500);
      return self::createResponse($message, 500);
    }
  }

  public static function getInstitutionFields() {
    try {
      $connection = PDOBuilder::getConnection();
      $data = Institutions::getFields($connection);
      return self::createResponse($data);
    }

    catch (Exception $e) {
      $message = preg_replace('/^SQLSTATE\[.*\]:?/', '', $e->getMessage());
      return self::createResponse($message, 500);
    }
  }

  public static function addInstitution(Request $request) {
    try {
      $parameters = array_map(self::emptyToNull(), $request->request->all());
      $connection = PDOBuilder::getConnection();
      $data = Institutions::add($connection, $parameters);
      return self::createResponse($data);
    }

    catch (Exception $e) {
      $message = preg_replace('/^SQLSTATE\[.*\]:?/', '', $e->getMessage());
      return self::createResponse($message, 500);
    }
  }

  public static function updateInstitution(Request $request) {
    try {
      $parameters = array_map(self::emptyToNull(), $request->request->all());
      $connection = PDOBuilder::getConnection();
      $data = Institutions::update($connection, $parameters);
      return self::createResponse($data);
    }

    catch (Exception $e) {
      $message = preg_replace('/^SQLSTATE\[.*\]:?/', '', $e->getMessage());
      return self::createResponse($message, 500);
    }
  }

  public static function mergeInstitution(Request $request) {
    try {
      $parameters = array_map(self::emptyToNull(), $request->request->all());
      $connection = PDOBuilder::getConnection();
      $data = Institutions::merge($connection, $parameters);
      return self::createResponse($data);
    }

    catch (Exception $e) {
      $message = preg_replace('/^SQLSTATE\[.*\]:?/', '', $e->getMessage());
      return self::createResponse($message, 500);
    }
  }

}
