<?php
/* 
=================================================
# Filename : skeleton6.css.php
# Description : Dynamic CSS rules for skeleton 6
# Author : TemplatePlazza
# Author Url : http://www.templateplazza.com
# Copyright (C) 2009 TemplatePlazza.com
# All rights reserved.
=================================================
*/
define('DS', DIRECTORY_SEPARATOR);
define('PATH_ROOT', dirname(__FILE__) . DS);
include( ( file_exists( PATH_ROOT . DS . 'calc_skeleton6.php' ) ) ? PATH_ROOT . DS . 'calc_skeleton6.php' : PATH_ROOT . DS . 'calc.php' );

?>
/* ===== BODIES ===== */
.tpbodies {
	padding:0;
	margin: 0;
	font: 13px Arial, Helvetica, Garuda, sans-serif;
	background:url('<?php echo $tpbackgroundimgpath; ?>' ) <?php echo $tpbackgroundcolor; ?>; 
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

    margin-top:<?php echo $tpgutter; ?>px;
	}
#tpwrapper-right {
	float:right;
    background:#FFFFFF;
    

	}
#tpwrapper-inner-left {

	}
#tpwrapper-inner-right {
	}
#tpwrapper-footer-wrapper{
	margin:auto 0;
    background: url("../images/bgmobile.png") center bottom;
    margin-bottom: 0;
    height: 70px;
    padding-top: 10px;
    border-bottom: none;
    
	}     
#tpwrapper-footer {
	margin:<?php echo $tpgutter; ?>px 0;
    width:<?php echo $tpwidth_wrapper_page; ?>px;
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
    background:url(../images/bg-topblock-head.png) no-repeat top left #131313;
	}
.tpblock-head-inner{
background:url(../images/shadowright.png) no-repeat top right;
	}

#tpdiv-logo {
	width:<?php echo $tpwidth_logowidth; ?>px;
	height:<?php echo $tpheight_blockhead - 84; ?>px;
	background:url('../images/logo.png') no-repeat left top;
	float:<?php echo $tplogofloat; ?>;

    }
#tpdiv-logo h1 a{
	display:block;
	text-indent:-9000px;
    width:<?php echo $tpwidth_logowidth; ?>px;
	}
#tpmod-banner {
	text-align:<?php echo $tpbannerfloat; ?>;
	width:<?php echo $tpwidth_mod_banner; ?>px;
	float:<?php echo $tpbannerfloat; ?>;
    }
#tpmod-banner div.search {
    float:<?php echo $tpbannerfloat; ?>;
    margin: 14px 0 0 0;
    width: 281px;
    height: 38px;
    background:url('../images/bgsearch.png') no-repeat <?php echo $tpbannerfloat; ?> top;
    margin-<?php echo $tpbannerfloat; ?>:10px;        
}
#tpmod-banner #mod_search_searchword {
    border: none;
    margin: 7px 50px 0 0;
    width: 150px;
    background: none;

  

}
#tpmod-banner #mod_search_searchword:hover,
#tpmod-banner #mod_search_searchword:focus {
}
/* ===== BLOCK TPMENU ===== */
#tpblock-tpmenu {
    padding:10px ;

    }

#tpmod-breadcrumb {
    height: 48px;
    background:url(../images/bgbreadcrumb1.png) no-repeat left;
    margin-left:-8px;
    margin-right:2px;
    margin-top:-<?php echo $tpgutter + 10; ?>px;
    margin-bottom:<?php echo $tpgutter - 5; ?>px;
}
.tpmod-breadcrumb-inner {
    height: 47px;
    padding: 1px 0 0 <?php echo $tpgutter * 2; ?>px ;
    background:url(../images/bgbreadcrumb1.png) no-repeat right;
    margin-right:-10px;

}
.tpmod-breadcrumb-inner  * {
    color: #FFF;
}
.tpmod-breadcrumb-inner-inner {
    padding-top: 10px;
}
.tpmod-breadcrumb-inner-inner .breadcrumbs {
    margin-top: -5px;
}
/* ===== BLOCK TOP ===== */
#tpblock-top {
    margin: 0 auto;
}
#tpblock-top-inner {

     margin: 0 auto;

}
#tpblock-top-inner-inner{
}
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

/*# tpblock-top hack for mootab*/
#tpblock-top  #mootabs_handles4,
#tpblock-top  #mootabs_handles3,
#tpblock-top  #mootabs_handles2,
#tpblock-top  #mootabs_handles1
 {
        background-image: none;
        border: none;
        background: #afacac;
        padding: 2px 2px 3px 2px;
        -moz-border-radius: 2px;
        -webkit-border-radius: 2px;                                                        
        

}
.mootabs {
    background: #e7e7e7; 
    -moz-border-radius: 2px;
    -webkit-border-radius: 2px;   
    
}
#tpblock-top  #mootabs_handles4 {
        text-align: center;
}
#tpblock-top .mootabs_innerbox,
#tpblock-top .mootabs_innerbox * {
    text-align: left;
    padding: 0px;        

}
#tpblock-top .mootabs_buttons1 span,
#tpblock-top .mootabs_buttons2 span,
#tpblock-top .mootabs_buttons3 span{
    padding: 2px 4px;
    color:#fff ;
    font-size: 11px;
    letter-spacing: 0;        
  }
#tpblock-top .mootabs_buttons1 span.active,
#tpblock-top .mootabs_buttons2 span.active,
#tpblock-top .mootabs_buttons3 span.active {
    -moz-border-radius: 2px;
    -webkit-border-radius: 2px;    
    color:#fff;        
}

.mootabs_buttons1 span.active, .buttons span:hover,
.mootabs_buttons2 span.active, .buttons span:hover,
.mootabs_buttons3 span.active, .buttons span:hover
{background:#c3c3c3;color:#fff;}

/*# tpblock-top hack for accordion*/
.tpaccordiontoggler, .tpaccordiontoggler-active {
	background:url(../images/bgaccordion.png) #CCC 100% 42px;}
 
#tpblock-top div.moduletable-box,
#tpblock-top div.moduletable-boxred,
#tpblock-top div.moduletable-boxblue,
#tpblock-top div.moduletable-badgehot,
#tpblock-top div.moduletable-badgenew,
#tpblock-top div.moduletable-box,
#tpblock-top div.moduletable h3,
#tpblock-top div.moduletable_menu h3,
#tpblock-top div.moduletable-red h3,
#tpblock-top div.moduletable-blue h3,
#tpblock-top div.moduletable-box h3,
#tpblock-top div.moduletable-boxred h3,
#tpblock-top div.moduletable-boxblue h3,
#tpblock-top div.moduletable-badgehot h3,
#tpblock-top div.moduletable-box 
 {
    text-align: left;
}
#tpblock-top div.moduletable-box,
#tpblock-top div.moduletable-boxred,
#tpblock-top div.moduletable-boxblue {
    margin-bottom: <?php echo $tpgutter; ?>px;
}
/*# tpblock-top hack for too much padding*/
#tpblock-top div.moduletable_inner {
    padding-bottom: 0;
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
	float:right;
	}
#tpmod-left {
	float:right;
    background: #FFF;
    padding:<?php echo $tpgutter; ?>px;
    border: 1px solid #c3c3c3;
    }
/* ===== BLOCK RIGHT ===== */
#tpwrapper-right {
	width:<?php echo $tpwidth_wrapper_right; ?>px;
	float:left
	}
#tpwrapper-right-inner {
    padding:<?php echo $tpgutter; ?>px;
    border: 1px solid #c3c3c3;
 }
#tpwrapper-inner-left {
	width:<?php echo $tpwidth_tpwrapper_inner_left; ?>px;
	float:left;
	}
#tpwrapper-inner-right {
	width:<?php echo $tpwidth_tpwrapper_inner_right - $tpgutter; ?>px;
	float:right;}
#tpmod-right {
    padding-left:<?php echo $tpgutter; ?>px ;
	float:right;
    border-left: 1px solid #CCC;}
/* ===== BLOCK TOPBODY ===== */

#tpblock-topbody {
    background: #000;
    padding-top: <?php echo $tpgutter; ?>px;
    padding-bottom: <?php echo $tpgutter - 10; ?>px;
    margin-bottom: <?php echo $tpgutter; ?>px;
    }
.tpblock-topbody-inner {
    padding-left:<?php echo $tpgutter ; ?>px ;
    padding-right:<?php echo $tpgutter ; ?>px ;

}
#tpmod-user1 {
	float:left;
	width: <?php echo $tpwidth_mod_user1; ?>px;
}
#tpmod-user2 {
	float:right;
	width: <?php echo $tpwidth_mod_user2; ?>px;
}
 #tpmod-user1 *,
 #tpmod-user2 * {
    text-align: center;
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
#tpblock-bot {
    background: #FFF;
    padding:<?php echo $tpgutter-1; ?>px;
    border: 1px solid #C3C3C3;
}

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
	width:50%;
    text-align: left;}
#tpblock-footerright {
	float:right;
	width:50%;
	}
/* ===== BLOCK FOOTERRIGHT ===== */

.tpmobile-switch {
    background: url("../images/bgmobile.png") center bottom;
    width: auto;
    text-align: center;
    height: 70px;
    padding-top: 10px;
    
}

/* ===== MODULES HACK ===== */

#tpblock-left div.moduletable-box,
#tpblock-left div.moduletable-nobox,
#tpblock-left div.moduletable-boxblue,
#tpblock-left div.moduletable-boxred,
#tpblock-left div.moduletable-badgehot,
#tpblock-left div.moduletable-badgenew {
	margin-bottom:<?php echo $tpgutter; ?>px;
	}

#tpmod-right div.moduletable-box,
#tpmod-right div.moduletable-nobox,
#tpmod-right div.moduletable-boxblue,
#tpmod-right div.moduletable-boxred,
#tpmod-right div.moduletable-badgehot,
#tpmod-right div.moduletable-badgenew {
	margin-bottom:<?php echo $tpgutter; ?>px;
	}

.moduletable_inner {
	padding-bottom:<?php echo $tpgutter; ?>px;
}
#tpblock-midtopbody div.moduletable-nobox {
    padding-bottom: 0;
}
/* ===== COM CONTENT OVERRIDE DATE ===== */
.tp-tittle-date {
    background: url("../images/bgtitledate.png") left top no-repeat;
	width:100px;
    height: 123px;
	float:left;
    color: #FFF;
    margin-left: -26px;
    margin-right: <?php echo $tpgutter; ?>px;
    overflow: hidden;
    display: block;
    font-family:Arial,Helvetica,FreeSans,"Liberation Sans","Nimbus Sans L",sans-serif;
    
}
.tp-tittle-date-date {
    font-size: 45px;
    display: block;
    padding-left: 20px;
    padding-top: 30px;
    font-weight: 700;
    
}
.tp-tittle-date-month {
    font-size: 24px;
    text-transform: uppercase;
    display: block;
    font-weight: 400;
     padding-left: 20px;
     padding-top: 12px;
}
.tp-tittle-date-date .cufon{
    padding-top: 0;
    margin-top: -10px;
}
.tp-tittle-date-month .cufon {
    padding-top: 0;
    margin-top: -20px;
}
.tp-authorline {
    letter-spacing: 0;
}
.tp-authorline img {
    float: right;
}
.leading_article .tp-tittle-date {
    margin-left: -20px;
}
a.contentpagetitle:link,
a.contentpagetitle:visited {
    color: #111111;


}
a.contentpagetitle:hover {
    color: #333;
}

.leading_article{ 
    margin-left: -<?php echo $tpgutter ; ?>px;
    margin-right: -5px;  
}
/*mod tpnewsticker*/
ul#tpmoostick {
    margin-top: 8px;
}


/*HACK FOR MODULES.CSS*/
/* suffix -badgehot -badgenew -boxred -boxblue -> default*/

div.moduletable-boxred h3 ,
div.moduletable-boxblue h3{
	border-bottom:none;
    height: 50px;
    padding-left:0;
    color: #FFF;
    
    margin-top:0;
    margin-bottom:0;
    }

div.moduletable-boxred h3 .strong_moduletable_title,
div.moduletable-boblue h3 .strong_moduletable_title  {
    font-size: 11px;
    color:#FFF;
    text-transform: uppercase;
}

div.moduletable-boxred,
div.moduletable-boxblue
{
    background:url(../images/bgcornershadow.png) #AE0C00 no-repeat top right;
    padding: <?php echo $tpgutter; ?>px ;

}
div.moduletable-boxred,
div.moduletable-boxred *,
div.moduletable-boxblue,
div.moduletable-boxblue * {
    color: #FFF;
}
div.moduletable-boxblue  {
    background-color:#56699B;
    }
	

div.moduletable-badgehot h3 ,
div.moduletable-badgenew h3{
	border-bottom:none;
    background:url(../images/badgehot-default.png) no-repeat top left;
    height: 45px;
    padding: 10px;
    padding: 5px 0 0 50px;
    color: #111;
    margin-top: 0;
    margin-bottom: 0;  
    }
div.moduletable-badgenew h3 {
    background:url(../images/badgenew-default.png) no-repeat top left;
    }
div.moduletable-badgehot h3 .strong_moduletable_title,
div.moduletable-badgenew h3 .strong_moduletable_title {
    font-size: 11px;
    color:#666;
    text-transform: uppercase;
}

div.moduletable-badgenew {}
div.moduletable-badgenew h3 {}
 
div.moduletable-nobox {
	padding:0 0 <?php echo $tpgutter ; ?>px 0;
	}



/* suffix -badgehot -badgenew -> for tpmod-left and tpmod-right*/
#tpmod-right div.moduletable-badgehot h3 ,
#tpmod-left div.moduletable-badgehot h3 ,
#tpmod-right div.moduletable-badgenew h3,
#tpmod-left div.moduletable-badgenew h3{
	border-bottom:none;
    background:url(../images/badgehot.png) no-repeat top right;
    height: 70px;
    margin-top:-<?php echo $tpgutter; ?>px;
    margin-left:-<?php echo $tpgutter + 1; ?>px;
    margin-right:-28px;
    margin-bottom:-<?php echo $tpgutter; ?>px;
    padding: 10px;
    padding-left:<?php echo $tpgutter; ?>px;
    color: #FFF;
    }
#tpmod-right div.moduletable-badgenew h3,
#tpmod-left div.moduletable-badgenew h3 {
    background:url(../images/badgenew.png) no-repeat top right;
    }
#tpmod-right div.moduletable-badgehot h3 .strong_moduletable_title,
#tpmod-left div.moduletable-badgehot h3 .strong_moduletable_title,
#tpmod-right div.moduletable-badgenew h3 .strong_moduletable_title,
#tpmod-left div.moduletable-badgenew h3 .strong_moduletable_title  {
    font-size: 11px;
    color:#FFF;
    text-transform: uppercase;
}
/*suffix boxred - boxblue -> for tpmod-left and tpmod-right*/
#tpmod-right div.moduletable-boxred h3 ,
#tpmod-left div.moduletable-boxred h3 ,
#tpmod-right div.moduletable-boxblue h3,
#tpmod-left div.moduletable-boxblue h3{
	border-bottom:none;
    height: 50px;
    padding-left: 0px;
    color: #FFF;
    
    margin-top:0;
    margin-bottom:0;
    }

#tpmod-right div.moduletable-boxred h3 .strong_moduletable_title,
#tpmod-left div.moduletable-boxred h3 .strong_moduletable_title,
#tpmod-right div.moduletable-boxblue h3 .strong_moduletable_title,
#tpmod-left div.moduletable-boxblue h3 .strong_moduletable_title  {
    font-size: 11px;
    color:#FFF;
    text-transform: uppercase;
}

#tpmod-right div.moduletable-boxred,
#tpmod-left div.moduletable-boxred,
#tpmod-right div.moduletable-boxblue,
#tpmod-left div.moduletable-boxblue  {
    background:url(../images/bgcornershadow.png) #AE0C00 no-repeat top right;
    margin-left:-<?php echo $tpgutter + 1; ?>px;
    margin-right:-24px;
    margin-bottom:<?php echo $tpgutter * 2; ?>px;
    padding: <?php echo $tpgutter; ?>px ;

}
#tpmod-right div.moduletable-boxred,
#tpmod-left div.moduletable-boxred,
#tpmod-right div.moduletable-boxred *,
#tpmod-left div.moduletable-boxred *,
#tpmod-right div.moduletable-boxblue,
#tpmod-left div.moduletable-boxblue,
#tpmod-right div.moduletable-boxblue *,
#tpmod-left div.moduletable-boxblue * {
    color: #FFF;
}
#tpmod-right div.moduletable-boxblue ,
#tpmod-left div.moduletable-boxblue  {
    background-color:#56699B;
    }
    
    
    
#tpblock-topbody h3 {
    border-bottom: none;
}
#tpblock-topbody * {
    color: #bbb;
}
/*minifp hack*/
span.minifp-anotherlinks {
    background: none;
    margin-bottom: 5px;
    padding-left: 0;
}
li.minifp {
    background:url(../images/star.gif) no-repeat 0 10px;
    border-bottom: 1px solid #ccc;display: block;
    padding: 5px 0;
    
}
li.minifp a {
    margin-left: 15px;
}
span.minifp-date {
    background: #cc0000;
    display:block;
    padding: 3px 4px;
    color:#FFF;
    float: left;
    margin-right: 5px;
}
.minifp-introtitle {
    display: block;
    padding: 3px 5px;
    border-top:3px solid #666;
    border-bottom:1px solid #CCC;
    margin: 5px 0;
}
td.minifp {
    border-bottom:1px solid #CCC;
    padding-top: 5px;
}
#tpmod-user11 div.moduletable_inner img.nomp,
#tpmod-user12 div.moduletable_inner img.nomp,
#tpmod-user13 div.moduletable_inner img.nomp, 
#tpmod-user14 div.moduletable_inner img.nomp  {
    margin: 0;
    padding: 0;
}
a.minifp-full-link, a:visited.minifp-full-link, a:active.minifp-full-link, a:link.minifp-full-link {
	line-height:24px;
	font-weight:bold;
	text-transform:uppercase;
	font-size:90%;
	background:#333333;
	color:#FFFFFF;
	padding:2px 5px;
	letter-spacing:0px;
}

/*IE7 hack */
<?php
$http_user_agent = ( !empty( $_GET['hua'] ) ) ? $_GET['hua'] : null;
$http_user_agent = urldecode( $http_user_agent );
if(strpos(strtolower($http_user_agent), 'msie 7') !== false)
{
?>
#tpmod-left div.moduletable-badgehot h3 ,
#tpmod-left div.moduletable-badgenew h3

{
    width:<?php echo $tpwidth_blockleft - $tpgutter + 2; ?>px;

}
#tpmod-right div.moduletable-badgehot h3 ,
#tpmod-right div.moduletable-badgenew h3

{ width:<?php echo $tpwidth_tpwrapper_inner_right - $tpgutter + 3; ?>px;

}

#tpmod-right div.moduletable-boxred ,
#tpmod-right div.moduletable-boxblue {
    width:<?php echo $tpwidth_tpwrapper_inner_right - ($tpgutter * 1.4) ; ?>px;

} 
#tpblock-mainbody .leading_article {
    position: relative;
    width:<?php echo $tpwidth_tpwrapper_inner_left + $tpgutter ; ?>px;
    margin-left: -<?php echo $tpgutter;?> px;
}
#tpblock-mainbody .tp-tittle-date {
    position: relative;
    margin-left: -28px;
}
#tpblock-mainbody .leading_article .tp-tittle-date {

    margin-left: -23px;
}
#tpmod-breadcrumb ul#tpmoostick {
    line-height: 30px;
    padding-bottom: 10px;
    background-position: 0 8px;
}

#tpmod-breadcrumb span.pathway { 
	line-height:30px;
	background:url(../images/home.gif) no-repeat 0 10px ;
	}
<?php
}
?>