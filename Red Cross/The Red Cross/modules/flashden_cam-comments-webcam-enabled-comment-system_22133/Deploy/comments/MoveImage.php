<?php
	//Used to copy the temporary file over to our new location
	$file = 'example.txt';
	$newfile = 'example.txt.bak';

	if (!copy($file, $newfile)) {
    	echo "failed to copy $file...\n";
	}
?>
