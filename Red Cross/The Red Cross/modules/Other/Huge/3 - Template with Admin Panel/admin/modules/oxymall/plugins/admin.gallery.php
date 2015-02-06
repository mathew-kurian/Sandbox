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

		if (strstr($_GET["sub"] , "oxymall.plugin.gallery.")) {
			$sub = str_replace("oxymall.plugin.gallery." , "" ,$_GET["sub"]);
			$action = $_GET["action"];

			//read the module
			$this->tpl_module = $this->module->plugins["modules"]->getModuleInfo($_GET["module_id"]);

			switch ($sub) {

				case "landing":

					if (($_GET["action"] == "moveup") || ($_GET["action"] == "movedown")) {
						$this->__call_reorder_cats($_GET["action"]);
					}
					
					$data = new CSQLAdmin("gallery/" . $sub, $this->__parent_templates,$this->db,$this->tables,$extra);

					$this->PrepareFields(&$data->forms["forms"] , $sub);

					$data->functions = array( 
							"onstore" => array(&$this , "StoreCat"),
					);					

					return $data->DoEvents();

				break;

				case "images":

					if (($_GET["action"] == "moveup") || ($_GET["action"] == "movedown")) {
						$this->__call_reorder_images($_GET["action"]);
					}
					
					$data = new CSQLAdmin("gallery/" . $sub, $this->__parent_templates,$this->db,$this->tables,$extra);

					$this->PrepareFields(&$data->forms["forms"] , $sub);

					$data->functions = array( 
							"onstore" => array(&$this , "StoreImage"),
					);					

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

		if ($this->tpl_module["settings"]["set_reverseorder"] && ($sub == "images")) {
			$forms["list"]["sql"]["vars"]["order_mode"]["import"] = "desc";
		}

		if ($this->tpl_module["settings"]["set_reverseorder_albums"] && ($sub == "landing")) {
			$forms["list"]["sql"]["vars"]["order_mode"]["import"] = "desc";

		}
		


		if (is_array($forms["edit"]["fields"]["item_image"])) {

			$width = $this->tpl_module["settings"]["set_thumbwidth"];
			$height = $this->tpl_module["settings"]["set_thumbheight"];

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
				$this->tables["plugin:gallery_cats"],
				array(
					"cat_order" => $record["cat_id"]
				),
				"cat_id='{$record[cat_id]}'"
			);
		}		
	}
	

	function __call_reorder_cats($action) {

		if ($this->tpl_module["settings"]["set_reverseorder_albums"]) {
			$sql = "SELECT * FROM {$this->tables['plugin:gallery_cats']} WHERE module_id={$this->tpl_module[mod_id]} AND cat_order " . ($_GET["action"] == "moveup" ? " <= " : " >= " ) . " '{$_GET[cat_order]}' ORDER BY cat_order " . ($_GET["action"] == "moveup" ? " DESC " : " ASC " ) . " LIMIT 2 " ;
		} else {
			$sql = "SELECT * FROM {$this->tables['plugin:gallery_cats']} WHERE module_id={$this->tpl_module[mod_id]} AND cat_order " . ($_GET["action"] == "moveup" ? " >= " : " <= " ) . " '{$_GET[cat_order]}' ORDER BY cat_order " . ($_GET["action"] == "moveup" ? " ASC " : " DESC " ) . " LIMIT 2 " ;
		}



		$rows = $this->db->QFetchRowArray($sql);

		if (count($rows) == 2) {

			//insert the new values
			$this->db->QueryUpdate(
						$this->tables['plugin:gallery_cats'],
						array(
							"cat_order" => $rows[1]["cat_order"]
						),
						" cat_id='{$rows[0][cat_id]}'"
					);

			//insert the new values
			$this->db->QueryUpdate(
						$this->tables['plugin:gallery_cats'],
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
				$this->tables["plugin:gallery_items"],
				array(
					"item_order" => $record["item_id"]
				),
				"item_id='{$record[item_id]}'"
			);
		}		
	}

	function __call_reorder_images($action) {

		$item = $this->db->QFetchArray("SELECT * FROM {$this->tables['plugin:gallery_items']} WHERE item_id='{$_GET[item_id]}' ");

		if ($this->tpl_module["settings"]["set_reverseorder"]) {
			$sql = "SELECT * FROM {$this->tables['plugin:gallery_items']} WHERE module_id={$this->tpl_module[mod_id]} AND item_cat='{$item[item_cat]}' AND item_order " . ($_GET["action"] == "moveup" ? " >= " : " <= " ) . " '{$_GET[item_order]}' ORDER BY item_order " . ($_GET["action"] == "moveup" ? " ASC " : " DESC " ) . " LIMIT 2 " ;
		} else {
			$sql = "SELECT * FROM {$this->tables['plugin:gallery_items']} WHERE module_id={$this->tpl_module[mod_id]} AND item_cat='{$item[item_cat]}' AND item_order " . ($_GET["action"] == "moveup" ? " <= " : " >= " ) . " '{$_GET[item_order]}' ORDER BY item_order " . ($_GET["action"] == "moveup" ? " DESC " : " ASC " ) . " LIMIT 2 " ;

		}

		$rows = $this->db->QFetchRowArray($sql);

		if (count($rows) == 2) {

			//insert the new values
			$this->db->QueryUpdate(
						$this->tables['plugin:gallery_items'],
						array(
							"item_order" => $rows[1]["item_order"]
						),
						" item_id='{$rows[0][item_id]}'"
					);

			//insert the new values
			$this->db->QueryUpdate(
						$this->tables['plugin:gallery_items'],
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