<?php

if ($_SERVER["REQUEST_URI"]) {
	if (is_array($tmp = explode("?" , $_SERVER["REQUEST_URI"]))) {
		$tmp = explode("&" , $tmp["1"]);
		foreach ($tmp as $key => $val) {
			$_tmp = explode("=" , $val);

			if ($_tmp[0]) {
				$_GET[$_tmp[0]] = urldecode($_tmp[1]);
			}			
		}		
	}	
}

$_PAGE = $_GET["_PAGE"];
$_ADMIN = false;

require "admin/config.php";
?>