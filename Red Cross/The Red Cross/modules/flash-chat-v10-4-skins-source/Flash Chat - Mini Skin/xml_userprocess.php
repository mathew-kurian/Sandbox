<?php

/*
XML USERLIST MODULE
---------------------------------------------------------------------

+ Reveives user data from Flash movie on logon or logout event
+ Calculates server time
+ Loads userlist XML file from a webserver
+ Adds user to userlist
+ Removes user from userlist
+ Automatically kicks user after time-out
+ Saves updated XML file 

This script requires the PHP-XML module installed on the webserver.
---------------------------------------------------------------------
*/

$receivedName = $_POST["var1"];
$userLove = $_POST["var2"];
$userStatus = $_POST["var3"];

if($receivedName != "")
	{
	$firstTime=strtotime('now');
	$lastTime=strtotime('2009-06-01 18:00:00');
	
	$timeDiff=$firstTime-$lastTime;
	$serverTime = $timeDiff;
	$receivedDateEntry = $serverTime;
	}

if ($userLove == "kick")
	{
	$doc = new DOMDocument();
    $doc->load( 'userlist.xml' );

	$counter = $doc->getElementsByTagName( "entry" );
    $users = $doc->getElementsByTagName( "user" );
	
    foreach( $users as $user )
    {
		for( $i = 0; $i <= $counter->length; $i++ )
  		{
  		$authors = $user->getElementsByTagName( "name" );
  		$author = $authors->item($i)->nodeValue;
	
			if ($author == $receivedName)
			{
			$tomodify = $user->getElementsByTagName('entry')->item($i);			
			
			$modify = $user->getElementsByTagName( 'user_love' );
			$modify->item($i)->nodeValue = $userLove;
			
			$test = $doc->save("userlist.xml");
			}
		}
  	}
	}
	
	
if ($userLove == "ban")
	{
	$doc = new DOMDocument();
    $doc->load( 'userlist.xml' );

	$counter = $doc->getElementsByTagName( "entry" );
    $users = $doc->getElementsByTagName( "user" );
	
		foreach( $users as $user )
		{
			for( $i = 0; $i <= $counter->length; $i++ )
			{
			$authors = $user->getElementsByTagName( "name" );
			$author = $authors->item($i)->nodeValue;
		
				if ($author == $receivedName)
				{
				$tomodify = $user->getElementsByTagName('entry')->item($i);			
				
				$modify = $user->getElementsByTagName( 'user_love' );
				$modify->item($i)->nodeValue = $userLove;
				
				$test = $doc->save("userlist.xml");
				}
			}
		}
	}


if ($userLove == "suicide")
	{
	$userip = getRealIpAddr();
	
	$xdoc = new DomDocument;
	$xdoc->preserveWhiteSpace = false;
	$xdoc->formatOutput = true;
  
	$xdoc->Load('banlist.xml');

	$ban = $xdoc->getElementsByTagName('ban')->item(0);
	$entry = $xdoc->createElement('entry');
	
	$ip = $xdoc->createElement('ip');
	$ipNode = $xdoc->createTextNode ($userip);
	$ip -> appendChild($ipNode);
	$entry -> appendChild($ip);
	
	$ban -> appendChild($entry);
	
	$test = $xdoc->save("banlist.xml");
	
	
	$doc = new DOMDocument();
    $doc->load( 'userlist.xml' );

	$counter = $doc->getElementsByTagName( "entry" );
    $users = $doc->getElementsByTagName( "user" );
	
		foreach( $users as $user )
		{
			for( $i = 0; $i <= $counter->length; $i++ )
			{
			$authors = $user->getElementsByTagName( "name" );
			$author = $authors->item($i)->nodeValue;
		
				if ($author == $receivedName)
				{
				$tomodify = $user->getElementsByTagName('entry')->item($i);			
				
				$modify = $user->getElementsByTagName( 'user_love' );
				$modify->item($i)->nodeValue = "kick";
				
				$test = $doc->save("userlist.xml");
				}
			}
		}
	}


if ($userStatus == "ping")
	{
	$firstTime=strtotime('now');
	$lastTime=strtotime('2009-06-01 18:00:00');
	
	$timeDiff=$firstTime-$lastTime;
	$currentping = $timeDiff;	
	
	$doc = new DOMDocument();
    $doc->load( 'userlist.xml' );

	$counter = $doc->getElementsByTagName( "entry" );
    $users = $doc->getElementsByTagName( "user" );
	
    foreach( $users as $user )
    {
		for( $i = 0; $i <= $counter->length; $i++ )
  		{
  		$authors = $user->getElementsByTagName( "name" );
  		$author = $authors->item($i)->nodeValue;
	
			if ($author == $receivedName)
			{
			$tomodify = $user->getElementsByTagName('entry')->item($i);			
			
			$modify = $user->getElementsByTagName( 'ping_time' );
			$modify->item($i)->nodeValue = $currentping;
			
			$serverTimes = $user->getElementsByTagName( "date_entry" );
			$serverTime = $serverTimes->item($i)->nodeValue;
			$onlineTime = $currentping - $serverTime;
			
			$modifyonlineTime = $user->getElementsByTagName( 'online_time' );
			$modifyonlineTime->item($i)->nodeValue = $onlineTime;
			
			$test = $doc->save("userlist.xml");
			}
		}
  	}
	}


if ($userStatus == "online")
	{
	$xdoc = new DomDocument;
	$xdoc->preserveWhiteSpace = false;
	$xdoc->formatOutput = true;
  
	$xdoc->Load('userlist.xml');

	$chat = $xdoc->getElementsByTagName('user')->item(0);
	
	$entry = $xdoc->createElement('entry');
	
	$name = $xdoc->createElement('name');
	$nameNode = $xdoc->createTextNode ($receivedName);
	$name -> appendChild($nameNode);
	$entry -> appendChild($name);
	
	$entryDate = $xdoc->createElement('date_entry');
	$entryDateNode = $xdoc->createTextNode ($receivedDateEntry);
	$entryDate -> appendChild($entryDateNode);
	$entry -> appendChild($entryDate);
	
	$pingTime = $xdoc->createElement('ping_time');
	$pingTimeNode = $xdoc->createTextNode ($receivedDateEntry);
	$pingTime -> appendChild($pingTimeNode);
	$entry -> appendChild($pingTime);
	
	$onlineTime = $xdoc->createElement('online_time');
	$onlineTimeNode = $xdoc->createTextNode ('0');
	$onlineTime -> appendChild($onlineTimeNode);
	$entry -> appendChild($onlineTime);
	
	$userLoveStatus = $xdoc->createElement('user_love');
	$userLoveStatusNode = $xdoc->createTextNode ($userLove);
	$userLoveStatus -> appendChild($userLoveStatusNode);
	$entry -> appendChild($userLoveStatus);
	
	$chat -> appendChild($entry);
	
	$test = $xdoc->save("userlist.xml");
	}

	
if ($userStatus == "logout")
	{
	$doc = new DOMDocument();
  
    $doc->load( 'userlist.xml' );
  
    $counter = $doc->getElementsByTagName( "entry" );
    $users = $doc->getElementsByTagName( "user" );

    foreach( $users as $user )
    {
		for( $i = 0; $i <= $counter->length; $i++ )
  		{
  		$authors = $user->getElementsByTagName( "name" );
  		$author = $authors->item($i)->nodeValue;
	
			if ($author == $receivedName)
			{
			$todelete = $user->getElementsByTagName('entry')->item($i);
			$deleted = $user->removeChild($todelete);
			$test = $doc->save("userlist.xml");
			}
		}
  	}
	}


$firstTime=strtotime('now');
$lastTime=strtotime('2009-06-01 18:00:00');
	
$timeDiff=$firstTime-$lastTime;
$currentping = $timeDiff;
$messageTimeStamp = date("G:i");
$userip = getRealIpAddr();

$doc = new DOMDocument();
$doc->load( 'userlist.xml' );
  
$counter = $doc->getElementsByTagName( "entry" );
$users = $doc->getElementsByTagName( "user" );
    
	foreach( $users as $user )
    {
		if($counter->length != 0)
		{
		for( $i = 0; $i <= $counter->length; $i++ )
  		{
		$entryDates = $user->getElementsByTagName( "ping_time" );
  		$entryDate = $entryDates->item($i)->nodeValue;
		
		$timeDifference = $currentping - $entryDate;

			if ($entryDate > 0 && $timeDifference > 15 && $timeDifference < 1000000) // Sets automatic user kick from chat
			{
			$currentUsers = $user->getElementsByTagName( "name" );
  			$currentUser = $currentUsers->item($i)->nodeValue;
			
			$todelete = $user->getElementsByTagName('entry')->item($i);
			$user->removeChild($todelete);
			
			$test = $doc->save("userlist.xml");
			
			$xdoc = new DomDocument;
			$xdoc->preserveWhiteSpace = false;
			$xdoc->formatOutput = true;
			  
			$xdoc->Load('chathistory.xml');
			
			$chat = $xdoc->getElementsByTagName('chat')->item(0);
			
			$entry = $xdoc->createElement('entry');
			
			$name = $xdoc->createElement('name');
			$nameNode = $xdoc->createTextNode ($currentUser);
			$name -> appendChild($nameNode);
			$entry -> appendChild($name);
			
			$leaveMessage = "is no longer online...";
			$message = $xdoc->createElement('message');
			$messageNode = $xdoc->createTextNode ($leaveMessage);
			$message -> appendChild($messageNode);
			$entry -> appendChild($message);
			
			$messagetime = $xdoc->createElement('messagetime');
			$messagetimeNode = $xdoc->createTextNode ($currentping);
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
			$nameNode = $xdoc->createTextNode ($currentUser);
			$name -> appendChild($nameNode);
			$entry -> appendChild($name);
			
			$leaveMessage = "is no longer online...";
			$message = $xdoc->createElement('message');
			$messageNode = $xdoc->createTextNode ($leaveMessage);
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
			
			
			$xdoc = new DomDocument;
			$xdoc->preserveWhiteSpace = false;
			$xdoc->formatOutput = true;
			  
			$xdoc->Load('chathistory.xml');
			
			$counter = $xdoc->getElementsByTagName( "entry" );
			$maxMessages = 4; // Messages begin to delete one by one after total messages in the chathistory XML exceed the set value
			
			if ($counter->length > $maxMessages)
					{
					$root = $xdoc->documentElement;
					$punkt = $root->getElementsByTagName('entry')->item(0);
					$root->removeChild($punkt);
					$test = $xdoc->save("chathistory.xml");
					}
			}
		}
		}
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
