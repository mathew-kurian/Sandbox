<?php

ERROR_REPORTING(E_ALL);

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

$gets = http_build_query($_GET, '', '&amp;');

//css path | css file name | css browser1
//css browser = "all" for all browser, "browser1,browser2,..." for defined various browser only
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

$theme = (!empty($_GET['theme'])) ? $_GET['theme'] : 'app_plazza';
$base = (!empty($_GET['base'])) ? str_replace('~', '/', $_GET['base']) : 'http://' . $http_host;

$tpskeleton = (!empty($_GET['skeleton'])) ? $_GET['skeleton'] : null;
$tpmobilemode = (!empty($_GET['mobile'])) ? $_GET['mobile'] : null;

$direction = (!empty($_GET['direction'])) ? $_GET['direction'] : null;

$loadSkeleton = true;
$isMobile = ( !empty( $_GET['ismobile'] ) ) ? true : false;
$switch = (!empty($_GET['switch'])) ? $_GET['switch'] : null;
$isMobile = ($switch == 'standard') ? false : $isMobile;

$http_user_agent = ( !empty( $_GET['hua'] ) ) ? $_GET['hua'] : null;
$http_user_agent = urldecode( $http_user_agent );

$http_host = ( !empty( $_GET['hh'] ) ) ? $_GET['hh'] : null;
$http_host = urldecode( $http_host );

if($tpmobilemode)
{
	if($isMobile)
	{
		$skeleton = 'skeletonmobiledefault';
		$skeleton = ( !empty( $_GET['mskeleton'] ) ) ? $_GET['mskeleton'] : $skeleton;
	  
		$skeletonFile = $cssPath .  DS . 'skeletons' . DS . $skeleton . '.css.php'; 
		$skeletonDefault = $cssPath .  DS . 'skeletons' . DS . 'skeletonmobiledefault.css.php'; 
		$skeletonFile = (file_exists(  $skeletonFile )) ? $skeletonFile : $skeletonDefault;
		if (file_exists(  $skeletonFile ))
		{
			$skeletonFile = explode( DS , $skeletonFile );
			$skeletonFile = $skeletonFile[count($skeletonFile)-1];
			$cssGZIP = array();
			$cssGZIP[] = $cssPath.DS."skeletons".DS."|".$skeletonFile."|all";
		}
		$loadSkeleton = false;
	}
}

if(!$isMobile || !$tpmobilemode)
{
	$cssGZIP[] = $cssPath."|reset.css|all";
	$cssGZIP[] = $cssPath."|general.css|all";
	$cssGZIP[] = $cssPath."|joomla.css|all";
	$cssGZIP[] = $cssPath."|template.css|all";
	$cssGZIP[] = $cssPath."|module.css|all";
	
	$cssGZIP[] = $cssPath."|ie6.css|msie 6";
	$cssGZIP[] = $cssPath."|ie7.css|msie 7";
	$cssGZIP[] = $cssPath."|ie8.css|msie 8";
	$cssGZIP[] = $cssPath."|opera.css|opera";
}

if($loadSkeleton)
{
	$skeletonFile = $cssPath . 'skeletons' . DS . $tpskeleton . '.css.php'; 
	$skeletonDefault = $cssPath . 'skeletons' . DS . 'skeletondefault.css.php'; 
	$skeletonFile = (file_exists(  $skeletonFile )) ? $skeletonFile : $skeletonDefault;
	if (file_exists(  $skeletonFile ))
	{
		$skeletonFile = explode( DS , $skeletonFile );
		$skeletonFile = $skeletonFile[count($skeletonFile)-1];
		$cssGZIP[] = $cssPath."skeletons".DS."|".$skeletonFile."|all";
	}
}

if(!$isMobile || !$tpmobilemode)
{
	if(!empty($_GET['tptheme']))
		$cssGZIP[] = $cssPath."|".$_GET['tptheme'].".css|all";

	if(!empty($_GET['ffp']))
		$cssGZIP[] = $cssPath."fontfamily".DS."primary".DS."|".$_GET['ffp'].".css|all";
	
	if(!empty($_GET['ffs']))
		$cssGZIP[] = $cssPath."fontfamily".DS."secondary".DS."|".$_GET['ffs'].".css|all";
	
	if(!empty($_GET['fft']))
		$cssGZIP[] = $cssPath."fontfamily".DS."tertiery".DS."|".$_GET['fft'].".css|all";
	
	if(!empty($_GET['fsp']))
		$cssGZIP[] = $cssPath."fontsize".DS."primary".DS."|".$_GET['fsp'].".css|all";
	
	if(!empty($_GET['fss']))
		$cssGZIP[] = $cssPath."fontsize".DS."secondary".DS."|".$_GET['fss'].".css|all";
	
	if(!empty($_GET['fst']))
		$cssGZIP[] = $cssPath."fontsize".DS."tertiery".DS."|".$_GET['fst'].".css|all";
}

if($direction == 'rtl')
	$cssGZIP[] = $cssPath."|rtl.css|all";

$cssContent = null;
foreach($cssGZIP as $GZIP)
{
	$css = explode("|", $GZIP);
	if($css[2]=="all")
	{
		if(file_exists($css[0].$css[1]))
		{
			if( file_exists( $css[0].$css[1] ) )
			{
				if( filesize( $css[0].$css[1] ) )
				{
					if(strtolower(substr($css[1], -4)) == '.php')
					{
						$docRoot = str_replace( 'templates'.DS.$theme.DS.'css'.DS, '', $cssPath );
						$css[0] = $base . str_replace("\\", "/", str_replace($docRoot, '', $css[0]));
						$url = $css[0] . $css[1] . "?" . $gets;

						if ( function_exists( 'fopen' ) && function_exists( 'stream_get_contents' ) && function_exists( 'fclose' ) && ini_get('allow_url_fopen') )
						{
							$handle = fopen( $url, "r" );
							$cssContent .= stream_get_contents( $handle );
							fclose( $handle );
						}
						else if ( function_exists( 'curl_init' ) )
						{
							$ch = curl_init();
							curl_setopt( $ch, CURLOPT_URL, $url );
							curl_setopt( $ch, CURLOPT_HEADER, 0);
							ob_start();
							curl_exec( $ch );
							curl_close( $ch );
							$cssContent .= ob_get_contents();
							ob_end_clean();
						}
					}
					else
					{
						$handle = fopen( $css[0].$css[1], "r" );
						$cssContent .= fread( $handle, filesize( $css[0].$css[1] ) );
						fclose( $handle );
					}
				}
			}
		}
	}
	else
	{
		$browsers = explode(",", $css[2]);
		$loadThisCSS = false;
		foreach($browsers as $browser)
		{
			if(strpos(strtolower($http_user_agent), $browser) !== false)
			{
				$loadThisCSS = true;
			}
		}
		
		if($loadThisCSS == true)
		{
			if(file_exists($css[0].$css[1]))
			{
				if( file_exists( $css[0].$css[1] ) )
				{
					if( filesize( $css[0].$css[1] ) )
					{
						if(strtolower(substr($css[1], -4)) == '.php')
						{
							$docRoot = str_replace( 'templates'.DS.$theme.DS.'css'.DS, '', $cssPath );
							$css[0] = $base . str_replace("\\", "/", str_replace($docRoot, '', $css[0]));
							$url = $css[0] . $css[1] . "?" . $gets;
	
							if ( function_exists( 'fopen' ) && function_exists( 'stream_get_contents' ) && function_exists( 'fclose' ) && ini_get('allow_url_fopen') )
							{
								$handle = fopen( $url, "r" );
								$cssContent .= stream_get_contents( $handle );
								fclose( $handle );
							}
							else if ( function_exists( 'curl_init' ) )
							{
								$ch = curl_init();
								curl_setopt( $ch, CURLOPT_URL, $url );
								curl_setopt( $ch, CURLOPT_HEADER, 0);
								ob_start();
								curl_exec( $ch );
								curl_close( $ch );
								$cssContent .= ob_get_contents();
								ob_end_clean();
							}
						}
						else
						{
							$handle = fopen( $css[0].$css[1], "r" );
							$cssContent .= fread( $handle, filesize( $css[0].$css[1] ) );
							fclose( $handle );
						}
					}
				}
			}
		}
	}
}

// Remove comments
$cssContent = preg_replace('!/\*[^*]*\*+([^/][^*]*\*+)*/!', '', $cssContent);
// Remove tabs, spaces, newlines etc.
$cssContent = str_replace(array("\r\n", "\r", "\n", "\t", '	', '		', '			'), '', $cssContent);

echo $cssContent;

?>