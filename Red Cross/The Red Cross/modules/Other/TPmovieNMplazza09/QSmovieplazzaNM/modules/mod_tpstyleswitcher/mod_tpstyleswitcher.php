<?php

// no direct access
defined('_JEXEC') or die('Restricted access');

require_once (dirname(__FILE__).DS.'helper.php');

$app =& JFactory::getApplication();
$templateDir = JPATH_BASE . DS .  'templates' . DS . $app->getTemplate();

$ini	= $templateDir.DS.'params.ini';
$xml	= $templateDir.DS.'templateDetails.xml';
$row	= modTPStyleSwitcherHelper::parseXMLTemplateFile($templateDir);

jimport('joomla.filesystem.file');

// Read the ini file
if (JFile::exists($ini))
{
	$cini = JFile::read($ini);
}
else
{
	$cini = null;
}

$params = new JParameter($cini, $xml, 'template');
if( $params->get('tp_styleswitcherstate') == 0 )
{
	echo "Style Switcher is disabled by template parameter setting";
}
else
{
	$superDefaultTheme= $params->get('tp_templatetheme');  

	$superDefaultFontSizePrimary = $params->get('tp_primaryfontsize'); 
	$superDefaultFontSizeSecondary = $params->get('tp_secondaryfontsize'); 
	$superDefaultFontSizeTertiery = $params->get('tp_tertieryfontsize'); 
	
	$superDefaultFontFamilyPrimary = $params->get('tp_primaryfontfam');
	$superDefaultFontFamilySecondary = $params->get('tp_secondaryfontfam');
	$superDefaultFontFamilyTertiery = $params->get('tp_tertieryfontfam');

	require( $templateDir.DS.'scripts'.DS.'php'.DS.'validvalues.php' );

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
		$fft = isset($_COOKIE['tp_fft']) ? $_COOKIE['tp_fft'] : $superDefaultFontFamilySecondary;
	}

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
		$fst = isset($_COOKIE['tp_fst']) ? $_COOKIE['tp_fst'] : $superDefaultFontSizeSecondary;
	}

	$params->set('tp_templatetheme', $tptheme);
	$params->set('tp_primaryfontsize', $fsp);
	$params->set('tp_secondaryfontsize', $fss);
	$params->set('tp_tertieryfontsize', $fst);
	$params->set('tp_primaryfontfam', $ffp);
	$params->set('tp_secondaryfontfam', $ffs);
	$params->set('tp_tertieryfontfam', $fft);

	$arrParams = $params->renderToArray();
	require(JModuleHelper::getLayoutPath('mod_tpstyleswitcher'));
}

?>