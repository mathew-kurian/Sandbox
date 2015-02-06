package net.flashden.lydian.news {
	
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import net.flashden.lydian.template.ConfigManager;
	import net.flashden.lydian.template.Preloader;
	
	public class NewsItem extends MovieClip {
		
		// Location of the image
		private var _imageURL:String;
		
		// Date added
		private var _date:String;
		
		// Item title
		private var _title:String;
		
		// Summary
		private var _summary:String;
		
		// Item content
		private var _content:String;
		
		// The loader to be used for loading external images 
		private var loader:Loader = new Loader();
		
		// The image as a Bitmap object
		private var _image:Bitmap;
		
		 // A preloader to be displayed during loading process
		private var preloader:Preloader = new Preloader();
		
		public function NewsItem(imageURL:String, date:String, title:String, summary:String, content:String) {
			
			this._imageURL = imageURL;
			this._date = date;
			this._title = title;
			this._summary = summary;
			this._content = content;
			
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
			
			titleField.text = _title;
			summaryField.htmlText = _summary;
			dateField.text = _date;
			
			// Start loading
			load();
			
		}
		
		/**
		 * Starts loading the image.
		 */
		private function load():void {
			
			// Add preloader
			preloader.scaleX = preloader.scaleY = 0.5;
			preloader.x = imageMask.x + imageMask.width / 2;
			preloader.y = imageMask.y + imageMask.height / 2;			
			addChild(preloader);
			
			// Create the url request and add event listeners
			var urlRequest:URLRequest = new URLRequest(_imageURL);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
			
			// Start loading the image
			loader.load(urlRequest);
			
		}
		
		/**
		 * This method is called when loading process is completed.
		 */
		private function onLoadComplete(evt:Event):void {
			
			var bitmapData:BitmapData = new BitmapData(loader.width, loader.height, true, 0x00000000);
			bitmapData.draw(loader);
			_image = new Bitmap(bitmapData, PixelSnapping.NEVER, true);
			_image.scaleX = _image.scaleY = 0.6;
			_image.x = imageMask.x + (imageMask.width - _image.width) / 2;
			_image.y = imageMask.y + (imageMask.height - _image.height) / 2;
			_image.mask = imageMask;
			_image.alpha = 0;
			addChild(_image);
			Tweener.addTween(preloader, {alpha:0, time:1});
			Tweener.addTween(_image, {alpha:1, time:1});			
			
		}
		
		/**
		 * Plays mouse over tweens.
		 */
		public function playMouseOverTweens():void {
			
			Tweener.addTween(titleField, {_color:ConfigManager.HIGHLIGHT_COLOR, time:1});
						
		}
		
		/**
		 * Plays mouse out tweens.
		 */
		public function playMouseOutTweens():void {
			
			Tweener.addTween(titleField, {_color:null, time:1});			
			
		}
		
		/**
		 * Returns the actual width of the item.
		 */
		public override function get width():Number {
			
			return background.width;			
			
		}
		
		/**
		 * Returns the actual height of the item.
		 */
		public override function get height():Number {
			
			return background.height;
			
		}
		
		/**
		 * Returns the title of the item.
		 */
		public function get title():String {
			
			return _title;
			
		}
		
		/**
		 * Returns the date added.
		 */
		public function get date():String {
			
			return _date;
			
		}
		
		/**
		 * Returns the summary.
		 */
		public function get summary():String {
			
			return _summary;
			
		}
		
		/**
		 * Returns the content.
		 */
		public function get content():String {
			
			return _content;
			
		}
		
		/**
		 * Returns the image url.
		 */
		public function get imageURL():String {
			
			return _imageURL;
			
		}

	}
	
}