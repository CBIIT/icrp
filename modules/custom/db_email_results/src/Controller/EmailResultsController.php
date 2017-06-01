<?php
/**
 * @file
 * Contains \Drupal\db_email_results\Controller\EmailResultsController.
 */


namespace Drupal\db_email_results\Controller;

require_once 'class.phpmailer.php';
require_once 'class.smtp.php';

use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use PHPMailer;
use Drupal\Core\Database\Database;
use PDO;

// require 'PHPMailerAutoload.php';

class EmailResultsController extends ControllerBase {

  /**
  * Adds CORS Headers to a response
  */
  public function addCorsHeaders($response) {
    $response->headers->set('Access-Control-Allow-Headers', 'origin, content-type, accept');
    $response->headers->set('Access-Control-Allow-Origin', '*');
    $response->headers->set('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, PATCH, OPTIONS');

    return $response;
  }


  public function emailResults() {
		$email_config = \Drupal::config('icrp_email');
		$config = [];

		foreach(['email_host', 'email_username', 'email_password', 'email_port'] as $parameter) {
			$config[$parameter] = $email_config->get($parameter);
		}

		//get Parameters from Request
		$to = $_REQUEST['recipient_email'];
		$name = $_REQUEST['name'];
		$from = 'operations@icrpartnership.org';
		$message = $_REQUEST['personal_message'];

		$emails = array();
		$email_str = '';

		$emails = explode(",", $to);

		$url = self::getBaseUrl();
		$url = $url . "db_search?sid=";

		//get search id from session
		$url = $url . $_SESSION['database_search_id'];

		$subject = $name . " wants to share their ICRP search results";
		$attachment = '';

		//create email content
		$content = $name . " wants to share their ICRP search results. <br/><br/>";
		$content = $content . "Please review their search results on the ICRP website: <br/>";
		$content = $content . "<a href='" . $url . "'>" . $url . "</a><br/><br/>";
		$content = $content . "Message from  <a href='mailto:${from}'>${from}</a>: <br/>";
		$content = $content . $message ."<br/><br/>";
		$content = $content . "The search results will be available for 30 days.";

		//set email server parameters
		$host = $config['email_host'];
		$username = $config['email_username'];
		$password = $config['email_password'];
		$port = $config['email_port'];


		if(isset($_POST['attachment'])){
			$attachment = $_POST['attachment'];
		}
		$result = "success";
		foreach($emails as $addr){
			$mail = new PHPMailer;
			// Set mailer to use SMTP
			$mail->isSMTP();
			$mail->Host = $host;
			// Enable SMTP authentication
			$mail->SMTPAuth = true;
			// SMTP username
			$mail->Username = $username;
			// SMTP password
			$mail->Password = $password;
			// Enable TLS encryption, ssl also accepted
			$mail->SMTPSecure = 'ssl';
			// TCP port to connect to
			$mail->Port = $port;

			$mail->setFrom($from, 'ICRP');
			// Add a recipient
			$mail->addAddress($addr);
			// Add attachments if exist
			if(file_exists($attachment)){
				$mail->addAttachment($attachment);
			}
			// Set email format to HTML
			$mail->isHTML(true);

			$mail->Subject = $subject;
			$mail->Body    = $content;

			if(!$mail->send()) {
				$result = 'Mailer Error: '. $mail->ErrorInfo;
			} else {
				$result = 'Mail has sent suceessfully ';
				//update database
				$sid = $_SESSION['database_search_id'];
				$conn = self::getConnection();
				$stmt = $conn->prepare("SET NOCOUNT ON; exec UpdateSearchResultMarkEmailSent @SearchID=:search_id_name");
				$stmt->bindParam(':search_id_name', $sid);
				$stmt->execute();
				$conn = null;
			}
		}
		return self::addCorsHeaders(new JsonResponse($result));
  }

  private function getBaseUrl(){
  	$currentPath = $_SERVER['PHP_SELF'];
  	$pathInfo = pathinfo($currentPath);
  	$hostName = $_SERVER['HTTP_HOST'];
  	$protocol = strtolower(substr($_SERVER["SERVER_PROTOCOL"],0,5))=='https://'?'https://':'https://';

  	return $protocol.$hostName."/";
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

}