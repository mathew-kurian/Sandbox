/* @author: Adrian Bota, adrian@oxylus.ro, www.oxylusflash.com 
 * @last_update: 09/28/2009 (mm/dd/yyyy) */

class oxylus.utils.UBool {
	private function UBool() { trace("Static class. No instantiation.") }
	
	/* Returns the Boolean corespondent of the given string. */
	public static function parse(str:String):Boolean {
		return str.toLowerCase() == "true";
	}
}