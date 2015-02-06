<?php

$username = $_GET["username"];

	if (is_uploaded_file($_FILES['Filedata']['tmp_name']))	 {
		
		
		$uploadDirectory ="Users/$username/";
		$uploadFile = $uploadDirectory . basename("default.jpg");
				
		copy($_FILES['Filedata']['tmp_name'], $uploadFile);
		
	}
	
?>