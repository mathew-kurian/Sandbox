<?php

/**
* This file is a part of mod_tpnewsticker package
* Author: http://www.templateplazza.com
* Creator: Jerry Wijaya ( me@jerrywijaya.com )
*/

// no direct access
defined('_JEXEC') or die('Restricted access');

?>
<div class="tpndefwrp"><?php if($show_ticker_title) { ?> <div class="ticker_text_wrp"><strong><?php echo $ticker_title_text; ?> </strong> &nbsp;</div> <?php } ?>
<ul id="tpnewsticker<?php echo $mid; ?>" class="moostick">
	<?php foreach ($list as $item) :?>
	<li>
		<?php
		if($show_date==1) {
			echo date($date_format, strtotime($item->created));
			echo '&nbsp;';
		} else if ($show_date==2) {
			echo date("d m Y", strtotime($item->modified));
			echo '&nbsp;';
		}
		?>
		<a href="<?php echo $item->link; ?>"><?php echo $item->text; ?></a>
	</li>
	<?php endforeach; ?>
</ul>
</div>