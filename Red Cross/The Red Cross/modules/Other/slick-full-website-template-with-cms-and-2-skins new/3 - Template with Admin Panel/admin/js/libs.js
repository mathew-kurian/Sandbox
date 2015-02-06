/*
	OXYLUS Developement web framweork
	copyright (c) 2002-2005 OXYLUS Developement

	$Id: libs.js,v 0.0.1 10/05/2005 20:38:15 Exp $
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

var TPLImagesPath = "images/"

var LoadableLibs = new Array(
						"js/common/admin.js",
						"js/common/common.js",
						"js/common/functions.js",
						"js/common/tabs.js",
						"js/common/javascript.fix.js",
						"js/common/forms.js",
						"js/common/preview.js",
						"js/common/ajax.js",
						"3rdparty/calendar/loader.js",
						"3rdparty/fck/fckeditor.js"
					)	

for (var library in LoadableLibs )
	document.write('<script src="' + LoadableLibs[library] + '"></script>');


