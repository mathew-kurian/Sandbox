<?php

	/*  
		@author: Constantin Boiangiu
		This is a very simple math captcha that displays a simple math operation and in
		order to validate, the user needs to enter the operation result. This is public code
		developed by myself.
	*/
	
	// Set flag that this is a parent file
	define( '_JEXEC', 1 );
	define('JPATH_BASE', str_replace(array('modules\mod_tploginxtd\assets','modules/mod_tploginxtd/assets'),'',dirname(__FILE__)) );	
	define( 'DS', DIRECTORY_SEPARATOR );
	
	require_once ( JPATH_BASE .DS.'includes'.DS.'defines.php' );
	require_once ( JPATH_BASE .DS.'includes'.DS.'framework.php' );
	
	$mainframe =& JFactory::getApplication('site');
	$mainframe->initialise();

	/* captcha script */
	$operators=array('+','-','*');
	$first_num=rand(1,5);
	$second_num=rand(6,11);
	shuffle($operators);
	$expression=$second_num.$operators[0].$first_num;

	eval("\$session_var=".$second_num.$operators[0].$first_num.";");

	/* set session value */
	$session =& JFactory::getSession();
	$session->set('TPContactModCaptcha', $session_var);
	
	$img=imagecreate(50,30);

	$text_color		 = imagecolorallocate($img,255,255,255);
	$background_color= imagecolorallocate($img,0,0,0);

	imagefill($img,0,50,$background_color);
	imagettftext($img,12,rand(-10,10),rand(10,10),rand(15,20),$background_color,"fonts/courbd.ttf",$expression);

	header("Content-type:image/jpeg");
	header("Content-Disposition:inline ; filename=secure.jpg");
	imagejpeg($img);

?>