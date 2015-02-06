/*
Ticket.as
JukeBox

Created by Alexander Ruiz Ponce on 20/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display.jukeBox
{
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.text.TextField;
	import fl.motion.easing.Sine;
	import flash.utils.getDefinitionByName;
	
	import gT.display.components.GenericComponent;
	import gT.display.Draw;
	import gT.display.Rasterize;
	
	import gs.TweenLite;
	
	public class Ticket extends GenericComponent {
		
		private var __mask:Sprite;
		private var __text:String;
		private var __divisionText:String = null;
		private var __space:uint;
		private var __holder:Sprite;
		
		private var __startTextfield:TextField;
		private var __endTextfield:TextField;
		private var __BStart:Bitmap;
		private var __BEnd:Bitmap;
		
		private var __ease:Function = Sine.easeInOut;
		private var __speed:Number = 7;
		private var __delay:Number = 3;
		private var __autoStart:Boolean;
		private var __stopNow:Boolean;
		private var __align:String = "right";
		private var __fontID:String = "Titilium250_20pt";
		
		private var fontReference:Class;
		
		//////////////////////////////////////////////////////////
		//
		// Constructor
		//
		//////////////////////////////////////////////////////////
		public function Ticket (autoStart:Boolean = true, divisionText:String = ""):void 
		{
			__autoStart = autoStart;
			__divisionText = divisionText;
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		override protected function init ():void
		{
			setMinSize(50, 20);
			super.init();	
		}
		
		override protected function addChildren():void
		{
			// Panneable Holder
			__holder = new Sprite;
			addChild(__holder);
			
			// TextFields
			__startTextfield = createTextField(__fontID);		
			__endTextfield = createTextField(__fontID);
			
			// mask
			__mask = Draw.rectangle(__minWidth, __minHeight, 0xff0000, .5);
			addChild(__mask);
			mask = __mask;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			__mask.width = __width;
			__mask.height = __height;
			__space = Math.round(__width / 2);
			
			if (__BStart) {
				__BEnd.x = __BStart.width + __space;
			}
			
			__holder.y = Math.round((__height - __holder.height) / 2);
		}
		
		public function start ():void
		{ 
			if (__BStart.width > __width) 
			{
				var fixedSpeed:Number = __speed * (__BStart.width / __width);
				TweenLite.to(__BStart, fixedSpeed, {x:-__BEnd.x, ease:__ease, delay:__delay});
				TweenLite.to(__BEnd, fixedSpeed, {x:0, ease:__ease, onComplete:loop, delay:__delay});
			} else {
				//checkAlign();
			}
		}
		
		public function stop (forceComplete:Boolean = true, resetPos:Boolean = false):void
		{
			__stopNow = forceComplete;
			if (!__stopNow) {
				TweenLite.killTweensOf(__BStart);
				TweenLite.killTweensOf(__BEnd);
			} else {
				resetPos = false;
			}

			if (resetPos) {
				resetPositions();
			}
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		private function createTextField (classId:String):TextField 
		{
			
			fontReference = getDefinitionByName(classId) as Class;
            var tfFont:Object = new fontReference();
			var tf = tfFont.tf;
			tf.autoSize = "left";
			//tf.border = true;
			//tf.antiAliasType = "normal";
			
			return tf;
		}
		
		private function loop ():void
		{
			TweenLite.killTweensOf(__BStart);
			TweenLite.killTweensOf(__BEnd);
			resetPositions();
			
			if (!__stopNow) {
				start();
			}
		}
		
		private function resetPositions ():void
		{
			__BStart.x = 0;
			__BEnd.x = __BStart.width + __space;
		}
		
		private function clear ():void
		{
			if (__BStart) 
			{
				if (__holder.contains(__BStart)) 
				{
					__holder.removeChild(__BStart);
				}
			}
			if (__BEnd) 
			{
				if (__holder.contains(__BEnd)) 
				{
					__holder.removeChild(__BEnd);
				}
			}
		}
		
		private function checkAlign ():void
		{
			if (__BStart.width < __width)
			{
				if (__align == "center") 
				{
					__BStart.x = Math.round((__width - __BStart.width) / 2);
				}
				
				if (__holder.contains(__BEnd)) 
				{
					__holder.removeChild(__BEnd);
				}
			}
		}
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		public function set space (value:uint):void
		{
			__space = value;
			draw();
		}
		
		public function set speed (value:uint):void
		{
			__speed = value;
		}
		
		public function set delay (value:Number):void
		{
			__delay = value;
		}
		
		public function set text (value:String):void
		{
			__text = value;
			__startTextfield.text = __text+__divisionText;
			__endTextfield.text = __text;
			
			// Clear the the rasterized textFields
			clear();
			
			// Create again
			__BStart = Rasterize.displayObject(__startTextfield);
			__holder.addChild(__BStart);
			
			__BEnd = Rasterize.displayObject(__endTextfield);
			__holder.addChild(__BEnd);
			
			// Resize and check align
			draw();
			checkAlign();
			
			// autoStart
			if (__autoStart) 
			{
				start();
			}
		}
		
		public function get text ():String
		{
			return __text;
		}
		
		public function set align (value:String):void
		{
			__align = value;
		}
		
		public function set textField (value:String):void
		{
			__fontID = value;
			
			clear();
			
			__startTextfield = createTextField(__fontID);		
			__endTextfield = createTextField(__fontID);
		}
	}
}