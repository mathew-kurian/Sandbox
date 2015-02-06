var CalPath = "";

if (window.location.href.indexOf("admin/") == -1) {
	CalPath = "admin/3rdparty/calendar/";
} else
	CalPath = "3rdparty/calendar/";

var CalendarLibs = new Array(
						"calendar.js",
						"calendar-en.js",
						"calendar-setup.js"
					)	

for (var library in CalendarLibs)
	document.write('<script src="' + CalPath + CalendarLibs[library] + '"></script>');


//load the css
document.write('<link href="' + CalPath + 'calendar.css" rel="stylesheet" type="text/css" />');



