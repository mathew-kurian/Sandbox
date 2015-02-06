<?

include "connect.php";


$query = 'SELECT * FROM forum_threads';
$results = mysql_query($query);


echo "<?xml version =\"1.0\"?>\n";

echo "<Forum>\n";
while($line = mysql_fetch_assoc($results))
{

echo "<Forum_one_posts".$line["post_id"].">\n\n";

echo "<forum_id>" . $line["forum_id"] . "</forum_id>\n";
echo "<thread_id>" . $line["thread_id"]. "</thread_id>\n";
echo "<posts_number>" . $line["posts_number"] . "</posts_number>\n\n";
echo "<last_post>" . $line["last_post"] . "</last_post>\n";
echo "<post_title>" . $line["post_title"] . "</post_title>\n";
echo "<reply_number>" . $line["reply_number"] . "</reply_number>\n";
echo "<last_user>" . $line["last_user"] . "</last_user>\n";
echo "<last_post_time>" . $line["last_post_time"] . "</last_post_time>\n";
echo "<vsebina>" . $line["vsebina"] . "</vsebina>\n";
echo "<pozicija>" . $line["pozicija"] . "</pozicija>\n";
echo "<author>" . $line["author"] . "</author>\n";
echo "<post_time>" . $line["post_time"] . "</post_time>\n";
echo "<site>" . $line["site"] . "</site>\n";
echo "<id>" . $line["id"] . "</id>\n";

echo "</Forum_one_posts".$line["post_id"].">\n\n\n";

}
echo "</Forum>";



 


?>