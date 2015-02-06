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
			"WHERE mod_module=module_id AND mod_status=1 " .
			"ORDER BY mod_order ASC"
		);

		if (is_array($modules)) {
			foreach ($modules as $key => $val) {
				$modules[$key]["cache"] = "";

				$modules[$key]["source"] = "../../../xml.php?code=" . $val["module_code"] . "&module_id={$val[mod_id]}";

				if ($val["mod_module_code"] == "external-link") {
					$modules[$key]["source"] =  "";
					$modules[$key]["urltitle"] = "";
					$modules[$key]["external"] = 'externalLink="1" ';

					//decode the settings
					$val["settings"] = unserialize($val["mod_settings"]);

					$modules[$key]["mod_url"] = $val["settings"]["set_link"];
					$modules[$key]["target"] = "externalTarget=\"" . $val["settings"]["set_target"] . "\""; 

				} else {
					$modules[$key]["mod_url"] = "/" . $val["mod_url"] . "/";
					$modules[$key]["target"] = "";
					$modules[$key]["external"] = "externalLink=\"0\"";
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
	
	
}

?>