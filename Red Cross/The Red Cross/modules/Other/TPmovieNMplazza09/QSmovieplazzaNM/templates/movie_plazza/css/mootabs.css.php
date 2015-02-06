<?php
if (extension_loaded('zscripts') && !ini_get('zscripts.output_compression')) @ob_start('ob_gzhandler');
header('Content-type: text/css; charset: UTF-8');
header('Cache-Control: must-revalidate');
header('Expires: ' . gmdate('D, d M Y H:i:s', time() + (3600*60)) . ' GMT');
$width = (!empty($_GET['width'])) ? $_GET['width'] : 900;
$height = (!empty($_GET['height'])) ? $_GET['height'] : 180;

 /* 
=================================================
# Filename : mootabs.css.php
# Description : Dynamic CSS rules Mootabs module 
# Author : TemplatePlazza
# Author Url : http://www.templateplazza.com
# Copyright (C) 2009 TemplatePlazza.com
# All rights reserved.
=================================================
*/
?>

.mootabs {
	/*clear: both;*/

	margin:0;
	padding:10px;
	/* border:1px solid #C3C3C3; */
	
}
.mootabs_mask{
	position:relative;
	width:<?php echo $width; ?>px;
	height:<?php echo $height; ?>px;
	overflow:hidden;
}
#mootabs_box{
	position:absolute;
}
#mootabs_box div{
	width:<?php echo $width; ?>px;
	height:<?php echo $height; ?>px;
	float:left;
}
.mootabs_innerbox {

}
#mootabs_handles1, #mootabs_handles2, #mootabs_handles3, #mootabs_handles4 {
	margin:0;}
/* ===== STYLE 1 ===== */
#mootabs_handles1 {
	border-bottom:1px solid #C3C3C3;
	cursor:pointer;
	padding:10px 0;
	font-size:14px;
	text-transform:uppercase;
	font-weight:700;
	letter-spacing:-1px;
	color:#FFFFFF;
	background:url(../images/bgaccordion.png) repeat-x bottom left;
	margin:-10px -10px 0 -10px;
}
#mootabs_box .mootabs_buttons1{
	text-align:left;
	/*clear:both;*/
}

.mootabs_buttons1{/*clear:both;*/}
.mootabs_buttons1 span{color:#0080FF;cursor:pointer; line-height:normal; padding:10px ; margin-left:4px;}
/* .mootabs_buttons1 span.active, .buttons span:hover{background:#C3C3C3;color:#fff;} */

/* ===== STYLE 2 ===== */
#mootabs_handles2 {
	border-top:1px solid #C3C3C3;
	cursor:pointer;
	padding:10px 0;
	font-size:14px;
	text-transform:uppercase;
	font-weight:700;
	letter-spacing:-1px;
	color:#FFFFFF;
	background:url(../images/bgaccordion.png) repeat-x bottom left;
	margin:0 -10px -10px -10px;
}
#mootabs_box .mootabs_buttons2{
	text-align:left;
	/*clear:both;*/
}

.mootabs_buttons2{/*clear:both;*/}
.mootabs_buttons2 span{color:#0080FF;cursor:pointer;line-height:normal; padding:10px ;margin-left:4px;}
/* .mootabs_buttons2 span.active, .buttons span:hover{background:#C3C3C3;color:#fff;} */

/* ===== STYLE 3 ===== */
#mootabs_handles3 {
	border-top:1px solid #C3C3C3;
	cursor:pointer;
	padding:10px 0;
	font-size:14px;
	text-transform:uppercase;
	font-weight:700;
	letter-spacing:-1px;
	color:#FFFFFF;
	background:url(../images/bgaccordion.png) repeat-x bottom left;
	margin:0 -10px -10px -10px;
}
#mootabs_box .mootabs_buttons3{
	text-align:left;
	/*clear:both;*/
}

.mootabs_buttons3{/*clear:both;*/}
.mootabs_buttons3 span{color:#0080FF;cursor:pointer; line-height:normal; padding:10px ;margin-left:4px;}
/* .mootabs_buttons3 span.active, .buttons span:hover{background:#C3C3C3;color:#fff;} */

/* ===== STYLE 4 ===== */
#mootabs_handles4 {
	/* border-top:1px solid #C3C3C3; */
	cursor:pointer;
	padding:5px 10px;
	font-size:14px;
	text-transform:uppercase;
	font-weight:700;
	background:url(../images/bgaccordion.png) repeat-x bottom left;
	letter-spacing:-1px;
	color:#FFFFFF;
	margin:0 -10px -10px -10px;}
#mootabs_box .mootabs_buttons4{
	text-align:left;
	/*clear:both;*/
}

.mootabs_buttons4{padding:5px;/*clear:both;*/}
.mootabs_buttons4 span{background:url(../images/mootabhandle4.png);padding:0 5px;cursor:pointer;}
.mootabs_buttons4 span.active, .buttons span:hover{background:url(../images/mootabhandle4act.png);}