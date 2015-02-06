<?php

$sendTo = "name@company.com";
$subject = "Message from your website";

$name = $_GET['Name'];
$email = $_GET['Email'];
$message = $_GET['Msg'];

$headers  = "From: $name <$email> \r\n";
//$headers .= 'MIME-Version: 1.0' . "\r\n";
//$headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
$msg = "Name: ".$name."\n\nE-mail: ".$email."\n\nMessage: ".$message."";
mail($sendTo, $subject, $msg, $headers);

echo "sent=success";

?>