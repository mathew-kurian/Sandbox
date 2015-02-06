<?
// set your infomation.
$dbhost='hostname';
$dbusername='username';
$dbuserpass='password';
$dbname='database';
//Connect to server and select databse.
mysql_connect("$dbhost", "$dbusername", "$dbuserpass")or die("cannot connect to server"); 
mysql_select_db("$dbname")or die ("no database");

// value sent from form 
$pemail=$_POST['pemail'];

// table name 
$tbl_name=member; 

// retrieve password from table where e-mail = $pemail 
$sql="SELECT password FROM $tbl_name WHERE email='$pemail'";
$result=mysql_query($sql);

// if found this e-mail address, row must be 1 row 
// keep value in variable name "$count" 
$count=mysql_num_rows($result);

// compare if $count =1 row
if($count==1){

$rows=mysql_fetch_array($result);

// keep password in $your_password
$your_password=$rows['password'];
// ---------------- SEND MAIL FORM ---------------- 

// send e-mail to ...
$to=$pemail; 

// Your subject 
$subject="Your Domain Support Team"; 

// From 
$header="from: Your Password Recovery <your email>"; 

// Your message 
$messages.="Your password is: $your_password \r\n";


// send email 
$sentmail = mail($to,$subject,$messages,$header); 

}

// else if $count not equal 1 
else {
//echo "EMAIL HAS NOT FOUND!";
$signal=3;
echo "signal=$signal";
} 

// if your email succesfully sent 
if($sentmail){
//echo "PASSWORD HAS BEEN SENT.";
$signal=1;
echo "signal=$signal";
}
else {
//echo "ERROR SENDING PASSWORD!";
}
?>
