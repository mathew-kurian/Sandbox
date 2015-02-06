<?php defined('_JEXEC') or die('Restricted access'); ?>
<div class="tp-sk-all-wrp">
	<div class="tp-sk-all-wrp-inner">
		<div class="tp-sk-all-date-wrp">
			<span class="tp-sk-all-date-date"><?php echo JHTML::_('date', $this->item->created, '%d'); ?></span>
			<span class="tp-sk-all-date-month"><?php echo JHTML::_('date', $this->item->created, '%b'); ?></span>
            <span class="tp-sk-all-date-year"><?php echo JHTML::_('date', $this->item->created, '%Y'); ?></span>
		</div>
		
		<div class="tp-sk-all-tittle">
			<h1><a href="<?php echo JRoute::_(ContentHelperRoute:: getArticleRoute($this->item->id, $this->item->catslug, $this->item->sectionid)); ?>"><?php echo $this->item->title; ?></a></h1>
		</div>
		<div class="tp-sk-all-section">
			<span><?php //echo JText::_('Author : '); ?> <strong><?php //echo JText::_(($this->item->created_by_alias ? $this->item->created_by_alias : $this->item->author) ); ?></strong></span>
			
			<?php
			echo '<span><a href="'.JRoute::_(ContentHelperRoute::getSectionRoute($this->item->sectionid)).'">';
			echo $this->item->section;
			echo '</a>';
			echo ' / ';
			echo '<a href="'.JRoute::_(ContentHelperRoute::getCategoryRoute($this->item->catslug, $this->item->sectionid)).'">';
			echo $this->item->category;
			echo '</a></span>';
			?>
		</div>
		<div class="clrfix"></div>
	</div>
</div>

