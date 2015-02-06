<?php
//-----------------Getting data sent by flash---------------------
foreach ($_POST as $key => $value){

		if ($key != 'mail_to' && $key != 'smtp_server' && $key != 'smtp_port' && $key != 'mail_from' && $key != 'mail_subject' && $key != 'plain_text'){
	
			$mail_body .= '<b>'.str_replace('_',' ',$key).'</b>:<br/>';
	
			$mail_body .= ''.stripslashes($value).'<br/>';
		}
}
//-----------------------------------------------------------------



$message = '<html><body>'.$mail_body.'</body></html>'; //  mail body

//------------if plain text is set to true removing html tags------
if ($_POST['plain_text']=='true') {

	$message = str_replace('<br/>',"\r\n", $message);

	$message = strip_tags($message);

//------------------------------------------------------------------
} else {
//----otherwise composing message headers---------------------------
	$headers  = 'MIME-Version: 1.0' . "\r\n";
	
	$headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
//------------------------------------------------------------------
}

//------------setting conf data-------------------------------------
$to = $_POST['mail_to'];

$from = $_POST['mail_from'];

$subject = $_POST['mail_subject'];

$smtp_server = $_POST['smtp_server'];

$smtp_port = $_POST['smtp_port'];
//------------------------------------------------------------------

//---------setting header info--------------------------------------
$headers .= 'To: '.$to. "\r\n";

$headers .= 'From: Site visitor ' .$from. "\r\n";
//------------------------------------------------------------------


if (mail($to, $subject, $message, $headers)){ // sending mail

	print('&mail=1');  //succes

} else {

	print('&mail=0');//failure

}

?>