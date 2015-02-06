<?php // no direct access
defined('_JEXEC') or die('Restricted access');

$app =& JFactory::getApplication();
require_once( JPATH_BASE . DS . 'templates' . DS . $app->getTemplate() . DS . 'scripts' . DS . 'php' . DS . 'tpframework.php' );
tpFramework::loadTheme(__FILE__);

?>