<?php

// Check to ensure this file is included in Joomla!
defined('_JEXEC') or die( 'Restricted access' );

class JElementContact extends JElement
{
	var	$_name = 'Contact';

	function fetchElement( $name, $value, &$node, $control_name )
	{
		$db = &JFactory::getDBO();

		$query = 'SELECT a.id, CONCAT( a.name, " - ",a.con_position ) AS text, a.catid '
		. ' FROM #__contact_details AS a'
		. ' INNER JOIN #__categories AS c ON a.catid = c.id'
		. ' WHERE a.published = 1'
		. ' AND c.published = 1'
		. ' ORDER BY a.catid, a.name'
		;
		$db->setQuery( $query );
		$options = $db->loadObjectList();

		return JHTML::_( 'select.genericlist',  $options, ''.$control_name.'['.$name.']', 'class="inputbox"', 'id', 'text', $value, $control_name.$name );
	}
}

?>