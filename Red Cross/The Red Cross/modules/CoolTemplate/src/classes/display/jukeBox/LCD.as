/*
LCD.as
JukeBox

Created by Alexander Ruiz Ponce on 16/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display.jukeBox
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import gT.display.components.GenericComponent;
	import gT.display.Draw;
	import org.bytearray.display.ScaleBitmap;
	
	public class LCD extends GenericComponent {
		
		private var __content:GenericComponent;
		private var __glossy:Bitmap;
		private var __base:ScaleBitmap;
		private var __mainMask:Sprite;
		private var __mask:Sprite;
		
		public static const MARGIN:uint = 3;
		
		public function LCD () 
		{
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		override protected function addChildren():void
		{
			// Base
			__base = new ScaleBitmap(new BJukeBoxBase(0,0));
			__base.scale9Grid = new Rectangle(3, 3, 12, 10);
			addChild(__base);
			
			// content
			__content = new GenericComponent;			
			__content.x = MARGIN;
			__content.y = MARGIN;
			__content.addEventListener(Event.RESIZE, onContentResize, false, 0, true);
			addChild(__content);
			
			// mask
			__mask = Draw.rectangle(__minWidth, __minHeight, 0xff0000, .2);
			__mask.x = MARGIN;
			__mask.y = MARGIN;
			addChild(__mask);
			__content.mask = __mask;
			
			// Glossy
			__glossy = new Bitmap(new BJukeBoxLCDGlossy(0,0));
			__glossy.x = __glossy.y = 1;
			addChild(__glossy);
			
			// Main Mask
			__mainMask = Draw.rectangle(__minWidth, __minHeight, 0xff0000, .2);
			addChild(__mainMask);
			mask = __mainMask;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			__mainMask.width = __width;
			__mainMask.height = __height;
			__base.width = __width;
			__base.height = __height;
			
			var w = __width - MARGIN * 2;
			var h = __height - MARGIN * 2;
			
			__content.width = w;
			__content.height = h;
			
			__mask.width = w;
			__mask.height = h;
			
			__glossy.alpha = __height > 50 ? .3 : 1;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function onContentResize (e:Event):void
		{
			//<#statements#>
		}
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		public function get content ():GenericComponent
		{
			return __content;
		}
	}
}