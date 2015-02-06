package net.flashden.lydian.photogallery {
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import net.flashden.lydian.template.ConfigManager;
		
	public class Thumbnail extends Sprite {
				
		// A reference to the related gallery item
		private var _galleryItem:GalleryItem;
		
		// Indicates whether the thumbnail is loaded or not
		private var _loaded:Boolean = false;
		
		// The thumbnail mask
		private var thumbMask:Shape = new Shape();
		
		// The background sprite
		private var backgroundShape:Shape = new Shape();
		
		// The thumbnail border
		private var border:Shape = new Shape();
		
		private var innerBorder:Shape = new Shape();		
		
		// A reference to the category
		private var category:Category;
		
		// The index number of the thumbnail
		private var _index:int;
		
		// The size of the border
		private var borderSize:int;
		
		public function Thumbnail(category:Category, index:int, galleryItem:GalleryItem) {
			
			this.category = category;
			this._index = index;
			this._galleryItem = galleryItem;			
			
			// Initialize the object
			init();

		}
		
		/**
		 * Initializes the thumbnail.
		 */
		private function init():void {
			
			// Use the thumbnail as a button
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = false;
						
			// Prepare thumbnail background, border and mask
			prepareMask();
			prepareBorder();
			prepareBackground();
			
		}
		
		/**
		 * Prepares the mask.
		 */
		private function prepareMask():void {
			
			with (thumbMask) {
				graphics.beginFill(0, 0);
				graphics.drawRect(0, 0, ConfigManager.THUMB_MASK_WIDTH, ConfigManager.THUMB_MASK_HEIGHT);
				graphics.endFill();
			}
			
			thumbMask.x = -ConfigManager.THUMB_MASK_WIDTH / 2;
			thumbMask.y = -ConfigManager.THUMB_MASK_HEIGHT / 2;
			
		}
		
		/**
		 * Paints and adds the background rectangle of the thumbnail.
		 */
		private function prepareBackground():void {
			
			with (backgroundShape) {
				graphics.beginFill(ConfigManager.THUMB_BACKGROUND_COLOR, 1);
				graphics.drawRect(0, 0, ConfigManager.THUMB_MASK_WIDTH, ConfigManager.THUMB_MASK_HEIGHT);
				graphics.endFill();
			}
						
			backgroundShape.x = -ConfigManager.THUMB_MASK_WIDTH / 2;
			backgroundShape.y = -ConfigManager.THUMB_MASK_HEIGHT / 2;
			addChild(backgroundShape);
			
		}
		
		/**
		 * Paints and adds the border of the thumbnail.
		 */
		private function prepareBorder():void {					
			
			var borderSize:int = ConfigManager.THUMB_BORDER_SIZE;
			
			// Start painting the border
			with (border) {
				graphics.beginFill(ConfigManager.THUMB_BORDER_COLOR, 1);
				graphics.drawRect(0, 0,
								  ConfigManager.THUMB_MASK_WIDTH + 2,
								  ConfigManager.THUMB_MASK_HEIGHT + 2);
				graphics.endFill();
			}
			
			border.x = thumbMask.x - 1;
			border.y = thumbMask.y - 1;

			addChild(border);
			
		}

		/**
		 * Starts the loading process.
		 */
		public function load():void {
			
			if (!_loaded) {
				// Add the necessary event listeners
				_galleryItem.addEventListener(GalleryItem.THUMBNAIL_LOADED, onComplete, false, 0, true);
				_galleryItem.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);

				// Start loading the thumbnail
				_galleryItem.loadThumbnail();
			}
			
		}

		/**
		 * This method is called when loading thumbnail is complete.
		 */
		private function onComplete(evt:Event):void {
			
			// Set as thumbnail loaded
			_loaded = true;
			dispatchEvent(evt);

			// Remove all event listeners
			_galleryItem.removeEventListener(GalleryItem.THUMBNAIL_LOADED, onComplete);
			_galleryItem.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			// Resize and add thumbnail
			var thumbnail:Bitmap = _galleryItem.thumbnail;
			thumbnail.scaleY = thumbnail.scaleX = ConfigManager.THUMB_ZOOM_OUT_RATIO;
			thumbnail.x = (thumbMask.width - thumbnail.width - thumbMask.width) / 2;
			thumbnail.y = (thumbMask.height - thumbnail.height - thumbMask.height) / 2;
			thumbnail.mask = thumbMask;
			addChild(thumbMask);
			addChild(thumbnail);
			setChildIndex(thumbnail, 2);
			
			// Animate
			thumbnail.alpha = 0;
			Tweener.addTween(thumbnail, {alpha:0.7, time:2});
			
			// Start loading the next thumbnail		
			category.loadNext();
			
		}
		
		/**
		 * This method is called whenever a new enter frame event occurs.
		 */
		private function onEnterFrame(evt:Event):void {
			
			border.x = thumbMask.x - borderSize;
			border.y = thumbMask.y - borderSize;
			border.width = thumbMask.width + borderSize * 2;
			border.height = thumbMask.height + borderSize * 2;
			backgroundShape.x = -thumbMask.width / 2;
			backgroundShape.y = -thumbMask.height / 2;
			backgroundShape.width = thumbMask.width;
			backgroundShape.height = thumbMask.height;
			
		}
		
		/**
		 * This method is called if an error occurs during loading the file.
		 */
		private function onIOError(evt:IOErrorEvent):void {
						
			trace("An error has occured during reading the file : " + evt.text);
			category.loadNext();
			
		}
				
		/**
		 * Plays mouse over tweens.
		 */
		public function playMouseOver():void {
			
			if (_galleryItem.thumbnail != null) {				
				// Zoom in
				var target:Number = 1 / ConfigManager.THUMB_ZOOM_OUT_RATIO;
				Tweener.addTween(this, {scaleX:target, scaleY:target, time:.5, transition:Equations.easeOutQuint});
				
				// Start listening for enter frame events
				borderSize = ConfigManager.THUMB_BORDER_SIZE;
				addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0 ,true);
				
				// Start resizing thumb mask
				var targetX:Number = galleryItem.thumbnail.x;
				var targetY:Number = galleryItem.thumbnail.y;
				var targetWidth:Number = galleryItem.thumbnail.width;
				var targetHeight:Number = galleryItem.thumbnail.height;
				Tweener.addTween(thumbMask, {x:targetX, y:targetY, width:targetWidth, height:targetHeight, time:.5, transition:Equations.easeOutQuint});
				
				// Change the alpha value of the border
				Tweener.addTween(border, {_color:ConfigManager.HIGHLIGHT_COLOR, alpha:1, time:1});
				Tweener.addTween(_galleryItem.thumbnail, {alpha:1, time:1});
				
				// Hide inner border
				innerBorder.alpha = 0;
				
			}
			
		}
		
		/**
		 * Plays mouse out tweens.
		 */
		public function playMouseOut():void {
			
			if (_galleryItem.thumbnail != null) {
				// Zoom out
				Tweener.addTween(this, {scaleX:1, scaleY:1, time:1});
				borderSize = 1;
				// Start resizing thumb mask
				var targetX:Number = -ConfigManager.THUMB_MASK_WIDTH / 2;
				var targetY:Number = -ConfigManager.THUMB_MASK_HEIGHT / 2;
				var targetWidth:Number = ConfigManager.THUMB_MASK_WIDTH;
				var targetHeight:Number = ConfigManager.THUMB_MASK_HEIGHT;
				Tweener.addTween(thumbMask, {x:targetX, y:targetY,
								width:targetWidth,
								height:targetHeight, time:1.6,
								onComplete:removeEnterFrame});
				
				// Change the alpha value of the border
				Tweener.addTween(border, {_color:ConfigManager.THUMB_BORDER_COLOR, time:1});
				Tweener.addTween(_galleryItem.thumbnail, {alpha:0.8, time:1});
			}			
			
		}
		
		/**
		 * Removes the enter frame listener.
		 */
		private function removeEnterFrame():void {
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		/**
		 * Returns the related gallery item.
		 */
		public function get galleryItem():GalleryItem {
			
			return _galleryItem;
			
		}
		
		/**
		 * Returns the index number of the thumbnail.
		 */
		public function get index():int {
			
			return _index;
			
		}
		
		/**
		 * Returns true if the thumbnail is loaded to the memory.
		 */
		public function get loaded():Boolean {
			
			return _loaded;
			
		}
			
	}
	
}