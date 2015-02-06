/* @author: Adrian Bota, adrian@oxylus.ro, www.oxylusflash.com 
 * @last_update: 09/28/2009 (mm/dd/yyyy) */

import oxylus.utils.UArray;

class oxylus.utils.UMc {
	private function UMc() { trace("Static class. No instantiation.") }
	
	/* Sort depths ascending. */
	public static var SORT_ASC:Number =  1;
	/* Sort depths descending. */
	public static var SORT_DESC:Number = -1;
	
	/* Create new unique MovieClip instance inside specified "holder". */
	public static function create(holder:MovieClip):MovieClip {
		var d:Number = holder.getNextHighestDepth();
		return holder.createEmptyMovieClip("$$newMc" + d, d);
	}	
	/* Attach Library MovieClip inside specified "holder". */
	public static function attach(holder:MovieClip, libraryId:String):MovieClip {
		var d:Number = holder.getNextHighestDepth();
		return holder.attachMovie(libraryId, "$$newLibMc" + d, d);
	}	
	/* Duplicate MovieClip. */
	public static function duplicate(mc:MovieClip):MovieClip {
		var d:Number = mc._parent.getNextHighestDepth();
		return mc.duplicateMovieClip("$$dupMc" + d, d);
	}	
	/* Bring MovieClip to front. */
	public static function bringToFront(mc:MovieClip):Void {
		mc.swapDepths(mc._parent.getNextHighestDepth());
	}
	/* Scale MovieClip. */
	public static function scale(mc:MovieClip, xyScale:Number) {
		mc._xscale = xyScale;
		mc._yscale = xyScale;
	}
	/* Remove MovieClip, but call specified function before removal. */
	public static function remove(mc:MovieClip, func:Function, scope:Object, arg):Void {
		if(func) func.call(scope, mc, arg);
		UMc.bringToFront(mc);
		mc.removeMovieClip();
	}
	/* Play MovieClip frame-by-frame until it reaches specified frame. */
	public static function playTo(mc:MovieClip, frame:Number, updateHandler:Function, updateScope:Object, updateArg, completeHandler:Function, completeScope:Object, completeArg) {
		if (frame <= 0 || frame > mc._totalframes) frame = mc._totalframes;
		
		mc.onEnterFrame = function():Void {
			var cf:Number = this._currentframe;
			
			if (cf == frame) {
				delete this.onEnterFrame;
				if (completeHandler) completeHandler.call(completeScope, completeArg);
			} else {
				(cf > frame) ? this.prevFrame() : this.nextFrame();
				if (updateHandler) updateHandler.call(updateScope, updateArg);
			}
		};
	}
	/* Get MovieClip absolute position. */
	public static function getAbsolutePos(mc:MovieClip):Object {
		var p:Object = { x: 0, y: 0 };
		mc.localToGlobal(p);
		return p;
	}
	/* Set MovieClip absolute position. */
	public static function setAbsolutePos(mc:MovieClip, xPos:Number, yPos:Number):Void {
		var p:Object = getAbsolutePos(mc);
		mc._x += xPos - p.x;
		mc._y += yPos - p.y;
	}
	/* Check if mouse is over MovieClip. */
	public static function mouseIsOver(mc:MovieClip) {
		return mc.hitTest(_level0._xmouse, _level0._ymouse, true);
	}
	/* Set MovieClip rotation relative to a given registration point. */
	public static function setRotation(mc:MovieClip, rotation:Number, regPointX:Number, regPointY:Number):Void {
		$setRelProp(mc, "_rotation", rotation, regPointX, regPointY);
	}
	/* Set MovieClip x scale relative to a given registration point. */
	public static function setXScale(mc:MovieClip, xScale:Number, regPointX:Number, regPointY:Number):Void {
		$setRelProp(mc, "_xscale", xScale, regPointX, regPointY);
	}
	/* Set MovieClip y scale relative to a given registration point. */
	public static function setYScale(mc:MovieClip, yScale:Number, regPointX:Number, regPointY:Number):Void {
		$setRelProp(mc, "_yscale", yScale, regPointX, regPointY);
	}
	/* Set MovieClip scale relative to a given registration point. */
	public static function setScale(mc:MovieClip, scale:Number, regPointX:Number, regPointY:Number):Void {
		$setRelProp(mc, "_xscale", scale, regPointX, regPointY);
		$setRelProp(mc, "_yscale", scale, regPointX, regPointY);
	}
	/* Set MovieClip x position relative to a given registration point. */
	public static function setXPos(mc:MovieClip, xPos:Number, regPointX:Number, regPointY:Number):Void {
		var p:Object = $transformPoint(mc, { x: regPointX, y: regPointY });
		mc._x += xPos - p.x;
	}
	/* Get MovieClip x position relative to a given registration point. */
	public static function getXPos(mc:MovieClip, regPointX:Number, regPointY:Number):Number {
		var p:Object = $transformPoint(mc, { x: regPointX, y: regPointY });
 		return p.x;
	}
	/* Set MovieClip y position relative to a given registration point. */
	public static function setYPos(mc:MovieClip, yPos:Number, regPointX:Number, regPointY:Number):Void {
		var p:Object = $transformPoint(mc, { x: regPointX, y: regPointY });
		mc._y += yPos - p.y;
	}
	/* Get MovieClip y position relative to a given registration point. */
	public static function getYPos(mc:MovieClip, regPointX:Number, regPointY:Number):Number {
		var p:Object = $transformPoint(mc, { x: regPointX, y: regPointY });
 		return p.y;
	}
	/* Set MovieClip width relative to a given registration point. */
	public static function setWidth(mc:MovieClip, width:Number, regPointX:Number, regPointY:Number):Void {
		$setRelProp(mc, "_width", width, regPointX, regPointY);
	}
	/* Set MovieClip height relative to a given registration point. */
	public static function setHeight(mc:MovieClip, height:Number, regPointX:Number, regPointY:Number):Void {
		$setRelProp(mc, "_height", height, regPointX, regPointY);
	}	
	/* Get MovieClip mouse x relative to a given registration point. */
	public static function getXMouse(mc:MovieClip, regPointX:Number, regPointY:Number):Number {
		return mc._xmouse - regPointX;
	}
	/* Get MovieClip mouse y relative to a given registration point. */
	public static function getYMouse(mc:MovieClip, regPointX:Number, regPointY:Number):Number {
		return mc._ymouse - regPointY;
	}
	/* Private methods used for the above methods. */
	private static function $transformPoint(mc:MovieClip, p:Object):Object {
		mc.localToGlobal (p);
		mc._parent.globalToLocal (p);
		return p;
	}
	private static function $setRelProp(mc:MovieClip, propName:String, propValue:Number, regPointX:Number, regPointY:Number):Void {
		var p1:Object 	= $transformPoint(mc, { x: regPointX, y: regPointY });
		mc[propName] 	= propValue;		
		var p2:Object 	= $transformPoint(mc, { x: regPointX, y: regPointY });
		
		mc._x += p1.x - p2.x;
		mc._y += p1.y - p2.y;
	}

	/* Sort MovieClips depths. */
	public static function sortDepths(clips:Array, startIndex:Number, sortKind:Number, circular:Boolean):Void {
		startIndex 				= UArray.normIndex(clips, startIndex);		
		var len:Number 			= clips.length;
		var count:Number  		= circular ? Math.ceil(len / 2) : Math.max(Math.abs(len - startIndex), startIndex + 1);;
		var leftValid:Boolean 	= false;
		var rightValid:Boolean 	= false;
		var offset:Number		= 0;
		var leftIndex:Number	= 0;
		var rightIndex:Number 	= 0;
		
		for (var i:Number = 0; i < count; i++) {
			offset 		= (sortKind == SORT_ASC) ? i : count - 1 - i;
			leftIndex 	= startIndex - offset;
			rightIndex 	= startIndex + offset;
			
			if (circular) {
				leftIndex 	= UArray.normIndex(clips, leftIndex);
				rightIndex 	= UArray.normIndex(clips, rightIndex);
			}
			
			leftValid 	= leftIndex >= 0 && leftIndex != rightIndex;
			rightValid 	= rightIndex < len;
			
			if (leftValid) 	bringToFront(clips[leftIndex]);
			if (rightValid) bringToFront(clips[rightIndex]);
		}
	}
	/* Trace nested clips (as private vars). */
	public static function traceNestedClips(mc:MovieClip):Void {
		for (var p in mc) {
			if (String(p).indexOf("instance") == 0) continue;
			
			var nestedClip 	= mc[p];
			var type:String = "";
			
			if (nestedClip instanceof MovieClip) {
				type = "MovieClip";
			} else if (nestedClip instanceof TextField) {
				type = "TextField";				
			} else if (nestedClip instanceof Button) {
				type = "Button";
			}
			
			if (type.length > 0) trace("private var " + p + ":" + type + ";");
		}
	}
}