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
    string $workbook_key,
    int $search_id = NULL,
    int $data_upload_id = NULL) {

    $filename = [
      DatabaseExport::EXPORT_RESULTS_PUBLIC                          => sprintf('ICRP_Search_Results_Export_%s.xlsx', $search_id),
      DatabaseExport::EXPORT_RESULTS_PARTNERS                        => sprintf('ICRP_Search_Results_Export_Partners_%s.xlsx', $search_id),
      DatabaseExport::EXPORT_RESULTS_AS_SINGLE_SHEET                 => sprintf('ICRP_Search_Results_Single_Sheet_Export_%s.xlsx', $search_id),
      DatabaseExport::EXPORT_RESULTS_WITH_ABSTRACTS                  => sprintf('ICRP_Search_Abstracts_Export_%s.xlsx', $search_id),
      DatabaseExport::EXPORT_RESULTS_WITH_ABSTRACTS_AS_SINGLE_SHEET  => sprintf('ICRP_Search_Abstracts_Single_Sheet_Export_%s.xlsx', $search_id),
      DatabaseExport::EXPORT_GRAPHS_PUBLIC                           => sprintf('ICRP_Search_Results_Graphs_%s.xlsx', $search_id),
      DatabaseExport::EXPORT_GRAPHS_PARTNERS                         => sprintf('ICRP_Search_Results_Graphs_Partners_%s.xlsx', $search_id),
    ][$workbook_key];

    $url_path_prefix = $data_upload_id != NULL
      ? '/review' 
      : '';

    return in_array($workbook_key, [DatabaseExport::EXPORT_GRAPHS_PUBLIC, DatabaseExport::EXPORT_GRAPHS_PARTNERS])
      ? (new DatabaseExport())
          ->exportGraphs($pdo, $search_id, $workbook_key, $filename)
      : (new DatabaseExport())
          ->exportResults($pdo, $search_id, $data_upload_id, $workbook_key, $filename, $url_path_prefix);
  }

  function exportSearchResults(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_PUBLIC, intval($search_id));
    return self::createResponse($uri);
  }

  function exportSearchResultsForPartners(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_PARTNERS, intval($search_id));
    return self::createResponse($uri);
  }

  function exportSearchResultsInSingleSheet(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_AS_SINGLE_SHEET, intval($search_id));
    return self::createResponse($uri);
  }

  function exportAbstracts(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_WITH_ABSTRACTS, intval($search_id));
    return self::createResponse($uri);
  }

  function exportAbstractsInSingleSheet(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_WITH_ABSTRACTS_AS_SINGLE_SHEET, intval($search_id));
    return self::createResponse($uri);
  }

  function exportGraphs(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_GRAPHS_PUBLIC, intval($search_id));
    return self::createResponse($uri);
  }

  function exportGraphsForPartners(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_GRAPHS_PARTNERS, intval($search_id));
    return self::createResponse($uri);
  }


  function reviewExportSearchResults(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $data_upload_id = $request->query->get('data_upload_id', NULL);

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_PUBLIC, intval($search_id), intval($data_upload_id));
    return self::createResponse($uri);
  }

  function reviewExportSearchResultsForPartners(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $data_upload_id = $request->query->get('data_upload_id', NULL);

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_PARTNERS, intval($search_id), intval($data_upload_id));
    return self::createResponse($uri);
  }

  function reviewExportSearchResultsInSingleSheet(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $data_upload_id = $request->query->get('data_upload_id', NULL);

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_AS_SINGLE_SHEET, intval($search_id), intval($data_upload_id));
    return self::createResponse($uri);
  }

  function reviewExportAbstracts(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $data_upload_id = $request->query->get('data_upload_id', NULL);

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_WITH_ABSTRACTS, intval($search_id), intval($data_upload_id));
    return self::createResponse($uri);
  }

  function reviewExportAbstractsInSingleSheet(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $data_upload_id = $request->query->get('data_upload_id', NULL);

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_WITH_ABSTRACTS_AS_SINGLE_SHEET, intval($search_id), intval($data_upload_id));
    return self::createResponse($uri);
  }

  function reviewExportGraphs(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $data_upload_id = $request->query->get('data_upload_id', NULL);

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_GRAPHS_PUBLIC, intval($search_id));
    return self::createResponse($uri);
  }

  function reviewExportGraphsForPartners(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', $_SESSION['database_search_id']);
    $data_upload_id = $request->query->get('data_upload_id', NULL);

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_GRAPHS_PARTNERS, intval($search_id));
    return self::createResponse($uri);
  }
}
