<?php
/**
 * @file
 * Contains \Drupal\db_email_results\Controller\EmailResultsController.
 */
namespace Drupal\db_email_results\Controller;
include 'emailResults.php';

use Drupal\Core\Controller\ControllerBase;
class EmailResultsController extends ControllerBase {

  public function emailResults($parameters) {
  	  $param = json_decode($parameters);
  	  sendEmail($param);
  }
}