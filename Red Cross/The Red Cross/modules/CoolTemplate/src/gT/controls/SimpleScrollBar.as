/*
SimpleScrollBar.as
labs

Created by Alexander Ruiz Ponce on 25/09/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package gT.controls {
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import fl.motion.easing.Linear;
	import fl.motion.easing.Exponential;
	
	import gs.TweenLite;
	import gT.display.components.GenericComponent;
	import org.bytearray.display.ScaleBitmap;

	public class SimpleScrollBar extends GenericComponent {
		
		protected var __target:*;
		protected var __speed:Number;
		
		protected var __scroll:Sprite;
		protected var __trackHolder:Sprite;
		protected var __thumbHolder:Sprite;
		protected var __thumb:Bitmap;
		protected var __track:Bitmap;
		protected var __scrollPercent:Number;
		protected var __resizeThumb:Boolean = true;
						
		public function SimpleScrollBar (target:* = null, speed:Number = .5) {
			__target = target;
			__speed = speed;
			
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		override protected function init ():void
		{
			setMinSize(16, 46);
			super.init();
		}

		override protected function addChildren():void
		{
			__scroll = new Sprite;
			__trackHolder = new Sprite;
			__thumbHolder = new Sprite;
			
			// Create the track an thumb skin
			createSkin();
			
			__trackHolder.addChild(__track);
			__thumbHolder.addChild(__thumb);
			addChild(__scroll);
			
			__scroll.addChild(__trackHolder);
			__scroll.addChild(__thumbHolder);
			
			// Events
			__thumbHolder.addEventListener(MouseEvent.MOUSE_DOWN, thumbEvents, false, 0, true);
			__trackHolder.addEventListener(MouseEvent.MOUSE_DOWN, trackEvents, false, 0, true);
		}
		
		//////////////////////////////////////////////////////////
		//
		// protected Methods
		//
		//////////////////////////////////////////////////////////
		protected function createSkin ():void {
			createTrack();
			createThumb();
		}
		
		protected function createTrack ():void
		{
			var trackRect = new Rectangle(0, 18, 16, 10);
			__track = new ScaleBitmap(new BTrack(0,0));
			__track.scale9Grid = trackRect;
		}
		
		protected function createThumb ():void
		{
			var thumbRect = new Rectangle(0, 9, 16, 10);
			__thumb = new ScaleBitmap(new BThumb(0,0));
			__thumb.scale9Grid = thumbRect;
		}
		
		protected function verifyVisibility ():void
		{
			if (__target) {
				if (__target.height < __height) {
					visible = false;
				} else {
					visible = true;
				}
			} else {
				visible = false;
			}
		}
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			if (__target is DisplayObject) {
				var f:Number = __target.height / __height;
				var max = Math.round((__target.height > __height) ? __height / f : __height);
				if (__resizeThumb) __thumb.height = Math.max(max, 20);
				__track.height = __height;
				
				// fix scroll position
				if (__thumbHolder.height > __height - __thumbHolder.y) {
					__thumbHolder.y = __height - __thumbHolder.height;
					__target.y = getScrollPosition();
				}
			} else {
				if (__resizeThumb) __thumb.height = __height;
			}
			
			verifyVisibility();
		}
		
		public function refresh () {
			draw();
		}
		
		public function destroy ():void {
			__thumbHolder.removeEventListener(MouseEvent.MOUSE_DOWN, thumbEvents);
			__trackHolder.removeEventListener(MouseEvent.MOUSE_DOWN, trackEvents);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////
		//
		// private Methods
		//
		//////////////////////////////////////////////////////////
		
		private function getScrollPosition ():Number {
			var result:Number;
			__scrollPercent =  (__thumbHolder.y * 100) / (__height - __thumbHolder.height);
			result = (__target.height - __height) * (Math.round(__scrollPercent) / 100);
			
			return -result || 0;
		}
		
		private function thumbEvents (e:MouseEvent):void
		{
			if (__target is DisplayObject) {
				switch (e.type) {
					case "mouseUp" :
						__thumbHolder.stopDrag();
						__thumbHolder.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
						__thumbHolder.stage.removeEventListener(MouseEvent.MOUSE_MOVE, thumbEvents);
						__thumbHolder.stage.removeEventListener(MouseEvent.MOUSE_UP, thumbEvents);
						TweenLite.to(__thumbHolder, .3, {alpha:1});
						break;
						
					case "mouseDown" :
						
						__thumbHolder.stage.addEventListener(MouseEvent.MOUSE_MOVE, thumbEvents, false, 0, true);
						__thumbHolder.stage.addEventListener(MouseEvent.MOUSE_UP, thumbEvents, false, 0, true);
						__thumbHolder.startDrag(false, new Rectangle(0, 0, 0, __height - __thumb.height));
						TweenLite.to(__thumbHolder, .3, {alpha:.8});
						break;
						
					case "mouseMove" :
		
						slide(getScrollPosition());
						
						e.updateAfterEvent();
						break;
				}
			}
		}
		
		private function trackEvents (e:MouseEvent):void
		{
			__thumbHolder.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			
			var percent:Number =  (__track.mouseY * 100) / (__height - __thumb.height);
			var posY;
			
			if (__track.mouseY > __height - __thumb.height) {
				posY = __height - __thumb.height;
			} else {
				
				posY =  (((__height - __thumb.height) * percent) / 100) - __thumb.height/2;
				
				if (posY < 0) {
					posY = 0;
				};
			}
			
			percent =  (posY * 100) / (__height - __thumb.height);
			var slidePos = (__target.height - __height) * (Math.round(percent) / 100);
			//__tween = TweenLite.to(__thumbHolder, __speed, {y:Math.round(posY), ease:Exponential.easeOut});
			__thumbHolder.y = Math.round(posY);
			
			slide(-slidePos);
		}
		
		private function slide (value:Number):void 
		{
			TweenLite.to(__target, __speed, {y:value, ease:Exponential.easeOut});
		}
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		
		public function set target (value:*):void {
			__target = value;
			__thumbHolder.y = 0;
			draw();
		}
		
		public function set speed (value:Number) {
			__speed = value;
		}
		
		public function set size (value:Number):void {
			__height = value;
			draw();
		}
		
		public function get size ():Number {
			return __height;
		}
		
		public function set resizeThumb (value:Boolean):void
		{
			__resizeThumb = value;
			__thumb.scaleY = 1;
			draw();
		}
		
		public function get resizeThumb ():Boolean
		{
			return __resizeThumb;
		}
	}
}