<?php
defined('_JEXEC') or die('Restricted access');
$cparams =& JComponentHelper::getParams('com_media');

$displayedPages	= 3;
$this->pagination->set( 'pages.start', (floor(($this->pagination->get('pages.current') -1) / $displayedPages)) * $displayedPages +1);
if ($this->pagination->get('pages.start') + $displayedPages -1 < $this->pagination->get('pages.total')) {
	$this->pagination->set( 'pages.stop', $this->pagination->get('pages.start') + $displayedPages -1);
} else {
	$this->pagination->set( 'pages.stop', $this->pagination->get('pages.total'));
}

?>
<?php if ($this->params->get('show_page_title')) : ?>
<h1 class="componentheading">
	<?php echo $this->escape($this->params->get('page_title')); ?>
</h1>
<?php endif; ?>
<?php if ($this->params->def('show_description', 1) || $this->params->def('show_description_image', 1)) :?>
	<p>
	<?php if ($this->params->get('show_description_image') && $this->section->image) : ?>
		<img src="<?php echo $this->baseurl . '/' . $cparams->get('image_path') . '/'. $this->section->image;?>" align="<?php echo $this->section->image_position;?>" hspace="6" alt="" />
	<?php endif; ?>
	<?php if ($this->params->get('show_description') && $this->section->description) : ?>
		<?php echo $this->section->description; ?>
	<?php endif; ?>
	</p>
<?php endif; ?>

<?php if ($this->params->def('num_leading_articles', 1)) : ?>
<tr>
	<td valign="top" colspan="2">
	<?php for ($i = $this->pagination->limitstart; $i < ($this->pagination->limitstart + $this->params->get('num_leading_articles')); $i++) : ?>
		<?php if ($i >= $this->total) : break; endif; ?>
		<div class="leading_article">
			<div class="leading_article_inner">
				<?php $this->item =& $this->getItem($i, $this->params); echo $this->loadTemplate('item'); ?>
			</div>
		</div>
	<?php endfor; ?>
	</td>
</tr>
<?php else : $i = $this->pagination->limitstart; endif; ?>

<?php
$startIntroArticles = $this->pagination->limitstart + $this->params->get('num_leading_articles');
$numIntroArticles = $startIntroArticles + $this->params->get('num_intro_articles');
if (($numIntroArticles != $startIntroArticles) && ($i < $this->total)) : ?>
		<?php
				for ($z = 0; $z < $this->params->get('num_columns'); $z ++) :
					if ($z > 0) : $divider = " column_separator"; endif; ?>
					<?php for ($y = 0; $y < ($this->params->get('num_intro_articles') / $this->params->get('num_columns')); $y ++) :
					if ($i < $this->total && $i < ($numIntroArticles)) :
						$this->item =& $this->getItem($i, $this->params);
						echo $this->loadTemplate('item');
						$i ++;
					endif;
				endfor; ?>

		<?php endfor; ?>		

<?php endif; ?>


<?php if ($this->params->get('num_links') && ($i < $this->total)) : ?>
		<div class="blog_more<?php echo $this->params->get('pageclass_sfx') ?>">
			<?php
				$this->links = array_splice($this->items, $i - $this->pagination->limitstart);
				echo $this->loadTemplate('links');
			?>
		</div>
<?php endif; ?>



<?php if ($this->params->def('show_pagination_results', 1) || $this->params->def('show_pagination')) : ?>
	<?php if ($this->params->def('show_pagination_results', 1)) : ?>
		<div class="pagecounter"><?php echo $this->pagination->getPagesCounter(); ?></div>
	<?php endif; ?>
	<?php if ($this->params->def('show_pagination', 2)) : ?>
		<div><?php echo $this->pagination->getPagesLinks(); ?></div>
	<?php endif; ?>
<?php endif; ?>