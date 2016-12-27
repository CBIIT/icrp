<?php

/**
 * Sends an email
 * @param $param - An associative array containing email content
 *
 * email - the target email addrsss
 * body - the body of the email
 */
function emailResults($param) {


	$body = $param['body'];


}

$parameters = array(
	'address' => 'test@email.com',\
	'body' => 'this is the email body'

);

emailResults($parameters);