<?php
/**
 * @file
 * Contains \Drupal\db_project_view\Controller\UploadStatusReportController.
 */
namespace Drupal\db_project_view\Controller;
use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;

class UploadStatusReportController extends ControllerBase {


  /** Field mappings of database results to template variables */
  const FIELD_MAP = [
    'funding_org_names' => [
      'Name' => 'name',
      'Abbreviation' => 'abbr',
      'DisplayName' => 'displayname',
      'Type' => 'type',
      'MemberType' => 'membertype',
      'MemberStatus' => 'memberstatus',
      'Country' => 'country',
      'Currency' => 'currency',
      'SponsorCode' => 'sponsorcode',
      'IsAnnualized' => 'isannualized',
      'Note' => 'note',
      'LastImportDate' => 'lastimpordate',
      'LastImportNotes' => 'lastimportnotes',
    ],
  ];


  /**
  * Adds CORS Headers to a response
  */
  public function add_cors_headers($response) {
    $response->headers->set('Access-Control-Allow-Headers', 'origin, content-type, accept');
    $response->headers->set('Access-Control-Allow-Origin', '*');
    $response->headers->set('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, PATCH, OPTIONS');

    return $response;
  }

  public function getUploadStatusDetails() {
    $dbutil = new DBUtil();
    $pdo = $dbutil -> get_connection();

    $stmt = $pdo->prepare("
      SELECT 
       PartnerCode as partner,
       FundingYear as funding_year,
       Status as status,
       CAST(ReceivedDate as DATE) received_date,
       CAST(ValidationDate as DATE) validation_date,
       CAST(UploadToDevDate as DATE) dev_date,
       CAST(UploadToStageDate as DATE) stage_date,
       CAST(UploadToProdDate as DATE) prod_date
       FROM DataUploadStatus
       ");
     $stmt->execute();
     return $stmt->fetchAll(PDO::FETCH_ASSOC);
  }
  public function getUploadStatus() {
    $results = self::getUploadStatusDetails();
    return self::add_cors_headers(new JsonResponse($results));
  }  

  public function uploadStatusReport() {
   return [
     '#theme' => 'upload_status_report_view',
     '#attached' => [
        'library' => [
          'db_project_view/upload_status_report_resources'
        ],
     ],
   ];
  }
}
