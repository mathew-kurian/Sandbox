<?php
//include the connect script
include "connect.php";

/*THIS VARIABLE IS WHAT TABLE YOU ARE USING...IF YOU USED MY SQL FILE, THEN YOUR DEFAULT TABLE*/
/*NAME SHOULD BE 'userv2' AND YOU DO NOT NEED TO CHANGE ANYTHING, BUT IF YOU MADE YOUR OWN TABLE,*/
/*CHANGE THIS VARIABLE.*/
$tableName = "users";

//Post Variables from flash
$username = $_POST['username'];
//Encrypt the password with md5
$password = md5($_POST['password']);

$sql2 = mysql_query("SELECT * FROM users_stats WHERE username = '$username'");
//Get the number of results from the query.
$rows2 = mysql_num_rows($sql2);
//Gather all of the users information to display it in flash
$arr2 = mysql_fetch_array($sql2);

$posts = $arr2[1];


//Select all names and passwords that are equal to what the user entered.
$sql = mysql_query("SELECT * FROM $tableName WHERE username = '$username' and password = '$password'");
//Get the number of results from the query.
$rows = mysql_num_rows($sql);
//Gather all of the users information to display it in flash
$arr = mysql_fetch_array($sql);

$user = $arr[1];
$email = $arr[3];
$user_level = $arr[4];


//If their is a match of username and password, echo "Entrance Granted!" (this provokes flash's actions. Also echo the users information so flash can read it.
if($rows == 1) {
	echo "&msgText=Entrance Granted!";
	echo "&whosIn=$fname $lname";
	echo "&userName=$user";
	echo "&email=$email";
	echo "&posts=$posts";
	echo "&user_level=$user_level";
} else {
//If their was no match echo Invalid login and let flash take over from here.
	echo "&msgText=Invalid Login!";
}
?>
