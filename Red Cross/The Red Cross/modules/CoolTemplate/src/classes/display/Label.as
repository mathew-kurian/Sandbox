/*
TitleSection.as
CoolTemplate

Created by Carlos Andres Viloria Mendoza on 29/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import gT.display.components.GenericComponent;
	import gT.display.Draw;
	
	import gs.TweenMax;
	import classes.Global;
	
	public class Label extends GenericComponent {
		
		private var __text:String;
		private var	__textField:TextField;
		private var __background:Sprite;
		private var __padding:uint = 3;
		private var __font:*;
		private var __offset:int =0;
		
		public function Label(font:* = null):void
		{
			__font = (!font) ? new Font_18 : font;
			super(false);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		override protected function init():void
		{
			setMinSize(5, 5);
			super.init();
		}
		
		override protected function addChildren():void{
			__background = Draw.rectangle(__minWidth, __minHeight, Global.settings.globalColor1);
			addChild(__background);
			
			// Label
			__textField = __font.tf;
			__textField.autoSize = "left"
			__textField.x = __padding;
			__textField.textColor = Global.settings.globalColor2;
			__textField.cacheAsBitmap = true;
			addChild(__textField);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
	
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
	
		override public function draw():void{
			__height = __textField.textHeight + 1;
			__background.width = Math.round(__textField.width + __padding * 2);
			__background.height = __height;
					
			__textField.y = Math.round((__height - __textField.textHeight) / 2)-__offset;
			__width = __background.width;
			__height = __background.height;
		}
		
		
		//////////////////////////////////////////////////////////
		//
		// Setters and Getters
		//
		//////////////////////////////////////////////////////////
		
		public function get text():String{
			return __text;
		}
		
		public function set text(value:String):void{
			__text = value;
			__textField.text = __text;
			draw();
		}
		
		public function set offset(value:int):void{
			__offset = value;
			draw();
		}
	}
}