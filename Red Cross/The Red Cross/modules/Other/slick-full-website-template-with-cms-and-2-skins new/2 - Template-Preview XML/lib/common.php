<?php
/*
	OXYLUS Development web framework
	copyright (c) 2002-2008 OXYLUS Development
		web:  www.oxylus-development.com
		mail: support@oxylus-development.com

	$Id: name.php,v 0.0.1 dd/mm/yyyy hh:mm:ss oxylus Exp $
	description
*/

// dependencies

	function SendMail() {

		$params = AStripSlasshes(func_get_args());	
		//check to see the numbers of the arguments

		switch (func_num_args()) {
			case 1:
				$email = $params[0];
				$vars = array();
			break;

			case 2:
				$email = $params[0];
				$vars = $params[1];
			break;

			case 3:
				$to = $params[0];
				$email = $params[1];
				$vars = $params[2];
			break;

			case 4:
				$to = $params[0];
				$to_name = $params[1];
				$email = $params[2];
				$vars = $params[3];
			break;
		}
		
		if ($email["email_status"] == 1) {
			return true;
		}		
		
		$msg = new CTemplate(stripslashes($email["email_body"]) , "string");
		$msg = $msg->Replace($vars);

		$sub = new CTemplate(stripslashes($email["email_subject"]) , "string");
		$sub = $sub->Replace($vars);

		$email["email_from"] = new CTemplate(stripslashes($email["email_from"]) , "string");
		$email["email_from"] = $email["email_from"]->Replace($vars);

		$email["email_from_name"] = new CTemplate(stripslashes($email["email_from_name"]) , "string");
		$email["email_from_name"] = $email["email_from_name"]->Replace($vars);

		if (!$email["email_reply"]) 
			$email["email_reply"] = $email["email_from"];
		if (!$email["email_reply_name"]) 
			$email["email_reply_name"] = $email["email_from_name"];
		

		//prepare the headers
		$headers  = "MIME-Version: 1.0\r\n";

		if ($email["email_type"] == "html")
			$headers .= "Content-type: text/html\r\n";
		else
			$headers .= "Content-type: text/plain\r\n";
		
		

		//prepare the from fields
		if (!$email["email_hide_from"]) {
			$headers .= "From: {$email[email_from_name]}<{$email[email_from]}>\r\n";
			$headers .=	"Reply-To: {$email[email_reply_name]}<{$email[email_reply]}>\r\n";
		}

		$headers .= $email["headers"];
		
		if (!$email["email_hide_to"]) {
			return mail($email["email_to"] , $sub, $msg,$headers);		
		} else {
		}

		$headers .=	"X-Mailer: PHP/" . phpversion();

		return mail($to, $sub, $msg,$headers);				
	} 

	function AStripSlasshes($array) {
		if (is_array($array))		
			foreach ($array as $key => $item)
				if (is_array($item)) 
					$array[$key] = AStripSlasshes($item);
				else		
					$array[$key] = stripslashes($item);
		else
			return stripslashes($array);
		
		return $array;
	}


?>
