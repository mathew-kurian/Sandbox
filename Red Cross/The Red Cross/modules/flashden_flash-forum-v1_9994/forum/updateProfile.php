<?php
//include the connect script
include "connect.php";

/*THIS VARIABLE IS WHAT TABLE YOU ARE USING...IF YOU USED MY SQL FILE, THEN YOUR DEFAULT TABLE*/
/*NAME SHOULD BE 'userv2' AND YOU DO NOT NEED TO CHANGE ANYTHING, BUT IF YOU MADE YOUR OWN TABLE,*/
/*CHANGE THIS VARIABLE.*/
$tableName = "users";

//Post the new information they entered.
$user = $_POST['thePerson'];
$pass1 = md5($_POST['pw1']);
$pass2 = md5($_POST['pw2']);

//Gather the users current information.
$sql1 = mysql_query("SELECT * FROM $tableName WHERE username = '$user'");
$arr = mysql_fetch_array($sql1);



//if the 'current password' field doesnt match their current password in the database, echo "Current password doesn't match"
if($pass1 != $arr[2]) {
	echo("&msgText=Current password doesn't match.");
} elseif($emailrow > 0 && $email != $arr[5]) {
	echo("&msgText=That email is already in use!");
} else {
	//if they match, update all the fields, even if they havent changed.
	mysql_query("UPDATE $tableName SET password = '$pass2' WHERE username = '$user'");
	echo("&msgText=Successfully Updated.");	
}
?>
