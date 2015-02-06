/* @author: Adrian Bota, adrian@oxylus.ro, www.oxylusflash.com 
 * @last_update: 09/28/2009 (mm/dd/yyyy) */

import oxylus.utils.UFunc;
import oxylus.utils.UStr;
import oxylus.utils.UObj;

class oxylus.utils.UXml {
	private function UXml() { trace("Static class. No instantiation.") }
	
	private static var XML_CACHE:Object;
	
	/* Create new XML object. */
	public static function loadXml(xmlFile:String, loadHandler:Function, handlerScope:Object, cacheBuster:Boolean, forceReload:Boolean):XML {
		if (XML_CACHE == undefined) XML_CACHE = new Object();
		
		if (XML_CACHE[xmlFile].loaded && !UObj.valueOrAlt(forceReload, false)) {			
			UFunc.timedCall(handlerScope, loadHandler, 0, true);
			return XML_CACHE[xmlFile];
		}
		
		var xml:XML			= new XML();
		XML_CACHE[xmlFile] 	= xml;
		xml.ignoreWhite 	= true;
		xml.onLoad 			= UFunc.delegate(handlerScope, loadHandler);
		
		if (cacheBuster && String(_level0._url).indexOf("http") == 0) xmlFile += "?xml_cache_buster=" + UStr.uniqueStr();		
		xml.load(xmlFile);	
		
		return xml;
	}
	/* Get xml status string. */
	public static function statusMsg(status:Number):String {
		var errorMessage:String = "An unknown error has occurred.";
		switch (status) {
			case  0 	: errorMessage = "No error. Parse was completed successfully."; 				break;
			case -2 	: errorMessage = "A CDATA section was not properly terminated."; 				break;
			case -3 	: errorMessage = "The XML declaration was not properly terminated."; 			break;
			case -4 	: errorMessage = "The DOCTYPE declaration was not properly terminated."; 		break;
			case -5 	: errorMessage = "A comment was not properly terminated."; 						break;
			case -6 	: errorMessage = "An XML element was malformed."; 								break;
			case -7 	: errorMessage = "Out of memory."; 												break;
			case -8 	: errorMessage = "An attribute value was not properly terminated."; 			break;
			case -9 	: errorMessage = "A start-tag was not matched with an end-tag."; 				break;
			case -10 	: errorMessage = "An end-tag was encountered without a matching start-tag."; 	break;
		}
		return errorMessage;
	}
}