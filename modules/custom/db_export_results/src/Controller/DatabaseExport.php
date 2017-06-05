<?php

namespace Drupal\db_export_results\Controller;

require __DIR__ . '/../../vendor/autoload.php';

use PHPExcel;
use PHPExcel_IOFactory;
use Box\Spout\Writer\WriterFactory;
use Box\Spout\Common\Type;
use Box\Spout\Writer\Style\StyleBuilder;
use DateTime;
use PDO;


class DatabaseExport {

  const QUERY_MAP = [
    'export_results' => [
      'Search Results'          => 'EXECUTE GetProjectsBySearchID              @SearchID=:search_id, @ResultCount=:results_count',
      'Projects By CSO'         => 'EXECUTE GetProjectCSOsBySearchID           @SearchID=:search_id',
      'Projects By Cancer Type' => 'EXECUTE GetProjectCancerTypesBySearchID    @SearchID=:search_id',
      'Search Criteria'         => 'EXECUTE GetSearchCriteriaBySearchID        @SearchID=:search_id',
    ],

    'export_results_partners' => [
      'Search Results'          => 'EXECUTE GetProjectExportsBySearchCriteria  @SearchID=:search_id, @SiteURL=:site_url, @includeAbstract=0',
      'Projects By CSO'         => 'EXECUTE GetProjectCSOsBySearchID           @SearchID=:search_id',
      'Projects By Cancer Type' => 'EXECUTE GetProjectCancerTypesBySearchID    @SearchID=:search_id',
      'Search Criteria'         => 'EXECUTE GetSearchCriteriaBySearchID        @SearchID=:search_id',
    ],

    'export_results_single_sheet' => [
      'Search Results'          => 'EXECUTE GetProjectExportsSingleBySearchID  @SearchID=:search_id, @SiteURL=:site_url, @includeAbstract=0',
    ],

    'export_abstracts' => [
      'Search Results'          => 'EXECUTE GetProjectExportsBySearchCriteria  @SearchID=:search_id, @SiteURL=:site_url, @includeAbstract=1',
      'Projects By CSO'         => 'EXECUTE GetProjectCSOsBySearchID           @SearchID=:search_id',
      'Projects By Cancer Type' => 'EXECUTE GetProjectCancerTypesBySearchID    @SearchID=:search_id',
    ],

    'export_abstracts_single_sheet' => [
      'Search Results'          => 'EXECUTE GetProjectExportsSingleBySearchID  @SearchID=:search_id, @SiteURL=:site_url, @includeAbstract=1',
    ],

    'export_graphs' => [
      'Search Criteria'         => 'EXECUTE GetSearchCriteriaBySearchID        @SearchID=:search_id',
    ],

    'export_graphs_partners' => [
      'Search Criteria'         => 'EXECUTE GetSearchCriteriaBySearchID        @SearchID=:search_id',
    ],
  ];

  const PUBLIC_COLUMNS = [
    'export_results' => [
      'Search Results'  => [
        'Title'         => 'Project Title',
        'piFirstName'   => 'PI First Name',
        'piLastName'    => 'PI Last Name',
        'institution'   => 'Institution',
        'City'          => 'City',
        'State'         => 'State',
        'country'       => 'Country',
        'FundingOrg'    => 'Funding Organization',
        'AwardCode'     => 'Award Code',
        'ProjectID'     => 'View in ICRP',
      ],
      'Projects By CSO' => [
        'ProjectID'     => 'ICRP Project ID',
        'CSOCode'       => 'CSO Code',
      ],
      'Projects By Cancer Type' => [
        'ProjectID'     => 'ICRP Project ID',
        'CancerType'    => 'Cancer Type',
      ],
    ],
  ];  

  const PARTNER_COLUMNS = [

    'export_results_partners' => [
      'Search Results'  => [], // use original database columns
      'Projects By CSO' => [
        'ProjectID'     => 'ICRP Project ID',
        'CSOCode'       => 'CSO Code',
      ],
      'Projects By Cancer Type' => [
        'ProjectID'     => 'ICRP Project ID',
        'CancerType'    => 'Cancer Type',
      ],
    ],

    'export_results_single_sheet' => [
      'Search Results'  => [], // use original database columns
    ],

    'export_abstracts' => [
      'Search Results'  => [], // use original database columns
      'Projects By CSO' => [
        'ProjectID'     => 'ICRP Project ID',
        'CSOCode'       => 'CSO Code',
      ],
      'Projects By Cancer Type' => [
        'ProjectID'     => 'ICRP Project ID',
        'CancerType'    => 'Cancer Type',
      ],
    ],

    'export_abstracts_single_sheet' => [
      'Search Results'  => [], // use original database columns
    ],
  ];



  function __construct() {
    // get the relative path of this module
    $module_path = drupal_get_path('module', 'db_export_results');

    // set the output directory
    $this->output_directory = join('/', [$module_path, 'output']);

    // create the output directory if it does not exist
    if (!file_exists($this->output_directory)) {
      mkdir($this->output_directory);
    }
  }

  function getAbsolutePath($path) {
    $system_path = join(
      DIRECTORY_SEPARATOR,
      explode('/', $path)
    );

    return join(
      DIRECTORY_SEPARATOR,
      [getcwd(), $system_path]
    );
  }

  function getUrlBase() {
    return ($_SERVER['HTTPS'] == true
      ? 'https://'
      : 'http://')
      . $_SERVER['SERVER_NAME'];
  }


  function buildOutputPaths($filename) {
    $relative_path = join('/', [$this->output_directory, $filename]);
    $absolute_path = self::getAbsolutePath($relative_path);
    $uri = join('/', [null, $relative_path]);

    return [
      'filepath'  => $absolute_path,
      'uri'       => $uri,
    ];
  }

  function getQueryResults(PDO $pdo, $query, &$parameters) {
    $stmt_defaults = 'SET NOCOUNT ON; ';
    $stmt = $pdo->prepare($stmt_defaults . $query);
    $stmt->bindParam(':search_id', $parameters['search_id']);
    
    if (strpos($query, ':results_count') !== false) {
      $stmt->bindParam(':results_count', $parameters['results_count'], PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT, 1000);
    }

    return $stmt->execute()
      ? $stmt
      : null;
  }


  function exportSearchResults(PDO $pdo, $search_id) {
    $filename = sprintf('ICRP_Search_Results_%s.xlsx', $search_id);
    $workbook_key = 'export_results';
    $is_public = true;
    $include_search_parameters = true;    

    return $this->exportResults(
      $pdo, 
      $search_id, 
      $workbook_key, 
      $filename, 
      $is_public, 
      $include_search_parameters);
  }


  function exportSearchResultsForPartners(PDO $pdo, $search_id) {
    $filename = sprintf('ICRP_Partner_Search_Results_%s.xlsx', $search_id);
    $workbook_key = 'export_results';
    $is_public = false;
    $include_search_parameters = true;    

    return $this->exportResults(
      $pdo, 
      $search_id, 
      $workbook_key, 
      $filename, 
      $is_public, 
      $include_search_parameters);
  }






  


  function exportGraphs($pdo, $searchsearch_idID) {
    $ea = new PHPExcel();

    $ea->getProperties()
      ->setCreator('International Cancer Research Partnership')
      ->setTitle('Data Export');
      
    $ews = $ea->getSheet(0);
    $ews->setTitle('Data');

    $ews->setCellValue('a1', 'Vov');

    
    $writer = PHPExcel_IOFactory::createWriter($ea, 'Excel2007');

    $writer->save($filepath);
    
  }


  // exports search results based on th specified configuration
  function exportResults(PDO $pdo, $search_id, $workbook_key, $filename, $is_public, $include_search_parameters) {
    $paths = $this->buildOutputPaths($filename);
    $writer = WriterFactory::create(Type::XLSX);
    $writer->openToFile($paths['filepath']);

    if ($is_public) {
      $sheet_definitions = self::PUBLIC_COLUMNS[$workbook_key];
    }

    else {
      $sheet_definitions = self::PRIVATE_COLUMNS[$workbook_key];
    }

    $last_key = end(array_keys($sheet_definitions));

    // loop through each sheet's definition
    foreach($sheet_definitions as $sheet_key => $sheet_headers) {
      
      // set the name of the current sheet
      $writer->getCurrentSheet()->setName($sheet_key);

      // add headers to the current sheet
      $writer->addRow(array_values($sheet_headers));

      // determine the query for the current sheet
      $query = self::QUERY_MAP['export_results'][$sheet_key];
      
      // set up query parameters
      $parameters = [
        'search_id' => $search_id,
        'results_count' => 0,
      ];

      // retrieve the results of the query
      $results = $this->getQueryResults($pdo, $query, $parameters);

      // if there are results, write them to the current sheet
      if ($results) {

        // iterate over each of the rows in the results
        while ($row = $results->fetch(PDO::FETCH_ASSOC)) {

          $results_row = [];

          // iterate over each sheet header 
          // key corresponds to database column, value corresponds to sheet column
          foreach($sheet_headers as $database_column => $workbook_column) {
            
            // retrieve the database value for the current column
            $value = $row[$database_column];

            // set the value to the url for each project record if required
            if ($workbook_column === 'View in ICRP') {
              $value = $this->getUrlBase() . '/project/' . $value;
            }

            // add the corresponding value to the current array
            array_push($results_row, $value);
          }

          // add the row to the current sheet
          $writer->addRow($results_row);
        }

        // after writing all rows for the current query, 
        // create a new sheet (if there are any sheets left)
        if ($sheet_key !== $last_key) {
          $writer->addNewSheetAndMakeItCurrent();
        }
      }

      // specify if there are no results
      else {
          $writer->addRow(['No Data Available']);
      }
    }

    $writer->close();
    return $paths['uri']; 
  }
  
}