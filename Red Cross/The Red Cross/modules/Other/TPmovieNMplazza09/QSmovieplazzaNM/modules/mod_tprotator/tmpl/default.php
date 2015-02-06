<?php
	/**
	* TemplatePlazza
	* TemplatePlazza.com 
	**/
	defined('_JEXEC') or die('Restricted access');
	$headtag	= '
		<script type="text/javascript" src="' . JURI::base(true) . '/modules/mod_tprotator/tmpl/moostick.js"></script>
		<link rel="stylesheet" href="' . JURI::root() . '/modules/mod_tprotator/tmpl/tprotator.css" type="text/css" />
	';
	$mainframe->addCustomHeadTag($headtag);
?>
	<ul id="tpmoostick" class="moostick">
	<?php
		foreach ($list as $item):
			$filter			= new JFilterInput();
			$desc = $filter->clean($item->intro);
			if(strlen($desc) > 1500){
				$desc = substr($desc, 0, 1500) . " ...";
			}else{
				$desc = $desc;
			}
	?>
		<li style="visibility: hidden;"><a href="<?php echo $item->link; ?>"><?php echo $item->text; ?></a></li>
	<?php endforeach; ?>
	</ul>