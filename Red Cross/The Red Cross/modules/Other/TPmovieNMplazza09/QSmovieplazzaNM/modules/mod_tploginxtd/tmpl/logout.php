<?php // no direct access 
defined('_JEXEC') or die('Restricted access');
?>
<div class="rl_logout">
<form action="index.php" method="post" name="login" id="form-login">
	<a href="javascript: void(0)" onClick="document.login.submit();"><?php echo JText::_( 'BUTTON_LOGOUT'); ?></a>
	<input type="hidden" name="option" value="com_user" />
	<input type="hidden" name="task" value="logout" />
	<input type="hidden" name="return" value="<?php echo $return; ?>" />
</form>
</div>
<div class="rl_logout">
<?php
if( $params->get('greeting') )
{
	echo 'Welcome ';
	$name = $params->get('name', 0);
	echo ( $name ) ? $user->name : $user->username;
}
?>
</div>
<?php
$rlmodules = &JModuleHelper::getModules( 'right_login' );
if( count( $rlmodules ) )
{
	echo '<div class="rl_logout_right">';
	$rlmodules = &JModuleHelper::getModules( 'right_login' );
	foreach ($rlmodules as $m)
	{
		$_options = array( 'style' => 'xhtml' );
		echo JModuleHelper::renderModule( $m, $_options );
	}
	echo '</div>';
}
?>