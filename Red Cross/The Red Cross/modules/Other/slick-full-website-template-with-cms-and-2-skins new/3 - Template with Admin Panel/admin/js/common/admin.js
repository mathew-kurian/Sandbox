/*
	OXYLUS Developement web framweork
	copyright (c) 2002-2005 OXYLUS Developement

	$Id: common.js,v 0.0.1 10/05/2005 20:38:15 Exp $

	Note: tested in IE 5.0 , MOZILLA FIREFOX, OPERA

	contact:
		www.oxylus.ro
		devel@oxylus.ro

		office@oxyls.ro

	ALL THIS CODE IS THE PROPERTY OF OXYLUS DEVELOPEMENT. YOU CAN'T USE ANY OF THIS CODE WITHOUT
	A WRITTEN ACCORD BETWEEN YOU AND OXYLUS DEVELOPEMENT. ALL ILLEGAL USES OF CODE WILL BE TREATED
	ACCORDING THE LAWS FROM YOUR COUNTRY.

	THANK YOU FOR YOUR UNDERSTANDING.
	FOR MORE INFORMATION PLEASE CONTACT US AT: office@oxylus.ro
*/


/**
* detect if the browser is Internet Explorer
*
* @return boolean
*
* @access public
*/
function isIE() {
  return (navigator.userAgent.indexOf("MSIE") > -1);
}

/**
* detect if the browser is Gecko Compatible
*
* @return boolean
*
* @access public
*/
function isGecko() {
  return (navigator.userAgent.indexOf("Gecko") > -1);
}

/**
* detect if the browser is Mozilla / Mozilla Firebird / Firefox
*
* @return boolean
*
* @access public
*/
function isMozilla() {
	return (navigator.userAgent.toLowerCase().indexOf('gecko')!=-1) ? true : false;
}

/**
* detect if the browser is Mozilla Firefox
*
* @return boolean
*
* @access public
*/
function isFirefox() {
	return ( userAgent != null && userAgent.indexOf( "Firefox/" ) != -1 );
}

/**
* show password field value
*
* @param object pass the password field object
* @param boolean show private, used to revert the field type back to password
*
* @return void
*
* @access private
*/
function ShowPassword(pass,show) {
	show.style.display='inline';
	show.value=pass.value;
	pass.style.display='none';
	show.focus();
}
function HidePassword(pass,show) {
	show.style.display='none';
	pass.value=show.value;
	pass.style.display='inline';
	show.blur();
	pass.focus();
}

var bites = document.cookie.split("; ");

function getCookie(name) { 
for (var i=0; i < bites.length; i++) {
  nextbite = bites[i].split("=");
  if (nextbite[0] == name)
	return unescape(nextbite[1]);
}
return null;
}

var today = new Date();
var expiry = new Date(today.getTime() + 60 * 60 * 24 * 1000); // plus 1000 days

function setCookie(name, value) {
if (value != null && value != "")
  document.cookie=name + "=" + escape(value) + "; expires=" + expiry.toGMTString();
bites = document.cookie.split("; ");
}



