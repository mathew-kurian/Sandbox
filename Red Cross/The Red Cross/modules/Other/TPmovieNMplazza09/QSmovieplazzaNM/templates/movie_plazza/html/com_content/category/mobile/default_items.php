<?php // no direct access
defined('_JEXEC') or die('Restricted access'); ?>
<script language="javascript" type="text/javascript">

	function tableOrdering( order, dir, task )
	{
		var form = document.adminForm;

		form.filter_order.value 	= order;
		form.filter_order_Dir.value	= dir;
		document.adminForm.submit( task );
	}
</script>
<form action="<?php echo $this->action; ?>" method="post" name="adminForm">

<?php if ($this->params->get('filter') || $this->params->get('show_pagination_limit')) : ?>

		<?php if ($this->params->get('filter')) : ?>

				<p><?php echo JText::_($this->params->get('filter_type') . ' Filter').'&nbsp;'; ?>
				<input type="text" name="filter" value="<?php echo $this->escape($this->lists['filter']);?>" class="inputbox" onchange="document.adminForm.submit();" />
				<?php
				echo '&nbsp;&nbsp;&nbsp;'.JText::_('#').'&nbsp;';
				echo $this->pagination->getLimitBox();
			?></p>

		<?php endif; ?>

<?php endif; ?>

<ul>
<?php foreach ($this->items as $item) : ?>
	<li class="wrprounded">
	<h1><?php echo $this->pagination->getRowOffset( $item->count ); ?>	
	<?php if ($this->params->get('show_title')) : ?>
	<?php if ($item->access <= $this->user->get('aid', 0)) : ?>

		<a href="<?php echo $item->link; ?>">
			<?php echo $item->title; ?></a>
			<?php $this->item = $item; echo JHTML::_('icon.edit', $item, $this->params, $this->access) ?>

	<?php else : ?>

		<?php
			echo $this->escape($item->title).' : ';
			$link = JRoute::_('index.php?option=com_user&view=login');
			$returnURL = JRoute::_(ContentHelperRoute::getArticleRoute($item->slug, $item->catslug, $item->sectionid), false);
			$fullURL = new JURI($link);
			$fullURL->setVar('return', base64_encode($returnURL));
			$link = $fullURL->toString();
		?>
		<a href="<?php echo $link; ?>">
			<?php echo JText::_( 'Register to read more...' ); ?></a>

	<?php endif; ?>
	
	<?php endif; ?>
	</h1>
	
		<p>
		<?php echo $item->created; ?>

	<?php if ($this->params->get('show_author')) : ?>

		- <strong><?php echo $item->created_by_alias ? $item->created_by_alias : $item->author; ?></strong>

	<?php endif; ?>
	<?php if ($this->params->get('show_hits')) : ?>

		 - <?php echo $item->hits ? $item->hits : '-'; ?> <?php echo JText::_('Hits'); ?>

	<?php endif; ?>
	</p>
	</li>

<?php endforeach; ?><ul>
<?php if ($this->params->get('show_pagination')) : ?>

		<?php echo $this->pagination->getPagesLinks(); ?>

		<?php echo $this->pagination->getPagesCounter(); ?>

<?php endif; ?>

<input type="hidden" name="id" value="<?php echo $this->category->id; ?>" />
<input type="hidden" name="sectionid" value="<?php echo $this->category->sectionid; ?>" />
<input type="hidden" name="task" value="<?php echo $this->lists['task']; ?>" />
<input type="hidden" name="filter_order" value="" />
<input type="hidden" name="filter_order_Dir" value="" />
<input type="hidden" name="limitstart" value="0" />
</form>
