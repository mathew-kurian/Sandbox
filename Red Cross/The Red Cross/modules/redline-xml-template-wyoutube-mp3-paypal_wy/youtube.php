<?php

	//YouTube direct link...
	function youtube_directlink($video_url){
	   $html = file_get_contents($video_url);
	   if(preg_match("/var fullscreenUrl = '(.*?)';/",$html,$match)){
		      $direct_url = $match[1];
		      $direct_url = preg_replace('/\/watch_fullscreen/',"http://youtube.com/get_video.php",$direct_url );
		      return $direct_url ;
	   }
	}
	//
	echo "directlink=".urlencode(youtube_directlink($_REQUEST["url"]));

?>


