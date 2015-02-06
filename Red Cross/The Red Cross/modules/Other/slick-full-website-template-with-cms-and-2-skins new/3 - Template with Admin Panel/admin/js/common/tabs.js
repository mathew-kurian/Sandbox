/*
	OXYLUS Developement web framweork
	copyright (c) 2002-2005 OXYLUS Developement

	$Id: tabs.js,v 0.0.1 10/05/2005 20:38:15 Exp $

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

	function draw_tab(firstrow,active,last,afteractive,text,icon,link,width,onmouseover,onmouseout,id) {

		var img_active;
		var img_pre ;
		var img_after

		onmouseover = (onmouseover == "" ? "" : ' onmouseover="' + onmouseover + '" '); 
		onmouseout = (onmouseout == "" ? "" : ' onmouseout="' + onmouseout + '" '); 
		id = (id == "" ? "" : ' id="' + id + '" '); 
		text = (link == "" ? text : '<a class="FormTab' + (active ? "Active" : "") + '" href="' + link + '">' + text + '</a>' )
		firstrow = (firstrow == true ? "" : "2");

		if (icon != ""){
			icon = icon ? '<img src="images/tabs/' + icon + '.gif" />' : '';
			text = "<table cellspacing=0 cellpadding=0><tr><td>" + icon + '</td><td width=5><img width="5" height="0"></td><td class="FormTab' + (active ? "Active" : "") + '">' + text + '</td></tr></table>';
		}
		

		if (active) {
			img_active = "a";
			img_pre = "";

			text = text;
		} else {
			img_active = "i";
			img_pre = afteractive ? "a" : "";			
		}

		var html= ''
			+ '<td width="8"><img src="' + TPLImagesPath + '/tabs/' + firstrow + 'tab_' + img_active + img_pre + '_left.gif"/></td>'
			+ '<td ' + id + onmouseover + onmouseout + 'width="' + width + '" class="FormTab' + (active ? "Active" : "") + '" background="' + TPLImagesPath + '/tabs/' + firstrow + 'tab_' + img_active + '_bg.gif"><nobr>' + text + '</nobr></td>'
			+ '<td	width="16"><img src="' + TPLImagesPath + '/tabs/' + firstrow + 'tab_' + img_active + '_right.gif"></td>'
			+ ( last ? '<td width="8"><img src="' + TPLImagesPath + '/tabs/' + firstrow + 'tab_' + img_active + '2_right.gif"></td>' : "")

		//alert(html)
		document.write(html);		
	}

	function draw_tab_table(part) {
		if (part == 1){
			document.write(
				 '<table cellspacing="0" cellpadding="0" style="margin-top:10px;">'
				+'	<tr>'				
			);		
		} else {
			document.write(
				'</table>'
			);
		}
	}
