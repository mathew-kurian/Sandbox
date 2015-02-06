<?
include "connect.php";

//=========================================================
$datum=$_POST['datum'];
$threadName=$_POST['threadName'];
$threadContent=$_POST['threadContent'];
$threadId=$_POST['threadId'];
$author_odgovora2=$_POST['author_odgovora2'];
//=========================================================
$thread_id_odgovora=$_POST['thread_id_odgovora'];
$author_odgovora=$_POST['author_odgovora'];
$post_time_odgovora=$_POST['post_time_odgovora'];
$vsebina_odgovora=$_POST['vsebina_odgovora'];
$forum_part=$_POST['forum_part'];
$Site=$_POST['site'];
$threads_total=$_POST['threads_total'];

if($threadId == 16){
$site = 1;
}else if($threadId <= 30 && $threadId > 16){
$site = 1;
}else if($threadId <= 45 && $threadId > 30){
$site = 2;
}else if($threadId <= 60 && $threadId > 45){
$site = 3;
}else if($threadId <= 75 && $threadId > 60){
$site = 4;
}else if($threadId <= 90 && $threadId > 75){
$site = 5;
}else if($threadId <= 105 && $threadId > 90){
$site = 6;
}else if($threadId <= 120 && $threadId > 105){
$site = 7;
}else if($threadId <= 135 && $threadId > 120){
$site = 8;
}else if($threadId <= 150 && $threadId > 135){
$site = 9;
}else if($threadId <= 165 && $threadId > 150){
$site = 10;
}else if($threadId <= 180 && $threadId > 165){
$site = 11;
}else if($threadId <= 195 && $threadId > 180){
$site = 12;
}else if($threadId <= 210 && $threadId > 195){
$site = 13;
}else if($threadId <= 225 && $threadId > 210){
$site = 14;
}



$con = mysql_connect("localhost","root","lorencic");

if (!$con)
  {
  die('Could not connect: ' . mysql_error());
  }

mysql_select_db("flashden_forum", $con);

//$insert = mysql_query("INSERT INTO forum_threads () VALUES ()");

$insert = mysql_query("INSERT INTO forum_threads (forum_id, thread_id, posts_number, last_post, post_title, reply_number,last_user, last_post_time, vsebina, author, post_time, site) VALUES ('$forum_part', '$threadId', '0','0','$threadName','0','0','0','$threadContent','$author_odgovora','$datum', '$site')");

$insert = mysql_query("INSERT INTO forum_posts (thread_id, author, post_time, vsebina, forumId) VALUES ('$thread_id_odgovora','$author_odgovora','$post_time_odgovora','$vsebina_odgovora', '$forum_part')");

mysql_query("UPDATE forum SET  threads = '$threads_total' WHERE id = '$forum_part'");

echo($insert);
mysql_close($con);

?>