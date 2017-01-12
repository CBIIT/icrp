<?php
/**
 * @file
 * Contains \Drupal\db_email_results\Controller\EmailResultsController.
 */


namespace Drupal\db_email_results\Controller;

require 'class.phpmailer.php';
require 'class.smtp.php';

use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use PHPMailer;
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
		$name = $_REQUEST['user_name'];
		$from = $_REQUEST['user_email'];
		$message = $_REQUEST['personal_message'];
		$sendTo = $_REQUEST['send_to'];
		if($sendTo == 'self'){
			$to = $from;
		}
		$url = self::getBaseUrl();
		$url = $url . "db_search?sid=";

		//get search id from session

		$_SESSION['db_search_id'] = '12345';
		$url = $url . $_SESSION['db_search_id'];

		$from = "zhoujim@mail.nih.gov";
		$subject = $name . " wants to share their ICRP Search Results";
		$attachment = '';

		//create email content
		$content = $name . " wants to share their ICRP Search Result: <br/><br/>";
		$content = $content . "Please review their search results on the ICRP Web site: <br/>";
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
		$mail->addAddress($to);
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
		}

		return self::addCorsHeaders(new JsonResponse($result));
  }

  private function getBaseUrl(){
  	$currentPath = $_SERVER['PHP_SELF'];
  	$pathInfo = pathinfo($currentPath);
  	$hostName = $_SERVER['HTTP_HOST'];
  	$protocol = strtolower(substr($_SERVER["SERVER_PROTOCOL"],0,5))=='https://'?'https://':'http://';

  	return $protocol.$hostName."/";
  }
}