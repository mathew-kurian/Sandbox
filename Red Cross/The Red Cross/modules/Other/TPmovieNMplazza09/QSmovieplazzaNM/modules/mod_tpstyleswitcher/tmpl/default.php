<?php

// no direct access
defined('_JEXEC') or die('Restricted access');

?>
<div>
<form action="index.php" method="get">

	<span>Theme</span>

	<?php echo str_replace("params[tp_templatetheme]", "tptheme", $arrParams['tp_templatetheme'][1]); ?>


	<span>Primary Font Family</span>

	<?php echo str_replace("params[tp_primaryfontfam]", "ffp", $arrParams['tp_primaryfontfam'][1]); ?>



	<span>Secondary Font Family</span>

	<?php echo str_replace("params[tp_secondaryfontfam]", "ffs", $arrParams['tp_secondaryfontfam'][1]); ?>



	<span>Tertiery Font Family</span>

	<?php echo str_replace("params[tp_tertieryfontfam]", "fft", $arrParams['tp_tertieryfontfam'][1]); ?>

	<span>Primary Font Size</span>

	<?php echo str_replace("params[tp_primaryfontsize]", "fsp", $arrParams['tp_primaryfontsize'][1]); ?>

	<span>Secondary Font Size</span>

	<?php echo str_replace("params[tp_secondaryfontsize]", "fss", $arrParams['tp_secondaryfontsize'][1]); ?>



	<span>Tertiery Font Size</span>

	<?php echo str_replace("params[tp_tertieryfontsize]", "fst", $arrParams['tp_tertieryfontsize'][1]); ?>

<input type="submit" value="Apply" class="button" />
</form>
</div>