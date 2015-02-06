/*
LittleButton.as
MusicTemplate

Created by Carlos Andres Viloria Mendoza on 29/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display{
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
    import flash.net.navigateToURL;
	
	import gT.display.components.GenericComponent;
	import gT.display.Draw;
	import gT.utils.ColorUtils;
	
	import gs.TweenMax;
	
	import classes.Global;
	import classes.CustomEvent;
	
	
	public class LittleButton extends GenericComponent {
		
		private var __font:	*;
		private var __linkObj:	Object;
		private var __label:Label;
		
		public function LittleButton(font:*, linkObject:Object = null):void{
			__font = font;
			__linkObj = linkObject;
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		override protected function init():void
		{
			super.init();
		}
		
		override protected function addChildren():void
		{
			buttonMode = true;
			mouseChildren = false;
			
			__label = new Label(__font);
			__label.text = (__linkObj) ? __linkObj.label : Global.getString("VIEW_MORE").toUpperCase();
			__label.mouseEnabled = false;
			__label.offset = 2;
			addChild(__label);
					
			addEventListener(MouseEvent.CLICK, mouseHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OVER, mouseHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, mouseHandler, false, 0, true);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		
		private function mouseHandler(e:MouseEvent):void
		{
			switch(e.type){
				case "click":
					if (__linkObj) {
						if(__linkObj.href){
							navigateToURL(new URLRequest(__linkObj.href), __linkObj.target);
						}
						
						if (__linkObj.handler) {
							__linkObj.handler();
						}
					}
					break;
				case "mouseOver":
				//	TweenMax.to(background, Global.TIME/2, {glowFilter:{alpha:1, blurX:2, blurY:2, strength:5, quality:3}});
					break;
				case "mouseOut":
				//	TweenMax.to(background, Global.TIME/2, {glowFilter:{alpha:0, blurX:0, blurY:0, strength:5, quality:3}});
					break;
			}
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////
		//
		// Setters and Getters
		//
		//////////////////////////////////////////////////////////
	}
}
