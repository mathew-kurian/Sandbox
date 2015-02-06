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

$_TSM["PUB:GOOGLE_ANALYTICS"] = $_MODULES["oxymall"]->private->vars->data["set_google_analytics"] ? $_MODULES["oxymall"]->private->vars->data["set_google_analytics_tracker"]  : "";

$_TSM["PUB:GOOGLE_ANALYTICS_STATUS"] = $_MODULES["oxymall"]->private->vars->data["set_google_analytics"]  ? "1" : "0";
?>
