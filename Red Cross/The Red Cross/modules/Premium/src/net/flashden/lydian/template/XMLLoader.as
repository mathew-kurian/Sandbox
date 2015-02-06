package net.flashden.lydian.template {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;	
	
	/**
	 * A class for loading external xml files to the
	 * memory and fire appropriate events when parsing process
	 * is completed.
	 */
	public class XMLLoader extends EventDispatcher {
		
		// Indicates whether the cache killer is turned on.
		public static const CACHE_KILLER_ON:Boolean = false;
		
		// The name of the event to be fired when loading is completed
		public static const XML_LOADED:String = "xmlLoaded";
		
		// The xml data to be returned
		private var xml:XML;
		
		// The url of the xml file
		private var url:String;
		
		// A URLRequest instance to be used during loading process
		private var urlRequest:URLRequest;
		
		// A URLLoader instance for loading the xml file
		private var urlLoader:URLLoader;
		
		public function XMLLoader(url:String) {
								
			this.url = url;
			
		}
		
		public function load():void {					
			
			// Create a new URLRequest object, pass our url to it
			if (CACHE_KILLER_ON) {
				urlRequest = new URLRequest(url + "?cache=" + new Date().getTime());
			} else {
				urlRequest = new URLRequest(url);
			}
			
			// Create the URLLoader object and start loading
			urlLoader = new URLLoader(urlRequest);
			
			// Start listening for Event.COMPLETE
			urlLoader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			
			// Start listening for IOErrorEvent.IO_ERROR
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
			
		}
		
		/**
		 * Returns the XML data when parsing process is completed.
		 */
		public function getXML():XML {
			
			return xml;
			
		}
		
		/**
		 * This method is called when parsing xml is completed. It
		 * creates a new XML object and set the data read then fires
		 * events to all listeners.
		 */
		private function onComplete(evt:Event):void {
			
			xml = new XML(evt.target.data);			
			dispatchEvent(new Event(XML_LOADED));
			
		}
		
		/**
		 * This method is called when an error occurs during loading
		 * process.
		 */
		private function onIOError(evt:IOErrorEvent):void {
			
			trace("An error occured during loading XML : " + evt.text);
			trace("** Launch the application within your browser or turn off the cache killer. **");
			
		}		
			
	}
	
}