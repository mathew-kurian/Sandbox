<?php // no direct access
defined( '_JEXEC' ) or die( 'Restricted access' ); ?>
<form action="<?php echo JRoute::_( 'index.php' );?>" method="post" name="emailFormXtd" id="emailFormXtd">
    <div id="xtdcontact_wrp">
        <div id="send_responses" class="messages"></div>
		<p><label for="name_xtd" id="name_label_xtd">
			&nbsp;<?php echo JText::_( 'ENTER YOUR NAME' );?>
		</label>
		<input type="text" name="name" id="name_xtd" size="30" class="inputbox-xtd" value="" />
        </p>
        <p>
		<label id="email_label_xtd" for="email_xtd">
			&nbsp;<?php echo JText::_( 'EMAIL ADDRESS' );?>
		</label>
		<input type="text" id="email_xtd" name="email" size="30" value="" class="inputbox-xtd" maxlength="100" />
		</p>
        <p>
		<label for="subject_xtd" id="subject_label_xtd">
			&nbsp;<?php echo JText::_( 'MESSAGE SUBJECT' );?>
		</label>
		<input type="text" name="subject" id="subject_xtd" size="30" class="inputbox-xtd" value="" />
		</p>
        
		<p><label id="text_label_xtd" for="text_xtd">
			&nbsp;<?php echo JText::_( 'ENTER YOUR MESSAGE' );?>
		</label>
		<textarea cols="23" rows="4" name="text" id="text_xtd" class="inputbox-xtd"></textarea>
        </p>

   <label for="captcha_ver" id="captcha_ver_label"><?php echo JText::_('CAPTCHA LABEL') ?></label>
	 <input type="text"  name="captcha_ver" id="captcha_ver"  value="" class="inputbox-xtd" />
   <div class="captch_img">
   	<img src="<?php echo JURI::base() ;?>modules/mod_tploginxtd/assets/captcha.php" alt="verification" id="captcha_image" />
    <a href="#" title="refresh captcha" id="captcha_refresh"><?php echo JText::_( 'REFRESH' ); ?></a>
   </div>	


		<?php if ($params->get( 'show_email_copy' )) : ?>
			<input type="checkbox" name="email_copy" id="email_copy_xtd" value="1"  />
			<label for="email_copy" id="email_copy_label_xtd">
				<?php echo JText::_( 'EMAIL_A_COPY' ); ?>
			</label>
		<?php endif; ?>
		<input type="submit" name="send_button" id="submit_button_xtd" class="button" value="<?php echo JText::_('SEND'); ?>" />
	</div>
	<input type="hidden" name="id" value="<?php echo $contactid; ?>" />
	<input type="hidden" name="mid" value="<?php echo $module->id; ?>" />
</form>