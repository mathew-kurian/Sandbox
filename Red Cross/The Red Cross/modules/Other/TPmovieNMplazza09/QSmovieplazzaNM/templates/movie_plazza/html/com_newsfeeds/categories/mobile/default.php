<?php // no direct access
defined('_JEXEC') or die('Restricted access'); ?>
<?php if ( $this->params->get( 'show_page_title', 1 ) ) : ?>
	<h1 class="componentheading">
		<?php echo $this->escape($this->params->get('page_title')); ?>
	</h1>
<?php endif; ?>


<p><?php if ( ($this->params->get('image') != -1) || $this->params->get('show_comp_description') ) : ?></p>

	<?php
		if ( isset($this->image) ) :  echo $this->image; endif;
		echo $this->escape($this->params->get('comp_description'));
	?>

<?php endif; ?>

<ul>
<?php foreach ( $this->categories as $category ) : ?>
	<li class="wrprounded">
		<h1><a href="<?php echo $category->link ?>" class="category<?php echo $this->escape($this->params->get('pageclass_sfx')); ?>">
			<?php echo $this->escape($category->title);?></a>
		<?php if ( $this->params->get( 'show_cat_items' ) ) : ?>
		&nbsp;
		<span class="small">
			(<?php echo $category->numlinks;?>)
		</span>
		<?php endif; ?>
		</h1>
		<?php if ( $this->params->get( 'show_cat_description' ) && $category->description ) : ?>
		<p>
		<?php echo $category->description; ?>
		</p>
		<?php endif; ?>
	</li>
<?php endforeach; ?>
</ul>
