<?php

/*	OXYLUS Development web framework 
	copyright (c) 2002-2008 OXYLUS Development & Juggler Design All rights reserved 
	
	Contact Canada/US 
		web: www.jugglerdesign.com 
		mail: info@jugglerdesign.com 
		US and Canadian Patent Pending 
	
	Contact Romania 
		web: www.oxylus.ro 
		mail: support@oxylus.ro 
		Romanian Patent Pending 
		
*/

// dependencies

/**
* description
*
* @library	
* @author	
* @since	
*/
class COXYMall extends CModule{
	
	var $tplvars; 

	function COXYMall() {
		parent::CModule("oxymall");
		
		//get the core part
		$this->path = _MODPATH  . $this->name;
//		$this->__coreFiles = CDir::GetFiles($this->path . "/core/",  ".php");
		$this->__pluginsFiles = CDir::GetFilesRec($this->path . "/plugins/",  ".php");

		$this->language = 1;
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
	function __init() {
		parent::__init();

		//load the core and the p[lugins
		//initialize the core and the plugins
		if (is_array($this->__coreFiles)) {
			foreach ($this->__coreFiles as $key => $val) {
				if (strstr($val , "site." ) && strstr($val , ".php" )) {
					//read the file
					include_once($val);
					$file = str_replace("site." , "" , basename($val , ".php"));
					eval('$this->core[' . $file . '] = new COXYMall' . $file . '($this->db,$this->tables,$this->private->templates);');
					$this->core[$file]->CPlugin(&$this->db,&$this->private->tables,&$this->private->templates);
					$this->core[$file]->__parent_templates = &$this->templates;
					$this->core[$file]->vars = &$this->private->vars;
					$this->core[$file]->language = &$this->language;
					$this->core[$file]->module = &$this;
					$this->core[$file]->site = &$this->site;
					$this->core[$file]->tpl_path = _MODPATH . "/" . $this->name . "/core/templates/{$file}/" ;
					$this->core[$file]->forms_path = _MODPATH . "/" . $this->name . "/core/forms/{$file}/" ;
					
				}
			}			
		}

		if (is_array($this->__pluginsFiles)) {
			foreach ($this->__pluginsFiles as $key => $val) {
				if (strstr($val , "site." ) && strstr($val , ".php" )) {
					//read the file
					include_once($val);
					$file = str_replace("site." , "" , basename($val , ".php"));
					eval('$this->plugins[' . $file . '] = new COXYMall' . $file . '($this->db,$this->tables,$this->private->templates);');
					$this->plugins[$file]->CPlugin(&$this->db,&$this->private->tables,&$this->private->templates);
					$this->plugins[$file]->__parent_templates = &$this->templates;
					$this->plugins[$file]->vars = &$this->private->vars;
					$this->plugins[$file]->language = &$this->language;
					$this->plugins[$file]->module = &$this;
					$this->plugins[$file]->site = &$this->site;
					$this->plugins[$file]->tpl_path = _MODPATH . "/" . $this->name . "/plugins/templates/{$file}/" ;
					$this->plugins[$file]->forms_path = _MODPATH . "/" . $this->name . "/plugins/forms/{$file}/" ;
					
				}
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
	function DoEvents(){
		global $base, $_CONF, $_TSM , $_VARS , $_USER , $_BASE , $_SESS;

		if (!$this->__protect())
			return false;


		if (is_array($this->core)) {
			//save tthe forms path
			$tmp = $_CONF["forms"]["adminpath"];

			foreach ($this->core as $key => $val) {
				//temp fix				
				$_CONF["forms"]["adminpath"] = _MODPATH . "/" . $this->name . "/core/forms/" ;
				if ($data = $val->doEvents()) {
					if ($data !== FALSE) {
						return $data;
					}					
				}
			}			

			//restore it 
			$_CONF["forms"]["adminpath"] = $tmp; 
		}

		if (is_array($this->plugins)) {
			//save tthe forms path
			$tmp = $_CONF["forms"]["adminpath"];

			foreach ($this->plugins as $key => $val) {
				//temp fix				
				$_CONF["forms"]["adminpath"] = _MODPATH . "/" . $this->name . "/plugins/forms/" ;
				if ($data = $val->doEvents()) {
					if ($data !== FALSE) {
						return $data;
					}					
				}
			}			

			//restore it 
			$_CONF["forms"]["adminpath"] = $tmp; 
		}
	}

	function EncodeItems($items , $fields) {
		if (is_array($items)) {
			foreach ($items as $key => $val) {
				if (is_array($val)) {
					$this->EncodeItems(&$items[$key] , $fields);
				} else {
					if (in_array($key , $fields )) {
						$items[$key] = str_replace("\"" , "&quot;" , $val);//htmlentities($val . "\"");
					}					
				}
			}
		}
	}

	function __protect() {

		if ($this->name != $_GET["mod"])
			return false;
		
		parent::__protect();

		return true;
	}


}

?>