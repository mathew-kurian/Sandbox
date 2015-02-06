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
	
	function AlternateContent() {
		global $base;

		$this->tpl_module = $this->module->plugins["modules"]->LoadModuleInfo();

		$template = new CTemplate($this->tpl_path . "main.htm");

		//get all the categories

		//load the images for this module
		$cats = $this->db->QFetchRowArray(
			"SELECT * FROM {$this->tables['plugin:gallery_cats']} " .
			"WHERE module_id={$this->tpl_module[mod_id]} ORDER BY cat_order ASC"
		);

		if ($_GET["sub"] == "landing") {
			$cat = $cats[0];

			$this->module->plugins["modules"]->SetSeo($cat);			
			$this->module->plugins["modules"]->SetSeo($this->tpl_module);			

		} else {

			if (stristr($_GET["sub"] , "/")) {
				$tmp = explode("/" , $_GET["sub"]);

				$cat_id = $this->module->plugins["modules"]->GetIdFromLink($tmp[0]);
				$image_id = $this->module->plugins["modules"]->GetIdFromLink($tmp[1]);

				$cat = $this->db->QFetchArray(
					"SELECT * FROM {$this->tables['plugin:gallery_cats']} " .
					"WHERE module_id={$this->tpl_module[mod_id]} AND cat_id={$cat_id}"
				);

				$image = $this->db->QFetchArray(
					"SELECT * FROM {$this->tables['plugin:gallery_items']} " .
					"WHERE module_id={$this->tpl_module[mod_id]} AND item_id={$image_id}"
				);

				$content = $template->blockReplace(
					"Image",
					array_merge(
						array(
							"link"=> $template->blockReplace($image["item_video"] ?"Video" : "Jpg" , $image),
						),
						$cat , 
						$image , 
						$this->tpl_module
					)
				);

				$this->module->plugins["modules"]->SetSeo($image);			
				$this->module->plugins["modules"]->SetSeo($cat);			
				$this->module->plugins["modules"]->SetSeo($this->tpl_module);			


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

				$this->module->plugins["modules"]->SetSeo($cat);			
				$this->module->plugins["modules"]->SetSeo($this->tpl_module);			

			}
		}

		if (is_array($cat) && !is_array($image)	) {

			$content = CTemplateStatic::Replace(
				$base->html->table(
					$template , 
					"Items",
					$this->db->QFetchRowArray(
						"SELECT * FROM {$this->tables['plugin:gallery_items']} " .
						"WHERE module_id={$this->tpl_module[mod_id]} AND item_cat={$cat[cat_id]} ORDER BY item_order ASC"
					)
				),
				$cat
			);
		}




		return CTemplateStatic::Replace(
			$template->blockREplace(
				"Main",
				array(
					"mod_title" => $this->tpl_module["mod_long_name"],
	
					"menu" => $base->html->Table(
						$template,
						"Cats",
						$cats
					),
	
					"content" => $content,
				)
			),
			$this->tpl_module
		);

	}

	function GetAllLinks($module , $links) {
		//get all news for this module

		$cats = $this->db->QFetchRowArray(
			"SELECT * FROM {$this->tables['plugin:gallery_cats']} " .
			"WHERE module_id={$module[mod_id]}"
		);

		if (is_array($cats)) {
			foreach ($cats as $key => $val) {
				$links[] = array(
					"url" => $module["mod_url"] . "/" . $val["cat_url"] . "-" . $val["cat_id"] . "/",
					"priority" => "0.8",
				);
			}
		}


		$images = 	$this->db->QFetchRowArray(
			"SELECT * FROM {$this->tables['plugin:gallery_items']} as itm,{$this->tables['plugin:gallery_cats']} " .
			"WHERE itm.module_id={$module[mod_id]} AND item_cat=cat_id ORDER BY item_order ASC"
		);

		if (is_array($images)) {
			foreach ($images as $key => $val) {
				$links[] = array(
					"url" => $module["mod_url"] . "/" . $val["cat_url"] . "-" . $val["cat_id"] . "/" . $val["item_url"] . "-" . $val["item_id"] . "/",
					"priority" => "0.7",
				);
			}
		}
	}

}

?>