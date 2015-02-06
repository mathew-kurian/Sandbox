<?php

/**
* This file is a part of mod_tpnewsticker package
* Author: http://www.templateplazza.com
* Creator: Jerry Wijaya ( me@jerrywijaya.com )
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

// Include the syndicate functions only once
require_once (dirname(__FILE__).DS.'helper.php');

$list = modTPNewsTickerHelper::getList($params);

$layout = $params->get('layout', 'default');
$layout = JFilterInput::clean($layout, 'word');

$document =& JFactory::getDocument();
$document->addCustomTag( '<link rel="stylesheet" type="text/css" href="'. JURI::base() . 'modules/mod_tpnewsticker/css/tpnewsticker.css" title="default" />' );

$load_mootools = (int) $params->get('load_mootools', 0);
if($load_mootools) {
	$document->addCustomTag( '<script type="text/javascript" src="'. JURI::base() . 'modules/mod_tpnewsticker/js/mootools.js"></script>' );
}

$mid = rand();

$duration = (int) $params->get('duration', 500);
$delay = (int) $params->get('duration', 3000);

$show_button_play = (int) $params->get('show_button_play', 0);
$show_button_pause = (int) $params->get('show_button_pause', 0);
$show_button_prev = (int) $params->get('show_button_prev', 0);
$show_button_next = (int) $params->get('show_button_next', 0);
$show_ticker_title = (int) $params->get('show_ticker_title', 0);
$ticker_title_text = $params->get('ticker_title_text', 'Headlines');
$auto_play = ((int) $params->get('auto_play', 0)) ? 'true' : 'false';

switch($layout) {
	case 'horizontal_left_to_right':
	case 'horizontal_right_to_left':
	case 'vertical_top_to_bottom':
	case 'vertical_bottom_to_top':
		$theLayout = 'scroll';

		$document->addCustomTag( '<script type="text/javascript" src="'. JURI::base() . 'modules/mod_tpnewsticker/js/tpnewsticker.js"></script>' );
		$customJS = '
		<script type="text/javascript">
		<!--
		window.addEvent(\'domready\', function() {
		var opt = {
		  slides: \'tpnewstickerli\',
		  duration: '.$duration.',
		  delay: '.$delay.',
		  auto:'.$auto_play.',
		';
		switch($layout) {
			case 'horizontal_left_to_right':
			$customJS .= '
		  direction: \'h\',
		  hScroll: \'left\',
		  ';
			break;
			case 'horizontal_right_to_left':
			$customJS .= '
		  direction: \'h\',
		  hScroll: \'right\',
		  ';
			break;
			case 'vertical_top_to_bottom':
			$customJS .= '
		  direction: \'v\',
		  vScroll: \'top\',
			';
			break;
			case 'vertical_bottom_to_top':
			default:
			$customJS .= '
		  direction: \'v\',
		  vScroll: \'bottom\',
			';
		}
			$buttons = array();
			if($show_button_next) { $buttons[] = 'next:\'go-next'.$mid.'\''; }
			if($show_button_prev) { $buttons[] = 'prev:\'go-prev'.$mid.'\''; }
			if($show_button_play) { $buttons[] = 'play:\'play'.$mid.'\''; }
			if($show_button_pause) { $buttons[] = 'stop:\'stop'.$mid.'\''; }
			if(count($buttons)) {
				$buttons = implode(",", $buttons);
				$customJS .= '
			    buttons: {'.$buttons.'},
			  ';
			}
			$customJS .= '
		  transition:Fx.Transitions.Quart.easeIn
		}
		var scroller = new QScroller(\'tpnewsticker'.$mid.'\',opt);
		scroller.load();
		});
		//-->
		</script>
		';
		$document->addCustomTag($customJS);
		break;
	default:
		$theLayout = $layout;
		$document->addCustomTag( '<script type="text/javascript" src="'. JURI::base() . 'modules/mod_tpnewsticker/js/tpnewstickerfade.js?init=false"></script>' );
		$customJS = '
		<script type="text/javascript">
		<!--
		window.addEvent(\'domready\', function() {
		 	new Moostick($($(\'tpnewsticker'.$mid.'\'), true, '.$delay.', false, true);
		});
		//-->
		</script>
		';
		$document->addCustomTag( $customJS );
}

$path = JModuleHelper::getLayoutPath('mod_tpnewsticker', $theLayout);

if (!file_exists($path)) {
	$path = JModuleHelper::getLayoutPath('mod_tpnewsticker');
}

if (file_exists($path)) {
	$show_date = (int) $params->get('show_date', 0);
	$date_format = $params->get('date_format', 'd/m/y');
	$height = (int) $params->get('height', 20);
	$width = (int) $params->get('width', 200);
	$customCSS = '
	<style type="text/css">
	#tpnewsticker'.$mid.' {
		position: relative;
		width:'.$width.'px;
		height:'.$height.'px;
	}
	</style>
	';
	$document->addCustomTag( $customCSS );
	require($path);
}