<?php
// no direct access
defined('_JEXEC') or die('Restricted access');
function pagination_list_footer($list)
{
	$html = "<div class=\"list-footer\">\n";
	$html .= "\n<div class=\"limit\">".JText::_('Display Num').$list['limitfield']."</div>";
	$html .= $list['pageslinks'];
	$html .= "\n<div class=\"counter\">".$list['pagescounter']."</div>";
	$html .= "\n<input type=\"hidden\" name=\"limitstart\" value=\"".$list['limitstart']."\" />";
	$html .= "\n</div>";
	return $html;
}

function pagination_list_render($list)
{
	// Initialize variables
	$html = "<br/><span class=\"pagination\">";
	$html .= $list['start']['data'];
	$html .= $list['previous']['data'];
	foreach( $list['pages'] as $page )
	{
		if($page['data']['active']) {
			$html .= '<strong>';
		}
		$html .= $page['data'];
		if($page['data']['active']) {
			$html .= '</strong>';
		}
	}

	$html .= $list['next']['data'];
	$html .= $list['end']['data'];
	$html .= "</span>";
	return $html;
}

function pagination_item_active(&$item) {
	if(strtolower($item->text) == 'start') {
		return "<a href=\"".$item->link."\" title=\"".$item->text."\">&laquo;&nbsp;".$item->text."</a>";
	} else if (strtolower($item->text) == 'end') {
		return "<a href=\"".$item->link."\" title=\"".$item->text."\">".$item->text."&nbsp;&raquo;</a>";
	} else {
		return "<a href=\"".$item->link."\" title=\"".$item->text."\">".$item->text."</a>";
	}
}

function pagination_item_inactive(&$item) {
	if(strtolower($item->text) == 'start') {
		return "<span>&laquo;&nbsp;".$item->text."</span>";
	} else if (strtolower($item->text) == 'end') {
		return "<span>".$item->text."&nbsp;&raquo;</span>";
	} else {
		return "<span>".$item->text."</span>";
	}
}

?>