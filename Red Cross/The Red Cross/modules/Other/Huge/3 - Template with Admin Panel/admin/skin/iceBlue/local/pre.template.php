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

$_PAGE = "../skin/iceBlue/templates/index";

if (!is_array($_USER)) {
	$_PAGE = "../skin/iceBlue/templates/login";
	$_TSM["redirect"] = $_GET["redirect"];
}


?>