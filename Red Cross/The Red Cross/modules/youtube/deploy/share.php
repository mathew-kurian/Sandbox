<?php
  $recipientEmail = urldecode($_POST["recipientEmail"]);//Do not modify unless you know what you are doing ;-)
  $videoURL = urldecode($_POST["videoURL"]);//Do not modify unless you know what you are doing ;-)
  
  $subject = "Here goes your subject";//Edit this text according to your wishes. This is the email subject
  $message = "Here goes your message including the video URL. Video URL: $videoURL";//Edit this text according to your wishes. This the email text including the video URL.
 
  mail($recipientEmail, $subject, $message);
?>