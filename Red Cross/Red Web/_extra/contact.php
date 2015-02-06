<?php


/*
------------------------------------
SET THE VARIABLES
------------------------------------
*/

$contactTo = $_POST['contactTo'];
$contactFrom = $_POST['contactFrom'];
$contactSubject = $_POST['contactSubject'];
$contactMessage = $_POST['contactMessage'];

$userTo = $_POST['userTo'];
$userFrom = $_POST['userFrom'];
$userSubject = $_POST['userSubject'];
$userMessage = $_POST['userMessage'];

// Split the contactTo emails
$contactToArray = explode(",", $contactTo);

/*
---------------------------------------
EMAIL THE INFO
---------------------------------------
*/

// Loop through each of the contact emails
for ($i = 0; $i < sizeof($contactToArray); ++$i) {

    // Send an email to each of your emails
    mail($contactToArray[$i], $contactSubject, $contactMessage, "From: ".$contactFrom);
}

// Send a confirmation email to the user
mail($userTo, $userSubject, $userMessage, "From: ".$userFrom);

echo '&emailstatus=1';

?>