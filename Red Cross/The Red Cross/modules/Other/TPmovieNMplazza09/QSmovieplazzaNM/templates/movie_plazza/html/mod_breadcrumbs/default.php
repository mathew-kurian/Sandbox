<?php
	defined('_JEXEC') or die('Restricted access');
	if($count > 0 && $list[0]->name != ""){
		$menu = &JSite::getMenu();
		$menuactive	= $menu->getActive();
		$pathw = '<span class="breadcrumbs pathway">';
			for($i = 0; $i < $count; $i ++){
				$pos = strpos($list[$i]->name, "||");
				if($pos === false){
					$name	= $list[$i]->name;
				}else{
					$name	= substr($list[$i]->name,0,strpos($list[$i]->name,'||'));
				}
				$name = explode("||", $name);
				$name = $name[0];
				if($i < $count -1){
					if(!empty($list[$i]->link)){
						$pathw .= '<a href="'.$list[$i]->link.'" class="pathway">'.$name.'</a>';
					}else{
						if(strlen($name) > 100){
							$pathw .= substr($name, 0, 100) . " ...";
						}else{
							$pathw .= $name;
						}
					}
					$pathw .= ' '.$separator.' ';
				}else if ($params->get('showLast', 1)){
					if(strlen($name) > 100){
						$pathw .= substr($name, 0, 100) . " ...";
					}else{
						$pathw .= $name;
					}
				}
			};
			if($count == 1)
			{
				if($menu->getActive() == $menu->getDefault()){ $pathw = "<span>"; } //remove pathway in frontpage home page
			}
		$pathw .= "</span>";
		echo $pathw;
	}
?>