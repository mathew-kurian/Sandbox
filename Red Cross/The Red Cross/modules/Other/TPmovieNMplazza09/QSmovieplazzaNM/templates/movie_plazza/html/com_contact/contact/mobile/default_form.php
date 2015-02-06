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

<?php echo $this->error; ?>

<?php endif; ?>

	<form action="<?php echo JRoute::_( 'index.php' );?>" method="post" name="emailForm" id="emailForm" class="form-validate">
		<div class="tp-sk-contactform-wrapper">
			<p class="tp-sk-contactform">
			<input type="text" name="name" id="contact_name" size="30" class="inputbox" value="<?php echo JText::_( 'Enter your name' ); ?>" onblur="if(this.value=='') this.value='<?php echo JText::_( 'Enter your name' ); ?>';" onfocus="if(this.value=='<?php echo JText::_( 'Enter your name' ); ?>') this.value='';" />
			</p>
			<p class="tp-sk-contactform">
			<input type="text" id="contact_email" name="email" size="30" value="<?php echo JText::_( 'Email address' ); ?>" class="inputbox required validate-email" maxlength="100" onblur="if(this.value=='') this.value='<?php echo JText::_( 'Email address' ); ?>';" onfocus="if(this.value=='<?php echo JText::_( 'Email address' ); ?>') this.value='';" />
			</p>
			<p class="tp-sk-contactform">
			<input type="text" name="subject" id="contact_subject" size="30" class="inputbox" value="<?php echo JText::_( 'Message subject' ); ?>" onblur="if(this.value=='') this.value='<?php echo JText::_( 'Message subject' ); ?>';" onfocus="if(this.value=='<?php echo JText::_( 'Message subject' ); ?>') this.value='';" />
			</p>
			<p class="tp-sk-contactform">
			<textarea cols="30" rows="10" name="text" id="contact_text" class="inputbox required" onblur="if(this.value=='') this.value='<?php echo JText::_( 'Enter your message' ); ?>';" onfocus="if(this.value=='<?php echo JText::_( 'Enter your message' ); ?>') this.value='';"><?php echo JText::_( 'Enter your message' ); ?></textarea>
			</p>
			<?php if ($this->contact->params->get( 'show_email_copy' )) : ?>
			<p><input type="checkbox" name="email_copy" id="contact_email_copy" value="1"  /><?php echo JText::_( 'EMAIL_A_COPY' ); ?></p>
			<?php endif; ?>
			<button class="button validate" type="submit"><?php echo JText::_('Send'); ?></button>
		</div>
	<input type="hidden" name="option" value="com_contact" />
	<input type="hidden" name="view" value="contact" />
	<input type="hidden" name="id" value="<?php echo $this->contact->id; ?>" />
	<input type="hidden" name="task" value="submit" />
	<?php echo JHTML::_( 'form.token' ); ?>
	</form>

