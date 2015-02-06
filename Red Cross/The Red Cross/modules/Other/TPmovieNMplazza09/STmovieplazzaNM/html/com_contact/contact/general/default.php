<?php
	defined( '_JEXEC' ) or die( 'Restricted access' );
	$cparams = JComponentHelper::getParams ('com_media');
?>
<?php if ( $this->params->get( 'show_page_title', 1 ) && !$this->contact->params->get( 'popup' ) && $this->params->get('page_title') != $this->contact->name ) : ?>
	<div class="componentheading<?php echo $this->params->get( 'pageclass_sfx' ); ?>">
		<?php echo $this->params->get( 'page_title' ); ?>
	</div>
<?php endif; ?>
<div id="component-contact">
<table cellpadding="0" cellspacing="0" border="0" class="contentpaneopen<?php echo $this->params->get( 'pageclass_sfx' ); ?>">
	<tr valign="top">
		<td valign="top" width="48%">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<?php if ( $this->params->get( 'show_contact_list' ) && count( $this->contacts ) > 1) : ?>
				<tr>
					<td align="center">
						<form action="<?php echo JRoute::_('index.php') ?>" method="post" name="selectForm" id="selectForm">
						<?php echo JText::_( 'Select Contact' ); ?>:
							<br />
							<?php echo JHTML::_('select.genericlist',  $this->contacts, 'contact_id', 'class="inputbox" onchange="this.form.submit()"', 'id', 'name', $this->contact->id);?>
							<input type="hidden" name="option" value="com_contact" />
						</form>
					</td>
				</tr>
				<?php endif; ?>
				
				<?php if ( $this->contact->name && $this->contact->params->get( 'show_name' ) ) : ?>
					<tr><td width="100%" class="contentheading<?php echo $this->params->get( 'pageclass_sfx' ); ?>"><?php echo $this->contact->name; ?></td></tr>
				<?php endif; ?>
				
				<?php if ( $this->contact->con_position && $this->contact->params->get( 'show_position' ) ) : ?>
					<tr><td colspan="2"><?php echo $this->contact->con_position; ?></td></tr>
				<?php endif; ?>
			
				<tr>
					<td>
						<?php if ( $this->contact->image && $this->contact->params->get( 'show_image' ) ) : ?>
							<br />
							<?php echo JHTML::_('image', 'images/stories' . '/'.$this->contact->image, JText::_( 'Contact' ), array('align' => 'middle')); ?>
							<br /><br />
						<?php endif; ?>
						<?php echo $this->loadTemplate('address'); ?>
					</td>
				</tr>
				
				<?php if ( $this->contact->params->get( 'allow_vcard' ) ) : ?>
				<tr>
					<td colspan="2">
						<?php echo JText::_( 'Download information as a' );?>
						<a href="<?php echo JURI::base(); ?>index.php?option=com_contact&amp;task=vcard&amp;contact_id=<?php echo $this->contact->id; ?>&amp;format=raw&amp;tmpl=component"><?php echo JText::_( 'VCard' );?></a>
					</td>
				</tr>
				<?php endif; ?>
			</table>
		</td>
		
		<td width="4%"></td>
		
		<!--form-->
		<td valign="top" width="48%">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<?php
					if ( $this->contact->params->get('show_email_form') && ($this->contact->email_to || $this->contact->user_id))
					echo $this->loadTemplate('form');
				?>
			</table>
		</td>
	</tr>
	
</table>
</div>
