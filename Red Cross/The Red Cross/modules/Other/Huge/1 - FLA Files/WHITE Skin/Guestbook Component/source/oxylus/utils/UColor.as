/* @author: Adrian Bota, adrian@oxylus.ro, www.oxylusflash.com 
 * @last_update: 09/28/2009 (mm/dd/yyyy) */

import oxylus.utils.UMath;
import flash.filters.ColorMatrixFilter;

class oxylus.utils.UColor {
	private function UColor() { trace("Static class. No instantiation.") }
	
	/* Saturation value for grayscale. */
	public static var SAT_GRAYSCALE:Number = 0;
	/* Saturation value for normal color. */
	public static var SAT_NORMAL:Number = 1;
	
	/* Private constants */
	private static var LUM_R:Number = 0.212671;
	private static var LUM_G:Number = 0.715160;
	private static var LUM_B:Number = 0.072169;	
	
	/* Get MovieClip color. */
	public static function getColor(mc:MovieClip):Number {
		return (new Color(mc)).getRGB();
	}
	/* Set MovieClip color. */
	public static function setColor(mc:MovieClip, hexColor:Number):Void {
		(new Color(mc)).setRGB(hexColor);
	}	
	/* Get MovieClip brightness (-2.55; 2.55). */
	public static function getBrightness (mc:MovieClip):Number {
		var t:Object = (new Color(mc)).getTransform();		
		return UMath.toFixed((t.rb + t.gb + t.bb) / 300, 3);	
	}
	/* Set MovieClip brightness (-2.55; 2.55). */
	public static function setBrightness (mc:MovieClip, brightness:Number):Void {
		var p:Number = Math.round(brightness * 100);		
		(new Color(mc)).setTransform( { ra:100, rb: p, ga: 100, gb: p, ba: 100, bb: p } );
	}
	/* Get MovieClip contrast (-1; 1), -1 for solid grey. */
	public static function getContrast(mc:MovieClip):Number {
		var t:Object 	= (new Color(mc)).getTransform();
		var p1:Number 	= (t.ra + t.ga + t.ba) / 300 - 1;
		var p2:Number 	= (t.rb + t.gb + t.bb) / 384;			
		return UMath.toFixed((p1 - p2) / 2, 3);
	}
	/* Set MovieClip contrast (-1; 1), -1 for solid gray. */
	public static function setContrast(mc:MovieClip, contrast:Number):Void {
		var p1:Number = Math.round(contrast * 100) + 100;
		var p2:Number = Math.round(contrast * 128);		
		(new Color(mc)).setTransform({ ra:p1, rb: - p2, ga: p1, gb: - p2, ba: p1, bb: - p2 });
	}	
	/* Get MovieClip saturation (0; 2), 0 for greyscale. */
	public static function getSaturation(mc:MovieClip):Number {
		var m:Array 	= getMcMatrix(mc);				
		var p1:Number 	= ((m[0] - LUM_R) / (1 - LUM_R) + (m[6] - LUM_G) / (1 - LUM_G) + (m[12] - LUM_B) / (1 - LUM_B)) / 3;
		var p2:Number 	= 1 - ((m[1] / LUM_G + m[2] / LUM_B + m[5] / LUM_R + m[7] / LUM_B + m[10] / LUM_R + m[11] / LUM_G) / 6);		
		return UMath.toFixed((p1 + p2) / 2, 3);
	}	
	/* Set MovieClip saturation (0; 2), 0 for greyscale. */
	public static function setSaturation(mc:MovieClip, saturation:Number):Void {
		var sf:Number 	= saturation;
		var nf:Number 	= 1 - sf;
		var nr:Number 	= LUM_R * nf;
		var ng:Number 	= LUM_G * nf;
		var nb:Number 	= LUM_B * nf;
		var m:Array 	= [
			nr + sf,	ng,			nb,			0,	0,
			nr,			ng + sf,	nb,			0,	0,
			nr,			ng,			nb + sf,	0,	0,
			0,  		0, 			0,  		1,  0
		];		
		setMcMatrix(mc, m);
	}
	/* Private methods.
	 * Used for saturation. */
	private static function setMcMatrix(mc:MovieClip, m:Array): Void {
		var $filt:Array = mc.filters.concat();
		var found:Boolean = false;		
		for (var i = 0; i < $filt.length; i++)
		{if ($filt[i] instanceof ColorMatrixFilter) {$filt[i].matrix = m.concat();found = true;}}
		if (!found){var cmf:ColorMatrixFilter = new ColorMatrixFilter(m); $filt[$filt.length] = cmf;}		
		mc.filters = $filt;
	}
	private static function getMcMatrix(mc:MovieClip): Array {
		for (var i = 0; i < mc.filters.length; i++)
		if (mc.filters[i] instanceof ColorMatrixFilter)
		return mc.filters[i].matrix.concat();
		return [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
	}
}