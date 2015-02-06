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
$url = "http://www.yoursite.com/" ;
$upload_folder_temp = "upload/tmp/";
$upload_folder_final = "upload/resumes/";

$admin_notify_email = array(
	"to"		=> "admin@yoursite.com",
	"to_name"	=> "Admin Name",

	"from"		=> "{EMAIL}",
	"from_name"	=> "{NAME}",

	"subject"	=> "You received a new resume message",
	"body"		=> <<<EOD
	<p>Put here the message body</p>
	<p>
		Name: {NAME}<br>
		Email: {EMAIL}<br>
		Phone: {PHONE}<br>
		Attachment: {ATTACHMENT}
		Message <BR>
		{NOTE}
	</p>
EOD
);

$autoresponder_email = array(
	"enable"	=> true,

	"to"		=> "{EMAIL}",
	"to_name"	=> "{NAME}",

	"to"		=> "admin@yoursite.com",
	"from_name" => "Autoresponder",

	"subject"	=> "Thank you for contacting us",
	"body"		=>  <<<EOD
	<p>Put here the message body</p>
	<p>
		Name: {NAME}<br>
		Email: {EMAIL}<br>
		Phone: {PHONE}<br>
		Message <BR>
		{NOTED}
	</p>
EOD
);


require_once "lib/common.php";
require_once "lib/template.php";

if (is_array($_FILES["Filedata"])) {

	if (!$_FILES["Filedata"]["error"]) {
		move_uploaded_file($_FILES["Filedata"]["tmp_name"] , $upload_folder_temp . "resume-" . $_FILES["Filedata"]["name"]);
	}			
	die();
}

	
if ($_SERVER["REQUEST_METHOD"] == "POST") {
	$vars = array(
		"name" => stripslashes($_POST["name"]),
		"email" => stripslashes($_POST["e-mail"]),
		"phone" => stripslashes($_POST["phone"]),
		"note" => nl2br(stripslashes($_POST["mes"])),
	);


	//process the image if needed
	if ($_POST["file"] != "nofile") {
		//process the file

		$file_name = time() . "-" . $_POST["file"];

		if (file_exists($upload_folder_temp . "resume-" . $_POST["file"])) {
			rename($upload_folder_temp . "resume-" . $_POST["file"] , $upload_folder_final . $file_name );
			chmod($upload_folder_final . $file_name , 0777);
		}

		$vars["attachment"] = $url. $upload_folder_final . $file_name . "  <br>";
	} else 
		$vars["attachment"] = "none";	

	//process the notify email
	$email = array(
		"email_to"			=> $admin_notify_email["to"],
		"email_to_name"		=> $admin_notify_email["to_name"],

		"email_from"		=> $admin_notify_email["from"],
		"email_from_name"	=> $admin_notify_email["from_name"],

		"email_subject"		=> $admin_notify_email["subject"],
		"email_body"		=> $admin_notify_email["body"],
		"email_type"		=> "html"
	);

	foreach ($email as $key => $val) {
		$email[$key] = CTemplateStatic::Replace($val , $vars);
	}

	SendMail($email);

	//process the autoresponder email

	if ($autoresponder_email["enable"] == true) {
		$email = array(
			"email_to"			=> $autoresponder_email["to"],
			"email_to_name"		=> $autoresponder_email["to_name"],

			"email_from"		=> $autoresponder_email["from"],
			"email_from_name"	=> $autoresponder_email["from_name"],

			"email_subject"		=> $autoresponder_email["subject"],
			"email_body"		=> $autoresponder_email["body"],
			"email_type"		=> "html"
		);

		foreach ($email as $key => $val) {
			$email[$key] = CTemplateStatic::Replace($val , $vars);
		}

		SendMail($email);
	}


	echo "status=ok";
	die();

}

echo "status=false";
die();

?>
