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

//force the existence of the newsletters module if the page is cron
if ($_PAGE == "cron") {

	$_CONF["modules"]["newsletters"] = "newsletters";
	$_CONF["path"] = "../";
	$_CONF["url"] = "../";
}

?>
