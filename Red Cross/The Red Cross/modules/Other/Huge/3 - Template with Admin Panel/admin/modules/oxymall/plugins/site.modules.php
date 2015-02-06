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
class COXYMallModules extends CPlugin{
	
	var $tplvars; 

	function COXYMallModules() {
		//$this->CPlugin($db, $tables , $templates);
	}

	function DoEvents(){
		global $base, $_CONF, $_TSM , $_VARS , $_USER , $_BASE , $_SESS;

		parent::DoEvents();

		if ($_GET["sub"] == "oxymall.plugin.main.xml") {
			return $this->MainXml();
		}
		
	}

	function GetMainSwf() {
		global $_NO_HTACCESS;

		$template = new CTemplate($this->tpl_path . "skin.htm");


		if ($_GET["forceskin"] && is_array($skin = $this->db->QFetchArray("SELECT * FROM {$this->tables['core:skins']} WHERE skin_code='{$_GET[forceskin]}'"))) {
			return CTemplateStatic::Replace(
				$template->blockReplace(
					"Main",
					$skin
				),
				array(
					"cache" => $this->vars->data["set_cache"] ? "" : $template->blockReplace("Cache" , array()),
				)
			);
		}
		

		//read the selected skin
		if ($this->vars->data["set_skin"]) {
			$skin = $this->db->QFetchArray("SELECT * FROM {$this->tables['core:skins']} WHERE skin_id='{$this->vars->data[set_skin]}'");

			if (is_array($skin)) {

				return CTemplateStatic::Replace(
					$template->blockReplace(
						"Main",
						$skin
					),
					array(
						"cache" => $this->vars->data["set_cache"] ? "" : $template->blockReplace("Cache" , array())	,
					)
				);
			}
			
		}		
	}

	function MainXML() {		
		global $base , $_NO_HTACCESS;

		$this->MimeXML();

		$template = new CTemplate($this->tpl_path . "main.xml");

		//read all the modules
		$modules = $this->db->QFetchRowArray(
			"SELECT * FROM " . 
				$this->tables['core:modules'] . ", " . 
				$this->tables['core:user_modules'] . " " . 
			"WHERE mod_module=module_id AND mod_status=1 AND mod_parent=0 " .
			"ORDER BY mod_order ASC"
		);

		if (is_array($modules)) {
			foreach ($modules as $key => $val) {
				$modules[$key]["cache"] = "";

				$modules[$key]["source"] = urlencode("../../../xml.php?code=" . $val["module_code"] . "&module_id={$val[mod_id]}");
				$modules[$key]["subitems"] = "";

				switch ($val["mod_module_code"]) {
					case "external-link":
						$modules[$key]["source"] =  "";
						$modules[$key]["urltitle"] = "";
						$modules[$key]["external"] = 'externalLink="1" ';

						//decode the settings
						$val["settings"] = unserialize($val["mod_settings"]);

						$modules[$key]["mod_url"] = $val["settings"]["set_link"];
						$modules[$key]["target"] = "externalTarget=\"" . $val["settings"]["set_target"] . "\""; 
					break;

					case "category":
						$submodules = $this->db->QFetchRowArray(
							"SELECT * FROM " . 
								$this->tables['core:modules'] . ", " . 
								$this->tables['core:user_modules'] . " " . 
							"WHERE mod_module=module_id AND mod_status=1 AND mod_parent={$val[mod_id]} " .
							"ORDER BY mod_order ASC"
						);

						if (is_array($submodules)) {
							foreach ($submodules as $k => $v) {
								$submodules[$k]["cache"] = "";
								$submodules[$k]["source"] = urlencode("../../../xml.php?code=" . $v["module_code"] . "&module_id={$v[mod_id]}");

								switch ($v["mod_module_code"]) {
									case "external-link":
										$submodules[$k]["source"] =  "";
										$submodules[$k]["urltitle"] = "";
										$submodules[$k]["external"] = 'externalLink="1" ';

										//decode the settings
										$v["settings"] = unserialize($v["mod_settings"]);

										$submodules[$k]["mod_url"] = $v["settings"]["set_link"];
										$submodules[$k]["target"] = "externalTarget=\"" . $v["settings"]["set_target"] . "\""; 
									break;

									default:
										$submodules[$k]["mod_url"] = "/" . $v["mod_url"] . "/";
										$submodules[$k]["target"] = "";
										$submodules[$k]["external"] = "externalLink=\"0\"";
									break;

								}
								
								$submodules[$k]["hidden"] = " hiddenModule=\"" . ($v["mod_invisible"] ? '1' : "0") . "\" ";
							}			

							$this->module->EncodeItems(
								&$submodules , 
								array(					
									"mod_module_code" , 
									"mod_name",
									"mod_long_name" , 
									"mod_urltitle" ,
									"mod_url" ,
									"source" ,
								)
							);
						}
						
						$modules[$key]["subitems"] = $base->html->table(
							$template , 
							"Sub",
							$submodules
						);

						$modules[$key]["mod_url"] = "";
						$modules[$key]["target"] = "";
						$modules[$key]["source"] = "";
						$modules[$key]["external"] = "";

					break;

					default:
						$modules[$key]["mod_url"] = "/" . $val["mod_url"] . "/";
						$modules[$key]["target"] = "";
						$modules[$key]["external"] = "externalLink=\"0\"";
					break;

				}
				
				$modules[$key]["hidden"] = " hiddenModule=\"" . ($val["mod_invisible"] ? '1' : "0") . "\" ";
			}			

			$this->module->EncodeItems(
				&$modules , 
				array(					
					"mod_module_code" , 
					"mod_name",
					"mod_long_name" , 
					"mod_urltitle" ,
					"mod_url" ,
					"source" ,
				)
			);
		}
		

		return CTemplateStatic::Replace(
			$base->html->table(
				$template, 
				"",
				$modules
			),
			array(
				"set_copyright" => $this->vars->data["set_copyright"],
				"logo" => file_exists("upload/logo.png") ? "../../logo.png" : "",
				"show_menu" => $this->vars->data["set_menu_show"],	
				"menu_align" => $this->vars->data["set_menu_align"],	
				"max_width" => $this->vars->data["set_tpl_maxwidth"],	
				"max_height" => $this->vars->data["set_tpl_maxheight"],	
				"set_menu_correction" => $this->vars->data["set_menu_correction"],	
			)
		);
	}

	/**
	* description
	*
	* @param
	*
	* @return
	*
	* @access
	*/
	function MimeXML() {
		$mime = new CMime();
		$mime->Set("xml");
	}

	
	function LoadModuleInfo() {

		//read the small 
		$module = $this->db->QFetchArray(
			"SELECT * FROM {$this->tables['core:modules']} , {$this->tables['core:user_modules']} " . 
			"WHERE module_id=mod_module AND mod_id={$_GET[module_id]}"
		);

		if (is_array($module)) {
			$module["settings"] = (array) unserialize($module["mod_settings"]);
			$module["default"] = unserialize($module["module_settings"]);
		}

		$this->module->EncodeItems(
			&$modules , 
			array(					
				"mod_module_code" , 
				"mod_name",
				"mod_long_name" , 
				"mod_urltitle" ,
				"mod_url" 
			)
		);


		return $module;
	}

	function LoadDefaultModule($mod) {

		//read the small 
		$module = $this->db->QFetchArray(
			"SELECT * FROM {$this->tables['core:modules']} " . 
			"WHERE module_code='{$mod}'"
		);


		if (is_array($module)) {
			$module["settings"] = unserialize($module["module_settings"]);
		}

		return $module;
	}

	
	/**
	* description
	*
	* @param
	*
	* @return
	*
	* @access
	*/
	function GetHTMLMenu() {
		global $base;

		$template = new CTemplate($this->tpl_path . "menu.htm");

		//get the entire list of modules, no matter if they are hidden or not.

		//read all the modules
		$modules = $this->db->QFetchRowArray(
			"SELECT * FROM " . 
				$this->tables['core:modules'] . ", " . 
				$this->tables['core:user_modules'] . " " . 
			"WHERE mod_module=module_id AND mod_status=1 AND mod_parent=0 " .
			"ORDER BY mod_order ASC"
		);

		if (is_array($modules)) {
			foreach ($modules as $key => $val) {

				$submodules = $this->db->QFetchRowArray(
					"SELECT * FROM " . 
						$this->tables['core:modules'] . ", " . 
						$this->tables['core:user_modules'] . " " . 
					"WHERE mod_module=module_id AND mod_status=1 AND mod_parent={$val[mod_id]} " .
					"ORDER BY mod_order ASC"
				);

				if (is_array($submodules)) {
					foreach ($submodules as $k => $v) {
						if ($v["module_code"] == "external-link") {
							$v["settings"] = unserialize($v["mod_settings"]);
							$submodules[$k]["mod_url"] = $v["settings"]["set_link"];
							$submodules[$k]["item_target"] = "_blank";
						} else{
							$submodules[$k]["mod_url"] .=  "/";
							$submodules[$k]["item_target"] = "";
						}
						
					}
					
				}
								

				$modules[$key]["subitems"] = is_array($submodules) ? $base->html->Table(
					$template, 
					"SubMenu" ,
					$submodules
				) : "";


				if ($val["module_code"] == "external-link") {
					$val["settings"] = unserialize($val["mod_settings"]);
					$val["mod_url"] = $val["settings"]["set_link"];
					$val["item_target"] = "_blank";
				} else{
					$val["mod_url"] .=  "/";
					$val["item_target"] = "";
				}


				$modules[$key]["title"] = $template->blockReplace($val["mod_module_code"] == "category" ? "NoLink" : "Link" , $val);
			}
			
		}
		

		return $base->html->Table(
			$template, 
			"Menu" ,
			$modules
		);


	}
	

	function GetModuleByCode($module) {

		//read the small 
		$_module = $this->db->QFetchArray(
			"SELECT * FROM {$this->tables['core:user_modules']} " . 
			"WHERE mod_url='{$module}'"
		);

		return $_module;
	}

	/**
	* description
	*
	* @param
	*
	* @return
	*
	* @access
	*/
	function GetIdFromLink($link) {
		$tmp = explode("-" , $link);

		return trim($tmp[count($tmp)-1]);
	}

	/**
	* description
	*
	* @param
	*
	* @return
	*
	* @access
	*/
	function SetSeo($item) {
		global $_TSM;

		if ($item["seo_title"] && !$_TSM["PUB:SEO_TITLE"])
			$_TSM["PUB:SEO_TITLE"] = $item["seo_title"];

		if ($item["seo_desc"] && !$_TSM["PUB:SEO_DESC"])
			$_TSM["PUB:SEO_DESC"] = $item["seo_desc"];

		if ($item["seo_keys"] && !$_TSM["PUB:SEO_KEYS"])
			$_TSM["PUB:SEO_KEYS"] = $item["seo_keys"];
		
	}
	
	
	
}

?>