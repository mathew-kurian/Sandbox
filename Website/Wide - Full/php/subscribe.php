<?php
include 'my_email.php';

// change the text below for your Auto-Reply message:
$autoreply_subject = "Subscription auto-reply.";
$autoreply_message = "Thank you for your subscription to our newsletter!" . "\n\n" .
				     "Kind Regards";

// request data on form submit
$sEmail = $_REQUEST["email"];
$headers = 'From: ' . $sEmail . "\r\n" .
		   'Reply-To: ' . $sEmail . "\r\n" .
		   'X-Mailer: PHP/' . phpversion();
 
// include sender IP and some other data in the message
$subscribe_message = "New subscription request: " . "\n\n" .
				     "Sender IP: " . $_SERVER['REMOTE_ADDR'] . "\n\n" .
				     "Sender Email: " . $sEmail . "\n\n";		
 
// remove the backslashes from form field
$subscribe_message = stripslashes($subscribe_message); 
 
// subject line for the Email message with subscription request
$subject = "Subscribe request!";

// if variable is set, send $subscribe_message to $subscribe_email
if(isset($subscribe_message)){
		
		if(mail($subscribe_email, $subject, $subscribe_message, $headers)){
				
				// if mail successful, send auto-reply message to subscriber's email
				$autoreply_headers = 'From: ' . $subscribe_email . "\r\n" .
						   'Reply-To: ' . $subscribe_email . "\r\n" .
						   'X-Mailer: PHP/' . phpversion();
				mail($sEmail, $autoreply_subject, "$autoreply_message", $autoreply_headers);
		}
}
?>