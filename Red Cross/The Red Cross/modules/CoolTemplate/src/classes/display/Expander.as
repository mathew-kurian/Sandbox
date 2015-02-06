/*
Expander.as
CoolTemplate

Created by Alexander Ruiz Ponce on 5/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display 
{
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.motion.easing.Back;
	import gT.display.components.GenericComponent;
	
	import gs.TweenMax;
	import classes.Global;
	import classes.CustomEvent;
	import gT.utils.DisplayObjectUtils;
	
	public class Expander extends GenericComponent {
		
		private var __expandIcon:MovieClip;
		private var __base:Bitmap;
		private var __holder:Sprite;
		private var __actualIcon:String;
		
		public function Expander () 
		{
			buttonMode = true;
			mouseChildren = false;
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		
		override protected function init ():void
		{
			super.init();
			setSize(31, 31);
			
			// set holder inir properties
			__holder.x = __width/2;
			__holder.y = __height/2;
			__holder.scaleX = 0;
			__holder.scaleY = 0;
			
			addEventListener(MouseEvent.CLICK, mouseHandler, false, 0, true);
		}
		
		override protected function addChildren():void
		{
			// Holder
			__holder = new Sprite;
			addChild(__holder);
			
			// Base
			__base = new Bitmap(new BExpanderBase(0,0));
			__base.smoothing = true;
			__base.x = -13;
			__base.y = -13;
			__holder.addChild(__base);
			
			// Icon
			__expandIcon = new ExpanderIcons;
			__expandIcon.x = 9;
			__expandIcon.y = 9;
			__holder.addChild(__expandIcon);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		/*
		override public function draw ():void
		{
		}
		*/
		
		public function show ():void
		{
			TweenMax.to(__holder, Global.settings.time/2, {alpha:1, x:0, y:0, scaleX:1, scaleY:1, ease:Back.easeOut});
		}
		
		public function hide ():void
		{
			TweenMax.to(__holder, Global.settings.time/2, {alpha:0, x:__width/2, y:__height/2, scaleX:0, scaleY:0, ease:Back.easeIn});
		}
		
		public function showIcon (id:String):void
		{
			__actualIcon = id;
			var spinner:MovieClip;
			
			if (id == "spinner") {
				__expandIcon.gotoAndStop(id);
				spinner = __expandIcon.getChildByName("spinner") as MovieClip;
				spinner.play();
				__expandIcon.alpha = 0;
				TweenMax.to(__expandIcon, Global.settings.time/1.5, {alpha:1});
				return;
			} else {
				
				__expandIcon.gotoAndStop("spinner");
				try{
					spinner = __expandIcon.getChildByName("spinner") as MovieClip;
					//trace(DisplayObjectUtils.getChildren(__expandIcon))
					spinner.stop();	
				}catch(e){}
			}
			
			__expandIcon.gotoAndStop(id);
			
			__expandIcon.alpha = 0;
			TweenMax.to(__expandIcon, Global.settings.time/1.5, {alpha:1});
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function mouseHandler (e:MouseEvent):void
		{
			//e.stopImmediatePropagation();
			dispatchEvent(new CustomEvent(CustomEvent.EXPANDER_CLICKED));
		}
		////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		public function get expandIcon ():MovieClip
		{
			return __expandIcon;
		}
		public function get actualIcon ():String
		{
			return __actualIcon;
		}
	}
}