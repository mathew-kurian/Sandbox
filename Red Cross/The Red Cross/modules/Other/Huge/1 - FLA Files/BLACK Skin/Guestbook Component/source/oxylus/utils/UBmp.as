/* @author: Adrian Bota, adrian@oxylus.ro, www.oxylusflash.com 
 * @last_update: 09/28/2009 (mm/dd/yyyy) */

import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import oxylus.utils.UMc;
import oxylus.utils.UObj;

class oxylus.utils.UBmp {
	private function UBmp() { trace("Static class. No instantiation.") }
	
	/* "flipKind" parameter for the "generate" method. */
	public static var NO_FLIP:Number = 0;
	/* "flipKind" parameter for the "generate" method. */
	public static var FLIP_VERTICALLY:Number = 1;
	/* "flipKind" parameter for the "generate" method. */
	public static var FLIP_HORIZONTALLY:Number = 2;
	
	/* Deletes source MovieClip and returns 
	 * a new MovieClip with the bitmap data attached. */
	public static function generate(sourceMc:MovieClip, smoothing:Boolean, blendMode:String, flipKind:Number):MovieClip {
		smoothing 	= UObj.valueOrAlt(smoothing, true);
		blendMode 	= UObj.valueOrAlt(blendMode, "normal");
		flipKind 	= UObj.valueOrAlt(flipKind, NO_FLIP);

		var w:Number 			= sourceMc._width;
		var h:Number 			= sourceMc._height;
		var bmp:BitmapData 		= new BitmapData(w, h, true, 0);
		var matrix:Matrix 		= new Matrix();
		var ct:ColorTransform 	= new ColorTransform(0, 0, 0);
		
		switch(flipKind) {
			case FLIP_VERTICALLY:
				matrix.scale(1, -1);
				matrix.translate(0, h);
				break;
				
			case FLIP_HORIZONTALLY:
				matrix.scale( -1, 1);
				matrix.translate(w, 0);
		}
		bmp.draw(sourceMc, matrix, ct, blendMode, null, smoothing);
		
		var parent:MovieClip 	= sourceMc._parent;
		var depth:Number 	 	= sourceMc.getDepth();
		var xPos:Number 		= sourceMc._x;
		var yPos:Number 		= sourceMc._y;
		UMc.remove(sourceMc);
		
		var genMc:MovieClip = parent.createEmptyMovieClip("$$newmc" + depth, depth);
		genMc.cacheAsBitmap = true;
		genMc._x 			= xPos;
		genMc._y 			= yPos;		
		genMc.attachBitmap(bmp, genMc.getNextHighestDepth(), "auto", smoothing);		
		
		return genMc;
	}
}