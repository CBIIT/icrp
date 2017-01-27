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
    //$sid = 3;

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
	$file_export  =  $filelocation . $filename;
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

	$result_count = NULL;
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectsBySearchID @SearchID=:search_id_name, @ResultCount=:result_count");
	$stmt->bindParam(':search_id_name', $sid);
	$stmt->bindParam(':result_count', $result_count, PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT, 1000);
	if ($stmt->execute()) {
		$objPHPExcel->setActiveSheetIndex(0)
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
			$objPHPExcel->setActiveSheetIndex(0)
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

 	$labels = Array("Term Search Type", "Terms", "Institution", "PI Last Name", "PI First Name", "PI ORC ID", "Award Code", "Years" , "City", "State", "Country", "Funding Organization", "Cancer Type", "Project Type", "CSO", "Search By User Name");

	 //add a new sheet
	$objWorkSheet = $objPHPExcel->createSheet();
	$stmt = $conn -> prepare("SELECT * from SearchCriteria where SearchCriteriaID = :search_id");
	$stmt->bindParam(':search_id', $sid);
	if ($stmt->execute()){
	   $objPHPExcel->setActiveSheetIndex(1)
	  			   ->setCellValue('A1', "International Cancer Research Partnership - " . self::getBaseUrl() . "\n");
	   $row = $stmt->fetch(PDO::FETCH_NUM);
	   $date = date("d/m/Y H:i:s", strtotime($row[17]));
	   $objPHPExcel->setActiveSheetIndex(1)
	  			   ->setCellValue('A2', "Created: " . $date);
	   fwrite($data, "Search Criteria:");
	   $objPHPExcel->setActiveSheetIndex(1)
	    		   ->setCellValue('A3',"Search Criteria:");
	   $location = "B";
	   $index = 3;
	   for ($i = 0; $i < 16; $i++){
	        if($row[$i+1] != null){
				$location++;
				$objPHPExcel->setActiveSheetIndex(1)
							->setCellValue($location.$index, $labels[$i] . " : " . $row[$i+1]);
			}
	   }
	   $result = "succeed";
	} else {
	   $result = "failed to query server";
    }
	$objPHPExcel->getActiveSheet()->setTitle('Search Criteria');

	$objPHPExcel->setActiveSheetIndex(0);
	// Save Excel 2007 file
	$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
	$objWriter->save($filelocation.$filenameExport);
    $conn = null;

	return self::addCorsHeaders(new JSONResponse($downloadlocation.$filenameExport));
  }

  private function getConfig(){
    $database_config = \Drupal::config('icrp_file_export');
    $config = [];
    foreach(['file_location', 'download_location'] as $parameter) {
    	$config[$parameter] = $database_config->get($parameter);
	}

	return $config;
  }
  private function createSearchCriteria($filelocation, $fileCriteria, $sid){
  	 $labels = Array("Term Search Type", "Terms", "Institution", "PI Last Name", "PI First Name", "PI ORC ID", "Award Code", "Years" , "City", "State", "Country", "Funding Organization", "Cancer Type", "Project Type", "CSO", "Search By User Name");
  	 try {
	   $conn = self::getConnection();
  	 } catch (Exception $exc) {
  	   return "Could not create db connection";
  	 }
     $result = "";
	 $file_criteria  =  $filelocation . $fileCriteria;
	 $data = fopen($file_criteria, 'w');
	 $result = "success";
	 $stmt = $conn -> prepare("SELECT * from SearchCriteria where SearchCriteriaID = :search_id");
	 $stmt->bindParam(':search_id', $sid);
	 if ($stmt->execute()){
		fwrite($data, "International Cancer Research Partnership - " . self::getBaseUrl() . "\n");
		$row = $stmt->fetch(PDO::FETCH_NUM);
		$date = date("d/m/Y H:i:s", strtotime($row[17]));
		fwrite($data, "Created: " . $date . "\n");
		fwrite($data, "Search Criteria:");
		for ($i = 0; $i < 16; $i++){
			if($row[$i+1] != null){
				fwrite($data, "," . $labels[$i] . " : " . $row[$i+1]);
			}
		}
		fwrite($data, "\n");
		$result = "succeed";
	 } else {
		$result = "failed to query server";
	 }

     $data=null;
	 $conn = null;

	 return $result;
  }

  private function createZipFile($filelocation, $filename, $filename2, $zipFilename){
	//zip file
	$zip = new ZipArchive();
	if ($zip->open($zipFilename, ZipArchive::CREATE)!==TRUE) {
		$result = "cannot open <$zipFilename>";
	}else{
		$zip->addFile($filelocation . $filename, $filename);
		$zip->addFile($filelocation . $filename2, $filename2);
		$zip->close();
		$result = "succeed";
	}
	//remove export file, not zip file.
	unlink($filelocation . $filename);
	unlink($filelocation . $filename2);

	return $result;
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
    //$sid = 3;

	$result = "Complete Exporting Results in Partner Site";
	$config = self::getConfig();
 	$filelocation = $config['file_location'];
 	$downloadlocation = self::getBaseUrl() .  $config['download_location'];
    $filenameExport  = 'ICRPExportPartner'.$sid.'.xlsx';

    //$result = self::createExportDataforPartnerSite($filelocation, $filenameExport, $sid, false);

  	 try {
	   $conn = self::getConnection();
  	 } catch (Exception $exc) {
  	   return "Could not create db connection";
  	 }
	$url = self::getBaseUrl();
	$viewLink = $url . "project/";

	$file_export  =  $filelocation . $filenameExport;
	$result = "success";
    $withAbstract = false;

	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectExportsBySearchID @SearchID=:search_id_name, @SiteURL=:site_url");
	$stmt->bindParam(':search_id_name', $sid);
	$stmt->bindParam(':site_url', $viewLink);
	$currentYear = Date('Y') + 1;

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
	if ($stmt->execute()) {
		$objPHPExcel->setActiveSheetIndex(0)
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
			$objPHPExcel->setActiveSheetIndex(0)
						->setCellValue($realLocation."1", $i);
		}
		$objPHPExcel->setActiveSheetIndex(0)
					->setCellValue($location3.$location2++."1", "Currency")
					->setCellValue($location3.$location2++."1", "To Currency")
					->setCellValue($location3.$location2++."1", "To Currency Rate")
					->setCellValue($location3.$location2++."1", "Funding Mechanism")
					->setCellValue($location3.$location2++."1", "Funding Mechanism Code")
					->setCellValue($location3.$location2++."1", "Funding Org")
					->setCellValue($location3.$location2++."1", "Funding Div")
					->setCellValue($location3.$location2++."1", "Funding Div Abbr")
					->setCellValue($location3.$location2++."1", "Funding Contact")
					->setCellValue($location3.$location2++."1", "PI First Name")
					->setCellValue($location3.$location2++."1", "PI Last Name")
					->setCellValue($location3.$location2++."1", "PI ORC ID")
					->setCellValue($location3.$location2++."1", "Instutition")
					->setCellValue($location3.$location2++."1", "City")
					->setCellValue($location3.$location2++."1", "State")
					->setCellValue($location3.$location2++."1", "Country")
					->setCellValue($location3.$location2++."1", "View In ICRP");
			//fwrite($data,",,,,,,,,,,,,,,,,,Tech Abstract\n");
		$in = 2;
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			$location = "L";
			$location2 = "A";
			$location3 = "A";
			$realLocation = "";
			$objPHPExcel->setActiveSheetIndex(0)
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
				$objPHPExcel->setActiveSheetIndex(0)
							->setCellValue($realLocation.$in, $value);
			}
			$objPHPExcel->setActiveSheetIndex(0)
						->setCellValue($location3.$location2++.$in, $row['Currency'])
						->setCellValue($location3.$location2++.$in, "")
						->setCellValue($location3.$location2++.$in, "")
						->setCellValue($location3.$location2++.$in, $row['FundingMechanism'])
						->setCellValue($location3.$location2++.$in, $row['FundingMechanismCode'])
						->setCellValue($location3.$location2++.$in, $row['FundingOrg'])
						->setCellValue($location3.$location2++.$in, $row['FundingDiv'])
						->setCellValue($location3.$location2++.$in, $row['FundingDivAbbr'])
						->setCellValue($location3.$location2++.$in, $row['FundingContact'])
						->setCellValue($location3.$location2++.$in, $row['piLastName'])
						->setCellValue($location3.$location2++.$in, $row['piFirstName'])
						->setCellValue($location3.$location2++.$in, $row['piORCID'])
						->setCellValue($location3.$location2++.$in, $row['Institution'])
						->setCellValue($location3.$location2++.$in, $row['City'])
						->setCellValue($location3.$location2++.$in, $row['State'])
						->setCellValue($location3.$location2++.$in, $row['Country'])
						->setCellValue($location3.$location2++.$in, $row['icrpURL']);
			$in++;
		}
		$result = "succeed";
	} else {
		$result = "failed to query server";
	}
   $objPHPExcel->getActiveSheet()->setTitle('Export Data');

 	$labels = Array("Term Search Type", "Terms", "Institution", "PI Last Name", "PI First Name", "PI ORC ID", "Award Code", "Years" , "City", "State", "Country", "Funding Organization", "Cancer Type", "Project Type", "CSO", "Search By User Name");

	 //add a new sheet
	$objWorkSheet = $objPHPExcel->createSheet();
	$stmt = $conn -> prepare("SELECT * from SearchCriteria where SearchCriteriaID = :search_id");
	$stmt->bindParam(':search_id', $sid);
	if ($stmt->execute()){
	   $objPHPExcel->setActiveSheetIndex(1)
	  			   ->setCellValue('A1', "International Cancer Research Partnership - " . self::getBaseUrl() . "\n");
	   $row = $stmt->fetch(PDO::FETCH_NUM);
	   $date = date("d/m/Y H:i:s", strtotime($row[17]));
	   $objPHPExcel->setActiveSheetIndex(1)
	  			   ->setCellValue('A2', "Created: " . $date);
	   fwrite($data, "Search Criteria:");
	   $objPHPExcel->setActiveSheetIndex(1)
	    		   ->setCellValue('A3',"Search Criteria:");
	   $location = "B";
	   $index = 3;
	   for ($i = 0; $i < 16; $i++){
	        if($row[$i+1] != null){
				$location++;
				$objPHPExcel->setActiveSheetIndex(1)
							->setCellValue($location.$index, $labels[$i] . " : " . $row[$i+1]);
			}
	   }
	   $result = "succeed";
	} else {
	   $result = "failed to query server";
    }
	$objPHPExcel->getActiveSheet()->setTitle('Search Criteria');

    //$result = self::createExportDataForPartnerSiteCSO($filelocation, $filenameCSO, $sid);
    //$result = self::createExportDataForPartnerSite_Site($filelocation, $filenameCancerType, $sid);

	//$result = self::createZipFileForPartnerSite($filelocation, $filenameExport, $filenameCriteria, $filenameCSO, $filenameCancerType, $zipFilename);

	$objPHPExcel->setActiveSheetIndex(0);
	// Save Excel 2007 file
	$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
	$objWriter->save($filelocation.$filenameExport);
    $conn = null;

	return self::addCorsHeaders(new JSONResponse($downloadlocation . $filenameExport));
  }

  private function createExportDataForPartnerSite_Site($filelocation, $filename, $sid){
    try {
  	   $conn = self::getConnection();
     } catch (Exception $exc) {
    	   return "Could not create db connection";
  	 }
	$file_export  =  $filelocation . $filename;
	$result = "success";
    $data = fopen($file_export, 'w');
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectCancerTypesBySearchID @SearchID=:search_id_name");
	$stmt->bindParam(':search_id_name', $sid);

	if ($stmt->execute()) {
		fwrite($data, "ICRP PROJECT ID,Cancer Type,Site Relevance\n");
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			fwrite($data, "\"".$row['ProjectID']."\",\"".$row['CancerType']."\",\"".$row['Relevance']."\""."\n");
		}
		$result = "succeed";
	} else {
		$result = "failed to query server";
	}

	$data=null;
	$conn=null;

	return $result;

  }

  private function createZipFileForPartnerSite($filelocation, $filename, $filename2, $filename3, $filename4, $zipFilename){
	//zip file
	$zip = new ZipArchive();
	if ($zip->open($zipFilename, ZipArchive::CREATE)!==TRUE) {
		$result = "cannot open <$zipFilename>";
	}else{
		$zip->addFile($filelocation . $filename, $filename);
		$zip->addFile($filelocation . $filename2, $filename2);
		$zip->addFile($filelocation . $filename3, $filename3);
		$zip->addFile($filelocation . $filename4, $filename4);
		$zip->close();
		$result = "succeed";
	}
	//remove export file, not zip file.
	unlink($filelocation . $filename);
	unlink($filelocation . $filename2);
	unlink($filelocation . $filename3);
	unlink($filelocation . $filename4);

	return $result;
  }

  private function createExportDataForPartnerSiteCSO($filelocation, $filename, $sid){
    try {
  	   $conn = self::getConnection();
     } catch (Exception $exc) {
    	   return "Could not create db connection";
  	 }
	$file_export  =  $filelocation . $filename;
	$result = "success";
    $data = fopen($file_export, 'w');
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectCSOsBySearchID @SearchID=:search_id_name");
	$stmt->bindParam(':search_id_name', $sid);
	if ($stmt->execute()) {
		fwrite($data, "ICRP PROJECT ID,Code,CSO Relevance\n");
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			fwrite($data, "\"".$row['ProjectID']."\",\"".$row['CSOCode']."\",\"".$row['CSORelevance']."\""."\n");
		}
		$result = "succeed";
	} else {
		$result = "failed to query server";
	}

	$data=null;
	$conn=null;

	return $result;
  }

  private function createExportDataforPartnerSite($filelocation, $filename, $sid, $withAbstract){
  	 try {
	   $conn = self::getConnection();
  	 } catch (Exception $exc) {
  	   return "Could not create db connection";
  	 }
	$url = self::getBaseUrl();
	$viewLink = $url . "project/";

	$file_export  =  $filelocation . $filename;
	$result = "success";
    $data = fopen($file_export, 'w');

	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectExportsBySearchID @SearchID=:search_id_name, @SiteURL=:site_url");
	$stmt->bindParam(':search_id_name', $sid);
	$stmt->bindParam(':site_url', $viewLink);
	$currentYear = Date('Y') + 1;
	if ($stmt->execute()) {
		fwrite($data, "ICRP PROJECT ID,Award Code,Award Title,Award Type,Source ID,ALT ID,Award Start Date,Award End Date,Budget Start Date,Budget End Date,Award Funding,Funding Indicator");
		for($i = 2000; $i < $currentYear; $i++){
			fwrite($data,",".$i);
		}
		if($withAbstract){
			fwrite($data,",Currency,To Currency,To Currency Rate,Funding Mechanism,Funding Mechanism Code,Funding Org,Funding Div,Funding Div Abbr,Funding Contact,PI First Name,PI Last Name,PI ORC ID,Instutition,City,State,Country,Tech Abstract\n");
		}else{
			fwrite($data,",Currency,To Currency,To Currency Rate,Funding Mechanism,Funding Mechanism Code,Funding Org,Funding Div,Funding Div Abbr,Funding Contact,PI First Name,PI Last Name,PI ORC ID,Instutition,City,State,Country,View In ICRP\n");
		}
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			fwrite($data, "\"".$row['ProjectID']."\",\"".$row['AwardCode']."\",\"".$row['AwardTitle']."\",\"".$row['AwardType']."\",\"".$row['Source_ID']."\",\"".$row['AltAwardCode']."\",\"".$row['AwardStartDate']."\",\"".$row['AwardEndDate']."\",\"".$row['BudgetStartDate']."\",\"".$row['BudgetEndDate']."\",\"".$row['AwardAmount']."\",\"".$row['FundingIndicator']."\"");
			for($i = 2000; $i < $currentYear; $i++){
				$value = $row[$i];
				fwrite($data, ",\"".$value."\"");
			}
			if($withAbstract){
				$abstract = str_replace(array("\r","\n"), '', $row['TechAbstract']);
				fwrite($data, ",\"".$row['Currency']."\",\" \",\" \","."\"".$row['FundingMechanism']."\",\"".$row['FundingMechanismCode']."\",\"".$row['FundingOrg']."\",\"".$row['FundingDiv']."\",\"".$row['FundingDivAbbr']."\",\"".$row['FundingContact']."\",\"".$row['piLastName']."\",\"".$row['piFirstName']."\",\"".$row['piORCID']."\",\"".$row['Institution']."\",\"".$row['City']."\",\"".$row['State']."\",\"".$row['Country']."\",\"".$abstract."\""."\n");
			}else{
				fwrite($data, ",\"".$row['Currency']."\",\" \",\" \","."\"".$row['FundingMechanism']."\",\"".$row['FundingMechanismCode']."\",\"".$row['FundingOrg']."\",\"".$row['FundingDiv']."\",\"".$row['FundingDivAbbr']."\",\"".$row['FundingContact']."\",\"".$row['piLastName']."\",\"".$row['piFirstName']."\",\"".$row['piORCID']."\",\"".$row['Institution']."\",\"".$row['City']."\",\"".$row['State']."\",\"".$row['Country']."\",\"".$row['icrpURL']."\""."\n");
			}
		}
		$result = "succeed";
	} else {
		$result = "failed to query server";
	}

	$data=null;
	$conn=null;

    return $result;
  }

  public function exportResultsWithAbstractPartner(){
    $sid = $_SESSION['database_search_id'];
    //$sid = 3;

	$result = "Complete Exporting Results in Partner Site";
	$config = self::getConfig();
 	$filelocation = $config['file_location'];
 	$downloadlocation = self::getBaseUrl() .  $config['download_location'];
    $filenameExport  = 'export-'.$sid.'.csv';
    $filenameCriteria = 'searchCriteria-'.$sid.'.csv';
    $filenameCSO = 'export-'.$sid.'CSO.csv';
    $filenameCancerType = 'export-'.$sid.'CancerType.csv';
    $fileName = 'ICRPExportPartnerAbstract'.$sid.'.zip';
    $zipFilename = $filelocation . $fileName;


    $result = self::createExportDataforPartnerSite($filelocation, $filenameExport, $sid, true);
    $result = self::createSearchCriteria($filelocation, $filenameCriteria, $sid);
    $result = self::createExportDataForPartnerSiteCSO($filelocation, $filenameCSO, $sid);
    $result = self::createExportDataForPartnerSite_Site($filelocation, $filenameCancerType, $sid);

	$result = self::createZipFileForPartnerSite($filelocation, $filenameExport, $filenameCriteria, $filenameCSO, $filenameCancerType, $zipFilename);

	return self::addCorsHeaders(new JSONResponse($downloadlocation . $fileName));
  }

   public function exportResultsWithGraphsPartner(){
	$result = "Complete Exporting Results with Graphs in Partner Site";
	$sid = $_SESSION['database_search_id'];
	//$sid = 3;

	$result = "Complete Exporting Results in Partner Site";
	$config = self::getConfig();
	$filelocation = $config['file_location'];
	$downloadlocation = self::getBaseUrl() .  $config['download_location'];
	$filenameExport  = 'ICRPExportGraphPartner'.$sid.'.xlsx';
	//$fileName = 'ICRPExportGraphPartner'.$sid.'.zip';
    //$zipFilename = $filelocation . $fileName;

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

  	$file_export  =  $filelocation . $filename;
    $totalRow = 0;
  	// Create new PHPExcel object
	$objPHPExcel = new PHPExcel();

	// Set document properties
	$objPHPExcel->getProperties()->setCreator("ICRP")
							 	->setLastModifiedBy("ICRP")
							 	->setTitle("Test Document")
							 	->setSubject("Test Document")
							 	->setDescription("Test document for PHPExcel, generated using PHP classes.")
							 	->setKeywords("office PHPExcel php")
							 	->setCategory("Test result file");

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