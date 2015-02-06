<?php

defined('_JEXEC') or die('Restricted access');

class modTPStyleSwitcherHelper
{
	function parseXMLTemplateFile($templateDir)
	{
		// Check of the xml file exists
		if(!is_file($templateDir.DS.'templateDetails.xml')) {
			return false;
		}

		$xml = JApplicationHelper::parseXMLInstallFile($templateDir.DS.'templateDetails.xml');

		if ($xml['type'] != 'template') {
			return false;
		}

		$data = new StdClass();
		$data->directory = $templateDir;

		foreach($xml as $key => $value) {
			$data->$key = $value;
		}

		$data->checked_out = 0;
		$data->mosname = JString::strtolower(str_replace(' ', '_', $data->name));

		return $data;
	}
}

?>