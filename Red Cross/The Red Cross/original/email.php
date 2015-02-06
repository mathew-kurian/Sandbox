<?

//replace these next two variable with your email address and your web address
$yourEmailAddress = "youremai@gmail.com";
$yourWebAddress = "www.yourwebsite.com";

//collect Posted variables
$name = $_POST['Name'];
$email = $_POST['Email'];
$message = $_POST['Message'];
//generic subject
$subject = "Message From Visitor";
//header
$header = 'From: '. $yourWebAddress . "\r\n" . 'Content-Type: text/html; charset=ISO-8859-1';
//email
$htmlEmail = "
<html>
	<head>
	</head>
	<body>
		<font face='Verdana' style='font-size:22px;'><b>Message from site visitor</b></font><br>
			<font face='Verdana' style='font-size:11px;'><b>Name : ".$name."</b></font><br>
			<font face='Verdana' style='font-size:11px;'><b>Email : ".$email."</b></font><br><br>
			<font face='Verdana' style='font-size:11px;'><b>Message :".$message." </b></font><br><br>
	</body>
</html>";
//php mail function
mail($yourEmailAddress,$subject,$htmlEmail,$header);
echo("Message Sent!");
?>