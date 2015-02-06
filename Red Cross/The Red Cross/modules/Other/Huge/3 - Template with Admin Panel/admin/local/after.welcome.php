<?php
/*
	OXYLUS Development web framework
	copyright (c) 2002-2005 OXYLUS Development
		web:  www.oxylus.ro
		mail: support@oxylus.ro		

	$Id: name.php,v 0.0.1 dd/mm/yyyy hh:mm:ss author Exp $
	description
*/
global $_SKIN;
// dependencies

if (!$_GET["mod"] && $_USER) {
	$_TSM["PB_EVENTS"] = $_MODULES["oxymall"]->plugins["modules"]->DashBoard();
}

?>