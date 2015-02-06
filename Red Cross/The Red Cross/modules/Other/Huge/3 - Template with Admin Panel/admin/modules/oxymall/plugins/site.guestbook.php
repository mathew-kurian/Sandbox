<?php
/*
	OXYLUS Development web framework
	copyright (c) 2002-2007 OXYLUS Development
		web:  www.oxylus.ro
		mail: support@oxylus.ro		

	$Id: name.php,v 0.0.1 dd/mm/yyyy hh:mm:ss oxylus Exp $
	description
*/

// dependencies

/**
* description
*
* @library	
* @author	
* @since	
*/
class COXYMallGuestbook extends CPlugin{
	
	var $tplvars; 

	function COXYMallGuestbook() {
		//$this->CPlugin($db, $tables , $templates);
	}

	function DoEvents(){
		global $base, $_CONF, $_TSM , $_VARS , $_USER , $_BASE , $_SESS;

		parent::DoEvents();

		if ($_GET["sub"] == "oxymall.plugin.guestbook.xml") {
			return $this->GenerateXML();
		}

		if ($_GET["sub"] == "oxymall.plugin.guestbook.post") {
			return $this->PostMessage();
		}

	}

	function GenerateXml() {
		global $base;

		$this->module->plugins["modules"]->MimeXML();

		$this->tpl_module = $this->module->plugins["modules"]->LoadModuleInfo();

		$template = new CTemplate($this->tpl_path . "main.xml");

		//check for approval
		if ($this->tpl_module["settings"]["set_confirm"]) {
			$cond = "AND item_status=2";
		} else 
			$cond = "";
		

		if ($this->tpl_module["settins"]["set_reverse_order"]) {
			//load the images for this module
			$messages = $this->db->QFetchRowArray(
				"SELECT * FROM {$this->tables['plugin:guestbook_items']} " .
				"WHERE module_id={$this->tpl_module[mod_id]} {$cond} ORDER BY item_date ASC"
			);
		} else {		
			//load the images for this module
			$messages = $this->db->QFetchRowArray(
				"SELECT * FROM {$this->tables['plugin:guestbook_items']} " .
				"WHERE module_id={$this->tpl_module[mod_id]} {$cond} ORDER BY item_date DESC"
			);
		}

		//get the smiles
		$smiles = $this->db->QFetchRowArray(
				"SELECT * FROM {$this->tables['plugin:guestbook_images']} ORdER BY img_order ASC"
			);

		$this->module->EncodeItems(
			&$messages, 
			array(					
				"item_name" , 
			)
		);

		$this->module->EncodeItems(
			&$smiles, 
			array(					
				"img_text" , 
			)
		);

		return CTemplateStatic::Replace(
			$template->blockReplace(
				"Main" ,
				array(
					"mod_title" => $this->tpl_module["mod_long_name"],
					"items" => $base->html->Table(
						$template,
						"",
						$messages
					),
					"smiles"	=> $base->html->Table(
						$template,
						"Images",
						$smiles
					),
				)
			),
			$this->tpl_module["settings"]
		);
		
	}

	function PostMessage() {
		$this->tpl_module = $this->module->plugins["modules"]->LoadModuleInfo();

		
		if (!$_POST["mes"]) {
			die("s=false");
		}

		if (!$_POST["name"]) {
			die("s=false");
		}
		

		//save the message in database
		$message = array(
			"item_date" => time(),
			"item_status" => 1,
			"item_name" => $_POST["name"],
			"item_body" => $_POST["mes"],
			"module_id" => $this->tpl_module["mod_id"],
		);

		$id = $this->db->QueryInsert(
				$this->tables["plugin:guestbook_items"],
				$message
		);

		//send the notification emails

		die("s=true");
	}
	
	function AlternateContent() {
		global $base;

		$this->tpl_module = $this->module->plugins["modules"]->LoadModuleInfo();
		$template = new CTemplate($this->tpl_path . "main.htm");	

		$messages = $this->db->QFetchRowArray(
			"SELECT * FROM {$this->tables['plugin:guestbook_items']} " .
			"WHERE module_id={$this->tpl_module[mod_id]} {$cond} ORDER BY item_date DESC"
		);

		return CTemplateStatic::replace(
			str_replace(
				"../../guestbook/",
				"upload/guestbook/",
				$base->html->table(
					$template , 
					"",
					$messages
				)
			),

			$this->tpl_module
		);
	}

	function GetAllLinks($module , $links) {
	}
	
}

?>