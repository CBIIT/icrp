<?php

namespace Drupal\db_export_results\Controller;

// require __DIR__ . '/../../vendor/autoload.php';
require_once 'PHPExcel.php';

use DateTime;
use PDO;
use PDOStatement;

use Box\Spout\Writer\WriterFactory;
use Box\Spout\Common\Type;
use Box\Spout\Writer\Style\StyleBuilder;
use PHPExcel;
use PHPExcel_IOFactory;


class DatabaseExport {

  public const EXPORT_RESULTS_PUBLIC                          = 'EXPORT_RESULTS_PUBLIC';
  public const EXPORT_RESULTS_PARTNERS                        = 'EXPORT_RESULTS_PARTNERS';
  public const EXPORT_RESULTS_AS_SINGLE_SHEET                 = 'EXPORT_RESULTS_AS_SINGLE_SHEET';
  public const EXPORT_RESULTS_WITH_ABSTRACTS                  = 'EXPORT_RESULTS_WITH_ABSTRACTS';
  public const EXPORT_RESULTS_WITH_ABSTRACTS_AS_SINGLE_SHEET  = 'EXPORT_RESULTS_WITH_ABSTRACTS_AS_SINGLE_SHEET';
  public const EXPORT_GRAPHS_PUBLIC                           = 'EXPORT_GRAPHS_PUBLIC';
  public const EXPORT_GRAPHS_PARTNERS                         = 'EXPORT_GRAPHS_PARTNERS';

  /**
   * Workbook definitions
   *
   * Each entry is an associative array that corresponds to an excel workbook
   * This array contains entries that correspond to sheets within the workbook
   * The 'query' property of this array specifies the query that is to be performed against the database
   * The 'columns' property specifies the column mapping that is to be applied to the results set (as well as defining any custom column names)
   *   - if empty, no mappings will be applied and the entire results set will be written to the specified sheet
  */
  private const EXPORT_MAP = [

    // Workbook definition for 'EXPORT_RESULTS_PUBLIC' method
    self::EXPORT_RESULTS_PUBLIC  => [

      // Sheet definition for 'Search Results'
      'Search Results' => [
        'query' => 'EXECUTE GetProjectExportsBySearchID         @SearchID=:search_id, @includeAbstract=0, @SiteURL=:site_url, @Year = :year',
        'columns' =>  [
          'AwardTitle'    => 'Project Title',
          'piFirstName'   => 'PI First Name',
          'piLastName'    => 'PI Last Name',
          'Institution'   => 'Institution',
          'City'          => 'City',
          'State'         => 'State',
          'Country'       => 'Country',
          'Region'        => 'Region',
          'FundingOrg'    => 'Funding Organization',
          'AwardCode'     => 'Award Code',
          'icrpURL'       => 'View in ICRP',
        ],
      ],

      // // Sheet definition for 'Projects by CSO'
      'Projects by CSO' => [
        'query' => 'EXECUTE GetProjectCSOsBySearchID            @SearchID=:search_id',
        'columns' => [
          'ProjectID'             => 'ICRP Project ID',
          'ICRPProjectFundingID'  => 'ICRP Project Funding ID',
          'AltAwardCode'          => 'Alt. Award Code',
          'CSOCode'               => 'CSO Code',
        ],
      ],

      // // Sheet definition for 'Projects by Cancer Type'
      'Projects by Cancer Type' => [
        'query' => 'EXECUTE GetProjectCancerTypesBySearchID     @SearchID=:search_id',
        'columns' => [
          'ProjectID'             => 'ICRP Project ID',
          'ICRPProjectFundingID'  => 'ICRP Project Funding ID',
          'AltAwardCode'          => 'Alt. Award Code',
          'ICRPCode'              => 'ICRP Code',
          'CancerType'            => 'Cancer Type',
        ],
      ],

      'Project Collaborators' => [
        'query' => 'EXECUTE GetProjectCollaboratorsBysearchID         @SearchID=:search_id',
        'columns' =>  [],
      ],
    ],

    // Workbook definition for 'EXPORT_RESULTS_PARTNERS' method
    self::EXPORT_RESULTS_PARTNERS => [

      // Sheet definition for 'Search Results'
      'Search Results' => [
        'query' => 'EXECUTE GetProjectExportsBySearchID         @SearchID=:search_id, @includeAbstract=0, @SiteURL=:site_url, @Year = :year',
        'columns' =>  [/* use original columns from database */],
      ],

      // Sheet definition for 'Projects by CSO'
      'Projects by CSO' => [
        'query' => 'EXECUTE GetProjectCSOsBySearchID            @SearchID=:search_id',
        'columns' => [
          // 'ProjectID'             => 'ICRP Project ID',
          // 'ICRPProjectFundindID'  => 'ICRP Project Funding ID',
          // 'AltAwardCode'          => 'Alt. Award Code',
          // 'CSOCode'               => 'CSO Code',
          // 'CSORelevance'          => 'Relevance',
        ],
      ],

      // Sheet definition for 'Projects by Cancer Type'
      'Projects by Cancer Type' => [
        'query' => 'EXECUTE GetProjectCancerTypesBySearchID     @SearchID=:search_id',
        'columns' => [
          // 'ProjectID'             => 'ICRP Project ID',
          // 'ICRPProjectFundindID'  => 'ICRP Project Funding ID',
          // 'AltAwardCode'          => 'Alt. Award Code',
          // 'ICRPCode'              => 'ICRP Code',
          // 'CancerType'            => 'Cancer Type',
          // 'Relevance'             => 'Relevance',
        ],
      ],

      'Project Collaborators' => [
        'query' => 'EXECUTE GetProjectCollaboratorsBysearchID         @SearchID=:search_id',
        'columns' =>  [],
      ],
    ],

    // Workbook definition for 'EXPORT_RESULTS_AS_SINGLE_SHEET' method
    self::EXPORT_RESULTS_AS_SINGLE_SHEET => [

      // Sheet definition for 'Search Results'
      'Search Results' => [
        'query' => 'EXECUTE GetProjectExportsSingleBySearchID   @SearchID=:search_id, @includeAbstract=0, @SiteURL=:site_url, @Year = :year',
        'columns' =>  [/* use original columns from database */],
      ],
    ],

    // Workbook definition for 'EXPORT_RESULTS_WITH_ABSTRACTS' method
    self::EXPORT_RESULTS_WITH_ABSTRACTS => [

      // Sheet definition for 'Search Results'
      'Search Results' => [
        'query' => 'EXECUTE GetProjectExportsBySearchID         @SearchID=:search_id, @includeAbstract=1, @SiteURL=:site_url, @Year = :year',
        'columns' =>  [/* use original columns from database */],
      ],

      // Sheet definition for 'Projects by CSO'
      'Projects by CSO' => [
        'query' => 'EXECUTE GetProjectCSOsBySearchID            @SearchID=:search_id',
        'columns' => [
          // 'ProjectID'             => 'ICRP Project ID',
          // 'ICRPProjectFundindID'  => 'ICRP Project Funding ID',
          // 'AltAwardCode'          => 'Alt. Award Code',
          // 'CSOCode'               => 'CSO Code',
          // 'CSORelevance'          => 'Relevance',
        ],
      ],

      // Sheet definition for 'Projects by Cancer Type'
      'Projects by Cancer Type' => [
        'query' => 'EXECUTE GetProjectCancerTypesBySearchID     @SearchID=:search_id',
        'columns' => [
          // 'ProjectID'             => 'ICRP Project ID',
          // 'ICRPProjectFundingID'  => 'ICRP Project Funding ID',
          // 'AltAwardCode'          => 'Alt. Award Code',
          // 'ICRPCode'              => 'ICRP Code',
          // 'CancerType'            => 'Cancer Type',
          // 'Relevance'             => 'Relevance',
        ],
      ],

      'Project Collaborators' => [
        'query' => 'EXECUTE GetProjectCollaboratorsBysearchID         @SearchID=:search_id',
        'columns' =>  [],
      ],
    ],

    // Workbook definition for 'EXPORT_RESULTS_WITH_ABSTRACTS_AS_SINGLE_SHEET' method
    self::EXPORT_RESULTS_WITH_ABSTRACTS_AS_SINGLE_SHEET => [

      // Sheet definition for 'Search Results'
      'Search Results' => [
        'query' => 'EXECUTE GetProjectExportsSingleBySearchID   @SearchID=:search_id, @includeAbstract=1, @SiteURL=:site_url, @Year = :year',
        'columns' =>  [/* use original columns from database */],
      ],
    ],

    // Workbook definition for 'EXPORT_GRAPHS_PUBLIC' method
    self::EXPORT_GRAPHS_PUBLIC => [

      // Sheet definition for 'Projects by Country'
      'Projects by Country' => [
        'query' => 'EXECUTE GetProjectCountryStatsBySearchID    @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Count',
        'columns' => [
          'country'       => 'Country',
          'Count'         => 'Project Count',
        ],
      ],

      // Sheet definition for 'Projects by CSO'
      'Projects by CSO' => [
        'query' => 'EXECUTE GetProjectCSOStatsBySearchID        @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Count',
        'columns' => [
          'categoryName'  => 'CSO Category',
          'Relevance'     => 'Relevance',
          'ProjectCount'  => 'Project Count',
        ],
      ],

      // Sheet definition for 'Projects by Cancer Type'
      'Projects by Cancer Type' => [
        'query' => 'EXECUTE GetProjectCancerTypeStatsBySearchID @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Count',
        'columns' => [
          'CancerType'    => 'Cancer Type',
          'Relevance'     => 'Relevance',
          'ProjectCount'  => 'Project Count',
        ],
      ],

      // Sheet definition for 'Projects by Type'
      'Projects by Type' => [
        'query' => 'EXECUTE GetProjectTypeStatsBySearchID       @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Count',
        'columns' => [
          'ProjectType'   => 'Project Type',
          'Count'         => 'Project Count',
        ],
      ],

      // Sheet definition for 'Projects by Year'
      'Projects by Year' => [
        'query' => 'EXECUTE GetProjectAwardStatsBySearchID      @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year',
        'columns' => [
          'Year'          => 'Year',
          'Count'         => 'Project Count',
        ],
      ],

      // Sheet definition for 'Projects by Institution'
      'Projects by Institution' => [
        'query' => 'EXECUTE GetProjectInstitutionStatsBySearchID      @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Count',
        'columns' => [
          'Institution'   => 'Institution',
          'Count'         => 'Project Count',
        ],
      ],


      // Sheet definition for 'Projects by Childhood Cancer'
      'Projects for Childhood Cancer' => [
        'query' => 'EXECUTE GetProjectChildhoodCancerStatsBySearchID      @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Count',
        'columns' => [
          'IsChildhood'   => 'Is Childhood Cancer?',
          'Count'         => 'Project Count',
        ],
      ],

      // Sheet definition for 'Projects by Funding Organization'
      'Projects by Organization' => [
        'query' => 'EXECUTE GetProjectFundingOrgStatsBySearchID      @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Count',
        'columns' => [
          'FundingOrg'    => 'Funding Organization',
          'Count'         => 'Project Count',
        ],
      ],
    ],

    // Workbook definition for 'EXPORT_GRAPHS_PARTNERS' method
    self::EXPORT_GRAPHS_PARTNERS => [

      // Sheet definition for 'Projects by Country'
      'Projects by Country' => [
        'query' => 'EXECUTE GetProjectCountryStatsBySearchID    @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Count',
        'columns' => [
          'country'       => 'Country',
          'Count'         => 'Project Count',
        ],
      ],

      // Sheet definition for 'Projects by CSO'
      'Projects by CSO' => [
        'query' => 'EXECUTE GetProjectCSOStatsBySearchID        @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Count',
        'columns' => [
          'categoryName'  => 'CSO Category',
          'Relevance'     => 'Relevance',
          'ProjectCount'  => 'Project Count',
        ],
      ],

      // Sheet definition for 'Projects by Cancer Type'
      'Projects by Cancer Type' => [
        'query' => 'EXECUTE GetProjectCancerTypeStatsBySearchID @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Count',
        'columns' => [
          'CancerType'    => 'Cancer Type',
          'Relevance'     => 'Relevance',
          'ProjectCount'  => 'Project Count',
        ],
      ],

      // Sheet definition for 'Projects by Type'
      'Projects by Type' => [
        'query' => 'EXECUTE GetProjectTypeStatsBySearchID       @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Count',
        'columns' => [
          'ProjectType'   => 'Project Type',
          'Count'         => 'Project Count',
        ],
      ],

      // Sheet definition for 'Projects by Year'
      'Projects by Year' => [
        'query' => 'EXECUTE GetProjectAwardStatsBySearchID      @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Count',
        'columns' => [
          'Year'          => 'Year',
          'Count'         => 'Project Count',
        ],
      ],

      // Sheet definition for 'Projects by Institution'
      'Projects by Institution' => [
        'query' => 'EXECUTE GetProjectInstitutionStatsBySearchID      @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Count',
        'columns' => [
          'Institution'   => 'Institution',
          'Count'         => 'Project Count',
        ],
      ],


      // Sheet definition for 'Projects by Childhood Cancer'
      'Projects for Childhood Cancer' => [
        'query' => 'EXECUTE GetProjectChildhoodCancerStatsBySearchID      @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Count',
        'columns' => [
          'IsChildhood'   => 'Is Childhood Cancer?',
          'Count'         => 'Project Count',
        ],
      ],

      // Sheet definition for 'Projects by Funding Organization'
      'Projects by Organization' => [
        'query' => 'EXECUTE GetProjectFundingOrgStatsBySearchID      @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Count',
        'columns' => [
          'FundingOrg'    => 'Funding Organization',
          'Count'         => 'Project Count',
        ],
      ],


      // Sheet definition for 'Funding Amounts by Country'
      'Amounts by Country' => [
        'query' => 'EXECUTE GetProjectCountryStatsBySearchID    @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Amount',
        'columns' => [
          'country'       => 'Country',
          'USDAmount'     => 'Amount',
        ],
      ],

      // Sheet definition for 'Funding Amounts by CSO'
      'Amounts by CSO' => [
        'query' => 'EXECUTE GetProjectCSOStatsBySearchID        @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Amount',
        'columns' => [
          'categoryName'  => 'CSO Category',
          'USDAmount'     => 'Amount',
        ],
      ],

      // Sheet definition for 'Funding Amounts by Cancer Type'
      'Amounts by Cancer Type' => [
        'query' => 'EXECUTE GetProjectCancerTypeStatsBySearchID @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Amount',
        'columns' => [
          'CancerType'    => 'Cancer Type',
          'USDAmount'     => 'Amount',
        ],
      ],

      // Sheet definition for 'Funding Amounts by Type'
      'Amounts by Type' => [
        'query' => 'EXECUTE GetProjectTypeStatsBySearchID       @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Amount',
        'columns' => [
          'ProjectType'   => 'Project Type',
          'USDAmount'     => 'Amount',
        ],
      ],

      // Sheet definition for 'Funding Amounts by Year'
      'Amounts by Year' => [
        'query' => 'EXECUTE GetProjectAwardStatsBySearchID      @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Amount',
        'columns' => [
          'Year'          => 'Year',
          'USDAmount'     => 'Amount',
        ],
      ],

      // Sheet definition for 'Funding Amounts by Institution'
      'Amounts by Institution' => [
        'query' => 'EXECUTE GetProjectInstitutionStatsBySearchID      @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Amount',
        'columns' => [
          'Institution'   => 'Institution',
          'USDAmount'     => 'Amount',
        ],
      ],


      // Sheet definition for 'Funding Amounts by Childhood Cancer'
      'Amounts for Childhood Cancer' => [
        'query' => 'EXECUTE GetProjectChildhoodCancerStatsBySearchID      @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Amount',
        'columns' => [
          'IsChildhood'   => 'Is Childhood Cancer?',
          'USDAmount'     => 'Amount',
        ],
      ],

      // Sheet definition for 'Funding Amounts by Funding Organization'
      'Amounts by Organization' => [
        'query' => 'EXECUTE GetProjectFundingOrgStatsBySearchID      @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Amount',
        'columns' => [
          'FundingOrg'    => 'Funding Organization',
          'USDAmount'     => 'Amount',
        ],
      ],
    ],
  ];

  /**
   * Ensure that the output directory exists
   */
  function __construct() {
    $this->output_directory = \Drupal::config('exports')->get('search') ?? 'data/exports/search';

    // create the output directory if it does not exist
    if (!file_exists($this->output_directory)) {
      mkdir($this->output_directory, 0744, true);
    }
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
    return date('j F Y g.ia');
  }

  /**
   * Returns the base url for this server
   *
   * @return string
   */
  static function getUrlBase(): string {
    return (
      (array_key_exists('HTTPS', $_SERVER) && $_SERVER['HTTPS'] == true)
      ? 'https://'
      : 'http://')
      . $_SERVER['SERVER_NAME'];
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
   * Performs the specified query on the database with the given parameters
   * and returns a PDOStatement containing the results set
   *
   * @param PDO $pdo
   * @param string $query
   * @param array $parameters
   * @return PDOStatement
   */
  function getQueryResults(PDO $pdo, string $query, array $parameters): PDOStatement {
    $stmt_defaults = 'SET NOCOUNT ON; ';
    $stmt = $pdo->prepare($stmt_defaults . $query);

    foreach($parameters as $key => $entry) {
      if (strpos($query, ":$key") !== false) {
        $stmt->bindParam(
          ":$key",
          $entry['value'],
          $entry['type']
        );
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

  function exportGraphs($pdo, $search_id, $data_upload_id, $year, $workbook_key, $filename) {
    $paths = $this->buildOutputPaths($filename);

    $excel = new \PHPExcel();
    $excel->getProperties()
      ->setCreator('International Cancer Research Partnership')
      ->setTitle('Data Export');

    $sheet_definitions = self::EXPORT_MAP[$workbook_key];
    $sheet_definition_keys = array_keys($sheet_definitions);
    $last_key = end($sheet_definition_keys);

    $sheet = $excel->getSheet(0);

    // loop through each sheet's definition
    foreach($sheet_definitions as $sheet_name => $sheet_definition) {

      // determine the query for the current sheet
      $sheet_query = $sheet_definition['query'];

      // determine the column names for the current sheet
      $sheet_columns = $sheet_definition['columns'];

      // set the name of the current sheet
      $sheet_name = substr($sheet_name, 0, 31);
      $sheet->setTitle($sheet_name);

      // set up query parameters
      $parameters = [
        'search_id' => [
          'type' => PDO::PARAM_INT,
          'value' => $search_id,
        ],
        'year' => [
          'type' => PDO::PARAM_INT,
          'value' => $year,
        ],
      ];

      // retrieve the results of the query
      $results = $this->getQueryResults($pdo, $sheet_query, $parameters);

      // if there are results, write them to the current sheet
      if ($results !== NULL) {

        $rows = [array_values($sheet_columns)];
        $columns = array_keys($sheet_columns);
        while ($row = $results->fetch(PDO::FETCH_ASSOC)) {
          array_push($rows,
            array_map(function($column) use ($row) {
              return $row[$column];
            }, $columns)
          );
        }
        $sheet->fromArray($rows, '', self::cell(0, 0));
        $num_rows = count($rows) - 1;

        $dsl = [
          new \PHPExcel_Chart_DataSeriesValues('String', "'".$sheet_name."'" . '!$A$1', NULL, 1),
          new \PHPExcel_Chart_DataSeriesValues('String', "'".$sheet_name."'" . '!$B$1', NULL, 1),
        ];

        $xal = [
          new \PHPExcel_Chart_DataSeriesValues('String', "'".$sheet_name."'" . '!$A$2:$A$' . ($num_rows + 1), NULL, $num_rows)
        ];

        $dsv = [
          new \PHPExcel_Chart_DataSeriesValues('Number', "'".$sheet_name."'" . '!$B$2:$B$' . ($num_rows + 1), NULL, $num_rows)
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

        $axis_layout = new \PHPExcel_Chart_Layout();
        $axis_layout->setHeight(10);
        $axis_layout->setWidth(10);

        $plot_area = new \PHPExcel_Chart_PlotArea($layout, array($ds));
        $legend = new \PHPExcel_Chart_Legend(\PHPExcel_Chart_Legend::POSITION_RIGHT, NULL, false);

        $chart = new \PHPExcel_Chart(
          $sheet_name,
          (new \PHPExcel_Chart_Title($sheet_name)),
          $legend,
          $plot_area,
          true,
          0,
          (new \PHPExcel_Chart_Title($rows[0][0], $axis_layout)),
          (new \PHPExcel_Chart_Title($rows[0][1], $axis_layout))
        );

//      $chart->setTopLeftPosition(self::cell(0, 4));
//      $chart->setBottomRightPosition(self::cell(10, 4 + $num_rows / 2));

        $chart->setTopLeftPosition(self::cell(0, 4));
        $chart->setBottomRightPosition(self::cell(25, 25));

        $sheet->addChart($chart);
      }

      // add another sheet
      if ($sheet_name !== $last_key) {
        $sheet = $excel->createSheet();
      }
    }

    $data = [];
    $sheet_name = '';

    if ($data_upload_id === NULL) {
      $data = self::getSearchCriteria($pdo, $search_id);
      $sheet_name = 'Search Criteria';
    }

    else {
      $data = self::getDataReviewCriteria($pdo, $data_upload_id);
      $sheet_name = 'Data Upload Review';
    }

    $sheet = $excel->createSheet();
    $sheet->setTitle($sheet_name);
    $this->writeArrayToWorksheet($data, $sheet);

    $writer = \PHPExcel_IOFactory::createWriter($excel, 'Excel2007');
    $writer->setIncludeCharts(true);
    $writer->save($paths['filepath']);



    return $paths['uri'];
  }

  /**
   * Rxports search results based on the specified configuration
   *
   * @param PDO $pdo
   * @param int $search_id
   * @param int $data_upload_id
   * @param int $year
   * @param string $workbook_key
   * @param string $filename
   * @param string $url_path_prefix
   * @return string
   */
  function exportResults(
    PDO $pdo,
    int $search_id = NULL,
    int $data_upload_id = NULL,
    int $year = NULL,
    string $workbook_key = '',
    string $filename = '',
    string $url_path_prefix = ''
  ): string {

    $paths = $this->buildOutputPaths($filename);
    $writer = WriterFactory::create(Type::XLSX);
    $writer->openToFile($paths['filepath']);
    $writer->setDefaultRowStyle(
      (new StyleBuilder())
        ->setShouldWrapText(false)
        ->build()
    );

    $sheet_definitions = self::EXPORT_MAP[$workbook_key];
    $sheet_definition_keys = array_keys($sheet_definitions);
    $last_key = end($sheet_definition_keys);

    // loop through each sheet's definition
    foreach($sheet_definitions as $sheet_name => $sheet_definition) {

      // determine the query for the current sheet
      $sheet_query = $sheet_definition['query'];

      // determine the column names for the current sheet
      $sheet_columns = $sheet_definition['columns'];

      // set the name of the current sheet
      $writer->getCurrentSheet()->setName($sheet_name);

      // set up query parameters
      $parameters = [
        'search_id' => [
          'type' => PDO::PARAM_INT,
          'value' => $search_id,
        ],
        'site_url' => [
          'type' => PDO::PARAM_STR,
          'value' => $this->getUrlBase() . $url_path_prefix . '/project/',
        ],
        'year' => [
          'type' => PDO::PARAM_INT,
          'value' => $year,
        ],
      ];

      // retrieve the results of the query
      $results = $this->getQueryResults($pdo, $sheet_query, $parameters);

      // if there are results, write them to the current sheet
      if ($results !== NULL) {

        $use_database_columns = false;

        // use database columns as headers if they are not defined
        if (empty($sheet_columns)) {
          $use_database_columns = true;
          foreach(range(0, $results->columnCount() - 1) as $column_index) {
            $meta = $results->getColumnMeta($column_index);
            array_push($sheet_columns, $meta['name']);
          }
        }

        // add headers to the current sheet
        $writer->addRow(array_values($sheet_columns));

        // iterate over each of the rows in the results
        // if we are using all table columns, we may insert each row without processing it
        if ($use_database_columns) {
          while ($row = $results->fetch(PDO::FETCH_NUM)) {
            $writer->addRow(
              array_map(function($value) {
                return substr($value, 0, 32767);
              }, $row)
            );
          }
        }

        // otherwise, apply the column mappings specified in the definition
        else {
          $columns = array_keys($sheet_columns);
          while ($row = $results->fetch(PDO::FETCH_ASSOC)) {
            $writer->addRow(
              array_map(function($column) use ($row) {
                return array_key_exists($column, $row)
                  ? substr($row[$column], 0, 32767)
                  : '';
              }, $columns)
            );
          }
        }

        // after writing all rows for the current query,
        // create a new sheet (if there are any sheets left)
        if ($sheet_name !== $last_key) {
          $writer->addNewSheetAndMakeItCurrent();
        }
      }
    }

    function addSheetToWorkbook($writer, $sheet_name, $data) {
      $writer->addNewSheetAndMakeItCurrent();
      $writer->getCurrentSheet()->setName($sheet_name);
      $writer->addRows($data);
    }

    // if a data upload id was not specified, add a sheet containing search criteria
    // otherwise, do not include search criteria and instead use data review criteria
    $data_upload_id === NULL
      ? addSheetToWorkbook($writer, 'Search Criteria', $this->getSearchCriteria($pdo, $search_id))
      : addSheetToWorkbook($writer, 'Data Upload Review', $this->getDataReviewCriteria($pdo, $data_upload_id));

    $writer->close();
    return $paths['uri'];
  }

  function getSearchCriteria($pdo, int $search_id) {
    $data = [
      ['International Cancer Research Partnership', $this->getUrlBase()],
      ['Created: ', $this->getTimestamp()],
      ['Search Criteria: '],
    ];

    $stmt_defaults = 'SET NOCOUNT ON; ';
    $stmt = $pdo->prepare($stmt_defaults . 'EXECUTE GetSearchCriteriaBySearchID @SearchID=:search_id');
    if ($stmt->execute([':search_id' => $search_id])) {
      while ($row = $stmt->fetch(PDO::FETCH_NUM))
        array_push($data, $row);
      //$data = $stmt->fetchAll(PDO::FETCH_NUM);
    }

    return $data;
  }

  function getDataReviewCriteria($pdo, int $data_upload_id) {
    $data = [
      ['International Cancer Research Partnership', $this->getUrlBase()],
      ['Created: ', $this->getTimestamp()],
      ['Sponsor Code', 'Funding Years', 'Type', 'Workbook Received Date', 'Note'],
    ];

    $stmt = $pdo->prepare('SELECT [PartnerCode], [FundingYear], [Type], [ReceivedDate], [Note]
          FROM DataUploadStatus
          WHERE DataUploadStatusID = :data_upload_id');

    if ($stmt->execute([':data_upload_id' => $data_upload_id])) {
      while ($row = $stmt->fetch(PDO::FETCH_NUM))
        array_push($data, $row);
    }

    return $data;
  }

  function writeArrayToWorksheet($data, &$sheet) {
    for ($row = 0; $row < count($data); $row ++) {
      for ($column = 0; $column < count($data[$row]); $column ++) {
        $sheet->setCellValueByColumnAndRow($column, $row + 1, $data[$row][$column]);
      }
    }

    return $sheet;
  }

  function addArrayAsWorksheet($data, $sheet_title, $filepath) {
    $excel = \PHPExcel_IOFactory::createReader('Excel2007')->load($filepath);
    $sheet = $excel->createSheet();
    $sheet->setTitle($sheet_title);
    $sheet = $this->writeArrayToWorksheet($data, $sheet);

    $writer = \PHPExcel_IOFactory::createWriter($excel, 'Excel2007');
    $writer->setIncludeCharts(true);
    $writer->save($filepath);
  }

  function addSearchCriteria($pdo, $filepath, int $search_id) {
    $data = self::getSearchCriteria($pdo, $search_id);
    $this->addArrayAsWorksheet($data, 'Search Criteria', $filepath);
  }

  function addDataReviewCriteria($pdo, $filepath, int $data_upload_id) {
    $data = self::getDataReviewCriteria($pdo, $data_upload_id);
    $this->addArrayAsWorksheet($data, 'Data Upload Review', $filepath);
  }
}
