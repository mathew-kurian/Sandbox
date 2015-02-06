/*
	OXYLUS Developement web framweork
	copyright (c) 2002-2005 OXYLUS Developement

	$Id: common.js,v 0.0.1 10/05/2005 20:38:15 Exp $
	Dinamic libraries loader

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

	function SelectElement(select,which) {
		for (var i = 0; i < select.options.length; i++) {          
			if ( select.options[i].value == which )                    
				select.options[i].selected=true;
		}
	}

	function RadioElement(radio,which) {
		for (var i = 0; i < radio.length; i++) {          
			if ( radio[i].value == which )                    
				radio[i].checked=true;
		}
	}

	function GetSelectText(select) {
		for (var i = 0; i < select.options.length; i++) {          
			if ( select.options[i].selected == true )                    
				return select.options[i].text;
		}
	}

	function GetSelectValue(select) {
		for (var i = 0; i < select.options.length; i++) {          
			if ( select.options[i].selected == true )                    
				return select.options[i].value;
		}
	}

	function NewWindow(mypage, myname, w, h, scroll) {
		var winl = (screen.width - w) / 2;
		var wint = (screen.height - h) / 2;
		winprops = 'height='+h+',width='+w+',top='+wint+',left='+winl+',scrollbars='+scroll+',toolbar=no,menubar=no,statusbar=no,status=no,resizable=no'
		return window.open(mypage, myname, winprops)
	}

	function Name2Url( link  ) {

		var replace = {
				" " : "-",
				"&" : "-and-",
				"?" : "", 
				"'" : "-",
				"/" : "-",
				"!" : "",
				"," : "-",
				"\"" : "",
				"(" : "-",
				")" : "-",
				"'" : "",
				"__" : "-"
			}

		var data = link.trim();

		for (i in replace){
			data = str_replace( i , replace[i] , data);
		}

		return data;
	}


	function getAbsolutePos (el) {
		var r = { 
				x: el.offsetLeft, 
				y: el.offsetTop , 
				width: el.offsetWidth, 
				height: el.offsetHeight
			};

		if (el.offsetParent) {
			var tmp = getAbsolutePos (el.offsetParent);
			r.x += tmp.x;
			r.y += tmp.y;
		}

		return r;
	};
