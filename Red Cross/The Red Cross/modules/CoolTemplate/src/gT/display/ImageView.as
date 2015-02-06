/*
ImageView.as
goTo! Framework

Created by Alexander Ruiz Ponce on 6/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package gT.display 
{	
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import gT.display.components.GenericComponent;
	import gT.display.Draw;
	import gT.utils.DisplayObjectUtils;
	
	public class ImageView extends GenericComponent {
		
		protected var __image:Bitmap;
		protected var __request:URLRequest;
		protected var __mask:Sprite;
		protected var __forceSize:Boolean;
		protected var __smoothing:Boolean = true;
		protected var __redraw:Boolean = true;
		protected var __fitToHeight:Boolean;
		protected var __fitToWidth:Boolean;
		protected var __loader:Loader;
		
		public static const LOAD_COMPLETE:String = "loadComplete";
		
		public function ImageView (pixelSnapping:Boolean = true):void 
		{
			super(pixelSnapping);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		override protected function init():void
		{
			super.init();
			setSize(100, 100);
		}
		
		override protected function addChildren():void
		{
			// Mask
			__mask = Draw.rectangle(__minWidth, __minHeight, 0xff0000, .5);
			addChild(__mask);
			
			mask = __mask;
		}
		
		protected function load ():void
		{
			__loader = new Loader();
			__loader.contentLoaderInfo.addEventListener(Event.COMPLETE, addImage);
			__loader.load(__request);
		}		
		
		protected function clear ():void
		{
			if (__image) {
				if (contains(__image)) {
					removeChild(__image);
				}
				__image = null;
			}
		}
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////

		override public function draw ():void
		{
			if (__image) 
			{
				
				if (__fitToWidth) {
					
					__image.width = __width;
					__image.scaleY = __image.scaleX;
					__height = __image.height;
					
				} else if (__fitToHeight) {
					
					__image.height = __height;
					__image.scaleX = __image.scaleY;
					__width = __image.width;
					
				} else {
					DisplayObjectUtils.setProporcionalSize(__image, __width, __height, __forceSize);
				}
				
				if (__redraw) {
					DisplayObjectUtils.centerToObject(__image, this);
				}
			}
			
			__mask.width = __width;
			__mask.height = __height;
		}
		
		public function closeLoad ():void
		{
			try {
				__loader.close();
				__loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, addImage);
			} catch (e) {};
		}
		
		public function destroy ():void
		{
			closeLoad();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		
		protected function addImage (e:Event):void
		{
			__image = e.target.content;
			__image.smoothing = __smoothing;
			addChild(__image);
			
			draw();
			
			dispatchEvent(new Event(ImageView.LOAD_COMPLETE));
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
		public function set source (value:String):void
		{
			if (!value) { return; }
			
			clear();
			__request = new URLRequest(value);
			load();
		}
		
		public function set image (value:Bitmap):void
		{
			if (!value) { return; }
			
			clear();
			__image = value;
			addChild(__image);
			
			draw();
		}
		
		public function get image ():Bitmap
		{
			return __image;
		}
		
		public function set forceSize (value:Boolean):void
		{
			__forceSize = value;
			draw();
		}
		
		public function set smoothing (value:Boolean):void
		{
			__smoothing = value;
			
			if (__image)
			{
				__image.smoothing = __smoothing;
			}
		}
		
		public function set redraw (value:Boolean):void
		{
			__redraw = value;
		}
		
		public function get redraw ():Boolean
		{
			return __redraw;
		}
		
		public function set fitToWidth (value:Boolean):void
		{
			__fitToWidth = value;
			__fitToHeight = false;
			draw();
		}
		
		public function get fitToWidth ():Boolean
		{
			return __fitToWidth;
		}
		
		public function set fitToHeight (value:Boolean):void
		{
			__fitToHeight = value;
			__fitToWidth = false;
			draw();
		}
		
		public function get fitToHeight ():Boolean
		{
			return __fitToHeight;
		}
		
		public function get loader ():Loader
		{
			return __loader;
		}
	}
}