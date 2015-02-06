<?php // no direct access
defined('_JEXEC') or die('Restricted access'); ?>
<?php if($type == 'logout') : ?>

<form action="index.php" method="post" name="login" id="form-login">


<?php if ($params->get('greeting')) : ?>
	<?php if ($params->get('name')) : {
		echo JText::sprintf( 'HINAME', $user->get('name') );
	} else : {
		echo JText::sprintf( 'HINAME', $user->get('username') );
	} endif; ?>

<?php endif; ?>

		<br />
<input type="image"  style="vertical-align:middle; position:relative;" src="templates/movie_plazza/images/logoutbutton.gif"  name="Submit"  value="<?php echo JText::_( 'BUTTON_LOGOUT'); ?>" />


	<input type="hidden" name="option" value="com_user" />
	<input type="hidden" name="task" value="logout" />
	<input type="hidden" name="return" value="<?php echo $return; ?>" />
</form><div style="clear:both;"></div>
<?php else : ?>
<?php if(JPluginHelper::isEnabled('authentication', 'openid')) :
		$lang->load( 'plg_authentication_openid', JPATH_ADMINISTRATOR );
		$langScript = 	'var JLanguage = {};'.
						' JLanguage.WHAT_IS_OPENID = \''.JText::_( 'WHAT_IS_OPENID' ).'\';'.
						' JLanguage.LOGIN_WITH_OPENID = \''.JText::_( 'LOGIN_WITH_OPENID' ).'\';'.
						' JLanguage.NORMAL_LOGIN = \''.JText::_( 'NORMAL_LOGIN' ).'\';'.
						' var modlogin = 1;';
		$document = &JFactory::getDocument();
		$document->addScriptDeclaration( $langScript );
		JHTML::_('script', 'openid.js');
endif; ?><form action="<?php echo JRoute::_( 'index.php', true, $params->get('usesecure')); ?>" method="post" name="login" id="form-login" >
	<?php echo $params->get('pretext'); ?>
	<input id="modlgn_username" type="text" name="username" class="inputbox" alt="username" size="10" value="username" />
	<input id="modlgn_passwd" type="password" name="passwd" class="inputbox" size="10" alt="password" value="password" />

	<?php if(JPluginHelper::isEnabled('system', 'remember')) : ?>

		

<img src="templates/movie_plazza/images/save.gif" alt="save" style="vertical-align:middle" title="Remember Password" />
		<input id="modlgn_remember" type="checkbox" name="remember"  value="yes" alt="Remember Me" />

	<?php endif; ?>
	<input type="image" style="vertical-align: middle; position:relative;" src="templates/movie_plazza/images/loginbutton.gif"  name="Submit" value="<?php echo JText::_('LOGIN') ?>" />


			<a href="<?php echo JRoute::_( 'index.php?option=com_user&view=reset' ); ?>"><img src="templates/movie_plazza/images/lost-pwd.gif" alt="lost pwd" style="vertical-align:middle" title="Lost Password" /></a> 

			<a href="<?php echo JRoute::_( 'index.php?option=com_user&view=remind' ); ?>">
			<img src="templates/movie_plazza/images/lost_uname.gif" alt="lost username" style="vertical-align:middle" title="Lost Username"/></a> 

		<?php
		$usersConfig = &JComponentHelper::getParams( 'com_users' );
		if ($usersConfig->get('allowUserRegistration')) : ?>

			<a href="<?php echo JRoute::_( 'index.php?option=com_user&task=register' ); ?>">
				<img src="templates/movie_plazza/images/create-account.gif" alt="create account" style="vertical-align:middle" title="Create Account" /></a>

		<?php endif; ?>

	<?php echo $params->get('posttext'); ?>

	<input type="hidden" name="option" value="com_user" />
	<input type="hidden" name="task" value="login" />
	<input type="hidden" name="return" value="<?php echo $return; ?>" />
	<?php echo JHTML::_( 'form.token' ); ?>
</form>
<?php endif; ?>