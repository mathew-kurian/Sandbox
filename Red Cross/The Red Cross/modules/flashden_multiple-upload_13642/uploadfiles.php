<?php
$uploaddir = $_SERVER['DOCUMENT_ROOT']."upload/";
if(count($_FILES) > 0)
{
	$arrfile = pos($_FILES);

	$uploadfile = $uploaddir . basename($arrfile['name']);

	if (move_uploaded_file($arrfile['tmp_name'], $uploadfile))
	echo "File is valid, and was successfully uploaded.\n";
}

?>