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
class COXYMallSitemaps extends CPlugin{	
	
	var $tplvars; 

	function COXYMallSitemaps() {
		//$this->CPlugin($db, $tables , $templates);
	}

	function DoEvents(){
		global $base, $_CONF, $_TSM , $_VARS , $_USER , $_BASE , $_SESS;

		parent::DoEvents();

		if ($_GET["sub"] == "oxymall.plugin.sitemaps.google") {
			return $this->GoogleMap();
		}

		if ($_GET["sub"] == "oxymall.plugin.sitemaps.urllist") {
			return $this->YahooMap();
		}

	}

	function GoogleMap() {
		//get all the modules
		$links = $this->read_links();

		global $_CONF;

		if (is_array($links)) {
			foreach ($links as $key => $val) {
				$links[$key]["url"] = $_CONF["url"] . $val["url"];
			}
		}

		global $base;

		$this->module->plugins["modules"]->MimeXML();

		$template = new CTemplateDynamic($this->tpl_path . "googlemap.xml");

		return $base->html->table(
			$template , 
			"Map" ,
			$links
		);

	}	

	function YahooMap() {
		//get all the modules
		$links = $this->read_links();

		global $_CONF;

		if (is_array($links)) {
			foreach ($links as $key => $val) {
				$links[$key]["url"] = $_CONF["url"] . $val["url"];
			}
		}

		global $base;

		//$this->module->plugins["modules"]->MimeXML();

		$template = new CTemplateDynamic($this->tpl_path . "urllist.txt");

		echo $base->html->table(
			$template , 
			"Map" ,
			$links
		);
		die();

	}	

	function read_links() {

		header("Content-type: text/plain");

		$links[] = array(
			"url" => "",
			"priority" => "1",
		);

		$modules = $this->db->QFetchRowArray(
			"SELECT * FROM " . 
				$this->tables['core:modules'] . ", " . 
				$this->tables['core:user_modules'] . " " . 
			"WHERE mod_module=module_id AND mod_status=1 AND module_code!='category' AND module_code!='external-link' " .
			"ORDER BY mod_order ASC"
		);

		if (is_array($modules)) {
			foreach ($modules as $key => $val) {
				$links[] = array(
					"url" => $val["mod_url"] . "/",
					"priority"	=> "0.9",
				);

				$this->module->plugins[$val["module_code"]]->GetAllLinks($val , &$links);

			}			
		}

		return $links;
	}
	
}

?>