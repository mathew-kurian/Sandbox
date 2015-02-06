/*
ProgressBar.as
JukeBox

Created by Alexander Ruiz Ponce on 17/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display.jukeBox
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ProgressBar extends Box {
		
		protected var __percent:Number = 0;
		protected var __drawSuper:Boolean = true;
		
		public function ProgressBar () {
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////

		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			if (__drawSuper) super.draw();
			__drawSuper = true;
			
			__fill.width = Math.ceil(((__width - 2) * __percent) / 100);
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
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		public function set percent (value:Number):void
		{
			__percent = Math.min(value, 100);
			__drawSuper = false;
			draw();
		}
		
		public function get percent ():Number
		{
			return __percent;
		}
		
		public function set progress (value:Number):void
		{
			percent = value;
		}
		
		public function get progress ():Number
		{
			return __percent;
		}
	}
}