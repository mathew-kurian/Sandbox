/*
ArrowButtton.as
CoolTemplate

Created by Alexander Ruiz Ponce on 6/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.controls 
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gs.TweenMax;
	import gT.utils.EventUtils;
	
	import classes.Global;
	import classes.CustomEvent;
	
	public class ArrowButton extends Sprite 
	{
		
		private var __asset:ArrowButtonAsset;
		private var __direction:String;
		private var __offset:uint = 20;
		private var __minAlpha:Number = .3;
		private var __maxAlpha:Number = .8;
		private var __enabled:Boolean;
		private var __action:String = "none";
		private var __hide:Boolean;
		
		public function ArrowButton (direction:String = "left") 
		{
			buttonMode = true;
			__direction = direction;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init (e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			__asset = new ArrowButtonAsset;

			addChild(__asset);
			
			if (__direction != "left") {
				scaleX = -1;
			}
			
			EventUtils.add(__asset, [MouseEvent.ROLL_OVER, MouseEvent.ROLL_OUT, MouseEvent.CLICK], eventHandler, false, 0, true);
			__asset.base.x = -__asset.base.width;
			
			hide();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		public function focus (action:Boolean = true):void
		{
			var a = (action) ? "true" : "false";
			
			if (__enabled && __action != a) {
				__action = a;
				if (action) {
					rollOver();
				} else {
					rollOut();
				}
			}
		}
		
		public function click ():void 
		{
			if (__enabled) {
				//__asset.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				//dispatchEvent(new CustomEvent(CustomEvent.CLICKED, {id:__direction}));
			}
		}
		
		public function hide ():void
		{
			if (!__hide) {
				__hide = true;
				TweenMax.to(__asset.base, Global.settings.time/2, {x:-__asset.base.width, ease:Global.settings.easeIn});
			}
		}
		
		public function show ():void
		{
			if (__hide) {
				__hide = false;
				TweenMax.to(__asset.base, Global.settings.time/2, {x:-15, ease:Global.settings.easeOut});
			}
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
		private function eventHandler (e:MouseEvent):void
		{
			switch (e.type) {
				case MouseEvent.CLICK:
					dispatchEvent(new CustomEvent(CustomEvent.CLICKED, {id:__direction}));
					break;
				case MouseEvent.ROLL_OVER:
					rollOver();
					break;
				case MouseEvent.ROLL_OUT:
					rollOut();
					break;
				default:
					break;
			}
		}
		
		private function rollOver ():void
		{
			if (!__hide) {
				TweenMax.to(__asset.base, Global.settings.time/2, {alpha:__maxAlpha, x:0, ease:Global.settings.easeInOut});
			}
		}
		
		private function rollOut ():void
		{
			if (!__hide) {
				TweenMax.to(__asset.base, Global.settings.time/2, {alpha:__maxAlpha, x:-15, ease:Global.settings.easeInOut});
			}
		}
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		
		public function set enabled (value:Boolean):void
		{
			__enabled = value;
			buttonMode = mouseChildren = __enabled;
			if (!__enabled) {
				__asset.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
			}
		}
	}
}