<?php

error_reporting(E_ERROR | E_WARNING | E_PARSE);

$no_tutorials = 1;

if ($_ADMIN) {
	define("_LIBPATH","./lib/");	
	define("_TPLPATH" , "./skin/");
//	define("_XMLCACHE" , "./xml/");
//	define("_XMLNOFILE" , 1);
} else {
	if (!defined("_LIBPATH")) 
		define("_LIBPATH","./admin/lib/");
	if (!defined("_MODPATH")) 
		define("_MODPATH","./admin/modules/");
	
	
}

//ini_set("default_charset" , "utf-8");

require_once _LIBPATH . "site.php";

$site = new CSite(($_ADMIN ? "" : "admin/") . "site.xml",$_ADMIN , true);
$site->Run();
?>