<?php

/**
* This file is a part of mod_tpnewsticker package
* Author: http://www.templateplazza.com
* Creator: Jerry Wijaya ( me@jerrywijaya.com )
*/

// no direct access
defined('_JEXEC') or die('Restricted access');


if($show_button_prev || $show_button_next || $show_button_play || $show_button_pause) {
?>
<div class="tpndefwrp">
<div class="tpnewsticker_nav">
	<?php if($show_ticker_title) { ?> <strong><?php echo $ticker_title_text; ?> </strong> <?php } ?>
	<?php if($show_button_prev) { ?>
  <a id="go-prev<?php echo $mid; ?>" href="javascript:void(0)">
  	<img src="modules/mod_tpnewsticker/images/b-prev.png" alt="Previous" border="0" width="14" height="13"/>
  </a>
	<? } ?>
	<?php if($show_button_play) { ?>
  <a id="play<?php echo $mid; ?>" href="javascript:void(0)">
  	<img src="modules/mod_tpnewsticker/images/b-play.png" alt="Play" border="0" width="12" height="13"/>
  </a>
	<? } ?>
	<?php if($show_button_pause) { ?>
  <a id="stop<?php echo $mid; ?>" href="javascript:void(0)">
  	<img src="modules/mod_tpnewsticker/images/b-pause.png" alt="Pause" border="0" width="13" height="13"/>
  </a>
	<? } ?>
	<?php if($show_button_next) { ?>
  <a id="go-next<?php echo $mid; ?>" href="javascript:void(0)">
  	<img src="modules/mod_tpnewsticker/images/b-next.png" alt="Next" border="0" width="14" height="13"/>
  </a>
	<? } ?>
</div>
<?
}
?>

<div id="tpnewsticker<?php echo $mid; ?>" class="tpnewsticker"></div>
<div class="hide">
<?php foreach ($list as $item) :  ?>
	<div class="tpnewstickerli">
		<?php
		if($show_date==1) {
			echo date($date_format, strtotime($item->created));
			echo '&nbsp;';
		} else if ($show_date==2) {
			echo date("d m Y", strtotime($item->modified));
			echo '&nbsp;';
		}
		?>
		<a href="<?php echo $item->link; ?>">
			<?php echo $item->text; ?>
		</a>
	</div>
<?php endforeach; ?>
</div>
<div style="clear:both;"></div>
</div>