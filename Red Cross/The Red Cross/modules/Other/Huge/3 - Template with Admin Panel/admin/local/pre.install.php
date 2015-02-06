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

$tables = $this->db->QFetchRowArray("SHOW tables;");

if (!count($tables)) {
	$file = file("../local/db.sql");
	if (is_array($file)) {
		foreach ($file as $key => $val) {
			if (trim($val)) {
				$this->db->Query($val);
			}			
		}		
	}	

	echo '<script>alert("Database installed!\nPlease login in admin panel with: \n\nUsername: admin\nPassword: test")</script>';
}


?>
