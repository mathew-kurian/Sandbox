<?php
include "../connect.php";
//=========================================================
$id=$_POST['post_id'];
//=========================================================

mysql_select_db("flashden_forum", $con);

mysql_query("DELETE FROM forum_posts WHERE id=$id");

mysql_close($con);
?>
  

