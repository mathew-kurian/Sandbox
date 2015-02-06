<?php
/***************************************************\
 * PHP 4.1.0+ version of email script. For more
 * information on the mail() function for PHP, see
 * http://www.php.net/manual/en/function.mail.php
\***************************************************/


$sendTo = $_POST["myAddress"];
$subject = "New comment from " . $_POST["name"];

// variables are sent to this PHP page through
// the POST method.  $_POST is a global associative array
// of variables passed through this method.  From that, we
// can get the values sent to this page from Flash and
// assign them to appropriate variables which can be used
// in the PHP mail() function.


// header information not including sendTo and Subject
// these all go in one variable.  First, include From:
$headers = "From: Cam Comments" . "<" . $_POST["email"] .">\r\n";
// next include a replyto
$headers .= "Reply-To: " . $_POST["email"] . "\r\n";
// often email servers won't allow emails to be sent to
// domains other than their own.  The return path here will
// often lift that restriction so, for instance, you could send
// email to a hotmail account. (hosting provider settings may vary)
// technically bounced email is supposed to go to the return-path email
$headers .= "Return-path: " . $_POST["email"];

// now we can add the content of the message to a body variable
$message = $_POST["name"] . " left the following message:

" . $_POST["message"];


// once the variables have been defined, they can be included
// in the mail function call which will send you an email
mail($sendTo, $subject, $message, $headers);

?>