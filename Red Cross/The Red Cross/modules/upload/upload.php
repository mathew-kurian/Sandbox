<?php 
echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<settings>
	<!-- Directory of the script that handles the file upload, can be .php, .cfm etc -->
	<scriptURL>upload_PHP.php</scriptURL> 
	
	<!-- Default folder to which files are uploaded, if userSetFolder is set to true this value will be overwritten by users entry -->
	<defaultFolder>../images/</defaultFolder>
	
	<!-- Boolean Value to change whether USer selects upload folder -->
	<userSetFolder>false</userSetFolder>
	
	<!-- Color for main body of app, use Hexadecimal Value -->
	<mainColor>0x6AAABF</mainColor>
	
	<!-- Color for hover state of browse button -->
	<browseColor>0x2992AB</browseColor>
	
	<!-- Color for hover state of upload button -->
	<uploadColor>0x00CC66</uploadColor>
		
	<!-- Color for file item -->
	<itemColor>0x326C89</itemColor>
	
	<!-- Valid file types for uploading, default allows Images and text fils -->
	<filetypes>
		<label>Images (*.jpg, *.jpeg, *.gif, *.png)</label> <type>*.jpg;*.jpeg;*.gif;*.png</type>
		<label>Text Files (*.txt, *.rtf)</label> <type>*.txt;*.rtf</type>
	</filetypes>
</settings>";
?>
