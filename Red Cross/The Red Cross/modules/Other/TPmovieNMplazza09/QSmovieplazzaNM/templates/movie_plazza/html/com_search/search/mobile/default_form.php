<?php defined('_JEXEC') or die('Restricted access'); ?>

<form id="searchForm" action="<?php echo JRoute::_( 'index.php?option=com_search' );?>" method="post" name="searchForm">


				<p><input type="text" name="searchword" id="search_searchword" size="30" maxlength="20" value="<?php echo $this->escape($this->searchword); ?>" class="inputbox" />
				<button name="Search" onclick="this.form.submit()" class="button"><?php echo JText::_( 'Search' );?></button>
				</p>
				<p><?php echo $this->lists['searchphrase']; ?>
				</p>
				<p>
					<?php echo JText::_( 'Ordering' );?>:
				
				<?php echo $this->lists['ordering'];?>
				</p>
	<?php if ($this->params->get( 'search_areas', 1 )) : ?>
		<?php echo JText::_( 'Search Only' );?>:
		<?php foreach ($this->searchareas['search'] as $val => $txt) :
			$checked = is_array( $this->searchareas['active'] ) && in_array( $val, $this->searchareas['active'] ) ? 'checked="checked"' : '';
		?>
		<input type="checkbox" name="areas[]" value="<?php echo $val;?>" id="area_<?php echo $val;?>" <?php echo $checked;?> />
			<label for="area_<?php echo $val;?>">
				<?php echo JText::_($txt); ?>
			</label>
		<?php endforeach; ?>
	<?php endif; ?>
			<h3 class="contentheading"><?php echo JText::_( 'Search Keyword' ) .' <b>'. $this->escape($this->searchword) .'</b>'; ?></h3>
			<p><?php echo $this->result; ?></P>

<?php if($this->total > 0) : ?>
<p>
	<?php echo JText::_( 'Display Num' ); ?>
	<?php echo $this->pagination->getLimitBox( ); ?>
	<?php echo $this->pagination->getPagesCounter(); ?>
</p>
<?php endif; ?>

<input type="hidden" name="task"   value="search" />
</form>
