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


if (!$_GET["code"]) {
	die("Invalid xml request!");
}


switch ($_GET["code"]) {
	case "main":
		$_GET["_PAGE"]	= "xml";
		$_GET["mod"]	= "oxymall";
		$_GET["sub"]	= "oxymall.plugin.main.xml";
	break;

	default:
		$_GET["_PAGE"]	= "xml";
		$_GET["mod"]	= "oxymall";
		$_GET["sub"]	= "oxymall.plugin.{$_GET[code]}.xml";
	break;
}


require "oxybase.php";

?>