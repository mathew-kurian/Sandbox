<?php
/* 
=================================================
# Filename : skeletondefault.css.php
# Description : Dynamic CSS rules for default sekeleton
# Author : TemplatePlazza
# Author Url : http://www.templateplazza.com
# Copyright (C) 2009 TemplatePlazza.com
# All rights reserved.
=================================================
*/
define('DS', DIRECTORY_SEPARATOR);
define('PATH_ROOT', dirname(__FILE__) . DS);
include(PATH_ROOT . DS . 'calc.php');

?>
/* ===== BODIES ===== */
.tpbodies {
	padding:0;
	margin: 0;
	font: 13px Arial, Helvetica, Garuda, sans-serif;
	background:url('<?php echo $tpbackgroundimgpath; ?>' ) fixed <?php echo $tpbackgroundcolor; ?>;
	/* *font-size: small;
	*font: x-small; */ /*ie fix*/
 }
/* ===== WRAPPER ===== */
#tpwrapper-global {
	}
#tpwrapper-page {
	padding-bottom:0;
	text-align:left;
	width:<?php echo $tpwidth_wrapper_page; ?>px;
	}
#tpwrapper-page-inner {
	padding: <?php echo $tpgutter; ?>px;
	background:#FFFFFF;
	}
#tpwrapper-right {
	float:right;

	}
#tpwrapper-inner-left {

	}
#tpwrapper-inner-right {
	}
#tpwrapper-footer {
	margin:<?php echo $tpgutter; ?>px 0;
	}
#tpwrapper-footer * {
	font-size:11px;}
/* ===== BLOCKS RESET ===== */
#tpblock-head, 
#tpblock-tpmenu,
#tpblock-top,
#tpblock-left,
#tpwrapper-right,
#tpblock-bot,
#tpblock-footerleft ,
#tpblock-footerright,
#tpaccordion {
	margin-bottom:<?php echo $tpgutter; ?>px;
	}
	
	
/* ===== BLOCK HEAD ===== */
#tpblock-head {
	height:<?php echo $tpheight_blockhead; ?>px;
	}
#tpblock-head-inner{

	}
#tpdiv-logo {
	margin-top: <?php echo $tpgutter; ?>px;
	width:<?php echo $tpwidth_logowidth; ?>px;
	height:84px;
	background:url('../images/logo.png') no-repeat left bottom;
	float:<?php echo $tplogofloat; ?>;}
#tpdiv-logo h1{
	display:block;
	text-indent:-9000px;
	}
#tpmod-banner {
	margin-top: <?php echo $tpgutter; ?>px;
	text-align:<?php echo $tpbannerfloat; ?>;
	width:<?php echo $tpwidth_mod_banner; ?>px;
	float:<?php echo $tpbannerfloat; ?>;}
	
/* ===== BLOCK TPMENU ===== */
#tpblock-tpmenu {
	background:url(../images/blackshadow.png);
	padding:10px;
	height:60px;}

#tpmod-user8 {}
/* ===== BLOCK TOP ===== */
#tpblock-top {
	background:url(../images/blackshadow.png);
	padding:10px;}
#tpblock-top-inner {
	background:#FFFFFF;
	padding:<?php echo $tpgutter; ?>px;}

#tpmod-user11, #tpmod-user12 , #tpmod-user13,#tpmod-user14 {
	float:left;
}
#tpmod-user11, #tpmod-user12 , #tpmod-user13,#tpmod-user14 {
	float:left;
}
#tpmod-user11 {
	width:<?php echo $tpwidth_u_11; ?>px;
	margin-right: <?php echo $tpmod_user11_margin; ?>px; 
}
#tpmod-user12 {
	width:<?php echo $tpwidth_u_12; ?>px;
	margin-right: <?php echo $tpmod_user12_margin; ?>px; 
}
#tpmod-user13 {
	width:<?php echo $tpwidth_u_13; ?>px;
	margin-right: <?php echo $tpmod_user13_margin; ?>px; 
}
#tpmod-user14 {
	width:<?php echo $tpwidth_u_14; ?>px;
	margin-right: <?php echo $tpmod_user14_margin; ?>px; 
}


/* for tpblocktoptype param = 2 * 1/2 */
#tpblock-top-innerleft {
	float:left;
	width: <?php echo $tpblock_top_innerleft_width; ?>px;
}
#tpblock-top-innerright {
	float:right;
	width: <?php echo $tpblock_top_innerright_width; ?>px;
}

/* for tpblocktoptype param = 2 * 1/2 */
#tpblock-bot-innerleft {
	float:left;
	width: <?php echo $tpblock_bot_innerleft_width; ?>px;
}
#tpblock-bot-innerright {
	float:right;
	width: <?php echo $tpblock_bot_innerright_width; ?>px;
}


/* ===== BLOCK LEFT ===== */
#tpblock-left {
	width:<?php echo $tpwidth_blockleft; ?>px;
	float:left;
	}
#tpmod-left {
	width:<?php echo $tpwidth_mod_left; ?>px;
	float:left;}
/* ===== BLOCK RIGHT ===== */
#tpwrapper-right {
	width:<?php echo $tpwidth_wrapper_right; ?>px;
	float:right;
	}
#tpwrapper-inner-left {
	width:<?php echo $tpwidth_tpwrapper_inner_left; ?>px;
	float:left;
	}
#tpwrapper-inner-right {
	width:<?php echo $tpwidth_tpwrapper_inner_right; ?>px;
	float:right;}
#tpmod-right {
	width:<?php echo $tpwidth_mod_right; ?>px;
	float:right;}
/* ===== BLOCK TOPBODY ===== */
#tpmod-breadcrumb {
	margin-bottom:<?php echo $tpgutter; ?>px;
	}
#tpblock-topbody {
	margin-bottom:<?php echo $tpgutter; ?>px;}
#tpmod-user1 {
	float:left;
	width: <?php echo $tpwidth_mod_user1; ?>px;
}
#tpmod-user2 {
	float:right;
	width: <?php echo $tpwidth_mod_user2; ?>px;
	}
/* ===== BLOCK MIDTOPBODY ===== */
#tpblock-midtopbody {
	margin-bottom:<?php echo $tpgutter; ?>px;}
#tpmod-advert1 {
	float:left;
	width: <?php echo $tpwidth_mod_advert1; ?>px;
}
#tpmod-advert2 {
	float:right;
	width: <?php echo $tpwidth_mod_advert2; ?>px;
}
/* ===== BLOCK MAINBODY ===== */
#tpblock-mainbody {
	margin-bottom:<?php echo $tpgutter; ?>px;}
/* ===== BLOCK MIDBOTBODY ===== */
#tpblock-midbotbody {
	margin-bottom:<?php echo $tpgutter; ?>px;}
#tpmod-advert3 {
	float:left;
	width: <?php echo $tpwidth_mod_advert3; ?>px;
}
#tpmod-advert4 {
	float:right;
	width: <?php echo $tpwidth_mod_advert4; ?>px;
}
/* ===== BLOCK BOTTOMBODY ===== */
#tpblock-botbody {
	margin-bottom:<?php echo $tpgutter; ?>px;}
#tpmod-user5 {
	float:left;
	width: <?php echo $tpwidth_mod_user5; ?>px;
}
#tpmod-user6 {
	float:right;
	width: <?php echo $tpwidth_mod_user6; ?>px;
}
/* ===== BLOCK BOTTOM ===== */
#tpblock-bot {}

#tpmod-user21, #tpmod-user22 , #tpmod-user23, #tpmod-user24 {
	float:left;
}
#tpmod-user21 {
	width:<?php echo $tpwidth_u_21; ?>px;
	margin-right: <?php echo $tpmod_user21_margin; ?>px; 
}
#tpmod-user22 {
	width:<?php echo $tpwidth_u_22; ?>px;
	margin-right: <?php echo $tpmod_user22_margin; ?>px; 
}
#tpmod-user23 {
	width:<?php echo $tpwidth_u_23; ?>px;
	margin-right: <?php echo $tpmod_user23_margin; ?>px; 
}
#tpmod-user24 {
	width:<?php echo $tpwidth_u_24; ?>px;
	margin-right: <?php echo $tpmod_user24_margin; ?>px; 
}

/* ===== BLOCK FOOTERLEFTT ===== */
#tpblock-footerleft {
	float:left;
	width:50%;}
#tpblock-footerright {
	float:right;
	width:50%;
	}
/* ===== BLOCK FOOTERRIGHT ===== */

.last {
	margin:0;}
	

