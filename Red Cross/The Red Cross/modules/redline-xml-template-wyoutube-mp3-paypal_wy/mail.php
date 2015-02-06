<?php

	//the message will be sent to this e-mail address...
	$destemail = "youraddress@somedomain.com";


	//if magic quotes turned on, remove slashes from escaped characters

	if (get_magic_quotes_gpc()) 
{
		$_POST['from'] = stripslashes($_POST['from']);
		$_POST['message'] = stripslashes($_POST['message']);

	}

	
//initialize variables for To and Subject fields
	
$subject = $_POST['subject'];
	
$msg = "";
	

//build message body from variables received in the POST array

	foreach ($_POST as $key => $value) 
{
		if ($value != "" && $key != "to" && $key != "subject")
	{

			$msg .= ucwords($key).": ".$value."\n\n";

		}
	
}
	

//add additional email headers for more user-friendly reply

	$additionalHeaders = "From: Contact Form\n";


	if($_POST['email'])
 {
		$additionalHeaders .= 'Reply-To: '.$_POST['email'];
	
}
	
else 
{
		$additionalHeaders .= 'Reply-To: noreply@mydomain.com';
	
}
echo $subject;
	

//send email message

	$OK = mail($destemail, $subject, $msg, $additionalHeaders);

	
if ($OK) 
{
		echo "sent=".urlencode("OK");

	}

	else 
{
		echo "sent=".urlencode("failed");

	}


?>