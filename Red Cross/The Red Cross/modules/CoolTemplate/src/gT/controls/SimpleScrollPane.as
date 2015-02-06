/*
SimpleScrollPane.as
labs

Created by Alexander Ruiz Ponce on 25/09/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package gT.controls {
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	
	import gT.display.Draw;
	import gT.display.components.GenericComponent;
	
	public class SimpleScrollPane extends SimpleScrollBar {
		
		private var __mask:Sprite;
		private var __padding:Number = 5;
		private var __content:Sprite;
		
		public function SimpleScrollPane (_target:* = null) {
			__target = _target;
			super(__target);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		override protected function init ():void
		{
			setMinSize(100, 49);
			super.init();
			
			
			if (__target) {
				content = __target;
			}
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			
			__mask = Draw.rectangle(__minWidth, __minHeight, 0xff0000, .5);
			addChild(__mask);
		}
		
		
		override protected function verifyVisibility ():void
		{
			var v:Boolean = true;
			
			if (__target) {
				if (__target.height < __height) {
					v = false;
				} else {
					v = true;
				}
			} else {
				v = false;
			}
			__scroll.visible = v;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			super.draw();
			__mask.width = __width - __trackHolder.width - __padding;
			__mask.height = __height;
						
			if (__target is TextField || __target is GenericComponent) {
				__target.width = __mask.width;
			}
			
			__scroll.x  = __width - __trackHolder.width;
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
		private function clear ():void {
			if (__target) {
				if (contains(__target)) {
					removeChild(__target);
				}
			}
		}
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		public function set padding (value:Number):void {
			__padding = value;
			draw();
		}
		
		public function set content (value:*):void {
			clear();
			if (!value) return;
			
			__thumbHolder.y = 0;
			__target = value;
			__target.x = __target.y = 0;
			if (__target is TextField) {
				if (__target.autoSize == "none") {
					__target.autoSize = "left";
				}
			}
			__target.mask = __mask;
			addChild(__target);
			draw();
		}
	}
}