<?php

 /* 
=================================================
# Filename : css.gzip.php
# Description : Gzip loader for all css files
# Author : TemplatePlazza
# Author Url : http://www.templateplazza.com
# Copyright (C) 2009 TemplatePlazza.com
# All rights reserved.
=================================================
*/

if (extension_loaded('zscripts') && !ini_get('zscripts.output_compression')) @ob_start('ob_gzhandler');
//if (extension_loaded('zlib') && !ini_get('zlib.output_compression')) @ob_start('ob_gzhandler');
header('Content-type: text/css; charset: UTF-8');
header('Expires: '.gmdate('D, d M Y H:i:s', time() + 86400).' GMT');

define('DS', DIRECTORY_SEPARATOR);
define('PATH_ROOT', dirname(__FILE__) . DS);

$cssPath = PATH_ROOT;
$css = $cssPath."saved".DS;
//$css = "http://" . str_replace("\\", "/", str_replace(str_replace(array("/", "\\"), DS, $_SERVER["DOCUMENT_ROOT"]), $_SERVER["HTTP_HOST"], $css));
//$handle = fopen( $css . $_GET['r'] . ".css", "r" );
//$cssContent = stream_get_contents( $handle );
//fclose( $handle );

//echo $cssContent;
include($css.$_GET['r'].".css");

?>