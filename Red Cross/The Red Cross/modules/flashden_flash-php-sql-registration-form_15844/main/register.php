<?php
// set your infomation.
$dbhost='hostname';
$dbusername='username';
$dbuserpass='password';
$dbname='database';
// connect to the mysql database server.
//Connect to server and select databse.
mysql_connect("$dbhost", "$dbusername", "$dbuserpass")or die("cannot connect to server"); 
mysql_select_db("$dbname")or die ("no database");

// value sent from form 
$Flashemail=$_POST['Flashemail'];
//echo "$Flashemail";
// table name 
$tbl_name=member; 
// retrieve email from table where e-mail = $email 
$sql="SELECT email FROM $tbl_name WHERE email='$Flashemail'";
$result=mysql_query($sql);
$count=mysql_num_rows($result);
$rows=mysql_fetch_array($result);
$your_password=$rows['email'];
//echo "$your_password";
if($your_password==$Flashemail){
$signal=4;
echo "signal=$signal";
}
else {
if (!mysql_select_db("$dbname")) die(mysql_error());
$name = $_POST['name'];
$pass = $_POST['pass'];
$email = $_POST['Flashemail'];
$query = "INSERT INTO member (username, password, email) VALUES('$name','$pass','$email')";
mysql_query($query) or die(mysql_error());
//echo "$user succussfully registered!";
$signal=5;
echo "signal=$signal";
}
?>