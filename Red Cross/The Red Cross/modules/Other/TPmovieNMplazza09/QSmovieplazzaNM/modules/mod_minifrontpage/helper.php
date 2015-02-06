<?php

// no direct access

defined('_JEXEC') or die('Restricted access');

if (!class_exists("modMiniFrontPageHelper")) {
class modMiniFrontPageHelper {
	function getList($params){
		global $mainframe;
		$database	=& JFactory::getDBO();
		$user			=& JFactory::getUser();
		$config 	=& JFactory::getConfig();
		$tzoffset	= intval($config->getValue('config.offset'));
		
		// Get Module Parameters
		$sections 		= $params->get( 'sections', '1,2,3' ) ;
		$categories 	= $params->get( 'categories', '1,3,7' ) ;
		$order		    = $params->get( 'order', 1);
		$order_type	  = $params->get( 'order_type', 'asc');
		$period 		 	= intval( $params->get( 'period', 366 ) );
		$show_front		= intval( $params->get( 'show_front', 0 ) );
		
		$limit 			 	= intval( $params->get( 'limit', 200 ) );
		$columns 			= intval( $params->get( 'columns', 1 ) );
		$count 				= intval( $params->get( 'count', 5 ) );
		$num_intro 		= intval( $params->get( 'num_intro', 1) );

		$thumb_embed 	= intval( $params->get( 'thumb_embed', 0 ) );
		$thumb_width 	= intval( $params->get( 'thumb_width', 32 ) );
		$thumb_height = intval( $params->get( 'thumb_height', 32 ) );
		$aspect 			= intval( $params->get( 'aspect', 0 ) );

		$allowed_tags =  "<i><b><strong><br><a>"; 

		$skip = intval( $params->get( 'num_intro_skip', 0 ) );
		
		switch($order) {
			case 0:
				$orderby = "a.created " . $order_type;
				break;
			case 1:
				$orderby  = "a.hits " . $order_type;
				break;
			case 2:
				$orderby  = "a.ordering " . $order_type;
				break;
			default:
				$orderby  = "RAND()";
				break;
		}

		$access 	= !$mainframe->getCfg( 'shownoauth' );
		$nullDate = $database->getNullDate();
		jimport('joomla.utilities.date');
		$date = new JDate();
		$now = $date->toMySQL();

		$whereCatid = '';
		if ($categories) {
			$catids = explode( ',', $categories );
			JArrayHelper::toInteger($catids );
			$whereCatid = "\n AND ( a.catid=" . implode( " OR a.catid=", $catids ) . " )";
		}
		
		$whereSecid = '';
		if ($sections) {
			$secids = explode( ',', $sections );
			JArrayHelper::toInteger( $secids );
			$whereSecid = "\n AND ( a.sectionid=" . implode( " OR a.sectionid=", $secids ) . " )";
		}

		$query = "SELECT a.*, u.name, u.username, cc.image AS image,"
				." CASE WHEN CHAR_LENGTH(a.alias) THEN CONCAT_WS(\":\", a.id, a.alias) ELSE a.id END as slug,"
				." CASE WHEN CHAR_LENGTH(cc.alias) THEN CONCAT_WS(\":\", cc.id, cc.alias) ELSE cc.id END as catslug,'link' as link"
				. "\n FROM #__content AS a"
				. "\n LEFT JOIN #__content_frontpage AS f ON f.content_id = a.id"
				. "\n LEFT JOIN #__users AS u ON u.id = a.created_by"
				. "\n INNER JOIN #__categories AS cc ON cc.id = a.catid"
				. "\n INNER JOIN #__sections AS s ON s.id = a.sectionid"
				. "\n WHERE ( a.state = 1 AND a.sectionid > 0 )"
				. "\n AND ( a.publish_up = " .$database->Quote($nullDate) 
				. " OR a.publish_up <= " . $database->Quote($now) . ")"
				. "\n AND ( a.publish_down = " . $database->Quote($nullDate)
				. " OR a.publish_down >= " . $database->Quote($now) . " )"
				. ( $access ? "\n AND a.access <= " . (int) $user->get('aid') . " AND cc.access <= " 
				. (int) $user->get('aid') . " AND s.access <= " . (int) $user->get('aid') : '' )
				. $whereCatid
				. $whereSecid
				. "\n AND ((TO_DAYS('" . date( 'Y-m-d', time()+$tzoffset*60*60 ) 
				. "') - TO_DAYS(a.created)) <= '" . $period . "')"
				. ( $show_front == '0' ? "\n AND f.content_id IS NULL" : '' )
				. "\n AND s.published = 1"
				. "\n AND cc.published = 1"
				. "\n ORDER BY $orderby"
				. "\n limit $skip," . $count;

		$database->setQuery( $query );
		$rows = $database->loadObjectList();
		//echo $query;
		echo $database->getErrorMsg();
		$pwidth = intval(100/$columns);
		
		$image_path = $params->get( 'image_path', 'images/stories' );

		$rc = count($rows);
		$counter = $num_intro;
		for ( $r = 0; $r < $rc; $r++) {
			if ($thumb_embed && $counter) {	
				/* Regex tool for finding image path on img tag - thx to Jerson Figueiredo */	
				preg_match_all("/<img[^>]*>/Ui", $rows[$r]->introtext . $rows[$r]->fulltext, $txtimg);
				if (!empty($txtimg[0])) {
					foreach ($txtimg[0] as $txtimgel) {
						$rows[$r]->introtext = str_replace($txtimgel,"",$rows[$r]->introtext);
						if (preg_match_all("#http#",$txtimgel,$txtimelsr,PREG_PATTERN_ORDER) > 0) {
							preg_match_all("#src=\"([\-\/\_A-Za-z0-9\.\:]+)\"#",$txtimgel,$txtimgelsr);
							if (!empty($rows[$r]->images)) {
								$rows[$r]->images = $txtimgelsr[1][0] . "\n" . $rows[$r]->images;
							} else {
								$rows[$r]->images = $txtimgelsr[1][0];
							}
						} elseif ( strstr($txtimgel, $image_path) ) {
							if (strstr($txtimgel, 'src="/')) {
								preg_match_all("#src=\"\/" . addslashes($image_path) . "\/([\:\-\/\_A-Za-z0-9\.]+)\"#",$txtimgel,$txtimgelsr);
							} else {
								preg_match_all("#src=\"" . addslashes($image_path) . "\/([\:\-\/\_A-Za-z0-9\.]+)\"#",$txtimgel,$txtimgelsr);
							}
				
							if (!empty($rows[$r]->images)) {
								$rows[$r]->images = $txtimgelsr[1][0] . "\n" . $rows[$r]->images;
							} else {
								$rows[$r]->images = $txtimgelsr[1][0];
							}
						} 
					}
				}
			} // end of thumbnail processing

			$rows[$r]->introtext= preg_replace("/{[^}]*}/","",$rows[$r]->introtext);
			
			$needles = array(
				'article'  => (int) $rows[$r]->id,
				'category' => (int) $rows[$r]->catid,
				'section'  => (int) $rows[$r]->sectionid,
			);
			
			$rows[$r]->link = ContentHelperRoute::getArticleRoute($rows[$r]->slug, $rows[$r]->catslug,$rows[$r]->sectionid);
			
  		if($limit > 0) {
      	$rows[$r]->introtext = fptn_limittext($rows[$r]->introtext,$allowed_tags,$limit);
			}
			$counter--;
		}

		return $rows;
		
	}//end function

}//end of class
}

//Function 
//added by remuz, edited by Jerry Wijaya
if (!function_exists("fptn_thumb_size")) {
function fptn_thumb_size($file, $wdth, $hgth, &$image, &$xtra, $class, $aspect) {
	$pos = stripos($file, 'http://');

	if($class!='') $xtra .= ' class="'.$class.'"';

	if($file ==""){
		$file = MOD_MINIFRONTPAGE_DEFAULT_IMAGE;
		$path = MOD_MINIFRONTPAGE_DEFAULT_BASE;
		$site = MOD_MINIFRONTPAGE_DEFAULT_BASEURL;
	}else{
		$path = MOD_MINIFRONTPAGE_THUMB_BASE;
		$site = MOD_MINIFRONTPAGE_THUMB_BASEURL;
	}
		
	// Find the extension of the file
	if($pos === false) {
		$ext = substr(strrchr(basename(JPATH_SITE.$file), '.'), 1);
	} else {
		$ext = substr(strrchr(basename($file), '.'), 1);
	}

	$thumb = str_replace('.'.$ext, '_thumb.'.$ext, $file);
	$thumb = explode("/", $thumb);
	$thumb = $thumb[count($thumb)-1];
	$thumb = explode("\\", $thumb);
	$thumb = $thumb[count($thumb)-1];

	$image = '';

	$image_path = $path.DS.$thumb;
	$image_site = $site."/".$thumb;

	$found = false;
	if (file_exists($image_path)){
		$size = '';
		$wx = $hy = 0;
		if (function_exists( 'getimagesize' )){
			$size = @getimagesize( $image_path );
			if (is_array( $size )){
				$wx = $size[0];
				$hy = $size[1];
				$size = 'width="'.$wx.'" height="'.$hy.'"';
			}
	  }

		$found = true;
		$size = 'width="'.$wx.'" height="'.$hy.'"';
		$image= '<img src="'.$image_site.'" '.$size.$xtra.' />';
	}
	
	if (!$found){
		$size = '';
		$wx = $hy = 0;
		if($pos === false) {
			if(file_exists(MOD_MINIFRONTPAGE_BASE.DS.$file)) {
				$sFile = MOD_MINIFRONTPAGE_BASE.DS.$file;
			} else {
				$sFile = MOD_MINIFRONTPAGE_DEFAULT_BASE.DS.$file;
			}
		} else {
			if(file_exists($file)) {
				$sFile = $file;
			} else {
				$sFile = MOD_MINIFRONTPAGE_DEFAULT_BASE.DS.MOD_MINIFRONTPAGE_DEFAULT_IMAGE;
			}
		}
		
		$size = @getimagesize( $sFile );
		
		if (is_array( $size )){
			$wx = $size[0];
			$hy = $size[1];
		}

		fptn_calcsize($wx, $hy, $wdth, $hgth, $aspect);

		switch ($ext){
			case 'jpg':
			case 'jpeg':
			case 'png':
				if($pos === false) {
					fptn_thumbit($sFile,$image_path,$ext,$wdth,$hgth);
				} else {
					fptn_thumbit($file,$image_path,$ext,$wdth,$hgth);
				}
				$size = 'width="'.$wdth.'" height="'.$hgth.'"';
				$image= '<img  src="'.$image_site.'" '.$size.$xtra.' />';
				break;
			case 'gif':
				if (function_exists("imagegif")) {
					if($pos === false) {
						fptn_thumbit($sFile,$image_path,$ext,$wdth,$hgth);
					} else {
						fptn_thumbit($file,$image_path,$ext,$wdth,$hgth);
					}
					$size = 'width="'.$wdth.'" height="'.$hgth.'"';
					$image= '<img src="'.$image_site.'" '.$size.$xtra.' />';
					break;
        }
			default:
				$size = 'width="'.$wdth.'" height="'.$hgth.'"';
				if($pos === false) {
					$image= '<img src="'.MOD_MINIFRONTPAGE_BASEURL."/".$file.'" '.$size.$xtra.' />';
				} else {
					$image= '<img src="'.$file.'" '.$size.$xtra.' />';
				}
				break;
		}
	}
}
}

if (!function_exists("fptn_thumbIt")) {
function fptn_thumbIt ($file, $thumb, $ext, &$new_width, &$new_height) {
	$img_info = getimagesize ( $file );
	$orig_width = $img_info[0];
	$orig_height = $img_info[1];
		
	if($orig_width<$new_width || $orig_height<$new_height){
		$new_width = $orig_width;
		$new_height = $orig_height;
	}
		
	switch ($ext) {
		case 'jpg':
		case 'jpeg':
			$im  = imagecreatefromjpeg($file);
			$tim = imagecreatetruecolor ($new_width, $new_height);
			fptn_ImageCopyResampleBicubic($tim, $im, 0,0,0,0, $new_width, $new_height, $orig_width, $orig_height);
			imagedestroy($im);
	
			imagejpeg($tim, $thumb, 75);
			imagedestroy($tim);
			break;

		case 'png':
			$im  = imagecreatefrompng($file);
			$tim = imagecreatetruecolor ($new_width, $new_height);
			fptn_ImageCopyResampleBicubic($tim, $im, 0,0,0,0, $new_width, $new_height, $orig_width, $orig_height);
			imagedestroy($im);
			imagepng($tim, $thumb, 9);
			imagedestroy($tim);
			break;

		case 'gif':
			if (function_exists("imagegif")) {
				$im  = imagecreatefromgif($file);
				$tim = imagecreatetruecolor ($new_width, $new_height);
				fptn_ImageCopyResampleBicubic($tim, $im, 0,0,0,0, $new_width, $new_height, $orig_width, $orig_height);
				imagedestroy($im);
				imagegif($tim, $thumb, 75);
				imagedestroy($tim);
    	}
			break;

			default:
				break;
	}
}
}

if (!function_exists("fptn_ImageCopyResampleBicubic")) {
function fptn_ImageCopyResampleBicubic (&$dst_img, &$src_img, $dst_x, $dst_y, $src_x, $src_y, $dst_w, $dst_h, $src_w, $src_h) {
	if ($dst_w==$src_w && $dst_h==$src_h) {
		$dst_img = $src_img;
		return;
	}

	ImagePaletteCopy ($dst_img, $src_img);
	$rX = $src_w / $dst_w;
	$rY = $src_h / $dst_h;
	$w = 0;
	for ($y = $dst_y; $y < $dst_h; $y++) {
		$ow = $w; $w = round(($y + 1) * $rY);
		$t = 0;
		for ($x = $dst_x; $x < $dst_w; $x++) {
			$r = $g = $b = 0; $a = 0;
			$ot = $t; $t = round(($x + 1) * $rX);
			for ($u = 0; $u < ($w - $ow); $u++) {
				for ($p = 0; $p < ($t - $ot); $p++) {
					$c = ImageColorsForIndex ($src_img, ImageColorAt ($src_img, $ot + $p, $ow + $u));
					$r += $c['red'];
   				$g += $c['green'];
   				$b += $c['blue'];
   				$a++;
   			}
			}
			
			if(!$a) $a = 1; {
				ImageSetPixel ($dst_img, $x, $y, ImageColorClosest ($dst_img, $r / $a, $g / $a, $b / $a));
			}
		}
	}
}
}

if (!function_exists("fptn_calcsize")) {
function fptn_calcsize($srcx, $srcy, &$forcedwidth, &$forcedheight, $aspect) {
	if ($forcedwidth > $srcx)  $forcedwidth = $srcx;
	if ($forcedheight > $srcy) $forcedheight = $srcy;
	if ( $forcedwidth <=0 && $forcedheight > 0) {
		$forcedwidth = round(($forcedheight * $srcx) / $srcy);
	} else if ( $forcedheight <=0 && $forcedwidth > 0) {
		$forcedheight = round(($forcedwidth * $srcy) / $srcx);
	} else if ( $forcedwidth/$srcx>1 && $forcedheight/$srcy>1) {
		//May not make an image larger!
		$forcedwidth = $srcx;
		$forcedheight = $srcy;
	}	else if ( $forcedwidth/$srcx<1 && $aspect) {
		//$forcedheight = round(($forcedheight * $forcedwidth) /$srcx);
		$forcedheight = round( ($srcy/$srcx) * $forcedwidth );
		$forcedwidth = $forcedwidth;
	}
}
}

//function added by Jerry Wijaya
if (!function_exists("fptn_limittext")) {
function fptn_limittext($text,$allowed_tags,$limit) {
	$strip = strip_tags($text);
	$endText = (strlen($strip) > $limit) ? "&nbsp;[&nbsp;...&nbsp;]" : ""; 
	$strip = substr($strip, 0, $limit);
	$striptag = strip_tags($text, $allowed_tags);
	$lentag = strlen($striptag);
	
	$display = "";
	
	$x = 0;
	$ignore = true;
	for($n = 0; $n < $limit; $n++) {
		for($m = $x; $m < $lentag; $m++) {
			$x++;
			if($striptag[$m] == "<") {
				$ignore = false;
			} else if($striptag[$m] == ">") {
				$ignore = true;
			}
			if($ignore == true) {
				if($strip[$n] != $striptag[$m]) {
					$display .= $striptag[$m];
				} else {
					$display .= $strip[$n];
					break;
				}
			} else {
				$display .= $striptag[$m];
			}
		}
	}
	return fix_tags ('<p>'.$display.$endText.'</p>');}
}

//added by remush
//this fuction to show Thumbnail image
if (!function_exists("showThumb")) {
function showThumb($images,$image,$params,$link){
	$thumb_embed = intval( $params->get( 'thumb_embed', 0 ) );
	$thumb_width = intval( $params->get( 'thumb_width', 32 ) );
	$thumb_height = intval( $params->get( 'thumb_height', 32 ) );
	$aspect = intval( $params->get( 'aspect', 0 ) );
	// show thumbnail image	
	if ($thumb_embed == 1) {
		?><a href="<?php echo $link ?>"><?php
		if (!empty($images)) {
			$img = strtok($images,"|\r\n");
			$class="";
			$extra = ' align="left"  alt="article thumbnail" ';
			fptn_thumb_size($img, $thumb_width, $thumb_height, $image, $extra, $class, $aspect);
			echo  $image;
		} else if ($image !="") {
			$img = strtok($image,"|\r\n");
			$class="";
			$extra = ' align="left"  alt="article thumbnail" ';
			fptn_thumb_size($img, $thumb_width, $thumb_height, $image, $extra, $class, $aspect);
			echo  $image;
		} else {			
			$img = "";	
			$class="";
			$extra = ' align="left"  alt="article thumbnail" ';
			fptn_thumb_size($img, $thumb_width, $thumb_height, $image, $extra, $class, $aspect);
			echo  $image;					
		}
		?></a><?php				
	}
}
}

//added by Jerry Wijaya
//function taken from https://svn.typo3.org/TYPO3v4/Extensions/pdf_generator2/trunk/html2ps/xhtml.utils.inc.php
if(!function_exists('fix_tags')) {
function fix_tags($html) {
  $result = "";
  $tag_stack = array();

  // these corrections can simplify the regexp used to parse tags
  // remove whitespaces before '/' and between '/' and '>' in autoclosing tags
  $html = preg_replace("#\s*/\s*>#is","/>",$html);
  // remove whitespaces between '<', '/' and first tag letter in closing tags
  $html = preg_replace("#<\s*/\s*#is","</",$html);
  // remove whitespaces between '<' and first tag letter 
  $html = preg_replace("#<\s+#is","<",$html);

  while (preg_match("#(.*?)(<([a-z\d]+)[^>]*/>|<([a-z\d]+)[^>]*(?<!/)>|</([a-z\d]+)[^>]*>)#is",$html,$matches)) {
    $result .= $matches[1];
    $html = substr($html, strlen($matches[0]));

    // Closing tag 
    if (isset($matches[5])) { 
      $tag = $matches[5];

      if ($tag == $tag_stack[0]) {
        // Matched the last opening tag (normal state) 
        // Just pop opening tag from the stack
        array_shift($tag_stack);
        $result .= $matches[2];
      } elseif (array_search($tag, $tag_stack)) { 
        // We'll never should close 'table' tag such way, so let's check if any 'tables' found on the stack
        $no_critical_tags = !array_search('table',$tag_stack);
        if (!$no_critical_tags) {
          $no_critical_tags = (array_search('table',$tag_stack) >= array_search($tag, $tag_stack));
        };

        if ($no_critical_tags) {
          // Corresponding opening tag exist on the stack (somewhere deep)
          // Note that we can forget about 0 value returned by array_search, becaus it is handled by previous 'if'
          
          // Insert a set of closing tags for all non-matching tags
          $i = 0;
          while ($tag_stack[$i] != $tag) {
            $result .= "</{$tag_stack[$i]}> ";
            $i++;
          }; 
          
          // close current tag
          $result .= "</{$tag_stack[$i]}> ";
          // remove it from the stack
          array_splice($tag_stack, $i, 1);
          // if this tag is not "critical", reopen "run-off" tags
          $no_reopen_tags = array("tr","td","table","marquee","body","html");
          if (array_search($tag, $no_reopen_tags) === false) {
            while ($i > 0) {
              $i--;
              $result .= "<{$tag_stack[$i]}> ";
            }; 
          } else {
            array_splice($tag_stack, 0, $i);
          };
        };
      } else {
        // No such tag found on the stack, just remove it (do nothing in out case, as we have to explicitly 
        // add things to result
      };
    } elseif (isset($matches[4])) {
      // Opening tag
      $tag = $matches[4];
      array_unshift($tag_stack, $tag);
      $result .= $matches[2];
    } else {
      // Autoclosing tag; do nothing specific
      $result .= $matches[2];
    };
  };

  // Close all tags left
  while (count($tag_stack) > 0) {
    $tag = array_shift($tag_stack);
    $result .= "</".$tag.">";
  }	

  return $result;
}
}

?>