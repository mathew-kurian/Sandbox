/*
SocialIcons.as

Created by Carlos Andres Viloria Mendoza  on 2/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display {
	
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import gs.TweenMax;
	import gs.plugins.TweenPlugin;
	import gT.display.InteractiveBitmap;
	import classes.Global;
	import classes.CustomEvent;
	
	public class SocialIcons extends Sprite {
		
		private var __icons:Array;
		private var __cont:uint;
		private var __iconWidth:uint = 32;
		private var __space:uint = 10;
		
		private var __elements:Array = [];
		private var __column:int = 6;
		private var __separation:Number = 5;
		private var __loader:Loader;
		
		public function SocialIcons (icons:Array) {
			
			__icons = icons;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init (e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			loadNext();
		}
				
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		public function destroy ():void
		{
			try {
				__loader.close();
				__loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, addIcon);
			} catch (e) {};
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function addIcon (e:Event):void
		{
			var icon = new InteractiveBitmap(e.currentTarget.content.bitmapData);
			icon.smoothing = true;
			icon.buttonMode = true;
			icon.name = String(__cont);
			
			icon.addEventListener(MouseEvent.CLICK, iconHandler, false, 0, true);
			icon.addEventListener(MouseEvent.MOUSE_OVER, iconHandler, false, 0, true);
			icon.addEventListener(MouseEvent.MOUSE_OUT, iconHandler, false, 0, true);
			
			//icon.x = (__iconWidth + __space) * __cont;		
			addChild(icon);
			__elements.push(icon);
			
			draw();
			if (__cont < __icons.length-1) {
				__cont++;
				loadNext();
			}
			
			TweenMax.from(icon, Global.settings.time/2, {alpha:0});
		}
		
		private function draw():void
		{
			for(var j:uint = 0; j < __elements.length; j++){
				__elements[j].x = (j % __column) * (__elements[j].width + __separation);
				__elements[j].y = Math.floor((j / __column)) * (__elements[j].height + __separation);
			}	
		}
		
		private function iconHandler (e:MouseEvent):void
		{
			switch (e.type) {
				case MouseEvent.CLICK:
					navigateToURL(new URLRequest(__icons[uint(e.currentTarget.name)].url), "_blank");
					break;
				case MouseEvent.MOUSE_OVER:
					TweenMax.to(e.currentTarget, Global.settings.time/2, {glowFilter:{color:Global.settings.globalColor1, alpha:1, blurX:10, blurY:10, strength:1, quality:3}});
					break;
				case MouseEvent.MOUSE_OUT:
					TweenMax.to(e.currentTarget, Global.settings.time/2, {glowFilter:{color:Global.settings.globalColor1, alpha:0, blurX:0, blurY:0}});
					break;
			}
			
		}
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		private function loadNext ():void
		{				 
			__loader = new Loader;
			__loader.contentLoaderInfo.addEventListener(Event.COMPLETE, addIcon);
			__loader.load(new URLRequest(__icons[__cont].icon));
		}
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
	}
}