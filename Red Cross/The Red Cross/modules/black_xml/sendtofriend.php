<?php

$content="
Hi $thereName\n
I found this amazing website, check it out: http://www.activeden.net \n
$yourName
";

mail($thereEmail, "recommendation from $yourName", $content, "From: $yourEmail");

$filename = "answer.txt";
$fd = fopen( $filename, "r" );
$contents = fread( $fd, filesize( $filename ) );
fclose( $fd );
mail( "$yourEmail", "Thanks for your recommendation", "$contents\n\n", "From:robwes19@activeden.net\n" );
$signal=1;
echo "signal=$signal";

?>