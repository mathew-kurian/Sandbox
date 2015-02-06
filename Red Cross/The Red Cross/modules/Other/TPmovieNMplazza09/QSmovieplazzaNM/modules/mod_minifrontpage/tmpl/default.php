
<?php 
// no direct access 
defined('_JEXEC') or die('Restricted access'); 

$database =& JFactory::getDBO(); 
$pwidth = intval(100/$columns); 
$col = 0; 
  
$ini_intro = 1; 
?><table width="100%" class="minifp"><?php 

foreach ( $rows as $row ) { 
// ----------- add category title ------------ 
$link = JRoute::_($row->link); 
if ($cat_title) { 
	$query = "SELECT title FROM #__categories WHERE id =". $row->catid; 
	$database->setQuery( $query ); 
	$categ = $database->loadResult(); 
	$catlink   = JRoute::_(ContentHelperRoute::getCategoryRoute($row->catslug, $row->sectionid));
}
 
if ($show_title) { 
	$title = '<a href="'. $link .'">'. $row->title . '</a>'; 
}	else {
	$title = '<a href="'. $link .'">'. $row->title . '</a>'; 
}
 
if ( $num_intro ) { 
	if ($col==0) { ?><tr><?php }?> 
		<td valign="top" width="<?php echo $pwidth; ?>%" class="minifp"><?php 
		if ($loadorder == 1) {
			showThumb($row->images,$row->image,$params,$link); 
		} 
		if ($cat_title) {
			echo '<span class="'.$class_categoria.'">';
			if($cat_title_link) {
				echo '<a href="'.$catlink.'">';
			}
			echo $categ;
			if($cat_title_link) {
				echo '</a>';
			}
			echo '</span>';
		}
		
		if ($show_title) { 
			if ($title_link == 1) {
				echo '<span class="'.$class_introtitle.'">'.$title.'</span>';
			}	else { 
				echo '<span class="'.$class_introtitle.'">'. $row->title . '</span>';
			}

			echo "<br class=\"minifp-seperator\" />"; 
		} 

		if ($show_date) { 
			echo '<span class="'.$class_date.'">'; 
			switch($params->get( 'date_type' )) {
				case 1:
					$date = ($row->modified != "0000-00-00 00:00") ? $row->modified : $row->created;
					break;
				case 2:
					$date = $row->publish_up;
					break;
				case 0:
				default:
					$date = $row->created;
					break;
			}
			echo JHTML::_('date', $date, $params->get( 'date_format' ), $mainframe->getCfg('offset')); 
			echo '</span>'; 
		} 
			if($show_author_type) {
			$author = htmlspecialchars( $row->username );
		} else {
			if ( $row->created_by_alias ) {
				$author = $row->created_by_alias;
			} else {
				$author = htmlspecialchars( $row->name );
			} 
		}

		if ($show_date && $show_author) { 
			echo $sep; 
		} 

		if ($show_author==1) { 
			echo '<span class="'.$class_author.'">'.$author.'</span>'; 
		} 
		echo '<br class="minifp-seperator" />'; 
		
		if ($loadorder == 0) { 
			// repeat code I hate this --- just because I can't create a new function -- damned 
			if ($thumb_embed == 1) { 
				?><a href="<?php echo $link; ?>"><?php 
				if (!empty($row->images)) { 
					$img = strtok($row->images,"|\r\n"); 
					$class=""; 
					$extra = ' align="left" alt="article thumbnail" ';  
					fptn_thumb_size($img, $thumb_width, $thumb_height, $image, $extra, $class, $aspect); 
					echo $image; 
				} else if ($row->image !="") {
					$img = strtok($row->images,"|\r\n"); 
					$class=""; 
					$extra = ' align="left" alt="article thumbnail" ';  
					fptn_thumb_size($img, $thumb_width, $thumb_height, $image, $extra, $class, $aspect); 
					echo $image; 
				} else {
					if($thumb_embed_default) {
						$img = ""; 
						$class=""; 
						$extra = ' align="left" alt="article thumbnail" '; 
						fptn_thumb_size($img, $thumb_width, $thumb_height, $image, $extra, $class, $aspect); 
						echo $image;
					}
				}
			}
			?></a><?php 
		}// end if ($loadorder == 0) 
			if ( ($limit > 1) ) { 
			echo $row->introtext; 
			?><br class="minifp-seperator" /><?php 
		} else { 
			?><div style="clear: both;"></div><?php 
		} 
		if ($fulllink !="") { 
			?> 
			<div class="minifp-full-link-wrp"><a class="minifp-full-link" href="<?php echo $link; ?>"><?php echo $fulllink; ?></a></div><?php 
		} 
		?></td><?php 
		
		$num_intro = $num_intro - 1; 

		if ( $num_intro == 0 ) { 
			$ini_intro = 0; 
			if ( ( ( ($col + 1) % $columns ) == 0 ) && $anotherlink ) echo "</tr><tr>"; 
			if ( ( ( ($col + 1) % $columns ) == 0 ) && !$anotherlink ) echo "</tr>"; 
			if ($anotherlink) { 
				echo '<td valign="top" colspan="'.$columns.'">'; 
				if ($header_title_links != "") echo "<span class='".$class_another_links."'>".$header_title_links."</span>"; 
				else echo "<br class=\"minifp-seperator\" />"; 
				echo '<ul class="minifp">'; 
			}
		} 
	} else if ( ($num_intro==0) && ($ini_intro == 1) ) {
		if ( ( ($col + 1) % $columns ) == 0 ) echo "</tr><tr>"; 
		echo '<td valign="top" colspan="'.$columns.'">'; 
		if ($header_title_links != "") echo "<span class='".$class_another_links."'>".$header_title_links."</span>"; 
		else echo "<br class=\"minifp-seperator\"/>"; 
		echo '<ul class="minifp">'; 
		echo "<li class='minifp'>". $title ."</li>"; 
		$ini_intro = 0; 
		continue; 
	} else { 
		echo "<li class='minifp'>". $title ."</li>"; 
	} 
		$col = ($col + 1) % $columns; 
	if ($col == 0 && $num_intro) echo "</tr>"; 
} 

if ( ($num_intro==0) && $anotherlink) {
	?></ul></td></tr><?php
} 

echo '</table>';

?>