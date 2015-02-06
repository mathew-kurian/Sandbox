<?

include "connect.php";

$query = 'SELECT * FROM users_stats';
$results = mysql_query($query);


echo "<?xml version =\"1.0\"?>\n";

echo "<users_stats>\n";
while($line = mysql_fetch_assoc($results))
{

echo "<user".$line["username"].">\n\n";

echo "<username>" . $line["username"] . "</username>\n";
echo "<posts>" . $line["posts"]. "</posts>\n";


echo "</Forum_one_posts".$line["username"].">\n\n\n";

}
echo "</user>";



?>