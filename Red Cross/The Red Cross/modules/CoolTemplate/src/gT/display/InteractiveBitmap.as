/*
InteractiveBitmap.as

Created by fenixkim on 16/09/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package gT.display {
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class InteractiveBitmap extends Sprite {
		
		var __bitmap:Bitmap;
		
		public function InteractiveBitmap (bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoothing:Boolean = false) {
			__bitmap = new Bitmap(bitmapData, pixelSnapping, smoothing);
			addChild(__bitmap);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		public function set smoothing (value:Boolean):void 
		{ 
			__bitmap.smoothing = value;
		}
		public function get smoothing ():Boolean 
		{
			return __bitmap.smoothing;
		}
		public function set bitmapData (value:BitmapData):void
		{ 
			__bitmap.bitmapData = value; 
		}
		public function get bitmapData ():BitmapData
		{
			return __bitmap.bitmapData;
		}
		public function set pixelSnapping (value:String):void
		{ 
			__bitmap.pixelSnapping = value; 
		}
		public function get pixelSnapping ():String
		{
			return __bitmap.pixelSnapping;
		}
		public function get bitmap ():Bitmap
		{
			return __bitmap;
		}

	}
}