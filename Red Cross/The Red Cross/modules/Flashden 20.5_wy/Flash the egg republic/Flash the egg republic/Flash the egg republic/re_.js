

var _re_script_v = 1.5;

var re_host = "stats.reinvigorate.net";

var re_u_expires = 86400;
var re_r_expires = 86400*365;


var re_unique = 0;

var re_ua = navigator.userAgent.toLowerCase();

var re_browser_ident = "";

if (typeof(re_name_tag) == "undefined")
	var re_name_tag = "";
if (typeof(re_context_tag) == "undefined")
	var re_context_tag = "";
if (typeof(re_comment_tag) == "undefined")
	var re_comment_tag = "";
if (typeof(re_new_user_tag) == "undefined")
	var re_new_user_tag = "";
if (typeof(re_purchase_tag) == "undefined")
	var re_purchase_tag = "";

function re_ua_get(s)
{
	return re_ua.indexOf(s) + 1;
}

function re_cookie_exists(n)
{
	return ((document.cookie.indexOf(n + "=") == -1) ? false : true);
}

function re_get_cookie(n)
{
	var b, e, n, t;
	
	if (document.cookie == "")
		return false;

	with (document.cookie)
	{
		if ((b = indexOf(n + "=")) == -1)
			return false;
		if ((e = substring(b).indexOf(";")) == -1)
			return unescape(substring(b + n.length + 1));
		t = substring(b + n.length + 1);
		return unescape(t.substring(0,t.indexOf(";")));
	}
	
	return  "";
}

function re_set_cookie(name, value, expires, path, domain, secure)
{
	var whence = "";
	if (expires)
	{
		var the_date = new Date();
		the_date.setTime(the_date.getTime()+(expires*1000));
		whence = the_date.toGMTString();
	}
	
    var cook = name + "=" + escape(value) + (expires ? "; expires=" + whence : "") + (path ? "; path=" + path : "") + (domain ? "; domain=" + domain : "") + (secure ? "secure" : "");
    document.cookie = cook;
}


function re_add_event(obj, evnt, func)
{
	var oldobj = obj[evnt];
	if (typeof oldfrm != 'function')
	{
		obj[evnt] = func;
	} else
	{
		obj[evnt] = function()
		{
			oldfrm();
			func();
		}
	}
}

function re_make_comment(name, email, url, comment)
{
	if (name == "")
		name = "Anonymous";
	
	var context = url;
	if (context == "")
		url = "mailto:" + email;
	
	if (name != "Anonymous")
	{
		re_set_cookie("_reun",name,86400*365,"/");
		
		if (context != "")
			re_set_cookie("_rectx",context,86400*365,"/");
	}
	
	comment = comment.substr(0,155);
	
	re_set_cookie("_recmt",comment,60*60*2,"/");
}

function re_auto_tag(usernames, contexts)
{
	var nametag="";
	for (var i=0;i<usernames.length;++i)
	{
		if (re_cookie_exists(usernames[i]) && re_get_cookie(usernames[i]) != "")
		{
			nametag = re_get_cookie(usernames[i]);
			break;
		}
	}

	var context="";
	for (var i=0;i<contexts.length;++i)
	{
		if (re_cookie_exists(contexts[i]) && re_get_cookie(contexts[i]) != "")
		{
			context = re_get_cookie(contexts[i]);
			break;
		}
	}
	
	
	//
	//re_name_tag = "n/a";
	//re_context_tag = "n/a";
	//re_comment_tag = "n/a";
	//

	if (nametag != "" && re_name_tag == "")
		re_name_tag = nametag;
	
	if (context != "" && re_context_tag == "")
		re_context_tag = context;

	
	if (re_cookie_exists("_recmt") && re_get_cookie("_recmt") != "")
	{
		re_comment_tag = re_get_cookie("_recmt");
		re_set_cookie("_recmt","",0,"/");
	}
	
	//alert(re_name_tag + "\n" + re_context_tag + "\n" + re_comment_tag);
}

function re_mt_platform() // Movable Type
{
	re_add_event(window, "onload", function()
		{
			var btn = document.getElementById("comment-post");
			var f = document.forms["comments_form"];

			if (!btn && typeof f != "undefined")
				return;

			re_add_event(btn, "onclick", function()
				{
					re_make_comment(f["comment-author"].value, f["comment-email"].value, f["comment-url"].value, f["comment-text"].value);
				});
		} );
		
	re_auto_tag(new Array("_reun","mtcmtauth"), new Array("_rectx","mtcmthome","mtcmtmail"));
}

function re_tt_platform() // Text Pattern
{
	re_add_event(window, "onload", function()
		{
			var f = document.getElementById("txpCommentInputForm");
			if (typeof f["submit"] == "undefined")
				return;
			
			var msg = "";
			var a = f.getElementsByTagName("textarea");
			
			for (i=0;i<a.length;++i)
				if (a[i].className.match(/txpCommentInputMessage/))
					msg = a[i].value;
			
			re_add_event(f["submit"], "onclick", function() { re_make_comment(f.name.value, f.email.value, f.web.value, msg); });
		} );
		
		re_auto_tag(new Array("_reun"), new Array("_rectx"));
}

function re_ee_platform() // Expression Engine
{
	re_add_event(window, "onload", function()
		{
			var f = document.getElementById("comment_form");
			if (f && f["submit"])
				re_add_event(f["submit"], "onclick", function() { re_make_comment(f.name.value, f.email.value, f.url.value, f.comment.value); });
		} );

	re_auto_tag(new Array("_reun"), new Array("_rectx"));
}

function re_wp_platform()
{
	
	re_add_event(window, "onload", function()
		{
			var f = document.getElementById("commentform");
			if (f && f["submit"])
				re_add_event(f["submit"], "onclick", function() { re_make_comment(f.author.value, f.email.value, f.url.value, f.comment.value); });
		} );

	re_auto_tag(new Array("_reun"), new Array("_rectx"));
}

function re_discover_platform()
{
	if (typeof(re_disc_plat_ran) != "undefined")
		return;

	re_disc_plat_ran = true;


	var metas = document.getElementsByName("generator");
	for (var i=0;i<metas.length;++i)
	{
		if ((metas[i].content + "").match(/movable type/i) || (metas[i].content + "").match(/typepad/i)) // Movable Type / Typepad
		{
			re_mt_platform();
			return;
		}
	}
	
	// Textpattern
	if (document.getElementById("txpCommentInputForm"))
	{
		re_tt_platform();
		return;
	}

	
	// Expression Engine
	if (re_cookie_exists("exp_tracker"))
	{
		re_ee_platform();
		return;
	}
	
	// Wordress comments page
	var wp_tag = document.getElementById("commentform");
	if (wp_tag && wp_tag.action.match(/wp-comments-post/i))
	{
		re_wp_platform();
		return;
	}
	
	// Let name tags and comments work for unidentifable pages
	if (re_cookie_exists("_reun"))
		re_auto_tag(new Array("_reun"), new Array("_rectx"));

}









function re_os()
{
	if(re_ua_get("sunos"))
		return "SunOS";
	else if (re_ua_get("freebsd") || re_ua_get("openbsd"))
		return "BSD";
	else if (re_ua_get("linux"))
		return "Linux";
	else if (re_ua_get("mac") || re_ua_get("ppc"))
		return "Mac";
	else if (re_ua_get("x11"))
		return "UNIX";
	else if (re_ua_get("win"))
		return "Windows";
	else if (re_ua_get("nintendo wii"))
		return "Nintendo Wii";
	else if (re_ua_get("playstation 3"))
		return "Playstation 3";
	else if (re_ua_get("playstation portable"))
		return "PlayStation Portable";
	return "";
}


function re_os_version()
{
	var os = re_os();
	
	if (os == "Windows")
	{
		if (re_ua.indexOf("win3.11") != -1 || re_ua.indexOf("windows 3.1") != -1)
			return "3.1";
		if (re_ua.indexOf("winnt3.51") != -1)
			return "NT 3.11";
		if (re_ua.indexOf("winnt4.0") != -1)
			return "4.0";
		if (re_ua.indexOf("win95") != -1 || re_ua.indexOf("windows 95") != -1)
			return "95";
		if (re_ua.indexOf("win98") != -1 || re_ua.indexOf("windows 98") != -1)
			return "98";
		if (re_ua.indexOf("win 9x 4.90") != -1)
			return "Millennium Edition";
		if (re_ua.indexOf("nt 5.0") != -1 || re_ua.indexOf("windows 2000") != -1)
			return "2000";
		if (re_ua.indexOf("nt 5.1") != -1)
			return "XP";
		if (re_ua.indexOf("nt 5.2") != -1)
			return "Server 2003 / XP Pro (x64 Edition)";
		if (re_ua.indexOf("nt 6.0") != -1)
			return "Vista";
		if (re_ua.indexOf("win32") != -1)
			return "XP";
		if (re_ua.indexOf("windows nt") != -1)
			return "NT";
			
	}
	
	if (os == "Mac")
	{
		if (re_ua.indexOf("os x") != -1 && re_ua.indexOf("intel") != -1)
			return "OS X (Intel)";
		if (re_ua.indexOf("os x") != -1 && re_ua.indexOf("ppc") != -1)
			return "OS X (PowerPC)";
		if (re_ua.indexOf("mac") != -1)
			return "MacOS";
	}
	
	if (os == "SunOS")
	{
		var exp = new RegExp(/sunos ([0-9.]+)/);
		var matches;
		if ((matches = exp.exec(re_ua)) && matches.length == 2)
			return matches[1];
	}
	
	return "";
}

function re_get_browser_version()
{
	var i, ua, b, cr;

	if (re_browser_ident == "Netscape Navigator" && document.layers)
		return 4;
	if (!((i = re_ua.indexOf(re_browser_ident+" ")) >= 0 || (i = re_ua.indexOf(re_browser_ident+"/")) >= 0))
		return "";
	ua = re_ua.substring(i + re_browser_ident.length + 1);
	if (ua.charAt(0) == "v")
		ua = ua.substring(1);
	b = "";
	for (cnt=0;cnt<ua.length;cnt++)
	{
		cr = ua.charAt(cnt);
		if ((cr >= 0 && cr <= 9) || cr == ".")
			b += cr;
		else
			break;
	}
	return b;
}

function re_get_clr()
{
	var a = re_ua.split(".net clr ");
	var exp = new RegExp(/^([0-9.]+).*$/);
	var matches;
	
	var dotnet_v = new Array();
	for (var cnt=0;cnt<a.length;++cnt)
	{
		if ((matches = exp.exec(a[cnt])) && matches.length == 2)
			dotnet_v.push(matches[1]);
	}
	
	if (dotnet_v.length > 0)
	{
		var big = dotnet_v[0];
		for (var cnt=0;cnt<dotnet_v.length;++cnt)
		{
			if (dotnet_v[cnt] > big)
				big = dotnet_v[cnt];
		}

		return big;
	}

	return "";
}

function re_get_browser()
{
	var re_browser = "";

	if (re_ua_get("konqueror"))
	{
		re_browser = "Konqueror";
		re_browser_ident = "konqueror";
	} else if (re_ua_get("safari"))
	{
		re_browser = "Safari";
		re_browser_ident = "safari";
	}  else if (re_ua_get("opera"))
	{
		re_browser = "Opera";
		re_browser_ident = "opera";
	} else if (re_ua_get("webtv"))
	{
		re_browser = "WebTV";
		re_browser_ident = "webtv";
	} else if (re_ua_get("firefox"))
	{
		re_browser = "FireFox";
		re_browser_ident = "firefox";
	} else if (re_ua_get("msie"))
	{
		re_browser = "Internet Explorer";
		re_browser_ident = "msie";
	} else if (re_ua_get("omniweb"))
	{	
		re_browser = "OmniWeb";
		re_browser_ident = "omniweb";
	} else if (re_ua_get("netscape"))
	{
		re_browser = "Netscape";
		re_browser_ident = "netscape";
	} else if (!re_ua_get("compatible"))
	{
		re_browser = "Netscape Navigator";
		re_browser_ident = "Netscape Navigator";
	}
	
	return re_browser;
}

function primary_domain_name(url)
{
	var pos;
	if ((pos = url.indexOf(":\/\/")) >= 0)
		url = url.substr(pos);
	var domain = url.match(/(www\.)?([^\/:]+)/);
	if (!domain)
		return "";
	domain = domain[2];
	var top_levels = new Array("aero","biz","cat","com","coop","edu","gov","info","int","jobs","mil","mobi","museum","name","net","org","travel");
	var name_list = domain.split(".");
	while (true)
	{
		var num_levels = name_list.length;
		var level = name_list[name_list.length-1];
		for (var cnt=0;cnt<top_levels.length;++cnt)
		{
			if (top_levels[cnt] == level && name_list.length > 1)
			{
				name_list.pop();
				break;
			}
		}		
		if (name_list.length > 1 && name_list[name_list.length-1].length == 2)
			name_list.pop();
		if (num_levels == name_list.length)
			break;
	}
	return name_list.pop();
}

function re_sid()
{
	var re_d = new Date();
	var chars = "qwertyuiopasdfghjklzxcvbnm1234567890QWERTYUIOPASDFGHJKLZXCVBNM";
	var buffer = "";
	for (var i=0;i<5;++i)
		buffer += chars.charAt(Math.floor(Math.random()*chars.length));
	buffer += "-" + Math.floor(Math.random()*214748364) + "" + re_d.getSeconds();
	return buffer;
}

function re_localtime()
{
	var d = new Date();
	var hr = d.getHours()%12;
	return (hr == 0 ? 12 : hr) + ":" + (d.getMinutes().toString().length == 1 ? "0" : "") + d.getMinutes() + " " + (d.getHours() < 12 ? "am" : "pm");
}


function re_(re_id)
{
	re_discover_platform();

	var screen_res = 0;
	var inner_screen_res = 0;
	
	if (screen)
		screen_res = screen.width | screen.height << 16;
		
	if (window.innerWidth)
		inner_screen_res = window.innerWidth | window.innerHeight << 16;
	else if (document.body)
		inner_screen_res = document.body.clientWidth | document.body.clientHeight << 16;

	if (!re_cookie_exists("re_ret"))
		re_set_cookie("re_ret",0,re_r_expires,"/");
	else if (!re_get_cookie("re_ses"))
		re_set_cookie("re_ret",parseInt(re_get_cookie("re_ret")) + 1,re_r_expires,"/");

	if (!re_get_cookie("re_ses"))
	{
		re_set_cookie("re_ses",re_sid(),re_u_expires,"/");
		re_set_cookie("re_ses_indx",1,re_u_expires,"/");
		re_unique = 1;
	} else
	{
		re_set_cookie("re_ses_indx",parseInt(re_get_cookie("re_ses_indx")) + 1,re_u_expires,"/");
	}

	
	var re_ref = "";
	var re_parent_ref = "";

	try
	{
		if (parent.document.referrer != undefined)
		                re_parent_ref = parent.document.referrer + "";
	} catch (_E)
	{
	}
	
	if (re_parent_ref != "" && re_unique)
		re_ref = re_parent_ref + "";
	else
		re_ref = document.referrer + "";
	
	var tz = (new Date()).getTimezoneOffset()/60;

	var ary = {};
	ary["id"] = re_id;
	ary["sv"] = _re_script_v;
	ary["ses"] = re_get_cookie("re_ses");
	ary["ses_index"] = parseInt(re_get_cookie("re_ses_indx"));

	re_url = (window.location + "").substring(0,250);
	
	if (re_unique)
	{
		ary["u"] = 1;
		ary["ret_index"] = parseInt(re_get_cookie("re_ret"));
		ary["tz"] = tz;
		ary["bwr"] = re_get_browser();
		ary["bwrv"] = re_get_browser_version();
		ary["os"] = re_os();
		ary["osv"] = re_os_version();
		ary["ref"] = re_ref;
		ary["dotnet"] = re_get_clr();
		ary["res"] = screen_res;
		ary["user_agent"] = navigator.userAgent;
		ary["pdn"] = primary_domain_name(re_url);
		ary["rpdn"] = primary_domain_name(re_ref);
	
	}

	ary["cook"] = !!document.cookie;	
	ary["lt"] = re_localtime();
	ary["url"] = re_url;
	ary["title"] = (document.title) ? document.title : "Untitled";
	ary["ires"] = inner_screen_res;
	
	if (re_name_tag != "")
	{
		ary["nt"] = re_name_tag;
		
		if (re_context_tag != "")
			ary["ct"] = re_context_tag;
	}
	
	if (re_comment_tag != "")
		ary["cmmt"] = re_comment_tag;
	
	if (re_new_user_tag != "")
		ary["nwusr"] = re_new_user_tag;

	if (re_purchase_tag != "")
		ary["prchs"] = re_purchase_tag;
		
	ary["rnd"] = Math.floor(Math.random()*2147483647);

	var qry_str = "";
	for (k in ary)
		qry_str += escape(k) + "=" + escape(ary[k]) + "&";

	qry_str = qry_str.substring(0,qry_str.length-1);

	var _re_rpcimg = new Image(1,1);
        _re_rpcimg.src = "http://" + re_host + "/ping?" + qry_str;
}

