/* @author: Adrian Bota, adrian@oxylus.ro, www.oxylusflash.com 
 * @last_update: 09/19/2009 (mm/dd/yyyy) */
 
class oxylus.utils.UObj {
	private function UObj() { trace("Static class. No instantiation.") }
	
	/* Returns a copy of the given object. */
	public static function copy(obj:Object):Object {
		var newObj:Object = new Object();
		for (var prop in obj) {
			newObj[prop] = obj[prop];
		}
		return newObj;
	}
	/* Return value or, if undefined, alternate value. */
	public static function valueOrAlt(val, altVal) {
		if (val != undefined) return val;
		return altVal;
	}
}