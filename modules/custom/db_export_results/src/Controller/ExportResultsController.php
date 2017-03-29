<?php
/**
 * @file
 * Contains \Drupal\db_email_results\Controller\ExportResultsController.
 */
namespace Drupal\db_export_results\Controller;

require_once 'PHPExcel.php';
require_once 'spout-2.7.1/src/Spout/Autoloader/autoload.php';

use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Database\Database;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use PDO;
use ZipArchive;
use PHPExcel;
use PHPExcel_IOFactory;
use PHPExcel_Chart_DataSeries;
use PHPExcel_Style_Border;
use PHPExcel_Chart_DataSeriesValues;
use PHPExcel_Chart_DataSerie;
use PHPExcel_Chart_Layout;
use	PHPExcel_Chart_PlotArea;
use	PHPExcel_Chart_Legend;
use	PHPExcel_Chart_Title;
use	PHPExcel_Chart;
use Box\Spout\Common\Exception\SpoutException;
use Box\Spout\Writer\WriterFactory;
use Box\Spout\Writer\XLSX\Internal\Worksheet;
use Box\Spout\Writer\XLSX\Writer;
use Box\Spout\Common\Type;
use Box\Spout\Writer\Style\StyleBuilder;

 /** Error reporting */
error_reporting(E_ALL);
ini_set('display_errors', TRUE);
ini_set('display_startup_errors', TRUE);


define('EOL',(PHP_SAPI == 'cli') ? PHP_EOL : '<br />');

class ExportResultsController extends ControllerBase {
 		  
  /**
  * Adds CORS Headers to a response
  */
  public function addCorsHeaders($response) {

      $response->headers->set('Access-Control-Allow-Headers', 'origin, content-type, accept');
      $response->headers->set('Access-Control-Allow-Origin', '*');
      $response->headers->set('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, PATCH, OPTIONS');

      return $response;
  }

  public function exportResults() {

    $sid = $_SESSION['database_search_id'];
    //$sid = 4;

	$isPublic = true;
  	$config = self::getConfig();
    $filelocation = $config['file_location'];
    $downloadlocation = self::getBaseUrl() .  $config['download_location'];
    $filenameExport  = 'ICRPExportPublic'.$sid.'.xlsx';

	 try {
	   $conn = self::getConnection();
  	 } catch (Exception $exc) {
  	   return "Could not create db connection";
  	 }

	$result = "success";

  	$shouldUseInlineStrings = true;
	$shouldCreateSheetsAutomatically = true;

	/** @var \Box\Spout\Writer\XLSX\Writer $writer */
	$writer = WriterFactory::create(Type::XLSX);
	$writer->setShouldUseInlineStrings($shouldUseInlineStrings);
	$writer->setShouldCreateNewSheetsAutomatically($shouldCreateSheetsAutomatically);
	$writer->openToFile($filelocation.$filenameExport);

    $result = self::createExportPublicSheet($conn, $writer, $sid);
	$result = self::createCSOSheet($conn, $writer, $sid, $isPublic);
    $result = self::createSiteSheet($conn, $writer, $sid, $isPublic);
	$result = self::createCriteriaSheet($conn, $writer, $sid);
	
	$writer->close();
    $conn = null;

	return self::addCorsHeaders(new JSONResponse($downloadlocation.$filenameExport));
  }

  private function createExportPublicSheet($conn, $writer, $sid){
	$result = "";
	$style = (new StyleBuilder())
  	 		  ->setShouldWrapText(false)
  	 		  ->build();
   
    $header = ['Title', 'PI First Name', 'PI Last Name', 'Institution', 'City', 'State', 'Country', 'Funding Organization', 'Award Code', 'View in ICRP'];

    $url = self::getBaseUrl();
	$viewLink = $url . "project/";
	$result_count = NULL;
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectsBySearchID @SearchID=:search_id_name, @ResultCount=:result_count");
	$stmt->bindParam(':search_id_name', $sid);
	$stmt->bindParam(':result_count', $result_count, PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT, 1000);
	if ($stmt->execute()) {
		$writer->addRowsWithStyle([$header], $style);
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			$rowData = Array();
			$rowData[0] = $row['Title'];
			$rowData[1] = $row['piFirstName'];
			$rowData[2] = $row['piLastName'];
			$rowData[3] = $row['institution'];
			$rowData[4] = $row['City'];
			$rowData[5] = $row['State'];
			$rowData[6] = $row['country'];
			$rowData[7] = $row['FundingOrg'];
			$rowData[8] = $row['AwardCode'];
			$rowData[9] = $viewLink . $row['ProjectID'];
			$writer->addRowsWithStyle([$rowData], $style);
		}
		$result = "succeed";
	    $writer->getCurrentSheet()->setName('Search Result');
	} else {
		$result = "failed to query server";
	}

	return $result;
  }

  private function getConfig(){
    $database_config = \Drupal::config('icrp_file_export');
    $config = [];
    foreach(['file_location', 'download_location'] as $parameter) {
    	$config[$parameter] = $database_config->get($parameter);
	}

	return $config;
  }

  private function getConnection(){
  	$database_config = \Drupal::config('icrp_database');
  	$config = [];

  	foreach(['host', 'username', 'password', 'port', 'database'] as $parameter) {
  		$config[$parameter] = $database_config->get($parameter);
	}

	$host = $config['host'];
	$database = $config['database'];
	$username = $config['username'];
	$password = $config['password'];
	$port = $config['port'];

	$serverName = $host.", ".$port;
	$opt = [
		PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
		PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
	];

  	return new PDO("sqlsrv:Server=".$serverName.";Database=".$database, $username, $password, $opt);
  }

  private function getBaseUrl()
  {
	$currentPath = $_SERVER['PHP_SELF'];
	$pathInfo = pathinfo($currentPath);
	$hostName = $_SERVER['HTTP_HOST'];
	$protocol = strtolower(substr($_SERVER["SERVER_PROTOCOL"],0,5))=='https://'?'https://':'https://';

	return $protocol.$hostName."/";
  }

  public function exportResultsPartner(){
    $sid = $_SESSION['database_search_id'];
    //$sid = 4;

	$result = "Complete Exporting Results in Partner Site";
	$config = self::getConfig();
 	$filelocation = $config['file_location'];
 	$downloadlocation = self::getBaseUrl() .  $config['download_location'];
    $filenameExport  = 'ICRPExportPartner'.$sid.'.xlsx';

  	 try {
	   $conn = self::getConnection();
  	 } catch (Exception $exc) {
  	   return "Could not create db connection";
  	 }


	$shouldUseInlineStrings = true;
	$shouldCreateSheetsAutomatically = true;

	/** @var \Box\Spout\Writer\XLSX\Writer $writer */
	$writer = WriterFactory::create(Type::XLSX);
	$writer->setShouldUseInlineStrings($shouldUseInlineStrings);
	$writer->setShouldCreateNewSheetsAutomatically($shouldCreateSheetsAutomatically);
	$writer->openToFile($filelocation.$filenameExport);

    //create export data for partner site
    $withAbstract = false;
	$isPublic = false;

    $result = self::createExportDataforPartner($conn, $writer, $sid, $withAbstract);
	$result = self::createCSOSheet($conn, $writer, $sid, $isPublic);
	$result = self::createSiteSheet($conn, $writer, $sid, $isPublic);
	$result = self::createCriteriaSheet($conn, $writer, $sid);
    $writer->close();
    $conn = null;

	return self::addCorsHeaders(new JSONResponse($downloadlocation . $filenameExport));
  }

  private function createExportDataforPartner($conn, $writer, $sid, $withAbstract){
	$result = "success";
	$style = (new StyleBuilder())
  	 	   ->setShouldWrapText(false)
  	 	   ->build();

    $abstract = 0;
	$url = self::getBaseUrl();
	$viewLink = $url . "project/";
	if($withAbstract == true){
		$abstract = 1;
	}else{
		$abstract = 0;
	}
	$rowData =array();
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectExportsBySearchID @SearchID=:search_id_name, @SiteURL=:site_url, @IncludeAbstract=:with_abstract");
	$stmt->bindParam(':search_id_name', $sid);
	$stmt->bindParam(':site_url', $viewLink);
    $stmt->bindParam(':with_abstract', $abstract);
	if ($stmt->execute()) {
		$colName = Array();
		foreach(range(0, $stmt->columnCount() - 1) as $column_index)
		{
		  $meta = $stmt->getColumnMeta($column_index);
		  $colName[] = $meta['name'];
		}
		//add header to Excel file
		$writer->addRowsWithStyle([$colName], $style);
		$arrayLength = sizeof($colName);
		//add content to Excel file
		while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
			$rowData = Array();
			for($i = 0; $i < $arrayLength; $i++){
				$rowData[$i] = $row[$colName[$i]];
			}
			$writer->addRowsWithStyle([$rowData], $style);
		}
		$writer->getCurrentSheet()->setName("Search Result");
	}

	return $result;
  }

  private function createSiteSheet($conn, $writer, $sid, $isPublic){
  	$result = "";
  	$style = (new StyleBuilder())
  	 		  ->setShouldWrapText(false)
  	 		  ->build();

  	$header1 = ['ICRP PROJECT ID', 'Cancer Type'];
 	$header2 = ['ICRP PROJECT ID', 'Cancer Type', 'Site Relevance'];
     //add a new sheet
    $writer->addNewSheetAndMakeItCurrent();
    $stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectCancerTypesBySearchID @SearchID=:search_id_name");
	$stmt->bindParam(':search_id_name', $sid);

	if ($stmt->execute()) {
		if($isPublic){
			$writer->addRowsWithStyle([$header1], $style);
		}else{
			$writer->addRowsWithStyle([$header2], $style);
		}
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			$rowData = Array();	
			if($isPublic){
				$rowData[0] = $row['ProjectID'];
				$rowData[1] = $row['CancerType'];
				$writer->addRowsWithStyle([$rowData], $style);
			}else{
				$rowData[0] = $row['ProjectID'];
				$rowData[1] = $row['CancerType'];
				$rowData[2] = $row['Relevance'];
				$writer->addRowsWithStyle([$rowData], $style);
			}
		}
		$result = "succeed";
		$writer->getCurrentSheet()->setName('Project By Cancer Type');
	} else {
		$result = "failed to query server";
	}

    return $result;
  }

  private function createCSOSheet($conn, $writer, $sid, $isPublic){
 	$result = "";
 	$style = (new StyleBuilder())
  	 		  ->setShouldWrapText(false)
  	 		  ->build();

 	$header1 = ['ICRP PROJECT ID', 'Code'];
 	$header2 = ['ICRP PROJECT ID', 'Code', 'CSO Relevance'];
 	//add a new sheet
   	$writer->addNewSheetAndMakeItCurrent();

	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectCSOsBySearchID @SearchID=:search_id_name");
	$stmt->bindParam(':search_id_name', $sid);
	if ($stmt->execute()) {
		if($isPublic){
			$writer->addRowsWithStyle([$header1], $style);
		}else{
			$writer->addRowsWithStyle([$header2], $style);	
		}
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			$rowData = Array();
			if($isPublic){
				$rowData[0] = $row['ProjectID'];
				$rowData[1] = $row['CSOCode'];
				$writer->addRowsWithStyle([$rowData], $style);
			}else{
				$rowData[0] = $row['ProjectID'];
				$rowData[1] = $row['CSOCode'];
				$rowData[2] = $row['CSORelevance'];
				$writer->addRowsWithStyle([$rowData], $style);
			 }
		}
		$result = "succeed";
		$writer->getCurrentSheet()->setName("Project By CSO");
	} else {
		$result = "failed to query server";
	}

	return $result;
  }

  private function createCriteriaSheet($conn, $writer, $sid){
    $result = "";
    $style = (new StyleBuilder())
  	 		  ->setShouldWrapText(false)
  	 		  ->build();
	 //add a new sheet
    $writer->addNewSheetAndMakeItCurrent();
    $rowData = Array();
    $rowData[0] = "International Cancer Research Partnership - ";
    $rowData[1] = self::getBaseUrl();
    $writer->addRowsWithStyle([$rowData], $style);
    $rowData = Array();
	$date = date("m/d/Y H:i:s");
    $rowData[0] = "Created: ";
    $rowData[1] = $date;
    $writer->addRowsWithStyle([$rowData], $style);
    $rowData = Array();
    $rowData[0] = "Search Criteria: ";
    $rowData[1] = " ";
    $writer->addRowsWithStyle([$rowData], $style);

	$stmt = $conn -> prepare("SET NOCOUNT ON; exec GetSearchCriteriaBySearchID @SearchID = :search_id");
	$stmt->bindParam(':search_id', $sid);

	if ($stmt->execute()){
	   while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
	   		$rowData = Array();
	   		$rowData[0] = $row['Name'];
    		$rowData[1] = $row['Value'];
		    $writer->addRowsWithStyle([$rowData], $style);
	   }
	   $result = "succeed";
	   $writer->getCurrentSheet()->setName("Search Criteria");
	} else {
	   $result = "failed to query server";
    }

	return $result;
  }


  public function exportResultsWithAbstractPartner(){
     $sid = $_SESSION['database_search_id'];
    //$sid = 4;

	$isPublic = false;
	$result = "Complete Exporting Results in Partner Site";
	$config = self::getConfig();
 	$filelocation = $config['file_location'];
 	$downloadlocation = self::getBaseUrl() .  $config['download_location'];
    $filenameExport  = 'ICRPExportPartnerWithAbstract'.$sid.'.xlsx';

  	 try {
	   $conn = self::getConnection();
  	 } catch (Exception $exc) {
  	   return "Could not create db connection";
  	 }
    $shouldUseInlineStrings = true;
    $shouldCreateSheetsAutomatically = true;

        /** @var \Box\Spout\Writer\XLSX\Writer $writer */
    $writer = WriterFactory::create(Type::XLSX);
    $writer->setShouldUseInlineStrings($shouldUseInlineStrings);
    $writer->setShouldCreateNewSheetsAutomatically($shouldCreateSheetsAutomatically);
    $writer->openToFile($filelocation.$filenameExport);
    $withAbstract = true;

	self::createExportDataforPartner($conn, $writer, $sid, $withAbstract);
	self::createCSOSheet($conn, $writer, $sid, $isPublic);
    self::createSiteSheet($conn, $writer, $sid, $isPublic);
    self::createCriteriaSheet($conn, $writer, $sid);

    $writer->close();
    $conn = null;

	return self::addCorsHeaders(new JSONResponse($downloadlocation . $filenameExport));
  }

   public function exportResultsWithGraphsPartner(Request $request){
    $year = $request->query->get('year');
	$result = "Complete Exporting Results with Graphs in Partner Site";
	$sid = $_SESSION['database_search_id'];

	$result = "Complete Exporting Results in Partner Site";
	$config = self::getConfig();
	$filelocation = $config['file_location'];
	$downloadlocation = self::getBaseUrl() .  $config['download_location'];
	$filenameExport  = 'ICRPExportGraphPartner'.$sid.'.xlsx';
    $isPublic = false;

	$result = self::createExcelFileWithGraph($filelocation, $filenameExport, $sid, $year, $isPublic);

	return self::addCorsHeaders(new JSONResponse($downloadlocation.$filenameExport));
  }

   public function exportResultsWithGraphsPartnerPublic(){
	$year = 0;
	$result = "Complete Exporting Results with Graphs in Partner Site";
	$sid = $_SESSION['database_search_id'];

	$result = "Complete Exporting Results in Partner Site";
	$config = self::getConfig();
	$filelocation = $config['file_location'];
	$downloadlocation = self::getBaseUrl() .  $config['download_location'];
	$filenameExport  = 'ICRPExportGraphPartner'.$sid.'.xlsx';
	$isPublic = true;
	$result = self::createExcelFileWithGraph($filelocation, $filenameExport, $sid, $year, $isPublic);

	return self::addCorsHeaders(new JSONResponse($downloadlocation.$filenameExport));
  }

  private function createExcelFileWithGraph($filelocation, $filename, $sid, $year, $isPublic){
  	$result = "Succeed";
    try {
  	   $conn = self::getConnection();
    } catch (Exception $exc) {
    	   return "Could not create db connection";
  	}

    $totalRow = 0;
  	// Create new PHPExcel object
	$objPHPExcel = new PHPExcel();

	// Set document properties
	$objPHPExcel->getProperties()->setCreator("ICRP")
							 	->setLastModifiedBy("ICRP")
							 	->setTitle("ICRP export with Graphics")
							 	->setSubject("ICRP export data")
							 	->setDescription("Exporting ICRP data with Graphs.")
							 	->setKeywords("ICRP data with Graphs")
							 	->setCategory("ICRP data");

    //create first sheet for Projects By Country
   	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectCountryStatsBySearchID @SearchID=:search_id_name,  @ResultCount=:result_count");
   	$stmt->bindParam(':search_id_name', $sid);
   	$stmt->bindParam(':result_count', $result_count, PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT, 1000);

   	if ($stmt->execute()) {
   	    $i = 2;
   		// Add some data
   		$objPHPExcel->setActiveSheetIndex(0)
   		            ->setCellValue('A1', 'Country')
   		            ->setCellValue('B1', 'Project Count');
   		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
   			$objPHPExcel->setActiveSheetIndex(0)
   		    	        ->setCellValue('A'.$i, $row['country'])
   		    	        ->setCellValue('B'.$i, $row['Count']);
   			$i = $i + 1;
   			$totalRow = $totalRow + 1;
   		}
   		$result = "succeed";
   	} else {
   		$result = "failed to query server";
   	}
    $objPHPExcel->getActiveSheet()->setTitle('Projects_By_Country');

	$dataseriesLabels1 = array(
		new PHPExcel_Chart_DataSeriesValues('String', 'Projects_By_Country!$B$1', NULL, 1),
	);
	$xAxisTickValues1 = array(
	  new PHPExcel_Chart_DataSeriesValues('String', 'Projects_By_Country!$A$2:$A$'.($totalRow+1), NULL, $totalRow),
	);
    $dataSeriesValues1 = array(
	  new PHPExcel_Chart_DataSeriesValues('Number', 'Projects_By_Country!$B$2:$B$'.($totalRow+1), NULL, $totalRow),
	);
	$series1 = new PHPExcel_Chart_DataSeries(
	  PHPExcel_Chart_DataSeries::TYPE_BARCHART,       // plotType
	  PHPExcel_Chart_DataSeries::GROUPING_STANDARD,     // plotGrouping
	  range(0, count($dataSeriesValues1)-1),          // plotOrder
	  $dataseriesLabels1,                   // plotLabel
	  $xAxisTickValues1,                    // plotCategory
	  $dataSeriesValues1                    // plotValues
	);
	$layout1 = new PHPExcel_Chart_Layout();
	$layout1->setShowVal(TRUE);
	$plotarea1 = new PHPExcel_Chart_PlotArea($layout1, array($series1));
	$legend1 = new PHPExcel_Chart_Legend(PHPExcel_Chart_Legend::POSITION_RIGHT, NULL, false);
	$title1 = new PHPExcel_Chart_Title('Projects By Country');
	$chart1 = new PHPExcel_Chart(
	  'chart1',   // name
	  $title1,    // title
	  $legend1,   // legend
	  $plotarea1,   // plotArea
	  true,     // plotVisibleOnly
	  0,        // displayBlanksAs
	  NULL,     // xAxisLabel
	  NULL      // yAxisLabel   - Pie charts don't have a Y-Axis
	);
	$chart1->setTopLeftPosition('D2');
	$chart1->setBottomRightPosition('Q26');
	$objPHPExcel->getActiveSheet()->addChart($chart1);

	//create second sheet for Projects By CSO
	$totalRow = 0;
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectCSOStatsBySearchID @SearchID=:search_id_name,  @ResultCount=:result_count");
	$stmt->bindParam(':search_id_name', $sid);
	$stmt->bindParam(':result_count', $result_count, PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT, 1000);

	if ($stmt->execute()) {
		// Add new sheet
		$objWorkSheet = $objPHPExcel->createSheet();
	    $i = 2;
		// Add some data
		$objPHPExcel->setActiveSheetIndex(1)
		            ->setCellValue('A1', 'Category Name')
		            ->setCellValue('B1', 'Relevance')
		            ->setCellValue('C1', 'Project Count');
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			$objPHPExcel->setActiveSheetIndex(1)
		    	        ->setCellValue('A'.$i, $row['categoryName'])
		    	        ->setCellValue('B'.$i, $row['Relevance'])
		    	        ->setCellValue('C'.$i, $row['ProjectCount']);
			$i = $i + 1;
			$totalRow = $totalRow + 1;
		}

		$result = "succeed";
	} else {
		$result = "failed to query server";
	}
    $objPHPExcel->getActiveSheet()->setTitle('Project_By_CSO');
    $objPHPExcel->setActiveSheetIndex(1);
	$dataseriesLabels2 = array(
		new PHPExcel_Chart_DataSeriesValues('String', 'Project_By_CSO!$B$1', NULL, 1),
	);
	$xAxisTickValues2 = array(
	  new PHPExcel_Chart_DataSeriesValues('String', 'Project_By_CSO!$A$2:$A$'.($totalRow+1), NULL, $totalRow),
	);
    $dataSeriesValues2 = array(
	  new PHPExcel_Chart_DataSeriesValues('Number', 'Project_By_CSO!$B$2:$B$'.($totalRow+1), NULL, $totalRow),
	);
	$series2 = new PHPExcel_Chart_DataSeries(
	  PHPExcel_Chart_DataSeries::TYPE_BARCHART,       // plotType
	  PHPExcel_Chart_DataSeries::GROUPING_STANDARD,     // plotGrouping
	  range(0, count($dataSeriesValues2)-1),          // plotOrder
	  $dataseriesLabels2,                   // plotLabel
	  $xAxisTickValues2,                    // plotCategory
	  $dataSeriesValues2                    // plotValues
	);
	$layout2 = new PHPExcel_Chart_Layout();
	$layout2->setShowVal(TRUE);
	$plotarea2 = new PHPExcel_Chart_PlotArea($layout2, array($series2));
	$legend2 = new PHPExcel_Chart_Legend(PHPExcel_Chart_Legend::POSITION_RIGHT, NULL, false);
	$title2 = new PHPExcel_Chart_Title('Projects By CSO');
	$chart2 = new PHPExcel_Chart(
	  'chart2',   // name
	  $title2,    // title
	  $legend2,   // legend
	  $plotarea2,   // plotArea
	  true,     // plotVisibleOnly
	  0,        // displayBlanksAs
	  NULL,     // xAxisLabel
	  NULL      // yAxisLabel   - Pie charts don't have a Y-Axis
	);
	$chart2->setTopLeftPosition('D2');
	$chart2->setBottomRightPosition('Q26');
	$objPHPExcel->getActiveSheet()->addChart($chart2);


	//create second sheet for Projects By Cancer Type
	$totalRow = 0;
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectCancerTypeStatsBySearchID @SearchID=:search_id_name,  @ResultCount=:result_count");
	$stmt->bindParam(':search_id_name', $sid);
	$stmt->bindParam(':result_count', $result_count, PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT, 1000);

	if ($stmt->execute()) {
		// Add new sheet
		$objWorkSheet = $objPHPExcel->createSheet();
	    $i = 2;
		// Add some data
		$objPHPExcel->setActiveSheetIndex(2)
		            ->setCellValue('A1', 'Cancer Type')
		            ->setCellValue('B1', 'Relevance')
		            ->setCellValue('C1', 'Project Count');
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			$objPHPExcel->setActiveSheetIndex(2)
		    	        ->setCellValue('A'.$i, $row['CancerType'])
		    	        ->setCellValue('B'.$i, $row['Relevance'])
		    	        ->setCellValue('C'.$i, $row['ProjectCount']);
			$i = $i + 1;
			$totalRow = $totalRow + 1;;
		}

		$result = "succeed";
	} else {
		$result = "failed to query server";
	}
    $objPHPExcel->getActiveSheet()->setTitle('Project_By_Cancer_Type');
    $objPHPExcel->setActiveSheetIndex(2);
	$dataseriesLabels3 = array(
		new PHPExcel_Chart_DataSeriesValues('String', 'Project_By_Cancer_Type!$B$1', NULL, 1),
	);
	$xAxisTickValues3 = array(
	  new PHPExcel_Chart_DataSeriesValues('String', 'Project_By_Cancer_Type!$A$2:$A$'.($totalRow+1), NULL, $totalRow),
	);
    $dataSeriesValues3 = array(
	  new PHPExcel_Chart_DataSeriesValues('Number', 'Project_By_Cancer_Type!$B$2:$B$'.($totalRow+1), NULL, $totalRow),
	);
	$series3 = new PHPExcel_Chart_DataSeries(
	  PHPExcel_Chart_DataSeries::TYPE_BARCHART,       // plotType
	  PHPExcel_Chart_DataSeries::GROUPING_STANDARD,     // plotGrouping
	  range(0, count($dataSeriesValues3)-1),          // plotOrder
	  $dataseriesLabels3,                   // plotLabel
	  $xAxisTickValues3,                    // plotCategory
	  $dataSeriesValues3                    // plotValues
	);
	$layout3 = new PHPExcel_Chart_Layout();
	$layout3->setShowVal(TRUE);
	$plotarea3 = new PHPExcel_Chart_PlotArea($layout3, array($series3));
	$legend3 = new PHPExcel_Chart_Legend(PHPExcel_Chart_Legend::POSITION_RIGHT, NULL, false);
	$title3 = new PHPExcel_Chart_Title('Projects By Cancer Type');
	$chart3 = new PHPExcel_Chart(
	  'chart3',   // name
	  $title3,    // title
	  $legend3,   // legend
	  $plotarea3,   // plotArea
	  true,     // plotVisibleOnly
	  0,        // displayBlanksAs
	  NULL,     // xAxisLabel
	  NULL      // yAxisLabel   - Pie charts don't have a Y-Axis
	);
	$chart3->setTopLeftPosition('D2');
	$chart3->setBottomRightPosition('Q26');
	$objPHPExcel->getActiveSheet()->addChart($chart3);

	//create second sheet for Projects By Type
	$totalRow = 0;
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectTypeStatsBySearchID @SearchID=:search_id_name,  @ResultCount=:result_count");
	$stmt->bindParam(':search_id_name', $sid);
	$stmt->bindParam(':result_count', $result_count, PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT, 1000);

	if ($stmt->execute()) {
		// Add new sheet
		$objWorkSheet = $objPHPExcel->createSheet();
	    $i = 2;
		// Add some data
		$objPHPExcel->setActiveSheetIndex(3)
		            ->setCellValue('A1', 'Project Type')
		            ->setCellValue('B1', 'Count');
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			$objPHPExcel->setActiveSheetIndex(3)
		    	        ->setCellValue('A'.$i, $row['ProjectType'])
		    	        ->setCellValue('B'.$i, $row['Count']);
			$i = $i + 1;
			$totalRow = $totalRow + 1;
		}

		$result = "succeed";
	} else {
		$result = "failed to query server";
	}
    $objPHPExcel->getActiveSheet()->setTitle('Project_By_Type');
    $objPHPExcel->setActiveSheetIndex(3);
	$dataseriesLabels4 = array(
		new PHPExcel_Chart_DataSeriesValues('String', 'Project_By_Type!$B$1', NULL, 1),
	);
	$xAxisTickValues4 = array(
	  new PHPExcel_Chart_DataSeriesValues('String', 'Project_By_Type!$A$2:$A$'.($totalRow+1), NULL, $totalRow),
	);
    $dataSeriesValues4 = array(
	  new PHPExcel_Chart_DataSeriesValues('Number', 'Project_By_Type!$B$2:$B$'.($totalRow+1), NULL, $totalRow),
	);
	$series4 = new PHPExcel_Chart_DataSeries(
	  PHPExcel_Chart_DataSeries::TYPE_BARCHART,       // plotType
	  PHPExcel_Chart_DataSeries::GROUPING_STANDARD,     // plotGrouping
	  range(0, count($dataSeriesValues4)-1),          // plotOrder
	  $dataseriesLabels4,                   // plotLabel
	  $xAxisTickValues4,                    // plotCategory
	  $dataSeriesValues4                    // plotValues
	);
	$layout4 = new PHPExcel_Chart_Layout();
	$layout4->setShowVal(TRUE);
	$plotarea4 = new PHPExcel_Chart_PlotArea($layout4, array($series4));
	$legend4 = new PHPExcel_Chart_Legend(PHPExcel_Chart_Legend::POSITION_RIGHT, NULL, false);
	$title4 = new PHPExcel_Chart_Title('Projects By Type');
	$chart4 = new PHPExcel_Chart(
	  'chart4',   // name
	  $title4,    // title
	  $legend4,   // legend
	  $plotarea4,   // plotArea
	  true,     // plotVisibleOnly
	  0,        // displayBlanksAs
	  NULL,     // xAxisLabel
	  NULL      // yAxisLabel   - Pie charts don't have a Y-Axis
	);
	$chart4->setTopLeftPosition('D2');
	$chart4->setBottomRightPosition('Q26');
	$objPHPExcel->getActiveSheet()->addChart($chart4);

	if($isPublic == false){
		//create second sheet for Projects By Year
		$totalRow = 0;
		$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectAwardStatsBySearchID @SearchID=:search_id_name, @Year=:search_year, @Total=:result_count");
		$stmt->bindParam(':search_id_name', $sid);
		$stmt->bindParam(':search_year', $year);
		$stmt->bindParam(':result_count', $result_count, PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT, 1000);

		if ($stmt->execute()) {
			// Add new sheet
			$objWorkSheet = $objPHPExcel->createSheet();
			$i = 2;
			// Add some data
			$objPHPExcel->setActiveSheetIndex(4)
						->setCellValue('A1', 'Calendar Year')
						->setCellValue('B1', 'Funding Amount (USD)');
			while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
				$objPHPExcel->setActiveSheetIndex(4)
							->setCellValue('A'.$i, $row['Year'])
							->setCellValue('B'.$i, $row['amount']);
				$objPHPExcel->getActiveSheet()->getStyle('B'.$i)->getNumberFormat()->setFormatCode("#,##0.00");
				$i = $i + 1;
				$totalRow = $totalRow + 1;
			}
			$result = "succeed";
		} else {
			$result = "failed to query server";
		}

		$objPHPExcel->getActiveSheet()->setTitle('Project_Funding_by_Year');
		$objPHPExcel->setActiveSheetIndex(4);
		$dataseriesLabels5 = array(
			new PHPExcel_Chart_DataSeriesValues('String', 'Project_Funding_by_Year!$B$1', NULL, 1),
		);
		$xAxisTickValues5 = array(
		  new PHPExcel_Chart_DataSeriesValues('String', 'Project_Funding_by_Year!$A$2:$A$'.($totalRow+1), NULL, $totalRow),
		);
		$dataSeriesValues5 = array(
		  new PHPExcel_Chart_DataSeriesValues('Number', 'Project_Funding_by_Year!$B$2:$B$'.($totalRow+1), NULL, $totalRow),
		);
		$series5 = new PHPExcel_Chart_DataSeries(
		  PHPExcel_Chart_DataSeries::TYPE_LINECHART,       // plotType
		  PHPExcel_Chart_DataSeries::GROUPING_STANDARD,     // plotGrouping
		  range(0, count($dataSeriesValues5)-1),          // plotOrder
		  $dataseriesLabels5,                   // plotLabel
		  $xAxisTickValues5,                    // plotCategory
		  $dataSeriesValues5                    // plotValues
		);
		$layout5 = new PHPExcel_Chart_Layout();
		$layout5->setShowVal(TRUE);
		$plotarea5 = new PHPExcel_Chart_PlotArea($layout5, array($series5));
		$legend5 = new PHPExcel_Chart_Legend(PHPExcel_Chart_Legend::POSITION_RIGHT, NULL, false);
		$title5 = new PHPExcel_Chart_Title('Project Funding by Year');
		$chart5 = new PHPExcel_Chart(
		  'chart5',   // name
		  $title5,    // title
		  $legend5,   // legend
		  $plotarea5,   // plotArea
		  true,     // plotVisibleOnly
		  0,        // displayBlanksAs
		  NULL,     // xAxisLabel
		  NULL      // yAxisLabel   - Pie charts don't have a Y-Axis
		);
		$chart5->setTopLeftPosition('D2');
		$chart5->setBottomRightPosition('Q26');
		$objPHPExcel->getActiveSheet()->addChart($chart5);
	}

 	// Set active sheet index to the first sheet, so Excel opens this as the first sheet
	$objPHPExcel->setActiveSheetIndex(0);

	// Save Excel 2007 file
	$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
	$objWriter->setIncludeCharts(TRUE);
	$objWriter->save($filelocation.$filename);

	$conn=null;

    return $result;
  }

   public function exportResultsSinglePartner(){
    $sid = $_SESSION['database_search_id'];
    //$sid = 4;

	$result = "Complete Exporting Single Results in Partner Site";
	$config = self::getConfig();
 	$filelocation = $config['file_location'];
 	$downloadlocation = self::getBaseUrl() .  $config['download_location'];
    $filenameExport  = 'ICRPExportPartnerSingle'.$sid.'.xlsx';

	$shouldUseInlineStrings = true;
	$shouldCreateSheetsAutomatically = true;

	/** @var \Box\Spout\Writer\XLSX\Writer $writer */
	$writer = WriterFactory::create(Type::XLSX);
	$writer->setShouldUseInlineStrings($shouldUseInlineStrings);
	$writer->setShouldCreateNewSheetsAutomatically($shouldCreateSheetsAutomatically);
	$writer->openToFile($filelocation . $filenameExport);

  	 try {
	   $conn = self::getConnection();
  	 } catch (Exception $exc) {
  	   return "Could not create db connection";
  	 }

	$withAbstract = false;
	$result = self::createExportSingleSheet($conn, $writer, $sid, $withAbstract);
    $result = self::createCriteriaSheet($conn, $writer, $sid);
	
    $writer->close();
    $conn = null;

	return self::addCorsHeaders(new JSONResponse($downloadlocation.$filenameExport));
  }

  private function createExportSingleSheet($conn, $writer, $sid, $withAbstract){
    $result = "";
    $style = (new StyleBuilder())
  	 		  ->setShouldWrapText(false)
  	 		  ->build();

    $url = self::getBaseUrl();
	$viewLink = $url . "project/";
	$result_count = NULL;
	

	$stmt = "";
	if($withAbstract == true){
		$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectExportsSingleBySearchID @SearchID=:search_id_name, @SiteURL=:url, @IncludeAbstract=1");
	}else{
		$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectExportsSingleBySearchID @SearchID=:search_id_name, @SiteURL=:url");
	}
	$stmt->bindParam(':search_id_name', $sid);
	$stmt->bindParam(':url', $viewLink);
	if ($stmt->execute()) {
		$rowData = Array();
		$colName = Array();
		foreach(range(0, $stmt->columnCount() - 1) as $column_index)
		{
		  $meta = $stmt->getColumnMeta($column_index);
		  $colName[] = $meta['name'];
		}
		$arrayLength = sizeof($colName);
		for($i = 0; $i < $arrayLength; $i++){
			$rowData[$i] = $colName[$i];
		}
		$writer->addRowsWithStyle([$rowData], $style);

		while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
			$rowData = Array();
			for($i = 0; $i < $arrayLength; $i++){
				$value = $row[$colName[$i]];
				if(is_numeric($value)){
					$value = $value + 0;
				}else{
					$value = (string)$value;
				}
				$rowData[$i] = $value;
			}	
			$writer->addRowsWithStyle([$rowData], $style);
		}
	}
	$writer->getCurrentSheet()->setName('Search Result');

	return $result;
  }

   public function exportAbstractSinglePartner(){
    $sid = $_SESSION['database_search_id'];
    //$sid = 4;

	$result = "Complete Exporting Single With abstract Results in Partner Site";
	$config = self::getConfig();
 	$filelocation = $config['file_location'];
 	$downloadlocation = self::getBaseUrl() .  $config['download_location'];
    $filenameExport  = 'ICRPExportPartnerSingleAbstract'.$sid.'.xlsx';

	$shouldUseInlineStrings = true;
	$shouldCreateSheetsAutomatically = true;

	/** @var \Box\Spout\Writer\XLSX\Writer $writer */
	$writer = WriterFactory::create(Type::XLSX);
	$writer->setShouldUseInlineStrings($shouldUseInlineStrings);
	$writer->setShouldCreateNewSheetsAutomatically($shouldCreateSheetsAutomatically);
	$writer->openToFile($filelocation . $filenameExport);

  	 try {
	   $conn = self::getConnection();
  	 } catch (Exception $exc) {
  	   return "Could not create db connection";
  	 }
	$withAbstract = true;
	$result = self::createExportSingleSheet($conn, $writer, $sid, $withAbstract);
    $result = self::createCriteriaSheet($conn, $writer, $sid);

    $writer->close();
    $conn = null;

	return self::addCorsHeaders(new JSONResponse($downloadlocation.$filenameExport));
  }

  public function exportLookupTable(){

	$result = "Complete Exporting Lookup Table";
	$config = self::getConfig();
 	$filelocation = $config['file_location'];
 	$downloadlocation = self::getBaseUrl() .  $config['download_location'];
    $filenameExport  = 'ICRPExportLookupTable'.'.xlsx';

	$shouldUseInlineStrings = true;
	$shouldCreateSheetsAutomatically = true;

	/** @var \Box\Spout\Writer\XLSX\Writer $writer */
	$writer = WriterFactory::create(Type::XLSX);
	$writer->setShouldUseInlineStrings($shouldUseInlineStrings);
	$writer->setShouldCreateNewSheetsAutomatically($shouldCreateSheetsAutomatically);
	$writer->openToFile($filelocation . $filenameExport);

  	 try {
	   $conn = self::getConnection();
  	 } catch (Exception $exc) {
  	   return "Could not create db connection";
  	 }
	$sheetIndex = 0;
	$type = "cso";
	$result = self::createExportLookupSheet($conn, $writer, $sheetIndex, $type);
	$sheetIndex = 1;
	$type = "cancer";
	$result = self::createExportLookupSheet($conn, $writer, $sheetIndex, $type);
	$sheetIndex = 2;
	$type = "country";
	$result = self::createExportLookupSheet($conn, $writer, $sheetIndex, $type);
	$sheetIndex = 3;
	$type = "currency";
	$result = self::createExportLookupSheet($conn, $writer, $sheetIndex, $type);
	$sheetIndex = 4;
	$type = "Institution";
	$result = self::createExportLookupSheet($conn, $writer, $sheetIndex, $type);

  	$writer->close();
    $conn = null;

    header('Content-Description: File Transfer');
    header('Content-Type: application/vnd.ms-excel');
    header('Content-Disposition: attachment; filename="'.basename($filenameExport).'"');
    header('Expires: 0');
    header('Cache-Control: must-revalidate');
    header('Pragma: public');
    readfile($filelocation.$filenameExport);
    exit;

    return new BinaryFileResponse($downloadlocation.$filenameExport, 200, $headers);
  }

  private function createExportLookupSheet($conn, $writer, $sheetIndex, $type){
  	$result = "succeed";
  	$style = (new StyleBuilder())
  	 		  ->setShouldWrapText(false)
  	 		  ->build();

  	//based on sheetIndex to determine if file needs a new tab or not
  	if($sheetIndex != 0){
  		$writer->addNewSheetAndMakeItCurrent();
  	}
  	//cso is the first sheet, do not need to create a new sheet
  	if($type == 'cso'){
  		$stmt = $conn->prepare("SET NOCOUNT ON; exec GetCSOLookup");
  	}else if($type == 'cancer'){
  	 	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetCancerTypeLookUp");
  	}else if($type == 'country'){
		$stmt = $conn->prepare("SET NOCOUNT ON; exec GetCountryCodeLookup");
  	}else if ($type == 'currency'){
		$stmt = $conn->prepare("SET NOCOUNT ON; exec GetCurrencyRateLookup");
  	}else if($type == 'Institution'){
		$stmt = $conn->prepare("SET NOCOUNT ON; exec GetInstitutionLookup");
    }else{
  		$result = "No such category for look up table";
  	    return $result;
  	}
	if ($stmt->execute()) {
		$colName = Array();
		foreach(range(0, $stmt->columnCount() - 1) as $column_index)
		{
		  $meta = $stmt->getColumnMeta($column_index);
		  $colName[] = $meta['name'];
		}
		$writer->addRowsWithStyle([$colName], $style);
		while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
			$rowData = Array();
			for($in = 0; $in < sizeof($colName); $in++){
				$rowData[$in] = $row[$colName[$in]];	
			}
			$writer->addRowsWithStyle([$rowData], $style);
		}
		$result = "succeed";
	}else{
	 	$result = "failed to query server";
	}

	if($type == 'cso'){
  		$writer->getCurrentSheet()->setName('CSO Codes');
  	}else if($type == 'cancer'){
  		$writer->getCurrentSheet()->setName('Disease Site Codes');

  	}else if($type == 'country'){
  		$writer->getCurrentSheet()->setName('Country Codes');

  	}else if ($type == 'currency'){
  		$writer->getCurrentSheet()->setName('Currency Conversions');
	}else if($type == 'Institution'){
		$writer->getCurrentSheet()->setName('Institution');
	}

    return $result;
  }

  public function exportUploadStatus(){

	$result = "Complete Exporting Lookup Table";
	$config = self::getConfig();
 	$filelocation = $config['file_location'];
 	$downloadlocation = self::getBaseUrl() .  $config['download_location'];
    $filenameExport  = 'ICRPExportUploadStatus'.'.xlsx';

	$shouldUseInlineStrings = true;
	$shouldCreateSheetsAutomatically = true;

	/** @var \Box\Spout\Writer\XLSX\Writer $writer */
	$writer = WriterFactory::create(Type::XLSX);
	$writer->setShouldUseInlineStrings($shouldUseInlineStrings);
	$writer->setShouldCreateNewSheetsAutomatically($shouldCreateSheetsAutomatically);
	$writer->openToFile($filelocation . $filenameExport);

  	 try {
	   $conn = self::getConnection();
  	 } catch (Exception $exc) {
  	   return "Could not create db connection";
  	 }

	$result = self::createUploadStatusSheet($conn, $writer);

	$writer->close();
    $conn = null;

    return self::addCorsHeaders(new JSONResponse($downloadlocation.$filenameExport));

  }

  private function createUploadStatusSheet($conn, $writer){
  	$result = "succeed";
  	$style = (new StyleBuilder())
  	 		  ->setShouldWrapText(false)
  	 		  ->build();

	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetDataUploadStatus");
	if ($stmt->execute()) {
		$colName = Array();
		foreach(range(0, $stmt->columnCount() - 1) as $column_index)
		{
		  $meta = $stmt->getColumnMeta($column_index);
		  $colName[] = $meta['name'];
		}
		$writer->addRowsWithStyle([$colName], $style);
		while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
			$rowData = Array();
			for($in = 0; $in < sizeof($colName); $in++){
				$rowData[$in] = $row[$colName[$in]];	
			}
			$writer->addRowsWithStyle([$rowData], $style);
		}
		$result = "succeed";
		$writer->getCurrentSheet()->setName('Data Upload Status Report');
	}else{
		$result = "failed to query server";
	}
  	return $result;
  }

}
?>