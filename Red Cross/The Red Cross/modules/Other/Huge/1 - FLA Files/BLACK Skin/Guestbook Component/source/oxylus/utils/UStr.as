/* @author: Adrian Bota, adrian@oxylus.ro, www.oxylusflash.com 
 * @last_update: 10/18/2009 (mm/dd/yyyy) */

import oxylus.utils.UObj;
 
class oxylus.utils.UStr {
	private function UStr() { trace("Static class. No instantiation.") }
	
	/* White space characters codes */
	/* Code for Tab character. */
	public static var TAB:Number 	= 9;
	/* Code for LineFeed character. */
	public static var LF:Number 	= 10;
	/* Code for CarriageReturn character. */
	public static var CR:Number 	= 13;
	/* Code for Space character. */
	public static var SPACE:Number 	= 32;
	
	/* Removes all extra white spaces from the given string. */
	public static function squeeze(str:String):String {
		var n:Number 		= str.length;		
		var temp:String 	= "";
		var addSp:Boolean 	= false;

		for (var i:Number = 0; i < n; i++) {
			var cc:Number = str.charCodeAt(i);
			if (cc != TAB && cc != SPACE && cc != LF && cc != CR) {
				if (addSp) {
					addSp = false;
					temp += String.fromCharCode(SPACE) + String.fromCharCode(cc);
				} else {
					temp += String.fromCharCode(cc);
				}
			} else {
				if (temp.length > 0) addSp = true;
			}			
		}
		
		return temp;
	}
	/* Removes the white spaces from the begining
	 * and at the end of a given string. */
	public static function trim(str:String):String {		
		var n:Number 	= str.length;				
		var to:Number 	= n - 1;
		var temp:String = "";
		var from:Number;
		
		for (from = 0; from < n; from++) {
			var cc:Number = str.charCodeAt(from);
			if (cc != TAB && cc != SPACE && cc != LF && cc != CR) break;
		}
		for (; to >= 0; to--) {
			var cc:Number = str.charCodeAt(to);
			if (cc != TAB && cc != SPACE && cc != LF && cc != CR) break;
		}
		for (var i:Number = from; i <= to; i++) {
			temp += str.charAt(i);
		}		
		return temp;
	}
	/* Checks if a string is blank. */
	public static function isBlank(str:String):Boolean {
		var n:Number = str.length;
		for (var i:Number = 0; i < n; i++) {
			var cc:Number = str.charCodeAt(i);
			if (cc != SPACE && cc != TAB && cc != LF && cc != CR) return false;
		}
		return true;
	}
	/* Checks if a string is a valid email address. */
	public static function isEmail(str:String):Boolean {
		var n:Number 		= str.length - 1;
		var atPos:Number 	= -1;
		var ptPos:Number 	= -1;
		var i:Number;
		
		for (i = 0; i <= n; i++) {			
			switch(str.charAt(i)) {
				case ".":	
					if (i == 0 || i > n - 2) 		return false;
					if (Math.abs(i - atPos) == 1) 	return false;
					if (Math.abs(ptPos - i) == 1) 	return false;
					ptPos = i;
					break;
				
				case "@":
					if (i == 0 || i == n) 			return false;
					if (atPos > 0)					return false;
					if (Math.abs(i - ptPos) == 1) 	return false;
					atPos = i;				
					break;
			}			
		}
		
		if (ptPos == -1) 	return false;
		if (atPos == -1)	return false;
		if (ptPos < atPos) 	return false;
		if (ptPos < n - 4 ) return false;
		
		for (i = ptPos + 1; i <= n; i++) {
			var cc:Number = str.charCodeAt(i);
			if (! ((cc >= 65 && cc <= 90) || (cc >= 97 && cc <= 122))) return false;
		}
		
		return true;
	}
	/* Replaces the substring from a string
	 * with a specified string. */
	public static function replace(str:String, subStr:String, repStr:String, matchCase:Boolean, wholeWord:Boolean, globalReplace:Boolean):String {
		if (matchCase == undefined) 		matchCase 	= true;
		if (wholeWord == undefined) 		wholeWord 	= false;
		if (globalReplace == undefined) globalReplace	= true;
		if (!matchCase) 					subStr 		= subStr.toLowerCase();
		
		var n:Number 	= str.length;				
		var temp:String = "";
		var flag:String = subStr.charAt(0);
		
		for (var i:Number = 0; i < n; i++) {			
			var c1:String = str.charAt(i);
			var c2:String = matchCase ? c1 : c1.toLowerCase();
			
			if (c2 != flag) temp += c1;
			else {				
				var found:Boolean 	= true;	
				var j:Number 		= 1
				
				for (; j < subStr.length; j++) {
					
					var c3:String = matchCase ? str.charAt(i + j) : str.charAt(i + j).toLowerCase();
					var c4:String = matchCase ? subStr.charAt(j) : subStr.charAt(j).toLowerCase();
					
					if (c3 != c4) { found = false; break; }
				}
				
				if (found && wholeWord) {
					var scc:Number = str.charCodeAt(i - 1);
					var ecc:Number = str.charCodeAt(i + j);
					
					var test1:Boolean = (scc != SPACE && scc != TAB && scc != CR && scc != LF && !isNaN(scc));
					var test2:Boolean = (ecc != SPACE && ecc != TAB && ecc != CR && ecc != LF && !isNaN(ecc));
					
					if (test1 || test2) found = false;					
				}
				
				if (!found) temp += c1;
				else { 
					temp += repStr; 
					i += j - 1;
					if (!globalReplace) flag = null;
				}				
			}
		}
		
		return temp;
	}
	/* Gets the extension of given string. */
	public static function extension(str:String):String {
		var ext:String 			= "";
		var pointFound:Boolean 	= false;
		
		for (var i:Number = str.length - 1; i >= 0; i--) {
			var c:String = str.charAt(i);
			if (c == '.') {
				pointFound = true;
				break;
			}else {
				ext = c.toLowerCase() + ext;
			}
		}
		
		return pointFound ? ext : "";
	}
	/* Truncates the string at specified
	 * index and adds ending characters. */
	public static function truncate(str:String, endIdx:Number, endStr:String):String {
		var n:Number = str.length;
		if (endIdx < 0) endIdx += n;
		if (endStr == undefined) endStr = "...";
		
		if (endIdx <= 0) {
			return endStr;
		}
		if (endIdx >= n) {
			return str;
		}
		var temp:String = "";
		for (var i:Number = 0; i < endIdx; i++) {
			temp += str.charAt(i);
		}
		
		return temp + endStr;
	}
	/* Returns an unique string. */
	public static function uniqueStr():String {
		return String((new Date()).getTime());
	}
	/* Parse string and return coresponding object. */
	public static function parse(str:String):Object {
		var tStr:String = UStr.trim(str);
		
		if (!isNaN(tStr)) 						return Number(tStr);
		else if (tStr.toLowerCase() == "true") 	return true;
		else if (tStr.toLowerCase() == "false") return false;
		else 									return tStr;
	}
	/* Convert number to formatted string. 
	 * Define number of chars before and after the decimal point. */
	public static function nrToStr(nr:Number, charsBefore:Number, charsAfter:Number, usedSymb:String) {
		if (isNaN(nr)) return "";
		
		var strParts:Array 		= String(nr).split(".");
		var beforeStr:String 	= strParts[0];
		var afterStr:String 	= UObj.valueOrAlt(strParts[1], "");		
		charsBefore 			= Math.max(beforeStr.length, UObj.valueOrAlt(charsBefore, beforeStr.length));
		charsAfter 				= UObj.valueOrAlt(charsAfter, afterStr.length);
		usedSymb				= UObj.valueOrAlt(usedSymb, "0");
		var nrStr:String 		= "";
		
		var i:Number;
		for (i = 0; i < charsBefore; i++) {
			if (i < beforeStr.length) nrStr += beforeStr.charAt(i);
			else nrStr = usedSymb + nrStr;
		}		
		for (i = 0; i < charsAfter; i++) {
			if(i == 0) nrStr += ".";
			nrStr += i < afterStr.length ? afterStr.charAt(i) : usedSymb;
		}
		
		return nrStr;
	}
	/* Get char code. */
	public static function code(c:String):Number {
		return c.charCodeAt(0);
	}
	/* Array of strings. */
	public static function explode(str:String, delimChar:String, limit:Number):Array {
		if (isNaN(limit)) limit = Number.POSITIVE_INFINITY;
		if (limit <= 0 || str.length == 0) return [];
		
		var n:Number 	= str.length;
		var part:String = "";
		var parts:Array = new Array();
		
		for (var i:Number = 0; i < n; i++) {
			var c:String = str.charAt(i);
			
			if (c != delimChar) {
				part += c;
			} else {
				if (part.length > 0) {
					if (--limit > 0) {
						parts.push(part);
						part = "";
					} else break;
				}
			}
		}
		if (part.length > 0) parts.push(part);		
		
		return parts;
	}
	/* String from Array. */
	public static function implode(arr:Array, delimChar:String, limit:Number) {
		if (isNaN(limit)) limit = Number.POSITIVE_INFINITY;
		if (limit <= 0 || arr.length == 0) return "";
		
		var n:Number 	= arr.length - 1;
		var str:String 	= "";
		var i:Number 	= 0
		
		for (; i < n; i++) {
			if (--limit > 0) str += arr[i] + delimChar;
			else break;
		}

		return str + arr[i];
	}
}