<?php
/*
	OXYLUS Development web framework
	copyright (c) 2002-2008 OXYLUS Development
		web:  www.oxylus-development.com
		mail: support@oxylus-development.com

	$Id: name.php,v 0.0.1 dd/mm/yyyy hh:mm:ss oxylus Exp $
	description
*/

// dependencies

global $_MODULES;

if ($_GET["action"] == "detectmod") {
	$module = $_MODULES["oxymall"]->plugins["modules"]->GetModuleByCode($_GET["module"]);

	if (is_array($module)) {
		$_GET["module_id"] = $module["mod_id"];
		$_TSM["PB_EVENTS"] = $_MODULES["oxymall"]->plugins[$module["mod_module_code"]]->AlternateContent();
	}
	
}


//default seo fields

$_MODULES["oxymall"]->plugins["modules"]->SetSEo(
	array (
		"seo_title"	=> $_MODULES["oxymall"]->private->vars->data["set_meta_title"],
		"seo_desc"	=> $_MODULES["oxymall"]->private->vars->data["set_meta_desc"],
		"seo_keys"	=> $_MODULES["oxymall"]->private->vars->data["set_meta_keys"],
	)
);

?>