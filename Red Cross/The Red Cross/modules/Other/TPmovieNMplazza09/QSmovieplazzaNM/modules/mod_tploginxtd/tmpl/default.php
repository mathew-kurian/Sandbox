<?php // no direct access
defined( '_JEXEC' ) or die( 'Restricted access' ); ?>

<?php
switch( $link_style )
{
	case 'left':
		$custom_class = 'fixleft';
	break;
	case 'right':
		$custom_class = 'fixright';
	break;
	case 'top':
		$custom_class = 'fixtop';
	break;
	case 'bottom':
		$custom_class = 'fixbottom';
	break;
	default:
		$custom_class = '';
	break;
}
/*div nya nanti jadi <div class="<?php echo $custom_class; ?>"></div>*/
?>

<?php if( $enable_login ) : ?>
	<?php if( !$user->id ) : ?>
	<div id="rl_login" class="rlbox_login"><span class="blogin<?php echo $custom_class; ?>"><?php echo JText::_('LOGIN'); ?></span></div>
	<?php else: ?>
	<div>
	<form action="index.php" method="post" name="login" id="form-login">
		<a href="javascript: void(0)" onClick="javascript:document.login.submit();"><span class="blogout<?php echo $custom_class; ?>"><?php echo JText::_( 'BUTTON_LOGOUT'); ?></span></a>
		<input type="hidden" name="option" value="com_user" />
		<input type="hidden" name="task" value="logout" />
		<input type="hidden" name="return" value="<?php echo $return; ?>" />
	</form>
	</div>
	<div class="rl_logout">
	<?php
	/*if( $params->get('greeting') )
	{
		echo 'Welcome ';
		$name = $params->get('name', 0);
		echo ( $name ) ? $user->name : $user->username;
	}
	*/?>
	</div>
	<?php endif; ?>
<?php endif; ?>

<?php if( $enable_register & !$user->id ) : ?>
<div id="rl_register" class="rlbox_register"><span class="bregister<?php echo $custom_class; ?>"><?php echo JText::_('REGISTER'); ?></span></div>
<?php endif; ?>

<?php if( $enable_contact ) : ?>
<div id="rl_contact" class="rlbox_contact"><span class="bcontact<?php echo $custom_class; ?>"><?php echo JText::_('CONTACT'); ?></span></div>
<?php endif; ?>
<div class="clrfix"></div>
<?php if( $enable_login && !$user->id ) : ?>
<div class="rlboxhidden">
	<div id="rlbox_login">
		<div>
			<div>
				<div>
					<div>
                        <img src="<?php echo JURI::base() ;?>modules/mod_tploginxtd/assets/images/login.png" alt="Login" align="left" />
						<h3 class="xtdlogin"><?php echo JText::_('LOGIN'); ?></h3>
						<?php require_once (dirname(__FILE__).DS.'login.php'); ?>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<?php endif; ?>

<?php if( $enable_register && !$user->id ) : ?>
<div class="rlboxhidden">
	<div id="rlbox_register">
		<div>
			<div>
				<div>
					<div>
						
                        <img src="<?php echo JURI::base() ;?>modules/mod_tploginxtd/assets/images/register.png" alt="Register" align="left" />
                        <h3 class="xtdlogin"><?php echo JText::_('REGISTER'); ?></h3>
						<?php require_once (dirname(__FILE__).DS.'register.php'); ?>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<?php endif; ?>

<?php if( $enable_contact ) : ?>
<div class="rlboxhidden">
	<div id="rlbox_contact">
		<div>
			<div>
				<div>
					<div>
						<img src="<?php echo JURI::base() ;?>modules/mod_tploginxtd/assets/images/question.png" alt="Question" align="left" />
                        <h3 class="xtdlogin"><?php echo JText::_('CONTACT'); ?></h3>
						<?php require_once (dirname(__FILE__).DS.'contact.php'); ?>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<?php endif; ?>