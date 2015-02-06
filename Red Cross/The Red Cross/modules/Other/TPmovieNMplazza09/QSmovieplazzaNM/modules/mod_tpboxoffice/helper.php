<?php

// no direct access
defined('_JEXEC') or die('Restricted access');

class modTPBoxOffice
{
	function getLists( $params )
	{
		$datas = array();

		for( $n = 1; $n <= 10; $n++ )
		{
			$datas[] = array( 'order' => $params->get( 'order' . $n ), 'number' => $n );
		}
		
		foreach ($datas as $key => $row)
		{
			$order[$key] = $row['order'];
			$number[$key]  = $row['number'];
		}

		array_multisort($order, SORT_ASC, $number, SORT_ASC, $datas);

		$lists = array();
		$order = array();

		foreach ($datas as $key => $row)
		{
			$n = $row['number'];

			$icon = $params->get( 'icon' . $n, 'default.png' );
			$title = $params->get( 'title' . $n );
			$url = $params->get( 'url' . $n );
			$revenue = $params->get( 'revenue' . $n );
			$ordering = $params->get( 'order' . $n );
			if( !empty( $title ) )
			{
				for( $o=1; $o <= 10; $o++ )
				{
					if( in_array( $ordering, $order ) )
					{
						$ordering++;
					}
				}
				$order[$ordering] = true;
				
				$list = new JObject;
				$list->icon = $icon;
				$list->title = $title;
				$list->url = $url;
				$list->revenue = $revenue;

				$lists[$ordering] = $list;
			}
		}
		unset( $order );
		return $lists;
	}
}