<?
// set your infomation.
$dbhost='hostname';
$dbusername='username';
$dbuserpass='password';
$dbname='database';
//this pulls the variables from the flash movie when the user
//hits submit.  Use this when your global variables are off.
//I don't know how to toggle global variables, so I just put
//it in all the time ;)
$user=$_POST['user'];
$pass=$_POST['pass'];

//connect to database
if ($user && $pass){
	mysql_pconnect("$dbhost","$dbusername","$dbuserpass") or die ("didn't connect to mysql");
	mysql_select_db("$dbname") or die ("no database");
//make query
$query = "SELECT * FROM member WHERE username = '$user' AND password = '$pass'";
$result = mysql_query( $query ) or die ("didn't query");

//see if there's an EXACT match
$num = mysql_num_rows( $result );
if ($num == 1){
	print "status=You're in&checklog=1";
	} else {
	print "status=Sorry, but your user name and password did not match a user name/password combination in our database.  Usernames and passwords are entered in from a different file.  Thank you for visiting test login script!!&checklog=2";
}
}

?>