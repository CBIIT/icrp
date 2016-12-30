<?php
/**
 * @file
 * Contains \Drupal\db_email_results\Controller\EmailResultsController.
 */
namespace Drupal\db_export_results\Controller;
include 'exportResults.php';

use Drupal\Core\Controller\ControllerBase;
class ExportResultsController extends ControllerBase {

  public function exportResults($parameters) {
  	  $param = json_decode($parameters);
  	  exportResult($param);
  }
}