/*
Background.as
CoolTemplate

Created by Alexander Ruiz Ponce on 2/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/

package classes.display

{
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	import gT.display.Draw;
	import gT.display.components.GenericComponent;
	import gT.utils.DisplayObjectUtils;
	import gT.utils.ColorUtils;
	
	import gs.TweenMax;
	import classes.Global;
	
	public class Background extends GenericComponent {
		
		private var __base:Sprite;
		private var __gradient:Sprite;
		private var __noise:Sprite;
		private var __image:Bitmap;
		
		public function Background () {
			super();
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
		
		override protected function onStage():void
		{
		}
		*/
		override protected function addChildren():void
		{
			// Base
			__base = Draw.rectangle(__minWidth, __minHeight, Global.settings.backgroundBaseColor);
			TweenMax.from(__base, Global.settings.time, {alpha:0});
			addChild(__base);
			
			// Gradient
			if (Global.settings.backgroundGradient) {
				__gradient = new BackgroundGradient;
				__gradient.blendMode = "overlay";
				addChild(__gradient);
			}
			
			// Noise
			if (Global.settings.backgroundNoise) {
				__noise = new Sprite;
				__noise.blendMode = "multiply";
				addChild(__noise);
			}
			
			// Load Bacground Image
			loadImage();
			
			
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			__base.width = __width;
			__base.height = __height;
			
			if (Global.settings.backgroundGradient) DisplayObjectUtils.setProporcionalSize(__gradient, __width, __height);
			
			if (__image) {
				DisplayObjectUtils.setProporcionalSize(__image, __width, __height);
				DisplayObjectUtils.centerToObject(__image, this);
			}
			
			if (Global.settings.backgroundNoise) {
				DisplayObjectUtils.centerToObject(__gradient, this);
				generateNoise();
			}
		}
		
		public function loadImage():void
		{
			if (Global.settings.backgroundImage)
			{
				var loader = new Loader;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderHandler);
				loader.load(new URLRequest(Global.settings.backgroundImage));
			}
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		
		private function loaderHandler (e:Event):void
		{
			__image = e.target.content;
			__image.smoothing = true;
			__image.blendMode = "multiply";
			addChild(__image);
			ColorUtils.desaturation(__image);
			draw();
			TweenMax.from(__image, Global.settings.time, {alpha:0});
		}
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		private function generateNoise ():void
		{
			var g = __noise.graphics;
			g.clear();
			g.beginBitmapFill(new BBackgroundNoise(0,0));
			g.drawRect(0, 0, __width, __height);
            g.endFill();
		}
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
	}
}