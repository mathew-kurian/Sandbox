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
class COXYMallPortfolio extends CPlugin{
	
	var $tplvars; 

	function COXYMallPortfolio() {
		//$this->CPlugin($db, $tables , $templates);
	}

	function DoEvents(){
		global $base, $_CONF, $_TSM , $_VARS , $_USER , $_BASE , $_SESS;

		parent::DoEvents();

		if (strstr($_GET["sub"] , "oxymall.plugin.portfolio.")) {
			$sub = str_replace("oxymall.plugin.portfolio." , "" ,$_GET["sub"]);
			$action = $_GET["action"];

			//read the module
			$this->tpl_module = $this->module->plugins["modules"]->getModuleInfo($_GET["module_id"]);

			switch ($sub) {

				case "cats":

					if (($_GET["action"] == "moveup") || ($_GET["action"] == "movedown")) {
						$this->__call_reorder_cats($_GET["action"]);
					}
					
					$data = new CSQLAdmin("portfolio/" . $sub, $this->__parent_templates,$this->db,$this->tables,$extra);

					$this->PrepareFields(&$data->forms["forms"]);

					$data->functions = array( 
							"onstore" => array(&$this , "StoreCat"),
					);					

					return $data->DoEvents();

				break;

				case "projects":

					if (($_GET["action"] == "moveup") || ($_GET["action"] == "movedown")) {
						$this->__call_reorder_projects($_GET["action"]);
					}

					if ($_GET["action"] == "details") {
						$data = new CSQLAdmin("portfolio/images" , $this->__parent_templates,$this->db,$this->tables,$extra);

						if ($this->tpl_module["settings"]["set_reverseorder"]) {
							$data->forms["forms"]["list"]["sql"]["vars"]["order_mode"]["import"] = "desc";
						}

						$extra["details"]["after"] = $data->DoEvents();
					}
					
					$data = new CSQLAdmin("portfolio/" . $sub, $this->__parent_templates,$this->db,$this->tables,$extra);

					$this->PrepareFields(&$data->forms["forms"] , $sub);

					$data->functions = array( 
							"onstore" => array(&$this , "StoreProject"),
					);					

					return $data->DoEvents();

				break;

				case "images":

					if (($_GET["action"] == "moveup") || ($_GET["action"] == "movedown")) {
						$this->__call_reorder_images($_GET["action"]);
					}
					
					$data = new CSQLAdmin("portfolio/" . $sub, $this->__parent_templates,$this->db,$this->tables,$extra);

					$this->PrepareFields(&$data->forms["forms"] , $sub);

					$data->functions = array( 
							"onstore" => array(&$this , "StoreImage"),
					);					

					return $data->DoEvents();

				break;

				case "landing":

						$data = new CFormSettings($this->forms_path  . $sub . ".xml" ,$_CONF["forms"]["admintemplate"] , $this->db,$this->tables);

						$data->form["title"] = CTemplateStatic::Replace(
							$data->form["title"],
							array( "title" => $this->tpl_module["mod_name"])
						);

						$data->form["fields"]["portfolio_header_" . $this->tpl_module["mod_id"]] = $data->form["fields"]["header"];
						unset($data->form["fields"]["header"]);


						if ($data->Done()) {
							$this->vars->SetAll($_POST);
							$this->vars->Save();							
						}
						
						return $data->Show($this->vars->data);
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
	function PrepareFields($forms , $sub = "") {

		if (is_array($forms["search"])) {
			$forms["search"]["title"] = CTemplateStatic::Replace(
				$forms["search"]["title"],
				array( "title" => $this->tpl_module["mod_name"])
			);
		}

		if (is_array($forms["details"])) {
			$forms["details"]["title"] = CTemplateStatic::Replace(
				$forms["details"]["title"],
				array( "title" => $this->tpl_module["mod_name"])
			);
		}

		$forms["list"]["title"] = CTemplateStatic::Replace(
			$forms["list"]["title"],
			array( "title" => $this->tpl_module["mod_name"])
		);

		$forms["edit"]["title"] = CTemplateStatic::Replace(
			$forms["edit"]["title"],
			array( "title" => $this->tpl_module["mod_name"])
		);

		$forms["add"]["title"] = CTemplateStatic::Replace(
			$forms["add"]["title"],
			array( "title" => $this->tpl_module["mod_name"])
		);


		//process the images sizes
		if (is_array($forms["edit"]["fields"]["cat_image"])) {

			$width = $this->tpl_module["settings"]["set_thumbwidth"];
			$height = $this->tpl_module["settings"]["set_thumbheight"];

			$forms["edit"]["fields"]["cat_image"]["thumbnails"]["resize"]["width"] = 
			$forms["add"]["fields"]["cat_image"]["thumbnails"]["resize"]["width"] = $width;

			$forms["edit"]["fields"]["cat_image"]["thumbnails"]["resize"]["height"] = 
			$forms["add"]["fields"]["cat_image"]["thumbnails"]["resize"]["height"] = $height;

			$forms["add"]["fields"]["cat_image"]["title"] = 
			$forms["edit"]["fields"]["cat_image"]["title"] = CTemplateStatic::ReplaceSingle(
				$forms["edit"]["fields"]["cat_image"]["title"] ,
				"size" , 
				$width . " x "  . $height
			);
		}
		

		if (is_array($forms["edit"]["fields"]["cat_image"])) {

			$width = $this->tpl_module["settings"]["set_thumbwidth"];
			$height = $this->tpl_module["settings"]["set_thumbheight"];

			$forms["edit"]["fields"]["cat_image"]["thumbnails"]["resize"]["width"] = 
			$forms["add"]["fields"]["cat_image"]["thumbnails"]["resize"]["width"] = $width;

			$forms["edit"]["fields"]["cat_image"]["thumbnails"]["resize"]["height"] = 
			$forms["add"]["fields"]["cat_image"]["thumbnails"]["resize"]["height"] = $height;

			$forms["add"]["fields"]["cat_image"]["title"] = 
			$forms["edit"]["fields"]["cat_image"]["title"] = CTemplateStatic::ReplaceSingle(
				$forms["edit"]["fields"]["cat_image"]["title"] ,
				"size" , 
				$width . " x "  . $height
			);
		}


		if (is_array($forms["edit"]["fields"]["project_image"])) {

			$width = $this->tpl_module["settings"]["set_thumbwidthprojecttypelisting"];
			$height = $this->tpl_module["settings"]["set_thumbheightprojecttypelisting"];

			$forms["edit"]["fields"]["project_image"]["thumbnails"]["resize"]["width"] = 
			$forms["add"]["fields"]["project_image"]["thumbnails"]["resize"]["width"] = $width;

			$forms["edit"]["fields"]["project_image"]["thumbnails"]["resize"]["height"] = 
			$forms["add"]["fields"]["project_image"]["thumbnails"]["resize"]["height"] = $height;

			$forms["add"]["fields"]["project_image"]["title"] = 
			$forms["details"]["fields"]["project_image"]["title"] = 
			$forms["edit"]["fields"]["project_image"]["title"] = CTemplateStatic::ReplaceSingle(
				$forms["edit"]["fields"]["project_image"]["title"] ,
				"size" , 
				$width . " x "  . $height
			);
		}

		if (is_array($forms["edit"]["fields"]["item_image"])) {

	
			if ($_POST["item_pan"]) {
				$width = $_POST["item_pan_max_width"];
				$height = $_POST["item_pan_max_height"];
			} else {
				$width = $this->tpl_module["settings"]["set_thumbwidthprojectdetails"];
				$height = $this->tpl_module["settings"]["set_thumbheightprojectdetails"];
			}
			
			$forms["edit"]["fields"]["item_image"]["thumbnails"]["resize"]["width"] = 
			$forms["add"]["fields"]["item_image"]["thumbnails"]["resize"]["width"] = $width;

			$forms["edit"]["fields"]["item_image"]["thumbnails"]["resize"]["height"] = 
			$forms["add"]["fields"]["item_image"]["thumbnails"]["resize"]["height"] = $height;

			$forms["add"]["fields"]["item_image"]["title"] = 
			$forms["edit"]["fields"]["item_image"]["title"] = CTemplateStatic::ReplaceSingle(
				$forms["edit"]["fields"]["item_image"]["title"] ,
				"size" , 
				$width . " x "  . $height
			);
		}
		
		if ($this->tpl_module["settings"]["set_reverseorderp"] && (($sub == "projects") && ($_GET["action"] != "details"))) {
			$forms["list"]["sql"]["vars"]["order_mode"]["import"] = "desc";
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
	function StoreCat($record) {
		if ($record["cat_id"] && !$record["cat_order"]) {
			$this->db->QueryUpdate(
				$this->tables["plugin:portfolio_cats"],
				array(
					"cat_order" => $record["cat_id"]
				),
				"cat_id='{$record[cat_id]}'"
			);
		}		
	}
	

	function __call_reorder_cats($action) {

		$sql = "SELECT * FROM {$this->tables['plugin:portfolio_cats']} WHERE module_id={$this->tpl_module[mod_id]} AND cat_order " . ($_GET["action"] == "moveup" ? " <= " : " >= " ) . " '{$_GET[cat_order]}' ORDER BY cat_order " . ($_GET["action"] == "moveup" ? " DESC " : " ASC " ) . " LIMIT 2 " ;

		$rows = $this->db->QFetchRowArray($sql);

		if (count($rows) == 2) {

			//insert the new values
			$this->db->QueryUpdate(
						$this->tables['plugin:portfolio_cats'],
						array(
							"cat_order" => $rows[1]["cat_order"]
						),
						" cat_id='{$rows[0][cat_id]}'"
					);

			//insert the new values
			$this->db->QueryUpdate(
						$this->tables['plugin:portfolio_cats'],
						array(
							"cat_order" => $rows[0]["cat_order"]
						),
						" cat_id='{$rows[1][cat_id]}'"
					);
		}

		//debug($_SERVER);

		UrlRedirect($_SERVER["HTTP_REFERER"]);
		die;
	}

	function StoreImage($record) {
		if ($record["item_id"] && !$record["item_order"]) {
			$this->db->QueryUpdate(
				$this->tables["plugin:portfolio_items"],
				array(
					"item_order" => $record["item_id"]
				),
				"item_id='{$record[item_id]}'"
			);
		}		
	}

	function __call_reorder_images($action) {

		if ($this->tpl_module["settings"]["set_reverseorder"]) {
			$sql = "SELECT * FROM {$this->tables['plugin:portfolio_items']} WHERE item_project={$_GET[item_project]} AND module_id={$this->tpl_module[mod_id]} AND item_order " . ($_GET["action"] == "moveup" ? " >= " : " <= " ) . " '{$_GET[item_order]}' ORDER BY item_order " . ($_GET["action"] == "moveup" ? " ASC " : " DESC " ) . " LIMIT 2 " ;
		} else {
			$sql = "SELECT * FROM {$this->tables['plugin:portfolio_items']} WHERE item_project={$_GET[item_project]} AND module_id={$this->tpl_module[mod_id]} AND item_order " . ($_GET["action"] == "moveup" ? " <= " : " >= " ) . " '{$_GET[item_order]}' ORDER BY item_order " . ($_GET["action"] == "moveup" ? " DESC " : " ASC " ) . " LIMIT 2 " ;
		}

		$rows = $this->db->QFetchRowArray($sql);

		if (count($rows) == 2) {

			//insert the new values
			$this->db->QueryUpdate(
						$this->tables['plugin:portfolio_items'],
						array(
							"item_order" => $rows[1]["item_order"]
						),
						" item_id='{$rows[0][item_id]}'"
					);

			//insert the new values
			$this->db->QueryUpdate(
						$this->tables['plugin:portfolio_items'],
						array(
							"item_order" => $rows[0]["item_order"]
						),
						" item_id='{$rows[1][item_id]}'"
					);
		}

		//debug($_SERVER);

		UrlRedirect($_SERVER["HTTP_REFERER"]);
		die;
	}


	function StoreProject($record) {
		if ($record["project_id"] && !$record["project_order"]) {
			$this->db->QueryUpdate(
				$this->tables["plugin:portfolio_projects"],
				array(
					"project_order" => $record["project_id"]
				),
				"project_id='{$record[project_id]}'"
			);
		}		
	}
	

	function __call_reorder_projects($action) {

		if ($this->tpl_module["settings"]["set_reverseorderp"]) {
			$sql = "SELECT * FROM {$this->tables['plugin:portfolio_projects']} WHERE module_id={$this->tpl_module[mod_id]} AND project_order " . ($_GET["action"] == "moveup" ? " >= " : " <= " ) . " '{$_GET[project_order]}' ORDER BY project_order " . ($_GET["action"] == "moveup" ? " ASC " : " DESC " ) . " LIMIT 2 " ;
		} else {
			$sql = "SELECT * FROM {$this->tables['plugin:portfolio_projects']} WHERE module_id={$this->tpl_module[mod_id]} AND project_order " . ($_GET["action"] == "moveup" ? " <= " : " >= " ) . " '{$_GET[project_order]}' ORDER BY project_order " . ($_GET["action"] == "moveup" ? " DESC " : " ASC " ) . " LIMIT 2 " ;
		}

		$rows = $this->db->QFetchRowArray($sql);

		if (count($rows) == 2) {

			//insert the new values
			$this->db->QueryUpdate(
						$this->tables['plugin:portfolio_projects'],
						array(
							"project_order" => $rows[1]["project_order"]
						),
						" project_id='{$rows[0][project_id]}'"
					);

			//insert the new values
			$this->db->QueryUpdate(
						$this->tables['plugin:portfolio_projects'],
						array(
							"project_order" => $rows[0]["project_order"]
						),
						" project_id='{$rows[1][project_id]}'"
					);
		}

		//debug($_SERVER);

		UrlRedirect($_SERVER["HTTP_REFERER"]);
		die;
	}




}

?>