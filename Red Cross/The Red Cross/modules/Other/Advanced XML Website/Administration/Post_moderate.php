<?php
include "../connect.php";
//=========================================================
$id=$_POST['idd'];
$content=$_POST['Content'];
//=========================================================


mysql_select_db("flashden_forum", $con);
mysql_query("UPDATE forum_posts SET vsebina = '$content' WHERE id = '$id'");
mysql_close($con);
?>
  

