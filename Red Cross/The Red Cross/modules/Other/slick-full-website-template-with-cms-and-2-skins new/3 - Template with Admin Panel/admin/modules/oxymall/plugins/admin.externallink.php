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
class COXYMallExternalLink extends CPlugin{
	
	var $tplvars; 

	function COXYMallExternalLink() {
		//$this->CPlugin($db, $tables , $templates);
	}

	function DoEvents(){
		global $base, $_CONF, $_TSM , $_VARS , $_USER , $_BASE , $_SESS;

		parent::DoEvents();

		if (strstr($_GET["sub"] , "oxymall.plugin.external-link.")) {

			urlredirect("index.php?mod=oxymall&sub=oxymall.plugin.modules.user&mod_id={$_GET[module_id]}&action=details&returnurl=index.php");
		}
	}

}

?>