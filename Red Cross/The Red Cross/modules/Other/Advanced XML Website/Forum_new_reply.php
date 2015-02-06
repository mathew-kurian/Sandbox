<?
include "connect.php";

//=========================================================
$thread_id_odgovora=$_POST['thread_id_odgovora'];
$author_odgovora=$_POST['author_odgovora'];
$post_time_odgovora=$_POST['post_time_odgovora'];
$vsebina_odgovora=$_POST['vsebina_odgovora'];
$forum_id=$_POST['forum_id'];
$post_site=$_POST['post_site'];
$posts=$_POST['Posts'];
$user=$_POST['user'];

$id=$_POST['Id'];
$posts_number=$_POST['posts_number'];

//=========================================================
	
	$files = $post_site;
	$f = $files - 6;
	$o = $files / 6;
	$z = floor($o);
	for ($i = 0; $i < $files; $i++) {
		if ($z == $i) {
			$c = $z;
		} else if( $z > $i ){
			$c = $z + 1;
		}
	}
	$t = floor($c);


$insert = mysql_query("INSERT INTO forum_posts (thread_id,author,post_time,vsebina, forumId, site) VALUES ('$thread_id_odgovora','$author_odgovora','$post_time_odgovora','$vsebina_odgovora', '$forum_id', '$t')");

mysql_query("UPDATE users_stats SET posts = $posts WHERE username = $user");

mysql_query("UPDATE forum_threads SET posts_number = $posts_number WHERE id = $id");


?>