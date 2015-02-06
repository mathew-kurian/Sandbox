package net.flashden.lydian.photogallery {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import net.flashden.lydian.template.ConfigManager;
		
	public class GalleryItem extends EventDispatcher {
		
		// The name of the event to be fired when loading the thumbnail is finished
		public static const THUMBNAIL_LOADED:String = "thumbLoaded";
		
		// The name of the event to be fired when loading the photo is finished
		public static const PHOTO_LOADED:String = "photoLoaded";		
		
		// The name of the image along with its extension
		private var _name:String;
		
		// The title of the item
		private var _title:String;
		
		// The description of the item
		private var _description:String;
		
		// The loader to be used for loading the thumbnails
		private var _thumbnailLoader:Loader = new Loader();
		
		// The loader to be used for loading the original photo
		private var _photoLoader:Loader = new Loader();
		
		// The thumbnail image as a Bitmap
		private var _thumbnail:Bitmap;
		
		// The original photo as a Bitmap
		private var _photo:Bitmap;
		
		// A URLRequest instance to be used while loading the images
		private var urlRequest:URLRequest;
		
		public function GalleryItem(name:String, title:String, description:String) {
			
			this._name = name;
			this._title = title;
			this._description = description;

		}
		
		/**
		 * Starts loading the thumbnail.
		 */
		public function loadThumbnail():void {
			
			// Add necessary event listeners
			_thumbnailLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onThumbComplete, false, 0, true);
			_thumbnailLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
			
			// Start loading the thumbnail
			_thumbnailLoader.load(new URLRequest(ConfigManager.THUMBNAIL_DIR + _name));
					
		}			
		
		/**
		 * Starts loading the photo.
		 */
		public function loadPhoto():void {					
				
			// Start loading the original photo
			_photoLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onPhotoProgress, false, 0, true);
			_photoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPhotoComplete, false, 0, true);
			_photoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
			
			// Start loading the photo
			_photoLoader.load(new URLRequest(ConfigManager.PHOTO_DIR + _name));
			
		}
		
		/**
		 * This method is called during the photo loading process.
		 */
		private function onPhotoProgress(evt:ProgressEvent):void {
			
			dispatchEvent(evt);
			
		}
		
		/**
		 * This method is called when loading the thumbnail is completed.
		 */
		private function onThumbComplete(evt:Event):void {
			
			// Copy the content of the loader as bitmap
			var bitmapData:BitmapData = new BitmapData(_thumbnailLoader.width, _thumbnailLoader.height, true, 0x00000000);
			bitmapData.draw(_thumbnailLoader);
			_thumbnail = new Bitmap(bitmapData, PixelSnapping.NEVER, true);
			
			// Fire the event
			dispatchEvent(new Event(THUMBNAIL_LOADED));
			
		}
		
		/**
		 * This method is called when loading the photo is completed.
		 */
		private function onPhotoComplete(evt:Event):void {
			
			// Copy the content of the loader as bitmap
			var bitmapData:BitmapData = new BitmapData(_photoLoader.width, _photoLoader.height, true, 0x00000000);
			bitmapData.draw(_photoLoader);
			_photo = new Bitmap(bitmapData, PixelSnapping.NEVER, true);
			
			// Fire the event
			dispatchEvent(new Event(PHOTO_LOADED));			
			
		}
		
		/**
		 * This method is called if an error occurs during the loading process.
		 */
		private function onIOError(evt:IOErrorEvent):void {
			
			dispatchEvent(evt);
			
		}
		
		/**
		 * Returns the name of this gallery item.
		 */
		public function get name():String {
			
			return _name;
			
		}
		
		/**
		 * Returns the title of the item.
		 */
		public function get title():String {
			
			return _title;
			
		}
		
		/**
		 * Returns the description of the item.
		 */
		public function get description():String {
			
			return _description;
			
		}
		
		/**
		 * Returns the thumbnail version of this gallery item.
		 */
		public function get thumbnail():Bitmap {
			
			return _thumbnail;
			
		}
		
		/**
		 * Returns the original photo.
		 */
		public function get photo():Bitmap {
			
			return _photo;
			
		}		
		
	}	
	
}