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
class COXYMallGallery extends CPlugin{	
	
	var $tplvars; 

	function COXYMallGallery() {
		//$this->CPlugin($db, $tables , $templates);
	}

	function DoEvents(){
		global $base, $_CONF, $_TSM , $_VARS , $_USER , $_BASE , $_SESS;

		parent::DoEvents();

		if ($_GET["sub"] == "oxymall.plugin.gallery.xml") {
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
			"SELECT * FROM {$this->tables['plugin:gallery_cats']} " .
			"WHERE module_id={$this->tpl_module[mod_id]} ORDER BY cat_order ASC"
		);

		$this->module->EncodeItems(
			&$cats, 
			array(					
				"cat_title" , 
				"cat_url" , 
				"cat_urltitle" , 
			)
		);

		if (is_array($cats)) {
			foreach ($cats as $key => $val) {

				if ($this->tpl_module["settings"]["set_reverseorder"]) {
					$items = $this->db->QFetchRowArray(
							"SELECT * FROM {$this->tables['plugin:gallery_items']} " .
							"WHERE module_id={$this->tpl_module[mod_id]} AND item_cat={$val[cat_id]} ORDER BY item_order ASC"
						);
				} else {
					$items = $this->db->QFetchRowArray(
							"SELECT * FROM {$this->tables['plugin:gallery_items']} " .
							"WHERE module_id={$this->tpl_module[mod_id]} AND item_cat={$val[cat_id]} ORDER BY item_order DESC"
						);
				}

				$this->module->EncodeItems(
					&$items, 
					array(					
						"item_title" , 
						"item_url" , 
						"item_urltitle" , 
					)
				);

				if (is_array($items)) {
					foreach ($items as $k => $v) {
						if ($v["item_video"]) {
							$items[$k]["source"] = "video_" . $v["item_id"] . ".flv";
						} else 
							$items[$k]["source"] = "" . $v["item_id"] . ".jpg";						
					}
				}

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