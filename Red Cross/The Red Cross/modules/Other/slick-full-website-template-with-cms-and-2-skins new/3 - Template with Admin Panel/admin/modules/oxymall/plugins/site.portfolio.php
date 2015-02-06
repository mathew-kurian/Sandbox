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

		if ($_GET["sub"] == "oxymall.plugin.portfolio.xml") {
			return $this->GenerateXML();
		}
	}

	function GenerateXml() {
		global $base;

		$this->module->plugins["modules"]->MimeXML();


		$this->tpl_module = $this->module->plugins["modules"]->LoadModuleInfo();

		$records = $this->LoadRecords();

		$template = new CTemplate($this->tpl_path . "main.xml");

		if (is_Array($records["cats"])) {
			foreach ($records["cats"] as $key => $val) {

				if (is_Array($records["projects"][$val["cat_id"]])) {
					foreach ($records["projects"][$val["cat_id"]] as $k => $v) {
						$records["projects"][$val["cat_id"]][$k]["items"] = $base->html->table(
							$template,
							"Items",
							$records["items"][$v["project_id"]]
						);
					}
				}

				$records["cats"][$key]["projects"] = $base->html->Table(
					$template,
					"Projects",
					$records["projects"][$val["cat_id"]]
				);
			}
		}
		

		//get all the categories
		return CTemplateStatic::Replace(
			$template->blockReplace(
				"Main" ,
				array(
					"mod_title" => $this->tpl_module["mod_long_name"],
					"mod_urltitle" => $this->tpl_module["mod_urltitle"],
					"mod_url" => $this->tpl_module["mod_url"],

					"header" => $this->vars->data["portfolio_header_" . $this->tpl_module["mod_id"]],

					"items" => $base->html->Table(
						$template,
						"Cats",
						$records["cats"]
					)
				)
			),
			$this->tpl_module["settings"]
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
	function LoadRecords() {
		global $_NO_HTACCESS;

		//cats
		$cats = $this->db->QFetchRowArray(
			"SELECT * FROM {$this->tables['plugin:portfolio_cats']} " .
			"WHERE module_id={$this->tpl_module[mod_id]} ORDER BY cat_order ASC"
		);

		$this->module->EncodeItems(
			&$cats, 
			array(					
				"cat_title" , 
				"cat_url" , 
				"cat_urltitle" , 
				"cat_content_title" , 
			)
		);

		if ($this->tpl_module["settings"]["set_reverseorderp"]) {
			//projects
			$projects = $this->db->QFetchRowArray(
				"SELECT * FROM {$this->tables['plugin:portfolio_projects']} " .
				"WHERE module_id={$this->tpl_module[mod_id]} ORDER BY project_cat ASC,project_order DESC"
			);
		} else {
			$projects = $this->db->QFetchRowArray(
				"SELECT * FROM {$this->tables['plugin:portfolio_projects']} " .
				"WHERE module_id={$this->tpl_module[mod_id]} ORDER BY project_cat ASC,project_order ASC"
			);
		}

		$this->module->EncodeItems(
			&$projects, 
			array(					
				"project_title" , 
				"project_url" , 
				"project_url_title" , 
				"project_details_title" , 
			)
		);


		if ($this->tpl_module["settings"]["set_reverseorder"]) {
			//items
			$items = $this->db->QFetchRowArray(
				"SELECT * FROM {$this->tables['plugin:portfolio_items']} " .
				"WHERE module_id={$this->tpl_module[mod_id]} ORDER BY item_project ASC,item_order DESC"
			);		
		} else {
			$items = $this->db->QFetchRowArray(
				"SELECT * FROM {$this->tables['plugin:portfolio_items']} " .
				"WHERE module_id={$this->tpl_module[mod_id]} ORDER BY item_project ASC,item_order ASC"
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

		if (is_array($projects)) {
			foreach ($projects as $key => $val) {
				$cat_projects[$val["project_cat"]][] = $val;
			}
		}
		
		if (is_array($items)) {
			foreach ($items as $key => $val) {

				//process for sources
				if ($val["item_video"]) {

					if ($_NO_HTACCESS) {
						$val["source"] = "video_" . $val["item_id"] . ".flv";
					} else {
						$val["source"] = "videos/" . $val["item_id"] . "/" .$val["item_video_file"];
					}

				} else 
					$val["source"] = "img_" . $val["item_id"] . ".jpg";
				
				$projects_items[$val["item_project"]][] = $val;
			}
		}
		
		return array(
			"cats" => $cats,
			"projects" => $cat_projects,
			"items" => $projects_items,
		);
	}
	

}

?>