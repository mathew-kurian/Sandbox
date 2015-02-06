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
class COXYMallMusic extends CPlugin{
	
	var $tplvars; 

	function COXYMallMusic() {
		//$this->CPlugin($db, $tables , $templates);
	}

	function DoEvents(){
		global $base, $_CONF, $_TSM , $_VARS , $_USER , $_BASE , $_SESS;

		parent::DoEvents();

		if (strstr($_GET["sub"] , "oxymall.plugin.music.")) {
			$sub = str_replace("oxymall.plugin.music." , "" ,$_GET["sub"]);
			$action = $_GET["action"];

			switch ($sub) {

				case "landing":
					if (($_GET["action"] == "moveup") || ($_GET["action"] == "movedown")) {
						$this->__call_reorder_music($_GET["action"]);
					}
					
					$data = new CSQLAdmin("music/" . $sub, $this->__parent_templates,$this->db,$this->tables,$extra);

					$data->functions = array( 
							"onstore" => array(&$this , "StoreMusic"),
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
	function StoreMusic($record) {
		if ($record["item_id"] && !$record["item_order"]) {
			$this->db->QueryUpdate(
				$this->tables["plugin:music_items"],
				array(
					"item_order" => $record["item_id"]
				),
				"item_id='{$record[item_id]}'"
			);
		}		
	}
	

	
	function __call_reorder_music($action) {

		$sql = "SELECT * FROM {$this->tables['plugin:music_items']} WHERE item_order " . ($_GET["action"] == "moveup" ? " <= " : " >= " ) . " '{$_GET[item_order]}' ORDER BY item_order " . ($_GET["action"] == "moveup" ? " DESC " : " ASC " ) . " LIMIT 2 " ;

		$rows = $this->db->QFetchRowArray($sql);

		if (count($rows) == 2) {

			//insert the new values
			$this->db->QueryUpdate(
						$this->tables['plugin:music_items'],
						array(
							"item_order" => $rows[1]["item_order"]
						),
						" item_id='{$rows[0][item_id]}'"
					);

			//insert the new values
			$this->db->QueryUpdate(
						$this->tables['plugin:music_items'],
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