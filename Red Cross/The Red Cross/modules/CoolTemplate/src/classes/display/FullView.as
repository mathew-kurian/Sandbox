/*
FullView.as
CoolTemplate

Created by Alexander Ruiz Ponce on 14/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display
{	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	
	import gs.TweenMax;
	import gT.display.components.GenericComponent;
	import gT.utils.DisplayObjectUtils;
	import gT.display.Draw;
	import gT.display.ImageView;
	
	import classes.Global;
	import classes.CustomEvent;
	import classes.controls.ArrowButton;
	import classes.display.vPlayer.VPlayer;
	
	public class FullView extends GenericComponent {
		
		private var __background:Sprite;
		private var __holder:GenericComponent;
		private var __bitmap:Bitmap;
		private var __image:ImageView;
		private var __imageLoader:ImageView;
		private var __images:Array;
		private var __defaultImageIndex:uint;
		private var __currentImageIndex:uint;
		private var __currentDirection:String;
		private var __vPlayer:VPlayer;
		
		private var __iW:Number;
		private var __iH:Number;
		private var __iX:Number;
		private var __iY:Number;
		private var __iR:Number;
		private var __refBitmap:Bitmap;
		private var __acceleration:uint = 15;
		private var __onOff:Boolean;
		private var __tweening:Boolean;
		
		private var __left:ArrowButton;
		private var __right:ArrowButton
		private var __closeButton:Expander;
		private var __photoFoot:PhotoFoot;
		
		public function FullView (image:ImageView, defaultImageIndex:uint = 0, images:Array = null) 
		{
			//alpha = .3;
			__image = image;
			__image.alpha = 0;
			__images = images;
			__defaultImageIndex = __currentImageIndex = defaultImageIndex;
			
			var pos:Point = __image.localToGlobal(new Point(__image.x, __image.y));
			__iW = __image.width;
			__iH = __image.height;
			__iX = pos.x - __image.x;
			__iY = pos.y - __image.y;
			__iR = __image.rotation;
			
			__tweening = true;
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
				
		override protected function onStage():void
		{
			stage.addEventListener(Event.RESIZE, resize, false, 0, true);
			resize();
			
			on();
		}
		
		override protected function addChildren():void
		{
			// bacground
			__background = Draw.rectangle(__minWidth, __minHeight, Global.settings.fullViewBackgroundColor, .9);
			addChild(__background);
			
			// imageLolader
			__imageLoader = new ImageView(false);
			__imageLoader.addEventListener(ImageView.LOAD_COMPLETE, imageLoaderComplete, false, 0, true);
			// __imageLoader.alpha = .5;
			addChild(__imageLoader);
			
			// Bitmap
			__image.x = __iX;
			__image.y = __iY;
			addChild(__image);
			
			// Arrows
			__left = new ArrowButton("left");
			__left.addEventListener(CustomEvent.CLICKED, arrowHandler, false, 0, true);
			addChild(__left);
			// __left.hide();
			
			__right = new ArrowButton("right");
			__right.addEventListener(CustomEvent.CLICKED, arrowHandler, false, 0, true);
			addChild(__right);
			// __right.hide();
			
			// CloseButton
			__closeButton = new Expander;
			__closeButton.y = 20;
			__closeButton.showIcon("minimize");
			__closeButton.addEventListener(CustomEvent.EXPANDER_CLICKED, off, false, 0, true);
			addChild(__closeButton);
			
			// Photo Foot
			__photoFoot = new PhotoFoot;
			__photoFoot.addEventListener(PhotoFoot.TEXT_CHANGED, function (e) {
										 __photoFoot.y = __height - __photoFoot.height - 20;
										 });
			__photoFoot.x = 20;
			addChild(__photoFoot);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			__background.width = __width;
			__background.height = __height;
			
			__closeButton.x = __width - __closeButton.width - 20;
			__photoFoot.y = __height - __photoFoot.height - 20;
			
			if (!__tweening) {
				__image.width = __width;
				__image.height = __height;
			}
			
			__left.y = Math.round((__height - __left.height)/2);
			__right.y = __left.y;
			__right.x = __width;
			
			if (__vPlayer) {
				__vPlayer.width = __width;
				__vPlayer.height = __height;
			}
		}
		
		public function destroy ():void
		{
			stage.removeEventListener(Event.RESIZE, resize);
		}
				
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		
		private function resize (e:Event = null):void
		{
			var sw = stage.stageWidth;
			var sh = stage.stageHeight;
			
			__width = sw;
			__height = sh;
			
			draw();
		}
		
		private function onHolderResize (e:Event):void
		{
			DisplayObjectUtils.setProporcionalSize(__bitmap, __holder.width, __holder.height);
			
			if (!__onOff)
				DisplayObjectUtils.centerToObject(__bitmap, __holder);
		}
		
		private function panning(e:CustomEvent) 
		{
			var xm = mouseX;
			var ym = mouseY;
			
			var xEnd = -((__image.image.width - __width) / __width) * xm;	
			__image.image.x += (xEnd - __image.image.x) / __acceleration;
			
			var yEnd = -((__image.image.height - __height) / __height) * ym;	
			__image.image.y += (yEnd - __image.image.y) / __acceleration;
		}
		
		private function arrowHandler (e:CustomEvent):void
		{
			__currentDirection = e.params.id;
			
			if (__currentDirection == "left") { 
				previous(); 
			} else {
				next(); 
			}
		}
		
		private function imageLoaderComplete (e:Event):void
		{
			__closeButton.showIcon("minimize");
			
			Global.removeEventListener(CustomEvent.GLOBAL_RENDER, panning);

			addChild(__imageLoader);
			zOrder();
			
			__imageLoader.width = __width;
			__imageLoader.height = __height;
			
			
			if (__currentDirection == "right")
			{
				__imageLoader.x = __width;
				TweenMax.to(__image, Global.settings.time, {x:-width, ease:Global.settings.easeInOut});
				TweenMax.to(__imageLoader, Global.settings.time, {x:0, ease:Global.settings.easeInOut, onComplete:swap});
				if (__vPlayer) {
					TweenMax.to(__vPlayer, Global.settings.time, {x:-width, ease:Global.settings.easeInOut});
				}
			} else {
				__imageLoader.x = -__width;
				TweenMax.to(__image, Global.settings.time, {x:width, ease:Global.settings.easeInOut});
				TweenMax.to(__imageLoader, Global.settings.time, {x:0, ease:Global.settings.easeInOut, onComplete:swap});
				if (__vPlayer) {
					TweenMax.to(__vPlayer, Global.settings.time, {x:width, ease:Global.settings.easeInOut});
				}
			}
			
			function swap () {
				
				removeChild(__imageLoader);
				
				// clone bitmap
				var clon = new Bitmap(__imageLoader.image.bitmapData);
				clon.smoothing = true;
				
				__image.image = clon;
				TweenMax.killTweensOf(__image);
				__image.x = 0;
				
				mouseChildren = true;
				
				destroyVideo();
				
				if (__images[__currentImageIndex].video) {
					createVideo();
				} else {
					Global.addEventListener(CustomEvent.GLOBAL_RENDER, panning, false, 0, true);
				}
				
				__photoFoot.text = __images[__currentImageIndex].description;
			}
		}
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		
		private function on ():void
		{
			TweenMax.to(__image, Global.settings.time, {x:0, y:0, width:stage.stageWidth, height:stage.stageHeight, rotation:0, ease:Global.settings.easeInOut, onComplete:startEnterFrame});
			TweenMax.to(__image, Global.settings.time/2, {alpha:1, overwrite:0});
			TweenMax.from(__background, Global.settings.time/2, {alpha:0, ease:Global.settings.easeIn});
		}
		
		private function off (e:CustomEvent = null):void
		{
			__onOff = true;
			Global.removeEventListener(CustomEvent.GLOBAL_RENDER, panning);
			
			mouseChildren = false;
			__closeButton.hide();
			__left.hide();
			__right.hide();
			
			// Clear the PhotoFoot;
			__photoFoot.text = null;
			
			__image.redraw = false;
			
			// Get the image end size
			DisplayObjectUtils.setProporcionalSize(__image.image, __iW, __iH);
			var endW:Number = __image.image.width;
			var endH:Number = __image.image.height;
			__image.draw(); // Resize to actual size
			
			TweenMax.to(__image.image, Global.settings.time, {x:(__iW - endW) / 2, y:(__iH - endH) / 2, ease:Global.settings.easeIn});
			TweenMax.to(__image, Global.settings.time, {x:__iX, y:__iY, width:__iW, height:__iH, rotation:__iR, ease:Global.settings.easeIn});
			
			if (__vPlayer) {
				__vPlayer.pause();
				TweenMax.to(__vPlayer, Global.settings.time/2, {alpha:0, ease:Global.settings.easeIn});
			}
			
			TweenMax.to(__image, Global.settings.time, {alpha:0, overwrite:0, ease:Global.settings.easeIn, onComplete:function () {
						
						if (__vPlayer) {
							destroyVideo();
						}						
						dispatchEvent(new CustomEvent(CustomEvent.FULL_VIEW_CLOSE));
						}});
			TweenMax.to(__background, Global.settings.time, {alpha:0});
		}
		
		private function startEnterFrame ():void
		{
			__tweening = false;
			__closeButton.show();

			checkArrow();
			
			if (__images[__currentImageIndex].video) {
				createVideo(true);
			} else {
				Global.addEventListener(CustomEvent.GLOBAL_RENDER, panning, false, 0, true);
			}
			
			__photoFoot.text = __images[__currentImageIndex].description;
		}
		
		private function previous ():void
		{
			if (__currentImageIndex > 0) {
				mouseChildren = false;
				__currentImageIndex--;
				__closeButton.showIcon("spinner");
				__imageLoader.source = __images[__currentImageIndex].url;
			}
			checkArrow();
		}
		
		private function next ():void
		{
			if (__currentImageIndex < __images.length-1) {
				mouseChildren = false;
				__currentImageIndex++;
				__closeButton.showIcon("spinner");
				__imageLoader.source = __images[__currentImageIndex].url;
			}
			checkArrow();
		}
		
		private function checkArrow ():void
		{
			if (__currentImageIndex == 0) {
				__left.hide();
			} else {
				__left.show();
			}
			
			if (__currentImageIndex == __images.length-1) {
				__right.hide();
			} else {
				__right.show();
			}
		}
		
		private function createVideo (autoPlay:Boolean = false):void
		{		
			__vPlayer = new VPlayer;
			__vPlayer.bufferTime = Global.settings.videoBufferTime;
			__vPlayer.source = __images[__currentImageIndex].video;
			__vPlayer.backgroundAlpha = 0;
			addChild(__vPlayer);
			
			if (autoPlay) {
				__vPlayer.play();
			}
			zOrder();
			draw();
			
			Global.addEventListener(CustomEvent.GLOBAL_RENDER, videoRender, false, 0, true);
			
			dispatchEvent(new CustomEvent(CustomEvent.FULL_VIEW_SHOW_VIDEO));
		}
		
		private function zOrder ():void
		{
			addChild(__left);
			addChild(__right);
			addChild(__closeButton);
			addChild(__photoFoot);
		}
		
		private function videoRender (e:CustomEvent):void
		{
			__vPlayer.render();
		}
		
		private function destroyVideo ():void
		{
			Global.removeEventListener(CustomEvent.GLOBAL_RENDER, videoRender);
			
			if (__vPlayer) {
				removeChild(__vPlayer);
				__vPlayer = null;
				dispatchEvent(new CustomEvent(CustomEvent.FULL_VIEW_HIDE_VIDEO));
			}
			
		}
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
	}
}