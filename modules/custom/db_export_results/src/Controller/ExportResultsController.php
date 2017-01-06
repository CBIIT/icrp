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
use PDO;
use ZipArchive;

class ExportResultsController extends ControllerBase {

  public function exportResults() {

	$url = self::getBaseUrl();
	$viewLink = $url . "viewProject.cfm?pid=";

	$filelocation = 'C:/Temp/icrp/';
	$filename     = 'export-'.date('Y-m-d_H.i.s').'.csv';
	$file_export  =  $filelocation . $filename;
	$result = "success";
	$conn = self::getConnection();
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjects");

	if(!$conn){
		print "Connection failed";
	}else{
		if ($stmt->execute()) {
			$data = fopen($file_export, 'w');
			fwrite($data, "Title,PIFirstName,PILastName,Institution,City,State,Country,Funding Organisation,Award Code,View in ICRP\n");
			$count = 1;
			while ($row = $stmt->fetch(PDO::FETCH_NUM)) {
				$count = $count + 1;
				fwrite($data, "\"".$row[3]."\",\"".$row[4]."\",\"".$row[5]."\",\"".$row[7]."\",\"".$row[9]."\",\"".$row[10]."\",\"".$row[11]."\",\"".$row[13]."\",\"".$row[1]."\"," . $viewLink . $row[0] . "\n");
				if($count == 50){
					break;
				}
			}
			$result = "succeed";
		} else {
			$result = "failed to query server";
		}
		$data=null;
		$conn=null;

		//zip file
		$zip = new ZipArchive();
		$zipFilename = $filelocation . 'export-'.date('Y-m-d_H.i.s').'.zip';
		if ($zip->open($zipFilename, ZipArchive::CREATE)!==TRUE) {
			$result = "cannot open <$zipFilename>";
		}else{
			$zip->addFile($filelocation . $filename, $filename);
			$zip->close();
			$result = "succeed";
		}

		//remove export file, not zip file.
		unlink($file_export);
	}

	return new Response($result);
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
	$protocol = strtolower(substr($_SERVER["SERVER_PROTOCOL"],0,5))=='https://'?'https://':'http://';

	return $protocol.$hostName."/";
  }

}