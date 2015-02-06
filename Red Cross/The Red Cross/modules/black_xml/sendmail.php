<?
//Send Mail PHP
//
//Upload this file to the root of your web directory

if(!empty($HTTP_POST_VARS['sender_mail']) || !empty($HTTP_POST_VARS['sender_message']) || !empty($HTTP_POST_VARS['sender_name']))

{
	//Insert Address(s) to send the mail to
	$to = "rob@yahoo.com,frank@hotmail.com";

	//Subject
	$subject = "Message from yourdomain.com";
	
	//Body
	$body = stripslashes($HTTP_POST_VARS['sender_message']);

	$body .= "\n---------------------------\n";

	$body .= "Mail sent by: " . $HTTP_POST_VARS['sender_name'] . " <" . $HTTP_POST_VARS['sender_mail']  . ">\n";

	$body .= "\n\n";

	$body .= "\nservice powered by yourdomain.com\n";

	$header = "From: " . $HTTP_POST_VARS['sender_name'] . " <" . $HTTP_POST_VARS['sender_mail'] . ">\n";

	$header .= "Reply-To: " . $HTTP_POST_VARS['sender_name'] . " <" . $HTTP_POST_VARS['sender_mail'] . ">\n";

	$header .= "X-Mailer: PHP/" . phpversion() . "\n";

	$header .= "X-Priority: 1";

	//Mail Sentinel
	if(@mail($to, $subject, $body, $header))

	{
	//Return Mail Status to Flash Form
		echo "output=sent";

	} else {

		echo "output=error";

	}

} else {

	echo "output=error";

}

?>