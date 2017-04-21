<?php
/**
 * @file
 * Contains \Drupal\db_project_view\Controller\FundingOrgController.
 */
namespace Drupal\db_project_view\Controller;
use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use PDO;

class FundingOrgController extends ControllerBase {


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

  public function getFundingOrgDetails() {
    $dbutil = new DBUtil();
    $pdo = $dbutil -> get_connection();
    $stmt = $pdo->prepare("
      SELECT DISTINCT
       Name  AS name,
       Abbreviation AS abbr,
       Country as country,
       SponsorCode as sponsor,
       Currency as currency,
       LastImportDesc as description,
       CAST(LastImportDate as DATE) import_date,
       CASE WHEN IsAnnualized = 1 THEN 'YES'
            ELSE 'NO'
       END as annual
       FROM FundingOrg
       ");
     $stmt->execute();
     return $stmt->fetchAll(PDO::FETCH_ASSOC);
  }
  public function getFundingOrg() {
    $results = self::getFundingOrgDetails();
    return self::add_cors_headers(new JsonResponse($results));
  }  

  public function getFundingOrgNamesData() {
    $dbutil = new DBUtil();
    $pdo = $dbutil -> get_connection();
    $stmt = $pdo -> prepare("{CALL GetPartnerOrgs}");
    $stmt->execute();
    return $stmt->fetchAll();
  }
  public function getFundingOrgNames() {
    $results = self::getFundingOrgNamesData();
    return self::add_cors_headers(new JsonResponse($results));
  }  
  public function getFundingOrgContent() {
   return [
     '#theme' => 'funding_org_view',
     '#attached' => [
        'library' => [
          'db_project_view/funding_org_resources'
        ],
     ],
   ];
  }
}
