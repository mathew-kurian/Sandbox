package net.flashden.lydian.template {
	
	import com.asual.swfaddress.SWFAddress;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
		
	public class TopBar extends MovieClip {
		
		// A loader to load the logo
		private var logoLoader:Loader;
		
		public function TopBar() {
			
			// Initialize the top bar
			init();
			
		}
		
		/**
		 * Initializes the top bar.
		 */
		private function init():void {
			
			// Start loading the logo
			var request:URLRequest = new URLRequest(ConfigManager.LOGO_URL);
			logoLoader = new Loader();
			logoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
			logoLoader.load(request);
			
		}
		
		/**
		 * This method is called when the logo is loaded to the memory.
		 */
		private function onLoadComplete(evt:Event):void {
			
			// Create a holder
			var logo:MovieClip = new MovieClip();
			logo.addChild(logoLoader);
			logo.x = 15;
			logo.y = 15;
			
			// Use logo as a button
			logo.useHandCursor = true;
			logo.buttonMode = true;
			logo.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
			addChild(logo);
			
		}
		
		/**
		 * Navigates to the home page when the logo is clicked.
		 */
		private function mouseDown(evt:MouseEvent):void {
			
			SWFAddress.setValue("/");
			
		}

	}
	
}