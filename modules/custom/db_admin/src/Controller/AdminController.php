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

use PDO;

/**
 * Controller routines for db_admin routes.
 */
class AdminController extends ControllerBase {
  private static function createResponse($data = NULL, $status_code = 200) {
    return JsonResponse::create($data, $status_code, [
      'Access-Control-Allow-Headers' => 'origin, content-type, accept',
      'Access-Control-Allow-Origin'  => '*',
      'Access-Control-Allow-Methods' => 'GET, POST',
    ]);
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
}

