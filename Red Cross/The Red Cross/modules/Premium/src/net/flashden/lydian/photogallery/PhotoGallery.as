package net.flashden.lydian.photogallery {	

	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import net.flashden.lydian.template.ConfigManager;
	import net.flashden.lydian.template.Preloader;

	public class PhotoGallery extends MovieClip {
		
		// Location of the data xml file
		public static var DATA_XML:String;
		
		// A reference to the gallery manager
		private var _galleryManager:GalleryManager;			
		
		// Holds the active category
		private var _activeCategory:Category;
		
		// The grid menu
		private var _gridMenu:GridMenu;
		
		// The name of the gallery
		private var _name:String;
		
		// Indicates whether the gallery is loaded or not
		private var _loaded:Boolean = false;
		
		 // A preloader to be displayed during loading process
		private var preloader:Preloader = new Preloader();
		
		public function PhotoGallery(name:String, xml:String) {
			
			this._name = name;
			PhotoGallery.DATA_XML = xml;
			
			// Initialize the photo gallery
			init();
			
		}
		
		/**
		 * Initializes the photo gallery.
		 */
		public function init():void {
			
			// Add preloader
			preloader.x = (ConfigManager.CONTENT_HOLDER_WIDTH / 2) - ConfigManager.CONTENT_HOLDER_LEFT_MARGIN;
			preloader.y = (ConfigManager.CONTENT_HOLDER_HEIGHT / 2) - ConfigManager.CONTENT_HOLDER_TOP_MARGIN;
			addChild(preloader);
			
			// Create the gallery manager
			_galleryManager = new GalleryManager();
			_galleryManager.addEventListener(GalleryManager.DATA_READY, onDataReady, false, 0, true);
			
		}
		
		/**
		 * This method is called when the data is read and ready.
		 */
		private function onDataReady(evt:Event):void {
			
			// Hide preloader
			Tweener.addTween(preloader, {alpha:0, time:1, onComplete:onPageLoaded});
	
			// Create the grid menu
			_gridMenu = new GridMenu(this);
			_gridMenu.alpha = 0;
			_gridMenu.y = 7;
			addChild(_gridMenu);
			
			// Select the first category
			var category:Category = _galleryManager.categories[0];
			activeCategory = category;
			_loaded = true;
			addEventListeners();
			dispatchEvent(evt);
			
		}

		/**
		 * Removes preloader and fades the content in.
		 */
		private function onPageLoaded():void {
			
			// Remove preloader
			removeChild(preloader);
			Tweener.addTween(_gridMenu, {alpha:1, time:1});
			
		}
		
		/**
		 * Selects the thumbnail with the given title.
		 */
		public function selectThumbnail(title:String):void {
		
			for (var i = 0; i < _activeCategory.length; i++) {
				var thumbnail:Thumbnail = _activeCategory.thumbnails[i] as Thumbnail;

				if (title == thumbnail.galleryItem.title.toLowerCase()) {
					_gridMenu.selectThumbnail(thumbnail.index);
					return;
				}
			}
			
		}
		
		/**
		 * Sets the active category.
		 */
		public function set activeCategory(activeCategory:Category):void {
			
			this._activeCategory = activeCategory;
			_gridMenu.category = _activeCategory;
			
		}
		
		/**
		 * Adds necessary event listeners.
		 */
		public function addEventListeners():void {
			
			_gridMenu.addEventListeners();
			
		}
		
		/**
		 * Removes event listeners.
		 */
		public function removeEventListeners():void {
			
			_gridMenu.removeEventListeners();
			
		}
		
		/**
		 * Returns the name of the gallery.
		 */
		public override function get name():String {
			
			return _name;
			
		}

		/**
		 * Returns true if banner is loaded to the memory.
		 */
		public function get loaded():Boolean {
			
			return _loaded;
			
		}
				
	}
	
}