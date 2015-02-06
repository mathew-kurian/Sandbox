<?php

defined('_JEXEC') or die('Restricted access'); 
ini_set('arg_separator.output','&amp;');

class TPMenu {
  var $_menutype;
  var $_openall;
  var $_start;
  var $_end;
  var $_open;
  var $_menu_name;
  var $_output;
  var $_indents;
	var $_menu_images;
	var $_menu_images_pos;
  var $_show_menu_text;
	var $_css;
	var $_js;
	  
  function displayMenu() {
    $this->_open = array();
    $this->_indents = array("<ul>", "<li>" , "</li>", "</ul>");
    $this->_menu_name = '';

		$this->_openall = 1;
		$this->_start = 1;
		$this->_end = 11;
    
   	global  $mainframe,$Itemid;
   
    
		$database      = & JFactory::getDBO();
    $my 	       	 = & JFactory::getUser();
    $cur_template  = $mainframe->getTemplate(); 
		$contentConfig = &JComponentHelper::getParams( 'com_content' );
		$noauth		   	 = $contentConfig->get('shownoauth');


   	$hilightid = null;
   	$startid = 0;
   	if ($noauth) {
      $database->setQuery("SELECT m.*, count(p.parent) as cnt" .
      "\nFROM #__menu AS m" .
      "\nLEFT JOIN #__menu AS p ON p.parent = m.id" .
      "\nWHERE m.menutype='$this->_menutype' AND m.published='1'" .
      "\nGROUP BY m.id ORDER BY m.parent, m.ordering ");
    } else {
      $database->setQuery("SELECT m.*, sum(case when p.published=1 then 1 else 0 end) as cnt" .
      "\nFROM #__menu AS m" .
      "\nLEFT JOIN #__menu AS p ON p.parent = m.id" .
      "\nWHERE m.menutype='$this->_menutype' AND m.published='1' AND m.access <= '$my->gid'" .
      "\nGROUP BY m.id ORDER BY m.parent, m.ordering ");
    }

   	$rows = $database->loadObjectList( 'id' );
   	echo $database->getErrorMsg();
  	
    // fix weird problem with itemid undefined
   	if ($Itemid > 999999) { 
   	  $current = current($rows);
   	  $Itemid = $current->id; 
   	}
   	
   	//work out if this should be highlighted
   	$sql = "SELECT m.* FROM #__menu AS m"
   	. "\nWHERE menutype='". $this->_menutype ."' AND m.published='1'"; 
   	$database->setQuery( $sql );
   	$subrows = $database->loadObjectList( 'id' );
   	$maxrecurse = 5;
   	$parentid = $Itemid;

   	//this makes sure toplevel stays hilighted when submenu active
   	while ($maxrecurse-- > 0) {
   		$parentid = $this->getTheParentRow($subrows, $parentid);
   		if (isset($parentid) && $parentid >= 0 && $subrows[$parentid]) {
   			$hilightid = $parentid;
   		} else {
   			break;	
   		}
   	}	
    // establish the hierarchy of the menu
   	$children = array();

    // first pass - collect children
    foreach ($rows as $v ) {
  		$pt = $v->parent;
   		$list = @$children[$pt] ? $children[$pt] : array();
   		array_push( $list, $v );

      $children[$pt] = $list;
    }

    // second pass - collect 'open' menus
  	$this->_open = array( $Itemid );
   	$count = 20; // maximum levels - to prevent runaway loop
   	$id = $Itemid;
   	while (--$count) {
   		if (isset($rows[$id]) && $rows[$id]->parent > 0) {
   			$id = $rows[$id]->parent;
   			$this->_open[] = $id;
   		} else {
   			break;
   		}
   	}
   	
    //get the name of the parent node
 	  $parentopen = array_reverse($this->_open);
 	  if (array_key_exists($parentopen[0],$rows)) 
 	    $this->_menu_name = $rows[$parentopen[0]]->name;
   	
	  if ($this->_start > 1) $startid = $id;
	  $this->_output = $this->recurseListMenu( $startid, $this->_start, $children, $hilightid );
	  	  
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
  
  function recurseListMenu( $id, $level, &$children, $highlight ) {
  	global $Itemid;
  	global $HTTP_SERVER_VARS;

  	$output = "";
  	$ulstyle = "";


  	if (@$children[$id] && $level < $this->_end) {
  		$n = min( $level, count( $this->_indents )-1 );

  		if($this->_start==$level) {
  		  $ulstyle .= ' class="clearfix" ';
  		} 
  		if($level==1) {
  		  $ulstyle .= ' id="tp-cssmenu"'; 
  		}
  		
  		$output .= "<ul" . $ulstyle . ">";
			$menuid = 0;
  		foreach ($children[$id] as $row) {
				$menuid++;
  		  switch ($row->type) {
       		case 'separator':
       		// do nothing
       		$row->link = "seperator";

       		break;

       		case 'url':
       		if ( eregi( 'index.php\?', $row->link ) ) {
      				if ( !eregi( 'Itemid=', $row->link ) ) {
      					$row->link .= '&Itemid='. $row->id;
      				}
      			}
       		break;

       		default:
       			$row->link .= "&Itemid=$row->id";

       		break;
       	}
				
				if ($row->home == 1) $row->link = JURI::base();
				$row->link = JRoute::_( $row->link );

        $class = "";
        $current_itemid =JRequest::getVar( 'Itemid', 0, '', 'int' );
				$active_stat = false;
		if ($row->link != "seperator" 
  					&& $current_itemid == $row->id 
            || in_array($row->id,$this->_open)
  					|| $row->id == $highlight
          	|| (JRoute::_( substr($_SERVER['PHP_SELF'],0,-9) . $row->link)) == $_SERVER['REQUEST_URI']
          	|| (JRoute::_( substr($_SERVER['PHP_SELF'],0,-9) . $row->link)) == $HTTP_SERVER_VARS['REQUEST_URI']) {
  							$class .= "active ";
  							$active_stat = true;
  			}
  			if ($row->cnt > 0) {
  				$class .= "parent ";
  			}
		  	if($level == 1) {
	  			$class .= 'tpmenuid'.$menuid.' ';
					$split = explode('||', $row->name, 2);
					if (count($split) == 2) {
		  			$class .= 'tptopmenuhavesubtitle ';
					}
	  			$class .= 'tptopmenu ';
			  }

				$menu_params = new stdClass();
				$menu_params = new JParameter( $row->params );
				$menu_image = $menu_params->def( 'menu_image', -1 );
				$class .= ( ( $menu_image != '-1' ) && $menu_image && (strlen($menu_image)>0) && $this->_menu_images ) ? ' has-image-'.$this->_menu_images_pos : '';
				$itembg = ( ( $menu_image != '-1' ) && $menu_image && (strlen($menu_image)>0) && $this->_menu_images ) ? ' style="background-image:url(' . JURI::base() . 'images/stories/' . $menu_image . ');"' : '';

  	    $output .= '<li class="' . trim($class) . '"'.$itembg.'>' . "\n";

        $output .= $this->getLink( $row, $level, $active_stat );
        if ( $this->_openall || in_array( $row->id, $this->_open )) {
  			  $output .= $this->recurseListMenu( $row->id, $level+1, $children, "");
  		  }
        $output .= $this->_indents[2];

      }
  		$output .= "\n".$this->_indents[3];

  		return $output;

  	}
  }

  function getTheParentRow($rows, $id) {
		if (isset($rows[$id]) && $rows[$id]) {
  		if($rows[$id]->parent > 0) {
  			return $rows[$id]->parent;
  		}	
  	}
 		return -1;
	}

  function getLink( $mitem, $level, $active_stat) {
  	global $Itemid;
  	$txt = '';
  	$topdaddy = 'top';

  	preg_match_all( "/({)(.*)(})/", $mitem->name, $matches, PREG_SET_ORDER );
		$mitemparams = ( !empty( $matches[0][2] ) ) ? $matches[0][2] : null;
		$mitem->name = str_replace( "{".$mitemparams."}", "", $mitem->name );
  	
  	$class = ($mitem->cnt > 0) ? ' class="haschild" ' : ' ';
  	
  	$mitem->link = str_replace( '&amp;', '&', $mitem->link );
  	$mitem->name = stripslashes( JFilterOutput::ampReplace($mitem->name));
  	
  	if (strcasecmp(substr($mitem->link,0,4),"http")) {
  		if($mitem->link == 'index.php?option=com_content&amp;view=frontpage&amp;Itemid=1') {
  			$mitem->link = JURI::base();
  		} else {
	  		$mitem->link = JRoute::_($mitem->link);
	  	}
  	} else {
  		if($mitem->link == 'index.php?option=com_content&amp;view=frontpage&amp;Itemid=1') {
  			$mitem->link = JURI::base();
  		}
  	}

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
  		default:	// formerly case 2
  		  $txt = "<a".$class."href=\"$mitem->link\">".$this->show_image($mitem, $level, $active_stat)."</a>";
	      break;
  	}
    return $txt;
  }

	function show_image($mitem, $level, $active_stat){
		global $Itemid;
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
		
		if (!$this->_show_menu_text)
		{
			$subtitle = null;
			$menu_params = new stdClass();
			$menu_params = new JParameter( $mitem->params );
			$menu_image = $menu_params->def( 'menu_image', -1 );
			$mitem->namedisplay = ($menu_image != -1) ? "&nbsp;" : $mitem->namedisplay;
		}

		$class = ($level == 1) ? 'tpparenttitle' : 'tpchildtitle';
		$txt = '<span class="'.$class.'">' . $mitem->namedisplay . '</span>' . $subtitle;
		return $txt;
	}
}

?>