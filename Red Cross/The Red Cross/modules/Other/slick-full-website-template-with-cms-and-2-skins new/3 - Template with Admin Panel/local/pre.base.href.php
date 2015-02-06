<?php
/*
	OXYLUS Development web framework
	copyright (c) 2002-2005 OXYLUS Development
		web:  www.oxylus.ro
		mail: support@oxylus.ro		

*/



//	$_TSM["PRIV.BASE.HREF"] = 	"http://www.strategicmerchants.com/";
	$_TSM["PRIV.BASE.HREF"] = 	
			dirname((strtoupper($_SERVER["HTTPS"]) == "on" ? "https://" :  "http://") . 
			$_SERVER["SERVER_NAME"] . 
			($_SERVER["SERVER_PORT"] != 80 ? ':' . $_SERVER["SERVER_PORT"] : '') .
			$_SERVER["SCRIPT_NAME"] ) . "/";	


	$_CONF["url"] = $_TSM["PRIV.BASE.HREF"] ;

//	if (!strstr($_SERVER["HTTP_HOST"] , "www.")) {
//		header("Location: http://{$_SERVER[SERVER_NAME]}{$_SERVER[REQUEST_URI]}");	
//		exit;
//	} 

	$_TSM["PRIV.SELF_URI"] = 
			((strtoupper($_SERVER["HTTPS"]) == "on" ? "https://" :  "http://") . 
			$_SERVER["SERVER_NAME"] . 
			($_SERVER["SERVER_PORT"] != 80 ? ':' . $_SERVER["SERVER_PORT"] : '') .
			$_SERVER["REQUEST_URI"]);

	$_TSM["PRIV.SELF_URI_ENC"] = urlencode($_TSM["PRIV.SELF_URI"]);

	$_TSM["PRIV.SELF_URI_NV"] = @explode("?" , $_TSM["PRIV.SELF_URI"]);
	$_TSM["PRIV.SELF_URI_NV"] = $_TSM["PRIV.SELF_URI_NV"][0];
	
?>