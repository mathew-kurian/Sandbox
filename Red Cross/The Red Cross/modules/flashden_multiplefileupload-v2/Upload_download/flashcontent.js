function insertFlash(movie,w,h,flashvars,id)
{
    document.write('<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" id="'+id+'" width="'+w+'" height="'+h+'">');
    document.write('<param name="movie" value="'+movie+'" />\n');
	document.write('<param name="allowScriptAccess" value="always" />\n');
	document.write('<param name="quality" value="high" />\n');
	document.write('<param name="flashvars" value="'+flashvars+'" />\n');
	document.write('<embed src="'+movie+'" menu="false" allowScriptAccess="always" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" id="'+id+'" width="'+w+'" height="'+h+'" flashvars="'+flashvars+'"></embed>\n');
    document.write('</object>\n');
}
