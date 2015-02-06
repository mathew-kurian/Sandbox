<?php

/*
	OXYLUS Development web framework
	copyright (c) 2002-2005 OXYLUS Development
		web:  www.oxylus.ro
		mail: support@oxylus.ro		

	$Id: name.php,v 0.0.1 dd/mm/yyyy hh:mm:ss author Exp $
	description
*/



$RewriteBase = dirname($_SERVER["SCRIPT_NAME"]) . "/";



if ($_SERVER["REQUEST_URI"]) {
	$url = $_SERVER["REQUEST_URI"];
} else {
	//i think the server is IIS
	error_reporting(E_PARSE & E_WARNING );
	//DAMN IIS!!!!
	$__tmp = explode(":80" , $_SERVER["QUERY_STRING"]);
	$url = trim($__tmp[1]);

}


//remove the base from the final url
$url = str_replace($RewriteBase , "" , $url );
$orig_url = $url;

$url = eregi_replace("([^/]+)/(.*)/$" , "oxybase.php?_PAGE=index&action=detectmod&sub=\\2&module=\\1", $url );
$url = eregi_replace("([^/]+)/$" , "oxybase.php?_PAGE=index&action=detectmod&sub=landing&module=\\1", $url );
$url = eregi_replace("googlemap.xml" , "oxybase.php?_PAGE=xml&mod=oxymall&sub=oxymall.plugin.sitemaps.google", $url );
$url = eregi_replace("urllist.txt" , "oxybase.php?_PAGE=xml&mod=oxymall&sub=oxymall.plugin.sitemaps.urllist", $url );

//the link matched my needs
if ($orig_url != $url ) {
	header("HTTP/1.1 200 OK");
} else {
	header("Location: page-not-found/");
	exit;
}

if (is_array($tmp = explode("?" , $url))) {
	$tmp = explode("&" , $tmp["1"]);
	foreach ($tmp as $key => $val) {
		$_tmp = explode("=" , $val);

		if ($_tmp[0]) {
			$_GET[$_tmp[0]] = urldecode($_tmp[1]);
		}
	}		
}	


foreach ($_GET as $key => $val) {
	$_GET[$key] = str_replace("oxybase.php" , "" , $val);
}

require_once "oxybase.php";
?>