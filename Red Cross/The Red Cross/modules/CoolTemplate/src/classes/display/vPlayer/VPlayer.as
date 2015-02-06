/*
VPlayer.as
CoolTemplate

Created by Alexander Ruiz Ponce on 27/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display.vPlayer
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Video;
	
	import gs.TweenLite;
	
	import gT.display.components.GenericComponent;
	import gT.display.Draw;
	import gT.net.EasyNetStream;
	import gT.utils.DisplayObjectUtils;
	import gT.utils.ObjectUtils;
	import gT.utils.ColorUtils;
	
	import classes.controls.VideoControls;
		
	public class VPlayer extends GenericComponent {
		
		private var __ns:EasyNetStream;
		private var __video:Video;
		private var __isPlaying:Boolean;
		private var __duration:Number;
		private var __forceSize:Boolean;
		private var __controls:VideoControls;
		private var __bufferTime:Number = 10;
		private var __loop:Boolean;
		private var __background:Sprite;
		private var __mask:Sprite;
		private var __backgroundColor:uint = 0x333333;
		private var __backgroundAlpha:Number = 1;
		private var __source:String;
		
		public function VPlayer () {
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
			setSize(100, 100);
		}
		
		override protected function onRemovedFromStage ():void
		{
			destroy();
		}
		
		/*
		override protected function onStage():void
		{
		}
		 */
		
		override protected function addChildren():void
		{
			// Mask
			__mask = Draw.rectangle(10, 10, 0xff0000, .5);
			addChild(__mask);
			mask = __mask;
			
			// Background
			__background = Draw.rectangle(10, 10, __backgroundColor, __backgroundAlpha);
			addChild(__background);
			
			// Controls
			__controls = new VideoControls;
			//__controls.minAlpha = .1;
			__controls.addEventListener(MouseEvent.CLICK, controlsHandler, false, 0, true);
			
			addChild(__controls);
			
			// Net Stream
			__ns = new EasyNetStream;
			__ns.bufferTime = __bufferTime;
			__ns.addEventListener(EasyNetStream.ON_META_DATA, nsHandler, false, 0, true);
			__ns.addEventListener(EasyNetStream.STATUS, nsHandler, false, 0, true);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			if (__video)
			{
				DisplayObjectUtils.setProporcionalSize(__video, __width, __height, __forceSize);
				DisplayObjectUtils.centerToObject(__video, this);
			}
			
			DisplayObjectUtils.centerToObject(__controls, this, false);
			 
			__background.width = __width;
			__background.height = __height;
			__mask.width = __width;
			__mask.height = __height;
		}
		
		public function play (url:String = null):void
		{
			if (url) __source = url;
			
			if (__source) {
				__isPlaying = true;
				__ns.play(__source);
				__controls.showIcon("pauseIcon");
			}
		}
		
		public function pause ():void
		{
			__ns.pause();
		}
		
		public function togglePause ():void
		{
			__ns.togglePause();
		}
		
		public function render ():void
		{
			__controls.render();
			__controls.progress = ((__ns.time * 100) / __duration) || 0;
			__controls.progressLoader = ((__ns.bytesLoaded * 100) / __ns.bytesTotal) || 0;
		}
		
		
		public function destroy ():void
		{
			try {
				__ns.close();
				removeChild(__video); 
				__video = null;
			} catch (e) {}
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function nsHandler (e:*):void 
		{	
			if (e.type == "status") {
				switch (__ns.status) {
					case "full" :
						__controls.showIcon("pauseIcon");
						break;
						
					case "empty" :
						if (__video && __isPlaying) {
							__controls.showIcon("spinner");
						}
						break;
						
					case "flush" :
						if (!__isPlaying) {
							__controls.showIcon("playIcon");
						} else {
							__controls.showIcon("pauseIcon");
						}
						break;
						
					case "start" :
						break;
						
					case "stop" :
						__isPlaying = false;
						__controls.showIcon("playIcon");
						onNsComplete();
						break;
						
					default :
						trace("vPlayer:", __ns.status);
				}
			} else {
				__duration = __ns.metaData.duration;
				createVideo(__ns.metaData.width, __ns.metaData.height);
			}
		}
		
		private function controlsHandler (e:MouseEvent):void
		{
			switch (__controls.currentIcon) {
				case "playIcon":
					if (__source)
					{
						if (!__isPlaying && !__video) {
							__isPlaying = true;
							__ns.play(__source);
						} else {
							__isPlaying = true;
							togglePause();
						}
						__controls.showIcon("pauseIcon");
					}
					break;
				case "pauseIcon":
					if (__isPlaying) {
						__isPlaying = false;
						__controls.showIcon("playIcon");
						togglePause();
					}
					break;

			}
		}
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		private function createVideo (w:Number, h:Number):void 
		{
			if (__video) {
				removeChild(__video);
				__video = null;
			}
			
			__video = new Video(w, h);
			__video.attachNetStream(__ns);
			__video.smoothing = true;
			
			addChild(__video);
			addChild(__controls);
			
			draw();
		}
		
		private function onNsComplete ():void
		{
			if (__loop) 
			{
				__ns.seek(0);
				__isPlaying = true;
			} else {
				mouseChildren = false;
				TweenLite.to(__video, 1, {alpha:0, onComplete:function () {
							 removeChild(__video); 
							 __video = null;
							 mouseChildren = true;
							 }});
			}
		}
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		public function set forceSize (value:Boolean):void
		{
			__forceSize = value;
			draw();
		}
		
		public function set bufferTime (value:Number):void
		{
			__bufferTime = value;
			__ns.bufferTime = __bufferTime;
		}
		
		public function get bufferTime ():Number
		{
			return __bufferTime;
		}
		
		public function get controls ():VideoControls
		{
			return __controls;
		}
		
		public function set loop (value:Boolean):void
		{
			__loop = value;
		}
		
		public function get background ():Sprite
		{
			return __background;
		}
		
		public function set backgroundColor (value:uint):void
		{
			__backgroundColor = value;
			ColorUtils.tint(__background, __backgroundColor);
		}
		
		public function set backgroundAlpha (value:Number):void
		{
			__backgroundAlpha = value;
			__background.alpha = value;
		}
		
		public function set source (value:String):void
		{
			__source = value;
		}
		
		public function get source ():String
		{
			return __source;
		}
	}
}