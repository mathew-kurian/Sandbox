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
class COXYMallJobs extends CPlugin{
	
	var $tplvars; 

	function COXYMallJobs() {
		//$this->CPlugin($db, $tables , $templates);
	}

	function DoEvents(){
		global $base, $_CONF, $_TSM , $_VARS , $_USER , $_BASE , $_SESS;

		parent::DoEvents();

		if (strstr($_GET["sub"] , "oxymall.plugin.jobs.")) {
			$sub = str_replace("oxymall.plugin.jobs." , "" ,$_GET["sub"]);
			$action = $_GET["action"];

			//read the module
			$this->tpl_module = $this->module->plugins["modules"]->getModuleInfo($_GET["module_id"]);

			switch ($sub) {

				case "landing":
				case "resumes":
					if (($_GET["action"] == "moveup") || ($_GET["action"] == "movedown")) {
						$this->__call_reorder_jobs($_GET["action"]);
					}
					
					$data = new CSQLAdmin("jobs/" . $sub, $this->__parent_templates,$this->db,$this->tables,$extra);

					$this->PrepareFields(&$data->forms["forms"] , $sub);

					if ($sub == "landing") {
						$data->functions = array( 
								"onstore" => array(&$this , "StoreJob"),
						);					
					}

					return $data->DoEvents();
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
	function PrepareFields($forms , $sub) {
		if (is_array($forms["search"])) {
			$forms["search"]["title"] = CTemplateStatic::Replace(
				$forms["search"]["title"],
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

		if ($this->tpl_module["settings"]["set_reverseorder"] && ($sub == "landing")) {
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
	function StoreJob($record) {
		if ($record["item_id"] && !$record["item_order"]) {
			$this->db->QueryUpdate(
				$this->tables["plugin:jobs_items"],
				array(
					"item_order" => $record["item_id"]
				),
				"item_id='{$record[item_id]}'"
			);
		}		
	}
	

	
	function __call_reorder_jobs($action) {

		if ($this->tpl_module["settings"]["set_reverseorder"]) {
			$sql = "SELECT * FROM {$this->tables['plugin:jobs_items']} WHERE module_id={$this->tpl_module[mod_id]} AND item_order " . ($_GET["action"] == "moveup" ? " >= " : " <= " ) . " '{$_GET[item_order]}' ORDER BY item_order " . ($_GET["action"] == "moveup" ? " ASC " : " DESC " ) . " LIMIT 2 " ;
		} else {
			$sql = "SELECT * FROM {$this->tables['plugin:jobs_items']} WHERE module_id={$this->tpl_module[mod_id]} AND item_order " . ($_GET["action"] == "moveup" ? " <= " : " >= " ) . " '{$_GET[item_order]}' ORDER BY item_order " . ($_GET["action"] == "moveup" ? " DESC " : " ASC " ) . " LIMIT 2 " ;
		}

		$rows = $this->db->QFetchRowArray($sql);

		if (count($rows) == 2) {

			//insert the new values
			$this->db->QueryUpdate(
						$this->tables['plugin:jobs_items'],
						array(
							"item_order" => $rows[1]["item_order"]
						),
						" item_id='{$rows[0][item_id]}'"
					);

			//insert the new values
			$this->db->QueryUpdate(
						$this->tables['plugin:jobs_items'],
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



}

?>