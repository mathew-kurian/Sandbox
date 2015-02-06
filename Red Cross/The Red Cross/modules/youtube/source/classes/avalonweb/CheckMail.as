/** -----------------------------------------------------------
 * CheckMail - Class to validate email
 * (you should not have to edit something here)
 * ------------------------------------------------------------
 */
class CheckMail
{
	static public function isEmail (s : String) : Boolean
	{
		if (s.indexOf ("@") == - 1) return false;
		var email : Array;
		var user : String;
		var domain : String;
		var domain_dots : Array;
		var user_dots : Array;
		if ((email = s.split ("@")).length == 2)
		{
			if ((domain = email [1]).split (".").pop ().length > 4) return false;
			if (domain.split (".").length < 2) return false;
			if ((user = email [0]).indexOf (".") && domain.indexOf ("."))
			{
				if (domain.lastIndexOf (".") > domain.length - 3) return false;
				var c, t;
				user_dots = user.split (".");
				for (var i = user_dots.length - 1; i >= 0; i --)
				{
					c = user_dots[i];
					if ( ! CheckMail.checkWords (c, true)) return false;
				}
				domain_dots = domain.split (".");
				for (var i = domain_dots.length - 1; i >= 0; i --)
				{
					c = domain_dots[i];
					if ( ! CheckMail.checkWords (c, false)) return false;
				}
			} else return false;
		} else return false;
		return true;
	}
	
	static private function checkWords (s : String, userBol : Boolean) : Boolean
	{
		var len = s.length - 1;
		if (userBol)
		{
			if (s.charAt (0) == "-" || s.charAt (len) == "-" || s.charAt (0) == "_" || s.charAt (len) == "_") return false;
		}else
		{
			if (s.charAt (0) == "-" || s.charAt (len) == "-") return false;
		}
		for (var i = len; i >= 0; i --)
		{
			var c = s.charAt (i).toLowerCase ();
			var alpha = (c <= "z") && (c >= "a");
			var num = (c <= "9") && (c >= "0");
			var spw;
			if (userBol)
			{
				spw = (c == "-") || (c == "_");
			}else
			{
				spw = (c == "-");
			}
			if ( ! alpha && ! num && ! spw) return false;
		}
		return true;
	}
}
