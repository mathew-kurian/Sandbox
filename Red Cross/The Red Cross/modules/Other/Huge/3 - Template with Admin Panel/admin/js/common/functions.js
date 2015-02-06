/*
	OXYLUS Developement web framweork
	copyright (c) 2002-2005 OXYLUS Developement

	$Id: functions.js,v 0.0.1 10/05/2005 20:38:15 Exp $

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

 function PageQuery(q) {
if(q.length > 1) this.q = q.substring(1, q.length);
else this.q = null;
this.keyValuePairs = new Array();
if(q) {
for(var i=0; i < this.q.split("&").length; i++) {
this.keyValuePairs[i] = this.q.split("&")[i];
}
}
this.getKeyValuePairs = function() { return this.keyValuePairs; }
this.getValue = function(s) {
for(var j=0; j < this.keyValuePairs.length; j++) {
if(this.keyValuePairs[j].split("=")[0] == s)
return this.keyValuePairs[j].split("=")[1];
}
return false;
}
this.getParameters = function() {
var a = new Array(this.getLength());
for(var j=0; j < this.keyValuePairs.length; j++) {
a[j] = this.keyValuePairs[j].split("=")[0];
}
return a;
}
this.getLength = function() { return this.keyValuePairs.length; }
}
function queryString(key){
var page = new PageQuery(window.location.search);
return unescape(page.getValue(key));
}
function displayItem(key){
if(queryString(key)=='false')
{
document.write("you didn't enter a ?name=value querystring item.");
}else{
document.write(queryString(key));
}
}




function str_replace( r, w , s){
     return s.split(r).join(w);
}

