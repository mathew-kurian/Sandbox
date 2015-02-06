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

$path = explode("/" , dirname($_SERVER["SCRIPT_NAME"]));

$out = array_pop(&$path);
$out = array_pop(&$path);
$out = array_pop(&$path);
$out = array_pop(&$path);
$out = array_pop(&$path);
$out = array_pop(&$path);
$out = array_pop(&$path);

$path = implode("/" , $path ) ;

echo "<table><tr><td><pre style=\"background-color:white\">";
print_r($path);
echo "</pre></td></tr></table>";


?>