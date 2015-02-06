<?php

include "connect.php";

/*THIS VARIABLE IS WHAT TABLE YOU ARE USING...IF YOU USED MY SQL FILE, THEN YOUR DEFAULT TABLE*/
/*NAME SHOULD BE 'userv2' AND YOU DO NOT NEED TO CHANGE ANYTHING, BUT IF YOU MADE YOUR OWN TABLE,*/
/*CHANGE THIS VARIABLE.*/
$tableName = "users";

//Post all of the users information (md5 Encrypt the password)
$username = $_POST['username'];
$password = md5($_POST['password']);
$email = $_POST['email'];
$posts = 0;
mkdir ("./Users/$username", 0600, true);

//grab all the usernames in the table
$sql1 = mysql_query("SELECT * FROM $tableName WHERE username = '$username'");
//grab all the emails in the table
$sql2 = mysql_query("SELECT * FROM $tableName WHERE email = '$email'");
//get number of results from both queries
$row1 = mysql_num_rows($sql1);
$row2 = mysql_num_rows($sql2);
//if there is a result it will be either 1 or higher
if($row1 > 0 || $row2 > 0) {
	//echo username or email is already in use and deny registration.
	echo "&msgText=Username or email already in use!";
} else {
	//if there was no existing username or email, insert all their information into the database.
		$insert = mysql_query("INSERT INTO $tableName (username,password,email) VALUES ('$username','$password','$email')") or die(mysql_error());
		$insert = mysql_query("INSERT INTO users_stats (username,posts) VALUES ('$username','$posts')") or die(mysql_error());
	
	//and echo "Successfully registered!" and take them to a "thanks for registering" frame in flash
	echo "&msgText=Successfully registered!";
	echo "&nameText=$firstName";

}
?>