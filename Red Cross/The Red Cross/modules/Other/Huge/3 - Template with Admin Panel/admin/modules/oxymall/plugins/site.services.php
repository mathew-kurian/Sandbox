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

	function AlternateContent() {
		global $base;

		$this->tpl_module = $this->module->plugins["modules"]->LoadModuleInfo();

		$template = new CTemplate($this->tpl_path . "main.htm");

		//get all the categories

		//load the images for this module
		$cats = $this->db->QFetchRowArray(
			"SELECT * FROM {$this->tables['plugin:services_cats']} " .
			"WHERE module_id={$this->tpl_module[mod_id]} ORDER BY cat_order ASC"
		);


		if ($_GET["sub"] == "landing") {
			$cat = $cats[0];
		} else {
			$id = $this->module->plugins["modules"]->GetIdFromLink($_GET["sub"]);
			
			if (is_array($cats)) {
				foreach ($cats as $key => $val) {
					if ($val["cat_id"] == $id) {
						$cat= $val;
						break;
					}
				}
			}
		}

		if (is_array($cat)) {

			$cat["images"] = $base->html->table(
				$template , 
				"Items",
				$this->db->QFetchRowArray(
					"SELECT * FROM {$this->tables['plugin:services_items']} " .
					"WHERE module_id={$this->tpl_module[mod_id]} AND item_cat={$cat[cat_id]} ORDER BY item_order ASC"
				)
			);
		}
		
		$this->module->plugins["modules"]->SetSeo($cat);			
		$this->module->plugins["modules"]->SetSeo($this->tpl_module);			


		return CTemplateStatic::Replace(
			$template->blockReplace(
				"Main" ,
				array(
					"mod_title" => $this->tpl_module["mod_long_name"],

					"menu" => $base->html->Table(
						$template,
						"Cats",
						$cats
					),

					"content" => $template->blockReplace(
						"Category" , 
						$cat
					),
				)
			),
			$this->tpl_module
		);

	}
	
	function GetAllLinks($module , $links) {
		//get all news for this module

		$news = $this->db->QFetchRowArray(
			"SELECT * FROM {$this->tables['plugin:services_cats']} " .
			"WHERE module_id={$module[mod_id]}"
		);

		if (is_array($news)) {
			foreach ($news as $key => $val) {
				$links[] = array(
					"url" => $module["mod_url"] . "/" . $val["cat_url"] . "-" . $val["cat_id"] . "/",
					"priority" => "0.8",
				);
			}
		}
		

	}

}

?>