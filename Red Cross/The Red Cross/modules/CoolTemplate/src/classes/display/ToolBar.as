/*
ToolBar.as
CoolTemplate

Created by Alexander Ruiz Ponce on 5/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import gT.display.InteractiveBitmap;
	import gT.display.layout.HLayout;
	import gT.utils.EventUtils;
	import gT.utils.DisplayObjectUtils;
	import gT.utils.ColorUtils;
	
	import gs.TweenMax;
	
	import classes.Global;
	import classes.CustomEvent;
	
	public class ToolBar extends Sprite {
		
		private var __items:Array;
		private var __layout:HLayout;
		private var __label:TextField;
		
		public function ToolBar ()
		{
			__items = [{name:"fs", label:Global.getString("FULL_SCREEN").toUpperCase(), clip:new InteractiveBitmap(new BFullScreenIcon(0,0))}];
			
			__layout = new HLayout;
			addChild(__layout);	
			
			for (var i in __items) {
				__items[i].clip.buttonMode = true;
				__items[i].clip.name = __items[i].name;
				__items[i].clip.alpha = .5;
				
				ColorUtils.tint(__items[i].clip, Global.settings.globalColor1);
				__layout.addChild(__items[i].clip);
				
				TweenMax.from(__items[i].clip, Global.settings.time / 2, {alpha:0});
			}
			
			EventUtils.add(DisplayObjectUtils.getChildren(__layout), [MouseEvent.CLICK, MouseEvent.MOUSE_OVER, MouseEvent.MOUSE_OUT], handler, false, 0, true);
			
			//label
			var font = new Font_8;
			__label = font.tf;
			__label.mouseEnabled = false;
			__label.text = "";
			__label.filters = null;
			__label.autoSize = "left";
			__label.textColor = Global.settings.globalColor1;
			addChild(__label);
		}		
		
		private function handler (e:MouseEvent):void
		{
			switch (e.type) {
				case MouseEvent.CLICK:
					switch (e.currentTarget.name) {
						case "fs":
							toggleFullScreen();
							break;
					}
					
					break;
				case MouseEvent.MOUSE_OVER:
					__label.text = getLabel(e.currentTarget.name);
					
					__label.x = -__label.width - 5;
					__label.y = -10;
					__label.alpha = 0;
					TweenMax.to(__label, Global.settings.time / 2, {y:-3, alpha:1, ease:Global.settings.easeOut});
					TweenMax.to(e.currentTarget, Global.settings.time / 2, {alpha:1});
					break;
				case MouseEvent.MOUSE_OUT:
					TweenMax.to(__label, Global.settings.time / 2, {y:-10, alpha:0, ease:Global.settings.easeOut});
					TweenMax.to(e.currentTarget, Global.settings.time / 2, {alpha:.5});
					break;
			}
		}
		
		private function getLabel(id:String):String {
			var result:String;
			for (var i in __items) {
				if (id == __items[i].name) {
					result = __items[i].label;
				}
			}
			return result;
		}
		
		private function toggleFullScreen():void 
		{
            switch(stage.displayState) {
                case "normal":
                    stage.displayState = "fullScreen";    
                    break;
                case "fullScreen":
                default:
                    stage.displayState = "normal";    
                    break;
            }
        }
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		
		override public function get width ():Number {
			return __layout.width;
		}
	}
}