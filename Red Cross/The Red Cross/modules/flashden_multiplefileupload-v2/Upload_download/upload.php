<?php
//get uploaddir
$theUploadFolder = "upload";
$filename = $_FILES['Filedata']['name'];
$uploaddir = $theUploadFolder."/".$filename;
//move the uploaded file
move_uploaded_file($_FILES['Filedata']['tmp_name'], $uploaddir);
chmod($uploaddir, 0777);
?>