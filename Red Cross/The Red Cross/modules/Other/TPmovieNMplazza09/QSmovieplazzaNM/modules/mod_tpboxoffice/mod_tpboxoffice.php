<?php

// no direct access
defined( '_JEXEC' ) or die( 'Restricted access' );

$document = &JFactory::getDocument();  

if( !defined( '_TPBOXOFFICE_' ) )
{
	$document->addStyleSheet( 'modules/mod_tpboxoffice/assets/style.css' );
	$document->addScript( 'modules/mod_tpboxoffice/assets/toggle.js' );
	define( '_TPBOXOFFICE_', 1 );
}

require_once ( dirname(__FILE__) . DS . 'helper.php' );
$mid = $module->id;
$toggle = $params->get( 'toggle' );

$lists = modTPBoxOffice::getLists( $params );
require ( JModuleHelper::getLayoutPath( 'mod_tpboxoffice' ) );

?>