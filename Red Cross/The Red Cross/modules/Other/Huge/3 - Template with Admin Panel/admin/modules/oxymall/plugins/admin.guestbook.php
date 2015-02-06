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
class COXYMallGuestBook extends CPlugin{
	
	var $tplvars; 

	function COXYMallGuestBook() {
		//$this->CPlugin($db, $tables , $templates);
	}

	function DoEvents(){
		global $base, $_CONF, $_TSM , $_VARS , $_USER , $_BASE , $_SESS;

		parent::DoEvents();

		if (strstr($_GET["sub"] , "oxymall.plugin.guestbook.")) {
			$sub = str_replace("oxymall.plugin.guestbook." , "" ,$_GET["sub"]);
			$action = $_GET["action"];

			//read the module
			$this->tpl_module = $this->module->plugins["modules"]->getModuleInfo($_GET["module_id"]);

			switch ($sub) {
				case "landing":
					$data = new CSQLAdmin("guestbook/" . $sub, $this->__parent_templates,$this->db,$this->tables,$extra);
					$this->PrepareFields(&$data->forms["forms"]);
					return $data->DoEvents();
				break;


				case "images":

					if (($_GET["action"] == "moveup") || ($_GET["action"] == "movedown")) {
						$this->__call_reorder_images($_GET["action"]);
					}


					$data = new CSQLAdmin("guestbook/" . $sub, $this->__parent_templates,$this->db,$this->tables,$extra);
					$data->functions = array( 
							"onstore" => array(&$this , "StoreImg"),
					);					
					$this->PrepareFields(&$data->forms["forms"]);
					return $data->DoEvents();
				break;
			}
		}
	}

	function PrepareFields($forms) {
		$forms["list"]["title"] = CTemplateStatic::Replace(
			$forms["list"]["title"],
			array( "title" => $this->tpl_module["mod_name"])
		);

		if ($forms["search"]["title"] ) {
			$forms["search"]["title"] = CTemplateStatic::Replace(
				$forms["search"]["title"],
				array( "title" => $this->tpl_module["mod_name"])
			);
		}
		

		$forms["edit"]["title"] = CTemplateStatic::Replace(
			$forms["edit"]["title"],
			array( "title" => $this->tpl_module["mod_name"])
		);

		$forms["add"]["title"] = CTemplateStatic::Replace(
			$forms["add"]["title"],
			array( "title" => $this->tpl_module["mod_name"])
		);

	}
	

	function StoreImg($record) {
		if ($record["img_id"] && !$record["img_order"]) {
			$this->db->QueryUpdate(
				$this->tables["plugin:guestbook_images"],
				array(
					"img_order" => $record["img_id"]
				),
				"img_id='{$record[img_id]}'"
			);
		}		
	}


	function __call_reorder_images($action) {

		$sql = "SELECT * FROM {$this->tables['plugin:guestbook_images']} WHERE img_order " . ($_GET["action"] == "moveup" ? " <= " : " >= " ) . " '{$_GET[img_order]}' ORDER BY img_order " . ($_GET["action"] == "moveup" ? " DESC " : " ASC " ) . " LIMIT 2 " ;

		$rows = $this->db->QFetchRowArray($sql);

		if (count($rows) == 2) {

			//insert the new values
			$this->db->QueryUpdate(
						$this->tables['plugin:guestbook_images'],
						array(
							"img_order" => $rows[1]["img_order"]
						),
						" img_id='{$rows[0][img_id]}'"
					);

			//insert the new values
			$this->db->QueryUpdate(
						$this->tables['plugin:guestbook_images'],
						array(
							"img_order" => $rows[0]["img_order"]
						),
						" img_id='{$rows[1][img_id]}'"
					);
		}

		//debug($_SERVER);

		UrlRedirect($_SERVER["HTTP_REFERER"]);
		die;
	}




}

?>