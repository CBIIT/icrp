<?php
/**
 * @file
 * Contains \Drupal\db_project_view\Controller\LatestNewsletterController.
 */
namespace Drupal\db_project_view\Controller;
use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;

class LatestNewsletterController extends ControllerBase {


  /**
  * Adds CORS Headers to a response
  */
  public function add_cors_headers($response) {
    $response->headers->set('Access-Control-Allow-Headers', 'origin, content-type, accept');
    $response->headers->set('Access-Control-Allow-Origin', '*');
    $response->headers->set('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, PATCH, OPTIONS');

    return $response;
  }
  public function getLatestNewletterData() {
    $dbutil = new DBUtil();
    $pdo = $dbutil -> get_connection();
    $stmt = $pdo -> prepare("{CALL GetLatestNewsletter}");
    $stmt->execute();
    return $stmt->fetchAll();
  }
  public function getLatestNewletter() {
    $results = self::getLatestNewletterData();
    return self::add_cors_headers(new JsonResponse($results));
  }  
}
