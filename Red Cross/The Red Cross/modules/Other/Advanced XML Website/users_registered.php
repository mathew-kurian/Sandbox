<?

include "connect.php";

$query = 'SELECT * FROM users';
$results = mysql_query($query);


echo "<?xml version =\"1.0\"?>\n";

echo "<Users>\n";
while($line = mysql_fetch_assoc($results))
{
echo "<Member>\n";
echo "<username>" . $line["username"] . "</username>\n";

echo "</Member>\n";
}
echo "</Users>";


?>