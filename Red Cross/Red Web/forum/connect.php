<?php
//YOU MUST FILL THESE OUT IN ORDER TO CONNECT TO THE DATABASE.
$host = "localhost";
$usernameDB = "localforum";
$passwordDB = "localforum123";
$whichDB = "localforum";
//connect with host,username and password
$con = mysql_connect($host,$usernameDB,$passwordDB);
//if it cant connect echo cant connect and mysql_error;
if (!$con) {
	echo "unable to connect to DB";
	echo mysql_error($con);
	exit();
}
//select the database
$db = mysql_select_db($whichDB);
//if it cant open the DB, echo cant open DB and echo mysql_error
if (!$db) {
	echo "unable to open DB";
	echo mysql_error($db);
	exit();
}
?>