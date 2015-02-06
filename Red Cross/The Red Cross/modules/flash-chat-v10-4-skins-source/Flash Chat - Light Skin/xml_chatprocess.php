<?php

/*
XML CHATHISTORY MODULE
---------------------------------------------------------------------

+ Reveives message data from Flash movie on send
+ Applies filters to messages to convert smileys, links, etc.
+ Calculates server time
+ Loads chathistory XML file from a webserver
+ Adds message to XML file
+ Auto-cleans chathistory if total messages exceed $maxMessages (default = 40)
+ Saves updated XML file 

This scripte requires the PHP-XML module installed on the webserver.
---------------------------------------------------------------------
*/

$receivedName = $_POST["var1"];
$receivedMessage = $_POST["var2"];
$receivedTime = $_POST["var3"];

$processMessage = str_ireplace('fuck', '****', $receivedMessage);
$processMessage = str_ireplace('shit', '****', $processMessage);
$processMessage = str_ireplace('bitch', '****', $processMessage);
$processMessage = str_ireplace('slut', '****', $processMessage);
$processMessage = str_ireplace('cunt', '****', $processMessage);
$processMessage = str_ireplace('asshole', '****', $processMessage);
$processMessage = str_ireplace('fucker', '****', $processMessage);
$processMessage = str_ireplace('retard', '****', $processMessage);
$processMessage = str_ireplace('whore', '****', $processMessage);
$processMessage = str_ireplace('nigga', '****', $processMessage);
$processMessage = str_ireplace('nazi', '****', $processMessage);
$processMessage = str_ireplace('hitler', '****', $processMessage);
$processMessage = str_ireplace('wanker', '****', $processMessage);
$processMessage = str_ireplace('cock', '****', $processMessage);
$processMessage = str_ireplace('dick', '****', $processMessage);

$processMessage = str_ireplace('img', '***', $processMessage);
$processMessage = str_ireplace('c=', '**', $processMessage);
$processMessage = str_ireplace('<br', '**', $processMessage);
$processMessage = str_ireplace('r>', '**', $processMessage);
$processMessage = str_ireplace('p>', '**', $processMessage);
$processMessage = str_ireplace('e=', '**', $processMessage);
$processMessage = str_ireplace('t=', '**', $processMessage);
$processMessage = str_ireplace('.gif', '**', $processMessage);
$processMessage = str_ireplace('.jpg', '**', $processMessage);
$processMessage = str_ireplace('.jpeg', '**', $processMessage);
$processMessage = str_ireplace('.png', '**', $processMessage);
$processMessage = str_ireplace('.bmp', '**', $processMessage);

$processMessage = str_replace("\'", "'", $processMessage);
$processMessage = str_replace('\"', '"', $processMessage);

$processMessage = replace_uri($processMessage);

$enterMessage = "Enters " . date("l jS \of F \@ G:i:s");
$leaveMessage = "Leaves " . date("l jS \of F \@ G:i:s");

$processMessage = str_ireplace('enters @', $enterMessage, $processMessage);
$processMessage = str_ireplace('leaves @', $leaveMessage, $processMessage);

$receivedMessage = $processMessage;

$userip = getRealIpAddr();

if($receivedName != "")
	{
	$firstTime=strtotime('now');
	$lastTime=strtotime('2009-06-01 18:00:00');
	
	$timeDiff=$firstTime-$lastTime;
	$serverTime = $timeDiff;
	$receivedTime = $serverTime;
	$messageTimeStamp = date("G:i");
	
	$xdoc = new DomDocument;
	$xdoc->preserveWhiteSpace = false;
	$xdoc->formatOutput = true;
	$xdoc->Load('chathistory.xml');

	$chat = $xdoc->getElementsByTagName('chat')->item(0);
	
	$entry = $xdoc->createElement('entry');
	
	$name = $xdoc->createElement('name');
	$nameNode = $xdoc->createTextNode ($receivedName);
	$name -> appendChild($nameNode);
	$entry -> appendChild($name);
	
	$message = $xdoc->createElement('message');
	$messageNode = $xdoc->createTextNode ($receivedMessage);
	$message -> appendChild($messageNode);
	$entry -> appendChild($message);
	
	$messagetime = $xdoc->createElement('messagetime');
	$messagetimeNode = $xdoc->createTextNode ($receivedTime);
	$messagetime -> appendChild($messagetimeNode);
	$entry -> appendChild($messagetime);
	
	$timestamp = $xdoc->createElement('timestamp');
	$timestampNode = $xdoc->createTextNode ($messageTimeStamp);
	$timestamp -> appendChild($timestampNode);
	$entry -> appendChild($timestamp);
	
	$userIP = $xdoc->createElement('ip');
	$userIPNode = $xdoc->createTextNode ($userip);
	$userIP -> appendChild($userIPNode);
	$entry -> appendChild($userIP);
	
	$chat -> appendChild($entry);
	
	$test = $xdoc->save("chathistory.xml");
	
	
	$xdoc = new DomDocument;
	$xdoc->preserveWhiteSpace = false;
	$xdoc->formatOutput = true;
	$xdoc->Load('chatarchive.xml');

	$chat = $xdoc->getElementsByTagName('chat')->item(0);
	
	$entry = $xdoc->createElement('entry');
	
	$name = $xdoc->createElement('name');
	$nameNode = $xdoc->createTextNode ($receivedName);
	$name -> appendChild($nameNode);
	$entry -> appendChild($name);
	
	$message = $xdoc->createElement('message');
	$messageNode = $xdoc->createTextNode ($receivedMessage);
	$message -> appendChild($messageNode);
	$entry -> appendChild($message);
	
	$messagetime = $xdoc->createElement('messagetime');
	$messagetimeNode = $xdoc->createTextNode ("2");
	$messagetime -> appendChild($messagetimeNode);
	$entry -> appendChild($messagetime);
	
	$timestamp = $xdoc->createElement('timestamp');
	$timestampNode = $xdoc->createTextNode ($messageTimeStamp);
	$timestamp -> appendChild($timestampNode);
	$entry -> appendChild($timestamp);
	
	$userIP = $xdoc->createElement('ip');
	$userIPNode = $xdoc->createTextNode ($userip);
	$userIP -> appendChild($userIPNode);
	$entry -> appendChild($userIP);
	
	$chat -> appendChild($entry);
	
	$test = $xdoc->save("chatarchive.xml");
	}
	
$xdoc = new DomDocument;
$xdoc->preserveWhiteSpace = false;
$xdoc->formatOutput = true;
$xdoc->Load('chathistory.xml');

$counter = $xdoc->getElementsByTagName( "entry" );

$maxMessages = 4; // Messages begin to delete one by one after total messages in the chathistory XML exceed the set value
echo "maximumMessages=".$maxMessages;

if ($counter->length > $maxMessages)
		{
		$root = $xdoc->documentElement;

		$punkt = $root->getElementsByTagName('entry')->item(0);
		$root->removeChild($punkt);
		
		$test = $xdoc->save("chathistory.xml");
		}

function replace_uri($str) 
{
  $pattern = '#(^|[^\"=]{1})(http://|ftp://|mailto:|news:)([^\s<>]+)([\s\n<>]|$)#sm';
  return preg_replace($pattern,"\\1<a href=\"\\2\\3\" target=\"_blank\"><font color=\"#FF8400\"><u>\\2\\3</u></font></a>\\4",$str);
}

function getRealIpAddr()
	{
		if (!empty($_SERVER['HTTP_CLIENT_IP']))   //check ip from share internet
		{
		  $ip=$_SERVER['HTTP_CLIENT_IP'];
		}
		elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR']))   //to check ip is pass from proxy
		{
		  $ip=$_SERVER['HTTP_X_FORWARDED_FOR'];
		}
		else
		{
		  $ip=$_SERVER['REMOTE_ADDR'];
		}
		return $ip;
	}	
?>
