<?php

error_reporting(0);

define( '_JEXEC', 1 );
define('JPATH_BASE', str_replace(array('modules\mod_tploginxtd\assets','modules/mod_tploginxtd/assets'),'',dirname(__FILE__)) );	
define( 'DS', DIRECTORY_SEPARATOR );
require_once ( JPATH_BASE .DS.'includes'.DS.'defines.php' );
require_once ( JPATH_BASE .DS.'includes'.DS.'framework.php' );
$mainframe =& JFactory::getApplication('site');
$mainframe->initialise();
$session =& JFactory::getSession();

$lang = & JFactory :: getLanguage();
$lang->load('mod_tploginxtd', JPATH_BASE);
jimport( 'joomla.methods' );

$captcha_value = $session->get('TPContactModCaptcha');
$neccesary_fields = array(
	JText::_('FIRST NAME')		=>'first_name',
	JText::_('LAST NAME')			=>'surname'		
);	

$_POST['name'] = ( !empty( $_POST['name'] ) ) ? $_POST['name'] : null;
$_POST['email'] = ( !empty( $_POST['email'] ) ) ? $_POST['email'] : null;
$_POST['subject'] = ( !empty( $_POST['subject'] ) ) ? $_POST['subject'] : null;
$_POST['text'] = ( !empty( $_POST['text'] ) ) ? $_POST['text'] : null;
$_POST['captcha_ver'] = ( !empty( $_POST['captcha_ver'] ) ) ? $_POST['captcha_ver'] : null;

$error = array();
$fields = array();

$fields['name'] = 0;
if( empty( $_POST['name'] ) )
{
	$error[] = JText::_('ENTER YOUR NAME');
	$fields['name'] = 1;
}

$fields['email'] = 0;
if( !preg_match( "/^([a-zA-Z?0-9?\_?\.?]+)@([a-zA-Z?\.?\-?]+)\.([a-zA-Z?]{2,6})$/i", $_POST['email'] ) )
{
	$error[] = JText::_('EMAIL VERIFY');
	$fields['email'] = 1;
}

$fields['subject'] = 0;
if( empty( $_POST['subject'] ) )
{
	$error[] = JText::_('ENTER SUBJECT');
	$fields['subject'] = 1;
}

$fields['text'] = 0;
if( empty( $_POST['text'] ) )
{
	$error[] = JText::_('ENTER MESSAGE');
	$fields['text'] = 1;
}

$fields['captcha_ver'] = 0;
if( $captcha_value != $_POST['captcha_ver'] )
{
	$error[] = JText::_('CAPTCHA VERIFY');
	$fields['captcha_ver'] = 1;
}		
	
if( count($error) > 0 )
{
	require('JSON.class.php');
	$response = array('err_fields'=>$fields, 'error'=>$error[0]);
	$json = new JSON($response);
	echo $json->result;
	exit();
}

$db	=& JFactory::getDBO();
$sql = "SELECT params FROM #__modules WHERE module = 'mod_tploginxtd' AND id='".$_POST['mid']."'";
$db->setQuery( $sql );
$p = $db->loadObjectList();		
require_once(JPATH_BASE.DS.'libraries'.DS.'joomla'.DS.'html'.DS.'parameter.php');		
$params = new JParameter($p[0]->params, JPATH_BASE.DS.'modules'.DS.'mod_tploginxtd'.DS.'mod_tploginxtd.xml');

require_once('PHPMailer.class.php');
$mail = new PHPMailer();
$mail->From = $_POST['email'];
$mail->FromName = $_POST['name'];
$mail->Subject = $params->get('contact_subject', 'New Contact');
//$mail->ReplyTo = $_POST['email'];

$mail->AddAddress($params->get('your_email'));

$body = array();
$body[] = '<table width="500" style="font-family:verdana; font-size:12px;">';
$body[] = '<tr><td>'.JText::_('NAME LABEL').'</td><td>'.$_POST['name'].'</td></tr>';
$body[] = '<tr><td>'.JText::_('EMAIL LABEL').'</td><td>'.$_POST['email'].'</td></tr>';
$body[] = '<tr><td>'.JText::_('SUBJECT LABEL').'</td><td>'.$_POST['subject'].'</td></tr>';
$body[] = '<tr><td>'.JText::_('MESSAGE LABEL').'</td><td>'.nl2br($_POST['text']).'</td></tr>';
$body[] = '</table>';		

$mail->IsHTML(true);
$mail->Body = implode("\n",$body);
require('JSON.class.php');

if( $mail->Send() )
{
	$response = array('success'=> $params->get('sent_msg'));
	$json = new JSON($response);
	echo $json->result;
	exit();
}		
else
{
	$response = array('error'=>JText::_('NOT SENT'));
	$json = new JSON($response);
	echo $json->result;
	exit();
}

?>