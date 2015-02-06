<?php
	defined('_JEXEC') or die('Restricted access');
	$canEdit	= ($this->user->authorize('com_content', 'edit', 'content', 'all') || $this->user->authorize('com_content', 'edit', 'content', 'own'));
?>
<?php if ($this->params->get('show_page_title', 1) && $this->params->get('page_title') != $this->article->title) : ?>
	<h1 class="componentheading"><?php echo $this->escape($this->params->get('page_title')); ?></h1>
<?php endif; ?>
<?php if ($canEdit || $this->params->get('show_title') || $this->params->get('show_pdf_icon') || $this->params->get('show_print_icon') || $this->params->get('show_email_icon')) : ?>

	<?php if ($this->params->get('show_title')) : ?>
	
		<?php if ($this->params->get('link_titles') && $this->article->readmore_link != '') : ?>
		<h1 class="contentheading"><a href="<?php echo $this->article->readmore_link; ?>">
			<?php echo $this->escape($this->article->title); ?></a></h1>
		<?php else : ?>
			<h1 class="contentheading"><?php echo $this->escape($this->article->title); ?></h1>
		<?php endif; ?>

	<?php endif; ?>
	<?php if (!$this->print) : ?>
		<div class="tp-sk-jbutton-wrapper">
		<?php $this->params->set('show_icons', 0); ?>
		<?php if ($this->params->get('show_pdf_icon')) : ?>
		<?php echo str_replace( array( "&nbsp;", "|" ), "", JHTML::_('icon.pdf',  $this->article, $this->params, $this->access) ); ?>
		<?php endif; ?>
		<?php if ( $this->params->get( 'show_print_icon' )) : ?>
		<?php echo str_replace( array( "&nbsp;", "|" ), "", JHTML::_('icon.print_popup',  $this->article, $this->params, $this->access) ); ?>
		<?php endif; ?>
		<?php if ($this->params->get('show_email_icon')) : ?>
		<?php echo str_replace( array( "&nbsp;", "|" ), "", JHTML::_('icon.email',  $this->article, $this->params, $this->access) ); ?>
		<?php endif; ?>
		<?php if ($canEdit) : ?>
			<?php echo str_replace( array( "&nbsp;", "|" ), "", JHTML::_('icon.edit', $this->article, $this->params, $this->access) ); ?>
		<?php endif; ?>
		</div>
        <div class="clrfix"></div>
	<?php else : ?>
		<?php echo JHTML::_('icon.print_screen',  $this->article, $this->params, $this->access); ?>
	
	<?php endif; ?>

<?php endif; ?>

<?php  if (!$this->params->get('show_intro')) :
	echo $this->article->event->afterDisplayTitle;
endif; ?>
<?php echo $this->article->event->beforeDisplayContent; ?>

<?php if (($this->params->get('show_section') && $this->article->sectionid) || ($this->params->get('show_category') && $this->article->catid)) : ?>
<?php endif; ?>

<?php
if (($this->params->get('show_author')) && ($this->article->author != "") || $this->params->get('show_create_date') || ($this->params->get('show_url') && $this->article->urls) || ($this->params->get('show_section') && $this->article->sectionid && isset($this->article->section)) || ($this->params->get('show_category') && $this->article->catid)) :
?>
	<div class="tp-sk-authorbar small bold">

		<?php
			if ($this->params->get('show_section') && $this->article->sectionid && isset($this->article->section)):
				echo '<span class="small">';
				if ($this->params->get('link_section')) : echo '<a href="'.JRoute::_(ContentHelperRoute::getSectionRoute($this->article->sectionid)).'">'; endif;
				echo $this->article->section;
				if ($this->params->get('link_section')): echo '</a>'; endif;
				if ($this->params->get('show_category')): echo ' / '; endif;
				echo '</span>';
			endif;
			
			if ($this->params->get('show_category') && $this->article->catid) :
				echo '<span class="small">';	
				if ($this->params->get('link_category')): echo '<a href="'.JRoute::_(ContentHelperRoute::getCategoryRoute($this->article->catslug, $this->article->sectionid)).'">'; endif;
				echo $this->article->category;
				if ($this->params->get('link_category')): echo '</a>'; endif;
				if (($this->params->get('show_author')) && ($this->article->author != "")): echo " / "; endif;
				echo '</span>';
			endif;
			
			if(($this->params->get('show_author')) && ($this->article->author != "")):
				echo '<span class="author">';
				echo ($this->article->created_by_alias ? $this->article->created_by_alias : $this->article->author);
				if ($this->params->get('show_create_date')): echo " / "; endif;
				echo "</span>";
			endif;
			
			if ($this->params->get('show_create_date')):
				echo '<span class="createdate">';
				echo JHTML::_('date', $this->article->created, JText::_('DATE_FORMAT_LC2'));
				if ($this->params->get('show_url') && $this->article->urls): echo ' / '; endif;
				echo '</span>';
			endif;
			
			if ($this->params->get('show_url') && $this->article->urls):
				echo '<span class="small">';
				echo '<a href="http://' . $this->article->urls . '" target="_blank">' . $this->article->urls . '</a>';
				echo '</span>';
			endif;
		?>
	</div>
<?php endif; ?>


<?php if (isset ($this->article->toc)) : ?>
	<?php echo $this->article->toc; ?>
<?php endif; ?>
<?php echo $this->article->text; ?>


<?php if ( intval($this->article->modified) !=0 && $this->params->get('show_modify_date')) : ?>

		<div class="small italic"><?php echo JText::sprintf('LAST_UPDATED2', JHTML::_('date', $this->article->modified, JText::_('DATE_FORMAT_LC2'))); ?></div>

<?php endif; ?>

<?php echo $this->article->event->afterDisplayContent; ?>
