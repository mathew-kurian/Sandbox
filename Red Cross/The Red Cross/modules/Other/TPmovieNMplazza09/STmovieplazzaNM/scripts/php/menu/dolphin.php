<?php
defined('_JEXEC') or die('Restricted access'); 
ini_set('arg_separator.output','&amp;');

class TPMenu {
	var $_menutype = 'mainmenu';
	var $_css = null;
	var $_js = null;

	function __construct()
	{
		global $Itemid;
		$this->Itemid = $Itemid;
	}

	function displayMenu() {
		$menutype = $this->_menutype;
		
		global $Itemid,$mainframe;
	
		$database = & JFactory::getDBO();
    $my = & JFactory::getUser();
    $cur_template  = $mainframe->getTemplate(); 
		$contentConfig = &JComponentHelper::getParams( 'com_content' );
		$noauth = $contentConfig->get('shownoauth');

		$active = 0;
	 	if($Itemid==99999999) {
	 		$Itemid = 1;
	 	}
	
		if ($noauth) {
	 	$database->setQuery("SELECT m.*, count(p.parent) as cnt" .
	  "\nFROM #__menu AS m" .
	  "\nLEFT JOIN #__menu AS p ON p.parent = m.id" .
	  "\nWHERE m.menutype='$menutype' AND m.published='1' AND m.parent=0" .
	  "\nGROUP BY m.id ORDER BY m.parent, m.ordering ");
		} else {
			$database->setQuery("SELECT m.*, sum(case when p.published=1 then 1 else 0 end) as cnt" .
			"\nFROM #__menu AS m" .
			"\nLEFT JOIN #__menu AS p ON p.parent = m.id" .
			"\nWHERE m.menutype='$menutype' AND m.published='1' AND m.access <= '$my->gid' AND m.parent=0" .
			"\nGROUP BY m.id ORDER BY m.parent, m.ordering ");
	  }
	
	 $rows = $database->loadObjectList( 'id' );
	 echo $database->getErrorMsg();
		
		if (count($rows)) {
			$pre = '<div class="menutop" id="tp-menu-container">
							<div id="tp-menu-nav">
							<ul><li style="display:none"><a></a></li>';
			
			$n = 0;
		 foreach ($rows as $row)
		 {
			 	$n++;
				if ($noauth)
				{
			 		$database->setQuery("SELECT count(*) FROM #__menu AS m WHERE m.menutype='$menutype' AND m.published='1' AND m.parent='$row->id'");
				}
				else
				{
					$database->setQuery("SELECT count(*) FROM #__menu AS m WHERE m.menutype='$menutype' AND m.published='1' AND m.access <= '$my->gid' AND m.parent='$row->id'");
			  }
			 	echo $database->getErrorMsg();
				
				$row = $this->getMenuItem( $row );	

		    if($database->loadResult() >= 1 ) {
					if($row->id == $Itemid) {
						$active = $n;
					}
					$pre .= '<li class="tptopmenu tpmenuid'.$row->id.'"><a href="'.$row->link.'" rel="'.strtolower(str_replace(" ", "", $row->name)).'"><span>'.$row->name.'</span></a></li>
					';
				} else {
					$act = "";
					if($row->id == $Itemid) {
						$act = "active ";
						$active = $n;
					}
					$pre .= '<li class="'.$act.'tptopmenu tpmenuid'.$row->id.'"><a href="'.$row->link.'" rel="relhide"><span>'.$row->name.'</span></a></li>
					';
				}	
			}

			$pre .= '</ul>
			';
			$pre .= '</div>
			';

		 	$pre .= '<div style="display:none" id="relhide"></div>
		 	';

			$pre .= '<div id="tp-menu-inner">
			';
			
			$n = 0;
			 foreach ($rows as $row) {
			 	$n++;
					if ($noauth) {
				 	$database->setQuery("SELECT m.*, count(p.parent) as cnt" .
				  "\nFROM #__menu AS m" .
				  "\nLEFT JOIN #__menu AS p ON p.parent = m.id" .
				  "\nWHERE m.menutype='$menutype' AND m.published='1' AND m.parent='$row->id'" .
				  "\nGROUP BY m.id ORDER BY m.parent, m.ordering ");
					} else {
						$database->setQuery("SELECT m.*, sum(case when p.published=1 then 1 else 0 end) as cnt" .
						"\nFROM #__menu AS m" .
						"\nLEFT JOIN #__menu AS p ON p.parent = m.id" .
						"\nWHERE m.menutype='$menutype' AND m.published='1' AND m.access <= '$my->gid' AND m.parent='$row->id'" .
						"\nGROUP BY m.id ORDER BY m.parent, m.ordering ");
				  }
				
				 $rows2 = $database->loadObjectList( 'id' );
				 $number = 0;
				 echo $database->getErrorMsg();
					if (count($rows2)) {
					 	$number++;
						$pre .= '<div id="'.strtolower(str_replace(" ", "", $row->name)).'" class="tp-menu-inner-content" style="display:none"><ul>
						';
					 	foreach ($rows2 as $row2) {
							if($row2->id == $Itemid) {
								$active = $n;
							}
							$row2 = $this->getMenuItem( $row2 );

					    $pre .= '<li><a href="'.$row2->link.'">'.$row2->name.'</a></li>
							';
					 }
						$pre .= "</ul></div>
						";
					}
			 }
		 
			$pre .= '</div>
			';
			
			$pre .= '</div>
			';
			
			$pre .= '<script type="text/javascript">
			';
			$pre .= 'dolphintabs.init("tp-menu-nav", '.$active.');
			';
			$pre .= '</script>
			';
		}
		
		if(!empty($pre))
		{
			$document=& JFactory::getDocument();
			if( $document->getType() == 'html' )
			{
				if ( isset( $this->_css ) && $this->_css )
				{
					$document->addStyleSheet( $this->_css );
				}
				
				if ( isset( $this->_js ) && $this->_js )
				{
					$document->addScript( $this->_js );
				}
			}

			echo $pre;
		}
	}
	
	function getMenuItem( $menu )
	{
  	preg_match_all( "/({)(.*)(})/", $menu->name, $matches, PREG_SET_ORDER );
		$menuparams = ( !empty( $matches[0][2] ) ) ? $matches[0][2] : null;
		$menu->name = str_replace( "{".$menuparams."}", "", $menu->name );
		$menu->name = explode( "||", $menu->name );
		$menu->name = ( !empty( $menu->name[0] ) ) ? trim( $menu->name[0] ) : '';

		switch ( $menu->type )
		{
			case 'separator':
				$menu->link = '#';
			break;
			case 'url':
				if ( ( strpos( $menu->link, 'index.php?' ) !== false ) && ( strpos( $menu->link, 'Itemid=' ) === false ) )
				{
					$menu->link = $menu->link.'&amp;Itemid='.$menu->id;
				}
				else
				{
					$menu->link = $menu->link;
				}
			break;
			default:
				$router = JSite::getRouter();
				$menu->link = $router->getMode() == JROUTER_MODE_SEF ? 'index.php?Itemid='.$menu->id : $menu->link.'&Itemid='.$menu->id;
			break;
		}
		
		$menu->link = JRoute::_( $menu->link );

		$itemparams = new JParameter( $menu->params );
		$iSecure = $itemparams->def( 'secure', 0 );
		if ( $menu->home == 1 )
		{
			$menu->link = JURI::base();
		}
		else if ( strcasecmp( substr( $menu->link, 0, 4 ), 'http' ) && ( strpos( $menu->link, 'index.php?' ) !== false ) )
		{
			$menu->link = JRoute::_( $menu->link, true, $iSecure );
		}
		else
		{
			$menu->link = str_replace( '&', '&amp;', $menu->link );
		}
		
		return $menu;
	}
}

?>