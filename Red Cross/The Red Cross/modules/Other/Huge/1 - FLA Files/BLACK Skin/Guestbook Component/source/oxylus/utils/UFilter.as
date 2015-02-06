/* @author: Adrian Bota, adrian@oxylus.ro, www.oxylusflash.com 
 * @last_update: 09/28/2009 (mm/dd/yyyy) */

import flash.filters.*;
import oxylus.utils.UArray;

class oxylus.utils.UFilter {
	private function UFilter() { trace("Static class. No instantiation.") }
	
	/* BlurFilter string corespondent. */
	public static var BLUR:String 	= "BlurFilter";
	/* BevelFilter string corespondent. */
	public static var BEVEL:String 	= "BevelFilter";
	/* DropShadowFilter string corespondent. */
	public static var SHADOW:String = "DropShadowFilter";
	/* GlowFilter string corespondent. */
	public static var GLOW:String 	= "GlowFilter";
		
	/* Set MovieClip blur filter. */
	public static function setBlur(mc:MovieClip, blurX:Number, blurY:Number, quality:Number):Void {
		var f:Object = new Object();
		
		if (blurX 	!= undefined) f.blurX 	= blurX;
		if (blurY 	!= undefined) f.blurY 	= blurY;
		if (quality != undefined) f.quality = quality;
		
		setFilter(mc, BLUR, f);
	}
	/* Get MovieClip blur filter. */
	public static function getBlur(mc:MovieClip):BlurFilter {
		return getFilter(mc, BLUR).filter;
	}
	/* Remove MovieClip blur filter. */
	public static function removeBlur(mc:MovieClip):Void {
		removeFilter(mc, BLUR);
	}
	
	/* Set MovieClip bevel filter. */
	public static function setBevel(mc:MovieClip, distance:Number, angle:Number, highlightColor:Number, highlightAlpha:Number, shadowColor:Number, shadowAlpha:Number, blurX:Number, blurY:Number, strength:Number, quality:Number, type:String, knockout:Boolean):Void {
		var f:Object = new Object();
		
		if (distance 		!= undefined) f.distance 		= distance;
		if (angle 			!= undefined) f.angle 			= angle;
		if (highlightColor 	!= undefined) f.highlightColor 	= highlightColor;
		if (highlightAlpha 	!= undefined) f.highlightAlpha 	= highlightAlpha;
		if (shadowColor 	!= undefined) f.shadowColor 	= shadowColor;
		if (shadowAlpha 	!= undefined) f.shadowAlpha 	= shadowAlpha;
		if (blurX 			!= undefined) f.blurX 			= blurX;
		if (blurY 			!= undefined) f.blurY 			= blurY;
		if (strength 		!= undefined) f.strength 		= strength;
		if (quality 		!= undefined) f.quality 		= quality;
		if (type 			!= undefined) f.type 			= type;
		if (knockout 		!= undefined) f.knockout 		= knockout;
		
		setFilter(mc, BEVEL, f);
	}
	/* Get MovieClip bevel filter. */
	public static function getBevel(mc:MovieClip):BevelFilter {
		return getFilter(mc, BEVEL).filter;
	}
	/* Remove MovieClip bevel filter. */
	public static function removeBevel(mc:MovieClip):Void {
		removeFilter(mc, BEVEL);
	}	
	
	/* Set MovieClip drop shadow filter. */
	public static function setShadow(mc:MovieClip, distance:Number, angle:Number, color:Number, alpha:Number, blurX:Number, blurY:Number, strength:Number, quality:Number, inner:Boolean, knockout:Boolean, hideObject:Boolean):Void {
		var f:Object = new Object();
		
		if (distance 	!= undefined) f.distance 	= distance;
		if (angle 		!= undefined) f.angle 		= angle;
		if (color 		!= undefined) f.color 		= color;
		if (alpha 		!= undefined) f.alpha 		= alpha;
		if (blurX 		!= undefined) f.blurX 		= blurX;
		if (blurY 		!= undefined) f.blurY 		= blurY;
		if (strength 	!= undefined) f.strength 	= strength;
		if (quality 	!= undefined) f.quality 	= quality;
		if (inner 		!= undefined) f.inner 		= inner;
		if (knockout 	!= undefined) f.knockout 	= knockout;
		if (hideObject 	!= undefined) f.hideObject 	= hideObject;
		
		setFilter(mc, SHADOW, f);
	}
	/* Get MovieClip drop shadow filter. */
	public static function getShadow(mc:MovieClip):DropShadowFilter {
		return getFilter(mc, SHADOW).filter;
	}
	/* Remove MovieClip shadow filter. */
	public static function removeShadow(mc:MovieClip):Void {
		removeFilter(mc, SHADOW);
	}
	
	/* Set MovieClip glow filter. */
	public static function setGlow(mc:MovieClip, color:Number, alpha:Number, blurX:Number, blurY:Number, strength:Number, quality:Number, inner:Boolean, knockout:Boolean):Void {
		var f:Object = new Object();
		
		if (color 		!= undefined) f.color 		= color;
		if (alpha 		!= undefined) f.alpha 		= alpha;
		if (blurX 		!= undefined) f.blurX 		= blurX;
		if (blurY 		!= undefined) f.blurY 		= blurY;
		if (strength 	!= undefined) f.strength 	= strength;
		if (quality 	!= undefined) f.quality 	= quality;
		if (inner 		!= undefined) f.inner 		= inner;
		if (knockout	!= undefined) f.knockout 	= knockout;		
		
		setFilter(mc, GLOW, f);
	}
	/* Get MovieClip glow filter. */
	public static function getGlow(mc:MovieClip):GlowFilter {
		return getFilter(mc, GLOW).filter;
	}
	/* Remove MovieClip glow filter. */
	public static function removeGlow(mc:MovieClip):Void {
		removeFilter(mc, GLOW);
	}
	
	/* Get MovieClip filter. */
	public static function getFilter(mc:MovieClip, filterKind:String):Object {
		var f:Object 		= new Object();
		var filters:Array 	= mc.filters;
		var n:Number 		= filters ? filters.length : 0;
		
		for (var i:Number = 0; i < n; i++) {	
			var check:Boolean = false;
			switch(filterKind) {
				case BLUR:
					check = filters[i] instanceof BlurFilter;
					break;					
				case BEVEL:
					check = filters[i] instanceof BevelFilter;
					break;					
				case SHADOW:
					check = filters[i] instanceof DropShadowFilter;
					break;					
				case GLOW:
					check = filters[i] instanceof GlowFilter;
					break;					
			}			
			if (check) {
				f.filter 	= filters[i];
				f.index 	= i;
				break;
			}
		}
		return f;
	}
	/* Set MovieClip filter. */
	public static function setFilter(mc:MovieClip, filterKind:String, filterParams:Object):Void {
		var f:Object 		= getFilter(mc, filterKind);
		var filters:Array 	= mc.filters || new Array();
		var filter:Object	= undefined;

		if (f.index != undefined) {
			filter = f.filter;
		} else {
			switch(filterKind) {
				case BLUR:
					filter = new BlurFilter(0, 0, 2);
					break;					
				case BEVEL:
					filter = new BevelFilter(4, 45, 0xFFFFFF, 1, 0, 1, 4, 4, 1, 2, "inner", false);
					break;					
				case SHADOW:
					filter = new DropShadowFilter(4, 45, 0, 1, 4, 4, 1, 2, false, false, false);
					break;					
				case GLOW:
					filter = new GlowFilter(0, 1, 4, 4, 1, 2, false, false);
					break;					
			}		
		}
		if (filter) {
			for (var prop in filterParams) {
				filter[prop] = filterParams[prop];
			}
			if (f.index != undefined) 	filters[f.index] = filter;
			else 						filters.push(filter);
			
			mc.filters = filters;
		}		
	}
	/* Remove MovieClip filter. */
	public static function removeFilter(mc:MovieClip, filterKind:String):Void {
		var filters:Array 	= mc.filters ? mc.filters : new Array();
		var n:Number 		= filters.length;
		
		for (var i:Number = 0; i < n; i++) {	
			var check:Boolean = false;
			switch(filterKind) {
				case BLUR:
					check = filters[i] instanceof BlurFilter;
					break;					
				case BEVEL:
					check = filters[i] instanceof BevelFilter;
					break;					
				case SHADOW:
					check = filters[i] instanceof DropShadowFilter;
					break;					
				case GLOW:
					check = filters[i] instanceof GlowFilter;
					break;					
			}			
			if (check) UArray.removeAt(filters, i);
		}
		mc.filters = filters;
	}
}