<?php
// Pull contact details
$sendTo = "yourname@youremail.com";
$subject = "You've got a new message";

// Do not edit the following lines
$name = trim($_POST["name"]);
$email = trim($_POST["email"]);
$message = trim($_POST["message"]);
$headers = "From: " . $name . " <" . $email . ">\r\n";

if (mail($sendTo, $subject, $message, $headers)) {
	echo "result=sent";
} else {
	echo "result=failed";
}
?>