/*
Launcher.as
CoolTemplate

Created by Alexander Ruiz Ponce on 2/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import fl.motion.easing.Exponential;
	
	import gs.TweenLite;
	import classes.display.jukeBox.ProgressBar;
	
	public class Launcher extends MovieClip {
		
		private var __preload:ProgressBar;
		private var __loader:Loader;
		private var __font:MovieClip;
		private var __percentLoaded:Number = 0;
		private var __hasContent:Boolean;
		
		public function Launcher () {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init (e:Event):void
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			// Setting Stage
			stage.align = "topLeft";
			stage.scaleMode = "noScale";
			stage.showDefaultContextMenu = false;
			stage.addEventListener(Event.RESIZE, resize, false, 0, true);
			
			createPreload();
			load();
		}
		
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		
		private function loaderHandler (e:Event):void
		{
			__font.tf.text = "INITIALIZING";	
		}
		
		private function enterFrameHandler (e:Event):void
		{
			var progress = ((__loader.contentLoaderInfo.bytesLoaded * 100) / __loader.contentLoaderInfo.bytesTotal) || 0;
			__percentLoaded += (progress - __percentLoaded) * .25;
			__preload.progress = __percentLoaded;
			
			__font.alpha = Math.random() * .5 + .5;
			
			if (Math.round(__percentLoaded) == 100 && !__hasContent)
			{
				__hasContent = true;
				var main = __loader.contentLoaderInfo.content;
				main.launcher = this;
				addChild(main);
			}
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		public function off ():void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.removeEventListener(Event.RESIZE, resize);
			TweenLite.to(__font, .5, {alpha:0});
			TweenLite.to(__preload, .5, {width:0, x:"-100", alpha:0, ease:Exponential.easeIn, onComplete:function () {
						 // Destroy launcher objects
						 removeChild(__preload);
						 __preload = null;
						 __font = null;
						 }});
		}
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		private function createPreload ():void
		{
			__preload = new ProgressBar;
			__preload.width = 120;
			__preload.height = 10;
			
			addChild(__preload);
			
			// Preload Font
			__font = new PreloadFont;
			__font.tf.autoSize = "right";
			__font.tf.text = "LOADING";
			__font.y = __preload.height;
			__font.x = __preload.width + 2;
			__preload.addChild(__font);
			
			resize();
		}
		
		private function load ():void
		{
			__loader = new Loader;
			__loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderHandler);
			__loader.load(new URLRequest("interfaz.swf")); // SWF to Load
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function resize (e:Event = null):void
		{
			var w:uint = stage.stageWidth;
			var h:uint = stage.stageHeight;
			
			__preload.x = (w - __preload.width) / 2;
			__preload.y = (h - __preload.height) / 2;
		}
	}
}