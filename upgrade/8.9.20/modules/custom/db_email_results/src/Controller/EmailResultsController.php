<?php
/**
 * @file
 * Contains \Drupal\db_email_results\Controller\EmailResultsController.
 */

namespace Drupal\db_email_results\Controller;

use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;

class EmailResultsController extends ControllerBase {

  const ALLOWED_PARAMETERS = [
    'search_id',
    'sender_name',
    'recipient_addresses',
    'personal_message',
  ];

  const EMAIL_PARAMETERS = [
    'search_id'             => NULL,
    'sender_address'        => 'operations@icrpartnership.org',
    'sender_name'           => NULL,
    'recipient_addresses'   => NULL,
    'search_results_url'    => NULL,
    'personal_message'      => NULL,
    'attachments'           => [],
  ];

  /**
   * Creates a new JSON response with CORS headers
   *
   * @param any $data
   * @return JSONResponse
   */
  private static function createResponse($data): JSONResponse {
    $response = JsonResponse::create($data, 200, [
      'Access-Control-Allow-Headers' => 'origin, content-type, accept',
      'Access-Control-Allow-Origin'  => '*',
      'Access-Control-Allow-Methods' => 'GET',
    ]);

    // format json
    $response->setEncodingOptions($response->getEncodingOptions() | JSON_PRETTY_PRINT);
    return $response;
  }

  public static function emailResults(Request $request) {
    $parameters = self::EMAIL_PARAMETERS;
    foreach (self::ALLOWED_PARAMETERS as $key) {
      $parameters[$key] = $request->query->get($key);
    }


    $parameters['search_results_url'] =
      ( $request->server->get('HTTPS') ? 'https://' : 'http://' )
      . $request->server->get('SERVER_NAME')
      . '/db_search?sid='
      . $parameters['search_id'];

    return self::createResponse(EmailResults::sendEmail($parameters));
  }
}
