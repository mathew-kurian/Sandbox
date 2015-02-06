package net.flashden.lydian.photogallery {
	
	public class Category {

		// An array for holding thumbnails
		private var _thumbnails:Array = new Array();
		
		// An array for holding photos
		private var _photos:Array = new Array(); 
		
		// The data XML to be parsed
		private var _data:XML;
		
		// The index value of the currently loading item
		private var loadingIndex:int = -1;
		
		public function Category(data:XML) {

			this._data = data;
			
			// Initialize the category			
			init();
			
		}
		
		/**
		 * Initializes this category by parsing the xml data.
		 */
		private function init():void {
		
			var index:int = 0;
			
			// Create items
			for each (var photo:XML in _data.photo) {
				var name:String = photo.@name;
				var title:String = photo.title;
				var description:String = photo.description;
				var item:GalleryItem = new GalleryItem(name, title, description);
				var thumbnail:Thumbnail = new Thumbnail(this, index, item);
				var bigPhoto:Photo = new Photo(item);
				_thumbnails.push(thumbnail);
				_photos.push(bigPhoto);
				++index;
			}
			
		}
		
		/**
		 * Loads the next thumbnail in the queue.
		 */
		public function loadNext():void {
								
			if (loadingIndex < length - 1) {
				++loadingIndex;
				_thumbnails[loadingIndex].load();				
			}
			
		}
		
		/**
		 * Returns the number of thumbnails in this category.
		 */
		public function get length():int {
			
			return _thumbnails.length;
			
		}	
		
		/**
		 * Returns the array of the thumbnails for this category.
		 */
		public function get thumbnails():Array {
			
			return _thumbnails;
			
		}
		
		/**
		 * Returns the array of the photos for this category.
		 */
		public function get photos():Array {
			
			return _photos;
			
		}
		
	}
	
}