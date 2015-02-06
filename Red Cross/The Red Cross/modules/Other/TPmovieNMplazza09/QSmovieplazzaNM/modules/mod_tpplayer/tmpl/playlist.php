<?php
	/**
	* TemplatePlazza
	**/
	require_once "../../../configuration.php";
	$db		= new JConfig;
	$dbname	= $db->db;
	$dbuser	= $db->user;
	$dbpass	= $db->password;
	$dbhost	= $db->host;
	$prefix	= $db->dbprefix;
	
	$link	= mysql_connect($dbhost, $dbuser, $dbpass);
	if(!$link){
		die('Could not connect: ' . mysql_error());
	}
	
	$sel	= mysql_select_db($dbname, $link);
	if(!$sel){
		die ('Can\'t use db: ' . mysql_error());
	}
	
	$q		= mysql_query("SELECT params FROM " . $prefix . "modules WHERE module='mod_tpplayer'");
	if(!$q){
		die('Could not query:' . mysql_error());
	}
	$result	= mysql_result($q, 0);
	$result	= split("\n", $result);
	$t		= 0;
	$a		= array();
	$b		= array();
	foreach($result as $item){
		if($item != ""){
			if($t > 9){ //other parameters beside movie data
				echo "&" . $item;
				$movie	= strstr($item,"flv");
				if($movie != FALSE){
					$val	= substr($item,strpos($item, "=")+1);
					if(trim($val) != ""){
						$a[]		= 1;
					}
				}
			}
			$t++;
		}
	}
	echo "&count=10";
	mysql_close($link);
?>