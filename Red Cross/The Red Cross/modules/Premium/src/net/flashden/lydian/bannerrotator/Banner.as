package net.flashden.lydian.bannerrotator {
	
	import com.asual.swfaddress.SWFAddress;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class Banner extends Sprite {
		
		// Location of the image
		private var _imageURL:String;
		
		// The link to be launched when clicked on banner
		private var _link:String;
		
		// Holds the target browser window to open the given url
		private var _target:String;
		
		// A URLRequest instance to be used while loading the image or swf
		private var urlRequest:URLRequest;

		// The loader to be used for loading external images and swfs 
		private var loader:Loader = new Loader();
		
		// Indicates whether the item is loaded or not
		private var _loaded:Boolean = false;
		
		public function Banner(imageURL:String, link:String, target:String = null) {
			
			this._imageURL = imageURL;
			this._link = link;
			this._target = target;
			
			// Initialize the object
			init();
			
		}
		
		/**
		 * Initializes the banner.
		 */
		private function init():void {
			
			// Use this banner as a button
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = false;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			
		}
		
		/**
		 * Starts loading this banner.
		 */
		public function load():void{
			
			// If the item is not loaded, start loading
			if (!_loaded) {
				// Create the url request and add event listeners
				urlRequest = new URLRequest(_imageURL);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressEvent, false, 0, true);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
								
				// Start loading the content
				loader.load(urlRequest);
			}
			
		}
		
		/**
		 * Cancels the loading process.
		 */
		public function cancelLoading():void {
			
			// If the loader is not null, close the stream and unload
			if (!_loaded) {
				if (loader != null) {
					try {			
						loader.close();
						loader.unload();
					} catch (e:Error) {
					}
				}
			}
				
		}
		
		/**
		 * Dispatches progress event.
		 */
		private function onProgressEvent(evt:ProgressEvent):void {
			
			dispatchEvent(evt);

		}
		
		/**
		 * This method is called when the loading process is completed.		 
		 */
		private function onComplete(evt:Event):void {
			
			// Loading process is completed, add loader to display list
			_loaded = true;
			alpha = 0;
			addChild(loader);
			dispatchEvent(evt);
					
		}
		
		/**
		 * This method is called if an error occurs during the loading process.		 
		 */
		private function onIOError(evt:IOErrorEvent):void {
			
			// An error occured during loading the file
			trace("An error occured during loading the file : " + evt.text);
			
		}
		
		/**
		 * This method is called when the banner is clicked.
		 */
		private function onMouseDown(evt:MouseEvent):void {
			
			// Check the type of the link and take appropriate action
			if (_link != null) {
				if (_link.substr(0, 7) == "http://") {					
					try {
						navigateToURL(new URLRequest(_link), _target);
					} catch (e:Error) {
						trace("The page cannot be load:" + _link);
					}
				} else {
					SWFAddress.setValue(_link);
				}
			}
			
		}
		
		/**
		 * Returns true if banner is loaded to the memory.
		 */
		public function get loaded():Boolean {
			
			return _loaded;
			
		}
		
	}
	
}