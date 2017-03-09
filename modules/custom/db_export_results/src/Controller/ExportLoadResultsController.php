<?php
/**
 * @file
 * Contains \Drupal\db_email_results\Controller\ExportResultsController.
 */
namespace Drupal\db_export_results\Controller;

require_once 'PHPExcel.php';

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
ini_set('memory_limit','2048M');

define('EOL',(PHP_SAPI == 'cli') ? PHP_EOL : '<br />');

class ExportLoadResultsController extends ControllerBase {

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
    $result = self::createCSOSheet($conn, $objPHPExcel, $sid, $sheetIndex, $isPublic);
    $sheetIndex = 2;
    $result = self::createSiteSheet($conn, $objPHPExcel, $sid, $sheetIndex, $isPublic);
    $sheetIndex = 3;
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
    $url = self::getBaseUrl();
	$viewLink = $url . "project/";
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
						->setCellValue('B'.$i, $row['piFirstName'])
						->setCellValue('C'.$i, $row['piLastName'])
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
    $objPHPExcel->getActiveSheet()->setTitle('Search Result');

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
  	$database_config = \Drupal::config('icrp_load_database');
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
    $isPublic = false;
    $result = self::createExportDataSheetforPartner($conn, $objPHPExcel, $sid, $sheetIndex, $withAbstract);
    $sheetIndex = 1;
    $result = self::createCSOSheet($conn, $objPHPExcel, $sid, $sheetIndex, $isPublic);
    $sheetIndex = 2;
    $result = self::createSiteSheet($conn, $objPHPExcel, $sid, $sheetIndex, $isPublic);
     $sheetIndex = 3;
    $result = self::createCriteriaSheet($conn, $objPHPExcel, $sid, $sheetIndex);


	$objPHPExcel->setActiveSheetIndex(0);
	// Save Excel 2007 file
	$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
	$objWriter->save($filelocation.$filenameExport);
    $conn = null;

	return self::addCorsHeaders(new JSONResponse($downloadlocation . $filenameExport));
  }

  private function createSiteSheet($conn, &$objPHPExcel, $sid, $sheetIndex, $isPublic){
  	$result = "";
     //add a new sheet
   	$objWorkSheet = $objPHPExcel->createSheet();
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectCancerTypesBySearchID @SearchID=:search_id_name");
	$stmt->bindParam(':search_id_name', $sid);

	if ($stmt->execute()) {
		if($isPublic){
			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue('A1', "ICRP PROJECT ID")
						->setCellValue('B1', "Cancer Type");
		}else{
			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue('A1', "ICRP PROJECT ID")
						->setCellValue('B1', "Cancer Type")
						->setCellValue('C1', "Site Relevance");
		}
		$i = 2;
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			if($isPublic){
				$objPHPExcel->setActiveSheetIndex($sheetIndex)
							->setCellValue('A'.$i, $row['ProjectID'])
							->setCellValue('B'.$i, $row['CancerType']);
			}else{
				$objPHPExcel->setActiveSheetIndex($sheetIndex)
							->setCellValue('A'.$i, $row['ProjectID'])
							->setCellValue('B'.$i, $row['CancerType'])
							->setCellValue('C'.$i, $row['Relevance']);
			}
			$i++;
		}
		$result = "succeed";
	} else {
		$result = "failed to query server";
	}
	$objPHPExcel->getActiveSheet()->setTitle('Project By Cancer Type');

    return $result;
  }

  private function createCSOSheet($conn, &$objPHPExcel, $sid, $sheetIndex, $isPublic){
 	$result = "";
 	//add a new sheet
   	$objWorkSheet = $objPHPExcel->createSheet();
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectCSOsBySearchID @SearchID=:search_id_name");
	$stmt->bindParam(':search_id_name', $sid);
	if ($stmt->execute()) {
		if($isPublic){
			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue('A1',"ICRP PROJECT ID")
						->setCellValue('B1', "Code");
		}else{
			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue('A1',"ICRP PROJECT ID")
						->setCellValue('B1', "Code")
						->setCellValue('C1', "CSO Relevance");
		}
		$i = 2;
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			 if($isPublic){
				 $objPHPExcel->setActiveSheetIndex($sheetIndex)
							 ->setCellValue('A'.$i, $row['ProjectID'])
							 ->setCellValue('B'.$i, $row['CSOCode']);
			 }else{
				 $objPHPExcel->setActiveSheetIndex($sheetIndex)
							 ->setCellValue('A'.$i, $row['ProjectID'])
							 ->setCellValue('B'.$i, $row['CSOCode'])
							 ->setCellValue('C'.$i, $row['CSORelevance']);
			 }
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
				$realLocation = $location3.$location2;
				if($location2 == "Z"){
					$location2 = "A";
					$location3++;
				}else{
					$location2++;
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
					if($location2 == "Z"){
						$location2 = "A";
						$location3++;
					}else{
						$location2++;
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
						->setCellValue($location3.$location2++.$in, $row['piFirstName']);
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
    $objPHPExcel->getActiveSheet()->setTitle('Search Result');

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
 	self::createCSOSheet($conn, $objPHPExcel, $sid, $sheetIndex, $isPublic);

 	$sheetIndex = 2;
 	self::createSiteSheet($conn, $objPHPExcel, $sid, $sheetIndex, $isPublic);

 	$sheetIndex = 3;
 	self::createCriteriaSheet($conn, $objPHPExcel, $sid, $sheetIndex);

	$objPHPExcel->setActiveSheetIndex(0);
	// Save Excel 2007 file
	$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
	$objWriter->save($filelocation.$filenameExport);
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

	$objPHPExcel = new PHPExcel();

  	 try {
	   $conn = self::getConnection();
  	 } catch (Exception $exc) {
  	   return "Could not create db connection";
  	 }

	$sheetIndex = 0;
	$withAbstract = false;
	$result = self::createExportSingleSheet($conn, $objPHPExcel, $sid, $sheetIndex, $withAbstract);
	$sheetIndex = 1;
	$result = self::createCriteriaSheet($conn, $objPHPExcel, $sid, $sheetIndex);

 	// Set active sheet index to the first sheet, so Excel opens this as the first sheet
	$objPHPExcel->setActiveSheetIndex(0);

	// Save Excel 2007 file
	$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
	$objWriter->setIncludeCharts(TRUE);
	$objWriter->save($filelocation.$filenameExport);
    $conn = null;

	return self::addCorsHeaders(new JSONResponse($downloadlocation.$filenameExport));
  }

  private function createExportSingleSheet($conn, &$objPHPExcel, $sid, $sheetIndex, $withAbstract){
    $result = "";
    $url = self::getBaseUrl();
	$viewLink = $url . "project/";
	$result_count = NULL;

	$objPHPExcel->getProperties()->setCreator("ICRP")
							 	 ->setLastModifiedBy("ICRP")
							 	 ->setTitle("ICRP export Single")
							 	 ->setSubject("ICRP export data")
							 	 ->setDescription("Exporting ICRP Single data ")
							 	 ->setKeywords("ICRP signle data")
							 	 ->setCategory("ICRP data");

	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectExportsSingleBySearchID @SearchID=:search_id_name, @SiteURL=:url");
	$stmt->bindParam(':search_id_name', $sid);
	$stmt->bindParam(':url', $viewLink);
	if ($stmt->execute()) {
		$location = "A";
		$location2 = "A";
		$location3 = "A";
		$realLocation = "";
		$index = 1;
		$colName = Array();
		foreach(range(0, $stmt->columnCount() - 1) as $column_index)
		{
		  $meta = $stmt->getColumnMeta($column_index);
		  $colName[] = $meta['name'];
		}

		$arrayLength = sizeof($colName);
		if($withAbstract != true){
			$arrayLength = $arrayLength -1; //remove last column - tech abstract
		}

		for($i = 0; $i < $arrayLength; $i++){
		  if($location != 'Z'){
				$realLocation = $location;
				$location++;
		  }else{
				$realLocation = $location3.$location2;
				if($location2 == "Z"){
					$location2 = "A";
					$location3++;
				}else{
					$location2++;
				}
		  }
		 $objPHPExcel->setActiveSheetIndex($sheetIndex)
		 			 ->setCellValue($realLocation.$index, $colName[$i]);
		}

		$in = 2;
		while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
			$location = "A";
			$location2 = "A";
			$location3 = "A";
			$realLocation = "";
			for($i = 0; $i < $arrayLength; $i++){
			  if($location != 'Z'){
					$realLocation = $location;
					$location++;
			  }else{
					$realLocation = $location3.$location2;
					if($location2 == "Z"){
						$location2 = "A";
						$location3++;
					}else{
						$location2++;
					}
			  }
			  $objPHPExcel->setActiveSheetIndex($sheetIndex)
						  ->setCellValue($realLocation.$in, $row[$colName[$i]]);
			}//end of for
			$in++;
		}
	}
	$objPHPExcel->getActiveSheet()->setTitle('Search Result');

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

	$objPHPExcel = new PHPExcel();
	$objPHPExcel->getProperties()->setCreator("ICRP")
							 	 ->setLastModifiedBy("ICRP")
							 	 ->setTitle("ICRP export Looup Table")
							 	 ->setSubject("ICRP export data")
							 	 ->setDescription("Exporting ICRP Looup Table ")
							 	 ->setKeywords("ICRP Lookup Table data")
							 	 ->setCategory("ICRP data");

  	 try {
	   $conn = self::getConnection();
  	 } catch (Exception $exc) {
  	   return "Could not create db connection";
  	 }

	$sheetIndex = 0;
	$withAbstract = true;
	$result = self::createExportSingleSheet($conn, $objPHPExcel, $sid, $sheetIndex, $withAbstract);
	$sheetIndex = 1;
	$result = self::createCriteriaSheet($conn, $objPHPExcel, $sid, $sheetIndex);

 	// Set active sheet index to the first sheet, so Excel opens this as the first sheet
	$objPHPExcel->setActiveSheetIndex(0);

	// Save Excel 2007 file
	$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
	$objWriter->setIncludeCharts(TRUE);
	$objWriter->save($filelocation.$filenameExport);
    $conn = null;

	return self::addCorsHeaders(new JSONResponse($downloadlocation.$filenameExport));
  }

  public function exportLookupTable(){

	$result = "Complete Exporting Lookup Table";
	$config = self::getConfig();
 	$filelocation = $config['file_location'];
 	$downloadlocation = self::getBaseUrl() .  $config['download_location'];
    $filenameExport  = 'ICRPExportLookupTable'.'.xlsx';

	$objPHPExcel = new PHPExcel();

  	 try {
	   $conn = self::getConnection();
  	 } catch (Exception $exc) {
  	   return "Could not create db connection";
  	 }
	$sheetIndex = 0;
	$type = "cso";
	$result = self::createExportLookupSheet($conn, $objPHPExcel, $sheetIndex, $type);
	$sheetIndex = 1;
	$type = "cancer";
	$result = self::createExportLookupSheet($conn, $objPHPExcel, $sheetIndex, $type);
	$sheetIndex = 2;
	$type = "country";
	$result = self::createExportLookupSheet($conn, $objPHPExcel, $sheetIndex, $type);
	$sheetIndex = 3;
	$type = "currency";
	$result = self::createExportLookupSheet($conn, $objPHPExcel, $sheetIndex, $type);
	$sheetIndex = 4;
	$type = "Institution";
	$result = self::createExportLookupSheet($conn, $objPHPExcel, $sheetIndex, $type);

    $objPHPExcel->setActiveSheetIndex(0);

	// Save Excel 2007 file
	$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
	$objWriter->setIncludeCharts(TRUE);
	$objWriter->save($filelocation.$filenameExport);

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

  private function createExportLookupSheet($conn, &$objPHPExcel, $sheetIndex, $type){
  	$result = "succeed";
  	//cso is the first sheet, do not need to create a new sheet
	if($type == 'cso'){
  		$stmt = $conn->prepare("SET NOCOUNT ON; exec GetCSOLookup");
  	}else if($type == 'cancer'){
  	  	$objWorkSheet = $objPHPExcel->createSheet();
		$stmt = $conn->prepare("SET NOCOUNT ON; exec GetCancerTypeLookUp");
  	}else if($type == 'country'){
	  	$objWorkSheet = $objPHPExcel->createSheet();
		$stmt = $conn->prepare("SET NOCOUNT ON; exec GetCountryCodeLookup");
  	}else if ($type == 'currency'){
	  	$objWorkSheet = $objPHPExcel->createSheet();
		$stmt = $conn->prepare("SET NOCOUNT ON; exec GetCurrencyRateLookup");
  	}else if($type == 'Institution'){
	  	$objWorkSheet = $objPHPExcel->createSheet();
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
		$location = "A";
		$position = 1;
		for($i=0; $i < sizeof($colName); $i++){
			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location.$position, $colName[$i]);
			$location++;
		}
		$location = "A";
		$position = 2;
		while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
			for($in = 0; $in < sizeof($colName); $in++){
				$objPHPExcel->setActiveSheetIndex($sheetIndex)
							->setCellValue($location.$position, $row[$colName[$in]]);
				$location++;
			}
			$location="A";
			$position++;
		}
		$result = "succeed";
	}else{
	 	$result = "failed to query server";
	}

	if($type == 'cso'){
  		$objPHPExcel->getActiveSheet()->setTitle('CSO Codes');
  	}else if($type == 'cancer'){
  		$objPHPExcel->getActiveSheet()->setTitle('Disease Site Codes');

  	}else if($type == 'country'){
  		$objPHPExcel->getActiveSheet()->setTitle('Country Codes');

  	}else if ($type == 'currency'){
  		$objPHPExcel->getActiveSheet()->setTitle('Currency Conversions');
	}else if($type == 'Institution'){
		$objPHPExcel->getActiveSheet()->setTitle('Institution');
	}

    return $result;
  }

  public function exportUploadStatus(){

	$result = "Complete Exporting Lookup Table";
	$config = self::getConfig();
 	$filelocation = $config['file_location'];
 	$downloadlocation = self::getBaseUrl() .  $config['download_location'];
    $filenameExport  = 'ICRPExportUploadStatus'.'.xlsx';

	$objPHPExcel = new PHPExcel();

  	 try {
	   $conn = self::getConnection();
  	 } catch (Exception $exc) {
  	   return "Could not create db connection";
  	 }
	$sheetIndex = 0;
	$result = self::createUploadStatusSheet($conn, $objPHPExcel, $sheetIndex);

    $objPHPExcel->setActiveSheetIndex(0);

	// Save Excel 2007 file
	$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
	$objWriter->setIncludeCharts(TRUE);
	$objWriter->save($filelocation.$filenameExport);

    $conn = null;

    return self::addCorsHeaders(new JSONResponse($downloadlocation.$filenameExport));

  }

  private function createUploadStatusSheet($conn, &$objPHPExcel, $sheetIndex){
  	$result = "succeed";
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetDataUploadStatus");
	if ($stmt->execute()) {
		$colName = Array();
		foreach(range(0, $stmt->columnCount() - 1) as $column_index)
		{
		  $meta = $stmt->getColumnMeta($column_index);
		  $colName[] = $meta['name'];
		}
		$location = "A";
		$position = 1;
		for($i=0; $i < sizeof($colName); $i++){
			$objPHPExcel->setActiveSheetIndex($sheetIndex)
						->setCellValue($location.$position, $colName[$i]);
			$location++;
		}
		$location = "A";
		$position = 2;
		while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
			for($in = 0; $in < sizeof($colName); $in++){
				$objPHPExcel->setActiveSheetIndex($sheetIndex)
							->setCellValue($location.$position, $row[$colName[$in]]);
				$location++;
			}
			$location="A";
			$position++;
		}

		$result = "succeed";
	}else{
		$result = "failed to query server";
	}
	$objPHPExcel->getActiveSheet()->setTitle('Data Upload Status Report');

  	return $result;
  }

}
?>
