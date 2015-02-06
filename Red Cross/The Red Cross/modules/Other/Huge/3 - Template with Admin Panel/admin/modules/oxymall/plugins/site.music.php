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
class COXYMallMusic extends CPlugin{
	
	var $tplvars; 

	function COXYMallMusic() {
		//$this->CPlugin($db, $tables , $templates);
	}

	function DoEvents(){
		global $base, $_CONF, $_TSM , $_VARS , $_USER , $_BASE , $_SESS;

		parent::DoEvents();

		if ($_GET["sub"] == "oxymall.plugin.mp3player.xml") {
			return $this->GenerateXML();
		}
	}

	function GenerateXml() {
		global $base;

		$this->module->plugins["modules"]->MimeXML();

		$template = new CTemplate($this->tpl_path . "main.xml");

		//load the module
		$module = $this->module->plugins["modules"]->LoadDefaultModule("music");

		//load the images for this module
		$items = $this->db->QFetchRowArray(
			"SELECT * FROM {$this->tables['plugin:music_items']} " .
			"ORDER BY item_order ASC"
		);


		return CTemplateStatic::Replace(
			$template->blockReplace(
				"Main" ,
				array(
					"items" => $base->html->Table(
						$template,
						"Items",
						$items
					)
				)
			),
			array(
				"status"	=> $module["module_unique_enabled"] ? "true" : "false",
				"action"	=> $module["settings"]["set_onfirststart"],
				"volume"	=> $module["settings"]["set_playingvolume"],
			)
			
		);
		
	}
	

	function GetAllLinks($module , $links) {
	}

}

?>