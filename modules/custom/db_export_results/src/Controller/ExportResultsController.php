<?php
/**
 * @file
 * Contains \Drupal\db_email_results\Controller\ExportResultsController.
 */
namespace Drupal\db_export_results\Controller;

require 'PHPExcel.php';

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

  	$config = self::getConfig();
    $filelocation = $config['file_location'];
    $downloadlocation = self::getBaseUrl() .  $config['download_location'];
    $filenameExport  = 'ICRPExportPublic'.$sid.'.xlsx';

	 try {
	   $conn = self::getConnection();
  	 } catch (Exception $exc) {
  	   return "Could not create db connection";
  	 }
	$url = self::getBaseUrl();
	$viewLink = $url . "viewProject.cfm?pid=";

	$result = "success";

  	// Create new PHPExcel object
	$objPHPExcel = new PHPExcel();

	// Set document properties
	$objPHPExcel->getProperties()->setCreator("ICRP")
							 	->setLastModifiedBy("ICRP")
							 	->setTitle("ICRP Export Data for Public")
							 	->setSubject("ICRP Export Data")
							 	->setDescription("This file contains all public data based on the user provided search criteria")
							 	->setKeywords("ICRP Data")
							 	->setCategory("Search Result File");
	$sheetIndex = 0;
	$result = self::createExportPublicSheet($conn, $objPHPExcel, $sid, $sheetIndex);
	$sheetIndex = 1;
	$result = self::createCriteriaSheet($conn, $objPHPExcel, $sid, $sheetIndex);

	$objPHPExcel->setActiveSheetIndex(0);
	// Save Excel 2007 file
	$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
	$objWriter->save($filelocation.$filenameExport);
    $conn = null;

	return self::addCorsHeaders(new JSONResponse($downloadlocation.$filenameExport));
  }

  private function createExportPublicSheet($conn, &$objPHPExcel, $sid, $sheetIndex){
    $result = "";
	$result_count = NULL;
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectsBySearchID @SearchID=:search_id_name, @ResultCount=:result_count");
	$stmt->bindParam(':search_id_name', $sid);
	$stmt->bindParam(':result_count', $result_count, PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT, 1000);
	if ($stmt->execute()) {
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
		            ->setCellValue('A1', 'Title')
		            ->setCellValue('B1', 'PI First Name')
		            ->setCellValue('C1', 'PI Last Name')
		            ->setCellValue('D1', 'Institution')
		            ->setCellValue('E1', 'City')
		            ->setCellValue('F1', 'State')
		            ->setCellValue('G1', 'Country')
		            ->setCellValue('H1', 'Funding Organization')
		            ->setCellValue('I1', 'Award Code')
		            ->setCellValue('J1', 'View in ICRP');
		$i = 2;
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue('A'.$i, $row['Title'])
						->setCellValue('B'.$i, $row['piLastName'])
						->setCellValue('C'.$i, $row['piFirstName'])
						->setCellValue('D'.$i, $row['institution'])
						->setCellValue('E'.$i, $row['City'])
						->setCellValue('F'.$i, $row['State'])
						->setCellValue('G'.$i, $row['country'])
						->setCellValue('H'.$i, $row['FundingOrg'])
						->setCellValue('I'.$i, $row['AwardCode'])
						->setCellValue('J'.$i, $viewLink . $row['ProjectID']);
			$i = $i + 1;
		}
		$result = "succeed";
	} else {
		$result = "failed to query server";
	}
    $objPHPExcel->getActiveSheet()->setTitle('Export Data');

	return $result;
  }

  private function createCriteriaSheet($conn, &$objPHPExcel, $sid, $sheetIndex){
    $result = "";
 	$labels = Array("Term Search Type", "Terms", "Institution", "PI Last Name", "PI First Name", "PI ORC ID", "Award Code", "Years" , "City", "State", "Country", "Funding Organization", "Cancer Type", "Project Type", "CSO", "Search By User Name");

	 //add a new sheet
	$objWorkSheet = $objPHPExcel->createSheet();
	$stmt = $conn -> prepare("SELECT * from SearchCriteria where SearchCriteriaID = :search_id");
	$stmt->bindParam(':search_id', $sid);
	if ($stmt->execute()){
	   $objPHPExcel->setActiveSheetIndex($sheetIndex)
	  			   ->setCellValue('A1', "International Cancer Research Partnership - " . self::getBaseUrl() . "\n");
	   $row = $stmt->fetch(PDO::FETCH_NUM);
	   $date = date("d/m/Y H:i:s", strtotime($row[17]));
	   $objPHPExcel->setActiveSheetIndex($sheetIndex)
	  			   ->setCellValue('A2', "Created: " . $date);
	   $objPHPExcel->setActiveSheetIndex($sheetIndex)
	    		   ->setCellValue('A3',"Search Criteria:");
	   $location = "B";
	   $index = 3;
	   for ($i = 0; $i < 16; $i++){
	        if($row[$i+1] != null){
				$location++;
				$objPHPExcel->setActiveSheetIndex($sheetIndex)
							->setCellValue($location.$index, $labels[$i] . " : " . $row[$i+1]);
			}
	   }
	   $result = "succeed";
	} else {
	   $result = "failed to query server";
    }
	$objPHPExcel->getActiveSheet()->setTitle('Search Criteria');

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

  	// Create new PHPExcel object
	$objPHPExcel = new PHPExcel();

	// Set document properties
	$objPHPExcel->getProperties()->setCreator("ICRP")
							 	->setLastModifiedBy("ICRP")
							 	->setTitle("ICRP Export Data for Partner")
							 	->setSubject("ICRP Export Data")
							 	->setDescription("This file contains all Partner Site data based on the user provided search criteria")
							 	->setKeywords("ICRP Data")
							 	->setCategory("Search Result File");


    //create export data for partner site
    $sheetIndex = 0;
    $withAbstract = false;
    $result = self::createExportDataSheetforPartner($conn, $objPHPExcel, $sid, $sheetIndex, $withAbstract);
    $sheetIndex = 1;
    $result = self::createCriteriaSheet($conn, $objPHPExcel, $sid, $sheetIndex);
    $sheetIndex = 2;
    $result = self::createCSOSheet($conn, $objPHPExcel, $sid, $sheetIndex);
    $sheetIndex = 3;
    $result = self::createSiteSheet($conn, $objPHPExcel, $sid, $sheetIndex);


	$objPHPExcel->setActiveSheetIndex(0);
	// Save Excel 2007 file
	$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
	$objWriter->save($filelocation.$filenameExport);
    $conn = null;

	return self::addCorsHeaders(new JSONResponse($downloadlocation . $filenameExport));
  }

  private function createSiteSheet($conn, &$objPHPExcel, $sid, $sheetIndex){
  	$result = "";
     //add a new sheet
   	$objWorkSheet = $objPHPExcel->createSheet();
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectCancerTypesBySearchID @SearchID=:search_id_name");
	$stmt->bindParam(':search_id_name', $sid);

	if ($stmt->execute()) {
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue('A1', "ICRP PROJECT ID")
					->setCellValue('B1', "Cancer Type")
					->setCellValue('C1', "Site Relevance");
		$i = 2;
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue('A'.$i, $row['ProjectID'])
						->setCellValue('B'.$i, $row['CancerType'])
						->setCellValue('C'.$i, $row['Relevance']);
			$i++;
		}
		$result = "succeed";
	} else {
		$result = "failed to query server";
	}
	$objPHPExcel->getActiveSheet()->setTitle('Project By Site');

    return $result;
  }

  private function createCSOSheet($conn, &$objPHPExcel, $sid, $sheetIndex){
 	$result = "";
 	//add a new sheet
   	$objWorkSheet = $objPHPExcel->createSheet();
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectCSOsBySearchID @SearchID=:search_id_name");
	$stmt->bindParam(':search_id_name', $sid);
	if ($stmt->execute()) {
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue('A1',"ICRP PROJECT ID")
					->setCellValue('B1', "Code")
					->setCellValue('C1', "CSO Relevance");
		$i = 2;
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			 $objPHPExcel->setActiveSheetIndex($sheetIndex)
			 			 ->setCellValue('A'.$i, $row['ProjectID'])
			 			 ->setCellValue('B'.$i, $row['CSOCode'])
			 			 ->setCellValue('C'.$i, $row['CSORelevance']);
			 $i++;
		}
		$result = "succeed";
	} else {
		$result = "failed to query server";
	}
	$objPHPExcel->getActiveSheet()->setTitle('Project By CSO');

	return $result;
  }

  private function createExportDataSheetforPartner($conn, &$objPHPExcel, $sid, $sheetIndex, $withAbstract){
	$result = "success";

	$url = self::getBaseUrl();
	$viewLink = $url . "project/";
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectExportsBySearchID @SearchID=:search_id_name, @SiteURL=:site_url");
	$stmt->bindParam(':search_id_name', $sid);
	$stmt->bindParam(':site_url', $viewLink);
	$currentYear = Date('Y') + 1;

	if ($stmt->execute()) {
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue('A1', "ICRP PROJECT ID")
					->setCellValue('B1', "Award Code")
					->setCellValue('C1', "Award Title")
					->setCellValue('D1', "Award Type")
					->setCellValue('E1', "Source ID")
					->setCellValue('F1', "ALT ID")
					->setCellValue('G1', "Award Start Date")
					->setCellValue('H1', "Award End Date")
					->setCellValue('I1', "Budget Start Date")
					->setCellValue('J1', "Budget End Date")
					->setCellValue('K1', "Award Funding")
					->setCellValue('L1', "Funding Indicator");
		$location = "L";
		$location2 = "A";
		$location3 = "A";
		$realLocation = "";
		for($i = 2000; $i < $currentYear; $i++){
			if($location != 'Z'){
				$location++;
				$realLocation = $location;
			}else{
				$realLocation = "A".$location2;
				$location2++;
				if($location2 == "Z"){
					$location2 = "A";
					$location3++;
				}
			}
			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($realLocation."1", $i);
		}
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue($location3.$location2++."1", "Currency");
		if($location2 == "Z"){
			$location2 = "A";
			$location3++;
		}
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue($location3.$location2++."1", "To Currency");
		if($location2 == "Z"){
			$location2 = "A";
			$location3++;
		}
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue($location3.$location2++."1", "To Currency Rate");
		if($location2 == "Z"){
			$location2 = "A";
			$location3++;
		}
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue($location3.$location2++."1", "Funding Mechanism");
		if($location2 == "Z"){
			$location2 = "A";
			$location3++;
		}
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue($location3.$location2++."1", "Funding Mechanism Code");
		if($location2 == "Z"){
			$location2 = "A";
			$location3++;
		}
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue($location3.$location2++."1", "Funding Org");
		if($location2 == "Z"){
			$location2 = "A";
			$location3++;
		}
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue($location3.$location2++."1", "Funding Div");
		if($location2 == "Z"){
			$location2 = "A";
			$location3++;
		}
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue($location3.$location2++."1", "Funding Div Abbr");
		if($location2 == "Z"){
			$location2 = "A";
			$location3++;
		}
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue($location3.$location2++."1", "Funding Contact");
		if($location2 == "Z"){
			$location2 = "A";
			$location3++;
		}
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue($location3.$location2++."1", "PI First Name");
		if($location2 == "Z"){
			$location2 = "A";
			$location3++;
		}
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue($location3.$location2++."1", "PI Last Name");
		if($location2 == "Z"){
			$location2 = "A";
			$location3++;
		}
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue($location3.$location2++."1", "PI ORC ID");
		if($location2 == "Z"){
			$location2 = "A";
			$location3++;
		}
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue($location3.$location2++."1", "Instutition");
		if($location2 == "Z"){
			$location2 = "A";
			$location3++;
		}
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue($location3.$location2++."1", "City");
		if($location2 == "Z"){
			$location2 = "A";
			$location3++;
		}
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue($location3.$location2++."1", "State");
		if($location2 == "Z"){
			$location2 = "A";
			$location3++;
		}
		$objPHPExcel->setActiveSheetIndex($sheetIndex)
					->setCellValue($location3.$location2++."1", "Country");
		if($location2 == "Z"){
			$location2 = "A";
			$location3++;
		}
		if($withAbstract){
			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location3.$location2++."1", "Tech Abstract");
		}else{
			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location3.$location2++."1", "View In ICRP");
		}
		$in = 2;
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			$location = "L";
			$location2 = "A";
			$location3 = "A";
			$realLocation = "";
			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue('A'.$in, $row['ProjectID'])
						->setCellValue('B'.$in, $row['AwardCode'])
						->setCellValue('C'.$in, $row['AwardTitle'])
						->setCellValue('D'.$in, $row['AwardType'])
						->setCellValue('E'.$in, $row['Source_ID'])
						->setCellValue('F'.$in, $row['AltAwardCode'])
						->setCellValue('G'.$in, $row['AwardStartDate'])
						->setCellValue('H'.$in, $row['AwardEndDate'])
						->setCellValue('I'.$in, $row['BudgetStartDate'])
						->setCellValue('J'.$in, $row['BudgetEndDate'])
						->setCellValue('K'.$in, $row['AwardAmount'])
						->setCellValue('L'.$in, $row['FundingIndicator']);
			for($i = 2000; $i < $currentYear; $i++){
				if($location != 'Z'){
					$location++;
					$realLocation = $location;
				}else{
					$realLocation = $location3.$location2;
					$location2++;
					if($location2 == "Z"){
						$location2 = "A";
						$location3++;
					}
				}
				$value = $row[$i];
				$objPHPExcel->setActiveSheetIndex($sheetIndex)
							->setCellValue($realLocation.$in, $value);
			}
			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location3.$location2++.$in, $row['Currency']);
			if($location2 == "Z"){
				$location2 = "A";
				$location3++;
			}
			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location3.$location2++.$in, "");
			if($location2 == "Z"){
				$location2 = "A";
				$location3++;
			}

			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location3.$location2++.$in, "");
			if($location2 == "Z"){
				$location2 = "A";
				$location3++;
			}

			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location3.$location2++.$in, $row['FundingMechanism']);
			if($location2 == "Z"){
				$location2 = "A";
				$location3++;
			}

			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location3.$location2++.$in, $row['FundingMechanismCode']);
			if($location2 == "Z"){
				$location2 = "A";
				$location3++;
			}

			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location3.$location2++.$in, $row['FundingOrg']);
			if($location2 == "Z"){
				$location2 = "A";
				$location3++;
			}

			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location3.$location2++.$in, $row['FundingDiv']);
			if($location2 == "Z"){
				$location2 = "A";
				$location3++;
			}

			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location3.$location2++.$in, $row['FundingDivAbbr']);
			if($location2 == "Z"){
				$location2 = "A";
				$location3++;
			}

			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location3.$location2++.$in, $row['FundingContact']);
			if($location2 == "Z"){
				$location2 = "A";
				$location3++;
			}

			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location3.$location2++.$in, $row['piLastName']);
			if($location2 == "Z"){
				$location2 = "A";
				$location3++;
			}

			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location3.$location2++.$in, $row['piFirstName']);
			if($location2 == "Z"){
				$location2 = "A";
				$location3++;
			}

			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location3.$location2++.$in, $row['piORCID']);
			if($location2 == "Z"){
				$location2 = "A";
				$location3++;
			}

			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location3.$location2++.$in, $row['Institution']);
			if($location2 == "Z"){
				$location2 = "A";
				$location3++;
			}

			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location3.$location2++.$in, $row['City']);
			if($location2 == "Z"){
				$location2 = "A";
				$location3++;
			}

			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location3.$location2++.$in, $row['State']);
			if($location2 == "Z"){
				$location2 = "A";
				$location3++;
			}

			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location3.$location2++.$in, $row['Country']);
			if($location2 == "Z"){
				$location2 = "A";
				$location3++;
			}
			if($withAbstract){
				$objPHPExcel->setActiveSheetIndex($sheetIndex)
							->setCellValue($location3.$location2++.$in, $row['TechAbstract']);
			}else{
				$objPHPExcel->setActiveSheetIndex($sheetIndex)
							->setCellValue($location3.$location2++.$in, $row['icrpURL']);
			}
			$in++;
		}
		$result = "succeed";
	} else {
		$result = "failed to query server";
	}
    $objPHPExcel->getActiveSheet()->setTitle('Export Data');

	return $result;
  }

  public function exportResultsWithAbstractPartner(){
    $sid = $_SESSION['database_search_id'];
    //$sid = 4;

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
	// Create new PHPExcel object
	$objPHPExcel = new PHPExcel();

	// Set document properties
	$objPHPExcel->getProperties()->setCreator("ICRP")
							 	->setLastModifiedBy("ICRP")
							 	->setTitle("ICRP Export Data for Partner")
							 	->setSubject("ICRP Export Data")
							 	->setDescription("This file contains all Partner Site data based on the user provided search criteria")
							 	->setKeywords("ICRP Data")
							 	->setCategory("Search Result File");
	$sheetIndex = 0;
	$withAbstract = true;
	self::createExportDataSheetforPartner($conn, $objPHPExcel, $sid, $sheetIndex, $withAbstract);

 	$sheetIndex = 1;
 	self::createCriteriaSheet($conn, $objPHPExcel, $sid, $sheetIndex);

 	$sheetIndex = 2;
 	self::createCSOSheet($conn, $objPHPExcel, $sid, $sheetIndex);

 	$sheetIndex = 3;
 	self::createSiteSheet($conn, $objPHPExcel, $sid, $sheetIndex);


	$objPHPExcel->setActiveSheetIndex(0);
	// Save Excel 2007 file
	$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
	$objWriter->save($filelocation.$filenameExport);
    $conn = null;

	return self::addCorsHeaders(new JSONResponse($downloadlocation . $filenameExport));
  }

   public function exportResultsWithGraphsPartner(){
	$result = "Complete Exporting Results with Graphs in Partner Site";
	$sid = $_SESSION['database_search_id'];
	//$sid = 4;

	$result = "Complete Exporting Results in Partner Site";
	$config = self::getConfig();
	$filelocation = $config['file_location'];
	$downloadlocation = self::getBaseUrl() .  $config['download_location'];
	$filenameExport  = 'ICRPExportGraphPartner'.$sid.'.xlsx';

	$result = self::createExcelFileWithGraph($filelocation, $filenameExport, $sid);

	return self::addCorsHeaders(new JSONResponse($downloadlocation.$filenameExport));
  }

  private function createExcelFileWithGraph($filelocation, $filename, $sid){
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
		            ->setCellValue('B1', 'Project Count');
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			$objPHPExcel->setActiveSheetIndex(1)
		    	        ->setCellValue('A'.$i, $row['categoryName'])
		    	        ->setCellValue('B'.$i, $row['Count']);
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
		            ->setCellValue('B1', 'Project Count');
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			$objPHPExcel->setActiveSheetIndex(2)
		    	        ->setCellValue('A'.$i, $row['CancerType'])
		    	        ->setCellValue('B'.$i, $row['Count']);
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
		    	        ->setCellValue('B'.$i, $row['Project Count']);
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

	//create second sheet for Projects By Year
	$bit = 1;
	$totalRow = 0;
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectAwardStatsBySearchID @SearchID=:search_id_name, @isPartner=:is_partner, @Total=:result_count");
	$stmt->bindParam(':search_id_name', $sid);
	$stmt->bindParam(':is_partner', $bit, PDO::PARAM_INT);
	$stmt->bindParam(':result_count', $result_count, PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT, 1000);

	if ($stmt->execute()) {
		// Add new sheet
		$objWorkSheet = $objPHPExcel->createSheet();
	    $i = 2;
		// Add some data
		if($bit == 0){
			$objPHPExcel->setActiveSheetIndex(4)
						->setCellValue('A1', 'Calendar Year')
						->setCellValue('B1', 'Project Count');
			while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
				$objPHPExcel->setActiveSheetIndex(4)
							->setCellValue('A'.$i, $row['Year'])
							->setCellValue('B'.$i, $row['Count']);
				$i = $i + 1;
				$totalRow = $totalRow + 1;
			}
		}else if($bit == 1){
			$objPHPExcel->setActiveSheetIndex(4)
						->setCellValue('A1', 'Calendar Year')
						->setCellValue('B1', 'Amount');
			while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
				$objPHPExcel->setActiveSheetIndex(4)
							->setCellValue('A'.$i, $row['Year'])
							->setCellValue('B'.$i, $row['Amount']);
				$objPHPExcel->getActiveSheet()->getStyle('B'.$i)->getNumberFormat()->setFormatCode("#,##0.00");
				$i = $i + 1;
				$totalRow = $totalRow + 1;
			}
		}
		$result = "succeed";
	} else {
		$result = "failed to query server";
	}
    $objPHPExcel->getActiveSheet()->setTitle('Award_Amount_By_Year');
    $objPHPExcel->setActiveSheetIndex(4);
	$dataseriesLabels5 = array(
		new PHPExcel_Chart_DataSeriesValues('String', 'Award_Amount_By_Year!$B$1', NULL, 1),
	);
	$xAxisTickValues5 = array(
	  new PHPExcel_Chart_DataSeriesValues('String', 'Award_Amount_By_Year!$A$2:$A$'.($totalRow+1), NULL, $totalRow),
	);
    $dataSeriesValues5 = array(
	  new PHPExcel_Chart_DataSeriesValues('Number', 'Award_Amount_By_Year!$B$2:$B$'.($totalRow+1), NULL, $totalRow),
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
	$title5 = new PHPExcel_Chart_Title('Award Amount By Year');
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


 	// Set active sheet index to the first sheet, so Excel opens this as the first sheet
	$objPHPExcel->setActiveSheetIndex(0);

	// Save Excel 2007 file
	$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
	$objWriter->setIncludeCharts(TRUE);
	$objWriter->save($filelocation.$filename);

	$conn=null;

    return $result;
  }
}
?>