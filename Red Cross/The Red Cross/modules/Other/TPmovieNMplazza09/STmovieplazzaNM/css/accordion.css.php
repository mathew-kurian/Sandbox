<?php
 /* 
=================================================
# Filename : accordion.css.php
# Description : Dynamic CSS rules Accordion module 
# Author : TemplatePlazza
# Author Url : http://www.templateplazza.com
# Copyright (C) 2009 TemplatePlazza.com
# All rights reserved.
=================================================
*/

if (extension_loaded('zscripts') && !ini_get('zscripts.output_compression')) @ob_start('ob_gzhandler');
header('Content-type: text/css; charset: UTF-8');
header('Cache-Control: must-revalidate');
header('Expires: ' . gmdate('D, d M Y H:i:s', time() + (3600*60)) . ' GMT');

?>

#tpaccordion {


	}
.tpaccordiontoggler, .tpaccordiontoggler-active {
	cursor:pointer;
	padding:10px 10px 10px 0;
	font-size:16px;
	text-transform:uppercase;
	font-weight:700;
	letter-spacing:-1px;
    border-bottom: 3px solid #CCC;        
    color: #666;
    background-color:#FFF;
}

.tpaccordiontoggler {
}

.tpaccordiontoggler-active {
	color:#ccc;
    background:url(../images/bgaccordion.png) 100% 0;


}

#tpaccordion div.tpaccordionelement {
}

#tpaccordion div.tpaccordionelement-inner {
	padding:5px 0;
    margin:0;
}