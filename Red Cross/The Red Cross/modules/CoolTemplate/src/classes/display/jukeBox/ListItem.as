/*
ListItem.as
JukeBox

Created by Alexander Ruiz Ponce on 22/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display.jukeBox
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import fl.motion.easing.Exponential;
	
	import gs.TweenMax;
	import gT.display.components.GenericComponent;
	import gT.display.Draw;
	import gT.utils.EventUtils;
	
	public class ListItem extends GenericComponent {
		
		private var __hit:Sprite;
		private var __background:Sprite;
		private var __selector:Sprite;
		private var __label:TextField;
		private var __index:uint;
		private var __icon:Bitmap;
		
		private var __textOverColor:uint = 0x282c31;
		private var __textOutColor:uint = 0x646a72;
		private var __selectorColor:uint = 0x646a72;
		private var __speed:Number = .3;
		private var __enabled:Boolean = true;
		private var __trackInfo:Object;
		
		public function ListItem () {
			mouseChildren = false;
			//buttonMode = true;
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		override protected function init ():void
		{
			setMinSize(50, 17);
			super.init();
			
			EventUtils.add(this, [MouseEvent.MOUSE_OVER, MouseEvent.MOUSE_OUT, MouseEvent.CLICK], mouseHandler, false, 0, true);
		}
		
		/*
		override protected function onStage():void
		{
		}
		*/
		
		override protected function addChildren():void
		{
			// Hit
			__hit = Draw.rectangle(__minWidth, __minHeight, 0xff0000, 0);
			addChild(__hit);
						
			// Background
			__background = Draw.rectangle(__minWidth, __minHeight, __selectorColor, .1);
			addChild(__background);
			
			// Selector
			__selector = Draw.rectangle(__minWidth, __minHeight, __selectorColor, 0);
			addChild(__selector);
			
			// TextField
			var font = new PF_Tempesta_Seven_Regular;
			__label = font.tf;
			__label.mouseEnabled = false;
			//__label.autoSize = "left";
			__label.x = 8;
			addChild(__label);
			
			// Icon
			__icon = new Bitmap(new JukeBoxItemListPlayIcon(0,0));
			__icon.visible = false;
			addChild(__icon);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			__hit.width = __width;
			__hit.height = __height;
			
			__selector.width = __width;
			__selector.height = __height - 1;
			
			__background.width = __width;
			__background.height = __height - 1;
			
			__label.y = Math.round((__height - __label.height) / 2);
			
			__icon.x = __width;
			__icon.y = Math.round((__height - __icon.height) / 2);
			
			__label.width = __width - __label.x - __icon.width - 15;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function mouseHandler (e:MouseEvent):void
		{
			if (__enabled) {
				switch (e.type) {
					case MouseEvent.MOUSE_OVER:
						TweenMax.to(__selector, __speed, {alpha:1});
						TweenMax.to(__label, __speed, {tint:__textOverColor});
						TweenMax.to(__icon, __speed, {x:__width - __icon.width - 10, visible:true, ease:Exponential.easeOut});
						break;
					case MouseEvent.MOUSE_OUT:
						TweenMax.to(__selector, __speed, {alpha:0});
						TweenMax.to(__label, __speed, {tint:__textOutColor});
						TweenMax.to(__icon, __speed, {x:__width, visible:true, ease:Exponential.easeIn});
						break;
					case MouseEvent.CLICK:
						dispatchEvent(new JukeBoxEvent(JukeBoxEvent.ITEM_LIST_CLICKED, {index:__index, trackInfo:__trackInfo}, true));
						break;
				}
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
		
		public function set label (value:String):void
		{
			__label.text = value.toUpperCase();
		}
		
		public function set index (value:uint):void
		{
			__index = value;
		}
		
		public function get index ():uint
		{
			return __index;
		}
		
		public function set enabled (value:Boolean):void
		{
			__enabled = value;
			mouseEnabled = __enabled;
			if (__enabled) 
			{
				dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
			}
		}
		
		public function get enabled ():Boolean
		{
			return __enabled;
		}
		
		public function set trackInfo (value:Object):void
		{
			__trackInfo = value;
		}
		
		public function get trackInfo ():Object
		{
			return __trackInfo;
		}
	}
}