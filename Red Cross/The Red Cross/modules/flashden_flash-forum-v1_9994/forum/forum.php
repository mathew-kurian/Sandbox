<?

include "connect.php";

$query = 'SELECT * FROM forum';
$results = mysql_query($query);


echo "<?xml version =\"1.0\"?>\n";

echo "<Forum>\n";
while($line = mysql_fetch_assoc($results))
{

echo "<Forum_threads".$line["id"].">\n\n";

echo "<threads>" . $line["threads"] . "</threads>\n";
echo "<id>" . $line["id"] . "</id>\n";

echo "</Forum_threads".$line["id"].">\n\n\n";

}
echo "</Forum>";



 


?>