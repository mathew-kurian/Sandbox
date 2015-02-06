package net.flashden.lydian.photogallery {
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import com.asual.swfaddress.SWFAddress;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	import net.flashden.lydian.template.ConfigManager;
	import net.flashden.lydian.template.GenericRect;
	import net.flashden.lydian.template.Preloader;
		
	public class PhotoStage extends Sprite {

		// A reference to the current photo on the stage
		private var _photo:Photo;

		// The width of the photo stage
		private var _stageWidth:Number;
		
		// The height of the photo stage
		private var _stageHeight:Number;
		
		// A reference to the PhotoStage
		private static var _photoStage:PhotoStage;
		
		// A generic rectangle to be used as a photo border
		private static var photoBorder:GenericRect = new GenericRect();
		
		// The preloader to be displayed during loading process
		private static var preloader:Preloader = new Preloader();
		
		// A container for holding photos
		private static var photoLayer:Sprite = new Sprite();
		
		// A container for holding stage controls
		private static var controlLayer:Sprite = new Sprite();

		// A rectangle to catch mouse events
		private static var hitRect:GenericRect = new GenericRect();
		
		// The button panel
		private static var _buttonPanel:ButtonPanel = new ButtonPanel();
		
		// Info panel
		private static var _infoPanel:InfoPanel = new InfoPanel();
		
		// Indicates whether the photo stage is enabled or not
		private var _enabled:Boolean = false;
		
		// Indicates whether the info panel is open
		private var infoPanelOpen:Boolean = false;
		
		// Indicates whether the the info panel is displayed or not
		private var displayInfoPanel:Boolean = true;
		
		public function PhotoStage(singletonEnforcer:SingletonEnforcer) {
			// NOTHING HERE
		}
		
		/**
		 * Returns the PhotoStage.
		 */
		public static function getInstance():PhotoStage {
			
			if (_photoStage == null) {
				_photoStage = new PhotoStage(new SingletonEnforcer());
				init();
			}
			
			return _photoStage;
			
		}
		
		/**
		 * Initializes the photo stage.
		 */
		private static function init():void {

			// Add stage controls
			controlLayer.addChild(hitRect);
			controlLayer.addChild(_buttonPanel);					
			
			// Add the photo border
			photoLayer.addChild(photoBorder);
			photoLayer.addChild(preloader);
			photoLayer.addChild(_infoPanel);
			
			// Add layers			
			_photoStage.addChild(controlLayer);
			_photoStage.addChild(photoLayer);
			
			// Change the color of hit rect to black			
			var colorTransform:ColorTransform = hitRect.transform.colorTransform;
			colorTransform.color = 0x000000;
			hitRect.transform.colorTransform = colorTransform;
			
			// Prepare other components
			hitRect.alpha = 0;
			photoBorder.alpha = 0;
			preloader.alpha = 0;
			_infoPanel.alpha = 0;
			photoBorder.width = 200;
			photoBorder.height = 200;
			controlLayer.mouseEnabled = false;
			photoLayer.mouseEnabled = false;
			_photoStage.mouseEnabled = false;			
			
			// Add necessary event listeners
			_buttonPanel.infoButton.addEventListener(MouseEvent.MOUSE_DOWN, 
								_photoStage.mouseDownOnInfoButton, false, 0, true);
			_buttonPanel.closeButton.addEventListener(MouseEvent.MOUSE_DOWN, 
								_photoStage.mouseDownOnCloseButton, false, 0, true);
						
		}
		
		/**
		 * This method is called when the info button is clicked.
		 */
		private function mouseDownOnInfoButton(evt:MouseEvent):void {
			
			if (displayInfoPanel) {
				Tweener.addTween(_infoPanel, {alpha:0, time:1});
				infoPanelOpen = false;
				displayInfoPanel = false;
			} else {
				Tweener.addTween(_infoPanel, {alpha:1, time:1});
				infoPanelOpen = true;
				displayInfoPanel = true;
			}
			
		}
		
		/**
		 * This method is called when the close button is clicked.
		 */
		private function mouseDownOnCloseButton(evt:MouseEvent):void {
			
			close();
			
		}
		
		/**
		 * Closes the photo stage.
		 */
		public function close():void {
			
			// Disable photo stage
			_enabled = false;
			
			// Remove previous event listener
			_photo.removeEventListener(GalleryItem.PHOTO_LOADED, onComplete);
			
			// Hide the content
			Tweener.addTween(_buttonPanel, {y:_stageHeight, time:.5});
			Tweener.addTween(hitRect, {alpha:0, delay:0.3, time:1});
			Tweener.addTween(_photo, {alpha:0, delay:0.3, time:1});
			Tweener.addTween(_infoPanel, {alpha:0, delay:0.3, time:1});
			Tweener.addTween(photoBorder, {alpha:0,  delay:0.3, time:1});
			Tweener.addTween(preloader, {alpha:0, delay:0.3, time:1});
			controlLayer.mouseEnabled = false;
			photoLayer.mouseEnabled = false;
			_photoStage.mouseEnabled = false;			
			
			// Return to the main gallery
			var address:String = SWFAddress.getValue();
			var lastSlashIndex:int = address.lastIndexOf("/");
			SWFAddress.setValue(address.substr(1, lastSlashIndex - 1));
			
		}

		/**
		 * Adds the given photo to the photo stage.
		 */		
		public function setPhoto(nextPhoto:Photo, index:String):void {
			
			// If the stage is not enabled, enable the stage.
			if (!_enabled) {
				_enabled = true;
				
				// Fade the content in
				_buttonPanel.x = (_stageWidth - _buttonPanel.width) / 2;
				_buttonPanel.y = _stageHeight;
				Tweener.addTween(hitRect, {alpha:0.75, time:0.5});
				Tweener.addTween(_buttonPanel, {y:_stageHeight - _buttonPanel.height + 1, delay:.3, time:.4, transition:Equations.easeOutCirc});
				Tweener.addTween(photoBorder, {alpha:1, delay:0.5, time:1});
				controlLayer.mouseEnabled = true;
				photoLayer.mouseEnabled = true;
				_photoStage.mouseEnabled = true;
				
				// Reset the size of the border
				photoBorder.width = 200;
				photoBorder.height = 200;
				
				// Update
				update(_stageWidth, _stageHeight);
			}			

			// Set photo and prepare the info panel
			this._photo = nextPhoto;
			_infoPanel.title.text = _photo.galleryItem.title;
			_infoPanel.subtitle.htmlText = _photo.galleryItem.description;
			_infoPanel.index.text = index;
			
			// Add photo to the photo stage			
			_photo.alpha = 0;
			_infoPanel.alpha = 0;
			infoPanelOpen = false;
			photoLayer.addChild(_photo);
			photoLayer.setChildIndex(_photo, numChildren - 1);
			
			if (photoBorder.alpha < 1) {
				Tweener.addTween(preloader, {alpha:1, delay:0.5, time:1});
			} else {
				Tweener.addTween(preloader, {alpha:1, time:0.5});
			}
					
			// If there are 2 photos on the photo stage, remove the first photo, and event listeners
			// from the previous photo.
			if (photoLayer.numChildren == 5) {
				var firstPhoto = photoLayer.getChildAt(2) as Photo;
				firstPhoto.removeEventListener(GalleryItem.PHOTO_LOADED, onComplete);
				Tweener.addTween(_infoPanel, {alpha:0, time:0.5});
				infoPanelOpen = false;
				photoLayer.removeChild(firstPhoto);
			}
			
			// If the photo is not loaded, start loading else start the animation
			if (!_photo.loaded) {
				_photo.addEventListener(GalleryItem.PHOTO_LOADED, onComplete, false, 0 , true);
				_photo.load();
			} else {
				startAnimation();
			}
						
		}
		
		/**
		 * This method is called whenever the photo is loaded to the memory.
		 */
		public function onComplete(evt:Event):void {
			
			// Remove listeners and start animation
			_photo.removeEventListener(GalleryItem.PHOTO_LOADED, onComplete);			
			startAnimation();
			
		}
		
		/**
		 * Prepares the photo and starts the animation.
		 */		 
		private function startAnimation():void {

			Tweener.addTween(preloader, {alpha:0, delay:.5, time:.8});
			updatePhoto();
			update(_stageWidth, _stageHeight);
			Tweener.addTween(_photo, {alpha:1, delay:0.5, time:1});
			
			if (displayInfoPanel) {
				Tweener.addTween(_infoPanel, {alpha:1, delay:0.5, time:1});
				infoPanelOpen = true;
			}
			
		}
		
		/**
		 * Updates the photo stage and controls.
		 */
		public function update(stageWidth:Number, stageHeight:Number):void {
						
			// Update the stage width and height
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;

			// Update the photo
			if (_photo != null) {
				if (_photo.loaded) {
					updatePhoto();
					_infoPanel.x = _photo.x;
					_infoPanel.y = _photo.y + _photo.height - _infoPanel.height;
					_infoPanel.update(_photo.width);
				}
			}
			
			// Update the width and height of the hit rectangle
			preloader.y = _stageHeight / 2;
			preloader.x = _stageWidth / 2;
			hitRect.width = _stageWidth;
			hitRect.height = _stageHeight;
			
			if (!Tweener.isTweening(_buttonPanel)) {
				_buttonPanel.x = (_stageWidth - _buttonPanel.width) / 2;
				if (_enabled) {
					_buttonPanel.y = _stageHeight - _buttonPanel.height + 1;
				} else {
					_buttonPanel.y = _stageHeight;
				}
			}
			
			photoBorder.x = (_stageWidth - photoBorder.width) / 2;
			photoBorder.y = (_stageHeight - photoBorder.height) / 2;
			
		}
	
		/**
		 * Updates the dimensions and the location of the photo.
		 */		 
		public function updatePhoto():void {
			
			var ratio:Number = _photo.scaleY = _photo.scaleX = 1;
			var localWidth:Number = _photo.width + ConfigManager.PHOTO_BORDER_SIZE * 2;
			var localHeight:Number = _photo.height + ConfigManager.PHOTO_BORDER_SIZE * 2;

			// Calculate photo ratio
			if (_stageWidth / localWidth <  _stageHeight / localHeight) {
				ratio = (_stageWidth - 150) / localWidth;
			} else {
				ratio = (_stageHeight - 150) / localHeight;
			}
			
			// Change the ratio if it's too small
			if (ratio < 0.05) {
				ratio = 0.05;					
			} else if (ratio > 1) {
				ratio = 1;
			}
			
			// Resize photo
			_photo.scaleY = _photo.scaleX = ratio;
			_photo.x = Math.ceil((_stageWidth - _photo.width) / 2);
			_photo.y = Math.ceil((_stageHeight - _photo.height) / 2);
			
			// Calculate border dimensions
			var targetBorderWidth = Math.ceil(_photo.width + ConfigManager.PHOTO_BORDER_SIZE * 2); 
			var targetBorderHeight = Math.ceil(_photo.height + ConfigManager.PHOTO_BORDER_SIZE * 2); 			
			var targetBorderX = Math.ceil(_photo.x - ConfigManager.PHOTO_BORDER_SIZE);
			var targetBorderY = Math.ceil(_photo.y - ConfigManager.PHOTO_BORDER_SIZE); 
			
			// Animate the border
			if (_photo.alpha == 0) {
				Tweener.addTween(photoBorder, {x:targetBorderX, width:targetBorderWidth, time:0.5, transition:Equations.easeOutQuad});
				Tweener.addTween(photoBorder, {y:targetBorderY, height:targetBorderHeight, time:0.5, transition:Equations.easeOutQuad});
			} else {
				photoBorder.x = targetBorderX;
				photoBorder.y = targetBorderY;
				photoBorder.width = targetBorderWidth;
				photoBorder.height = targetBorderHeight;
			}
			
		}
		
		/**
		 * Returns the button panel.
		 */
		public static function get buttonPanel():ButtonPanel {
			
			return _buttonPanel;
			
		}
		
		/**
		 * Returns true if the stage is enabled.
		 */
		public function get enabled():Boolean {
			
			return _enabled;
			
		}
		
	}
	
}