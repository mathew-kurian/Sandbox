<script src="flashcontent.js" type="text/javascript"></script>
<?
$theUploadFolder = "upload";
//get space used;
$spaceUsed = 0;
	if ($dir = @opendir($theUploadFolder)) {
	
	  while (($file = readdir($dir)) !== false) {
		if($file != '.' && $file !='..'){
			$spaceUsed = $spaceUsed + filesize($theUploadFolder."/".$file);
		}
	  }
	}
?>

<p><script type="text/javascript">insertFlash("file_upload2.swf",590,400,"&spaceUsed=<?= $spaceUsed;?>",'uploader'); </script></p>