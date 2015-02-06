/* @author: Adrian Bota, adrian@oxylus.ro, www.oxylusflash.com 
 * @last_update: 10/19/2009 (mm/dd/yyyy) */

import oxylus.utils.UStr;
 
class oxylus.utils.UAddr {
	private function UAddr() { trace("Static class. No instantiation.") }
	
	/* Cleanup address. */
	public static function contract(address:String):String {		
		var parts:Array = UStr.explode(address, "/");
		var n:Number 	= parts.length;
		for (var i:Number = 0; i < n; i++) {
			parts[i] = filterChars(parts[i]);
		}		
		return "/" + UStr.implode(parts, "/");
	}	
	private static var ALLOWED_CHARS:String = "~/-_";
	/* Returns a filtered string. */
	public static function filterChars(str:String):String {
		var n:Number 	= str.length;
		var temp:String = "";
		for (var i:Number = 0; i < n; i++) {
			var c:String 	= str.charAt(i).toLowerCase(); if (c == "\\") c = "/";
			var cc:Number 	= UStr.code(c);			
			if ((cc >= UStr.code("a") && cc <= UStr.code("z")) || (cc >= UStr.code("0") && cc <= UStr.code("9")) || ALLOWED_CHARS.indexOf(c) >= 0) {
				temp += c;
			}
		}
		return temp;
	}
	/* Compare adresses. 
	 * -2 means that the addresses are different. 
	 * -1 means that address1 is contained by address2. 
	 * 	0 means that address1 is the same as address2.
	 *  1 means that address1 contains address2. */
	public static function compare(address1:String, address2:String, forceContract:Boolean):Number {
		if (forceContract) {
			address1 = contract(address1);
			address2 = contract(address2);
		}
		address1 = address1.toLowerCase();
		address2 = address2.toLowerCase();
		
		var parts1:Array = UStr.explode(address1, "/");
		var parts2:Array = UStr.explode(address2, "/");
		
		var n1:Number 	= parts1.length;
		var n2:Number 	= parts2.length;
		var n:Number 	= Math.min(n1, n2);
		
		for (var i:Number = 0; i < n; i++) {
			if (parts1[i] != parts2[i]) return -2;
		}
		
		if (n1 == n2) 	return 0;
		if (n1 < n2) 	return -1;
		if (n2 > n2) 	return 1;
	}
	/* Slice address. */
	public static function slice(address:String, levels:Number, forceContract:Boolean):String {
		if (forceContract) address = contract(address);
		return "/" + UStr.implode(UStr.explode(address, "/", levels), "/");
	}
}