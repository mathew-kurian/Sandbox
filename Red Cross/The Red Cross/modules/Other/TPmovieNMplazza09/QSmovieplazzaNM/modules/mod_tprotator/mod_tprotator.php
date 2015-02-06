<?php
	/**
	* TemplatePlazza
	* TemplatePlazza.com 
	**/
	defined('_JEXEC') or die('Restricted access');
	require_once (dirname(__FILE__).DS.'helper.php');
	$list = modTPRotatorHelper::getList($params);
	require(JModuleHelper::getLayoutPath('mod_tprotator'));
?>