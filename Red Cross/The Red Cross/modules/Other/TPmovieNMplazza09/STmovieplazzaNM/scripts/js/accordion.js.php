<?php
 /* 
=================================================
# Filename : accordion.js.php
# Description : Javascript file for accordion
# Author : TemplatePlazza
# Author Url : http://www.templateplazza.com
# Copyright (C) 2009 TemplatePlazza.com
# All rights reserved.
=================================================
*/
if (extension_loaded('zscripts') && !ini_get('zscripts.output_compression')) @ob_start('ob_gzhandler');
header('Content-type: application/x-javascript; charset: UTF-8');
header('Cache-Control: must-revalidate');
header('Expires: ' . gmdate('D, d M Y H:i:s', time() + (3600*60)) . ' GMT');

if(!empty($_GET))
{
	foreach($_GET as $key => $val)
	{
		unset($_GET[$key]);
		$val = (substr($val, 0, 4) == 'amp;') ? substr($val, 4) : $val;
		$key = (substr($key, 0, 4) == 'amp;') ? substr($key, 4) : $key;
		$_GET[$key] = $val;
	}
}


$display = (!empty($_GET['display'])) ? $_GET['display'] : 'none';
$coo = (!empty($_COOKIE["tpFMAccordion"])) ? $_COOKIE["tpFMAccordion"] : null;
if(!empty($coo)) $display = $coo+1;
$hideall = (!empty($_GET['hideall'])) ? $_GET['hideall'] : 0;
$hideall = ($hideall) ? 'true' : 'false';
$opacity = (!empty($_GET['opacity'])) ? $_GET['opacity'] : 0;
$opacity = ($opacity) ? 'true' : 'false';
?>

function createCookie(name,value) {
	document.cookie = name+"="+value;
}

window.addEvent('domready', function() {
	var tpAccordion = new Accordion($('tpaccordion'), 'div.tpaccordiontoggler', 'div.tpaccordionelement', {
		<?php if( $display != 'none' && (int) $display ) : ?>
		display: <?php echo $display-1; ?>,
		<?php endif; ?>
		alwaysHide: <?php echo $hideall; ?>,
		opacity: <?php echo $opacity; ?>,
		onActive: function(toggler, element){
			toggler.className+="-active";
			//toggler.setStyle('color', '#666666');
			createCookie("tpFMAccordion", this.togglers.indexOf(toggler));
		},
		onBackground: function(toggler, element){
			toggler.className=toggler.className.replace(new RegExp("-active\\b"),"")
			//toggler.setStyle('color', '#CCCCCC');
		}
	});
});