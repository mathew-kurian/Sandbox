<?php

/*
XML CHATHISTORY MODULE
---------------------------------------------------------------------

+ Checks if a user with the same name is already connected before loging in
+ Gives the server time to the Flash movie

This scripte requires the PHP-XML module installed on the webserver.
---------------------------------------------------------------------
*/

$receivedName = $_POST["var1"];
$receivedTimeRequest = $_POST["var2"];
$receivedCommand = $_POST["var3"];

if($receivedTimeRequest == "getTime")
	{
	$serverTime = date("G:i");
	echo "resultServerTime=" . $serverTime . "&resultPassword=chat123";

	$xdoc = new DomDocument;
	$xdoc->preserveWhiteSpace = false;
	$xdoc->formatOutput = true;
	$xdoc->Load('chathistory.xml');
	
	$counter = $xdoc->getElementsByTagName( "entry" );
	
	$maxMessages = 4;
	
	if ($counter->length > $maxMessages)
			{
			$root = $xdoc->documentElement;
	
			$punkt = $root->getElementsByTagName('entry')->item(0);
			$root->removeChild($punkt);
			
			$test = $xdoc->save("chathistory.xml");
			}
	}


if($receivedCommand == "clear")
	{
	$doc = new DOMDocument();
	$doc->load( 'chathistory.xml' );
	
	$counter = $doc->getElementsByTagName( "entry" );
	$messages = $doc->getElementsByTagName( "chat" );
	
	$messageCounter = $counter->length;
	
		if($messageCounter != 0)
		{	
			foreach( $messages as $message )
			{
				for( $i = 0; $i < $messageCounter; $i++ )
				{
				$todelete = $message->getElementsByTagName('entry')->item(0);
				$deleted = $message->removeChild($todelete);
				}
			}
		}

	$xmlfile = $doc->save("chathistory.xml");
	
	
	$doc = new DOMDocument();
	$doc->load( 'chatarchive.xml' );
	
	$counter = $doc->getElementsByTagName( "entry" );
	$messages = $doc->getElementsByTagName( "chat" );
	
	$messageCounter = $counter->length;
	
		if($messageCounter != 0)
		{	
			foreach( $messages as $message )
			{
				for( $i = 0; $i < $messageCounter; $i++ )
				{
				$todelete = $message->getElementsByTagName('entry')->item(0);
				$deleted = $message->removeChild($todelete);
				}
			}
		}

	$xmlfile = $doc->save("chatarchive.xml");
	}


$processName = str_ireplace('sven', 'sven', $receivedName);
$processName = str_ireplace('admin', 'admin', $processName);
$processName = str_ireplace('svenadmin', 'svenadmin', $processName);
$processName = str_ireplace('administrator', 'administrator', $processName);
$processName = str_ireplace('creator', 'creator', $processName);
$processName = str_ireplace('owner', 'owner', $processName);
$processName = str_ireplace('moderator', 'moderator', $processName);
$processName = str_ireplace('mod', 'mod', $processName);
$processName = str_ireplace('mindprobe', 'mindprobe', $processName);
$processName = str_ireplace('chatbot', 'chatbot', $processName);
$receivedName = $processName;

if($receivedName != "")
	{
	$userip = getRealIpAddr();
	
	$doc = new DOMDocument();
	$doc->load( 'banlist.xml' );
	  
	$counter = $doc->getElementsByTagName( "entry" );
	$bans = $doc->getElementsByTagName( "ban" );
	
		foreach( $bans as $ban )
		{
			for( $i = 0; $i <= $counter->length; $i++ )
			{
			$ips = $ban->getElementsByTagName( "ip" );
			$ip = $ips->item($i)->nodeValue;

				if($ip == $userip)
				{
				echo "resultUserCheck=BANNED";
				$check = "banned";
				break;
				}
			}
		}
	}


if($receivedName != "" && $check != "banned")
	{
	$doc = new DOMDocument();
	$doc->load( 'userlist.xml' );
	  
	$counter = $doc->getElementsByTagName( "entry" );
	$users = $doc->getElementsByTagName( "user" );
	
		foreach( $users as $user )
		{
			for( $i = 0; $i <= $counter->length; $i++ )
			{
			$names = $user->getElementsByTagName( "name" );
			$name = $names->item($i)->nodeValue;
			
			$name = strtolower($name);
			$receivedName = strtolower($receivedName);
				
				if($name == $receivedName)
				{
				$check = "exists";
				}
			}
		}
		
		if($check == "exists")
		{
		echo "resultUserCheck=YES";
		}
		else
		{
			if($receivedName == "admin" 
			or $receivedName == "administrator"
			or $receivedName == "mindprobe"
			or $receivedName == "svenadmin"
			or $receivedName == "chatbot"
			or $receivedName == "moderator"
			or $receivedName == "mod"
			or $receivedName == "sven"
			or $receivedName == "owner")
			{
			echo "resultUserCheck=ILLEGAL";
			}
			else
			{
			echo "resultUserCheck=NO";
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
