<?

include "connect.php";

$query = 'SELECT * FROM forum_posts';
$results = mysql_query($query);


echo "<?xml version =\"1.0\"?>\n";

echo "<Forum_one>\n";
while($line = mysql_fetch_assoc($results))
{

echo "<Post_".$line["thread_id"].">\n";
echo "<thread_id>" . $line["thread_id"] . "</thread_id>\n";
echo "<author>" . $line["author"] . "</author>\n";
echo "<post_time>" . $line["post_time"] . "</post_time>\n";
echo "<vsebina>" . $line["vsebina"] . "</vsebina>\n";
echo "<forumpart>" . $line["forumId"] . "</forumpart>\n";
echo "<site>" . $line["site"] . "</site>\n";
echo "<id>" . $line["id"] . "</id>\n";
echo "</Post_".$line["thread_id"].">\n\n";

}
echo "</Forum_one>";


 


?>