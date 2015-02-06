<?php

// no direct access
defined('_JEXEC') or die('Restricted access');

if( count( $lists ) )
{

	$n = 0;
	
	foreach( $lists as $list )
	{
		$n++;
		if( $n == 1 )
		{
		?>
		<div class="tpboxofficetop5">
		<?php
		}
		elseif( $n == 6 )
		{
		?>
		<div class="tpboxofficetop10" id="tpboxofficetop10_<?php echo $mid; ?>">
		<?php
		}
		?>
		<div class="tpboxoffice_item">
			<span class="tpboxoffice_icon"><img src="<?php echo JURI::base(); ?>modules/mod_tpboxoffice/assets/images/<?php echo $list->icon; ?>"></span>
			<span class="tpboxoffice_title"><a href="<?php echo $list->url; ?>"><?php echo $list->title; ?></a></span>
			<span class="tpboxoffice_revenue"><?php echo $list->revenue; ?></span>
			<div class="clrfix"></div>
		</div>
		<?php
		if( $n == 5 || ( $n == count( $lists ) && $n <= 5 ) )
		{
		?>
		</div>
		<?php
		}
		elseif( $n == 10 || ( $n == count( $lists ) && $n >= 6 ) )
		{
		?>
		</div>
		<?php
		}
	}
	
	if( count( $lists ) >= 6 && $toggle == '1' )
	{
		?>
		<div id="tpboxoffice_show_hide_<?php echo $mid; ?>"><div id="tpboxofficetop_arrow_<?php echo $mid; ?>" class="tpboxoffice_hide"></div></div>
		<?php
	}
	
	if( $toggle == '1' )
	{
		$script = "window.addEvent('domready', function(){ var tbo_".$mid." = new Fx.Slide('tpboxofficetop10_".$mid."'); tbo_".$mid.".hide(); var status_".$mid." = false; var tboarrow_".$mid." = $('tpboxofficetop_arrow_".$mid."');  $('tpboxoffice_show_hide_".$mid."').addEvent('click', function(e){ e = new Event(e); tbo_".$mid.".toggle(); status_".$mid." = (status_".$mid.") ? false : true; if( status_".$mid." ) { tboarrow_".$mid.".removeClass('tpboxoffice_hide'); tboarrow_".$mid.".addClass('tpboxoffice_show'); } else { tboarrow_".$mid.".removeClass('tpboxoffice_show'); tboarrow_".$mid.".addClass('tpboxoffice_hide'); } e.stop(); }); }); ";
		$document->addScriptDeclaration( $script );
	}
}

?>