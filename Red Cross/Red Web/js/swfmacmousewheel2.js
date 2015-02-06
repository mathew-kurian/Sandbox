/**
 * SWFMacMouseWheel v2.0: Mac Mouse Wheel functionality in flash - http://blog.pixelbreaker.com/
 *
 * SWFMacMouseWheel is (c) 2007 Gabriel Bucknall and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Dependencies: 
 * SWFObject v2.0 rc2 <http://code.google.com/p/swfobject/>
 * Copyright (c) 2007 Geoff Stearns, Michael Williams, and Bobby van der Sluis
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 *
 * Browser detect part from http://www.quirksmode.org/js/detect.html
 *
 */
var Browser={init:function(){this.name=this.searchString(this.dataBrowser)||"unknown"},searchString:function(D){for(var A=0;A<D.length;A++){var B=D[A].string;var C=D[A].prop;this.versionSearchString=D[A].versionSearch||D[A].identity;if(B){if(B.indexOf(D[A].subString)!=-1){return D[A].identity}}else{if(C){return D[A].identity}}}},dataBrowser:[{string:navigator.vendor,subString:"Apple",identity:"Safari"}]};Browser.init();var swfmacmousewheel=function(){if(!swfobject)return null;var u=navigator.userAgent.toLowerCase();var p=navigator.platform.toLowerCase();var d=p?/mac/.test(p):/mac/.test(u);if(Browser.name!="Safari"&&!d)return{registerObject:function(){}};var k=[];var r=function(event){var o=0;if(event.wheelDelta){o=event.wheelDelta/120;if(window.opera)o= -o;if(Browser.name=="Safari")o=o*3;}else if(event.detail){o= -event.detail;}if(event.preventDefault)event.preventDefault();return o;};var l=function(event){var o=r(event);var c;for(var i=0;i<k.length;i++){c=swfobject.getObjectById(k[i]);if(typeof(c.externalMouseEvent)=='function')c.externalMouseEvent(o);}};return{registerObject:function(m){k[k.length]=m;if(window.addEventListener)window.addEventListener('DOMMouseScroll',l,false);window.onmousewheel=document.onmousewheel=l;}};}();