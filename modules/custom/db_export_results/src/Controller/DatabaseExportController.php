<?php

/**
 * @file
 * Contains \Drupal\db_export_results\Controller\DatabaseExportController
 */

namespace Drupal\db_export_results\Controller;

use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use PDO;

class DatabaseExportController extends ControllerBase {

  private static function createResponse($data) {
    $response = Response::create($data, 200, [
      'Access-Control-Allow-Headers' => 'origin, content-type, accept',
      'Access-Control-Allow-Origin'  => '*',
      'Access-Control-Allow-Methods' => 'GET',
    ]);
    return $response;
  }

  private static function getExportUri(
    PDO $pdo,
    string $export_type,
    int $search_id = NULL,
    int $data_upload_id = NULL) {

    switch($export_type) {
      case 'export_results':
        $filename = sprintf('ICRP_Search_Results_Export_%s.xlsx', $search_id);
        $workbook_key = 'export_results';
        $is_public = true;
        $include_search_parameters = true;
        $url_prefix = '';
        break;

      case 'export_results_partners':
        $filename = sprintf('ICRP_Search_Results_Export_Partners_%s.xlsx', $search_id);
        $workbook_key = 'export_results_partners';
        $is_public = false;
        $include_search_parameters = true;
        $url_prefix = '';
        break;

      case 'export_results_single_sheet':
        $filename = sprintf('ICRP_Search_Results_Single_Sheet_Export_%s.xlsx', $search_id);
        $workbook_key = 'export_results_single_sheet';
        $is_public = false;
        $include_search_parameters = true;
        $url_prefix = '';
        break;

      case 'export_abstracts':
        $filename = sprintf('ICRP_Search_Abstracts_Export_%s.xlsx', $search_id);
        $workbook_key = 'export_abstracts';
        $is_public = false;
        $include_search_parameters = true;
        $url_prefix = '';
        break;

      case 'export_abstracts_single_sheet':
        $filename = sprintf('ICRP_Search_Abstracts_Single_Sheet_Export_%s.xlsx', $search_id);
        $workbook_key = 'export_abstracts_single_sheet';
        $is_public = false;
        $include_search_parameters = true;
        $url_prefix = '';
        break;

      case 'export_graphs':
        $filename = sprintf('ICRP_Search_Results_Graphs_%s.xlsx', $search_id);
        $is_public = true;
        return (new DatabaseExport())->exportGraphs($pdo, $filename, $search_id, $is_public);

      case 'export_graphs_partners':
        $filename = sprintf('ICRP_Search_Results_Graphs_Partners_%s.xlsx', $search_id);
        $is_public = false;
        return (new DatabaseExport())->exportGraphs($pdo, $filename, $search_id, $is_public);


      case 'review_export_results':
        $filename = sprintf('Review_ICRP_Search_Results_Export_%s.xlsx', $search_id);
        $workbook_key = 'export_results';
        $is_public = true;
        $include_search_parameters = false;
        $url_prefix = '';
        break;

      case 'review_export_results_partners':
        $filename = sprintf('Review_ICRP_Search_Results_Export_Partners_%s.xlsx', $search_id);
        $workbook_key = 'export_results_partners';
        $is_public = false;
        $include_search_parameters = false;
        $url_prefix = '';
        break;

      case 'review_export_results_single_sheet':
        $filename = sprintf('Review_ICRP_Search_Results_Single_Sheet_Export_%s.xlsx', $search_id);
        $workbook_key = 'export_results_single_sheet';
        $is_public = false;
        $include_search_parameters = false;
        $url_prefix = '';
        break;

      case 'review_export_abstracts':
        $filename = sprintf('Review_ICRP_Search_Abstracts_Export_%s.xlsx', $search_id);
        $workbook_key = 'export_abstracts';
        $is_public = false;
        $include_search_parameters = false;
        $url_prefix = '';
        break;

      case 'review_export_abstracts_single_sheet':
        $filename = sprintf('Review_ICRP_Search_Abstracts_Single_Sheet_Export_%s.xlsx', $search_id);
        $workbook_key = 'export_abstracts_single_sheet';
        $is_public = false;
        $include_search_parameters = false;
        $url_prefix = '';
        break;

      case 'review_export_graphs':
        $filename = sprintf('Review_ICRP_Search_Results_Graphs_%s.xlsx', $search_id);
        $is_public = true;
        return (new DatabaseExport())->exportGraphs($pdo, $filename, $search_id, $is_public);

      case 'review_export_graphs_partners':
        $filename = sprintf('Review_ICRP_Search_Results_Graphs_Partners_%s.xlsx', $search_id);
        $is_public = false;
        return (new DatabaseExport())->exportGraphs($pdo, $filename, $search_id, $is_public);
    }

    return (new DatabaseExport())->exportResults(
      $pdo,
      $search_id,
      $data_upload_id,
      $workbook_key,
      $filename,
      $is_public,
      $include_search_parameters,
      $url_prefix);
  }

  function exportSearchResults(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $uri = self::getExportUri($pdo, 'export_results', intval($search_id));
    return self::createResponse($uri);
  }

  function exportSearchResultsForPartners(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $uri = self::getExportUri($pdo, 'export_results_partners', intval($search_id));
    return self::createResponse($uri);
  }

  function exportSearchResultsInSingleSheet(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $uri = self::getExportUri($pdo, 'export_results_single_sheet', intval($search_id));
    return self::createResponse($uri);
  }

  function exportAbstracts(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $uri = self::getExportUri($pdo, 'export_abstracts', intval($search_id));
    return self::createResponse($uri);
  }

  function exportAbstractsInSingleSheet(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $uri = self::getExportUri($pdo, 'export_abstracts_single_sheet', intval($search_id));
    return self::createResponse($uri);
  }

  function exportGraphs(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $uri = self::getExportUri($pdo, 'export_graphs', intval($search_id));
    return self::createResponse($uri);
  }

  function exportGraphsForPartners(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $uri = self::getExportUri($pdo, 'export_graphs_partners', intval($search_id));
    return self::createResponse($uri);
  }


  function reviewExportSearchResults(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $data_upload_id = $request->query->get('data_upload_id', NULL);

    $uri = self::getExportUri($pdo, 'review_export_results', intval($search_id), intval($data_upload_id));
    return self::createResponse($uri);
  }

  function reviewExportSearchResultsForPartners(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $data_upload_id = $request->query->get('data_upload_id', NULL);

    $uri = self::getExportUri($pdo, 'review_export_results_partners', intval($search_id), intval($data_upload_id));
    return self::createResponse($uri);
  }

  function reviewExportSearchResultsInSingleSheet(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $data_upload_id = $request->query->get('data_upload_id', NULL);

    $uri = self::getExportUri($pdo, 'review_export_results_single_sheet', intval($search_id), intval($data_upload_id));
    return self::createResponse($uri);
  }

  function reviewExportAbstracts(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $data_upload_id = $request->query->get('data_upload_id', NULL);

    $uri = self::getExportUri($pdo, 'review_export_abstracts', intval($search_id), intval($data_upload_id));
    return self::createResponse($uri);
  }

  function reviewExportAbstractsInSingleSheet(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $data_upload_id = $request->query->get('data_upload_id', NULL);

    $uri = self::getExportUri($pdo, 'review_export_abstracts_single_sheet', intval($search_id), intval($data_upload_id));
    $data_upload_id = $request->query->get('data_upload_id', NULL);

    return self::createResponse($uri);
  }

  function reviewExportGraphs(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $uri = self::getExportUri($pdo, 'review_export_graphs', intval($search_id));
    return self::createResponse($uri);
  }

  function reviewExportGraphsForPartners(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $uri = self::getExportUri($pdo, 'review_export_graphs_partners', intval($search_id));
    return self::createResponse($uri);
  }

}
