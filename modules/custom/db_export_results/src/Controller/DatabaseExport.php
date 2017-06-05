<?php

namespace Drupal\db_export_results\Controller;

require __DIR__ . '/../../vendor/autoload.php';

use DateTime;
use PDO;
use PDOStatement;

use Box\Spout\Writer\WriterFactory;
use Box\Spout\Common\Type;
use Box\Spout\Writer\Style\StyleBuilder;
use PHPExcel;
use PHPExcel_IOFactory;


class DatabaseExport {

  const QUERY_MAP = [
    'export_results' => [
      'Search Results'          => 'EXECUTE GetProjectsBySearchID              @SearchID=:search_id, @ResultCount = NULL',
      'Projects by CSO'         => 'EXECUTE GetProjectCSOsBySearchID           @SearchID=:search_id',
      'Projects by Cancer Type' => 'EXECUTE GetProjectCancerTypesBySearchID    @SearchID=:search_id',
      'Search Criteria'         => 'EXECUTE GetSearchCriteriaBySearchID        @SearchID=:search_id',
    ],

    'export_results_partners' => [
      'Search Results'          => 'EXECUTE GetProjectExportsBySearchID        @SearchID=:search_id, @includeAbstract=0, @SiteURL=:site_url',
      'Projects by CSO'         => 'EXECUTE GetProjectCSOsBySearchID           @SearchID=:search_id',
      'Projects by Cancer Type' => 'EXECUTE GetProjectCancerTypesBySearchID    @SearchID=:search_id',
      'Search Criteria'         => 'EXECUTE GetSearchCriteriaBySearchID        @SearchID=:search_id',
    ],

    'export_results_single_sheet' => [
      'Search Results'          => 'EXECUTE GetProjectExportsSingleBySearchID  @SearchID=:search_id, @includeAbstract=0, @SiteURL=:site_url',
    ],

    'export_abstracts' => [
      'Search Results'          => 'EXECUTE GetProjectExportsBySearchID        @SearchID=:search_id, @includeAbstract=1, @SiteURL=:site_url',
      'Projects by CSO'         => 'EXECUTE GetProjectCSOsBySearchID           @SearchID=:search_id',
      'Projects by Cancer Type' => 'EXECUTE GetProjectCancerTypesBySearchID    @SearchID=:search_id',
    ],

    'export_abstracts_single_sheet' => [
      'Search Results'          => 'EXECUTE GetProjectExportsSingleBySearchID  @SearchID=:search_id, @includeAbstract=1, @SiteURL=:site_url',
    ],


    'export_graphs' => [
      'Projects by Country'                     => 'EXECUTE GetProjectCountryStatsBySearchID    @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = NULL, @Type = Count',
      'Projects by CSO'                         => 'EXECUTE GetProjectCSOStatsBySearchID        @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = NULL, @Type = Count',
      'Projects by Cancer Type'                 => 'EXECUTE GetProjectCancerTypeStatsBySearchID @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = NULL, @Type = Count',
      'Projects by Type'                        => 'EXECUTE GetProjectTypeStatsBySearchID       @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = NULL, @Type = Count',
      'Projects by Year'                        => 'EXECUTE GetProjectAwardStatsBySearchID      @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = NULL',
    ],

    'export_graphs_partners' => [
      'Projects by Country'                     => 'EXECUTE GetProjectCountryStatsBySearchID    @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = NULL, @Type = Count',
      'Projects by CSO'                         => 'EXECUTE GetProjectCSOStatsBySearchID        @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = NULL, @Type = Count',
      'Projects by Cancer Type'                 => 'EXECUTE GetProjectCancerTypeStatsBySearchID @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = NULL, @Type = Count',
      'Projects by Type'                        => 'EXECUTE GetProjectTypeStatsBySearchID       @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = NULL, @Type = Count',
      'Projects by Year'                        => 'EXECUTE GetProjectAwardStatsBySearchID      @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = NULL',

      'Funding Amounts by Country'            => 'EXECUTE GetProjectCountryStatsBySearchID      @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = NULL, @Type = Amount',
      'Funding Amounts by CSO'                => 'EXECUTE GetProjectCSOStatsBySearchID          @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = NULL, @Type = Amount',
      'Funding Amounts by Cancer Type'        => 'EXECUTE GetProjectCancerTypeStatsBySearchID   @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = NULL, @Type = Amount',
      'Funding Amounts by Type'               => 'EXECUTE GetProjectTypeStatsBySearchID         @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = NULL, @Type = Amount',
      'Funding Amounts by Year'               => 'EXECUTE GetProjectAwardStatsBySearchID        @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = NULL',
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
      'Projects by CSO' => [
        'ProjectID'     => 'ICRP Project ID',
        'CSOCode'       => 'CSO Code',
      ],
      'Projects by Cancer Type' => [
        'ProjectID'     => 'ICRP Project ID',
        'CancerType'    => 'Cancer Type',
      ],
    ],

    'export_graphs' => [
      'Projects by Country' => [
        'country'       => 'Country',
        'Count'         => 'Count',
      ],
      'Projects by CSO' => [
        'categoryName'  => 'CSO Category',
        'Relevance'     => 'Relevance',
        'ProjectCount'  => 'Count',
      ],
      'Projects by Cancer Type' => [
        'CancerType'    => 'Cancer Type',
        'Relevance'     => 'Relevance',
        'ProjectCount'  => 'Count',
      ],
      'Projects by Type' => [
        'ProjectType'   => 'Project Type',
        'Count'         => 'Count',
      ],
      'Projects by Year' => [
        'Year'          => 'Year',
        'Count'         => 'Count',
      ],
    ],
  ];

  const PARTNER_COLUMNS = [

    'export_results_partners' => [
      'Search Results'  => [], // use original database columns
      'Projects by CSO' => [
        'ProjectID'     => 'ICRP Project ID',
        'CSOCode'       => 'CSO Code',
        'CSORelevance'  => 'Relevance',
      ],
      'Projects by Cancer Type' => [
        'ProjectID'     => 'ICRP Project ID',
        'CancerType'    => 'Cancer Type',
        'Relevance'     => 'Relevance',
      ],
    ],

    'export_results_single_sheet' => [
      'Search Results'  => [], // use original database columns
    ],

    'export_abstracts' => [
      'Search Results'  => [], // use original database columns
      'Projects by CSO' => [
        'ProjectID'     => 'ICRP Project ID',
        'CSOCode'       => 'CSO Code',
        'CSORelevance'  => 'Relevance',
      ],
      'Projects by Cancer Type' => [
        'ProjectID'     => 'ICRP Project ID',
        'CancerType'    => 'Cancer Type',
        'Relevance'     => 'Relevance',
      ],
    ],

    'export_abstracts_single_sheet' => [
      'Search Results'  => [], // use original database columns
    ],

    'export_graphs_partners' => [
      'Projects by Country' => [
        'country'       => 'Country',
        'Count'         => 'Count',
      ],
      'Projects by CSO' => [
        'categoryName'  => 'CSO Category',
        'Relevance'     => 'Relevance',
        'ProjectCount'  => 'Count',
      ],
      'Projects by Cancer Type' => [
        'CancerType'    => 'Cancer Type',
        'Relevance'     => 'Relevance',
        'ProjectCount'  => 'Count',
      ],
      'Projects by Type' => [
        'ProjectType'   => 'Project Type',
        'Count'         => 'Count',
      ],
      'Projects by Year' => [
        'Year'          => 'Year',
        'Count'         => 'Count',
      ],


      'Funding Amounts by Country' => [
        'country'       => 'Country',
        'USDAmount'     => 'Amount',
      ],
      'Funding Amounts by CSO' => [
        'categoryName'  => 'CSO Category',
        'USDAmount'     => 'Amount',
      ],
      'Funding Amounts by Cancer Type' => [
        'CancerType'    => 'Cancer Type',
        'USDAmount'     => 'Amount',
      ],
      'Funding Amounts by Type' => [
        'ProjectType'   => 'Project Type',
        'USDAmount'     => 'Amount',
      ],
      'Funding Amounts by Year' => [
        'Year'          => 'Year',
        'amount'        => 'Amount',
      ],
    ],
  ];


  /**
   * Ensure that the output directory exists
   */
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

  /**
   * Returns the base url for this server
   * @return string
   */
  function getUrlBase(): string {
    return ($_SERVER['HTTPS'] == true
      ? 'https://'
      : 'http://')
      . $_SERVER['SERVER_NAME'];
  }

  /**
   * Returns an absolute path with system directory separators
   * based on a relative path
   *
   * @param string $path
   * @return string
   */
  function getAbsolutePath(string $path): string {
    $system_path = join(
      DIRECTORY_SEPARATOR,
      explode('/', $path)
    );

    return join(
      DIRECTORY_SEPARATOR,
      [getcwd(), $system_path]
    );
  }

  /**
   * Returns the current time
   * eg: 01/01/2000 12:00:00 AM
   *
   * @return string
   */
  function getTimestamp(): string {
    return date('m/d/Y h:i:s A');
  }

  /**
   * Creates an array containing the absolute path as well as the uri
   * for a given output filename
   *
   * @param string $filename
   * @return array
   */
  function buildOutputPaths(string $filename): array {
    $relative_path = join('/', [$this->output_directory, $filename]);
    $absolute_path = self::getAbsolutePath($relative_path);
    $uri = join('/', [null, $relative_path]);

    return [
      'filepath'  => $absolute_path,
      'uri'       => $uri,
    ];
  }

  /**
   * Performs a query on the database with the given parameters and returns
   * the PDOStatement containing the results set
   *
   * @param PDO $pdo
   * @param string $query
   * @param array $parameters
   * @return PDOStatement
   */
  function getQueryResults(PDO $pdo, string $query, array $parameters, array &$output_parameters = []): PDOStatement {
    $stmt_defaults = 'SET NOCOUNT ON; ';
    $stmt = $pdo->prepare($stmt_defaults . $query);

    foreach($parameters as $key => $value) {
      $parameter_key = ':' . $key;
      if (strpos($query, $parameter_key) !== false) {
        $stmt->bindParam($parameter_key, $value);
      }
    }

    return $stmt->execute()
      ? $stmt
      : null;
  }



  /**
   * Converts a 0-index based coordinate to an excel coordinate
   * examples:
   * (0, 0) -> 'A1'
   * (1, 1) -> 'B2'
   * (2, 3) -> 'D3'
   *
   * @param int $row
   * @param int $column
   * @return string
   */
  static function cell(int $row, int $column): string {
    return chr(ord('A') + $column) . ($row + 1);
  }

  function exportGraphs($pdo, $filename, $search_id, $is_public) {
    $paths = $this->buildOutputPaths($filename);

    $excel = new PHPExcel();
    $excel->getProperties()
      ->setCreator('International Cancer Research Partnership')
      ->setTitle('Data Export');

    $workbook_key = $is_public
      ? 'export_graphs'
      : 'export_graphs_partners';

    $last_key = end(array_keys(self::QUERY_MAP[$workbook_key]));
    $sheet = $excel->getSheet(0);

//    $index = 0;
    foreach (self::QUERY_MAP[$workbook_key] as $sheet_title => $sheet_query) {
      $sheet->setTitle(substr($sheet_title, 0, 31));
      $sheet_headers = $is_public
        ? self::PUBLIC_COLUMNS[$workbook_key][$sheet_title]
        : self::PARTNER_COLUMN[$workbook_key][$sheet_title];

      $parameters = [
        'search_id' => $search_id,
      ];

      $stmt = self::getQueryResults($pdo, $sheet_query, $parameters);

      $results = [array_values($sheet_headers)];
      while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {

        $results_row = [];
        // iterate over each sheet header
        // key corresponds to database column, value corresponds to sheet column
        foreach($sheet_headers as $database_column => $workbook_column) {
          // retrieve the database value for the current column
          $value = $row[$database_column];
          array_push($results_row, $value);
        }

        // add the row to the array of results
        array_push($results, $results_row);
      }

      $sheet->fromArray($results, '', self::cell(0, 0));
      $num_rows = count($results) - 1;

      $dsl = [
        new \PHPExcel_Chart_DataSeriesValues('String', "'".$sheet_title."'" . '!$A$1', NULL, 1),
        new \PHPExcel_Chart_DataSeriesValues('String', "'".$sheet_title."'" . '!$B$1', NULL, 1),
      ];

      $xal = [
        new \PHPExcel_Chart_DataSeriesValues('String', "'".$sheet_title."'" . '!$A$2:$A$' . ($num_rows + 1), NULL, $num_rows)
      ];

      $dsv = [
        new \PHPExcel_Chart_DataSeriesValues('Number', "'".$sheet_title."'" . '!$B$2:$B$' . ($num_rows + 1), NULL, $num_rows)
      ];

      $ds = new \PHPExcel_Chart_DataSeries(
        \PHPExcel_Chart_Dataseries::TYPE_BARCHART,
        \PHPExcel_Chart_Dataseries::GROUPING_STANDARD,
        range(0, count($dsv) - 1),
        $dsl,
        $xal,
        $dsv
      );

      $layout = new \PHPExcel_Chart_Layout();
      $layout->setShowVal(TRUE);
      $plot_area = new \PHPExcel_Chart_PlotArea($layout, array($ds));
      $legend = new \PHPExcel_Chart_Legend(\PHPExcel_Chart_Legend::POSITION_RIGHT, NULL, false);

      $chart = new \PHPExcel_Chart(
        $sheet_title,
        (new \PHPExcel_Chart_Title($sheet_title)),
        $legend,
        $plot_area,
        true,
        0,
        NULL,
        NULL
      );

//      $chart->setTopLeftPosition(self::cell(0, 4));
//      $chart->setBottomRightPosition(self::cell(10, 4 + $num_rows / 2));


      $chart->setTopLeftPosition(self::cell(0, 6));
      $chart->setBottomRightPosition(self::cell(25, 25));


      $sheet->addChart($chart);

      if ($sheet_title !== $last_key) {
        $sheet = $excel->createSheet();
      }
    }

    $writer = PHPExcel_IOFactory::createWriter($excel, 'Excel2007');
    $writer->setIncludeCharts(true);
    $writer->save($paths['filepath']);
    return $paths['uri'];
  } // 3454





  /**
   * Rxports search results based on the specified configuration
   *
   * @param PDO $pdo
   * @param int $search_id
   * @param string $workbook_key
   * @param string $filename
   * @param bool $is_public
   * @param bool $include_search_parameters
   * @param string $url_prefix
   * @return string
   */
  function exportResults(
    PDO $pdo,
    int $search_id,
    int $data_upload_id = NULL,
    string $workbook_key,
    string $filename,
    bool $is_public,
    bool $include_search_parameters = true,
    string $url_prefix = ''
  ): string {

    $paths = $this->buildOutputPaths($filename);
    $writer = WriterFactory::create(Type::XLSX);
    $writer->openToFile($paths['filepath']);
    $writer->setDefaultRowStyle(
      (new StyleBuilder())
        ->setShouldWrapText(false)
        ->build()
    );

    $sheet_definitions = (
      $is_public
      ? self::PUBLIC_COLUMNS[$workbook_key]
      : self::PARTNER_COLUMNS[$workbook_key]
    );

    $last_key = end(array_keys($sheet_definitions));

    // loop through each sheet's definition
    foreach($sheet_definitions as $sheet_key => $sheet_headers) {

      // set the name of the current sheet
      $writer->getCurrentSheet()->setName($sheet_key);

      // determine the query for the current sheet
      $query = self::QUERY_MAP[$workbook_key][$sheet_key];

      // set up query parameters
      $parameters = [
        'search_id' => $search_id,
        'site_url' => $this->getUrlBase() . $url_prefix . '/projects/',
      ];

      // retrieve the results of the query
      $results = $this->getQueryResults($pdo, $query, $parameters);

      // if there are results, write them to the current sheet
      if ($results) {

        $use_database_columns = false;

        // use database columns as headers if they are not defined
        if (empty($sheet_headers)) {
          $use_database_columns = true;
          foreach(range(0, $results->columnCount() - 1) as $column_index) {
            $meta = $results->getColumnMeta($column_index);
            array_push($sheet_headers, $meta['name']);
          }
        }

        // add headers to the current sheet
        $writer->addRow(array_values($sheet_headers));

        // iterate over each of the rows in the results
        // if we are using all database columns directly, there is no need to do additional processing
        if ($use_database_columns) {
          while ($row = $results->fetch(PDO::FETCH_NUM)) {
            $writer->addRow($row);
          }
        }

        // otherwise, we may specify additional steps to perform on each value
        else {

          // store url base
          $url_base = $this->getUrlBase();

          while ($row = $results->fetch(PDO::FETCH_ASSOC)) {

            $results_row = [];

            // iterate over each sheet header
            // key corresponds to database column, value corresponds to sheet column
            foreach($sheet_headers as $database_column => $workbook_column) {

              // retrieve the database value for the current column
              $value = $row[$database_column];

              // set the value to the url for each project record if required
              if ($database_column === 'ProjectID' && $workbook_column === 'View in ICRP') {
                array_push($results_row, $url_base . '/project/' . $value);
              }

              // add the corresponding value to the current array
              else {
                array_push($results_row, $value);
              }
            }

            // add the row to the current sheet
            $writer->addRow($results_row);
          }
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

    if ($include_search_parameters) {
      $this->addSearchCriteria($pdo, $writer, $search_id);
    }

    if ($data_upload_id != NULL) {
      $this->addDataReviewCriteria($pdo, $writer, $data_upload_id);
    }

    $writer->close();
    return $paths['uri'];
  }



  function addSearchCriteria($pdo, $writer, int $search_id) {
    $writer->addNewSheetAndMakeItCurrent();
    $writer->getCurrentSheet()->setName('Search Criteria');

    $writer->addRows([
      ['International Cancer Research Partnership', $this->getUrlBase()],
      ['Created: ', $this->getTimestamp()],
      ['Search Criteria: '],
    ]);

    $stmt_defaults = 'SET NOCOUNT ON; ';
    $stmt = $pdo->prepare($stmt_defaults . 'EXECUTE GetSearchCriteriaBySearchID @SearchID=:search_id');
    if ($stmt->execute([':search_id' => $search_id])) {
      $writer->addRows($stmt->fetchAll(PDO::FETCH_NUM));
    }
  }

  function addDataReviewCriteria($pdo, $writer, int $data_upload_id) {
    $writer->addNewSheetAndMakeItCurrent();
    $writer->getCurrentSheet()->setName('Data Upload Review');

    $writer->addRows([
      ['International Cancer Research Partnership', $this->getUrlBase()],
      ['Created: ', $this->getTimestamp()],
      ['Sponsor Code', 'Funding Years', 'Type', 'Workbook Received Date', 'Note'],
    ]);

    $stmt_defaults = 'SET NOCOUNT ON; ';
    $stmt = $pdo->prepare($stmt_defaults
      . 'SELECT [PartnerCode], [FundingYear], [Type], [ReceivedDate], [Note]
          FROM DataUploadStatus
          WHERE DataUploadStatusID = :data_upload_id');

    if ($stmt->execute([':data_upload_id' => $data_upload_id])) {
      $writer->addRows($stmt->fetchAll(PDO::FETCH_NUM));
    }
  }

}
