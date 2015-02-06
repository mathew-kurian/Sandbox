<?php
	/**
	* TemplatePlazza
	**/
	defined('_JEXEC') or die('Restricted access');
	$document					= &JFactory::getDocument();
	$menupos					= $params->get("menupos", "bottom");
	$skin						= $params->get("skin", "blue");
	$showtitle					= $params->get("showtitle", 1);
	$showdesc					= $params->get("showdesc", 1);
	$showthumb					= $params->get("showthumb", 1);
	$color						= $params->get("textcolor", "ff6600");
	$highquality				= $params->get("highquality", 1);
	$logopos					= $params->get("logopos", "left");
	$previewimageresizemode		= $params->get("previewimageresizemode", 0);
	$videoresizemode			= $params->get("videoresizemode", 0);
	$document->addScript(JURI::base(true) . "/modules/mod_tpplayer/tmpl/swfobject.js", "text/javascript");
	
	if($menupos == "left" || $menupos == "right"){
		$width	= 890;
		$height	= 350;
		if($showtitle == 0 && $showdesc == 0){
			$width	= 735;
		}
	}else{
		$width	= 640;
		$height	= 423;
	}
	
	if($showtitle == 0 && $showdesc == 0 && $showthumb == 0){
		$width	= 640;
		$height	= 350;
	}
	
	$flashvars	= "u=" . JURI::root() . "&mp=" . $menupos . "&w=" . $width . "&h=" . $height . "&skin=" . $skin . "&c=0x" . $color . "&st=" . $showtitle . "&sd=" . $showdesc . "&stu=" . $showthumb . "&hq=" . $highquality . "&pirm=" . $previewimageresizemode . "&vrm=" . $videoresizemode . "&lp=" . $logopos;
	$script		= '
		var flashvars = {
			u: "' . JURI::root() . '",
			mp: "' . $menupos . '",
			w: "' . $width . '",
			h: "' . $height . '",
			skin: "' . $skin . '",
			c: "0x' . $color . '",
			st: "' . $showtitle . '",
			sd: "' . $showdesc . '",
			stu: "' . $showthumb . '",
			hq: "' . $highquality . '",
			pirm: "' . $previewimageresizemode . '",
			vrm: "' . $videoresizemode . '",
			lp: "' . $logopos . '"
		};
		var params = {
			play: "true",
			wmode: "opaque",
			scale: "scale",
			quality: "high",
			salign: "t",
			allowFullScreen: "true",
			menu: "true",
			allowScriptAccess: "always",
			loop: "false"
		};
		var attributes = {
			id: "myDynamicContent",
			name: "myDynamicContent"
		};
		swfobject.embedSWF("' . JURI::base(true) . '/modules/mod_tpplayer/tmpl/tpplayer.swf", "myflash", "' . $width . '", "' . $height . '", "9.0.0","expressInstall.swf", flashvars, params, attributes);
	';
	$document->addScriptDeclaration($script, "text/javascript");
?>
	<div id="myflash"></div>
	<!--
	<script type="text/javascript">
		var so = new SWFObject("<?php echo JURI::base(true); ?>/modules/mod_tpplayer/tmpl/tpplayer.swf", "myflash", "<?php echo $width; ?>", "<?php echo $height; ?>", "9", "");
		so.addParam("FlashVars", "<?php echo $flashvars; ?>");
		so.addParam("play", "true");
		so.addParam("wmode", "opaque");
		so.addParam("scale", "scale");
		so.addParam("quality", "high");
		so.addParam("salign", "t");
		so.addParam("allowFullScreen", "true");
		so.addParam("menu", "true");
		so.addParam("allowScriptAccess", "always");
		so.addParam("loop", "false");
		so.write("myflash");
	</script>
	-->