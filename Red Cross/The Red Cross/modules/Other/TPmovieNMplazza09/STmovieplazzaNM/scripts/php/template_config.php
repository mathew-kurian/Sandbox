<?php
 /* 
=================================================
# Filename : template_config.php
# Description : TemplatePlazza Config File + Style Switcher
# Author : TemplatePlazza
# Author Url : http://www.templateplazza.com
# Copyright (C) 2009 TemplatePlazza.com
# All rights reserved.
=================================================
*/
defined('_JEXEC') or die('Restricted access');

$tp_enablemobilephoneswitch = $this->params->get('tp_enablemobilephoneswitch');

$superDefaultTheme 		= $this->params->get('tp_templatetheme');  

$superDefaultFontSizePrimary = $this->params->get('tp_primaryfontsize'); 
$superDefaultFontSizeSecondary = $this->params->get('tp_secondaryfontsize'); 
$superDefaultFontSizeTertiery = $this->params->get('tp_tertieryfontsize'); 

$superDefaultFontFamilyPrimary = $this->params->get('tp_primaryfontfam');
$superDefaultFontFamilySecondary = $this->params->get('tp_secondaryfontfam');
$superDefaultFontFamilyTertiery = $this->params->get('tp_tertieryfontfam');

//$superDefaultTplOrientation 	= $this->params->get('tp_orientation'); 

$tpmetagen					= $this->params->get('metagen');
$tpgooglekey				= $this->params->get('googlekey');
$tpyahookey					= $this->params->get('yahookey');
$tpmsnkey						= $this->params->get('msnkey');
$templatewidth 			= $this->params->get('tp_templatewidth');
$tp_skeleton				= $this->params->get('tp_skeleton');
$tp_mobilemode			= $this->params->get('tp_mobilemode');
$tp_blocktoptype		= $this->params->get('tp_blocktoptype');
$tp_blockbottype		= $this->params->get('tp_blockbottype');
$tp_logowidth				= $this->params->get('tp_logowidth');
$tp_blockheadheight = $this->params->get('tp_blockheadheight');
$tp_logoplacement = $this->params->get('tp_logoplacement');

$tp_cufon_in_content = $this->params->get('tp_cufon_in_content');
$tp_cufon_in_module_block = $this->params->get('tp_cufon_in_module_block');
$tp_cufon_in_accordion_font = $this->params->get('tp_cufon_in_accordion_font');
$tp_cufon_in_module_font = $this->params->get('tp_cufon_in_module_font');
$tp_cufon_in_tpmenu_parent = $this->params->get('tp_cufon_in_tpmenu_parent');
$tp_cufon_in_tpmenu_parent_sub = $this->params->get('tp_cufon_in_tpmenu_parent_sub');
$tp_cufon_in_tpmenu_child = $this->params->get('tp_cufon_in_tpmenu_child');
$tp_cufon_in_tpmenu_child_sub = $this->params->get('tp_cufon_in_tpmenu_child_sub');
/*
$tp_cufon_in_tpaccordion = $this->params->get('tp_cufon_in_tpaccordion');
$tp_cufon_in_tpaccordion_font = $this->params->get('tp_cufon_in_tpaccordion_font');
*/

/////////////////DO NOT EDIT AFTER THIS LINE//////////////////////////////

require_once( JPATH_BASE . DS . 'templates' .  DS . $this->template . DS . 'scripts' . DS . 'php' . DS . 'tpframework.php');
$tpFramework = new tpFramework($tp, $this);

require_once( JPATH_BASE . DS . 'templates' .  DS . $this->template . DS . 'scripts' . DS . 'php' . DS . 'validvalues.php');

$isMobile = $tpFramework->mobileCheck();

if(!$isMobile || !$tp_mobilemode)
{
	//Theme
	if ($this->params->get('tp_styleswitcherstate')==0)
	{
		$tptheme = $superDefaultTheme;
	}
	else
	{
		if(!empty($_GET['tptheme']))
		{
			if(in_array($_GET['tptheme'],$arrTheme))
			{
				setcookie('tp_theme', $_GET['tptheme'] , time() + 3600, '/'); 
				$tptheme = $_GET['tptheme'];
			}
			else
			{
				$tptheme = isset($_COOKIE['tp_theme']) ? $_COOKIE['tp_theme'] : $superDefaultTheme;
			}
		}
		else
		{
			$tptheme = isset($_COOKIE['tp_theme']) ? $_COOKIE['tp_theme'] : $superDefaultTheme;
		}
	}

	//Font Family
	if ($this->params->get('tp_styleswitcherstate')==0)
	{
		$ffp = $superDefaultFontFamilyPrimary;
		$ffs = $superDefaultFontFamilySecondary;
		$fft = $superDefaultFontFamilyTertiery;
	}
	else
	{
		//Font Family Primary
		if(!empty($_GET['ffp']))
		{
			if(in_array($_GET['ffp'],$arrFontFamily))
			{
				setcookie('tp_ffp', $_GET['ffp'] , time() + 3600, '/'); 
				$ffp = $_GET['ffp'];
			}
			else
			{
				$ffp = isset($_COOKIE['tp_ffp']) ? $_COOKIE['tp_ffp'] : $superDefaultFontFamilyPrimary;
			}
		}
		else
		{
			$ffp = isset($_COOKIE['tp_ffp']) ? $_COOKIE['tp_ffp'] : $superDefaultFontFamilyPrimary;
		}
	
		//Font Family Secondary
		if(!empty($_GET['ffs']))
		{
			if(in_array($_GET['ffs'],$arrFontFamily))
			{
				setcookie('tp_ffs', $_GET['ffs'] , time() + 3600, '/'); 
				$ffs = $_GET['ffs'];
			}
			else
			{
				$ffs = isset($_COOKIE['tp_ffs']) ? $_COOKIE['tp_ffs'] : $superDefaultFontFamilySecondary;
			}
		}
		else
		{
			$ffs = isset($_COOKIE['tp_ffs']) ? $_COOKIE['tp_ffs'] : $superDefaultFontFamilySecondary;
		}
	
		//Font Family Tertiery
		if(!empty($_GET['fft']))
		{
			if(in_array($_GET['fft'],$arrFontFamily))
			{
				setcookie('tp_fft', $_GET['fft'] , time() + 3600, '/'); 
				$fft = $_GET['fft'];
			}
			else
			{
				$fft = isset($_COOKIE['tp_fft']) ? $_COOKIE['tp_fft'] : $superDefaultFontFamilyTertiery;
			}
		}
		else
		{
			$fft = isset($_COOKIE['tp_fft']) ? $_COOKIE['tp_fft'] : $superDefaultFontFamilyTertiery;
		}
	}
	
	//Font Size
	if ($this->params->get('tp_styleswitcherstate')==0)
	{
		$fsp = $superDefaultFontSizePrimary;
		$fss = $superDefaultFontSizeSecondary;
		$fst = $superDefaultFontSizeTertiery;
	}
	else
	{
		//Font Size Primary
		if(!empty($_GET['fsp']))
		{
			if(in_array($_GET['fsp'],$arrFontSize))
			{
				setcookie('tp_fsp', $_GET['fsp'] , time() + 3600, '/'); 
				$fsp = $_GET['fsp'];
			}
			else
			{
				$fsp = isset($_COOKIE['tp_fsp']) ? $_COOKIE['tp_fsp'] : $superDefaultFontSizePrimary;
			}
		}
		else
		{
			$fsp = isset($_COOKIE['tp_fsp']) ? $_COOKIE['tp_fsp'] : $superDefaultFontSizePrimary;
		}
	
		//Font Size Secondary
		if(!empty($_GET['fss']))
		{
			if(in_array($_GET['fss'],$arrFontSize))
			{
				setcookie('tp_fss', $_GET['fss'] , time() + 3600, '/'); 
				$fss = $_GET['fss'];
			}
			else
			{
				$fss = isset($_COOKIE['tp_fss']) ? $_COOKIE['tp_fss'] : $superDefaultFontSizeSecondary;
			}
		}
		else
		{
			$fss = isset($_COOKIE['tp_fss']) ? $_COOKIE['tp_fss'] : $superDefaultFontSizeSecondary;
		}
	
		//Font Size Tertiery
		if(!empty($_GET['fst']))
		{
			if(in_array($_GET['fst'],$arrFontSize))
			{
				setcookie('tp_fst', $_GET['fst'] , time() + 3600, '/'); 
				$fst = $_GET['fst'];
			}
			else
			{
				$fst = isset($_COOKIE['tp_fst']) ? $_COOKIE['tp_fst'] : $superDefaultFontSizeTertiery;
			}
		}
		else
		{
			$fst = isset($_COOKIE['tp_fst']) ? $_COOKIE['tp_fst'] : $superDefaultFontSizeTertiery;
		}
	}
	
	/*
	if ($this->params->get('tp_styleswitcherstate')==0)
	{
		$orient = $superDefaultTplOrientation;
	}
	else
	{
		if(!empty($_GET['tporient']))
		{
			if(in_array($_GET['tporient'],$arrOrient))
			{
				setcookie('tp_forient', $_GET['tporient'] , time() + 3600, '/'); 
				$orient = $_GET['tporient'];
			}
			else
			{
				$orient = isset($_COOKIE['tp_forient']) ? $_COOKIE['tp_forient'] : $d_forient;
			}
		}
		else
		{
			$orient = isset($_COOKIE['tp_forient']) ? $_COOKIE['tp_forient'] : $d_forient;
		}
	}
	*/
}

$skeletonids = explode(",", str_replace( " ", "", $this->params->get('tp_skeletonitemid') ) );
if(count($skeletonids))
{
	$si = array();
	foreach($skeletonids as $sids)
	{
		$s = explode("=", $sids);
		if(!empty($s[0]) && !empty($s[1]))
		{
			$si[str_replace("itemid", "", strtolower($s[0]))] = $s[1];
		}
	}
	
	$menus = &JSite::getMenu();
	$menu  = $menus->getActive();
	$Itemid = (!empty($menu->id)) ? $menu->id : null;
	if(!empty($si[$Itemid]))
	{
		$tp_skeleton = $si[$Itemid];
	}
}

$is_Mobile = ($isMobile) ? 1 : 0;

$user_agent = $_SERVER['HTTP_USER_AGENT'];
$mskeleton = null;
switch(true)
{
  //case (eregi('ipod',$user_agent)||eregi('iphone',$user_agent)):
  case (preg_match('/ipod/i',$user_agent)||preg_match('/iphone/i',$user_agent)):
  	$mskeleton = 'skeletonmobileiphone';
  break;
  //case (eregi('android',$user_agent)):
  case (preg_match('/android/i',$user_agent)):
  	$mskeleton = 'skeletonmobileandroid';
  break;
  //case (eregi('opera mini',$user_agent)):
  case (preg_match('/opera mini/i',$user_agent)):
  	$mskeleton = 'skeletonmobileopera';
  break;
  //case (eregi('blackberry',$user_agent)):
  case (preg_match('/blackberry/i',$user_agent)):
  	$mskeleton = 'skeletonmobileblackberry';
  break; 
  case (preg_match('/(palm os|palm|hiptop|avantgo|plucker|xiino|blazer|elaine)/i',$user_agent)):
  	$mskeleton = 'skeletonmobilepalm';
  break;
  case (preg_match('/(windows ce; ppc;|windows mobile;|windows ce; smartphone;|windows ce; iemobile)/i',$user_agent)):
  	$mskeleton = 'skeletonmobilewindows';
  break;
}

if($isMobile && $tp_mobilemode)
{
	$arrCssP = array();
	$arrCssP = array(
		'theme' => $this->template,
		'base' => str_replace("/", "~", JURI::base()),
		'skeleton' => $tp_skeleton,
		'mobile' => $tp_mobilemode,
		'mskeleton' => $mskeleton,
		'ismobile' => $is_Mobile,

		'hua' => urlencode( $_SERVER['HTTP_USER_AGENT'] ),
		'hh' => urlencode( $_SERVER['HTTP_HOST'] )
	);
}
else
{
	$direction = $this->direction;
	$sess =& JFactory::getSession();
	$switch_to = (!empty($_GET['switchto'])) ? $_GET['switchto'] : null;
	if(!empty($switch_to))
	{
		$sess->set('tp_switch_to', $switch_to);
	}
	else
	{
		$switch_to = $sess->get('tp_switch_to');
	}

	$arrCssP = array(
		'theme' => $this->template,
		'base' => str_replace("/", "~", JURI::base()),
		'tptheme' => $tptheme,
		'skeleton' => $tp_skeleton,
		'mobile' => $tp_mobilemode,
		'mskeleton' => $mskeleton,
		'ismobile' => $is_Mobile,
		'switch' => $switch_to,
	
		'tpleft' => $tp->left,
		'tpafterleft' => $tp->afterleft,
		'tpbeforeleft' => $tp->beforeleft,

		'tpright' => $tp->right,
		'tpafterright' => $tp->afterright,
		'tpbeforeright' => $tp->beforeright,

		'tpuser1' => $tp->user1,
		'tpuser2' => $tp->user2,

		'tpuser5' => $tp->user5,
		'tpuser6' => $tp->user6,

		'tpuser11' => $tp->user11,
		'tpuser12' => $tp->user12,
		'tpuser13' => $tp->user13,
		'tpuser14' => $tp->user14,
		'tpuser21' => $tp->user21,
		'tpuser22' => $tp->user22,
		'tpuser23' => $tp->user23,
		'tpuser24' => $tp->user24,
	
		'tpadvert1' => $tp->advert1,
		'tpadvert2' => $tp->advert2,
		'tpadvert3' => $tp->advert3,
		'tpadvert4' => $tp->advert4,

		'tpwidth_templatewidth' => intval($this->params->get('tp_templatewidth')),
		'tpwidth_logowidth' => intval($this->params->get('tp_logowidth')),
		'tpwidth_blockleft' => intval($this->params->get('tp_blockleftwidth')),
		'tpwidth_tpwrapper_inner_right' => intval($this->params->get('tp_blockrightwidth')),
		'tpgutter' => intval($this->params->get('tp_gutter')),
		'tpheight_blockhead' => intval($this->params->get('tp_blockheadheight')),
		'tpbackgroundimgpath' => $this->params->get('tp_backgroundimgpath'),
		'tpbackgroundcolor' => $this->params->get('tp_backgroundcolor'),
		'tplogoplacement' => $tp_logoplacement,
		
		'tpblocktoptype' => $this->params->get('tp_blocktoptype'),
		'tpblockbottype' => $this->params->get('tp_blockbottype'),
		
		'ffp' => $ffp,
		'ffs' => $ffs,
		'fft' => $fft,
	
		'fsp' => $fsp,
		'fss' => $fss,
		'fst' => $fst,

		'direction' => $direction,

		'hua' => urlencode( $_SERVER['HTTP_USER_AGENT'] ),
		'hh' => urlencode( $_SERVER['HTTP_HOST'] )
	);
}

$cssgets = "?" . http_build_query($arrCssP, '', '&amp;');

if($isMobile && $tp_mobilemode)
{
	$jsgets = null;
}
else
{
	$arrJsP = array(
		'cfc' => $tp_cufon_in_content,
		'cfmb' => $tp_cufon_in_module_block,
		'cfacc' => $tp_cufon_in_accordion_font,
		'cfmf' => $tp_cufon_in_module_font,
		'cftpp' => $tp_cufon_in_tpmenu_parent,
		'cftpps' => $tp_cufon_in_tpmenu_parent_sub,
		'cftpc' => $tp_cufon_in_tpmenu_child,
		'cftpcs' => $tp_cufon_in_tpmenu_child_sub
		/*
		'cftpa' => $tp_cufon_in_tpaccordion,
		'cftpaf' => $tp_cufon_in_tpaccordion_font
		*/
	);
	$jsgets = "?" . http_build_query($arrJsP, '', '&amp;');
}

?>