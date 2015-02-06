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
class COXYMallServices extends CPlugin{	
	
	var $tplvars; 

	function COXYMallServices() {
		//$this->CPlugin($db, $tables , $templates);
	}

	function DoEvents(){
		global $base, $_CONF, $_TSM , $_VARS , $_USER , $_BASE , $_SESS;

		parent::DoEvents();

		if ($_GET["sub"] == "oxymall.plugin.services.xml") {
			return $this->GenerateXML();
		}
	}

	function GenerateXml() {
		global $base;

		$this->module->plugins["modules"]->MimeXML();

		$this->tpl_module = $this->module->plugins["modules"]->LoadModuleInfo();

		$template = new CTemplate($this->tpl_path . "main.xml");

		//get all the categories

		//load the images for this module
		$cats = $this->db->QFetchRowArray(
			"SELECT * FROM {$this->tables['plugin:services_cats']} " .
			"WHERE module_id={$this->tpl_module[mod_id]} ORDER BY cat_order ASC"
		);

		$this->module->EncodeItems(
			&$cats, 
			array(					
				"cat_title" , 
				"cat_urltitle",
				"cat_content_title" , 
			)
		);

		if (is_array($cats)) {
			foreach ($cats as $key => $val) {

				if ($this->tpl_module["settings"]["set_reverseorder"]) {
					$items = $this->db->QFetchRowArray(
						"SELECT * FROM {$this->tables['plugin:services_items']} " .
						"WHERE module_id={$this->tpl_module[mod_id]} AND item_cat={$val[cat_id]} ORDER BY item_order DESC"
					);
				} else {
					$items = $this->db->QFetchRowArray(
						"SELECT * FROM {$this->tables['plugin:services_items']} " .
						"WHERE module_id={$this->tpl_module[mod_id]} AND item_cat={$val[cat_id]} ORDER BY item_order ASC"
					);
				}

				$this->module->EncodeItems(
					&$items, 
					array(					
						"item_title" , 
						"item_urltitle",
						"item_url" , 
					)
				);

				$cats[$key]["items"] = $base->html->table(
					$template , 
					"Items",
					$items
				);
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
						"Cats",
						$cats
					)
				)
			),
			$this->tpl_module["settings"]
		);
		
	}
	

}

?>