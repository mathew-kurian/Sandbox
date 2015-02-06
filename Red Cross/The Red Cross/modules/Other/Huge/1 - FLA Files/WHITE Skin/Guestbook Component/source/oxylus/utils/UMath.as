/* @author: Adrian Bota, adrian@oxylus.ro, www.oxylusflash.com 
 * @last_update: 09/28/2009 (mm/dd/yyyy) */

class oxylus.utils.UMath {
	private function UMath() { trace("Static class. No instantiation.") }
	
	/* "resizeKind" param for "getResizeObj" method.
	 * Resize to fit within container. */
	public static var RESIZE_FIT:Number 	= 0;
	/* "resizeKind" param for "getResizeObj" method.
	 * Resize to fit within container (largest image). */
	public static var RESIZE_CROP:Number 	= 1;
	/* "resizeKind" param for "getResizeObj" method.
	 * Force resize to container size. */
	public static var RESIZE_STRETCH:Number = 3;
	
	/* "alignKind" param for "getResizeObj" method.
	 * Align top-left. */
	public static var ALIGN_TL:Number = 0;
	/* "alignKind" param for "getResizeObj" method.
	 * Align top-center. */
	public static var ALIGN_TC:Number = 1;
	/* "alignKind" param for "getResizeObj" method.
	 * Align top-right. */
	public static var ALIGN_TR:Number = 2;
	/* "alignKind" param for "getResizeObj" method.
	 * Align center-right. */
	public static var ALIGN_CR:Number = 3;
	/* "alignKind" param for "getResizeObj" method.
	 * Align bottom-right. */
	public static var ALIGN_BR:Number = 4;
	/* "alignKind" param for "getResizeObj" method.
	 * Align bottom-center. */
	public static var ALIGN_BC:Number = 5;
	/* "alignKind" param for "getResizeObj" method.
	 * Align bottom-left. */
	public static var ALIGN_BL:Number = 6;
	/* "alignKind" param for "getResizeObj" method.
	 * Align center-left. */
	public static var ALIGN_CL:Number = 7;	
	/* "alignKind" param for "getResizeObj" method.
	 * Align center. */
	public static var ALIGN_CC:Number = 8;	
	
	/* Returns a random number between two given numbers. */
	public static function rand(lowerNumber:Number, higherNumber:Number):Number {
		return lowerNumber + Math.floor(Math.random() * (higherNumber - lowerNumber + 1));
	}
	/* Checks if number is between two given limits. */
	public static function belongs(num:Number, lowerLimit:Number, higherLimit:Number):Boolean {
		return (num >= lowerLimit && num <= higherLimit);
	}
	/* Returns the sign of a given number. */
	public static function sign(num:Number):Number {
		return (num < 0 ? -1 : 1);
	}
	/* Get the number with the specified number of decimals. */
	public static function toFixed(num:Number, decimalPlaces:Number):Number {
		if (isNaN(decimalPlaces)) decimalPlaces = 2;
		var n:Number = Math.pow(10, decimalPlaces);
		return Math.round(num * n) / n;
	}
	/* Get resize object.
	 * Returns object with these properties w, h, x, y. */
	public static function getResizeObj(resizeKind:Number, alignKind:Number, origWidth:Number, origHeight:Number, contWidth:Number, contHeight:Number, scaleUp:Boolean):Object {
		var sizeObj:Object;
		switch(resizeKind) {
			case RESIZE_FIT: 	sizeObj = getResizeObjFit(origWidth, origHeight, contWidth, contHeight, scaleUp); break;
			case RESIZE_CROP: 	sizeObj = getResizeObjCrop(origWidth, origHeight, contWidth, contHeight); break;
			default: 			sizeObj = { w: contWidth, h: contHeight }; break;
		}
		var posObj:Object = getResizeObjPos(alignKind, sizeObj.w, sizeObj.h, contWidth, contHeight);
		
		return { w: sizeObj.w, h: sizeObj.h, x: posObj.x, y: posObj.y };
	}
	/* Get resize object - FIT. */
	public static function getResizeObjFit(origWidth:Number, origHeight:Number, contWidth:Number, contHeight:Number, scaleUp:Boolean):Object {
		if (!scaleUp && origWidth <= contWidth && origHeight <= contHeight)
			return { w: origWidth, h: origHeight };

		var origRatio:Number = origWidth / origHeight;
		var contRatio:Number = contWidth / contHeight;
		
		var newWidth:Number;
		var newHeight:Number;
		
		if (origRatio > contRatio) {
			newWidth 	= contWidth;
			newHeight 	= newWidth / origRatio;
		} else if (origRatio < contRatio) {
			newHeight	= contHeight;
			newWidth 	= newHeight * origRatio;
		} else {
			newWidth 	= origWidth;
			newHeight 	= origHeight;
		}
		
		return { w: newWidth, h: newHeight };
	}
	/* Get resize object - CROP. */
	public static function getResizeObjCrop(origWidth:Number, origHeight:Number, contWidth:Number, contHeight:Number):Object {
		var origRatio:Number = origWidth / origHeight;
		var contRatio:Number = contWidth / contHeight;
		
		var newWidth:Number;
		var newHeight:Number;
		
		if (origRatio > contRatio) {
			newHeight	= contHeight;
			newWidth 	= newHeight * origRatio;			
		} else if (origRatio < contRatio) {
			newWidth 	= contWidth;
			newHeight 	= newWidth / origRatio;
		} else {
			newWidth 	= origWidth;
			newHeight 	= origHeight;
		}
		
		return { w: newWidth, h: newHeight };
	}
	/* Get position relative to container. */
	public static function getResizeObjPos(alignKind:Number, objWidth:Number, objHeight:Number, contWidth:Number, contHeight:Number):Object {
		switch(alignKind) {
			case ALIGN_TL: 	return { x: 0, 										y: 0 										}; 	break;
			case ALIGN_TC: 	return { x: Math.round((contWidth - objWidth) / 2), y: 0 										}; 	break;			
			case ALIGN_TR: 	return { x: contWidth - objWidth, 					y: 0 										}; 	break;			
			case ALIGN_CR: 	return { x: contWidth - objWidth, 					y: Math.round((contHeight - objHeight) / 2) }; 	break;
			case ALIGN_BR: 	return { x: contWidth - objWidth, 					y: contHeight - objHeight 					}; 	break;
			case ALIGN_BC: 	return { x: Math.round((contWidth - objWidth) / 2), y: contHeight - objHeight 					}; 	break;			
			case ALIGN_BL: 	return { x: 0, 										y: contHeight - objHeight 					}; 	break;			
			case ALIGN_CL: 	return { x: 0, 										y: Math.round((contHeight - objHeight) / 2) }; 	break;
			default: 		return { x: Math.round((contWidth - objWidth) / 2), y: Math.round((contHeight - objHeight) / 2) }; 	break;
		}
	}
}