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

		if (strstr($_GET["sub"] , "oxymall.plugin.modules.")) {
			$sub = str_replace("oxymall.plugin.modules." , "" ,$_GET["sub"]);
			$action = $_GET["action"];

			switch ($sub) {
				case "default":
					$data = new CSQLAdmin("modules/" . $sub, $this->__parent_templates,$this->db,$this->tables,$extra);
					$this->ProcessModuleFields(&$data->forms["forms"]);

					$data->functions = array( 
							"onstore_prepare" => array(&$this , "StoreDefaultModule"),
					);					

					return $data->DoEvents();
				break;

				case "user":

					if (($_GET["action"] == "moveup") || ($_GET["action"] == "movedown")) {
						$this->__call_reorder_user_modules($_GET["action"]);
					}

					$data = new CSQLAdmin("modules/" . $sub, $this->__parent_templates,$this->db,$this->tables,$extra);

					$this->ProcessUserModuleFields(&$data->forms["forms"]);

					$data->functions = array( 
							"onstore_prepare" => array(&$this , "StoreUserModule"),
					);					

					return $data->DoEvents();
				break;

				case "add-module":
					$data = new CFormSettings($this->forms_path  . $sub . ".xml" ,$_CONF["forms"]["admintemplate"] , $this->db,$this->tables);

					if ($data->Done()) {

						$this->StoreNewModule();
					}
					
					return $data->Show($this->vars->data);
				break;

				case "skins":
					$data = new CSQLAdmin("modules/" . $sub, $this->__parent_templates,$this->db,$this->tables,$extra);

					$data->functions  = array( 
							"onstore_prepare" => array(&$this , "StoreUserSkin"),
					);					
					return $data->DoEvents();
				break;

				case "settings":

						$data = new CFormSettings($this->forms_path  . $sub . ".xml" ,$_CONF["forms"]["admintemplate"] , $this->db,$this->tables);

						if ($data->Done()) {

							if ($_POST["set_logo_radio_type"] == -1) {
								unlink("../upload/logo.png");
							}
							
                            if (!$_POST["set_menu_show"])
                                $_POST["set_menu_show"] = 0;
							
							if (!$_POST["set_google_analytics"])
								$_POST["set_google_analytics"] = 0;

							if (!$_POST["set_cache"])
								$_POST["set_cache"] = 0;
							
							if (isset($_POST["set_logo_temp"]))
								unset($_POST["set_logo_temp"]);
							if (isset($_POST["set_logo_radio_type"]))
								unset($_POST["set_logo_radio_type"]);
							if (isset($_POST["set_logo_upload_web"]))
								unset($_POST["set_logo_upload_web"]);
							
							$this->vars->SetAll($_POST);
							$this->vars->Save();							
						}
						
						if (isset($this->vars->data["set_logo_temp"]))
							unset($this->vars->data["set_logo_temp"]);
						if (isset($this->vars->data["set_logo_radio_type"]))
							unset($this->vars->data["set_logo_radio_type"]);
						if (isset($this->vars->data["set_logo_upload_web"]))
							unset($this->vars->data["set_logo_upload_web"]);

						return $data->Show($this->vars->data);
				break;

				case "folders":
					return $this->folders();
				break;

				case "help":
					return $this->HelpModule();
				break;

			}
		}
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
	function ProcessModuleFields($forms) {
		if ($_GET["module_id"]) {

			$module = $this->db->QFetchArray("SELECT * FROM {$this->tables['core:modules']} WHERE module_id='{$_GET[module_id]}'");

			$module_settings = unserialize($module["module_settings"]);

			if (file_exists($this->forms_path . "settings/" . $module["module_code"] . ".xml")) {
				//read the module
				$conf = new CConfig($this->forms_path . "settings/" . $module["module_code"] . ".xml");
				
				foreach ($conf->vars["form"]["fields"] as $key => $val) {

					$val["default"] = $module_settings[$key];

					$forms["edit"]["fields"][$key] = $val;
				}

			}
			
		}		
	}

	function StoreDefaultModule($record) {

		if (is_array($record)) {
			foreach ($record as $key => $val) {
				if (stristr($key , "set_")) {

					$settings[$key] = $val;
				}
				
			}
			
			$this->db->QueryUpdate(
				$this->tables["core:modules"],
				array(
					"module_settings" => addslashes(serialize($settings)),
				),
				"module_id={$record[module_id]}"
			);
		}
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
	function StoreNewModule() {

		//read the installed module
		$module = $this->db->QFetchArray("SELECT * FROM {$this->tables['core:modules']} WHERE module_id='{$_POST[set_module]}'");

		if (is_array($module)) {
			//build the user module
			$user_mod = array(
				"mod_module"		=> $module["module_id"],
				"mod_module_code"	=> $module["module_code"],
				"mod_name"			=>	$_POST["set_title"],

				"mod_long_name"		=>	$_POST["set_title"],
				"mod_urltitle"		=>	$_POST["set_title"],
				"mod_settings"		=> $module["module_settings"]
			);

			//store the menu in database and get the id
			$id = $this->db->QueryInsert(
				$this->tables['core:user_modules'] , 
				$user_mod
			);

			//update the order variable
			$this->db->QueryUpdate(
				$this->tables['core:user_modules'],
				array(
					"mod_order" => $id,
				),
				"mod_id={$id}"
			);

			//redirect to the edit module
			urlredirect("index.php?mod=oxymall&sub=oxymall.plugin.modules.user&action=edit&mod_id={$id}&returnurl=" . urlencode("index.php?mod=oxymall&sub=oxymall.plugin.modules.user&action=details&mod_id={$id}"));
		}		
	}
	

	function ProcessUserModuleFields($forms) {

		if ($_POST["mod_id"]) {
			$_GET["mod_id"] = $_POST["mod_id"];
		}
		

		if ($_GET["mod_id"]) {

			$module = $this->db->QFetchArray("SELECT * FROM {$this->tables['core:user_modules']} WHERE mod_id='{$_GET[mod_id]}'");

			$module_settings = unserialize($module["mod_settings"]);

			if (file_exists($this->forms_path . "settings/" . $module["mod_module_code"] . ".xml")) {
				//read the module
				$conf = new CConfig($this->forms_path . "settings/" . $module["mod_module_code"] . ".xml");
				
				foreach ($conf->vars["form"]["fields"] as $key => $val) {

					$val["default"] = $module_settings[$key];

					$forms["edit"]["fields"][$key] = $val;

					if ($val["type"] == "droplist") {
						if ($val["options"]) {
							$val["type"] = "text";
							$val["default"] = $val["options"][$val["default"]];
						}								
					}

					$val["editable"] = "false";

					$forms["details"]["fields"][$key] = $val;

					//add the tabs to details

					if ($conf->vars["form"]["tabs"]) {
						$forms["details"]["tabs"] = $conf->vars["form"]["tabs"];
					}
					

				}
			}	
			
			if ($module["mod_module_code"] == "external-link") {
				//remove some unneded links.
				unset($forms["edit"]["fields"]["mod_invisible"]);
				unset($forms["edit"]["fields"]["mod_url"]);
				unset($forms["edit"]["fields"]["mod_urltitle"]);
				unset($forms["edit"]["fields"]["mod_long_name"]);


				unset($forms["details"]["fields"]["mod_invisible"]);
				unset($forms["details"]["fields"]["mod_url"]);
				unset($forms["details"]["fields"]["mod_urltitle"]);
				unset($forms["details"]["fields"]["mod_long_name"]);

			}
			
		}		
	}

	function StoreUserModule($record) {

		if (is_array($record)) {
			foreach ($record as $key => $val) {
				if (stristr($key , "set_")) {

					$settings[$key] = $val;
				}
			}
			
			$this->db->QueryUpdate(
				$this->tables["core:user_modules"],
				array(
					"mod_settings" => addslashes(serialize($settings))
					
				),
				"mod_id={$record[mod_id]}"
			);
		}
	}

	
	function __call_reorder_user_modules($action) {

		$sql = "SELECT * FROM {$this->tables['core:user_modules']} WHERE mod_order " . ($_GET["action"] == "moveup" ? " <= " : " >= " ) . " '{$_GET[mod_order]}' ORDER BY mod_order " . ($_GET["action"] == "moveup" ? " DESC " : " ASC " ) . " LIMIT 2 " ;

		$rows = $this->db->QFetchRowArray($sql);

		if (count($rows) == 2) {

			//insert the new values
			$this->db->QueryUpdate(
						$this->tables['core:user_modules'],
						array(
							"mod_order" => $rows[1]["mod_order"]
						),
						" mod_id='{$rows[0][mod_id]}'"
					);

			//insert the new values
			$this->db->QueryUpdate(
						$this->tables['core:user_modules'],
						array(
							"mod_order" => $rows[0]["mod_order"]
						),
						" mod_id='{$rows[1][mod_id]}'"
					);
		}

		//debug($_SERVER);

		UrlRedirect($_SERVER["HTTP_REFERER"]);
		die;
	}


	function GetModuleInfo($id) {
		//read the small 
		$module = $this->db->QFetchArray(
			"SELECT * FROM {$this->tables['core:modules']} , {$this->tables['core:user_modules']} " . 
			"WHERE module_id=mod_module AND mod_id={$id}"
		);

		if (is_array($module)) {
			$module["settings"] = unserialize($module["mod_settings"]);
			$module["default"] = unserialize($module["module_settings"]);
		}

		return $module;
	}


	function StoreUserSkin($record) {

		if (is_array($record)) {

			if ($record["skin_file_temp"]) {
				$unzip = new dUnzip2("../upload/tmp/" . $record["skin_file_temp"]);
				$files = $unzip->getList();

				if (is_Array($files)) {

					$folder = "../upload/skins/" . str_replace("/" , "" , $record["skin_code"]);

					if (!is_dir($folder)) {
						mkdir($folder);
						chmod($folder , 0777);
					}
					

					$unzip->unzipAll($folder);
				}
			}
		}
	}

	function Folders() {
		$folders = array(
			"../upload",
			"../upload/tmp",
			"../upload/skins",
			"../upload/services",
			"../upload/resumes",
			"../upload/banners",
			"../upload/portfolio",
			"../upload/clients",
			"../upload/galleries",
			"../upload/about",
			"../upload/contact",
			"../upload/pages",
			"../upload/music",
			"../upload/homepage",
		);

		foreach ($folders as $key => $val) {

			if (!is_dir($val)) {
				$status = @mkdir($val , 0777 , true);

				if ($status) {
					$status = 2;
				}
				
			} else {
				$status = 1;
			}
			
			$_folders[] = array(
				"path" => $val,				
				"exists" => $status,
				"chmod" => substr(sprintf('%o', fileperms($val)), -4),
				"status" => $status
			);
		}
		

		
		$data = new CSQLAdmin("modules/" . "folders", $this->__parent_templates,$this->db,$this->tables,$extra);

		return $data->FormList($_folders);
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
	function DashBoard() {
		global $base , $_USER;

		$template = new CTemplateDynamic("modules/oxymall/plugins/templates/modules/dashboard.htm");

		//add the configuration links
		$links[0] = array(
				"title" => "Configuration" ,
				"code" => "config",
				"links"	=> array(
					array( "title" => "Global Settings" , "link" => "index.php?mod=oxymall&sub=oxymall.plugin.modules.settings" ),
					array( "title" => "Installed Skins" , "link" => "index.php?mod=oxymall&sub=oxymall.plugin.modules.skins" ),
					array( "title" => "Installed Modules" , "link" => "index.php?mod=oxymall&sub=oxymall.plugin.modules.default" ),
					array( "title" => "Enabled Modules" , "link" => "index.php?mod=oxymall&sub=oxymall.plugin.modules.user" ),
					array( "title" => "Install Folders" , "link" => "index.php?mod=oxymall&sub=oxymall.plugin.modules.folders" ),
				)
		);

		$core_modules = $this->db->QFetchRowArray(
			"SELECT * FROM " . 
			"{$this->tables['core:modules']} " . 
			"WHERE module_unique=0 AND module_unique_enabled=1"
		);

		if (is_array($core_modules)) {
			foreach ($core_modules as $key => $val) {
				$tmp_mod_menu = explode("\n" , trim($val["module_links"]));

				$links["c_" . $val["module_id"]]["title"] = $val["module_name"];
				$links["c_" . $val["module_id"]]["code"] = $val["module_code"];

				if (count($tmp_mod_menu)) {
					foreach ($tmp_mod_menu as $k => $v) {
						$tmp = explode("|" , $v);

						$links["c_" . $val["module_id"]]["links"][] = array(
							"link" => trim(CTemplateStatic::Replace($tmp[1] , array( "module_id" => $val["module_id"]))),
							"title" => $tmp[0]
						);
					}					
				}			
			}
		}		


		$modules = $this->db->QFetchRowArray(
			"SELECT * FROM " . 
			"{$this->tables['core:user_modules']},{$this->tables['core:modules']} " . 
			"WHERE mod_module=module_id AND module_unique=1 ORDER BY mod_order ASC"
		);

		if (is_array($modules)) {
			foreach ($modules as $key => $val) {
				$tmp_mod_menu = explode("\n" , trim($val["module_links"]));

				$links[$val["mod_id"]]["title"] = $template->blockReplace($val["mod_status"] ? "Green" : "Red" , array( "title" => $val["mod_name"]));
				$links[$val["mod_id"]]["code"] = $val["module_code"];

				if (count($tmp_mod_menu)) {
					foreach ($tmp_mod_menu as $k => $v) {
						$tmp = explode("|" , $v);

						if (stristr($tmp[0] , "Video Tutorial") && ($GLOBALS["no_tutorials"])) {
						} else {						
							$links[$val["mod_id"]]["links"][] = array(
								"link" => trim(CTemplateStatic::Replace($tmp[1] , array( "module_id" => $val["mod_id"]))),
								"title" => $tmp[0]
							);
						}
					}					
				}			
			}
		}		

		//add the administrators
		//add the configuration links
		$links[9999] = array(
				"title" => "Administrators" ,
				"code" => "admins",
				"links"	=> array(
					array( "title" => "My Profile" , "link" => "index.php?mod=auth&sub=profile" ),
					array( "title" => "Users" , "link" => "index.php?mod=auth&sub=users" ),
				)
		);

		//add the configuration links
		$links[10000] = array(
				"title" => "My Profile" ,
				"code" => "admins",
				"links"	=> array(
					array( "title" => "My Profile" , "link" => "index.php?mod=auth&sub=profile" ),
				)
		);

		if (is_array($links)) {
			if ($_USER["user_level"]) {
				$perm = explode("," , $_USER["user_perm"]);
				$perm[] = "10000";

				//remove configuration and the admins
				unset($links["9999"]);
				unset($links[0]);

				foreach ($links as $key => $val) {
					if (!in_array($key , $perm)) {
						unset($links[$key]);
					} else {
						foreach ($val["links"] as $k => $v) {
							if ($v["title"] == "Module Settings"){
								unset($links[$key]["links"][$k]);
							}
						}
						
					}
				}				
			} else {
				unset($links[10000]);
			}			
		}
		


		if (is_Array($links)) {
			
			$count = 0;
			foreach ($links as $key => $val) {

				if ($count == 0 )
					$links[$key]["pre"] = "<tr>";
				else
					$links[$key]["pre"] = "";

				$count ++;

				if ($count == 3 ) {
					$links[$key]["after"] = "</tr>";
					$count = 0 ;
				} else
					$links[$key]["after"] = "";
				

				$links[$key]["links"] = $base->html->Table(
					$template , 
					"Items" , 
					$val["links"]
				);
			}			
			
			return $template->blockReplacE(
				"Main" , 
				array(
					"menu" => $base->html->Table(
						$template , 
						"" , 
						$links
					)
				)
			);
		}
		
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
	function HelpModule() {
		global $_CONF;

		$_GET["action"] = "edit";

		if ($_GET["module_id"]) {
			$module = $this->GetModuleInfo($_GET["module_id"]);

			//read the tabs from the settings
			$module_conf = new CConfig($this->forms_path . "settings/" . $module["module_code"] . ".xml");

			//load the config

			$tabs = $module_conf->vars["form"]["tabs"];

			if (is_array($tabs)) {
				$tabs["t"]["active"] = "false";
				$tabs["t_video"]["active"] = "true";
			}

			$data = new CFormSettings($this->forms_path  . "help.xml" ,$_CONF["forms"]["admintemplate"] , $this->db,$this->tables);

			$data->form["title"] = $module["mod_name"];

			$data->form["tabs"] = $tabs;
			$data->form["fields"]["comment"]["forcevalue"] = "<center>" . $module["module_help"] . "</center>";

			return $data->Show(array());
		}

		$data = new CFormSettings($this->forms_path  . "help.main.xml" ,$_CONF["forms"]["admintemplate"] , $this->db,$this->tables);
		return $data->Show(array());
	}
	
	
}

?>