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
use Symfony\Component\HttpFoundation\Response;
use PHPMailer;
// require 'PHPMailerAutoload.php';

class EmailResultsController extends ControllerBase {



  public function emailResults() {
		$email_config = \Drupal::config('icrp_email');
		$config = [];

		foreach(['email_host', 'email_username', 'email_password', 'email_port'] as $parameter) {
			$config[$parameter] = $email_config->get($parameter);
		}

		//get Parameters from Request
		$to = $_REQUEST['to'];
		$name = $_REQUEST['name'];
		$url = "http://localhost";
		$from = "zhoujim@mail.nih.gov";
		$subject = $name . " wants to share their ICRP Search Results";
		$attachment = '';

		//create email content
		$content = $name . " wants to share their ICRP Search Result: <br/><br/>";
		$content = $content . "Please review their search results on the ICRP Web site: <br/>";
		$content = $content . "<a href='" . $url . "'>" . $url . "</a><br/><br/>";
		$content = $content . "Message from  <a href='mailto:operations@icrpartnership.org'>operations@icrpartnership.org</a>: <br/>";
		$content = $content . "Please see attched. <br/><br/>";
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

		return new Response($result);
  }
}