<?php
	require 'PHPMailerAutoload.php';

	//get parameters from request
	$to = $_GET['to'];
	$from = $_GET['from'];
	$subject = $_GET['subject'];
	$content = $_GET['content'];
	$attachment = '';

	//set eamil parameter from config.ini file
	$ini_array = parse_ini_file("config.ini");
	$host = $ini_array['host'];
	$username = $ini_array['username'];
	$password = $ini_array['password'];
	$port = $ini_array['port'];

	if(isset($_GET['attachment'])){
		$attachment = $_GET['attachment'];
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
	// Enable TLS encryption, `ssl` also accepted
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
	echo $result;
?>