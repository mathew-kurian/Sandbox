function draw_button(image , href , onclick , title , onmouseover , onmouseout , target){
	var html = "";
		
		html += "<a href=\"" + href + "\" "
		html += "onclick=\"" + onclick + "\" "
		html += (target ? "target=\"" + target + "\" " : "")
		html += "onmouseover=\"" + onmouseover + "\" "
		html += "onmouseout=\"" + onmouseout + "\" >"
		html += "<img hspace=2 src=\"skin/iceBlue/buttons/" + image + ".gif\" border=\"0\" title=\"" + title + "\">"
		html += "</a>";

	document.write(html);
}

function draw_box ( width , part , title , nav) {
	if (part == 1){
		html =  '<table align="center" cellspacing="0" cellpadding="0" width="' + (width ? width : "100%" ) + '">' +					
				(nav ? '<tr><td class="siteFormNav">' + nav + '</td></tr>' : '<tr><td class="siteFormNav">&nbsp;</td></tr>' ) +
					"<tr>" +
						'<td class="siteForm">' + title + '</td>' +
					"</tr>"+
					"<tr>" +
						'<td class="siteFormContent">'
	} else {
		html =  "	</td>" +
					"</tr>" +
				"</table>"
	}

	document.write(html);
}


	var __show_menu = "";

	function HideMenu(menu) {
		var menu_tr = document.getElementById("XML_tr_" + menu);
		menu_tr.className = "closed";
	}

	function isIE() {
	  return (navigator.userAgent.indexOf("MSIE") > -1);
	}


	function ShowMenu( menu ) {

		if (menu == null) {
			RestoreMenu();
		} else {

			var menu_tr = document.getElementById("XML_tr_" + menu);

			if (__show_menu && (__show_menu != menu))
				HideMenu( __show_menu );
			
			//check if the menu appears
			if (menu_tr.className != "closed"){
				//make it hidden
				HideMenu(menu);

				//unset the cookie 
				__show_menu ="";	
				setCookie("__show_menu" , "-1");		

			} else {
				menu_tr.className = "open";
				//should save the open menu as current and hide the old one
				__show_menu = menu;
				
				//save this in a cookie for page reload
				setCookie("__show_menu", menu);
			}
		}
	}

	function RestoreMenu() {
		menu = getCookie("__show_menu");

		if (menu)
			if (menu != "-1")
			ShowMenu(menu);
	}

//check if the strreplace function exists
if (window.strReplace == undefined) {
	function strReplace(s, r, w){
		 return s.split(r).join(w);
	}

}

//check if the cookie function exists
if (window.getCookie == undefined) {


	function getCookie(name) { 
		for (var i=0; i < bites.length; i++) {
			nextbite = bites[i].split("=");
	
			if (nextbite[0] == name)
				return unescape(nextbite[1]);
		}
		return null;
	}

	function setCookie(name, value) {
		if (value != null && value != "")
			document.cookie=name + "=" + escape(value) + "; expires=" + expiry.toGMTString();
			bites = document.cookie.split("; ");
	}
} 

var bites = document.cookie.split("; ");
var today = new Date();
var expiry = new Date(today.getTime() + 60 * 60 * 24 * 1000); // plus 1000 days
