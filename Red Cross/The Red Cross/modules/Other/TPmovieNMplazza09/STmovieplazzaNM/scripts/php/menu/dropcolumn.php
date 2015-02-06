<?php

defined('_JEXEC') or die('Restricted access'); 
ini_set('arg_separator.output','&amp;');

class TPMenu {
  var $_menutype;
  var $_openall;
  var $_start;
  var $_end;
  var $_open;
  var $_output;
  var $_columns = 2;
  var $_column_width = 200;
  var $_show_menu_text;

  var $_js = null;
  var $_css = null;
  
	var $_menu_images_pos;

  function getLink( $mitem, $level, $active_stat ) {
  	global $Itemid;
  	$txt = '';

		switch ( $mitem->type )
		{
			case 'separator':
				$mitem->link = '#';
			break;
			case 'url':
				if ( ( strpos( $mitem->link, 'index.php?' ) !== false ) && ( strpos( $mitem->link, 'Itemid=' ) === false ) )
				{
					$mitem->link = $mitem->link.'&amp;Itemid='.$mitem->id;
				}
				else
				{
					$mitem->link = $mitem->link;
				}
			break;
			default:
				$router = JSite::getRouter();
				$mitem->link = $router->getMode() == JROUTER_MODE_SEF ? 'index.php?Itemid='.$mitem->id : $mitem->link.'&Itemid='.$mitem->id;
			break;
		}

		$mitem->link = JRoute::_( $mitem->link );

		$itemparams = new JParameter( $mitem->params );
		$iSecure = $itemparams->def( 'secure', 0 );
		if ( $mitem->home == 1 )
		{
			$mitem->link = JURI::base();
		}
		else if ( strcasecmp( substr( $mitem->link, 0, 4 ), 'http' ) && ( strpos( $mitem->link, 'index.php?' ) !== false ) )
		{
			$mitem->link = JRoute::_( $mitem->link, true, $iSecure );
		}
		else
		{
			$mitem->link = str_replace( '&', '&amp;', $mitem->link );
		}

  	$class = ($mitem->cnt > 0) ? ' class="haschild" ' : ' ';

    switch ($mitem->browserNav) {
  		case 1:
				$txt = "<a".$class."href=\"$mitem->link\" target=\"_window\" >".$this->show_image($mitem, $level, $active_stat)."</a>\n";
  			break;
  		case 2:
	  		$txt = "<a".$class."href=\"#\" onClick=\"javascript: window.open('$mitem->link', '', 'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=780,height=550');\">".$this->show_image($mitem, $level, $active_stat)."</a>\n";
	  		break;
  		case 3:
				$txt = "<a".$class.">".$this->show_image($mitem, $level, $active_stat)."</a>\n";
  			break;
  		default:
  		  $txt = "<a".$class."href=\"$mitem->link\">".$this->show_image($mitem, $level, $active_stat)."</a>";
	      break;
  	}
    return $txt;
  }

	function show_image($mitem, $level, $active_stat){
		global $Itemid;

  	preg_match_all( "/({)(.*)(})/", $mitem->name, $matches, PREG_SET_ORDER );
		$mitemparams = ( !empty( $matches[0][2] ) ) ? $matches[0][2] : null;
		$mitem->name = str_replace( "{".$mitemparams."}", "", $mitem->name );
		$mitem->namedisplay = $mitem->name;
		$subtitle = null;
		$split = explode('||', $mitem->name, 2);
		if (count($split) == 2) {
			$mitem->namedisplay = $split[0];
			if($level == 1)
			{
				$subtitle = '<span class="tpsubtitle">'.$split[1].'</span>';
			}
			else
			{
				$subtitle = '<span class="tpchildsubtitle">'.$split[1].'</span>';
			}
		}

		$menu_params = new stdClass();
		$menu_params = new JParameter( $mitem->params );
		$menu_image = $menu_params->def( 'menu_image', -1 );

		if (!$this->_show_menu_text)
		{
			$subtitle = null;
			$mitem->namedisplay = ($menu_image != -1) ? "&nbsp;" : $mitem->namedisplay;
		}

		$class = ($level == 1) ? 'tpparenttitle' : 'tpchildtitle';
		$txt = '<span class="'.$class.'">' . $mitem->namedisplay . '</span>' . $subtitle;
		
		return $txt;
	}
  
  function displayMenu() {
		$this->_openall = 1;
		$this->_start = 1;
		$this->_end = 11;
    $this->_open = array();
    
   	global $Itemid, $mainframe;
  	global $HTTP_SERVER_VARS;

		$database = & JFactory::getDBO();
    $my = & JFactory::getUser();
    $cur_template = $mainframe->getTemplate(); 
		$contentConfig = &JComponentHelper::getParams( 'com_content' );
		$noauth = $contentConfig->get('shownoauth');

   	$hilightid = null;
   	$startid = 0;
		
		if ($noauth) {
			$database->setQuery("SELECT m.*, count(p.parent) as cnt" .
			"\nFROM #__menu AS m" .
		  "\nLEFT JOIN #__menu AS p ON p.parent = m.id" .
		  "\nWHERE m.menutype='$this->_menutype' AND m.published='1' AND m.parent=0" .
		  "\nGROUP BY m.id ORDER BY m.parent, m.ordering ");
		} else {
			$database->setQuery("SELECT m.*, sum(case when p.published=1 then 1 else 0 end) as cnt" .
			"\nFROM #__menu AS m" .
			"\nLEFT JOIN #__menu AS p ON p.parent = m.id" .
			"\nWHERE m.menutype='$this->_menutype' AND m.published='1' AND m.access <= '$my->gid' AND m.parent=0" .
			"\nGROUP BY m.id ORDER BY m.parent, m.ordering ");
	  }

	 	$rows = $database->loadObjectList();
	 	echo $database->getErrorMsg();
  	$active_stat = true;
		if (count($rows)) {
			$this->_output .= '<ul class="clearfix"  id="tp-cssmenu">';
			$n = 0;
			$menuid = 0;
		 	foreach ($rows as $row) {
		 		$menuid++;
				if ($noauth) {
			  	$database->setQuery("SELECT count(*) FROM #__menu AS m WHERE m.menutype='$this->_menutype' AND m.published='1' AND m.parent='$row->id'");
				} else {
					$database->setQuery("SELECT count(*) FROM #__menu AS m WHERE m.menutype='$this->_menutype' AND m.published='1' AND m.access <= '$my->gid' AND m.parent='$row->id'");
			  }
			  echo $database->getErrorMsg();

				if ($noauth) {
				 	$query ="SELECT m.*, count(p.parent) as cnt" .
				  "\nFROM #__menu AS m" .
				  "\nLEFT JOIN #__menu AS p ON p.parent = m.id" .
				  "\nWHERE m.menutype='$this->_menutype' AND m.published='1' AND m.parent='$row->id'" .
				  "\nGROUP BY m.id ORDER BY m.parent, m.ordering ";
					$database->setQuery($query);
				} else {
					$query ="SELECT m.*, sum(case when p.published=1 then 1 else 0 end) as cnt" .
					"\nFROM #__menu AS m" .
					"\nLEFT JOIN #__menu AS p ON p.parent = m.id" .
					"\nWHERE m.menutype='$this->_menutype' AND m.published='1' AND m.access <= '$my->gid' AND m.parent='$row->id'" .
					"\nGROUP BY m.id ORDER BY m.parent, m.ordering ";
					$database->setQuery($query);
			  }
				//echo $query;
				$rows2 = $database->loadObjectList( 'id' );
				echo $database->getErrorMsg();
				  
			  $active = "";
				$active_stat = false;
			  if($Itemid == $row->id) {
			  	$active = "active ";
					$active_stat = true;
				}
				  
			  foreach ($rows2 as $subrow) {
			  	if($Itemid == $subrow->id) {
				  	$active = "active ";
						$active_stat = true;
					}
			  }

        $current_itemid =JRequest::getVar( 'Itemid', 0, '', 'int' );
        if ($row->link != "seperator" 
  					&& $current_itemid == $row->id 
            || in_array($row->id,$this->_open)
          	|| (JRoute::_( substr($_SERVER['PHP_SELF'],0,-9) . $row->link)) == $_SERVER['REQUEST_URI']
          	|| (JRoute::_( substr($_SERVER['PHP_SELF'],0,-9) . $row->link)) == $HTTP_SERVER_VARS['REQUEST_URI']) {
  							$active = "active ";
  							$active_stat = true;
  			}

				$class = "";
  			$mid = 'tpmenuid'.$menuid.' ';
				$split = explode('||', $row->name, 2);
				if (count($split) == 2) {
	  			$mid .= 'tptopmenuhavesubtitle ';
				}

				$menu_params = new stdClass();
				$menu_params = new JParameter( $row->params );
				$menu_image = $menu_params->def( 'menu_image', -1 );
				$class .= ( ( $menu_image != '-1' ) && $menu_image && (strlen($menu_image)>0) && $this->_menu_images ) ? 'has-image-'.$this->_menu_images_pos.' ' : '';
				$itembg = ( ( $menu_image != '-1' ) && $menu_image && (strlen($menu_image)>0) && $this->_menu_images ) ? ' style="background-image:url(' . JURI::base() . 'images/stories/' . $menu_image . ');"' : '';

  			if($database->loadResult() >= 1 ) {
			 		$this->_output .= '<li class="'.$active.$class.$mid.'parent tptopmenu"'.$itembg.'>' . $this->getLink( $row, 1, $active_stat );
			 	} else {
			 		$this->_output .= '<li class="'.$active.$class.$mid.'tptopmenu"'.$itembg.'>' . $this->getLink( $row, 1, $active_stat );
			 	}
			 	
				if (count($rows2)) {
					$columnnum = (count($rows2) < $this->_columns) ? count($rows2) : $this->_columns;
					$limit = ceil(count($rows2) / $columnnum);
					$columnnum = ( ceil ( count($rows2) / $limit ) < $columnnum) ? ceil ( count($rows2) / $limit ) : $columnnum;
					$this->_output .= '<ul style="width:'.$this->_column_width*$columnnum.'px"><li style="width:'.$this->_column_width*$columnnum.'px"><div style="width:'.$this->_column_width*$columnnum.'px">';
					$x = 0;
					$c = 0;
					foreach($rows2 as $submenu) {
						$x++;
						$c++;
						if($x==1) {
							$this->_output .= '<div class="tpdropcolumn" style="width:'.$this->_column_width.'px">';
						}


						switch ( $submenu->type )
						{
							case 'separator':
								$submenu->link = '#';
							break;
							case 'url':
								if ( ( strpos( $submenu->link, 'index.php?' ) !== false ) && ( strpos( $submenu->link, 'Itemid=' ) === false ) )
								{
									$submenu->link = $submenu->link.'&amp;Itemid='.$submenu->id;
								}
								else
								{
									$submenu->link = $submenu->link;
								}
							break;
							default:
								$router = JSite::getRouter();
								$submenu->link = $router->getMode() == JROUTER_MODE_SEF ? 'index.php?Itemid='.$submenu->id : $submenu->link.'&Itemid='.$submenu->id;
							break;
						}

						$submenu->link = JRoute::_( $submenu->link );
			
						$itemparams = new JParameter( $submenu->params );
						$iSecure = $itemparams->def( 'secure', 0 );
						if ( $submenu->home == 1 )
						{
							$submenu->link = JURI::base();
						}
						else if ( strcasecmp( substr( $submenu->link, 0, 4 ), 'http' ) && ( strpos( $submenu->link, 'index.php?' ) !== false ) )
						{
							$submenu->link = JRoute::_( $submenu->link, true, $iSecure );
						}
						else
						{
							$submenu->link = str_replace( '&', '&amp;', $submenu->link );
						}

				    $mysubmenulink = $submenu->link;
						$this->_output .= "<span>" . $this->getLink( $submenu, 2, $active_stat ) . "</span>";
						if (($x==$limit) OR ($c==count($rows2))) {
							$this->_output .= "</div>";
						}
							
						if($x==$limit) { $x = 0; }
						
					}
						
					$this->_output .= '</div></li></ul>';
				}
				$this->_output .= "</li>";
			}
			$this->_output .= "</ul>";
		}	  	  
    $pre = '<div id="tp-mainnavwrap"><div id="tp-mainnav" class="clearfix">';
    $post = '</div></div>';
           
    if (isset($this->_output)) {
       $this->_output = $pre . $this->_output . $post;
     } 

  	if(!empty($this->_output))
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
	    echo $this->_output;
  	}
  }
}

?>