<?
include "connect.php";

$query = 'SELECT * FROM forum_posts';
$results = mysql_query($query);


echo "<?xml version =\"1.0\"?>\n";

echo "<Total_Posts>\n";
while($line = mysql_fetch_assoc($results))
{
echo "<thread_id>" . $line["thread_id"] . "</thread_id>\n";
}
echo "</Total_Posts>";



?>