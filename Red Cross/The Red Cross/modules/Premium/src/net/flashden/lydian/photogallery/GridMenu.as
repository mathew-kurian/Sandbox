package net.flashden.lydian.photogallery {
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import com.asual.swfaddress.SWFAddress;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.flashden.lydian.template.ConfigManager;
	import net.flashden.lydian.template.GenericRect;
	import net.flashden.lydian.template.LeftButton;
	import net.flashden.lydian.template.RightButton;	
	
	public class GridMenu extends MovieClip {
		
		// A reference to the active category
		private var _category:Category;
		
		// A container sprite to hold thumbnails
		private var container:Sprite = new Sprite();
		
		// The menu mask
		private var menuMask:GenericRect = new GenericRect();
		
		// The photo stage
		private var photoStage:PhotoStage = PhotoStage.getInstance();
		
		// Current page index
		private var pageIndex:int = 0;
		
		// A reference to the actual photo gallery
		private var photoGallery:PhotoGallery;
		
		// An array to hold page sprites
		private var pages:Array = new Array();
		
		// Left navigation button
		private var leftButton:LeftButton = new LeftButton();
		
		// Right navigation button
		private var rightButton:RightButton = new RightButton();
		
		// Number of the total pages
		private var pageCount:int;
		
		// Current thumbnail index
		private var _currentIndex:int = -1;
		
		public function GridMenu(photoGallery:PhotoGallery) {
						
			this.photoGallery = photoGallery;
			
			// Initialize
			init();
				
		}
		
		public function init():void {
			
			// Prepare menu components
			prepareMask();
			container.x = menuMask.x;
			container.y = menuMask.y;
			addChild(container);
			leftButton.x = menuMask.x - 50;
			leftButton.y = menuMask.y + menuMask.height / 2;
			rightButton.x = menuMask.x + menuMask.width + 50;
			rightButton.y = leftButton.y;
			addChild(leftButton);
			addChild(rightButton);
			container.mask = menuMask;
				
			// Add necessary event listeners
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, false);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			leftButton.addEventListener(MouseEvent.MOUSE_DOWN, onLeftButton, false, 0, true);
			rightButton.addEventListener(MouseEvent.MOUSE_DOWN, onRightButton, false, 0, true);
			
		}
		
		/**
		 * Adds necessary event listeners to the photo stage.
		 */
		public function addEventListeners():void {
			
			PhotoStage.buttonPanel.prevButton.addEventListener(MouseEvent.MOUSE_DOWN, onPrevButton, false, 0, true);
			PhotoStage.buttonPanel.nextButton.addEventListener(MouseEvent.MOUSE_DOWN, onNextButton, false, 0, true);
			
		}
		
		/**
		 * Removes event listeners from the photo stage.
		 */
		public function removeEventListeners():void {
			
			PhotoStage.buttonPanel.prevButton.removeEventListener(MouseEvent.MOUSE_DOWN, onPrevButton, false);
			PhotoStage.buttonPanel.nextButton.removeEventListener(MouseEvent.MOUSE_DOWN, onNextButton, false);			
			
		}
		
		/**
		 * This method is called when the mouse is clicked on the prev button.
		 */
		private function onPrevButton(evt:MouseEvent):void {
			
			selectPreviousThumbnail();
			
		}
		
		/**
		 * This method is called when the mouse is clicked on the next button.
		 */
		private function onNextButton(evt:MouseEvent):void {
			
			selectNextThumbnail();
			
		}
		
		/**
		 * This method is called when the mouse is clicked on the left navigation button.
		 */
		private function onLeftButton(evt:MouseEvent):void {
			
			if (pageIndex != 0) {
				slideTo(--pageIndex);
				checkButtons();
			}
			
		}
		
		/**
		 * This method is called when the mouse is clicked on the right navigation button.
		 */
		private function onRightButton(evt:MouseEvent):void {
			
			if (pageIndex != pageCount - 1) {
				slideTo(++pageIndex);
				checkButtons();
			}
			
		}
		
		/**
		 * Prepares and adds menu mask.
		 */
		private function prepareMask():void {
			
			var numOfColumns:int = ConfigManager.NUM_OF_COLUMNS;
			var numOfRows:int = ConfigManager.NUM_OF_ROWS;
			var thumbWidth:Number = ConfigManager.THUMB_MASK_WIDTH + 2;
			var thumbHeight:Number = ConfigManager.THUMB_MASK_HEIGHT + 2;
			var space:Number = ConfigManager.SPACE_BETWEEN_THUMBNAILS;
			
			var maskWidth:Number = numOfColumns * thumbWidth + (numOfColumns - 1) * space;
			var maskHeight:Number = numOfRows * thumbHeight + (numOfRows - 1) * space;
			menuMask.width = maskWidth;
			menuMask.height = maskHeight;
			menuMask.alpha = 0;
			menuMask.x = 50;
			menuMask.y = 15;
			addChild(menuMask);
			
		}
				
		/**
		 * Slides container to the given page index.
		 */
		private function slideTo(index:int) {
			
			// Calculate and slide to target
			displayPages();
			var target:Number = menuMask.x - index * (menuMask.width + ConfigManager.SPACE_BETWEEN_THUMBNAILS); 
			Tweener.addTween(container, {x:target, time:0.95, transition:Equations.easeOutQuint, onComplete:hidePages});
			
		}
		
		/**
		 * Hides all of the pages except the current page.
		 */
		private function hidePages():void {
			
			for (var i = 0; i < pages.length; i++) {
				var page:Sprite = pages[i];
				
				if (i != pageIndex) {
					page.visible = false;
				}
			}
			
			container.mask = null;
			container.mouseChildren = true;
			
		}
		
		/**
		 * Makes all of the pages visible. 
		 */
		private function displayPages():void {
			
			for (var i = 0; i < pages.length; i++) {
				var page:Sprite = pages[i];
				page.visible = true;
			}
			
			container.mask = menuMask;
			container.mouseChildren = false;
			
		}
		
		
		/**
		 * This method is called when mouse is over a thumbnail.
		 */
		private function onMouseOver(evt:MouseEvent):void {					
			
			// Get the thumbnail
			var thumbnail:Thumbnail = evt.target as Thumbnail;
			
			if (thumbnail != null && thumbnail.galleryItem.thumbnail != null) {
				var page:Sprite = pages[findPageNumber(thumbnail.index)];
				page.setChildIndex(thumbnail, page.numChildren - 1);
				thumbnail.playMouseOver();
			}
			
		}
		
		/**
		 * This method is called when the mouse leaves a thumbnail.
		 */
		private function onMouseOut(evt:MouseEvent):void {
			
			var thumbnail:Thumbnail = evt.target as Thumbnail;
			
			if (thumbnail != null) {
				thumbnail.playMouseOut();
			}
			
		}
		
		/**
		 * This method is called when mouse is clicked on a thumbnail.
		 */
		private function onMouseDown(evt:MouseEvent):void {
			
			var thumbnail:Thumbnail = evt.target as Thumbnail;
			
			// Select the given thumbnail
			if (thumbnail != null) {
				// Set the photo address
				SWFAddress.setValue("/" + photoGallery.name.replace(/ /g, "_").toLowerCase() + "/" + thumbnail.galleryItem.title.replace(/ /g, "_").toLowerCase());
			}
			
		}
		
		/**
		 * Selects the next thumbnail.
		 */
		public function selectNextThumbnail():void {
						
			if (_currentIndex < _category.length - 1) {
				var thumbnail:Thumbnail = category.thumbnails[_currentIndex + 1];
				SWFAddress.setValue("/" + photoGallery.name.replace(/ /g, "_").toLowerCase() + "/" + thumbnail.galleryItem.title.replace(/ /g, "_").toLowerCase());
			}			
			
		}
		
		/**
		 * Selects the previous thumbnail.
		 */
		public function selectPreviousThumbnail():void {
						
			if (_currentIndex > 0) {
				var thumbnail:Thumbnail = category.thumbnails[_currentIndex - 1];
				SWFAddress.setValue("/" + photoGallery.name.replace(/ /g, "_").toLowerCase() + "/" + thumbnail.galleryItem.title.replace(/ /g, "_").toLowerCase());
			}			
			
		}
		
		/**
		 * Selects the thumbnail with the given index number
		 */
		public function selectThumbnail(index:int):void {

			// Load photo to the stage
			var photo:Photo = category.photos[index];
			photoStage.setPhoto(photo, (index + 1) + " / " + category.length);
			_currentIndex = index;
			
		}
		
		/**
		 * Checks the status of the previous and next buttons. Updates
		 * states by calling appropriate methods.
		 */
		private function checkButtons():void {
			
			if (pageIndex < pageCount - 1) {
				rightButton.mouseEnabled = true;
				rightButton.alpha = 1;
			} else {
				rightButton.mouseEnabled = false;
				rightButton.alpha = 0.2;
			}
			
			if (pageIndex == 0) {
				leftButton.mouseEnabled = false;
				leftButton.alpha = 0.2;
			} else {
				leftButton.mouseEnabled = true;
				leftButton.alpha = 1;
			}

		}
		
		/**
		 * Returns the page number of the given thumbnail index.
		 */
		private function findPageNumber(index:int):int {
			
			return Math.floor(index / (ConfigManager.NUM_OF_COLUMNS * ConfigManager.NUM_OF_ROWS));
			
		}
		
		/**
		 * Updates the thumbnail menu
		 */
		private function update():void {
			
			var numOfColumns:int = ConfigManager.NUM_OF_COLUMNS;
			var numOfRows:int = ConfigManager.NUM_OF_ROWS;
			var thumbWidth:Number = ConfigManager.THUMB_MASK_WIDTH + 2;
			var thumbHeight:Number = ConfigManager.THUMB_MASK_HEIGHT + 2;
			var spacing:Number = ConfigManager.SPACE_BETWEEN_THUMBNAILS;
			var pageLimit:int = numOfColumns * numOfRows;
			pageCount = Math.ceil(category.length / pageLimit);
			
			category.loadNext();
			
			for (var i:int = 0; i < pageCount; i++) {
				var page:Sprite = new Sprite();
				
				if (i == pageCount - 1) {
					var result:int = category.length % pageLimit;
					pageLimit = result > 0 ? result : pageLimit;
				}
				
				for (var j:int = 0; j < pageLimit; j++) {
					var index:int = i * numOfColumns * numOfRows + j;
					var thumb:Thumbnail = category.thumbnails[index];
					thumb.x = (index % numOfColumns) * (thumbWidth + spacing) + thumbWidth / 2;
					thumb.y = ((Math.floor(index / numOfColumns)) % numOfRows) * (spacing + thumbHeight) + thumbHeight / 2;
					page.addChild(thumb);
				}
				
				page.x = i * numOfColumns * (spacing + thumbWidth);
				
				pages.push(page);
				container.addChild(page);
				
			}
			
			addChild(container);
			hidePages();
			
		}
		
		/**
		 * Removes all the thumbnails on the container.
		 */
		public function clear():void {
			
			// Remove all thumbnails
			for (var i:int = 0; i < category.length; i++) {
				var thumb:Thumbnail = category.thumbnails[i];
				container.removeChild(thumb);
			}
			
		}
		
		/**
		 * Returns the current category.
		 */
		public function get category():Category {
			
			return _category;
			
		}
		
		/**
		 * Sets the given category and updates the menu.
		 */
		public function set category(category:Category):void {
			
			// Clear menu
			if (container.numChildren > 0) {
				clear();	
			}
			
			// Update
			this._category = category;
			update();
			checkButtons();
			
		}
				
	}
	
}