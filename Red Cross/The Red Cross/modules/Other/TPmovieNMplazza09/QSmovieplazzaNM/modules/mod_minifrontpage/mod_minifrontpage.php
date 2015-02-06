<?php

// no direct access
defined( '_JEXEC' ) or die( 'Restricted access' );

// Include the syndicate functions only once
require_once (JPATH_SITE.DS.'components'.DS.'com_content'.DS.'helpers'.DS.'route.php');
require_once( dirname(__FILE__).DS.'helper.php' );

// Set the path definitions
if(!defined('MOD_MINIFRONTPAGE_BASE')) {
	define('MOD_MINIFRONTPAGE_BASE', JPATH_SITE.DS.$params->get('image_path', 'images'.DS.'stories'));
	$document =& JFactory::getDocument();
	$document->addCustomTag( '<link rel="stylesheet" type="text/css" href="'. JURI::base() . 'modules/mod_minifrontpage/css/style.css" title="default" />' );
}
if(!defined('MOD_MINIFRONTPAGE_BASEURL')) {
	define('MOD_MINIFRONTPAGE_BASEURL', JURI::base().$params->get('image_path', 'images/stories'));
}

if(!defined('MOD_MINIFRONTPAGE_THUMB_BASE')) {
	define('MOD_MINIFRONTPAGE_THUMB_BASE', JPATH_SITE.DS.$params->get('image_path', 'images'.DS.'stories'.DS.'minifp'));
}
if(!defined('MOD_MINIFRONTPAGE_THUMB_BASEURL')) {
	define('MOD_MINIFRONTPAGE_THUMB_BASEURL', JURI::base().$params->get('image_path', 'images/stories/minifp/'));
}

if(!file_exists(MOD_MINIFRONTPAGE_THUMB_BASE)) {
	if(mkdir(MOD_MINIFRONTPAGE_THUMB_BASE)) {
		JPath::setPermissions(MOD_MINIFRONTPAGE_THUMB_BASE, '0777');
	}
} else {
	if(!is_dir(MOD_MINIFRONTPAGE_THUMB_BASE)) {
		if(mkdir(MOD_MINIFRONTPAGE_THUMB_BASE)) {
			JPath::setPermissions(MOD_MINIFRONTPAGE_THUMB_BASE, '0777');
		}
	}
}
		
// if there's no image in an article, give it a default one - change image name here if you have one
if(!defined('MOD_MINIFRONTPAGE_DEFAULT_BASE')) {
	define('MOD_MINIFRONTPAGE_DEFAULT_BASE', JPATH_SITE.DS.$params->get('image_path', 'modules'.DS.'mod_minifrontpage'.DS.'images'));
}
if(!defined('MOD_MINIFRONTPAGE_DEFAULT_BASEURL')) {
	define('MOD_MINIFRONTPAGE_DEFAULT_BASEURL', JURI::base().$params->get('image_path', 'modules/mod_minifrontpage/images'));
}
if(!defined('MOD_MINIFRONTPAGE_DEFAULT_IMAGE')) {
	define('MOD_MINIFRONTPAGE_DEFAULT_IMAGE', 'default.gif');
}

// Get Module Parameters (needed by default.php)
$moduleclass_sfx 		 = $params->get( 'moduleclass_sfx', '' );
$columns 						 = intval( $params->get( 'columns', 1 ) );
$cat_title 		 			 = intval( $params->get( 'cat_title', 0 ) );
$cat_title_link 		 = intval( $params->get( 'cat_title_link', 0 ) );
$show_title 	 			 = intval( $params->get( 'show_title', 1 ) );
$num_intro 					 = intval( $params->get( 'num_intro', 1) );
$columns 						 = intval( $params->get( 'columns', 1 ) );
$count 							 = intval( $params->get( 'count', 5 ) );
$loadorder 		 			 = intval( $params->get( 'loadorder', 1 ) );
$title_link 	 			 = intval( $params->get( 'title_link', 1 ) );
$show_author     		 = intval( $params->get( 'show_author', 0 ) );
$show_author_type  	 = intval( $params->get( 'show_author_type', 0 ) );
$show_date 	     		 = intval( $params->get( 'show_date', 0 ) );
$fulllink 		 			 = $params->get( 'fulllink','' );
$header_title_links  = $params->get( 'header_title_links', "" );
$limit 			 				 = intval( $params->get( 'limit', 200 ) );
$thumb_embed 				 = intval( $params->get( 'thumb_embed', 0 ) );
$thumb_width 				 = intval( $params->get( 'thumb_width', 32 ) );
$thumb_height 			 = intval( $params->get( 'thumb_height', 32 ) );
$aspect 						 = intval( $params->get( 'aspect', 0 ) );
$thumb_embed_default = intval( $params->get( 'thumb_embed_default', 1 ) );

if ($columns > 4) $columns = 4; // limit number of columns
$anotherlink = ( ($count - $num_intro) ==0 ) ? 0 : 1 ;

$sep = " | "; // separator between articles date and creator

// css classes - hardcoded
$class_date 					= "minifp-date";
$class_author 				= "minifp-date";
$class_another_links 	= "minifp-anotherlinks";
$class_minifulllink 	= "minifp-full_link";
$class_introtitle 		= 'minifp-introtitle';
$class_categoria 			= 'minifp-anotherlinks';

$rows = modMiniFrontPageHelper::getList( $params );
require( JModuleHelper::getLayoutPath( 'mod_minifrontpage' ) );

?>