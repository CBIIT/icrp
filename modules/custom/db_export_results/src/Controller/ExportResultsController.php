<?php
/**
 * @file
 * Contains \Drupal\db_email_results\Controller\ExportResultsController.
 */
namespace Drupal\db_export_results\Controller;

use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Database\Database;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use PDO;
use ZipArchive;

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

  	$config = getConfig();
    $filelocation = $config['file_location'];
    $downloadlocation = self::getBaseUrl() .  $config['download_location'];
    $filenameExport  = 'export-'.date('Y-m-d_H.i.s').'.csv';
    $filenameCriteria = 'searchCriteria-'.date('Y-m-d_H.i.s').'.csv';
    $fileName = 'export-'.date('Y-m-d_H.i.s').'.zip';
    $zipFilename = $filelocation . $fileName;

    $sid = $_SESSION['database_search_id'];
    //$sid = 3;

	$result = self::createExportData($filelocation, $filenameExport, $sid);
	$result = self::createSearchCriteria($filelocation, $filenameCriteria, $sid);
	$result = self::createZipFile($filelocation, $filenameExport, $filenameCriteria, $zipFilename);

	return self::addCorsHeaders(new JSONResponse($downloadlocation . $fileName));
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

  private function createExportData($filelocation, $filename, $sid){
  	 try {
	   $conn = self::getConnection();
  	 } catch (Exception $exc) {
  	   return "Could not create db connection";
  	 }
	$url = self::getBaseUrl();
	$viewLink = $url . "viewProject.cfm?pid=";

	$file_export  =  $filelocation . $filename;
	$result = "success";
    $data = fopen($file_export, 'w');

	$result_count = NULL;
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjectsBySearchID @SearchID=:search_id_name, @ResultCount=:result_count");
	$stmt->bindParam(':search_id_name', $sid);
	$stmt->bindParam(':result_count', $result_count, PDO::PARAM_INT | PDO::PARAM_INPUT_OUTPUT, 1000);
	if ($stmt->execute()) {
		fwrite($data, "Title,PIFirstName,PILastName,Institution,City,State,Country,Funding Organisation,Award Code,View in ICRP\n");
		while ($row = $stmt->fetch(PDO::FETCH_NUM)) {
			fwrite($data, "\"".$row[3]."\",\"".$row[4]."\",\"".$row[5]."\",\"".$row[7]."\",\"".$row[9]."\",\"".$row[10]."\",\"".$row[11]."\",\"".$row[13]."\",\"".$row[1]."\"," . $viewLink . $row[0] . "\n");
		}
		$result = "succeed";
	} else {
		$result = "failed to query server";
	}

	$data=null;
	$conn=null;

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
	$result = "Complete Exporting Results in Partner Site";
	$config = self::getConfig();
 	$filelocation = $config['file_location'];
 	$downloadlocation = self::getBaseUrl() .  $config['download_location'];
    $filenameExport  = 'export-'.date('Y-m-d_H.i.s').'.csv';
    $filenameCriteria = 'searchCriteria-'.date('Y-m-d_H.i.s').'.csv';
    $filenameCSO = 'exportCSO-'.date('Y-m-d_H.i.s').'.csv';
    $filenameCancerType = 'export-Cancer-type-'.date('Y-m-d_H.i.s').'.csv';
    $fileName = 'export-partner-site-'.date('Y-m-d_H.i.s').'.zip';
    $zipFilename = $filelocation . $fileName;

    $sid = $_SESSION['database_search_id'];
    //$sid = 3;

    $result = self::createExportDataforPartnerSite($filelocation, $filenameExport, $sid);
    $result = self::createSearchCriteria($filelocation, $filenameCriteria, $sid);
    $result = self::createExportDataForPartnerSiteCSO($filelocation, $filenameCSO, $sid);
    $result = self::createExportDataForPartnerSite_Site($filelocation, $filenameCancerType, $sid);

	$result = self::createZipFileForPartnerSite($filelocation, $filenameExport, $filenameCriteria, $filenameCSO, $filenameCancerType, $zipFilename);

	return self::addCorsHeaders(new JSONResponse($downloadlocation . $fileName));
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

  private function createExportDataforPartnerSite($filelocation, $filename, $sid){
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
		fwrite($data,",Currency,To Currency,To Currency Rate,Funding Mechanism,Funding Mechanism Code,Funding Org,Funding Div,Funding Div Abbr,Funding Contact,PI First Name,PI Last Name,PI ORC ID,Instutition,City,State,Country,View In ICRP\n");
		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			fwrite($data, "\"".$row['ProjectID']."\",\"".$row['AwardCode']."\",\"".$row['AwardTitle']."\",\"".$row['AwardType']."\",\"".$row['Source_ID']."\",\"".$row['AltAwardCode']."\",\"".$row['AwardStartDate']."\",\"".$row['AwardEndDate']."\",\"".$row['BudgetStartDate']."\",\"".$row['BudgetEndDate']."\",\"".$row['AwardAmount']."\",\"".$row['FundingIndicator']."\"");
			for($i = 2000; $i < $currentYear; $i++){
				$value = $row[$i];
				fwrite($data, ",\"".$value."\"");
			}
			fwrite($data, ",\"".$row['Currency']."\",\" \",\" \","."\"".$row['FundingMechanism']."\",\"".$row['FundingMechanismCode']."\",\"".$row['FundingOrg']."\",\"".$row['FundingDiv']."\",\"".$row['FundingDivAbbr']."\",\"".$row['FundingContact']."\",\"".$row['piLastName']."\",\"".$row['piFirstName']."\",\"".$row['piORCID']."\",\"".$row['Institution']."\",\"".$row['City']."\",\"".$row['State']."\",\"".$row['Country']."\",\"".$row['icrpURL']."\""."\n");
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
	$result = "Complete Exporting Results with Abstracts in Partner Site";
	return self::addCorsHeaders(new JSONResponse($result));
  }

   public function exportResultsWithGraphsPartner(){
	$result = "Complete Exporting Results with Graphs in Partner Site";
	return self::addCorsHeaders(new JSONResponse($result));
  }

}
?>