<?

if (isset($_GET['image'])) {

	$ch = curl_init();
	
	curl_setopt($ch, CURLOPT_URL, $_GET['image']);
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
	curl_setopt($ch, CURLOPT_HEADER, false);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	
	$str = curl_exec($ch);
	curl_close($ch);
	
	header("Content-type: image/jpeg");
	header("Content-Length: " . strlen($str));

	echo $str;	
	
}
else {

	$ch = curl_init();
	
	curl_setopt($ch, CURLOPT_URL, "http://www.youtube.com/get_video_info?&video_id=" . $_GET['id']);
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, false);
	curl_setopt($ch, CURLOPT_HEADER, true);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	
	$header = curl_exec($ch);
	
	$vpos = strpos($header, 'fmt_map=');
	$fmt = '22';
	
	if ($vpos) {
		$fmt_map = substr($header, $vpos + 8);
		$fmt_map = explode(',', urldecode(substr($fmt_map, 0, strpos($fmt_map, "&"))));
		for ($i = 0; $i < count($fmt_map); $i++) {
			if (substr($fmt_map[$i], 0, 3) == '18/') { // High Quality
				$fmt = '&fmt=18';
			}
			else if (substr($fmt_map[$i], 0, 3) == '22/') { // HD
				$fmt = '&fmt=22';
				break;
			}
		}
		
	}
	
	$vpos = strpos($header, 'token=');
	
	if ($vpos) {
		$header = substr($header, $vpos + 6);
		$token = substr($header, 0, strpos($header, "&"));
		
		curl_setopt($ch, CURLOPT_URL, "http://www.youtube.com/get_video?video_id=" . $_GET['id'] . "&t=" . $token . $fmt);
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, false);
		curl_setopt($ch, CURLOPT_HEADER, true);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		
		$header = curl_exec($ch);
		
		$vpos = strpos($header, 'Location: ');
		if ($vpos) {
			$header = substr($header, $vpos + 10);
			$url = substr($header, 0, strpos($header, "\n"));
			echo '<xml><video video_id="'.$url.'" /></xml>';
			die;
		}
		
	}
	
	echo '<xml><message error="Bad URL." /></xml>';	
}

?>