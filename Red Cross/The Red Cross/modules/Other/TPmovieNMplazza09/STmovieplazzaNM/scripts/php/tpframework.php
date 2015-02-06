<?php 
/* 
=================================================
# Filename : template_config.php
# Description : TemplatePlazza Template Framework
# Author : TemplatePlazza
# Author Url : http://www.templateplazza.com
# Copyright (C) 2009 TemplatePlazza.com
# All rights reserved.
# This file may not be redistributed in whole or significant part
=================================================
*/

defined('_JEXEC') or die('Restricted access');

class tpFramework
{
	var $fw = null;
	var $tp = null;
	var $template_dir = null;
	var $template_url = null;
	
	function tpFramework($tp = null, $fw = null)
	{
		if(!empty($tp))
		{
			$this->tp = $tp;
		}

		if(!empty($fw))
		{
			$this->fw = $fw;
			$this->template_dir = JPATH_BASE . DS . 'templates' .  DS . $this->fw->template;
			$this->template_url = JURI::base() . 'templates/' . $this->fw->template;
		}
	}
	
	function skeletons()
	{
		$tp_skeleton = $this->fw->params->get('tp_skeleton');
		$tp_mobilemode = $this->fw->params->get('tp_mobilemode');
		$loadSkeleton = true;
		if($tp_mobilemode)
		{
			$isMobile = $this->mobileCheck();
			if($isMobile)
			{
				$this->mobileLoad();
				$loadSkeleton = false;
			}
		}

		if($loadSkeleton)
		{
			$skeletonFile = $this->template_dir .  DS . 'skeletons' . DS . $tp_skeleton . '.php';
			$skeletonids = explode(",", str_replace( " ", "", $this->fw->params->get('tp_skeletonitemid') ) );
			if(count($skeletonids))
			{
				$si = array();
				foreach($skeletonids as $sids)
				{
					$s = explode("=", $sids);
					if(!empty($s[0]) && !empty($s[1]))
					{
						$si[str_replace("itemid", "", strtolower($s[0]))] = $s[1];
					}
				}
				
				$menus = &JSite::getMenu();
				$menu  = $menus->getActive();
				$Itemid = (!empty($menu->id)) ? $menu->id : null;
				if(empty($Itemid))
				{
					$Itemid = JRequest::getInt( 'Itemid' );
					if(empty($Itemid))
					{
						$Itemid = JRequest::getInt( 'amp;Itemid' );
					}
				}

				if(!empty($si[$Itemid]))
				{
					$skeletonFileCustom = $this->template_dir .  DS . 'skeletons' . DS . $si[$Itemid] . '.php';
					if (file_exists(  $skeletonFileCustom ))
					{
						$skeletonFile = $skeletonFileCustom;
					}
				}
			}
			$skeletonDefault = $this->template_dir .  DS . 'skeletons' . DS . 'skeletondefault.php'; 
			$skeletonFile = (file_exists(  $skeletonFile )) ? $skeletonFile : $skeletonDefault;
			if (file_exists(  $skeletonFile ))
			{
				$tp = $this->tp;
				include( $skeletonFile );
			}
		}
	}
	
	function checkaccordion($position)
	{
		if($this->fw->params->get('tp_accordionmodpos') == "noaccordion") return false;
		return ($position == $this->fw->params->get('tp_accordionmodpos'));
	}
	
	function tpmenu()
	{
		if(!defined('LOAD_TPMENU'))
		{
			define('LOAD_TPMENU', 1);
			
			$this->template_dir = JPATH_BASE . DS . 'templates' .  DS . $this->fw->template;
			$this->template_url = JURI::base() . 'templates/' . $this->fw->template;

			$menustyle = $this->fw->params->get('tp_menustyle');
			if( $menustyle == 'none' )
			{
				return false;
			}
			
			$menuFile = $this->template_dir.DS.'scripts'.DS.'php'.DS.'menu'.DS.$menustyle.'.php';
			include( $menuFile );

			$tpmenu = new TPMenu();
			$file = $this->template_dir.DS.'css'.DS.'menu'.DS.$menustyle.'.css';
			if (is_file ($file)) $tpmenu->_css = $this->template_url.'/css/menu/'.$menustyle.'.css';

			$tpmenu->_menutype = $this->fw->params->get('tp_tpmenutype');
			$tpmenu->_menu_images = $this->fw->params->get('tp_tpmenu_show_image');
			$tpmenu->_menu_images_pos = $this->fw->params->get('tp_tpmenu_show_image_position');
			$tpmenu->_show_menu_text = $this->fw->params->get('tp_tpmenu_show_menu_text');
			$tpmenu->_column_width = $this->fw->params->get('tp_dropcolumnwidth');
			$tpmenu->_newline = "\n";
			switch( $menustyle )
			{
				case 'dolphin':
					$file = $this->template_dir.DS.'scripts'.DS.'js'.DS.'menu'.DS.$menustyle.'.js';
					if (is_file ($file)) $tpmenu->_js = $this->template_url.'/scripts/js/menu/'.$menustyle.'.js';
				break;
				case 'dropcolumn':
					$tpmenu->_columns = $this->fw->params->get('tp_dropcolumnnum');
				default:
					$animated = $this->fw->params->get('tp_tpmenu_animated');
					if( $animated )
					{
						$file = $this->template_dir.DS.'scripts'.DS.'js'.DS.'menu'.DS.'menu.js.php';
						if (is_file ($file)) $tpmenu->_js = $this->template_url.'/scripts/js/menu/menu.js.php';
					}
					else
					{
						$file = $this->template_dir.DS.'scripts'.DS.'js'.DS.'menu'.DS.'css.js';
						if (is_file ($file)) $tpmenu->_js = $this->template_url.'/scripts/js/menu/css.js';
					}
				break;
			}

			$tpmenu->displayMenu();			
		}
	}

	function accordion($tp, $modules)
	{
		$doaccordion = false;
		foreach($modules as $module)
		{
			if($tp->$module)
			{
				$doaccordion = true;
				break;
			}
		}
		
		if($doaccordion == true)
		{
			$display = $this->fw->params->get('tp_accordiondefaultdisplay');
			$hideall = $this->fw->params->get('tp_accordioncanhideall');
			$opacity = $this->fw->params->get('tp_accordionopacity');

			$document =& JFactory::getDocument();
			$document->addStyleSheet( "templates/".$this->fw->template."/css/accordion.css.php" );
			$document->addScript( "templates/".$this->fw->template."/scripts/js/accordion.js.php?display=".$display."&amp;hideall=".$hideall."&amp;opacity=".$opacity );

			echo '<div id="tpaccordion">';
			foreach($modules as $module)
			{
				if($tp->$module)
				{
					$mods =& TPJModuleHelper::getModules($module);
					foreach ($mods as $mod)
					{
						$renderMod = TPJModuleHelper::renderModule($mod);
						if( !empty( $renderMod ) )
						{
							echo '<div class="tpaccordiontoggler">'.$mod->title.'</div>';
							echo '<div class="tpaccordionelement"><div class="tpaccordionelement-inner">';
							echo $renderMod;
							echo '</div></div>';
						}
					}
				}
			}
			echo '</div>';
		}
	}

	function checkmootabs($position)
	{
		return ($position == $this->fw->params->get('tp_mootabspos'));
	}

	function mootabs($module)
	{
		$width = $this->fw->params->get('tp_mootabswidth');
		$height = $this->fw->params->get('tp_mootabsheight');
		$style = $this->fw->params->get('tp_mootabsstyle');
		$mode = $this->fw->params->get('tp_mootabsmode');
		$transition = $this->fw->params->get('tp_mootabstransition');
		$duration = $this->fw->params->get('tp_mootabsduration');
		$autoplay = $this->fw->params->get('tp_mootabsautoplay');
		$interval = $this->fw->params->get('tp_mootabsinterval');

		$document =& JFactory::getDocument();
		$document->addStyleSheet( "templates/".$this->fw->template."/css/mootabs.css.php?width=".$width."&amp;height=".$height );
		$document->addScript( "templates/".$this->fw->template."/scripts/js/mootabs.js" );
		$document->addScript( "templates/".$this->fw->template."/scripts/js/mootabs/style".$style.".js.php?width=".$width."&amp;height=".$height."&amp;mode=".$mode."&amp;transition=".$transition."&amp;autoplay=".$autoplay."&amp;interval=".$interval );

		$mods =& TPJModuleHelper::getModules($module); 
		if(count($mods))
		{
			echo '<div class="mootabs">' . "\n";
	
			if($style == '1')
			{
				echo '<p class="mootabs_buttons1" id="mootabs_handles1">' . "\n";
				foreach($mods as $mod)
				{
					echo '<span>'.$mod->title.'</span>' . "\n";
				}
				echo '</p>' . "\n";
			}
	
			echo '<div class="mootabs_mask">' . "\n";
			echo '<div id="mootabs_box">' . "\n";
	
			foreach ($mods as $mod) 
			{
				$renderMod = TPJModuleHelper::renderModule($mod);
				if( !empty( $renderMod ) )
				{
					echo '<div class="mootabs_inner"><div class="mootabs_innerbox">' . "\n";
					echo $renderMod . "\n";
					echo '</div></div>' . "\n";
				}
			}
	
			echo '</div>' . "\n";
			echo '</div>' . "\n";
	
			if($style == '2')
			{
				echo '<p class="mootabs_buttons2" id="mootabs_handles2">' . "\n";
				foreach($mods as $mod)
				{
					echo '<span>'.$mod->title.'</span>' . "\n";
				}
				echo '</p>' . "\n";
			}
			else if ( $style == '3' )
			{
				echo '<p class="mootabs_buttons3" id="mootabs_handles3">' . "\n";
				$n = 0;
				foreach($mods as $mod)
				{
					$n++;
					echo '<span>'.$n.'</span>' . "\n";
				}
				echo '</p>' . "\n";
			}
			else if ( $style == '4' )
			{
				echo '<p class="mootabs_buttons4" id="mootabs_handles4">' . "\n";
				foreach($mods as $mod)
				{
					echo '<span>&nbsp;</span>' . "\n";
				}
				echo '</p>' . "\n";
			}
			
			echo '</div>' . "\n";
		}
	}

	function loadModuleCufon($block)
	{
		if($this->fw->params->get('tp_cufon_in_module_block') == 'all' && $this->fw->params->get('tp_cufon_in_module_font'))
		{
			return true;
		}
		else
		{
			$blocks = explode(",", str_replace( " ", "", $this->fw->params->get('tp_cufon_in_module_block') ) );
			return in_array($block, $blocks);
		}
	}

	function mobileLoad()
	{
		$skeleton = 'skeletonmobiledefault';

		$user_agent = $_SERVER['HTTP_USER_AGENT'];
		
		switch(true)
		{
	    //case (eregi('ipod',$user_agent)||eregi('iphone',$user_agent)):
	    case (preg_match('/ipod/i',$user_agent)||preg_match('/iphone/i',$user_agent)):
	    	$skeleton = 'skeletonmobileiphone';
	    break;
	    //case (eregi('android',$user_agent)):
	    case (preg_match('/android/i',$user_agent)):
	    	$skeleton = 'skeletonmobileandroid';
	    break;
	    //case (eregi('opera mini',$user_agent)):
	    case (preg_match('/opera mini/i',$user_agent)):
	    	$skeleton = 'skeletonmobileopera';
	    break;
	    //case (eregi('blackberry',$user_agent)):
	    case (preg_match('/blackberry/i',$user_agent)):
	    	$skeleton = 'skeletonmobileblackberry';
	    break; 
	    case (preg_match('/(palm os|palm|hiptop|avantgo|plucker|xiino|blazer|elaine)/i',$user_agent)):
	    	$skeleton = 'skeletonmobilepalm';
	    break;
	    case (preg_match('/(windows ce; ppc;|windows mobile;|windows ce; smartphone;|windows ce; iemobile)/i',$user_agent)):
	    	$skeleton = 'skeletonmobilewindows';
	    break;
	  }
	  
		$skeletonFile = $this->template_dir .  DS . 'skeletons' . DS . $skeleton . '.php'; 
		$skeletonDefault = $this->template_dir .  DS . 'skeletons' . DS . 'skeletonmobiledefault.php'; 
		$skeletonFile = (file_exists(  $skeletonFile )) ? $skeletonFile : $skeletonDefault;
		if (file_exists(  $skeletonFile ))
		{
			$tp = $this->tp;
			include( $skeletonFile );
		}
	  
	}
	
	function mobileCheck($wcheck = false)
	{
		if($wcheck == false)
		{
			$sess =& JFactory::getSession();
			$switch_to = (!empty($_GET['switchto'])) ? $_GET['switchto'] : null;
			if(!empty($switch_to))
			{
				$sess->set('tp_switch_to', $switch_to);
			}
			else
			{
				$switch_to = $sess->get('tp_switch_to');
			}
	
			if($switch_to == 'standard')
			{
				return false;
			}
		}

		$user_agent = $_SERVER['HTTP_USER_AGENT'];
		$accept = $_SERVER['HTTP_ACCEPT'];
    return (
    (preg_match('/(up.browser|up.link|mmp|symbian|smartphone|midp|wap|vodafone|o2|pocket|kindle|mobile|pda|psp|treo)/i',$user_agent))
    ||
    ((strpos($accept,'text/vnd.wap.wml')>0)||(strpos($accept,'application/vnd.wap.xhtml+xml')>0))
    ||
		(isset($_SERVER['HTTP_X_WAP_PROFILE'])||isset($_SERVER['HTTP_PROFILE']))
		||
		(in_array(strtolower(substr($user_agent,0,4)),array('1207'=>'1207','3gso'=>'3gso','4thp'=>'4thp','501i'=>'501i',
			'502i'=>'502i','503i'=>'503i','504i'=>'504i','505i'=>'505i','506i'=>'506i','6310'=>'6310','6590'=>'6590',
			'770s'=>'770s','802s'=>'802s','a wa'=>'a wa','acer'=>'acer','acs-'=>'acs-','airn'=>'airn','alav'=>'alav',
			'asus'=>'asus','attw'=>'attw','au-m'=>'au-m','aur '=>'aur ','aus '=>'aus ','abac'=>'abac','acoo'=>'acoo',
			'aiko'=>'aiko','alco'=>'alco','alca'=>'alca','amoi'=>'amoi','anex'=>'anex','anny'=>'anny','anyw'=>'anyw',
			'aptu'=>'aptu','arch'=>'arch','argo'=>'argo','bell'=>'bell','bird'=>'bird','bw-n'=>'bw-n','bw-u'=>'bw-u',
			'beck'=>'beck','benq'=>'benq','bilb'=>'bilb','blac'=>'blac','c55/'=>'c55/','cdm-'=>'cdm-','chtm'=>'chtm',
			'capi'=>'capi','comp'=>'comp','cond'=>'cond','craw'=>'craw','dall'=>'dall','dbte'=>'dbte','dc-s'=>'dc-s',
			'dica'=>'dica','ds-d'=>'ds-d','ds12'=>'ds12','dait'=>'dait','devi'=>'devi','dmob'=>'dmob','doco'=>'doco',
			'dopo'=>'dopo','el49'=>'el49','erk0'=>'erk0','esl8'=>'esl8','ez40'=>'ez40','ez60'=>'ez60','ez70'=>'ez70',
			'ezos'=>'ezos','ezze'=>'ezze','elai'=>'elai','emul'=>'emul','eric'=>'eric','ezwa'=>'ezwa','fake'=>'fake',
			'fly-'=>'fly-','fly_'=>'fly_','g-mo'=>'g-mo','g1 u'=>'g1 u','g560'=>'g560','gf-5'=>'gf-5','grun'=>'grun',
			'gene'=>'gene','go.w'=>'go.w','good'=>'good','grad'=>'grad','hcit'=>'hcit','hd-m'=>'hd-m','hd-p'=>'hd-p',
			'hd-t'=>'hd-t','hei-'=>'hei-','hp i'=>'hp i','hpip'=>'hpip','hs-c'=>'hs-c','htc '=>'htc ','htc-'=>'htc-',
			'htca'=>'htca','htcg'=>'htcg','htcp'=>'htcp','htcs'=>'htcs','htct'=>'htct','htc_'=>'htc_','haie'=>'haie',
			'hita'=>'hita','huaw'=>'huaw','hutc'=>'hutc','i-20'=>'i-20','i-go'=>'i-go','i-ma'=>'i-ma','i230'=>'i230',
			'iac'=>'iac','iac-'=>'iac-','iac/'=>'iac/','ig01'=>'ig01','im1k'=>'im1k','inno'=>'inno','iris'=>'iris',
			'jata'=>'jata','java'=>'java','kddi'=>'kddi','kgt'=>'kgt','kgt/'=>'kgt/','kpt '=>'kpt ','kwc-'=>'kwc-',
			'klon'=>'klon','lexi'=>'lexi','lg g'=>'lg g','lg-a'=>'lg-a','lg-b'=>'lg-b','lg-c'=>'lg-c','lg-d'=>'lg-d',
			'lg-f'=>'lg-f','lg-g'=>'lg-g','lg-k'=>'lg-k','lg-l'=>'lg-l','lg-m'=>'lg-m','lg-o'=>'lg-o','lg-p'=>'lg-p',
			'lg-s'=>'lg-s','lg-t'=>'lg-t','lg-u'=>'lg-u','lg-w'=>'lg-w','lg/k'=>'lg/k','lg/l'=>'lg/l','lg/u'=>'lg/u',
			'lg50'=>'lg50','lg54'=>'lg54','lge-'=>'lge-','lge/'=>'lge/','lynx'=>'lynx','leno'=>'leno','m1-w'=>'m1-w',
			'm3ga'=>'m3ga','m50/'=>'m50/','maui'=>'maui','mc01'=>'mc01','mc21'=>'mc21','mcca'=>'mcca','medi'=>'medi',
			'meri'=>'meri','mio8'=>'mio8','mioa'=>'mioa','mo01'=>'mo01','mo02'=>'mo02','mode'=>'mode','modo'=>'modo',
			'mot '=>'mot ','mot-'=>'mot-','mt50'=>'mt50','mtp1'=>'mtp1','mtv '=>'mtv ','mate'=>'mate','maxo'=>'maxo',
			'merc'=>'merc','mits'=>'mits','mobi'=>'mobi','motv'=>'motv','mozz'=>'mozz','n100'=>'n100','n101'=>'n101',
			'n102'=>'n102','n202'=>'n202','n203'=>'n203','n300'=>'n300','n302'=>'n302','n500'=>'n500','n502'=>'n502',
			'n505'=>'n505','n700'=>'n700','n701'=>'n701','n710'=>'n710','nec-'=>'nec-','nem-'=>'nem-','newg'=>'newg',
			'neon'=>'neon','netf'=>'netf','noki'=>'noki','nzph'=>'nzph','o2 x'=>'o2 x','o2-x'=>'o2-x','opwv'=>'opwv',
			'owg1'=>'owg1','opti'=>'opti','oran'=>'oran','p800'=>'p800','pand'=>'pand','pg-1'=>'pg-1','pg-2'=>'pg-2',
			'pg-3'=>'pg-3','pg-6'=>'pg-6','pg-8'=>'pg-8','pg-c'=>'pg-c','pg13'=>'pg13','phil'=>'phil','pn-2'=>'pn-2',
			'pt-g'=>'pt-g','palm'=>'palm','pana'=>'pana','pire'=>'pire','pock'=>'pock','pose'=>'pose','psio'=>'psio',
			'qa-a'=>'qa-a','qc-2'=>'qc-2','qc-3'=>'qc-3','qc-5'=>'qc-5','qc-7'=>'qc-7','qc07'=>'qc07','qc12'=>'qc12',
			'qc21'=>'qc21','qc32'=>'qc32','qc60'=>'qc60','qci-'=>'qci-','qwap'=>'qwap','qtek'=>'qtek','r380'=>'r380',
			'r600'=>'r600','raks'=>'raks','rim9'=>'rim9','rove'=>'rove','s55/'=>'s55/','sage'=>'sage','sams'=>'sams',
			'sc01'=>'sc01','sch-'=>'sch-','scp-'=>'scp-','sdk/'=>'sdk/','se47'=>'se47','sec-'=>'sec-','sec0'=>'sec0',
			'sec1'=>'sec1','semc'=>'semc','sgh-'=>'sgh-','shar'=>'shar','sie-'=>'sie-','sk-0'=>'sk-0','sl45'=>'sl45',
			'slid'=>'slid','smb3'=>'smb3','smt5'=>'smt5','sp01'=>'sp01','sph-'=>'sph-','spv '=>'spv ','spv-'=>'spv-',
			'sy01'=>'sy01','samm'=>'samm','sany'=>'sany','sava'=>'sava','scoo'=>'scoo','send'=>'send','siem'=>'siem',
			'smar'=>'smar','smit'=>'smit','soft'=>'soft','sony'=>'sony','t-mo'=>'t-mo','t218'=>'t218','t250'=>'t250',
			't600'=>'t600','t610'=>'t610','t618'=>'t618','tcl-'=>'tcl-','tdg-'=>'tdg-','telm'=>'telm','tim-'=>'tim-',
			'ts70'=>'ts70','tsm-'=>'tsm-','tsm3'=>'tsm3','tsm5'=>'tsm5','tx-9'=>'tx-9','tagt'=>'tagt','talk'=>'talk',
			'teli'=>'teli','topl'=>'topl','tosh'=>'tosh','up.b'=>'up.b','upg1'=>'upg1','utst'=>'utst','v400'=>'v400',
			'v750'=>'v750','veri'=>'veri','vk-v'=>'vk-v','vk40'=>'vk40','vk50'=>'vk50','vk52'=>'vk52','vk53'=>'vk53',
			'vm40'=>'vm40','vx98'=>'vx98','virg'=>'virg','vite'=>'vite','voda'=>'voda','vulc'=>'vulc','w3c '=>'w3c ',
			'w3c-'=>'w3c-','wapj'=>'wapj','wapp'=>'wapp','wapu'=>'wapu','wapm'=>'wapm','wig '=>'wig ','wapi'=>'wapi',
			'wapr'=>'wapr','wapv'=>'wapv','wapy'=>'wapy','wapa'=>'wapa','waps'=>'waps','wapt'=>'wapt','winc'=>'winc',
			'winw'=>'winw','wonu'=>'wonu','x700'=>'x700','xda2'=>'xda2','xdag'=>'xdag','yas-'=>'yas-','your'=>'your',
			'zte-'=>'zte-','zeto'=>'zeto','acs-'=>'acs-','alav'=>'alav','alca'=>'alca','amoi'=>'amoi','aste'=>'aste',
			'audi'=>'audi','avan'=>'avan','benq'=>'benq','bird'=>'bird','blac'=>'blac','blaz'=>'blaz','brew'=>'brew',
			'brvw'=>'brvw','bumb'=>'bumb','ccwa'=>'ccwa','cell'=>'cell','cldc'=>'cldc','cmd-'=>'cmd-','dang'=>'dang',
			'doco'=>'doco','eml2'=>'eml2','eric'=>'eric','fetc'=>'fetc','hipt'=>'hipt','http'=>'http','ibro'=>'ibro',
			'idea'=>'idea','ikom'=>'ikom','inno'=>'inno','ipaq'=>'ipaq','jbro'=>'jbro','jemu'=>'jemu','java'=>'java',
			'jigs'=>'jigs','kddi'=>'kddi','keji'=>'keji','kyoc'=>'kyoc','kyok'=>'kyok','leno'=>'leno','lg-c'=>'lg-c',
			'lg-d'=>'lg-d','lg-g'=>'lg-g','lge-'=>'lge-','libw'=>'libw','m-cr'=>'m-cr','maui'=>'maui','maxo'=>'maxo',
			'midp'=>'midp','mits'=>'mits','mmef'=>'mmef','mobi'=>'mobi','mot-'=>'mot-','moto'=>'moto','mwbp'=>'mwbp',
			'mywa'=>'mywa','nec-'=>'nec-','newt'=>'newt','nok6'=>'nok6','noki'=>'noki','o2im'=>'o2im','opwv'=>'opwv',
			'palm'=>'palm','pana'=>'pana','pant'=>'pant','pdxg'=>'pdxg','phil'=>'phil','play'=>'play','pluc'=>'pluc',
			'port'=>'port','prox'=>'prox','qtek'=>'qtek','qwap'=>'qwap','rozo'=>'rozo','sage'=>'sage','sama'=>'sama',
			'sams'=>'sams','sany'=>'sany','sch-'=>'sch-','sec-'=>'sec-','send'=>'send','seri'=>'seri','sgh-'=>'sgh-',
			'shar'=>'shar','sie-'=>'sie-','siem'=>'siem','smal'=>'smal','smar'=>'smar','sony'=>'sony','sph-'=>'sph-',
			'symb'=>'symb','t-mo'=>'t-mo','teli'=>'teli','tim-'=>'tim-','tosh'=>'tosh','treo'=>'treo','tsm-'=>'tsm-',
			'upg1'=>'upg1','upsi'=>'upsi','vk-v'=>'vk-v','voda'=>'voda','vx52'=>'vx52','vx53'=>'vx53','vx60'=>'vx60',
			'vx61'=>'vx61','vx70'=>'vx70','vx80'=>'vx80','vx81'=>'vx81','vx83'=>'vx83','vx85'=>'vx85','wap-'=>'wap-',
			'wapa'=>'wapa','wapi'=>'wapi','wapp'=>'wapp','wapr'=>'wapr','webc'=>'webc','whit'=>'whit','winw'=>'winw',
			'wmlb'=>'wmlb','xda-'=>'xda-',)))
		);
	}
	
	function switchURL()
	{
		$isMobile = $this->mobileCheck(true);
		if($isMobile && $this->fw->params->get('tp_enablemobilephoneswitch'))
		{
			$sess =& JFactory::getSession();
			$switch_to = (!empty($_GET['switchto'])) ? $_GET['switchto'] : null;
			if(!empty($switch_to))
			{
				$sess->set('tp_switch_to', $switch_to);
			}
			else
			{
				$switch_to = $sess->get('tp_switch_to');
				$switch_to = (!empty($switch_to)) ? $switch_to : 'mobile';
			}
			
			$switch_to = ($switch_to == 'mobile') ? 'standard' : 'mobile';
	
			$s = empty($_SERVER["HTTPS"]) ? '' : ($_SERVER["HTTPS"] == "on") ? "s" : "";
			$protocol = substr(strtolower($_SERVER["SERVER_PROTOCOL"]), 0, strpos(strtolower($_SERVER["SERVER_PROTOCOL"]), "/")) . $s;
			$port = ($_SERVER["SERVER_PORT"] == "80") ? "" : (":".$_SERVER["SERVER_PORT"]);
			$protocol = $protocol."://".$_SERVER['SERVER_NAME'].$port.$_SERVER['REQUEST_URI'];
			$protocol = str_replace(array("&switchto=standard", "&switchto=mobile", "?switchto=standard", "?switchto=mobile"), "", $protocol);
	
			if(strpos($protocol, '?'))
			{
				$url = $protocol . "&switchto=" . $switch_to;
			}
			else
			{
				$url = $protocol . "?switchto=" . $switch_to;
			}
			
			if ($switch_to == 'mobile')
			{
				return '<div class="tpmobile-switch"><a href="'.$url.'"><img src="'.$this->template_url.'/images/mobile_off.png" alt="Swicth to Mobile Interface" /></a></div>';
			}
			else
			{
				return '<div class="tpmobile-switch"><a href="'.$url.'"><img src="'.$this->template_url.'/images/mobile_on.png" alt="Swicth to Standard Interface" /></a></div>';
			}
		}
		else
		{
			return false;
		}
	}

	function headers($t, $cssgets, $jsgets)
	{
		$isMobile = $this->mobileCheck();
		if($isMobile && $this->fw->params->get('tp_mobilemode') == 1)
		{
			$headerstuff = $t->getHeadData();
			$headerstuff['scripts'] = array();
			$t->setHeadData($headerstuff);
		}

		$tpmetagen	= $this->fw->params->get('tp_metagen');
		$tpgooglekey	= $this->fw->params->get('tp_googlekey');
		$tpyahookey		= $this->fw->params->get('tp_yahookey');
		$tpmsnkey			= $this->fw->params->get('tp_msnkey');
		
		$document =& JFactory::getDocument();

		if($tpmetagen)
			$this->fw->setGenerator($tpmetagen);
		if($tpgooglekey)
			$document->setMetadata('verify-v1', $tpgooglekey);
		if($tpyahookey)
			$document->setMetadata('y_key', $tpyahookey);
		if($tpmsnkey)
			$document->setMetadata('msvalidate.01', $tpmsnkey);

		//echo JURI::base() . "templates/".$this->fw->template."/css/css.gzip.php".$cssgets;
		//exit;
		
		if( $this->fw->params->get('tp_cachecss') == 0 )
		{
			$document->addStyleSheet( "templates/".$this->fw->template."/css/css.gzip.php".$cssgets );
		}
		else
		{
			$savedcss = "tpcss_" . md5("css.gzip.php".$cssgets);
			$path = JPATH_BASE.DS.'templates'.DS.$this->fw->template.DS.'css'.DS.'saved'.DS.$savedcss.'.css';
			//$path = JPATH_BASE.DS.'templates'.DS.$this->fw->template.DS.'css'.DS.$savedcss.'.css';
			$usesaved = true;
			if(!file_exists($path))
			{
				$url = JURI::base() . "templates/".$this->fw->template."/css/css.gzip.php".$cssgets;
				if ( function_exists( 'fopen' ) && function_exists( 'stream_get_contents' ) && function_exists( 'fclose' ) && ini_get('allow_url_fopen') )
				{
					$handle = fopen( $url, "r" );
					$cssContent = stream_get_contents( $handle );
					fclose( $handle );
				}
				else if ( function_exists( 'curl_init' ) )
				{
					$ch = curl_init();
					curl_setopt( $ch, CURLOPT_URL, $url );
					curl_setopt( $ch, CURLOPT_HEADER, 0);
					ob_start();
					curl_exec( $ch );
					curl_close( $ch );
					$cssContent = ob_get_contents();
					ob_end_clean();
				}

				jimport('joomla.filesystem.file');
				$put = JFile::write($path, $cssContent);
				if(!$put)
				{
					@chmod(JPATH_BASE.DS.'templates'.DS.$this->fw->template.DS.'css'.DS.'saved', 0755);
					//@chmod(JPATH_BASE.DS.'templates'.DS.$this->fw->template.DS.'css', 0755);
					$put = JFile::write($path, $cssContent);
					if(!$put)
					{
						@chmod(JPATH_BASE.DS.'templates'.DS.$this->fw->template.DS.'css'.DS.'saved', 0777);
						//@chmod(JPATH_BASE.DS.'templates'.DS.$this->fw->template.DS.'css', 0777);
						$put = JFile::write($path, $cssContent);
						if(!$put)
						{
							$usesaved = false;
						}
					}
					//@chmod(JPATH_BASE.DS.'templates'.DS.$this->fw->template.DS.'css'.DS.'saved', 0644);
					@chmod(JPATH_BASE.DS.'templates'.DS.$this->fw->template.DS.'css'.DS.'saved', 0755);
					//@chmod(JPATH_BASE.DS.'templates'.DS.$this->fw->template.DS.'css', 0644);
				}
			}
			
			if($usesaved)
			{
				$document->addStyleSheet( "templates/".$this->fw->template."/css/style.php?r=".$savedcss );
				//$document->addStyleSheet( "templates/".$this->fw->template."/css/".$savedcss.".css" );
			}
			else
			{
				$document->addStyleSheet( "templates/".$this->fw->template."/css/css.gzip.php".$cssgets );
			}
		}
		
		//echo '  <link rel="stylesheet" href="templates/'.$this->fw->template.'/css/css.gzip.php'.$cssgets.'" type="text/css" />' . "\n";
		$document->addCustomTag( '<link rel="apple-touch-icon" href="'.$this->template_url.'/images/mobile_icon.png" />' );

		if(!$isMobile || $this->fw->params->get('tp_mobilemode') == 0)
		{
			JHTML::_('behavior.mootools');
			//echo '  <script type="text/javascript" src="templates/'.$this->fw->template.'/scripts/js/js.gzip.php'.$jsgets.'"></script>' . "\n";
			$document->addScript( "templates/".$this->fw->template."/scripts/js/js.gzip.php".$jsgets );
		}

		if ( (preg_match('/ipod/i',$_SERVER['HTTP_USER_AGENT']) || preg_match('/iphone/i',$_SERVER['HTTP_USER_AGENT'])) && $this->fw->params->get('tp_mobilemode') == 1 && $isMobile )
		{
			//echo "\t" . '<!-- needed for iphopne skeleton -->' . "\n";
			//echo "\t" . '<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; minimum-scale=1.0; user-scalable=0;" />' . "\n";
			$document->setMetadata('viewport', "width=device-width; initial-scale=1.0; maximum-scale=1.0; minimum-scale=1.0; user-scalable=0;");
		}
	}
	
	function headersIphone()
	{
		$document =& JFactory::getDocument();
		$document->addScript( "templates/".$this->fw->template."/scripts/js/jquery.js" );

		$document->addCustomTag('
			<script type="text/javascript">
				$(document).ready(function(){

			    $(".gotomenu").click(function(){
			    	//$(this).fadeTo("slow", 0.33);
				    //$("#tp-sk-iphone-wrapper").fadeOut("fast");
				    //$("#tp-sk-iphone-navpage-wrapper").fadeIn("slow");
				    //$("#tp-sk-iphone-wrapper").slideUp("slow");
				    $("#tp-sk-iphone-navpage-wrapper").slideDown();

			    });

			    $(".gotocontent").click(function(){
				    $("#tp-sk-iphone-navpage-wrapper").slideUp("slow");
				    //$("#tp-sk-iphone-navpage-wrapper").fadeOut("fast");
				    //$("#tp-sk-iphone-wrapper").fadeIn("slow");
						
			      //$("#tp-sk-iphone-wrapper").animate( { display:"none"}, 1000 )
			      //   .animate( { fontSize:"24px" } , 0 )
			      //   .animate( { borderLeftWidth:"15px" }, 0 );

			      //$("#tp-sk-iphone-navpage-wrapper").animate( { display:"block"}, 1000 )
			      //   .animate( { display:"block" } , 1000 )
			      //   .animate( { borderLeftWidth:"15px" }, 1000);
			    });
				});
			</script>
		');
	}

	function ieRedirect()
	{
		if($this->fw->params->get('tp_ie6checker'))
		{
			if (preg_match('/\bmsie 6/i', $_SERVER['HTTP_USER_AGENT']) && !preg_match('/\bopera/i', $_SERVER['HTTP_USER_AGENT']) && !$this->mobileCheck())
			{
				header("Location: templates/".$this->fw->template."/scripts/html/ie6alert/index.html");
				exit;
			}
		}
	}

	function loadTheme($f)
	{
		if(!DEFINED('TPMOBILEMODE'))
		{
			$app =& JFactory::getApplication();
			$templateDir = JPATH_BASE . DS .  'templates' . DS . $app->getTemplate();
			
			$ini	= $templateDir.DS.'params.ini';
			$xml	= $templateDir.DS.'templateDetails.xml';
			
			jimport('joomla.filesystem.file');
			$cini = (JFile::exists($ini)) ? JFile::read($ini) : null;

			$params = new JParameter($cini, $xml, 'template');
			
			DEFINE('TPMOBILEMODE', $params->get('tp_mobilemode'));
		}
			
		$dirname = dirname($f);
		$basename = basename($f);
		if (tpFramework::mobileCheck() && TPMOBILEMODE)
		{
			include( $dirname . DS . 'mobile' . DS . $basename );
		}
		else
		{
			include( $dirname . DS . 'general' . DS . $basename );
		}
	}
	
	function loadMenu()
	{
		$menutype = $this->fw->params->get('mobilemenu');
		$menutype = (!empty($menutype)) ? $menutype : 'mainmenu';
		
		$mobilemenumaxcount = (int) $this->fw->params->get('mobilemenumaxcount');
		$mobilemenumaxcount = (!empty($mobilemenumaxcount)) ? $mobilemenumaxcount : 4;

		global $Itemid,$mainframe;
	
		$database = & JFactory::getDBO();
   	$my = & JFactory::getUser();
   	$cur_template = $mainframe->getTemplate(); 
		$contentConfig = &JComponentHelper::getParams( 'com_content' );
		$noauth	= $contentConfig->get('shownoauth');

		$active = 0;
	 	if($Itemid==99999999)
	 	{
	 		$Itemid = 1;
	 	}
	
		if ($noauth)
		{
		 	$database->setQuery("SELECT m.*, count(p.parent) as cnt" .
		  "\nFROM #__menu AS m" .
		  "\nLEFT JOIN #__menu AS p ON p.parent = m.id" .
		  "\nWHERE m.menutype='$menutype' AND m.published='1' AND m.parent=0" .
		  "\nGROUP BY m.id ORDER BY m.parent, m.ordering ");
		}
		else
		{
			$database->setQuery("SELECT m.*, sum(case when p.published=1 then 1 else 0 end) as cnt" .
			"\nFROM #__menu AS m" .
			"\nLEFT JOIN #__menu AS p ON p.parent = m.id" .
			"\nWHERE m.menutype='$menutype' AND m.published='1' AND m.access <= '$my->gid' AND m.parent=0" .
			"\nGROUP BY m.id ORDER BY m.parent, m.ordering ");
	  }
	
		$rows = $database->loadObjectList( 'id' );
		echo $database->getErrorMsg();
		
		$output = null;
		
		if (count($rows))
		{
			$output = '<ul class="tpmobilemenu">';
				
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
					
				switch ($row->type)
				{
					case 'separator':
						// do nothing
						$row->link = "seperator";
						break;
					case 'url':
						if ( eregi( 'index.php\?', $row->link ) )
						{
					  	if ( !eregi( 'Itemid=', $row->link ) )
					  	{
					    	$row->link .= '&Itemid='. $row->id;
							}
						}
					break;
					default:
						$row->link .= "&Itemid=$row->id";
					break;
				}
	
		  	$row->link = str_replace( '&', '&amp;', $row->link );
		
		  	if (strcasecmp(substr($row->link,0,4),"http"))
		  	{
		  		if($row->link == 'index.php?option=com_content&amp;view=frontpage&amp;Itemid=1')
		  		{
		  			$row->link = JURI::base();
		  		}
		  		else
		  		{
			  		$row->link = JRoute::_($row->link);
			  	}
		  	}
		  	else
		  	{
		  		if($row->link == 'index.php?option=com_content&amp;view=frontpage&amp;Itemid=1')
		  		{
		  			$row->link = JURI::base();
		  		}
		  	}
				
		  	preg_match_all( "/({)(.*)(})/", $row->name, $matches, PREG_SET_ORDER );
				$mitemparams = ( !empty( $matches[0][2] ) ) ? $matches[0][2] : null;
				$row->name = str_replace( "{".$mitemparams."}", "", $row->name );
				$row->name = explode('||', $row->name, 2);
				$row->name = $row->name[0];
				
				$mobilemenudisplay = $this->fw->params->get('mobilemenudisplay');
				
				$menudisplay = '<span>'.$row->name.'</span>';
				$menu_params = new stdClass();
				$menu_params = new JParameter( $row->params );
				$menu_image = $menu_params->def( 'menu_image', -1 );
				$img_src = ( ( $menu_image != '-1' ) && $menu_image && (strlen($menu_image)>0) ) ? JURI::base() . 'images/stories/' . $menu_image : null;
				if ($mobilemenudisplay == 'image')
				{
					if(!empty($img_src))
					{
						$menudisplay = '<img src="'.$img_src.'" alt="'.$row->name.'"/>';
					}
					else
					{
						$menudisplay = '<span>'.$row->name.'</span>';
					}
				}
				else if ($mobilemenudisplay == 'textimage')
				{
					if(!empty($img_src))
					{
						$menudisplay = '<img src="'.$img_src.'" alt="'.$row->name.'"/><br/><span>'.$row->name.'</span>';
					}
					else
					{
						$menudisplay = '<span>'.$row->name.'</span>';
					}
				}

		    if($database->loadResult() >= 1 )
		    {
					if($row->id == $Itemid)
					{
						$active = $n;
					}
					$output .= '<li class="tpmobilemenuid'.$n.'"><a href="'.$row->link.'">'.$menudisplay.'</a></li>';
				}
				else
				{
					$act = "";
					if($row->id == $Itemid)
					{
						$act = "active ";
						$active = $n;
					}
					$output .= '<li class="'.$act.' tpmobilemenuid'.$n.'"><a href="'.$row->link.'">'.$menudisplay.'</a></li>';
				}
	
				if($n >= $mobilemenumaxcount) break;
			}

			$output .= '</ul>';
		}
		
		return $output;
	}
}

class TPJModuleHelper
{
	function &getModule($name, $title = null )
	{
		$result		= null;
		$modules	=& TPJModuleHelper::_load();
		$total		= count($modules);
		for ($i = 0; $i < $total; $i++)
		{
			// Match the name of the module
			if ($modules[$i]->name == $name)
			{
				// Match the title if we're looking for a specific instance of the module
				if ( ! $title || $modules[$i]->title == $title )
				{
					$result =& $modules[$i];
					break;	// Found it
				}
			}
		}

		// if we didn't find it, and the name is mod_something, create a dummy object
		if (is_null( $result ) && substr( $name, 0, 4 ) == 'mod_')
		{
			$result				= new stdClass;
			$result->id			= 0;
			$result->title		= '';
			$result->module		= $name;
			$result->position	= '';
			$result->content	= '';
			$result->showtitle	= 0;
			$result->control	= '';
			$result->params		= '';
			$result->user		= 0;
		}

		return $result;
	}

	/**
	 * Get modules by position
	 *
	 * @access public
	 * @param string 	$position	The position of the module
	 * @return array	An array of module objects
	 */
	function &getModules($position)
	{
		$position	= strtolower( $position );
		$result		= array();

		$modules =& TPJModuleHelper::_load();

		$total = count($modules);
		for($i = 0; $i < $total; $i++) {
			if($modules[$i]->position == $position) {
				$result[] =& $modules[$i];
			}
		}
		if(count($result) == 0) {
			if(JRequest::getBool('tp')) {
				$result[0] = TPJModuleHelper::getModule( 'mod_'.$position );
				$result[0]->title = $position;
				$result[0]->content = $position;
				$result[0]->position = $position;
			}
		}

		return $result;
	}

	/**
	 * Checks if a module is enabled
	 *
	 * @access	public
	 * @param   string 	$module	The module name
	 * @return	boolean
	 */
	function isEnabled( $module )
	{
		$result = &TPJModuleHelper::getModule( $module);
		return (!is_null($result));
	}

	function renderModule($module, $attribs = array())
	{
		static $chrome;
		global $mainframe, $option;

		$scope = $mainframe->scope; //record the scope
		$mainframe->scope = $module->module;  //set scope to component name

		// Handle legacy globals if enabled
		if ($mainframe->getCfg('legacy'))
		{
			// Include legacy globals
			global $my, $database, $acl, $mosConfig_absolute_path;

			// Get the task variable for local scope
			$task = JRequest::getString('task');

			// For backwards compatibility extract the config vars as globals
			$registry =& JFactory::getConfig();
			foreach (get_object_vars($registry->toObject()) as $k => $v) {
				$name = 'mosConfig_'.$k;
				$$name = $v;
			}
			$contentConfig = &JComponentHelper::getParams( 'com_content' );
			foreach (get_object_vars($contentConfig->toObject()) as $k => $v)
			{
				$name = 'mosConfig_'.$k;
				$$name = $v;
			}
			$usersConfig = &JComponentHelper::getParams( 'com_users' );
			foreach (get_object_vars($usersConfig->toObject()) as $k => $v)
			{
				$name = 'mosConfig_'.$k;
				$$name = $v;
			}
		}

		// Get module parameters
		$params = new JParameter( $module->params );

		// Get module path
		$module->module = preg_replace('/[^A-Z0-9_\.-]/i', '', $module->module);
		$path = JPATH_BASE.DS.'modules'.DS.$module->module.DS.$module->module.'.php';

		// Load the module
		if (!$module->user && file_exists( $path ) && empty($module->content))
		{
			$lang =& JFactory::getLanguage();
			$lang->load($module->module);

			$content = '';
			ob_start();
			require $path;
			$module->content = ob_get_contents().$content;
			ob_end_clean();
		}

		// Load the module chrome functions
		if (!$chrome) {
			$chrome = array();
		}

		require_once (JPATH_BASE.DS.'templates'.DS.'system'.DS.'html'.DS.'modules.php');
		$chromePath = JPATH_BASE.DS.'templates'.DS.$mainframe->getTemplate().DS.'html'.DS.'modules.php';
		if (!isset( $chrome[$chromePath]))
		{
			if (file_exists($chromePath)) {
				require_once ($chromePath);
			}
			$chrome[$chromePath] = true;
		}

		//make sure a style is set
		if(!isset($attribs['style'])) {
			$attribs['style'] = 'none';
		}

		//dynamically add outline style
		if(JRequest::getBool('tp')) {
			$attribs['style'] .= ' outline';
		}

		foreach(explode(' ', $attribs['style']) as $style)
		{
			$chromeMethod = 'modChrome_'.$style;

			// Apply chrome and render module
			if (function_exists($chromeMethod))
			{
				$module->style = $attribs['style'];

				ob_start();
				$chromeMethod($module, $params, $attribs);
				$module->content = ob_get_contents();
				ob_end_clean();
			}
		}

		$mainframe->scope = $scope; //revert the scope

		return $module->content;
	}

	/**
	 * Get the path to a layout for a module
	 *
	 * @static
	 * @param	string	$module	The name of the module
	 * @param	string	$layout	The name of the module layout
	 * @return	string	The path to the module layout
	 * @since	1.5
	 */
	function getLayoutPath($module, $layout = 'default')
	{
		global $mainframe;

		// Build the template and base path for the layout
		$tPath = JPATH_BASE.DS.'templates'.DS.$mainframe->getTemplate().DS.'html'.DS.$module.DS.$layout.'.php';
		$bPath = JPATH_BASE.DS.'modules'.DS.$module.DS.'tmpl'.DS.$layout.'.php';

		// If the template has a layout override use it
		if (file_exists($tPath)) {
			return $tPath;
		} else {
			return $bPath;
		}
	}

	/**
	 * Load published modules
	 *
	 * @access	private
	 * @return	array
	 */
	function &_load()
	{
		global $mainframe, $Itemid;

		static $modules;

		if (isset($modules)) {
			return $modules;
		}

		$user	=& JFactory::getUser();
		$db		=& JFactory::getDBO();

		$aid	= $user->get('aid', 0);

		$modules	= array();

		$wheremenu = isset( $Itemid ) ? ' AND ( mm.menuid = '. (int) $Itemid .' OR mm.menuid = 0 )' : '';
		//$wheremenu = null;

		$query = 'SELECT id, title, module, position, content, showtitle, control, params'
			. ' FROM #__modules AS m'
			. ' LEFT JOIN #__modules_menu AS mm ON mm.moduleid = m.id'
			. ' WHERE m.published = 1'
			. ' AND m.access <= '. (int)$aid
			. ' AND m.client_id = '. (int)$mainframe->getClientId()
			. $wheremenu
			. ' ORDER BY position, ordering';

		$db->setQuery( $query );

		if (null === ($modules = $db->loadObjectList())) {
			JError::raiseWarning( 'SOME_ERROR_CODE', JText::_( 'Error Loading Modules' ) . $db->getErrorMsg());
			return false;
		}

		$total = count($modules);
		for($i = 0; $i < $total; $i++)
		{
			//determine if this is a custom module
			$file					= $modules[$i]->module;
			$custom 				= substr( $file, 0, 4 ) == 'mod_' ?  0 : 1;
			$modules[$i]->user  	= $custom;
			// CHECK: custom module name is given by the title field, otherwise it's just 'om' ??
			$modules[$i]->name		= $custom ? $modules[$i]->title : substr( $file, 4 );
			$modules[$i]->style		= null;
			$modules[$i]->position	= strtolower($modules[$i]->position);
		}

		return $modules;
	}

}

?>