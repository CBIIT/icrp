<?php

/**
 * @file
 * Contains \Drupal\db_export_results\Controller\DatabaseExportController
 */

namespace Drupal\db_export_results\Controller;

use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\StreamedResponse;
use PDO;

class DatabaseExportController extends ControllerBase {

  private static function createResponse($data) {
    $response = Response::create($data, 200, [
      'Access-Control-Allow-Headers' => 'origin, content-type, accept',
      'Access-Control-Allow-Origin'  => '*',
      'Access-Control-Allow-Methods' => 'GET,POST',
    ]);
    return $response;
  }

  private static function getExportUri(
    PDO $pdo,
    string $workbook_key,
    int $search_id = NULL,
    int $data_upload_id = NULL,
    int $year = NULL) {

    $filename = [
      DatabaseExport::EXPORT_RESULTS_PUBLIC                          => sprintf('ICRP_Search_Results_Export_%s.xlsx', $search_id),
      DatabaseExport::EXPORT_RESULTS_PARTNERS                        => sprintf('ICRP_Search_Results_Export_Partners_%s.xlsx', $search_id),
      DatabaseExport::EXPORT_RESULTS_AS_SINGLE_SHEET                 => sprintf('ICRP_Search_Results_Single_Sheet_Export_%s.xlsx', $search_id),
      DatabaseExport::EXPORT_RESULTS_WITH_ABSTRACTS                  => sprintf('ICRP_Search_Abstracts_Export_%s.xlsx', $search_id),
      DatabaseExport::EXPORT_RESULTS_WITH_ABSTRACTS_AS_SINGLE_SHEET  => sprintf('ICRP_Search_Abstracts_Single_Sheet_Export_%s.xlsx', $search_id),
      DatabaseExport::EXPORT_CSO_CANCER_TYPES                        => sprintf('ICRP_CSO_Cancer_Types_Export_%s.xlsx', $search_id),
      DatabaseExport::EXPORT_GRAPHS_PUBLIC                           => sprintf('ICRP_Search_Results_Graphs_%s.xlsx', $search_id),
      DatabaseExport::EXPORT_GRAPHS_PARTNERS                         => sprintf('ICRP_Search_Results_Graphs_Partners_%s.xlsx', $search_id),

      ][$workbook_key];

    $url_path_prefix = $data_upload_id != NULL
      ? '/review'
      : '';

    return in_array($workbook_key, [DatabaseExport::EXPORT_GRAPHS_PUBLIC, DatabaseExport::EXPORT_GRAPHS_PARTNERS])
      ? (new DatabaseExport())
          ->exportGraphs($pdo, $search_id, $data_upload_id, $year, $workbook_key, $filename)
      : (new DatabaseExport())
          ->exportResults($pdo, $search_id, $data_upload_id, $year, $workbook_key, $filename, $url_path_prefix);
  }

  function exportSearchResults(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', NULL);
    $year = intval($request->query->get('year', NULL));

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_PUBLIC, intval($search_id), NULL, $year);
    return self::createResponse($uri);
  }

  function exportSearchResultsForPartners(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', NULL);
    $year = intval($request->query->get('year', NULL));

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_PARTNERS, intval($search_id), NULL,  $year);
    return self::createResponse($uri);
  }

  function exportSearchResultsInSingleSheet(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', NULL);
    $year = intval($request->query->get('year', NULL));

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_AS_SINGLE_SHEET, intval($search_id), NULL, $year);
    return self::createResponse($uri);
  }

  function exportAbstracts(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', NULL);
    $year = intval($request->query->get('year', NULL));

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_WITH_ABSTRACTS, intval($search_id), NULL, $year);
    return self::createResponse($uri);
  }

  function exportAbstractsInSingleSheet(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', NULL);
    $year = intval($request->query->get('year', NULL));

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_WITH_ABSTRACTS_AS_SINGLE_SHEET, intval($search_id), NULL, $year);
    return self::createResponse($uri);
  }

  function exportCsoCancerTypes(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', NULL);
    $year = intval($request->query->get('year', NULL));

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_CSO_CANCER_TYPES, intval($search_id), NULL, $year);
    return self::createResponse($uri);
  }

  function exportGraphs(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', NULL);
    $year = intval($request->query->get('year', NULL));

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_GRAPHS_PUBLIC, intval($search_id), NULL, $year);
    return self::createResponse($uri);
  }

  function exportGraphsForPartners(Request $request) {
    $pdo = Database::getConnection();
    $search_id = $request->query->get('search_id', NULL);
    $year = intval($request->query->get('year', NULL));

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_GRAPHS_PARTNERS, intval($search_id), NULL, $year);
    return self::createResponse($uri);
  }


  function reviewExportSearchResults(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', NULL);
    $data_upload_id = $request->query->get('data_upload_id', NULL);
    $year = intval($request->query->get('year', NULL));

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_PUBLIC, intval($search_id), intval($data_upload_id), $year);
    return self::createResponse($uri);
  }

  function reviewExportSearchResultsForPartners(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', NULL);
    $data_upload_id = $request->query->get('data_upload_id', NULL);
    $year = intval($request->query->get('year', NULL));

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_PARTNERS, intval($search_id), intval($data_upload_id), $year);
    return self::createResponse($uri);
  }

  function reviewExportSearchResultsInSingleSheet(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', NULL);
    $data_upload_id = $request->query->get('data_upload_id', NULL);
    $year = intval($request->query->get('year', NULL));

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_AS_SINGLE_SHEET, intval($search_id), intval($data_upload_id), $year);
    return self::createResponse($uri);
  }

  function reviewExportAbstracts(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', NULL);
    $data_upload_id = $request->query->get('data_upload_id', NULL);
    $year = intval($request->query->get('year', NULL));

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_WITH_ABSTRACTS, intval($search_id), intval($data_upload_id), $year);
    return self::createResponse($uri);
  }

  function reviewExportAbstractsInSingleSheet(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', NULL);
    $data_upload_id = $request->query->get('data_upload_id', NULL);
    $year = intval($request->query->get('year', NULL));

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_RESULTS_WITH_ABSTRACTS_AS_SINGLE_SHEET, intval($search_id), intval($data_upload_id), $year);
    return self::createResponse($uri);
  }

  function reviewExportCsoCancerTypes(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', NULL);
    $data_upload_id = $request->query->get('data_upload_id', NULL);
    $year = intval($request->query->get('year', NULL));

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_CSO_CANCER_TYPES, intval($search_id), intval($data_upload_id), $year);
    return self::createResponse($uri);
  }


  function reviewExportGraphs(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', NULL);
    $data_upload_id = $request->query->get('data_upload_id', NULL);
    $year = intval($request->query->get('year', NULL));

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_GRAPHS_PUBLIC, intval($search_id), intval($data_upload_id), $year);
    return self::createResponse($uri);
  }

  function reviewExportGraphsForPartners(Request $request) {
    $pdo = Database::getConnection('icrp_load_database');
    $search_id = $request->query->get('search_id', NULL);
    $data_upload_id = $request->query->get('data_upload_id', NULL);
    $year = intval($request->query->get('year', NULL));

    $uri = self::getExportUri($pdo, DatabaseExport::EXPORT_GRAPHS_PARTNERS, intval($search_id), intval($data_upload_id), $year);
    return self::createResponse($uri);
  }

  function lookupTable(): StreamedResponse {
    return new StreamedResponse(function() {
      $pdo = Database::getConnection();
      ExcelBuilder::exportQueries('ICRP Lookup Tables.xlsx', [
        [
          'title' => 'CSO Codes',
          'query' => $pdo->prepare('SET NOCOUNT ON; EXECUTE GetCSOLookup'),
        ],
        [
          'title' => 'Disease Site Codes',
          'query' => $pdo->prepare('SET NOCOUNT ON; EXECUTE GetCancerTypeLookUp'),
        ],
        [
          'title' => 'Country Codes',
          'query' => $pdo->prepare('SET NOCOUNT ON; EXECUTE GetCountryCodeLookup'),
        ],
        [
          'title' => 'Currency Conversions',
          'query' => $pdo->prepare('SET NOCOUNT ON; EXECUTE GetCurrencyRateLookup'),
        ],
        [
          'title' => 'Institutions',
          'query' => $pdo->prepare('SET NOCOUNT ON; EXECUTE GetInstitutionLookup'),
        ],
        [
          'title' => 'Cancer Incidences',
          'query' => $pdo->prepare('SET NOCOUNT ON; EXECUTE GetCancerStatisticsByCategory @Category = Incidence'),
        ],
        [
          'title' => 'Cancer Mortality',
          'query' => $pdo->prepare('SET NOCOUNT ON; EXECUTE GetCancerStatisticsByCategory @Category = Mortality'),
        ],
        [
          'title' => 'Cancer Prevalence',
          'query' => $pdo->prepare('SET NOCOUNT ON; EXECUTE GetCancerStatisticsByCategory @Category = Prevalence'),
        ],
      ]);
    });
  }

  function uploadStatus(): StreamedResponse {
    return new StreamedResponse(function() {
        $pdo = Database::getConnection();
        ExcelBuilder::exportQueries('Data Upload Status.xlsx', [
            [
                'title' => 'Data Upload Status Report',
                'query' => $pdo->prepare('SET NOCOUNT ON; EXECUTE GetDataUploadStatus'),
            ],
        ]);
    });
  }

  function exportCustom(Request $request, $prefix) {
    $sheets = json_decode($request->getContent(), true);
    $filename = sprintf("%s_%s.xlsx", $prefix, uniqid());
    $uri = ExcelBuilder::export($filename, $sheets);
    return self::createResponse($uri);
  }
}
