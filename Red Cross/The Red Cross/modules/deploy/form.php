<?php
$headers  = 'MIME-Version: 1.0' . "\r\n";
$headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
$headers .= 'From: ' . $_POST['txtFrom'] . ' <' . $_POST['txtEmail'] . '>' . "\r\n";//put your website's name in the header, near the email
$to = $_POST['txtTo'];//where to send the mail
$subject = $_POST['txtSubject'];//the subject of the mail
$message = $_POST['txtMessage'];//the message of the mail. The message is parsed in flash, so this variable contains all the fields that you have in your form
if ($_POST['txtMessage'] != "") {//checks if the script is executed by a person, manually
 $ok = mail($to, $subject, $message, $headers);
 if($ok) {//if the mail was sent..
  echo "&fStatus=ok&";//send an "ok" back to the flash 
 } else {//if the mail wasn't sent..
  echo "&fStatus=failed&";//let flash know about the error :)
 }
}
//this is it with the PHP script..the rest is in the FLA ;)
?>
