<?php

 /* 
=================================================
# Filename : js.gzip.php
# Description : Gzip Loader for all js files
# Author : TemplatePlazza
# Author Url : http://www.templateplazza.com
# Copyright (C) 2009 TemplatePlazza.com
# All rights reserved.
=================================================
*/
if (extension_loaded('zscripts') && !ini_get('zscripts.output_compression')) @ob_start('ob_gzhandler');
header('Content-type: application/x-javascript; charset: UTF-8');
header('Cache-Control: must-revalidate');
header('Expires: ' . gmdate('D, d M Y H:i:s', time() + (3600*60)) . ' GMT');

define('DS', DIRECTORY_SEPARATOR);
define('PATH_ROOT', dirname(__FILE__) . DS);

if(!empty($_GET))
{
	foreach($_GET as $key => $val)
	{
		unset($_GET[$key]);
		$val = (substr($val, 0, 4) == 'amp;') ? substr($val, 4) : $val;
		$key = (substr($key, 0, 4) == 'amp;') ? substr($key, 4) : $key;
		$_GET[$key] = $val;
	}
}

$jsPath = PATH_ROOT;

//js path | js file name | js browser1
//js browser = "all" for all browser, "browser1,browser2,..." for defined various browser only
//IE = msie 6
//IE with various version = msie parent version or full version, e.g. "msie 6" or "msie 5.5" or "msie 5.0.1"
//IE 4 = msie 4
//IE 5 = msie 5
//IE 6 = msie 6
//IE 7 = msie 7
//IE 7 = msie 7
//Opera = opera
//Opera with various version = opera/version, e.g. "opera/9.10"
//Firefox = firefox
//Firefox with various version = firefox/version, e.g. "firefox/2.0.0.14"
// usage $jsGZIP[] = $jsPath."|js2.js|msie 6,msie 7";
// usage $jsGZIP[] = $jsPath."|js1.js|all";

$cfc = (!empty($_GET['cfc'])) ? $_GET['cfc'] : null;
$cfmb = (!empty($_GET['cfmb'])) ? $_GET['cfmb'] : null;
$cfacc = (!empty($_GET['cfacc'])) ? $_GET['cfacc'] : null;
$cfmf = (!empty($_GET['cfmf'])) ? $_GET['cfmf'] : null;
$cftpp = (!empty($_GET['cftpp'])) ? $_GET['cftpp'] : null;
$cftpps = (!empty($_GET['cftpps'])) ? $_GET['cftpps'] : null;
$cftpc = (!empty($_GET['cftpc'])) ? $_GET['cftpc'] : null;
$cftpcs = (!empty($_GET['cftpcs'])) ? $_GET['cftpcs'] : null;

/*
$cftmtl = (!empty($_GET['cftmtl'])) ? $_GET['cftmtl'] : null;
$cftmtlf = (!empty($_GET['cftmtlf'])) ? $_GET['cftmtlf'] : null;
$cftmtls = (!empty($_GET['cftmtls'])) ? $_GET['cftmtls'] : null;
$cftmtlsf = (!empty($_GET['cftmtlsf'])) ? $_GET['cftmtlsf'] : null;
$cftmsl = (!empty($_GET['cftmsl'])) ? $_GET['cftmsl'] : null;
$cftmslf = (!empty($_GET['cftmslf'])) ? $_GET['cftmslf'] : null;
$cftpslst = (!empty($_GET['cftpslst'])) ? $_GET['cftpslst'] : null;
$cftpslstf = (!empty($_GET['cftpslstf'])) ? $_GET['cftpslstf'] : null;
*/

//$cftpa = (!empty($_GET['cftpa'])) ? $_GET['cftpa'] : null;
//$cftpaf = (!empty($_GET['cftpaf'])) ? $_GET['cftpaf'] : null;

$jsGZIP[] = $jsPath."|template.js|all";

if(!empty($_GET['cfc']) || !empty($_GET['cfmb']) || !empty($_GET['cftpmenu']) || !empty($_GET['cfacc']) )
{
	//load cufon js
	$jsGZIP[] = $jsPath.DS."cufon".DS."|cufon-yui.js|all";
}

$fonts = array();
$arrF = array('cfacc', 'cfc', 'cftpp', 'cftpps', 'cftpc', 'cftpcs');
foreach( $arrF as $f )
{
	if(!empty($_GET[$f]))
	{
		$fonts[$$f] = true;
	}
}

if(!empty($_GET['cfmb']))
{
	$fonts[$cfmf] = true;
}

if(count($fonts))
{
	foreach($fonts as $f => $true)
	{
		$font = str_replace(" ", "", strtolower($f));
		$jsGZIP[] = $jsPath.DS."cufon".DS."|".$font.".font.js|all";
	}
}

foreach($jsGZIP as $GZIP) {
	$js = explode("|", $GZIP);
	if($js[2]=="all") {
		if(file_exists($js[0].$js[1])) include($js[0].$js[1]);
	} else {
		$browsers = explode(",", $js[2]);
		$loadThisJS = false;
		foreach($browsers as $browser) {
			if(strpos(strtolower($_SERVER['HTTP_USER_AGENT']), $browser) !== false) {
				$loadThisJS = true;
			}
		}
		if($loadThisJS == true) {
			if(file_exists($js[0].$js[1])) include($js[0].$js[1]);
		}
	}
}

if(!empty($cfc)) echo "Cufon.replace('.contentheading, .contentpageopen, .componentheading', { fontFamily: '".$cfc."' });\n";
if(!empty($cfmb)) echo "Cufon.replace('.cufontag', { fontFamily: '".$cfmf."' });\n";
if(!empty($cfacc)) echo "Cufon.replace('.tpaccordiontoggler, .tpaccordiontoggler-active', { fontFamily: '".$cfacc."' });\n";
if(!empty($cftpp)) echo "Cufon.replace('.tpparenttitle', { fontFamily: '".$cftpp."' });\n";
if(!empty($cftpps)) echo "Cufon.replace('.tpsubtitle', { fontFamily: '".$cftpps."' });\n";
if(!empty($cftpc)) echo "Cufon.replace('.tpchildtitle, .dropxtdchildmenu', { fontFamily: '".$cftpc."' });\n";
if(!empty($cftpcs)) echo "Cufon.replace('.tpchildsubtitle', { fontFamily: '".$cftpcs."' });\n";

/*
if(!empty($_GET['cftpa']))
{
	echo 	"Cufon.replace('.tpaccordiontoggler', { fontFamily: '".$cftpaf."' });\n";
}
*/

?>