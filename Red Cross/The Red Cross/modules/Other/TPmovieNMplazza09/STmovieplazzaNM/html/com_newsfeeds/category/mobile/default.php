<?php // no direct access
defined('_JEXEC') or die('Restricted access'); ?>
<?php if ( $this->params->get( 'show_page_title', 1 ) ) : ?>
	<h1 class="componentheading"><?php echo $this->escape($this->params->get('page_title')); ?></h1>
<?php endif; ?>


<?php if ( @$this->image || @$this->category->description ) : ?>


	<?php
		if ( isset($this->image) ) :  echo $this->image; endif;
		echo $this->category->description;
	?>

<?php endif; ?>

	<?php echo $this->loadTemplate('items'); ?>

