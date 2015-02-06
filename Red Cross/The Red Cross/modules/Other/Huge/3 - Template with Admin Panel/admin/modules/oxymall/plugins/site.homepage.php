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
class COXYMallHomepage extends CPlugin{
	
	var $tplvars; 

	function COXYMallHomepage() {
		//$this->CPlugin($db, $tables , $templates);
	}

	function DoEvents(){
		global $base, $_CONF, $_TSM , $_VARS , $_USER , $_BASE , $_SESS;

		parent::DoEvents();

		if ($_GET["sub"] == "oxymall.plugin.homepage.xml") {
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
				"SELECT * FROM {$this->tables['plugin:homepage_images']} " .
				"WHERE module_id={$this->tpl_module[mod_id]} ORDER BY item_order DESC"
			);
		} else {
			$images = $this->db->QFetchRowArray(
				"SELECT * FROM {$this->tables['plugin:homepage_images']} " .
				"WHERE module_id={$this->tpl_module[mod_id]} ORDER BY item_order ASC"
			);
		}

		$this->module->EncodeItems(
			&$images,
			array(
				"item_title",
				"item_url",
			)
		);

		if (is_array($images)) {
			foreach ($images as $key => $val) {
				switch ($val["item_type"]) {
					case "1":
						$images[$key]["file"] = "large_" . $val["item_id"] . ".jpg";
						$images[$key]["item_url"] =	"/" . CFile::Name2Url($val["item_title"]) . "-" . $val["item_id"];
						
					break;

					case "2":
						$images[$key]["item_type"] = "1";
						$images[$key]["file"] = "video_" . $val["item_id"] . ".flv";
						$images[$key]["item_url"] =	"/" . CFile::Name2Url($val["item_title"]) . "-" . $val["item_id"];
					break;

					default:
						$images[$key]["file"] = "" . $val["item_id"] . ".jpg";
					break;

				}				
			}
			
		}
		

		return CTemplateStatic::Replace(
			$template->blockReplace(
				"Main" ,
				array(
					"mod_url" => $this->tpl_module["mod_url"],
					"header" => $this->vars->data["homepage_header_" . $this->tpl_module["mod_id"]],
					"title" => $this->tpl_module["mod_long_name"],
					"urltitle" => $this->tpl_module["mod_urltitle"],
					"subtitle" => $this->vars->data["homepage_subtitle_" . $this->tpl_module["mod_id"]],
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

	
	function AlternateContent() {
		global $base;


		$this->tpl_module = $this->module->plugins["modules"]->LoadModuleInfo();
		$template = new CTemplate($this->tpl_path . "main.htm");	

		$images = $this->db->QFetchRowArray(
			"SELECT * FROM {$this->tables['plugin:homepage_images']} " .
			"WHERE module_id={$this->tpl_module[mod_id]} ORDER BY item_order ASC"
		);

		if (is_array($images)) {
			foreach ($images as $key => $val) {
				switch ($val["item_type"]) {
					case "0":
						$images[$key]["url"] = str_replace("#/" , "" , $val["item_url"]);
					break;

					case "1":
						$images[$key]["url"] = "upload/homepage/large_" . $val["item_id"] . ".jpg";
					break;

					case "2":
						$images[$key]["url"] = "upload/homepage/video_" . $val["item_id"] . ".flv";
					break;

				}				
			}
			
		}
		
		$this->module->plugins["modules"]->SetSeo($this->tpl_module);					

		return CTemplateStatic::Replace(
			$template->blockReplace(
				"Main" ,
				array(
					"mod_title" => $this->tpl_module["mod_long_name"],

					"header" => $this->vars->data["homepage_header_" . $this->tpl_module["mod_id"]],
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

	function GetAllLinks($module , $links) {
	}

}

?>