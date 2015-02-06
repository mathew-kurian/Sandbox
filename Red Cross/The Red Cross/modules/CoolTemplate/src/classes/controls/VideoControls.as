/*
VideoControl.as
CoolTemplate

Created by Alexander Ruiz Ponce on 27/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.controls {
	
	import gT.display.components.GenericComponent;
	import gT.utils.DisplayObjectUtils;
	import gT.utils.EventUtils;
	import gT.display.Draw;
	import gT.utils.ColorUtils;
	
	import gs.TweenLite;
	
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	
	import classes.Global;
	import classes.CustomEvent;
	
	public class VideoControls extends GenericComponent {
		
		private var __controls:VideoControlsAsset;
		private var __icons:Array;
		private var __scaleIcons:Array;
		private var __currentIcon:String;
		private var __scaleMax:Number;
		private var __autoShow:Boolean;
		private var __progressBar:Sprite;
		private var __progress:Number = 0;
		private var __p:Number = 0;
		private var __loaderBar:Sprite;
		private var __progressLoader:Number = 0;
		private var __l:Number = 0;
		private var __acceleration:Number = 10;
		private var __color:uint;
		private var __minAlpha:Number = .5;
		
		public function VideoControls (scaleMax:Number = 3, autoShow:Boolean = true, color:uint = 0xffffff) 
		{
			__scaleMax = scaleMax;
			__autoShow = autoShow;
			__color = color;
			buttonMode = true;

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
			
			addEventListener(MouseEvent.MOUSE_OVER, handler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, handler, false, 0, true);
		}
		
		override protected function onStage():void
		{
			if (__autoShow) show();
			color = __color;
		}
		
		override protected function addChildren():void
		{
			__controls = new VideoControlsAsset;
			__controls.scaleX = 0;
			__controls.scaleY = 0;
			__controls.alpha = 0;
			__controls.visible = false;
			addChild(__controls);
			
			// get the icons and save in the array __icons
			__icons = DisplayObjectUtils.getChildren(__controls.icons);
			
			// save the initial scale por each item in the array __scaleIcons
			__scaleIcons = [];
			for (var i:uint; i < __icons.length; i++) {
				var scaleObject = new Object;
				scaleObject.sx = __icons[i].scaleX;
				scaleObject.sy = __icons[i].scaleY;
				
				__scaleIcons.push(scaleObject);
			}
			
			// Start With "playIcon"
			// availables: playIcon, pauseIcon and spinner
			showIcon("playIcon");
			
			// ProgressBar
			__loaderBar = new Sprite;
			__controls.progressHolder.addChild(__loaderBar);
			
			// LoaderBar
			__progressBar = new Sprite;
			__controls.progressHolder.addChild(__progressBar);
			
			// Fix holder rotation position
			__controls.progressHolder.rotation = -90;
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
		
		public function showIcon (value:String):void
		{
			var spinner = __controls.icons.getChildByName("spinner");
			
			for (var i:uint; i < __icons.length; i++) {
				var icon = __icons[i];
				
				if (value == "spinner") {
					spinner.play();	
				} else {
					spinner.stop();
				}
				
				if (value == icon.name) {
					TweenLite.to(icon, .3, {autoAlpha:1, scaleX:__scaleIcons[i].sx, scaleY:__scaleIcons[i].sy});
				} else {
					TweenLite.to(icon, .3, {autoAlpha:0, scaleX:0, scaleY:0});
				}
			}
			
			__currentIcon = value;
		}
		
		public function show ():void 
		{
			TweenLite.to(__controls, Global.settings.time / 2, {autoAlpha:__minAlpha, scaleX:__scaleMax, scaleY:__scaleMax, delay:.5, ease:Global.settings.easeBack.easeOut});
		}
		
		public function hide ():void 
		{
			TweenLite.to(__controls, Global.settings.time / 2, {autoAlpha:0, scaleX:0, scaleY:0, ease:Global.settings.easeBack.easeIn});
		}
		
		public function render ():void
		{
			__p += (__progress - __p) / __acceleration;
			drawWedge(__progressBar, __color, 1, __p);
			
			__l += (__progressLoader - __l) / __acceleration;
			drawWedge(__loaderBar, __color, .3, __l);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function handler (e:MouseEvent):void
		{
			switch (e.type) {
				case MouseEvent.MOUSE_OVER:
					TweenLite.to(__controls, .5, {alpha:1});
					break;
				case MouseEvent.MOUSE_OUT:
					TweenLite.to(__controls, .5, {alpha:__minAlpha});
					break;
			}
		}
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		private function drawWedge (target:Sprite, color:uint, alpha:Number = 1, arc:Number = 0):void
		{
			var g = target.graphics;
			g.clear();
			g.beginFill(color, alpha);
			Draw.drawWedge(g, 0, 0, 16, arc);
			g.endFill();
		}		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		public function set progress (value:Number):void
		{
			__progress = Math.round((360 * value) / 100);
		}
		
		public function get progress ():Number
		{
			return Math.round((__progress * 100) / 360);
		}
		
		public function set progressLoader (value:Number):void
		{
			__progressLoader = Math.round((360 * value) / 100);
		}
		
		public function get progressLoader ():Number
		{
			return Math.round((__progressLoader * 100) / 360);
		}
		
		public function set color (value:uint):void
		{
			__color = value;
			// Set icons color
			ColorUtils.tint(__controls.icons, __color);
		}
		
		public function get currentIcon ():String
		{
			return __currentIcon;
		}
		
		public function set minAlpha (value:Number):void
		{
			__minAlpha = value;
			__controls.alpha = __minAlpha;
		}
	}
}