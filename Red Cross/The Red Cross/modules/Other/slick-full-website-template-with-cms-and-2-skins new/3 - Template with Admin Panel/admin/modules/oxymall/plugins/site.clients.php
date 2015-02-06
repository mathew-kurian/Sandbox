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
class COXYMallClients extends CPlugin{
	
	var $tplvars; 

	function COXYMallClients() {
		//$this->CPlugin($db, $tables , $templates);
	}

	function DoEvents(){
		global $base, $_CONF, $_TSM , $_VARS , $_USER , $_BASE , $_SESS;

		parent::DoEvents();

		if ($_GET["sub"] == "oxymall.plugin.clients.xml") {
			return $this->GenerateXML();
		}
	}

	function GenerateXml() {
		global $base;

		$this->module->plugins["modules"]->MimeXML();

		$this->tpl_module = $this->module->plugins["modules"]->LoadModuleInfo();

		$template = new CTemplate($this->tpl_path . "main.xml");

		if ($this->tpl_module["settings"]["set_reverseorder"]) {
			//load the images for this module
			$images = $this->db->QFetchRowArray(
				"SELECT * FROM {$this->tables['plugin:clients_images']} " .
				"WHERE module_id={$this->tpl_module[mod_id]} ORDER BY item_order DESC"
			);
		} else  {
			//load the images for this module
			$images = $this->db->QFetchRowArray(
				"SELECT * FROM {$this->tables['plugin:clients_images']} " .
				"WHERE module_id={$this->tpl_module[mod_id]} ORDER BY item_order ASC"
			);
		}


		$this->module->EncodeItems(
			&$images, 
			array(					
				"item_name" , 
				"item_url" , 
			)
		);

		return CTemplateStatic::Replace(
			$template->blockReplace(
				"Main" ,
				array(
					"mod_url" => $this->tpl_module["mod_url"],
					"header" => $this->vars->data["clients_header_" . $this->tpl_module["mod_id"]],
					"title" => $this->tpl_module["mod_long_name"],
					"images" => $base->html->Table(
						$template,
						"Images",
						$images
					)
				)
			),
			$this->tpl_module["settings"]
		);
		
	}
}

?>