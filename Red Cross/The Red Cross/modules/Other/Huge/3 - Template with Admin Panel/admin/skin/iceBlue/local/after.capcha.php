<?php
/*
	OXYLUS Development web framework
	copyright (c) 2002-2005 OXYLUS Development
		web:  www.oxylus.ro
		mail: support@oxylus.ro		

	$Id: name.php,v 0.0.1 dd/mm/yyyy hh:mm:ss author Exp $
	description
*/

// dependencies


if ($_GET["global"] == "security") {

	//Select Font
	$font = "skin/iceBlue/local/capcha/font/1.ttf";

	//Select random background image
	$bgurl = rand(1, 1);
	$im = ImageCreateFromPNG("skin/iceBlue/local/capcha/images/bg".$bgurl.".png");

	//Generate the random string
	$chars = array("a","A","b","B","c","C","d","D","e","E","f","F","g","G","h","H","i","I","j","J","k","K","l","L","m","M","n","N","o","O","p","P","q","Q","r","R","s","S","t","T","u","U","v","V","w","W","x","X","y","Y","z","Z","1","2","3","4","5","6","7","8","9");

	$length = 4;
	$textstr = "";

	for ($i=0; $i<$length; $i++) {
	   $textstr .= $chars[rand(0, count($chars)-1)];
	}

	$_SESSION[$_CONF["site"]]["XML_verify_key"] = $textstr;

	//Create random size, angle, and dark color
	$size = rand(12, 12);
	$angle = 0;//rand(-0, 5);
	$color = ImageColorAllocate($im, rand(200, 255), rand(200, 255), rand(200, 255));

	//Determine text size, and use dimensions to generate x & y coordinates
	$textsize = imagettfbbox($size, $angle, $font, $textstr);
	$twidth = abs($textsize[2]-$textsize[0]);
	$theight = abs($textsize[5]-$textsize[3]);
	$x = (imagesx($im)/2)-($twidth/2)+(rand(-20, 20));
	$y = (imagesy($im))-($theight/2);


	//Add text to image
	ImageTTFText($im, $size, $angle, $x, $y, $color, $font, $textstr);

	//Output PNG Image
	header("Content-Type: image/png");
	ImagePNG($im);

	//Destroy the image to free memory
	imagedestroy($im);

	die();

}

?>
