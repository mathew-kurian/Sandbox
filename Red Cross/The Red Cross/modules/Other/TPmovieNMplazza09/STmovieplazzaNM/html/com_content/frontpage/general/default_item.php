<?php
	defined('_JEXEC') or die('Restricted access');
	$canEdit	= ($this->user->authorize('com_content', 'edit', 'content', 'all') || $this->user->authorize('com_content', 'edit', 'content', 'own'));
?>
<?php if ($this->item->state == 0) : ?><div class="system-unpublished"><?php endif; ?>
<?php if ($canEdit || $this->item->params->get('show_title') || $this->item->params->get('show_pdf_icon') || $this->item->params->get('show_print_icon') || $this->item->params->get('show_email_icon')) : ?>
<table class="contentpaneopen<?php echo $this->item->params->get( 'pageclass_sfx' ); ?>">
    <tr>
	<?php if ($this->item->params->get('show_title')) : ?>
	<td class="contentheading<?php echo $this->item->params->get( 'pageclass_sfx' ); ?>" width="100%">
        <?php if ($this->item->params->get('show_create_date')) :
				/* echo '<span class="createdate">';
				echo JHTML::_('date', $this->item->created, JText::_('DATE_FORMAT_LC2'));
				if ($this->item->params->get('show_url') && $this->item->urls) : echo " / "; endif;
				echo '</span>'; */
                
                echo '<div class="tp-tittle-date"><span class="tp-tittle-date-date">';
                echo JHTML::_('date', $this->item->created, '%d'); 
                echo '</span><span class="tp-tittle-date-month">';
                echo JHTML::_('date', $this->item->created, '%b'); 
                echo '</span></div>';
                
                
			endif;
       ?>

		<?php if ($this->item->params->get('link_titles') && $this->item->readmore_link != '') : ?>
		<a href="<?php echo $this->item->readmore_link; ?>" class="contentpagetitle<?php echo $this->item->params->get( 'pageclass_sfx' ); ?>">
			<?php echo $this->item->title; ?></a>
		<?php else : ?>
			<?php echo $this->escape($this->item->title); ?>
		<?php endif; ?>
        
        
        <div class="tp-authorline">
        
        <?php
			if ($this->item->params->get('show_section') && $this->item->sectionid && isset($this->item->section)) :
				echo '<span>';
				if ($this->item->params->get('link_section')): echo '<a href="'.JRoute::_(ContentHelperRoute::getSectionRoute($this->item->sectionid)).'">'; endif;
				echo $this->item->section;
				if ($this->item->params->get('link_section')): echo '</a>'; endif;
				if ($this->item->params->get('show_category')) : echo " / "; endif;
				echo '</span>';
			endif;
			
			if ($this->item->params->get('show_category') && $this->item->catid) :
				echo '<span >';
				if ($this->item->params->get('link_category')) : echo '<a href="'.JRoute::_(ContentHelperRoute::getCategoryRoute($this->item->catslug, $this->item->sectionid)).'">'; endif;
				echo $this->item->category;
				if ($this->item->params->get('link_category')) : echo '</a>'; endif;
				if (($this->item->params->get('show_author')) && ($this->item->author != "")) : echo ' / '; endif;
				echo '</span>';
			endif;
			
			if (($this->item->params->get('show_author')) && ($this->item->author != "")) :
				echo '<span >';
				echo JText::_(($this->item->created_by_alias ? $this->item->created_by_alias : $this->item->author) );
				if ($this->item->params->get('show_create_date')) : //echo ' / '; 
                endif;
				echo '</span>';
			endif;
			
			
			
			if ($this->item->params->get('show_url') && $this->item->urls) :
				echo '<span class="small">';
				echo '<a href="http://' . $this->item->urls . '" target="_blank">' . $this->item->urls . '</a>';
				echo '</span>';
			endif;
		?>
        
        
        
        <?php if ($this->item->params->get('show_pdf_icon')) : ?>

	<?php echo JHTML::_('icon.pdf', $this->item, $this->item->params, $this->access); ?>

	<?php endif; ?>

	<?php if ( $this->item->params->get( 'show_print_icon' )) : ?>

	<?php echo JHTML::_('icon.print_popup', $this->item, $this->item->params, $this->access); ?>

	<?php endif; ?>

	<?php if ($this->item->params->get('show_email_icon')) : ?>

	<?php echo JHTML::_('icon.email', $this->item, $this->item->params, $this->access); ?>

	<?php endif; ?>
	<?php if ($canEdit) : ?>

		<?php echo JHTML::_('icon.edit', $this->item, $this->item->params, $this->access); ?>

	<?php endif; ?>
        
        
        
        </div>
        
        
        
	</td>
	<?php endif; ?>

	
</tr>
</table>
<?php endif; ?>
<?php  if (!$this->item->params->get('show_intro')) :
	echo $this->item->event->afterDisplayTitle;
endif; ?>
<?php echo $this->item->event->beforeDisplayContent; ?>
<table class="contentpaneopen<?php echo $this->item->params->get( 'pageclass_sfx' ); ?>">
<tr>
<td valign="top" colspan="2" class="main_article">
<?php if (isset ($this->item->toc)) : ?>
	<?php echo $this->item->toc; ?>
<?php endif; ?>
<?php echo $this->item->text; ?>
</td>
</tr>

<?php if ( intval($this->item->modified) != 0 && $this->item->params->get('show_modify_date')) : ?>
<tr>
	<td colspan="2"  class="modifydate">
		<?php echo JText::sprintf('LAST_UPDATED2', JHTML::_('date', $this->item->modified, JText::_('DATE_FORMAT_LC2'))); ?>
	</td>
</tr>
<?php endif; ?>

<?php if ($this->item->params->get('show_readmore') && $this->item->readmore) : ?>
<tr>
	<td  colspan="2">
		<a href="<?php echo $this->item->readmore_link; ?>" class="readon<?php echo $this->item->params->get('pageclass_sfx'); ?>">
			<?php if ($this->item->readmore_register) :
				echo JText::_('Register to read more...');
			elseif ($readmore = $this->item->params->get('readmore')) :
				echo $readmore;
			else :
				echo JText::sprintf('Read more...');
			endif; ?></a>
	</td>
</tr>
<?php endif; ?>

</table>
<?php if ($this->item->state == 0) : ?>
</div>
<?php endif; ?>
<span class="article_separator">&nbsp;</span>
<?php echo $this->item->event->afterDisplayContent; ?>
