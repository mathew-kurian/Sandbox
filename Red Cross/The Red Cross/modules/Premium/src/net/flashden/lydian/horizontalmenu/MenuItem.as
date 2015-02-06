package net.flashden.lydian.horizontalmenu {
	
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.net.URLRequest;
	
	import net.flashden.lydian.template.ConfigManager;
	import net.flashden.lydian.template.Preloader;
		
	public class MenuItem extends MovieClip {
		
		// Location of the image
		private var _url:String;
		
		// Title of the menu item
		private var _title:String;
		
		// Subtitle of the menu item
		private var _subtitle:String;
		
		// Text content of the menu item
		private var _content:String;
		
		// The link to be launched when clicked on the item
		private var _link:String;
		
		// Holds the target browser window to open the given url
		private var _target:String;
		
		// The loader to be used for loading external images 
		private var loader:Loader = new Loader();
		
		// The image as a Bitmap object
	    private var image:Bitmap;
	    
	    // A preloader to be displayed during loading process
	    private var preloader:Preloader = new Preloader();
	
		public function MenuItem(url:String, title:String, subtitle:String, content:String = null, link:String = null, target = null) {
			
			this._url = url;
			this._title = title;
			this._subtitle = subtitle;
			this._content = content;
			this._link = link;
			this._target = target;

			// Initialize the menu item
			init();
			
		}
		
		/**
		 * Initializes the item.
		 */
		private function init():void {
			
			// Use as a button
			useHandCursor = true;
			buttonMode = true;
			mouseChildren = false;
						
			// Prepare screen components
			prepareMask();
			prepareBorder();
			prepareSelectionBox();
			prepareBackground();
			prepareTextPanel();
			
			// Set title and subtitle
			textPanel.title.text = _title;
			textPanel.subtitle.text = _subtitle;
			
			// Start loading
			load();
			
		}
		
		/**
		 * Prepares the mask.
		 */
		private function prepareMask():void {
			
			itemMask.width = ConfigManager.HORIZONTAL_MENU_ITEM_WIDTH;
			itemMask.height = ConfigManager.HORIZONTAL_MENU_ITEM_HEIGHT + textPanel.height;
			itemMask.y = itemMask.x = 0;
			
		}
		
		/**
		 * Prepares the item border.
		 */
		private function prepareBorder():void {
			
			border.y = border.x = -Math.ceil(ConfigManager.HORIZONTAL_MENU_ITEM_BORDER_SIZE);
			border.width = itemMask.width + ConfigManager.HORIZONTAL_MENU_ITEM_BORDER_SIZE * 2;
			border.height = itemMask.height + ConfigManager.HORIZONTAL_MENU_ITEM_BORDER_SIZE * 2;
			
			// Change the color
			var colorTransform:ColorTransform = border.transform.colorTransform;
			colorTransform.color = ConfigManager.HORIZONTAL_MENU_ITEM_BORDER_COLOR;
			border.transform.colorTransform = colorTransform;
			
		}
		
		/**
		 * Prepares the selection box.
		 */
		private function prepareSelectionBox():void {
			
			// Change the color and alpha value
			var colorTransform:ColorTransform = selectionBox.transform.colorTransform;
			colorTransform.color = ConfigManager.HIGHLIGHT_COLOR;
			selectionBox.transform.colorTransform = colorTransform;
			
			selectionBox.x = selectionBox.y = border.x - 1;
			selectionBox.width = border.width + 2;
			selectionBox.height = border.height + 2;
			
		}
		
		/**
		 * Prepares the background.
		 */
		private function prepareBackground():void {
			
			background.width = itemMask.width;
			background.height = itemMask.height;
			background.x = background.y = 0;
			
		}
		
		/**
		 * Prepares the text panel.
		 */
		private function prepareTextPanel():void {
			
			textPanel.alpha = 0;
			textPanel.background.width = textPanel.line.width = Math.ceil(itemMask.width);
			textPanel.x = Math.ceil(itemMask.x);
			textPanel.y = Math.ceil(ConfigManager.HORIZONTAL_MENU_ITEM_HEIGHT);
		}
		
		/**
		 * Starts loading the image.
		 */
		private function load():void {
			
			// Add preloader
			preloader.x = itemMask.x + itemMask.width / 2;
			preloader.y = itemMask.y + itemMask.height / 2;			
			addChild(preloader);
			
			// Create the url request and add event listeners
			var urlRequest:URLRequest = new URLRequest(_url);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
			
			// Start loading the image
			loader.load(urlRequest);
			
		} 

		/**
		 * This method is called when loading process is completed.
		 */
		private function onLoadComplete(evt:Event):void {
			
			// Create image bitmap
			var bitmapData:BitmapData = new BitmapData(loader.width, loader.height, true, 0x00000000);
			bitmapData.draw(loader);
			image = new Bitmap(bitmapData, PixelSnapping.NEVER, true);
			image.x = itemMask.x;
			image.y = itemMask.y;
			image.alpha = 0;
			addChild(image);
			setChildIndex(image, numChildren - 3);
			
			// Play animation
			Tweener.addTween(preloader, {alpha:0, time:1});
			Tweener.addTween(image, {alpha:1, time:1});
			Tweener.addTween(textPanel, {alpha:1, time:1});
			
		}
		
		/**
		 * Plays mouse over tweens.
		 */
		public function playMouseOverTweens():void {
			
			Tweener.addTween(border, {_color:ConfigManager.HIGHLIGHT_COLOR, time:1});
			Tweener.addTween(selectionBox, {alpha:1, time:1});
			Tweener.addTween(image, {alpha:.5, time:1});
			
		}
		
		/**
		 * Plays mouse out tweens.
		 */
		public function playMouseOutTweens():void {
			
			Tweener.addTween(border, {_color:ConfigManager.HORIZONTAL_MENU_ITEM_BORDER_COLOR, time:1});
			Tweener.addTween(selectionBox, {alpha:0, time:1});
			Tweener.addTween(image, {alpha:1, time:1});
			
		}
		
		/**
		 * Returns the title of the item.
		 */
		public function get title():String {
			
			return _title;
			
		}
		
		/**
		 * Returns the subtitle of the item.
		 */
		public function get subtitle():String {
			
			return _subtitle;
			
		}
		
		/**
		 * Returns the image url.		 
		 */
		public function get url():String {
			
			return _url;
			
		}
		
		/**
		 * Returns the item content.
		 */
		public function get content():String {
			
			return _content;
			
		}
		
		/**
		 * Returns the link associated with this item.
		 */
		public function get link():String {
			
			return _link;
			
		}
		
		/**
		 * Returns the target.
		 */
		public function get target():String {
			
			return _target;
			
		}
		
	}
	
}