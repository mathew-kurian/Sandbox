/*
Box.as
JukeBox

Created by Alexander Ruiz Ponce on 16/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display.jukeBox
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import gT.display.components.GenericComponent;
	import gT.display.Draw;
	import gT.utils.ColorUtils;
	
	public class Box extends GenericComponent {
		
		protected var __stroke:Sprite;
		protected var __fill:Sprite;
		protected var __color:uint = 0x646a72;
		protected var __cornerStype:String;
		
		public function Box (cornerStyle:String = "small") {
			__cornerStype = cornerStyle;
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		override protected function init ():void
		{
			setMinSize(5, 3);
			super.init();
		}
		
		
		override protected function addChildren():void
		{
			// Stroke
			__stroke = new Sprite;
			addChild(__stroke);
			
			// fill
			__fill = Draw.rectangle(__minWidth, __minHeight, __color);
			__fill.x = 1;
			__fill.y = 1;
			addChild(__fill);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			drawStroke();
			__fill.width = __width - 2;
			__fill.height = __height - 2;
		}
		
		private function drawStroke ():void
		{
			var g = __stroke.graphics;
			g.clear();
			g.beginFill(__color);
			
			switch (__cornerStype) {
				case "small":
					g.drawRect(1, 0, __width - 2, 1);
					g.drawRect(__width - 1, 1, 1, __height - 2);
					g.drawRect(1, __height - 1, __width - 2, 1);
					g.drawRect(0, 1, 1, __height - 2);
					break;
				case "normal":
					g.drawRect(1, 1, 1, 1);
					g.drawRect(2, 0, __width - 4, 1);
					g.drawRect(__width - 2, 1, 1, 1);
					g.drawRect(__width - 1, 2, 1, __height - 4);
					g.drawRect(__width - 2, __height - 2, 1, 1);
					g.drawRect(2, __height - 1, __width - 4, 1);
					g.drawRect(1, __height - 2, 1, 1);
					g.drawRect(0, 2, 1, __height - 4);
					break;
			}
			
			g.endFill();
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
		public function set color (value:uint):void
		{
			__color = value;
			ColorUtils.tint(__fill, __color);
			draw();
		}
		
		public function get fill ():Sprite
		{
			return __fill;
		}
	}
}