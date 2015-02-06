<?php
/**
* TemplatePlazza Custom Module Output
* TemplatePlazza.com 
**/
// no direct access
defined('_JEXEC') or die('Restricted access');

function modChrome_xhtmltp($module, &$params, &$attribs)
{
	$real_title = $module->title;
	$real_title = explode("||", $real_title);
	$title = $real_title[0];
	$sub_title = (!empty($real_title[1])) ? $real_title[1] : null;

	if (!empty ($module->content)) : ?>
		<div class="moduletable<?php echo $params->get('moduleclass_sfx'); ?>">
		<?php if ($module->showtitle != 0) : ?><h3><span class="span_moduletable"><?php echo $title; ?><?php if(!empty($sub_title)) { ?><strong class="strong_moduletable_title"><?php echo $sub_title; ?></strong><?php } ?></span></h3><?php endif; ?>
			<div class="moduletable_inner"><?php echo $module->content; ?></div>
		</div>
	<?php endif;
}

function modChrome_xhtmlcufon($module, &$params, &$attribs)
{
	$real_title = $module->title;
	$real_title = explode("||", $real_title);
	$title = $real_title[0];
	$sub_title = (!empty($real_title[1])) ? $real_title[1] : null;

	if (!empty ($module->content)) : ?>
		<div class="moduletable<?php echo $params->get('moduleclass_sfx'); ?>">
		<?php if ($module->showtitle != 0) : ?><h3 class="cufontag"><span class="span_moduletable"><?php echo $title; ?><?php if(!empty($sub_title)) { ?><strong class="strong_moduletable_title"><?php echo $sub_title; ?></strong><?php } ?></span></h3><?php endif; ?>
			<div class="moduletable_inner"><?php echo $module->content; ?></div>
		</div>
	<?php endif;
}

function modChrome_xhtmltpmenu($module, &$params, &$attribs)
{

	if (!empty ($module->content)) : ?>
		<div class="moduletable<?php echo $params->get('moduleclass_sfx'); ?>">
			<div class="moduletable_inner_tpmenu"><?php echo $module->content; ?></div>
		</div>
	<?php endif;
}

function modChrome_xhtmlcufontpmenu($module, &$params, &$attribs)
{

	if (!empty ($module->content)) : ?>
		<div class="moduletable<?php echo $params->get('moduleclass_sfx'); ?>">
			<div class="moduletable_inner_tpmenu"><?php echo $module->content; ?></div>
		</div>
	<?php endif;
}
?>