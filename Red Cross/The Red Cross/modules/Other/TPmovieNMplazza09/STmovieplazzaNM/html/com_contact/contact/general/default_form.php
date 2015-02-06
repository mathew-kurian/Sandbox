<?php
	defined( '_JEXEC' ) or die( 'Restricted access' );
	$script = '<!--
		function validateForm( frm ) {
			var valid = document.formvalidator.isValid(frm);
			if (valid == false) {
				// do field validation
				if (frm.email.invalid) {
					alert( "' . JText::_( 'Please enter a valid e-mail address.', true ) . '" );
				} else if (frm.text.invalid) {
					alert( "' . JText::_( 'CONTACT_FORM_NC', true ) . '" );
				}
				return false;
			} else {
				frm.submit();
			}
		}
		// -->';
	$document =& JFactory::getDocument();
	$document->addScriptDeclaration($script);
	
	if(isset($this->error)) : ?>
<tr>
	<td><?php echo $this->error; ?></td>
</tr>
<?php endif; ?>
<tr>
	<td colspan="2">
	<form action="<?php echo JRoute::_( 'index.php' );?>" method="post" name="emailForm" id="emailForm" class="form-validate">
		<div class="contact_email<?php echo $this->params->get( 'pageclass_sfx' ); ?>">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="table_list">
			<tr>
				<td>
					<label for="contact_name"><?php echo JText::_( 'Enter your name' );?></label>
					<br /><input type="text" name="name" id="contact_name" size="30" class="inputbox" value="" />
				</td>
			</tr>
			
			<tr>
				<td>
					<label id="contact_emailmsg" for="contact_email"><?php echo JText::_( 'Email address' );?></label>
					<br /><input type="text" id="contact_email" name="email" size="30" value="" class="inputbox required validate-email" maxlength="100" />
				</td>
			</tr>
			
			<tr>
				<td>
					<label for="contact_subject"><?php echo JText::_( 'Message subject' );?></label>
					<br /><input type="text" name="subject" id="contact_subject" size="30" class="inputbox" value="" />
				</td>
			</tr>
			
			<tr>
				<td>
					<label id="contact_textmsg" for="contact_text"><?php echo JText::_( 'Enter your message' );?></label>
					<br /><textarea cols="30" rows="10" name="text" id="contact_text" class="inputbox required"></textarea>
				</td>
			</tr>
			
			<?php if ($this->contact->params->get( 'show_email_copy' )) : ?>
			<tr>
				<td colspan="2"><input type="checkbox" name="email_copy" id="contact_email_copy" value="1"  /><label for="contact_email_copy"><?php echo JText::_( 'EMAIL_A_COPY' ); ?></label></td>
			</tr>
			<?php endif; ?>
			
			<tr>
				<td colspan="2" align="right"><button class="button validate" type="submit"><?php echo JText::_('Send'); ?></button></td>
			</tr>
		</table>
		</div>
	<input type="hidden" name="option" value="com_contact" />
	<input type="hidden" name="view" value="contact" />
	<input type="hidden" name="id" value="<?php echo $this->contact->id; ?>" />
	<input type="hidden" name="task" value="submit" />
	<?php echo JHTML::_( 'form.token' ); ?>
	</form>
	</td>
</tr>
