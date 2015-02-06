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
class COXYMallNews extends CPlugin{
	
	var $tplvars; 

	function COXYMallNews() {
		//$this->CPlugin($db, $tables , $templates);
	}

	function DoEvents(){
		global $base, $_CONF, $_TSM , $_VARS , $_USER , $_BASE , $_SESS;

		parent::DoEvents();

		if ($_GET["sub"] == "oxymall.plugin.news.xml") {
			return $this->GenerateXML();
		}
	}

	function GenerateXml() {
		global $base;

		$this->module->plugins["modules"]->MimeXML();

		$this->tpl_module = $this->module->plugins["modules"]->LoadModuleInfo();

		$template = new CTemplate($this->tpl_path . "main.xml");

		//load the images for this module
		$news = $this->db->QFetchRowArray(
			"SELECT * FROM {$this->tables['plugin:news_items']} " .
			"WHERE module_id={$this->tpl_module[mod_id]} ORDER BY item_date DESC"
		);

		$this->module->EncodeItems(
			&$news, 
			array(					
				"item_title" , 
				"item_url" , 
				"item_urltitle" , 
			)
		);

		//process for date
		if (is_array($news)) {
			foreach ($news as $key => $val) {
				$news[$key]["item_date"] = date($this->tpl_module["settings"]["set_date_format"] , $val["item_date"]);

				if ($val["item_main_title"]) {
					$news[$key]["main_title"] = $val["item_main_title"];
				}
				
			}			
		}
		

		return CTemplateStatic::Replace(
			$template->blockReplace(
				"Main" ,
				array(
					"mod_title" => $this->tpl_module["mod_long_name"],
					"mod_urltitle" => $this->tpl_module["mod_urltitle"],
					"mod_url" => $this->tpl_module["mod_url"],

					"items" => $base->html->Table(
						$template,
						"Items",
						$news
					),
					"main_title" => $this->tpl_module["settings"]["set_popup_title"]
				)
			),
			$this->tpl_module["settings"]
		);
		
	}
	

}

?>