<?php // no direct access
defined('_JEXEC') or die('Restricted access'); ?>
<form action="<?php echo JRoute::_('index.php?view=category&id='.$this->category->slug); ?>" method="post" name="adminForm">

<?php if ($this->params->get('show_limit')) : ?>

	<?php
		echo JText::_('Display Num') .'&nbsp;';
		echo $this->pagination->getLimitBox();
	?>

<?php endif; ?>

<ul><?php foreach ($this->items as $item) : ?>
<li class="wrprounded">
	<h1><?php echo $item->count + 1; ?>
		<a href="<?php echo $item->link; ?>">
	<?php echo $this->escape($item->name); ?></a>
	<?php if ( $this->params->get( 'show_articles' ) ) : ?>
		( <?php echo $item->numarticles; ?> <?php echo JText::_( 'Num Articles' ); ?> )</h1>
	<?php endif; ?>
</li>
<?php endforeach; ?></ul>
	<?php
		echo $this->pagination->getPagesLinks();
	?>
		<?php echo $this->pagination->getPagesCounter(); ?>
</form>
