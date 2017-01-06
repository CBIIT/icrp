<?php

	function getConnection(){
		$ini_array = parse_ini_file("config.ini");
		$host = $ini_array['database_host'];
		$database = $ini_array['database'];
		$username = $ini_array['db_username'];
		$password = $ini_array['db_password'];
		$port = $ini_array['port'];

		$serverName = $host.", ".$port;
		$opt = [
			PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
			PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
			//PDO::ATTR_EMULATE_PREPARES   => false,
		];

		return new PDO("sqlsrv:Server=".$serverName.";Database=".$database, $username, $password, $opt);
	}

	function getBaseUrl()
	{
		$currentPath = $_SERVER['PHP_SELF'];
		$pathInfo = pathinfo($currentPath);
		$hostName = $_SERVER['HTTP_HOST'];
		$protocol = strtolower(substr($_SERVER["SERVER_PROTOCOL"],0,5))=='https://'?'https://':'http://';

		return $protocol.$hostName."/";
	}

	//get parameters from request
	$uri = getBaseUrl();
	$viewLink = $uri . "viewProject.cfm?pid=";
	$filelocation = 'C:/Temp/icrp/';
	$filename     = 'export-'.date('Y-m-d_H.i.s').'.csv';
	$file_export  =  $filelocation . $filename;
	$result = "success";
	$conn = getConnection();
	$stmt = $conn->prepare("SET NOCOUNT ON; exec GetProjects");
	if(!$conn){
		$result = "Connection failed";
	}
	else{
		if ($stmt->execute()) {
			$data = fopen($file_export, 'w');
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
	echo $result;

?>