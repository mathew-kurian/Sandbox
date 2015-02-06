/*
CoolFrame.as
CoolFrame

Created by Alexander Ruiz Ponce on 29/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package gT.display.coolFrame
{
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	import gT.display.components.GenericComponent;
	import gT.display.Rasterize;
	import gT.utils.DisplayObjectUtils;	
	
	public class CoolFrame extends GenericComponent {
		
		protected var __cover:Bitmap;
		protected var __mask:Bitmap;
		protected var __image:Bitmap;
		protected var __bounds:Rectangle;
		protected var __offSet:Rectangle;
		protected var __forceSize:Boolean;
		protected var __draw:Boolean = true; 
		
		public function CoolFrame (_image:Bitmap, _cover:BitmapData, _mask:BitmapData, _bounds:Rectangle, _offSet:Rectangle = null, _forceSize:Boolean = false):void
		{
			__image = _image;
			__cover = new Bitmap(_cover);
			__mask = new Bitmap(_mask);
			__bounds = _bounds;
			__offSet = _offSet;
			__forceSize = _forceSize;
			
			super();
			
			__width = __cover.width;
			__height = __cover.height;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		/*
		override protected function init ():void
		{
		}
		*/
		
		/*
		override protected function onStage():void
		{
		}
		*/
		
		override protected function addChildren():void
		{
			// Mask
			__mask.smoothing = true;
			__mask.cacheAsBitmap = true;
			// addChild(__mask);
			
			if (__image) { __image.mask = __mask; }
			
			// Cover
			__cover.smoothing = true;
			__cover.cacheAsBitmap = true;
			addChild(__cover);
			
			// Image
			if (__image) {
				__draw = false;
				image = __image;
				__draw = true;
			}
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			if (!__image) { return };
			
			DisplayObjectUtils.setProporcionalSize(__image, __bounds.width, __bounds.height, __forceSize);
			__image.x = __bounds.left + Math.round((__bounds.width - __image.width)/2);
			__image.y = __bounds.top + Math.round((__bounds.height - __image.height)/2);
		}
		
		public function getSnapShot ():Bitmap
		{
			return Rasterize.snapShot(this, __cover.width, __cover.height);
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
				
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		public function get snapShot ():Bitmap
		{
			return getSnapShot();
		}
		
		public function set image (value:Bitmap):void
		{
			if (!value) { return };
			
			__image = value;
			__image.smoothing = true;
			__image.cacheAsBitmap = true;
			
			addChild(__image);
			addChild(__mask);
			addChild(__cover);
			
			 __image.mask = __mask;
			
			if (__draw) 
			{ 
				draw(); 
			}
		}
		
		public function get image ():Bitmap
		{
			return __image;
		}
		
		public function get bounds ():Rectangle
		{
			return __bounds;
		}
	}
}