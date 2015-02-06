<?php
 /* 
=================================================
# Filename : calc.php
# Description : PHP width calculation for CSS files 
# Author : TemplatePlazza
# Author Url : http://www.templateplazza.com
# Copyright (C) 2009 TemplatePlazza.com
# All rights reserved.
=================================================
*/
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

$tpwidth_templatewidth = $_GET['tpwidth_templatewidth'];
$tpwidth_logowidth = $_GET['tpwidth_logowidth'];
$tpwidth_blockleft = $_GET['tpwidth_blockleft'];
$tpwidth_tpwrapper_inner_right = $_GET['tpwidth_tpwrapper_inner_right'];
$tpgutter = $_GET['tpgutter'];
$tpheight_blockhead = $_GET['tpheight_blockhead'];
$tpbackgroundimgpath = $_GET['tpbackgroundimgpath'];
$tpbackgroundcolor = $_GET['tpbackgroundcolor'];
$tplogoplacement = $_GET['tplogoplacement'];
if($tplogoplacement == 1) {
	$tplogofloat = "right" ;
	$tpbannerfloat = "left" ;
} else {
	$tplogofloat = "left" ;
	$tpbannerfloat = "right" ;
}
		

$tpleft = $_GET['tpleft'];
$tpafterleft = $_GET['tpafterleft'];
$tpbeforeleft = $_GET['tpbeforeleft'];

$tpright = $_GET['tpright'];
$tpafterright = $_GET['tpafterright'];
$tpbeforeright = $_GET['tpbeforeright'];

$tpuser1 = $_GET['tpuser1'];
$tpuser2 = $_GET['tpuser2'];

$tpuser1 = ($tpuser1) ? 1 : 0;
$tpuser2 = ($tpuser2) ? 1 : 0;

$tpuser5 = $_GET['tpuser5'];
$tpuser6 = $_GET['tpuser6'];

$tpuser5 = ($tpuser5) ? 1 : 0;
$tpuser6 = ($tpuser6) ? 1 : 0;

$tpadvert1 = $_GET['tpadvert1'];
$tpadvert2 = $_GET['tpadvert2'];
$tpadvert3 = $_GET['tpadvert3'];
$tpadvert4 = $_GET['tpadvert4'];

$tpadvert1 = ($tpadvert1) ? 1 : 0;
$tpadvert2 = ($tpadvert2) ? 1 : 0;
$tpadvert3 = ($tpadvert3) ? 1 : 0;
$tpadvert4 = ($tpadvert4) ? 1 : 0;

$tpblocktoptype = $_GET['tpblocktoptype'];
$tpblockbottype = $_GET['tpblockbottype'];

$tpuser11 = $_GET['tpuser11'];
$tpuser12 = $_GET['tpuser12'];
$tpuser13 = $_GET['tpuser13'];
$tpuser14 = $_GET['tpuser14'];

$tpuser11 = ($tpuser11) ? 1 : 0;
$tpuser12 = ($tpuser12) ? 1 : 0;
$tpuser13 = ($tpuser13) ? 1 : 0;
$tpuser14 = ($tpuser14) ? 1 : 0;

$totaltop = $tpuser11 + $tpuser12 + $tpuser13 + $tpuser14;

$tpuser21 = $_GET['tpuser21'];
$tpuser22 = $_GET['tpuser22'];
$tpuser23 = $_GET['tpuser23'];
$tpuser24 = $_GET['tpuser24'];

$tpuser21 = ($tpuser21) ? 1 : 0;
$tpuser22 = ($tpuser22) ? 1 : 0;
$tpuser23 = ($tpuser23) ? 1 : 0;
$tpuser24 = ($tpuser24) ? 1 : 0;

$totalbot = $tpuser21 + $tpuser22 + $tpuser23 + $tpuser24;

$tpwidth_u_21 = $tpwidth_templatewidth;
$tpwidth_u_22 = $tpwidth_templatewidth;
$tpwidth_u_23 = $tpwidth_templatewidth;
$tpwidth_u_24 = $tpwidth_templatewidth;
$tpmod_user21_margin = 0;
$tpmod_user22_margin = 0;
$tpmod_user23_margin = 0;
$tpmod_user24_margin = 0;

if($totalbot)
{
	if($totalbot > 1)
	{
		if($tpuser21 && ($tpuser22 || $tpuser23 || $tpuser24))
			$tpmod_user21_margin = $tpgutter;
		if($tpuser22 && ($tpuser23 || $tpuser24))
			$tpmod_user22_margin = $tpgutter;
		if($tpuser23 && $tpuser24)
			$tpmod_user23_margin = $tpgutter;
		
		$botw = ( $tpwidth_templatewidth  - ( $tpmod_user21_margin + $tpmod_user22_margin + $tpmod_user23_margin ) ) / $totalbot;
		$tpwidth_u_21 = $botw;
		$tpwidth_u_22 = $botw;
		$tpwidth_u_23 = $botw;
		$tpwidth_u_24 = $botw;
	}
}

$botleft = $tpuser21 + $tpuser22;
$botright = $tpuser23 + $tpuser24;

$tpblock_bot_innerleft_width = ($botleft && $botright) ? (($tpwidth_templatewidth - $tpgutter) / 2) : $tpwidth_templatewidth;
$tpblock_bot_innerright_width = ($botleft && $botright) ? (($tpwidth_templatewidth - $tpgutter) / 2) : $tpwidth_templatewidth;

if($totalbot > 0 && $tpblockbottype != 1)
{	
	if($botleft == 1)
	{
		$tpmod_user21_margin = 0;
		$tpmod_user22_margin = 0;
		$tpwidth_u_21 = $tpblock_bot_innerleft_width;
		$tpwidth_u_22 = $tpblock_bot_innerleft_width;
	}
	else
	{
		$tpmod_user21_margin = $tpgutter;
		$tpmod_user22_margin = 0;
		$tpwidth_u_21 = ($tpblock_bot_innerleft_width) / 2 - ($tpgutter / 2);
		$tpwidth_u_22 = ($tpblock_bot_innerleft_width) / 2 - ($tpgutter / 2);
	}

	if($botright == 1)
	{
		$tpmod_user23_margin = 0;
		$tpmod_user24_margin = 0;
		$tpwidth_u_23 = $tpblock_bot_innerright_width;
		$tpwidth_u_24 = $tpblock_bot_innerright_width;
	}
	else
	{
		$tpmod_user23_margin = $tpgutter;
		$tpmod_user24_margin = 0;
		$tpwidth_u_23 = ($tpblock_bot_innerright_width) / 2 - ($tpgutter / 2);
		$tpwidth_u_24 = ($tpblock_bot_innerright_width) / 2 - ($tpgutter / 2);
	}
}

if(($tpleft || $tpafterleft || $tpbeforeleft) && ($tpright || $tpafterright || $tpbeforeright))
{
	$tpwidth_wrapper_right = $tpwidth_templatewidth - $tpwidth_blockleft + $tpgutter ;
	$tpwidth_tpwrapper_inner_left = $tpwidth_wrapper_right - $tpwidth_tpwrapper_inner_right - $tpgutter - $tpgutter;
}
else if ($tpleft || $tpafterleft || $tpbeforeleft)
{
	$tpwidth_wrapper_right = $tpwidth_templatewidth - $tpwidth_blockleft + $tpgutter ;
	$tpwidth_tpwrapper_inner_left = $tpwidth_wrapper_right - $tpgutter - $tpgutter;
}
else if ($tpright || $tpafterright || $tpbeforeright)
{
	$tpwidth_wrapper_right = $tpwidth_templatewidth + $tpgutter + $tpgutter ;
	$tpwidth_tpwrapper_inner_left = $tpwidth_wrapper_right - $tpwidth_tpwrapper_inner_right - $tpgutter - $tpgutter;
}
else
{
	$tpwidth_wrapper_right = $tpwidth_templatewidth + $tpgutter + $tpgutter ;
	$tpwidth_tpwrapper_inner_left = $tpwidth_wrapper_right - $tpgutter - $tpgutter;
}

$tpgutterx = 2; //($tpblocktoptype != 1) ? 2 : 4;

$tpwidth_wrapper_right = $tpwidth_wrapper_right - ( $tpgutter * $tpgutterx ) - 2;

$tpwidth_u_11 = $tpwidth_wrapper_right ;
$tpwidth_u_12 = $tpwidth_wrapper_right ;
$tpwidth_u_13 = $tpwidth_wrapper_right ;
$tpwidth_u_14 = $tpwidth_wrapper_right ;
$tpmod_user11_margin = 0;
$tpmod_user12_margin = 0;
$tpmod_user13_margin = 0;
$tpmod_user14_margin = 0;

if($totaltop)
{
	if($totaltop > 1)
	{
		if($tpuser11 && ($tpuser12 || $tpuser13 || $tpuser14))
			$tpmod_user11_margin = $tpgutter;
		if($tpuser12 && ($tpuser13 || $tpuser14))
			$tpmod_user12_margin = $tpgutter;
		if($tpuser13 && $tpuser14)
			$tpmod_user13_margin = $tpgutter;

		//$topw = ( $tpwidth_wrapper_right + ($tpgutter * 1.8) - ( $tpmod_user11_margin + $tpmod_user12_margin + $tpmod_user13_margin ) ) / $totaltop;
		$topw = ( $tpwidth_wrapper_right - ( $tpmod_user11_margin + $tpmod_user12_margin + $tpmod_user13_margin ) ) / $totaltop;
		$tpwidth_u_11 = $topw;
		$tpwidth_u_12 = $topw;
		$tpwidth_u_13 = $topw;
		$tpwidth_u_14 = $topw;
	}
}

$topleft = $tpuser11 + $tpuser12;
$topright = $tpuser13 + $tpuser14;

$tpblock_top_innerleft_width = ($topleft && $topright) ? (($tpwidth_wrapper_right - $tpgutter) / 2) : $tpwidth_wrapper_right ;
$tpblock_top_innerright_width = ($topleft && $topright) ? (($tpwidth_wrapper_right - $tpgutter) / 2) : $tpwidth_wrapper_right ;

if($totaltop > 0 && $tpblocktoptype != 1)
{	
	if($topleft == 1)
	{
		$tpmod_user11_margin = 0;
		$tpmod_user12_margin = 0;
		$tpwidth_u_11 = $tpblock_top_innerleft_width;
		$tpwidth_u_12 = $tpblock_top_innerleft_width;
	}
	else
	{
		$tpmod_user11_margin = $tpgutter;
		$tpmod_user12_margin = 0;
		$tpwidth_u_11 = ($tpblock_top_innerleft_width) / 2 - ($tpgutter / 2);
		$tpwidth_u_12 = ($tpblock_top_innerleft_width) / 2 - ($tpgutter / 2);
	}

	if($topright == 1)
	{
		$tpmod_user13_margin = 0;
		$tpmod_user14_margin = 0;
		$tpwidth_u_13 = $tpblock_top_innerright_width;
		$tpwidth_u_14 = $tpblock_top_innerright_width;
	}
	else
	{
		$tpmod_user13_margin = $tpgutter;
		$tpmod_user14_margin = 0;
		$tpwidth_u_13 = ($tpblock_top_innerright_width) / 2 - ($tpgutter / 2);
		$tpwidth_u_14 = ($tpblock_top_innerright_width) / 2 - ($tpgutter / 2);
	}
}

$tpwidth_wrapper_right = $tpwidth_wrapper_right + ( $tpgutter * $tpgutterx ) + 2;

$modw = ($tpuser1 && $tpuser2) ? ($tpwidth_templatewidth - $tpgutter ) /  2 : $tpwidth_templatewidth ;
$tpwidth_mod_user1 = $modw;
$tpwidth_mod_user2 = $modw;

$modw = ($tpuser5 && $tpuser6) ? ($tpwidth_tpwrapper_inner_left - $tpgutter) /  2 : $tpwidth_tpwrapper_inner_left;
$tpwidth_mod_user5 = $modw;
$tpwidth_mod_user6 = $modw;

$modw = ($tpadvert1 && $tpadvert2) ? ($tpwidth_tpwrapper_inner_left - $tpgutter) /  2 : $tpwidth_tpwrapper_inner_left;
$tpwidth_mod_advert1 = $modw;
$tpwidth_mod_advert2 = $modw;

$modw = ($tpadvert3 && $tpadvert4) ? ($tpwidth_tpwrapper_inner_left - $tpgutter) /  2 : $tpwidth_tpwrapper_inner_left;
$tpwidth_mod_advert3 = $modw;
$tpwidth_mod_advert4 = $modw;

$tpwidth_wrapper_page = $tpwidth_templatewidth + $tpgutter + $tpgutter;
//$tpwidth_mod_banner = $tpwidth_templatewidth - $tpwidth_logowidth - $tpgutter;
$tpwidth_mod_banner = $tpwidth_wrapper_right - $tpwidth_logowidth - $tpgutter;
//$tpwidth_mod_left = $tpwidth_blockleft - $tpgutter;
$tpwidth_mod_left = $tpwidth_blockleft ;
$tpwidth_mod_right = $tpwidth_tpwrapper_inner_right - $tpgutter;

?>
