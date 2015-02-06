<?php
$file = fopen("comments.xml", "w+") or die("Can't open XML file");
$xmlString = $HTTP_RAW_POST_DATA; 
if(!fwrite($file, $xmlString)){
    print "Error writing to XML-file";
}
print $xmlString."\n";
fclose($file);
?>
