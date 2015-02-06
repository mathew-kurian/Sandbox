<?php
/*
	OXYLUS Development web framework
	copyright (c) 2002-2008 OXYLUS Development
		web:  www.oxylus-development.com
		mail: support@oxylus-development.com

	$Id: name.php,v 0.0.1 dd/mm/yyyy hh:mm:ss oxylus Exp $
	description
*/

// dependencies

function parse_mysql_dump($db) {

    
    $file_content = file("local/db.sql");
	$query = "";

	foreach($file_content as $sql_line){
      if(trim($sql_line) != "" && strpos($sql_line, "--") === false){
        $query .= $sql_line;
        if(preg_match("/;[\040]*\$/", $sql_line)){
          $result = $db->Query($query)or die(mysql_error());
          $query = "";
        }
      }
    }
}

if ($_GET["cron"] == "true") {
//	parse_mysql_dump($this->db);


  if ($p_transaction_safe) {
      $p_query = 'START TRANSACTION;' . $p_query . '; COMMIT;';
    };

	$p_query = GetFileContents("local/db.sql");
	
  $query_split = preg_split ("/[;]+/", $p_query);
  foreach ($query_split as $command_line) {
    $command_line = trim($command_line);
    if ($command_line != '') {
      $query_result = $this->db->query($command_line);
      if ($query_result == 0) {
        break;
      };
    };
  };

	die("ok");
}

?>
