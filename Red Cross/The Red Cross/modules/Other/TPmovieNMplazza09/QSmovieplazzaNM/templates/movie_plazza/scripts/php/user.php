<?php
defined('_JEXEC') or die('Restricted access');
/* 
=================================================
# Filename : user.php
# Description : User module definition
# Author : TemplatePlazza
# Author Url : http://www.templateplazza.com
# Copyright (C) 2009 TemplatePlazza.com
# All rights reserved.
=================================================
*/

$tp = new JObject;
$tp->left   = $this->countModules('left');
$tp->beforeleft  = $this->countModules('beforeleft');
$tp->afterleft   = $this->countModules('afterleft');
$tp->right   = $this->countModules('right');
$tp->beforeright   = $this->countModules('beforeright');
$tp->afterright   = $this->countModules('afterright');
$tp->cpanel  = $this->countModules('cpanel');
$tp->inset   = $this->countModules('inset');
$tp->header   = $this->countModules('header');
$tp->banner  = $this->countModules('banner');
$tp->advert1  = $this->countModules('advert1');
$tp->advert2  = $this->countModules('advert2');
$tp->advert3  = $this->countModules('advert3');
$tp->advert4  = $this->countModules('advert4');
$tp->breadcrumb  = $this->countModules('breadcrumb');
$tp->user1  = $this->countModules('user1');
$tp->user2  = $this->countModules('user2');
$tp->user3  = $this->countModules('user3');
$tp->user4  = $this->countModules('user4');
$tp->user5  = $this->countModules('user5');
$tp->user6  = $this->countModules('user6');
$tp->user8  = $this->countModules('user8');
$tp->user11 = $this->countModules('user11');
$tp->user12 = $this->countModules('user12');
$tp->user13 = $this->countModules('user13');
$tp->user14 = $this->countModules('user14');
$tp->user21 = $this->countModules('user21');
$tp->user22 = $this->countModules('user22');
$tp->user23 = $this->countModules('user23');
$tp->user24 = $this->countModules('user24');
$tp->mobiletop = $this->countModules('mobiletop');
$tp->mobilebottom = $this->countModules('mobilebottom');

?>