var xmlhttp=false;
/*@cc_on @*/
/*@if (@_jscript_version >= 5)
// JScript gives us Conditional compilation, we can cope with old IE versions.
// and security blocked creation of the objects.
 try {
  xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
 } catch (e) {
  try {
   xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
  } catch (E) {
   xmlhttp = false;
  }
 }
@end @*/

if (!xmlhttp && typeof XMLHttpRequest!='undefined') {
	try {
		xmlhttp = new XMLHttpRequest();
	} catch (e) {
		xmlhttp=false;
	}
}
if (!xmlhttp && window.createRequest) {
	try {
		xmlhttp = window.createRequest();
	} catch (e) {
		xmlhttp=false;
	}
}

function HTTPGetRequest(onsuccess , url ) {

	wait = onsuccess == false ? false : true;

	xmlhttp.open("GET", url,wait);

	if (!wait){
		xmlhttp.send(null)
		return xmlhttp.responseText;
	} else {
		xmlhttp.onreadystatechange = function() {
			//temporaty fix, i font know why it isnw working when i pass directlu the xmlhttp.readyState to the function
			switch (xmlhttp.readyState)	{
				case 4:
					onsuccess(xmlhttp.responseText , xmlhttp.readyState)
				break;

				default:
					onsuccess("" , xmlhttp.readyState)
				break;			
			}
		}
		xmlhttp.send(null)
	}	
}


function HTTPPostRequest(onsuccess , url , vars)  {

	var wait = onsuccess == false ? false : true;
	var request = "";

	for ( i in vars ){
		request += i + "=" + escape(vars[i]) + "&";
	}

	xmlhttp.open("POST", url, wait);
	xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");

	if (!wait){
		xmlhttp.send(request)
		return xmlhttp.responseText;
	} else {
		xmlhttp.onreadystatechange = function() {

			switch (xmlhttp.readyState)	{
				case 4:
					onsuccess(xmlhttp.responseText , xmlhttp.readyState)
				break;

				default:
					onsuccess("" , xmlhttp.readyState)
				break;			
			}
						
			//alert(xmlhttp.readyState);
		}
		xmlhttp.send(request)
	}
}

function is_Ajax() {
	if (xmlhttp ==false)
		return false;
	else 
		return true;
}