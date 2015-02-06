<?php
/* =================================================
# Filename : skeletonmobileiphone.php
# Description : Skeleton for Safari iPhone 
# Author : TemplatePlazza
# Author Url : http://www.templateplazza.com
# Copyright (C) 2009 TemplatePlazza.com All rights reserved.

=================================================
*/

defined('_JEXEC') or die('Restricted access');
$this->headersIphone();
?>
<div class="quickFlip">
<div id="tp-sk-iphone-wrapper">
	<!-- ======= BLOCK HEADER  ======= -->
	<div id="tp-sk-iphone-header">
		
		<div id="tp-sk-iphone-header-logo"><a href="<?php JURI::base(); ?>"><img src="<?php echo $this->template_url; ?>/images/mobile_icon.png" height="40" align=" middle" alt="<?php echo $this->fw->params->get('tp_logotext');?>"/></a></div>
        <div id="tp-sk-iphone-header-text">
            <h1><a href="<?php JURI :: base(); ?>"><?php echo $this->fw->params->get('tp_logotext');?></a></h1>
        </div>
        <div id="tp-sk-iphone-header-menu">
            <a class="gotomenu" href="#">Menu</a>
        </div>        
		
	</div>

	<!-- ======= BLOCK NAVPAGE  ======= -->
	<!-- <div id="tp-sk-iphone-navpage">
        <?php //echo $this->loadMenu(); ?>       
	</div>
    -->
    <!-- ======= BLOCK BANNER  ======= -->
    <?php if ($tp->banner) { ?>
     <div id="tp-sk-iphone-banner-header">  	
    	<div id="tp-sk-mod_banner">
    		<jdoc:include type="modules" name="banner" style="raw" />
    	</div>	      
	</div>
    <?php } ?>	
	
	<!-- ======= BLOCK MOD USER1  ======= -->
	<?php if ($tp->mobiletop) { ?>
	<div class="tp-sk-iphone-container">
		<div class="tp-sk-iphone-content">	
			<div class="tp-sk-mod-user1-2">
				<jdoc:include type="modules" name="mobiletop" style="xhtml" />
			</div>	
		</div>
	</div>
	<?php } ?>
	
	<!-- ======= BLOCK MAINBODY  ======= -->
	<div class="tp-sk-iphone-container">
		<div class="tp-sk-iphone-content">
			<div class="tp-sk-iphone-content_inner">
				<jdoc:include type="message" />
				<jdoc:include type="component" />
			</div>
		</div>
	</div>
	<div class="clrfix"></div>
	
	<!-- ======= BLOCK MOD USER2  ======= -->
	<?php if ($tp->mobilebottom) { ?>
	<div class="tp-sk-iphone-container">
		<div class="tp-sk-iphone-content">	
			<div class="tp-sk-mod-user1-2">
				<jdoc:include type="modules" name="mobilebottom" style="xhtml" />
			</div>	
		</div>
	</div>
	<?php } ?>
	
	<!-- ======= BLOCK FOOTER  ======= -->
	<div id="tp-sk-iphone-footer" align="center">
		<div id="tp-sk-iphone-footer-txt" align="center">Designed by <a href="http://www.templateplazza.com" target="_blank"><strong> TemplatePlazza</strong></a> - All Rights Reserved</div>
	</div>
</div>

<!-- ======= NAVPAGE - SHOW/HIDE ======= -->
<div id="tp-sk-iphone-navpage-wrapper">
    	<div id="tp-sk-iphone-navpage-header">

    		<div id="tp-sk-iphone-header-logo-navpage"><a href="<?php JURI::base(); ?>"><img src="<?php echo $this->template_url; ?>/images/mobile_icon.png" height="40" align=" middle" alt="<?php echo $this->fw->params->get('tp_logotext');?>"/></a></div>
            <div id="tp-sk-iphone-header-text-navpage">
                <h1><a href="<?php JURI :: base(); ?>"><?php echo $this->fw->params->get('tp_logotext');?></a></h1>
            </div>
            <div id="tp-sk-iphone-header-menu-close">
               	<a class="gotocontent" href="#">Close</a>
            </div>        
    		
    	</div>
    <div id="tp-sk-iphone-navpage-inner">
        <jdoc:include type="modules" name="user4" style="raw" />  
        <?php echo $this->loadMenu(); ?>   
    </div>    
</div>

</div>