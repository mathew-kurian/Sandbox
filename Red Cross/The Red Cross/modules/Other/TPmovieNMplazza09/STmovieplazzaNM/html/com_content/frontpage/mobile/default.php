<?php // no direct access
defined('_JEXEC') or die('Restricted access');

$displayedPages	= 3;
$this->pagination->set( 'pages.start', (floor(($this->pagination->get('pages.current') -1) / $displayedPages)) * $displayedPages +1);
if ($this->pagination->get('pages.start') + $displayedPages -1 < $this->pagination->get('pages.total')) {
	$this->pagination->set( 'pages.stop', $this->pagination->get('pages.start') + $displayedPages -1);
} else {
	$this->pagination->set( 'pages.stop', $this->pagination->get('pages.total'));
}

?>

<?php if ($this->params->def('num_leading_articles', 1)) : ?>


	<?php for ($i = $this->pagination->limitstart; $i < ($this->pagination->limitstart + $this->params->get('num_leading_articles')); $i++) : ?>
		<?php if ($i >= $this->total) : break; endif; ?>
			<?php $this->item =& $this->getItem($i, $this->params); echo $this->loadTemplate('item'); ?>
	<?php endfor; ?>

<?php else : $i = $this->pagination->limitstart; endif; ?>

<?php
$startIntroArticles = $this->pagination->limitstart + $this->params->get('num_leading_articles');
$numIntroArticles = $startIntroArticles + $this->params->get('num_intro_articles', 4);
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

<?php if ($this->params->def('num_links', 4) && ($i < $this->total)) : ?>

		<div class="tp-sk-all-blog-more">
			<div class="tp-sk-all-blog-more-inner">
					<?php
					$this->links = array_splice($this->items, $i - $this->pagination->limitstart);
					echo $this->loadTemplate('links');
				?>
			</div>
		</div>

<?php endif; ?>

<div class="tp-sk-all-pagination">
	<div class="tp-sk-all-pagination-inner">
		<?php if ($this->params->def('show_pagination', 2) == 1  || ($this->params->get('show_pagination') == 2 && $this->pagination->get('pages.total') > 1)) : ?><?php echo $this->pagination->getPagesLinks(); ?><?php endif; ?>
	</div>
</div>	


