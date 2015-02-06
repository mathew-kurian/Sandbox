/*
MenuItem.as
CoolTemplate

Created by Alexander Ruiz Ponce on 2/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display
{
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import gT.display.Draw;
	import gT.display.MenuItem;
	
	import gs.TweenMax;
	import classes.Global;
	import classes.CustomEvent;
	
	public class MainItem extends MenuItem {
		
		private var __label:TextField;
		private var __background:Sprite;
		private var __hit:Sprite;
		private var __mask:Sprite;
		private var __labelStr:String;
		
		public function MainItem (labelStr:String) {
			buttonMode = true;
			mouseChildren = false;
			__labelStr = labelStr;
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		override protected function init ():void
		{
			setMinSize(31, 31);
			super.init();
		}
		
		override protected function addChildren():void
		{
			// hit
			__hit = Draw.rectangle(__minWidth, __minHeight, 0xff0000, 0);
			addChild(__hit);
			
			// Background
			__background = Draw.rectangle(__minWidth, __minHeight, Global.settings.globalColor1, 1);
			__background.visible = false;
			addChild(__background);
			
			// Label
			var font = new Font_24;
			__label = font.tf;
			__label.autoSize = "left"
			__label.text = __labelStr;
			__label.textColor = Global.settings.globalColor2;
			addChild(__label);
			
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
			__height = 31;
			
			if(__autoSize){
				__background.width = Math.round((__padding.left + __padding.right) + __label.textWidth);
				__width = __background.width;
			}
			
			__hit.width = __width;
			__background.width = __width;
			__background.height = __height;
			__label.y = Math.round((__height - __label.height) / 2) + 2;
			__mask.width = __width;
			__mask.height = __height;
			
			__label.x = Math.round((__width - __label.width)/2);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		override protected function eventHandler (e:*):void
		{
			super.eventHandler(e);
			
			switch (e.type) {
				case MouseEvent.MOUSE_OVER:
					__background.y = __height;
					TweenMax.to(__background, Global.settings.time/2, {y:0, visible:true, ease:Global.settings.easeOut});
					break;
				case MouseEvent.MOUSE_OUT:
					TweenMax.to(__background, Global.settings.time/2, {y:-__height, visible:false, ease:Global.settings.easeOut});
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
	}
}