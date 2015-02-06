/*
 CustomTemplate.as
 CoolTemplate
 
 Created by Carlos Vergara Marrugo on 20/11/09.
 Copyright 2009 goTo! Multimedia. All rights reserved.
 */
package classes.templates
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import gT.display.components.GenericComponent;
	import gT.display.Draw;
	
	import classes.Global;
	import classes.CustomEvent;
	import classes.display.jukeBox.ProgressBar;
	import gs.TweenMax;
	
	public class PluginTemplate extends Template {
		
		private var __data:Object;
		private var __preload:ProgressBar;
		private var __loader:Loader;
		private var __percentLoaded:Number = 0;
		private var __src:*;
		private var __mask:Sprite;
		
		public function PluginTemplate (data:Object) {
			__data = data;
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////

		override protected function addChildren():void
		{
			super.addChildren();
			// Title
			__title.text = __data.title;
			
			// holder Mask
			__mask = Draw.rectangle();
			__holder.addChild(__mask);
			__holder.mask = __mask;
			
			//Preload
			__preload = new ProgressBar;
			__preload.color = Global.settings.globalColor1;
			__preload.width = 80;
			__preload.height = 6;
			__preload.y = 20;
			
			__mainHolder.addChild(__preload);
			
			//SWF Loader
			__loader = new Loader();
			__loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderHandler, false, 0, true);
			
			draw();
		}
		
		override protected function onTemplateOn ():void
		{
			Global.addEventListener(CustomEvent.GLOBAL_RENDER, render, false, 0, true);
			__loader.load(new URLRequest(__data.src));
		}
		
		override protected function destroy ():void
		{
			try {
				__loader.close();
				__loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderHandler);
			} catch (e) {};
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			super.draw();
			
			if(__preload){
				__preload.x = __width - __preload.width - MARGIN_X*2;
			}
			
			if(__src && __data.resizable){
				__src.width = __contentWidth;
				__src.height = __contentHeight;
			}
			
			__mask.width = __contentWidth;
			__mask.height = __contentHeight;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function loaderHandler(e:Event):void{
			__src = e.target.content;
			__src.path = __data.path;
		}
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		private function render (e:CustomEvent):void
		{
			var progress = ((__loader.contentLoaderInfo.bytesLoaded * 100) / __loader.contentLoaderInfo.bytesTotal) || 0;
			__percentLoaded += (progress - __percentLoaded) * .25;
			__preload.progress = __percentLoaded;
			
			if (Math.round(__percentLoaded) == 100)
			{
				onComplete();
			}
		}
		
		private function onComplete ():void
		{
			Global.removeEventListener(CustomEvent.GLOBAL_RENDER, render);
			
			TweenMax.to(__preload, .5, {width:0, x:"-50", alpha:0, ease:Global.settings.easeIn, onComplete:function () {
						__mainHolder.removeChild(__preload);
						__preload = null;
						}});
			
			__holder.addChild(__src);
			draw();
			
			TweenMax.from(__src, Global.settings.time/2, {alpha:0});
		}
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
	}
}