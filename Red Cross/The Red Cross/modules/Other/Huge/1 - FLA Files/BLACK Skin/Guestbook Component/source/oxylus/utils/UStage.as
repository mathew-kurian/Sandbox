/* @author: Adrian Bota, adrian@oxylus.ro, www.oxylusflash.com 
 * @last_update: 09/28/2009 (mm/dd/yyyy) */

class oxylus.utils.UStage {
	private function UStage() { trace("Static class. No instantiation.") }
	
	/* Stage minimum width value. */
	public static var STAGE_MIN_WIDTH:Number = 0;
	/* Stage minimum height value. */
	public static var STAGE_MIN_HEIGHT:Number = 0;
	
	/* Get restricted stage width. */
	public static function getWidth():Number {
		return Math.max(Stage.width, STAGE_MIN_WIDTH);
	}
	/* Get restricted stage height. */
	public static function getHeight():Number {
		return Math.max(Stage.height, STAGE_MIN_HEIGHT);
	}
}