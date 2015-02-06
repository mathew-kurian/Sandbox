<?php
/*
	OXYLUS Development web framework
	copyright (c) 2002-2005 OXYLUS Development
		web:  www.oxylus.ro
		mail: support@oxylus.ro		

	$Id: name.php,v 0.0.1 dd/mm/yyyy hh:mm:ss author Exp $
	description
*/

// dependencies

if (is_array($_USER) && count($_USER)) {

	$_USER["str_user_log_last_login"] = date("m/d/Y g:i a" , $_USER["user_log_last_login"]);
	$_TSM["MINIBASE.WELCOME"] = $this->templates["user"]->Replace($_USER);

	//show the main
	if (!$_GET["mod"] && $_TSM["PB_EVENTS"]) {
		$_TSM["PB_EVENTS"] = $this->templates["welcome"]->ReplaceSingle("content" , $_TSM["PB_EVENTS"]);
	}
	
} else
	$_TSM["MINIBASE.WELCOME"] = "";



$_TSM["PUB:USER_FIRST_NAME"] = $_USER["user_first_name"];
$_TSM["PUB:USER_LAST_NAME"] = $_USER["user_last_name"];
?>