package net.flashden.lydian.photogallery {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import net.flashden.lydian.template.XMLLoader;	
	
	public class GalleryManager extends EventDispatcher {
		
		// The name of the event to be fired when the data is ready
		public static const DATA_READY:String = "dataReady";
		
		// The xml data
		private var xml:XML;
		
		// An XMLLoader instance to load the data xml file to the memory
		private var dataXMLLoader:XMLLoader;
		
		// An array to hold categories
		private var _categories:Array;
		
		public function GalleryManager() {
			
			// Initialize the object
			init();
			
		}
		
		/**
		 * Initializes the gallery manager.
		 */
		private function init():void {
			
			// Start loading the data.xml file
			dataXMLLoader = new XMLLoader(PhotoGallery.DATA_XML);
			dataXMLLoader.addEventListener(XMLLoader.XML_LOADED, onDataXMLLoaded);
			dataXMLLoader.load();
			
		}
		
		/**
		 * This method is called when the data.xml is loaded.		 
		 */
		private function onDataXMLLoaded(evt:Event):void {
						
			// Get the xml data
			xml = dataXMLLoader.getXML();
			
			// Create categories
			_categories = new Array();
			
			// Read categories
			
				var category:Category = new Category(xml);				
				_categories.push(category);
			
			// Dispatch event
			dispatchEvent(new Event(DATA_READY));
			
		}
		
		/**
		 * Returns the array of the categories.
		 */
		public function get categories():Array {
			
			return _categories;
			
		}
		
	}
	
}