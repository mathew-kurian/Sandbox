<?php
/**
TPBox2 for Joomla 1.5
Mambot System for Fancy Box Mambot
http://www.templateplazza.com
by Jerry Wijaya
*/

// no direct access
defined( '_JEXEC' ) or die( 'Restricted access' );
$mainframe->registerEvent( 'onPrepareContent', 'botTPBox2' );

function botTPBox2( &$row, &$params, $page=0 ) {
	
	// simple performance check to determine whether bot should process further
	if ( strpos( $row->text, 'tpbox2' ) === false ) {
		return true;
	}

	$arrayFind = array("type", "target", "title", "group", "width", "height");
	if(preg_match_all("#{tpbox2(.*?){/tpbox2}#s", $row->text, $matches, PREG_PATTERN_ORDER) > 0) {
		global $mosConfig_live_site, $mainframe;
		if(!defined( '_VALID_TPBOX2' )) {
			$document = &JFactory::getDocument();  
			if($document->getType() == 'html') {
				$jquery = JPATH_SITE . DS . 'templates' . DS . $mainframe->getTemplate() . DS . 'scripts' . DS . 'js' . DS . 'jquery.js';
				if( file_exists( $jquery ) )
				{
					$document->addScript('templates/'.$mainframe->getTemplate().'/scripts/js/jquery.js');
					$document->addScript('templates/'.$mainframe->getTemplate().'/scripts/js/jquery.no.conflict.js');
				}
				else
				{
					$document->addScript('plugins/content/tpbox2/jquery.js');
					$document->addScript('plugins/content/tpbox2/jquery.no.conflict.js');
				}
				
				$document->addScript('plugins/content/tpbox2/jquery.easing.1.3.js');
				$document->addStyleSheet( 'plugins/content/tpbox2/jquery.fancybox-1.2.6.css' );
				$document->addScript('plugins/content/tpbox2/jquery.fancybox-1.2.6.pack.js');
				
			  $plugin =& JPluginHelper::getPlugin( 'content', 'tpbox2' );
			  $tpboxparams = new JParameter( $plugin->params );

				$zoomopacity = ( $tpboxparams->get( 'zoomopacity' ) ) ? 'true' : 'false';
				$overlayshow = ( $tpboxparams->get( 'overlayshow' ) ) ? 'true' : 'false';
				$hideoncontentclick = ( $tpboxparams->get( 'hideoncontentclick' ) ) ? 'true' : 'false';
				$animatedoption = $tpboxparams->get( 'animatedoption' );
				$zoomspeedin = $tpboxparams->get( 'zoomspeedin', '500' );
				$zoomspeedout = $tpboxparams->get( 'zoomspeedout', '500' );
				$easingin = $tpboxparams->get( 'easingin', 'easeInBack' );
				$easingout = $tpboxparams->get( 'easingout', 'easeOutBack' );

				switch( $animatedoption )
				{
					case '1':
						$customJS = '
							jQuery(document).ready(function() {
								jQuery("a.tpboximage").fancybox({
									\'hideOnContentClick\': '.$hideoncontentclick.',
									\'zoomOpacity\' : '.$zoomopacity.',
									\'overlayShow\' : '.$overlayshow.',
									\'zoomSpeedIn\' : '.$zoomspeedin.',
									\'zoomSpeedOut\' : '.$zoomspeedout.'
								});
								
								jQuery("a.tpboxgroup").fancybox({
									\'hideOnContentClick\': '.$hideoncontentclick.',
									\'zoomOpacity\' : '.$zoomopacity.',
									\'overlayShow\' : '.$overlayshow.',
									\'zoomSpeedIn\' : '.$zoomspeedin.',
									\'zoomSpeedOut\' : '.$zoomspeedout.'
								});
							});
						';
					break;
					case '2':
						$customJS = '
							jQuery(document).ready(function() {
								jQuery("a.tpboximage").fancybox({
									\'hideOnContentClick\': '.$hideoncontentclick.',
									\'zoomOpacity\' : '.$zoomopacity.',
									\'overlayShow\' : '.$overlayshow.',
									\'zoomSpeedIn\' : '.$zoomspeedin.',
									\'zoomSpeedOut\' : '.$zoomspeedout.',
									\'easingIn\' : \''.$easingin.'\',
									\'easingOut\' : \''.$easingout.'\'
								});
								
								jQuery("a.tpboxgroup").fancybox({
									\'hideOnContentClick\': '.$hideoncontentclick.'
								});
							});
						';
					break;
					default:
						$customJS = '
							jQuery(document).ready(function() {
								jQuery("a.tpboximage").fancybox({
									\'hideOnContentClick\': '.$hideoncontentclick.',
									\'zoomOpacity\' : '.$zoomopacity.',
									\'overlayShow\' : '.$overlayshow.'
								});
								
								jQuery("a.tpboxgroup").fancybox({
									\'hideOnContentClick\': '.$hideoncontentclick.',
									\'zoomOpacity\' : '.$zoomopacity.',
									\'overlayShow\' : '.$overlayshow.'
								});
							});
						';
					break;
				}				

				$document->addScriptDeclaration($customJS);
			}
			define( '_VALID_TPBOX2', 1 );
		}

		for( $n=0; $n < count( $matches[0] ); $n++ )
		{
			$mb = $n+1;
		  preg_match_all( "#}}(.*?){/tpbox2}#s", $matches[0][$n], $m1, PREG_PATTERN_ORDER );
		  $content = $m1[1][0];
			foreach( $arrayFind as $find )
			{
			  preg_match_all( "#".$find."={(.*?)}#s", $matches[0][$n], $m2, PREG_PATTERN_ORDER );
			  $$find = ( !empty( $m2[1][0] ) ) ? $m2[1][0] : null;
			}

			$group = ( empty( $group ) ) ? rand() : $group;
			switch( strtolower( $type ) )
			{
				case "image":
					$newText = '<div class="tpbox2img"><a class="tpboximage" title="'.$title.'" href="'.$target.'">'.tpbox2_unhtmlentities($content).'</a></div>';
					$row->text = str_replace($matches[0][$n], $newText, $row->text);
					break;
				case "url":
					$newText = '<div class="tpbox2url"><a class="tpboxgroup iframe" href="'.$target.'" title="'.$title.'">'.tpbox2_unhtmlentities($content).'</a></div>';
					$row->text = str_replace($matches[0][$n], $newText, $row->text);
					break;
				case "youtube":
					$width 		= ( empty( $width ) ) ? '560' : $width;
					$height 	= ( empty( $height ) ) ? '340' : $height;
					$no 			= rand();
					$newText 	= '<div class="tpbox2tube"><a class="tpboxgroup" href="#tbbox2tube_'.$no.'">'.tpbox2_unhtmlentities($content).'</a>';
					$newText 	.= '<div style="display: none;" id="tbbox2tube_'.$no.'">';
					$newText 	.= '<object height="'.$height.'" width="'.$width.'"><param name="movie" value="http://www.youtube.com/v/M'.$target.'&amp;hl=en&amp;fs=1&amp;"><param name="allowFullScreen" value="true"><param name="allowscriptaccess" value="always"><embed src="http://www.youtube.com/v/M-cIjPOJdFM&amp;hl=en&amp;fs=1&amp;" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" height="'.$height.'" width="'.$width.'"></object>';
					$newText 	.= '</div>';

					$row->text = str_replace($matches[0][$n], $newText, $row->text);
					break;
			}
		}
	}
}

if(!function_exists('tpbox2_unhtmlentities')) {
	function tpbox2_unhtmlentities($string){
		// replace numeric entities
		$string = preg_replace('~&#x([0-9a-f]+);~ei', 'chr(hexdec("\\1"))', $string);
		$string = preg_replace('~&#([0-9]+);~e', 'chr("\\1")', $string);
		// replace literal entities
		$trans_tbl = get_html_translation_table(HTML_ENTITIES);
		$trans_tbl = array_flip($trans_tbl);
		return strtr($string, $trans_tbl);
	}
}
?>