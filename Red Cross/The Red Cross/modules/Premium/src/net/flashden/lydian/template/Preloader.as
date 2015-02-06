package net.flashden.lydian.template {
	
	import flash.display.MovieClip;
	import flash.events.Event;
		
	public class Preloader extends MovieClip {
	
		public function Preloader() {
			
			// Initialize the preloader
			init();
			
		}
		
		/**
		 * Initializes the preloader.
		 */
		private function init():void {

			// Disable mouse
			mouseEnabled = false;
			
			// Start listening for the enter frame events
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			
		}
		
		/**
		 * Rotates the preloader on each enter frame event.
		 */
		private function onEnterFrame(evt:Event):void {
			
			rotation += 20;
			
		}
		
	}
	
}