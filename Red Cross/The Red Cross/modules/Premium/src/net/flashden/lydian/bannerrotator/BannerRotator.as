package net.flashden.lydian.bannerrotator {
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	import net.flashden.lydian.template.ConfigManager;

	public class BannerRotator extends MovieClip {
		
		// Array of the banners
		private var _banners:Array;
		
		// The container which holds the items
		private var container:Sprite = new Sprite();
		
		// A sprite for masking banners
		private var bannerMask:SimpleRectangle = new SimpleRectangle();
		
		// The button menu
		private var buttonMenu:NumberButtonMenu;
		
		// Holds the current index
		private var _currentIndex:int = -1;
		
		// Holds the previous index
		private var _prevIndex:int = -1;
		
		public function BannerRotator() {
			
			// Initialize the rotator
			init();
			
		}
				
		/**
		 * Initializes the banner rotator.
		 */
		private function init():void {

			// Prepare screen components
			prepareBorder();
			prepareBackground();
			prepareMask();
			prepareContainer();
			
		}
		
		/**
		 * This method is called whenever a new selection occurs.
		 */
		private function onSelected(evt:NumberButtonEvent):void {
			
			// Get index numbers
			_currentIndex = evt.index;
			_prevIndex = evt.previousIndex;
			
			// Get the previous banner and remove the event listener in case it has not been removed.
			if (_prevIndex != -1) {
				var prevBanner:Banner = _banners[_prevIndex];
				
				if (!prevBanner.loaded) {
					prevBanner.removeEventListener(Event.COMPLETE, onLoadComplete);
					prevBanner.cancelLoading();
				}
			}
			
			var banner:Banner = _banners[_currentIndex];
			
			// If banner is not loaded, start loading
			if (!banner.loaded) {
				fadeOut(_prevIndex);
				banner.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
				banner.load();
			} else {
				fadeOut(_prevIndex);
				startAnimation();
			}
			
		}

		/**
		 * This method is called when loading process is completed.
		 */
		private function onLoadComplete(evt:Event):void {
	
			// Remove event listeners
			var banner:Banner = _banners[_currentIndex];
			banner.removeEventListener(Event.COMPLETE, onLoadComplete);
			startAnimation();
			
		}
		
		/**
		 * Starts tweens.
		 */
		private function startAnimation():void {
						
			fadeIn(_currentIndex);
			
		}
		
		/**
		 * Prepares the banner rotator's border.
		 */
		private function prepareBorder():void {
			
			// Set border dimensions
			border.width = ConfigManager.BANNER_WIDTH + ConfigManager.BR_BORDER_SIZE * 2;
			border.height = ConfigManager.BANNER_HEIGHT + ConfigManager.BR_BORDER_SIZE * 2;
			
			// Change the color
			var colorTransform:ColorTransform = border.transform.colorTransform;
			colorTransform.color = ConfigManager.BR_BORDER_COLOR;
			border.transform.colorTransform = colorTransform;
			
		}
		
		/**
		 * Prepares the background.
		 */
		private function prepareBackground():void {
			
			// Set background dimensions
			background.width = ConfigManager.BANNER_WIDTH;
			background.height = ConfigManager.BANNER_HEIGHT;
			background.y = background.x = ConfigManager.BR_BORDER_SIZE;
			
			// Change the color
			var colorTransform:ColorTransform = background.transform.colorTransform;
			colorTransform.color = ConfigManager.BR_BACKGROUND_COLOR;
			background.transform.colorTransform = colorTransform;
			
		}
		
		/**
		 * Prepares the mask.
		 */
		private function prepareMask():void {
			
			// Prepare the mask
			bannerMask.width = ConfigManager.BANNER_WIDTH;
			bannerMask.height = ConfigManager.BANNER_HEIGHT;
			bannerMask.y = bannerMask.x = background.x;
			container.mask = bannerMask;
			addChild(bannerMask);
			
		}
		
		/**
		 * Prepares and adds the container.
		 */
		private function prepareContainer():void {
			
			// Prepare container
			container.y = container.x = background.x;
			addChild(container);
			
		}
		
		/**
		 * Prepares and adds the button menu.
		 */
		private function addButtonMenu():void {
			
			// Set the location of the button menu
			buttonMenu = new NumberButtonMenu(_banners.length);
			buttonMenu.addEventListener(NumberButtonEvent.SELECTED, onSelected, false, 0, true);
			buttonMenu.y = border.height + 39;
			buttonMenu.x = (border.width - buttonMenu.width) / 2;
			addChild(buttonMenu);
			
		}
		
		/**
		 * Adds all of the banners to the container.
		 */
		private function addBanners():void {
						
			// Create banners
			for (var i:int = 0; i < _banners.length; i++) {
				container.addChild(_banners[i]);
			}
			
			// Add the button menu
			addButtonMenu();
			buttonMenu.select(0); 
				
		}
		
		/**
		 * Fades the banner with the given index number in.
		 */
		public function fadeIn(index:uint):void {
			
			if (index != -1) {
				var banner:Banner = _banners[index];
				banner.visible = true;
				Tweener.addTween(banner, {alpha:1, time:1.5, delay:0.5, transition:Equations.easeOutQuart});
			}
			
		}
		
		/**
		 * Fades the banner with the given index number out.
		 */
		public function fadeOut(index:uint):void {
			
			if (index != -1) {
				var banner:Banner = _banners[index];
				Tweener.addTween(banner, {alpha:0, time:1,
					transition:Equations.easeOutQuart, onComplete:function() {banner.visible = false}});
			}
			
		}
		
		/**
		 * Sets the banners.
		 */
		public function set banners(banners:Array):void {
			
			this._banners = banners;
			addBanners();
			
		}	
	}
}
