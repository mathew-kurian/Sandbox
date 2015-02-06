package net.flashden.lydian.template {
	
	import caurina.transitions.Tweener;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;	
	
	public class MainLoader extends MovieClip {
	
		// A preloader to be displayed during the loading process
		private var preloader:MainPreloader = new MainPreloader();
		
		// A loader to load the main swf file
		private var loader:Loader;
			
		public function MainLoader() {
			
			// Initialize the loader
			init();
			
		}
		
		/**
		 * Initializes the loader.
		 */
		private function init():void {
			
			// Prepare the stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);

			// Add preloader
			preloader.x = stage.stageWidth / 2;
			preloader.y = stage.stageHeight / 2;
			preloader.alpha = 0;
			addChild(preloader);
			Tweener.addTween(preloader, {alpha:1, time:1});
			
			// Start loading the main swf			
			var request:URLRequest = new URLRequest("main.swf");
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);			
			loader.load(request);
			
		}
		
		/**
		 * Updates the preloader.
		 */
		private function onProgress(evt:ProgressEvent):void {
			
			preloader.percent = Math.round((evt.bytesLoaded / evt.bytesTotal) * 100);
			
		}
		
		/**
		 * This method is called when the loading process is completed.
		 */
		private function onComplete(evt:Event):void {
			
			Tweener.addTween(preloader, {alpha:0, time:1, onComplete:addLoader});
			
		}
		
		/**
		 * Adds loader to the stage.
		 */
		private function addLoader():void {
			
			addChild(loader);
			
		}
		
		/**
		 * Updates the location of the preloader if the stage is resized.
		 */
		private function onStageResize(evt:Event):void {
			
			// Update the location of the preloader
			preloader.x = Math.ceil(stage.stageWidth / 2);
			preloader.y = Math.ceil(stage.stageHeight / 2);
			
		}
		
	}
	
}