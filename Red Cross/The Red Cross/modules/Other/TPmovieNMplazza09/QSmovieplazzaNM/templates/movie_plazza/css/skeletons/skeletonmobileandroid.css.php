/* 
=================================================
# Filename : skeletonmobileandroid.css.php
# Description : Sepecific CSS rules for android browser
# Author : TemplatePlazza
# Author Url : http://www.templateplazza.com
# Copyright (C) 2009 TemplatePlazza.com
# All rights reserved.
=================================================
*/
/* ======= RESET  ======= */
html, body, div, span, applet, object, iframe, blockquote, pre,
a, abbr, acronym, address, big, cite, code,
del, dfn, em, font, ins, kbd, q, s, samp,
small, strike, strong, sub, sup, tt, var,
b, u, i, center,
dl, dt, dd, ul,ol,li,
fieldset, form, label, legend,
table, caption, tbody, tfoot, thead, tr, th {
	margin: 0;
	padding: 0;
	border: 0;
	outline: 0;
	font-size: 100%;
	vertical-align: baseline;
	background: transparent;
}
a {	
	outline-width: 0; 
	} /* remove firefox image link outline */

ol, ul {

}
body {
	line-height:1;}
p {
	margin:1em 0;}
img {
	border:none;}
h1, h2, h3, h4, h5, h6 {
	font-weight:700;
	}
/* ======= GENERAL  ======= */
body {
	font: 13px Helvetica,sans-serif;
    line-height: 150%;
	-webkit-text-size-adjust: none;
    background: url("../images/bgbodymobile.png");}

li {
	font-size: 12px;
	color: #555;
}
h1,h2,h3 {
	font-size:18px;}
h4,h5 {
	font-size:13px;}
a {
	text-decoration: none;
}
a:link {
	color:#551A8B;}
a:visited {
	color:#666666;}
input {
	max-width: 96%;
}

input,
textarea {
	border:1px solid #CCCCCC;
	-webkit-border-radius: 5px;}
iframe {
	max-width: 100% !important;
	height: auto !important;
}

code {
	font-family: Courier, "Courier New", mono;
	color: red;
}

blockquote {
	padding: 10px;
	font-size: 12px;
	text-align: left;
	margin: 5px 1px;
}
.clrfix {
	clear: both; 
}
	
#tp-sk-iphone-wrapper {
}
	
/* ======= BLOCK HEADER  ======= */
#tp-sk-iphone-header, #tp-sk-iphone-navpage-header,  #tp-sk-iphone-banner-header {
	position: relative;
	top: 0;
	left: 0;
	display: block;
	width: 100%;
	height: 44px;
	background: url("../images/bgmobile.png") repeat-x center top;
	z-index: 200;
	}
 #tp-sk-iphone-banner-header {
    background: url("../images/bgmobilenavpage.png");
    height: auto;
    padding: 0 0 10px 0;
 }
 #tp-sk-iphone-navpage-header {
	height: 45px;
    background: url("../images/bgmobile_off.png") repeat-x center top;
	}
#tp-sk-iphone-header h1,
 #tp-sk-iphone-navpage-header h1 {
	color: #fff;
	text-shadow: rgba(0, 0, 0, 0.6) 0px -1px 0px;
	font-size: 20px;
	text-align: center;
	line-height: 44px;
	margin:0;
	padding:0;
}
#tp-sk-iphone-header-logo ,
#tp-sk-iphone-header-logo-navpage{
    background: #252525;
    display: block;
    width: 30px;
    height:30px;
    float: left;
    -webkit-border-radius:5px;
    margin: 6px 10px 6px 6px;
}
#tp-sk-iphone-header-logo img,
#tp-sk-iphone-header-logo-navpage img {
    width: 30px;
    height: 30px;
}
#tp-sk-iphone-header-text,
#tp-sk-iphone-header-text-navpage {
    float: left;
}
#tp-sk-iphone-header-text h1 a,
#tp-sk-iphone-header-text-navpage h1 a {
    color: #FFFFFF;
}
#tp-sk-iphone-header-menu a,
#tp-sk-iphone-header-menu-close a,
#tp-sk-iphone-jbutton a
  {
    background-image: url("../images/mobile_button.png");
    text-shadow: rgba(0, 0, 0, 0.6) 0px -1px 0px;
    color: #ffffff;    
    display: block;
    width: 46px;
    height:18px;
    float: right;
    -webkit-border-radius:5px;
    margin: 6px 10px;
    padding: 5px;
    text-align: center;
    font-size: 12px;
    font-weight: bold;
    border: 1px solid #41546F;
}

#tp-sk-iphone-header-menu-close a {
    background-image: url("../images/mobile_button_dark.png");
    border: 1px solid #161718;  
}
/* ======= BLOCK BANNER  ======= */
#tp-sk-mod_banner  {
    clear: left;
	text-align:center;
	padding:10px 0 0 0;}

#tp-sk-mod_banner img {
	width:94%;
    
}
/* ======= BLOCK USER1  ======= */
.tp-sk-mod-user1-2 {
	padding:10px;}
	
/* ======= BLOCK NAVPAGE + SEARCH BOX  ======= */

#tp-sk-iphone-navpage-wrapper {
    width: 100%;
    background-image: url("../images/bgmobilenavpage.png");
    position: absolute;
    top:0;
    left:0;
    /* opacity:0.8;*/
    z-index:999;
    height:700px;
    display: none;
}
.current {
	display: block;
}

#tp-sk-iphone-navpage-wrapper div:hover {
    
    
}
#tp-sk-iphone-navpage-inner {
    padding:15px;
}
#tp-sk-iphone-navpage-inner ul {
	margin: 0 auto;
	list-style: none;
	display: block;
}

#tp-sk-iphone-navpage-inner li {
	float: left;
    margin-right: 8px;
    margin-left: 7px;
}
#tp-sk-iphone-navpage-inner li img {
    width: 57px;
    height: 57px;
}
#tp-sk-iphone-navpage-inner span {
	color: #bbb;
	font-weight: bold;
	font-size: 11px;
	text-decoration: none;
    text-align: center;
    display: block;
    padding-top: 5px;
    width: 57px;
    line-height: 11px;
    height: 11px;
    margin-bottom: 15px;
    overflow: hidden;
}



#tp-sk-iphone-navpage-inner .inputbox {
    width:93%;
    -webkit-border-radius: 5px;
    height: 27px;
    padding: 0 10px;
    font-size: 13px;
    margin-bottom: 20px;
    color: #BBB;
    
    
}
/* ======= BLOCK MAINBODY / CONTAINER  ======= */
.tp-sk-iphone-container {
}

.tp-sk-iphone-content {
	margin:10px;
	border:1px solid #AAAAAA;
	background:#fff;
	-webkit-border-radius:10px;
	-moz-border-radius:10px;
	
}
.tp-sk-iphone-content_inner {
    padding: 10px;
 }

.tp-sk-iphone-content li.wrprounded {
	background:#f3f3f3;
	margin:0 10px 0 0;
	margin-bottom:10px;
	width:100%;
	-webkit-border-radius:5px;
	-moz-border-radius:5px;
	overflow: hidden;
	border:1px solid #CCCCCC;


	
}

.tp-sk-iphone-content li {
	padding:0.5em 0;
	margin:0 0 0 20px;
	}
.tp-sk-iphone-content li.wrprounded {
	padding:10px 0;
	}

.tp-sk-iphone-content li.wrprounded p, 
.tp-sk-iphone-content li.wrprounded h1,
.tp-sk-iphone-content li.wrprounded h2,
.tp-sk-iphone-content li.wrprounded h3,
.tp-sk-iphone-content li.wrprounded h4,
.tp-sk-iphone-content li.wrprounded h5,
.tp-sk-iphone-content li.wrprounded span
{padding: 0 10px;
}

/* ======= BLOCK FOOTER  ======= */
#tp-sk-iphone-footer {
	display: block;
	width: 100%;
	background: url("../images/bgmobile.png") center bottom;
	font-size:0.9em;
	line-height:30px;
    height: 30px;
	color:#fff;
    margin: auto 0;
	}
 #tp-sk-iphone-footer-txt {
    background: url("../images/logofooter.png") no-repeat left top;
    padding-left: 25px;
    width:280px;
    text-align: left;    
 }
/* ======= COM_CONTENT OVERRIDING  ======= */
/* ----- default.php ----- */
.tp-sk-all-blog-more {
	background:#252525;
	margin:-10px -10px 10px -10px;
	width: auto;
	border-bottom:1px solid #CCCCCC;
    color: #FFFFFF;
	}
 .tp-sk-all-blog-more li {
    list-style: none;
    margin: 0;
    padding: 0;
    line-height: 30px;
 }
.tp-sk-all-blog-more a.blogsection {
    color: #FFFFFF;
    border-bottom:1px solid #222222;
    background: url("../images/iphone-bgitem-shadow.png") repeat-x bottom left;
    
 }
.tp-sk-all-blog-more-inner div{
	padding:10px;}
.tp-sk-all-blog-more-inner div {
	font-size:18px;
	margin-bottom:10px;
	}
.tp-sk-all-blog-more-inner li a {
	display:block;
	padding:0 10px;}
.tp-sk-all-pagination {
	background:#f3f3f3;
	margin:0 10px 0 0;
	margin-bottom:10px;
	width:100%;
	-webkit-border-radius:5px;
	-moz-border-radius:5px;
	}
.tp-sk-all-pagination-inner {
	padding:10px;}
.tp-sk-all-pagination-inner br {
	display:none;}
span.pagination a,
.pagination span{
	padding:3px 5px;
	margin:0 3px;
	font-size:11px;
	background:#CCC;
	color:#FFF;
	-webkit-border-radius:3px;
	-moz-border-radius:3px;}


/* ----- default_item.php ------ */
/* wrapper */
.tp-sk-all-wrp {
	width: auto;
	border-bottom:1px solid #CCCCCC;
    min-height: 50px;
    opacity:0.8;
    margin:0 -10px 10px -10px;
    padding-right: 10px;
    background: url("../images/bg_tp-sk-all-wrp.png") bottom left no-repeat;}	
    
.tp-sk-all-wrp-inner {
    width: auto;
    background: url("../images/arrowiphone.png") no-repeat 100% 50%;}

.tp-sk-all-wrp-inner a {
	font-weight:700;}

/* date */
.tp-sk-all-date-wrp {
	width:75px;
	float:left;
	margin:0 0 0 0;
  
	
}
.tp-sk-all-date-date {
	font-size:30px;
	text-align:center;
	padding:3px;
	color:#ccc;
	text-shadow: rgba(0, 0, 0, 0.6) 0px -1px 0px;
    float: left;
    margin: 8px 0 8px 5px;
    }
.tp-sk-all-date-month,
 .tp-sk-all-date-year {
	text-align:center;
	font-size:11px;
	color:#666;
	text-transform:uppercase;
	padding:3px 0 0 0;
    margin: 0;
    float: left;
    height: 9px;
	}

/* title */
.tp-sk-all-tittle h1{
	font-size:18px;
	margin:0 0 2px 0;
    text-shadow: rgba(255, 255, 255, 0.3) 0px -1px 0;
    letter-spacing: -1px;
    padding-right: 32px;
    line-height: 100%;
	}
div.tp-sk-all-author *,
div.tp-sk-all-author p {

	}
div.tp-sk-all-section {
	padding-bottom: 10px;
	}

.small {
	font-size:11px;
	padding:5px 0;}
.bold {
	font-weight:700;}
.italic {
	font-style:italic;}

/* ======= MODULES  ======= */
div.moduletable h3 {
	padding:5px 0 10px 0;
	border-bottom:1px solid #CCCCCC;
	margin:0 10px 0 0;
	margin-bottom:10px;
	width:100%;
}
/* ======= SYSTEM MESSAGE  ======= */
dt.message,
dt.notice {
	font-size:18px;
	font-weight:700;
	color:#cc0000;}

/* ======= MOBILE SWITCH BUTTON  ======= */
.tpmobile-switch {
    background: url("../images/bgmobile.png") center bottom;
    width: auto;
    text-align: center;
    height: 70px; 
}

/* ======= COM CONTENT ======= */
.tp-sk-iphone-content_inner .componentheading,
.tp-sk-iphone-content_inner .contentheading {
    margin: 0 -10px 10px -10px;
    border-bottom: 1px solid #D6D6D6;
    padding: 10px;
    background: #fff url("../images/iphone-bgitem-shadow.png") bottom repeat-x;
    font-size:18px;
    font-weight: 700;
    
} 
.tp-sk-authorbar {
    display: block;
    margin: -10px -10px 10px -10px;
    border-bottom: 1px solid #EEE;
    padding:10px 10px 5px 10px;
    height: 25px;
    background:#F0F0F0;
}
/* ======= COM CONTACT ======= */

.tp-sk-contactform-wrapper {
    margin-top: 10px;
}
.tp-sk-contactform {
    margin: 0 -10px 10px -10px;
    border-top: 1px solid #D6D6D6;
    padding:10px 10px 0 10px;
}
.tp-sk-contactform input,
.tp-sk-contactform textarea {
    border: none;
    font: 16px Helvetica,sans-serif;
    background: #fff url("../images/spacer.gif");
    color: #CCCCCC;  
}
#tp-sk-iphone-navpage-wrapper input{
   background: url("../images/iphone-search-bg.png") no-repeat 100% 50% #FFF; 
}
.tp-sk-contact-img {
    float: left; margin-right: 10px;
    }
.tp-sk-jbutton-wrapper {
    display: block;
    margin: -10px -10px 10px -10px;
    border-bottom: 1px solid #D6D6D6;
    padding:10px 10px 5px 10px;
    height: 35px;
    background: #cccccc;
}
.tp-sk-jbutton-wrapper a {
    background-image: url("../images/mobile_button.png");
    text-shadow: rgba(0, 0, 0, 0.6) 0px -1px 0px;
    color: #ffffff;    
    display: block;
    width: 56px;
    height:18px;
    float: left;
    -webkit-border-radius:5px;
    margin: 0 10px 0 0;
    padding: 5px;
    text-align: center;
    font-size: 12px;
    font-weight: bold;
    border: 1px solid #41546F;
}
/* ===== JOOMLA =====*/
#limit  {
    margin:10px 0;
}
td.sectiontableheader a {
	color:#666;}
.sectiontableheader td,
td.sectiontableheader {
	font-weight:700;
	padding:5px;
	color:#666;
	margin-bottom:5px;
	background:#DDD;
	}
td.sectiontableentry1 {
	padding:5px;
	text-align:left;
	border-bottom:1px solid #c4c4c4;
}
td.sectiontableentry2 {
	padding:5px;
	text-align:left;
	border-bottom:1px solid #c4c4c4;
}
.sectiontableentry1 td {
	padding:5px 5px 10px 5px;
	text-align:left;
	background: #f0f0f0;
}
.sectiontableentry2 td{
	padding:5px 5px 10px 5px;
	text-align:left;
}
.sectiontableentry1 label{
	padding-left:5px;
	text-align:left;}
.sectiontableentry2 label {
	padding-left:5px;
	text-align:left;}