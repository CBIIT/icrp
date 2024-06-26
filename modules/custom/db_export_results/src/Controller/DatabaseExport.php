<?php

namespace Drupal\db_export_results\Controller;

use DateTime;
use PDO;
use PDOStatement;

use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Chart\Chart;
use PhpOffice\PhpSpreadsheet\Chart\DataSeries;
use PhpOffice\PhpSpreadsheet\Chart\DataSeriesValues;
use PhpOffice\PhpSpreadsheet\Chart\Legend;
use PhpOffice\PhpSpreadsheet\Chart\Layout;
use PhpOffice\PhpSpreadsheet\Chart\PlotArea;
use PhpOffice\PhpSpreadsheet\Chart\Title;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

class DatabaseExport {

  public const EXPORT_RESULTS_PUBLIC                          = 'EXPORT_RESULTS_PUBLIC';
  public const EXPORT_RESULTS_PARTNERS                        = 'EXPORT_RESULTS_PARTNERS';
  public const EXPORT_RESULTS_AS_SINGLE_SHEET                 = 'EXPORT_RESULTS_AS_SINGLE_SHEET';
  public const EXPORT_RESULTS_WITH_ABSTRACTS                  = 'EXPORT_RESULTS_WITH_ABSTRACTS';
  public const EXPORT_RESULTS_WITH_ABSTRACTS_AS_SINGLE_SHEET  = 'EXPORT_RESULTS_WITH_ABSTRACTS_AS_SINGLE_SHEET';
  public const EXPORT_CSO_CANCER_TYPES                        = 'EXPORT_CSO_CANCER_TYPES';
  public const EXPORT_GRAPHS_PUBLIC                           = 'EXPORT_GRAPHS_PUBLIC';
  public const EXPORT_GRAPHS_PARTNERS                         = 'EXPORT_GRAPHS_PARTNERS';


  /**
   * Ensure that the output directory exists
   */
  function __construct() {

    $this->output_directory = \Drupal::config('icrp-tmp')->get('exports') ?? 'data/tmp/exports';

    // create the output directory if it does not exist
    if (!file_exists($this->output_directory)) {
      mkdir($this->output_directory, 0744, true);
    }

    /**
     * Workbook definitions
     *
     * Each entry is an associative array that corresponds to an excel workbook
     * This array contains entries that correspond to sheets within the workbook
     * The 'query' property of this array specifies the query that is to be performed against the database
     * The 'columns' property specifies the column mapping that is to be applied to the results set (as well as defining any custom column names)
     *   - if empty, no mappings will be applied and the entire results set will be written to the specified sheet
    */
    $this->EXPORT_MAP = [

      // Workbook definition for 'EXPORT_RESULTS_PUBLIC' method
      self::EXPORT_RESULTS_PUBLIC  => [

        // Sheet definition for 'Search Results'
        'Search Results' => [
          'query' => 'EXECUTE GetProjectExportsBySearchID         @SearchID=:search_id, @includeAbstract=0, @SiteURL=:site_url, @Year = :year',
          'columns' =>  [
            'ICRPProjectID'        => 'ICRP Project ID',
            'ICRPProjectFundingID' => 'ICRP Project Funding ID',
            'AltAwardCode'         => 'Alt. Award Code',
            'AwardTitle'           => 'Project Title',
            'piFirstName'          => 'PI First Name',
            'piLastName'           => 'PI Last Name',
            'Institution'          => 'Institution',
            'City'                 => 'City',
            'State'                => 'State',
            'Country'              => 'Country',
            'Region'               => 'Region',
            'FundingOrg'           => 'Funding Organization',
            'AwardCode'            => 'Award Code',
            'icrpURL'              => 'View in ICRP',
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
          'column_formatter' => function($column) {
            return is_numeric($column)
              ? "$column (USD)"
              : $column;
          },
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
          'column_formatter' => function($column) {
            return is_numeric($column)
              ? "$column (USD)"
              : $column;
          },
        ],
      ],

      // Workbook definition for 'EXPORT_RESULTS_WITH_ABSTRACTS' method
      self::EXPORT_RESULTS_WITH_ABSTRACTS => [

        // Sheet definition for 'Search Results'
        'Search Results' => [
          'query' => 'EXECUTE GetProjectExportsBySearchID         @SearchID=:search_id, @includeAbstract=1, @SiteURL=:site_url, @Year = :year',
          'columns' =>  [/* use original columns from database */],
          'column_formatter' => function($column) {
            return is_numeric($column)
              ? "$column (USD)"
              : $column;
          },
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
          'column_formatter' => function($column) {
            return is_numeric($column)
              ? "$column (USD)"
              : $column;
          },
        ],
      ],

      // Workbook definition for 'EXPORT_CSO_CANCER_TYPES' method
      self::EXPORT_CSO_CANCER_TYPES => [
        'Project Counts' => [
          'query' => 'EXECUTE GetProjectCSOandCancerTypeExportsBySearchID  @SearchID=:search_id, @Type=Count;',
          'columns' =>  [/* use original columns from database */],
          'column_formatter' => function($column) {
            return is_numeric($column)
              ? "CSO $column"
              : $column;
          },
          'record_formatter' => function($record) {
            return is_numeric($record)
              ? floatval($record)
              : $record;
          },
        ],

        'Project Funding Amounts (USD)' => [
          'query' => 'EXECUTE GetProjectCSOandCancerTypeExportsBySearchID  @SearchID=:search_id, @Type=Amount;',
          'columns' =>  [/* use original columns from database */],
          'column_formatter' => function($column) {
            return is_numeric($column)
              ? "CSO $column"
              : $column;
            },
            'record_formatter' => function($record) {
              return is_numeric($record)
                ? floatval($record)
                : $record;
            },
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

        // Sheet definition for 'Projects by Institution'
        'Projects by PI Institution' => [
          'query' => 'EXECUTE GetProjectInstitutionStatsBySearchID      @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Count',
          'columns' => [
            'Institution'   => 'PI Institution',
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
        'Projects by PI Institution' => [
          'query' => 'EXECUTE GetProjectInstitutionStatsBySearchID      @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Count',
          'columns' => [
            'Institution'   => 'PI Institution',
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
        'Amounts by Project Type' => [
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
        'Amounts by PI Institution' => [
          'query' => 'EXECUTE GetProjectInstitutionStatsBySearchID      @SearchID = :search_id, @ResultCount = NULL, @ResultAmount = NULL, @Year = :year, @Type = Amount',
          'columns' => [
            'Institution'   => 'PI Institution',
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
    $spreadsheet = new Spreadsheet();
    $spreadsheet->getProperties()
      ->setTitle('ICRP Data Export')
      ->setCreator('International Cancer Research Partnership');
    $sheet = $spreadsheet->getActiveSheet();

    $sheet_definitions = $this->EXPORT_MAP[$workbook_key];
    $sheet_definition_keys = array_keys($sheet_definitions);
    $last_key = end($sheet_definition_keys);

    // loop through each sheet's definition
    foreach($sheet_definitions as $sheet_name => $sheet_definition) {
      // determine the query for the current sheet
      $sheet_query = $sheet_definition['query'];

      // determine the column names for the current sheet
      $sheet_columns = $sheet_definition['columns'];

      // set the name of the current sheet
      $sheet_title = $sheet_name;
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
        $sheet->fromArray($rows);
        $num_rows = count($rows) - 1;

        $dataSeriesLabels = [
          new DataSeriesValues(DataSeriesValues::DATASERIES_TYPE_STRING, "'${sheet_name}'" . '!$A$1', NULL, 1),
          new DataSeriesValues(DataSeriesValues::DATASERIES_TYPE_STRING, "'${sheet_name}'" . '!$B$1', NULL, 1),
        ];

        $xAxisTickValues = [
          new DataSeriesValues(
            DataSeriesValues::DATASERIES_TYPE_STRING,
            "'".$sheet_name."'" . '!$A$2:$A$' . ($num_rows + 1), NULL, $num_rows
          )
        ];

        $dataSeriesValues = [
          new DataSeriesValues(
            DataSeriesValues::DATASERIES_TYPE_NUMBER,
            "'".$sheet_name."'" . '!$B$2:$B$' . ($num_rows + 1), NULL, $num_rows
          ),
        ];

        // Build the dataseries
        $series = new DataSeries(
            DataSeries::TYPE_BARCHART, // plotType
            DataSeries::GROUPING_CLUSTERED, // plotGrouping
            range(0, count($dataSeriesValues) - 1), // plotOrder
            $dataSeriesLabels, // plotLabel
            $xAxisTickValues, // plotCategory
            $dataSeriesValues        // plotValues
        );

        // $series->setPlotDirection(DataSeries::DIRECTION_COL);

        $layout = (new Layout())
          ->setShowVal(TRUE);

        // Set the series in the plot area
        $plotArea = new PlotArea($layout, [$series]);

        // Set the chart legend
        $legend = new Legend(Legend::POSITION_RIGHT, null, false);

        $title = new Title($sheet_title);
        $xAxisLabel = new Title($rows[0][0]);
        $yAxisLabel = new Title($rows[0][1]);

        // Create the chart
        $chart = new Chart(
          $sheet_title, // name
          $title, // title
          $legend, // legend
          $plotArea, // plotArea
          true, // plotVisibleOnly
          DataSeries::EMPTY_AS_GAP, // displayBlanksAs
          $xAxisLabel, // xAxisLabel
          $yAxisLabel  // yAxisLabel
        );

        $chart->setTopLeftPosition(self::cell(0, 4));
        $chart->setBottomRightPosition(self::cell(25, 25));

        $sheet->addChart($chart);
      }

      // add another sheet if we are not at the last sheet
      if ($sheet_name !== $last_key) {
        $sheet = $spreadsheet->createSheet();
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

    if ($workbook_key == self::EXPORT_GRAPHS_PARTNERS) {
      $data[] = ['Currency Conversion Year:', "$year"];
    }

    $sheet = $spreadsheet->createSheet();
    $sheet->setTitle($sheet_name);
    $sheet->fromArray($data);

    (new Xlsx($spreadsheet))
      ->setIncludeCharts(true)
      ->save($paths['filepath']);

    return $paths['uri'];
  }

  /**
   * Exports search results based on the specified configuration
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
    $filepath = $paths['filepath'];

    $spreadsheet = new Spreadsheet();
    $sheet_definitions = $this->EXPORT_MAP[$workbook_key];
    $sheet_definition_keys = array_keys($sheet_definitions);
    $last_key = end($sheet_definition_keys);
    $worksheet = $spreadsheet->getActiveSheet();

    // loop through each sheet's definition
    foreach($sheet_definitions as $sheet_name => $sheet_definition) {
      $sheet_data = [];

      // determine the query for the current sheet
      $sheet_query = $sheet_definition['query'];

      // determine the column names for the current sheet
      $sheet_columns = $sheet_definition['columns'];

      $column_formatter = $sheet_definition['column_formatter'] ?? null;

      $record_formatter = $sheet_definition['record_formatter'] ?? null;

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
            $sheet_columns[] = $meta['name'];
          }
        }

        $column_names = array_values($sheet_columns);

        if (is_callable($column_formatter)) {
          $column_names = array_map($column_formatter, $column_names);
        }

        // add headers to the current sheet
        $sheet_data[] = $column_names;

        // iterate over each of the rows in the results
        // if we are using all table columns, we may insert each row without processing it
        if ($use_database_columns) {

          // apply a record formatter to each record, if specified
          // note: this is split into two branches to reduce
          // the number of checks when no $record_formatter is specified
          if (is_callable($record_formatter)) {
            while ($row = $results->fetch(PDO::FETCH_NUM)) {
              $sheet_data[] = (
                array_map(function($value) use ($record_formatter) {
                  return $record_formatter(substr($value, 0, 32767));
                }, $row)
              );
            }
          // this case should have identical performance to the original implementation
          } else {
            while ($row = $results->fetch(PDO::FETCH_NUM)) {
              $sheet_data[] = (
                array_map(function($value) {
                  return substr($value, 0, 32767);
                }, $row)
              );
            }
          }
        }

        // otherwise, apply the column mappings specified in the definition
        else {
          $columns = array_keys($sheet_columns);
          while ($row = $results->fetch(PDO::FETCH_ASSOC)) {
            $sheet_data[] = (
              array_map(function($column) use ($row, $record_formatter) {
                if (array_key_exists($column, $row)) {
                  $value = substr($row[$column], 0, 32767);
                  return is_callable($record_formatter)
                    ? $record_formatter($value)
                    : $value;
                }
                return '';
              }, $columns)
            );
          }
        }
        
        $worksheet->setTitle($sheet_name);
        $worksheet->fromArray($sheet_data);

        if ($sheet_name !== $last_key) {
          $worksheet = $spreadsheet->createSheet();
        }
      }
    }

    function addSheetToWorkbook($spreadsheet, $sheet_name, $data) {
      $worksheet = $spreadsheet->createSheet();
      $worksheet->setTitle($sheet_name);
      $worksheet->fromArray($data);
    }

    // if a data upload id was not specified, add a sheet containing search criteria
    // otherwise, do not include search criteria and instead use data review criteria
    $data_upload_id === NULL
      ? addSheetToWorkbook($spreadsheet, 'Search Criteria', $this->getSearchCriteria($pdo, $search_id))
      : addSheetToWorkbook($spreadsheet, 'Data Upload Review', $this->getDataReviewCriteria($pdo, $data_upload_id));

    // Add currency rate and year to last workbook entry
    if (in_array($workbook_key, [
      self::EXPORT_RESULTS_PARTNERS,
      self::EXPORT_RESULTS_AS_SINGLE_SHEET,
      self::EXPORT_RESULTS_WITH_ABSTRACTS,
      self::EXPORT_RESULTS_WITH_ABSTRACTS_AS_SINGLE_SHEET,
      self::EXPORT_CSO_CANCER_TYPES,
    ])) {
      $lastSheetIndex = $spreadsheet->getSheetCount() - 1;
      $worksheet = $spreadsheet->getSheet($lastSheetIndex);
      $row = $worksheet->getHighestRow() + 1;
      $worksheet->insertNewRowBefore($row);
      $worksheet->setCellValue('A'.$row, 'Currency Conversion Year:');
      $worksheet->setCellValue('B'.$row, $year);
    }

    $xlsx = new Xlsx($spreadsheet);
    $xlsx->save($filepath);
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

}
