package net.flashden.lydian.photogallery {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;	
	
	public class Photo extends Sprite {
		
		// A reference to the related gallery item
		private var _galleryItem:GalleryItem;
		
		// Indicates whether the photo is loaded or not
		private var _loaded:Boolean = false;
		
		public function Photo(galleryItem:GalleryItem) {
			
			this._galleryItem = galleryItem;
			mouseEnabled = false;

		}
		
		/**
		 * Starts loading the original photo if it's not already loaded.
		 */
		public function load():void {
			
			if (!_loaded) {
				// Add the necessary event listeners
				_galleryItem.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
				_galleryItem.addEventListener(GalleryItem.PHOTO_LOADED, onComplete, false, 0, true);
				_galleryItem.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);				
				
				// Start loading the photo
				_galleryItem.loadPhoto();
			}
			
		}
		
		/**
		 * Dispatches progress event.
		 */
		private function onProgress(evt:ProgressEvent):void {

			dispatchEvent(evt);
			
		}
		
		/**
		 * This method is called when loading photo is complete.
		 */
		private function onComplete(evt:Event):void {
						
			// Set as photo loaded
			_loaded = true;

			// Remove all event listeners
			_galleryItem.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			_galleryItem.removeEventListener(Event.COMPLETE, onComplete);
			_galleryItem.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			addChild(_galleryItem.photo);
			dispatchEvent(evt);
			
		}
		
		/**
		 * This method is called if an error occurs during reading the file.
		 */
		private function onIOError(evt:IOErrorEvent):void {
			
			trace("An error has occured during reading the file : " + evt.text);
			
		}
		
		/**
		 * Returns the related gallery item.
		 */
		public function get galleryItem():GalleryItem {
			
			return _galleryItem;
			
		}
		
		/**
		 * Returns true if the photo is loaded to the memory.
		 */
		public function get loaded():Boolean {
			
			return _loaded;
			
		}
		
	}
	
}
