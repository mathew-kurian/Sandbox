/*
LCDButton.as
JukeBox

Created by Alexander Ruiz Ponce on 16/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display.jukeBox
{
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	
	import gs.TweenLite;
	import gT.display.components.GenericComponent;
	import gT.utils.EventUtils;
	
	public class LCDButton extends GenericComponent {
		
		private var __base:Box;
		private var __stroke:Box;
		private var __label:TextField;
		private var __labelStr:String;
		private var __padding:uint;
		
		private var __timer:Timer;
		
		public function LCDButton (label:String) {
			__labelStr = label;
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		override protected function init ():void
		{
			//buttonMode = true;
			setMinSize(11, 5);
			super.init();
		}
		
		override protected function addChildren():void
		{
			// stroke
			__stroke = new Box("normal");
			__stroke.fill.visible = false;
			__stroke.x = -2;
			__stroke.y = -2;
			__stroke.alpha = 0;
			__stroke.visible = false;
			addChild(__stroke);
			
			// Base Button
			__base = new Box;
			addChild(__base);
			
			// label
			var font = new Uni_05_53;
			__label = font.tf;
			__label.mouseEnabled = false;
			__label.autoSize = "left";
			__label.text = __labelStr.toUpperCase();
			addChild(__label);
			
			//listeners
			EventUtils.add(this, [MouseEvent.MOUSE_OVER, MouseEvent.MOUSE_OUT, MouseEvent.MOUSE_DOWN], mouseHandler, false, 0, true);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			if (__width < __label.width + __padding * 2) {
				__width = __label.width + __padding * 2;
				__label.x = __padding;
			} else {
				__label.x = Math.round((__width - __label.width) / 2);
			}
			
			__label.y = Math.round((__height - __label.textHeight) / 2) - 1;
			
			__stroke.width = __width + 4;
			__stroke.height = __height + 4;
			__base.width = __width;
			__base.height = __height;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function mouseHandler (e:MouseEvent):void
		{
			switch (e.type) {
				case MouseEvent.MOUSE_OVER:
					TweenLite.to(__stroke, .3, {autoAlpha:1});
					break;
				case MouseEvent.MOUSE_OUT:
					TweenLite.to(__stroke, .3, {autoAlpha:0});
					break;
				case MouseEvent.MOUSE_DOWN:
					stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler, false, 0, true);
					__base.alpha = .7;
					break;
				case MouseEvent.MOUSE_UP:
					stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
					__base.alpha = 1;
					break;
			}
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
		public function set padding (value:uint):void
		{
			__padding = value;
			draw();
		}
		
		public function get padding ():uint
		{
			return __padding;
		}
	}
}