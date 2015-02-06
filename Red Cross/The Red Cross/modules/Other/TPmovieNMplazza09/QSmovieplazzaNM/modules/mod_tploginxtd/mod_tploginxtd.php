<?php

// no direct access
defined('_JEXEC') or die('Restricted access');

$w_login = '325px'; // login form width
$h_login = '400px'; // login form height

$w_register = '325px'; // register form width
$h_register = '500px'; // register form height

$w_contact = '325px'; // contact form width
$h_contact = '630px'; // contact form height

$lang =& JFactory::getLanguage();
$lang->load('mod_login', JPATH_SITE);

$user =& JFactory::getUser();

$document = &JFactory::getDocument();  

// Include the syndicate functions only once
require_once (dirname(__FILE__).DS.'helper.php');

$params->def('greeting', 1);
$type 	= modTPLoginXtdHelper::getType();
$return	= modTPLoginXtdHelper::getReturnURL($params, $type);

$enable_login = $params->get('enable_login');
$enable_register = $params->get('enable_register');
$enable_contact = $params->get('enable_contact');

$link_style = $params->get('link_style');

$contactid = $params->get('contactid');

if( $enable_login OR $enable_register OR $enable_contact )
{
	?>
	<script type="text/javascript" language="javascript">
		var rl_box_hide_div_holder;
		var rl_box_hide_div = document.getElementsByTagName("DIV");33
		for (var rl_box_hide_div_y=0; rl_box_hide_div_y<rl_box_hide_div.length; rl_box_hide_div_y++)
		{
			rl_box_hide_div_holder = rl_box_hide_div[rl_box_hide_div_y].className;
			if (rl_box_hide_div_holder.indexOf("-rl_box") > 0)
			{
				rl_box_hide_div[rl_box_hide_div_y].style.display = "none";
			}
		}
	</script>
	<?php
	$jquery = JPATH_SITE . DS . 'templates' . DS . $mainframe->getTemplate() . DS . 'scripts' . DS . 'js' . DS . 'jquery.js';
	if( file_exists( $jquery ) )
	{
		$document->addScript('templates/'.$mainframe->getTemplate().'/scripts/js/jquery.js');
		$document->addScript('templates/'.$mainframe->getTemplate().'/scripts/js/jquery.no.conflict.js');
	}
	else
	{
		$document->addScript('modules/mod_tploginxtd/assets/js/jquery.min.js');
		$document->addScript('modules/mod_tploginxtd/assets/js/jquery.no.conflict.js');
	}
	$document->addScript('modules/mod_tploginxtd/assets/js/jquery.colorbox.js');
	$document->addStyleSheet('modules/mod_tploginxtd/assets/css/colorbox.css');
	$br = strtolower($_SERVER['HTTP_USER_AGENT']); // what browser.
	if(ereg("msie", $br))
	{
		$document->addStyleSheet('modules/mod_tploginxtd/assets/css/colorbox-ie.css');
	} 

	JHTML::_('behavior.mootools');
	$document->addScript(JURI::base() . 'modules/mod_tploginxtd/assets/js/SendForm.js');

	$document->addScriptDeclaration("
		window.addEvent('domready', function(){
			new AjaxForm({
				dirname: '".JURI::base()."modules/mod_tploginxtd/assets/',
				captchaImageId: 'captcha_image',
				formId: 'emailFormXtd',
				sendTo: '".JURI::base()."modules/mod_tploginxtd/assets/ajax_validate.php',
				messages: 'send_responses',
				loadingMessage:'<img src=\"modules/mod_tploginxtd/assets/images/indicator.gif\">',
				captchaRefresh: 'captcha_refresh'
			});
		}.bind(this))
	");

	$jsscript = 'jQuery(document).ready(function(){';
	$jsscript .= ( $enable_login && !$user->id ) ? 'jQuery(".rlbox_login").colorbox({width:"'.$w_login.'", height:"'.$h_login.'", inline:true, href:"#rlbox_login"});' : '';
	$jsscript .= ( $enable_register ) ? 'jQuery(".rlbox_register").colorbox({width:"'.$w_register.'", height:"'.$h_register.'", inline:true, href:"#rlbox_register"});' : '';
	$jsscript .= ( $enable_contact ) ? 'jQuery(".rlbox_contact").colorbox({width:"'.$w_contact.'", height:"'.$h_contact.'", inline:true, href:"#rlbox_contact"});' : '';
	$jsscript .= '});';
	
	$document->addScriptDeclaration( $jsscript );

	if( $user->id )
	{
		$document->addStyleSheet('modules/mod_tploginxtd/assets/css/logout.css');
	}

	require(JModuleHelper::getLayoutPath('mod_tploginxtd'));
}

?>