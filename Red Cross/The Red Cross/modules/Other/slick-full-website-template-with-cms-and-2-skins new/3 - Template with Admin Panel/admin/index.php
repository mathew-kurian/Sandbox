<?php

//error_reporting(E_ERROR | E_WARNING | E_PARSE | E_NOTICE);

$_date = microtime();

$_PAGE = isset($_GET["frame"]) ? "frame" : "index";
$_ADMIN = true;

//define("PB_CRYPT_LINKS" , 1);
require "config.php";

//echo "<center>" . (abs(microtime()- $_date) ) . "</center>";
?>