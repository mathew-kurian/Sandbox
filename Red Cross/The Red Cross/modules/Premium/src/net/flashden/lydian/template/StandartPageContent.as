package net.flashden.lydian.template {
	
	import caurina.transitions.Tweener;
	
	import com.asual.swfaddress.SWFAddress;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;	
			
	public class StandartPageContent extends MovieClip {
		
		// Location of the data xml file
		private var dataXML:String;
		
		// An XMLLoader instance to load the data xml file to the memory
		private var dataXMLLoader:XMLLoader;
		
		// The loader to be used for loading external images 
		private var loader:Loader = new Loader();
		
		// The image as a Bitmap object
	    private var _image:Bitmap;
	    
	    // Title of the page
	    private var _title:String;
	    
	    // Subtitle of the page
	    private var _subtitle:String;
		
		// Body text	    
	    private var _text:String;
	    
	    // Location of the image
	    private var _imageURL:String;
	    
	    // Indicates whether the page is initialized or not
	    private var _initialized:Boolean = false;
	    
	    // A preloader to be displayed during loading process
	    private var preloader:Preloader = new Preloader();
	
		public function StandartPageContent(dataXML:String = null, title:String = null,
						subtitle:String = null, text:String = null, imageURL:String = null) {
										
			this.dataXML = dataXML;
			this._title = title;
			this._subtitle = subtitle;
			this._text = text;
			this._imageURL = imageURL;			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			
		}			
		
		/**
		 * Initializes the page content.
		 */
		public function init():void {
			
			// Clear text fields
			titleField.text = "";
			subtitleField.text = "";
						
			// Prepare scroll bar
			textFieldHolder.textField.text = "";
			textFieldHolder.textField.mouseEnabled = false;
			textFieldHolder.textField.autoSize = TextFieldAutoSize.LEFT;
			titleField.autoSize = TextFieldAutoSize.LEFT;
			textFieldHolder.cacheAsBitmap = true;
			
			// Initialize scroll bar
			scrollBar.content = textFieldHolder;
			scrollBar.contentMask = textFieldMask;
			scrollBar.init();

			// Prepare close button
			closeButton.useHandCursor = true;
			closeButton.buttonMode = true;
			closeButton.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			closeButton.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			closeButton.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownCloseButton, false, 0, true);			
			
			// Start reading the data.
			if (dataXML != null) {
				dataXMLLoader = new XMLLoader(dataXML);
				dataXMLLoader.addEventListener(XMLLoader.XML_LOADED, onDataXMLLoaded);
				dataXMLLoader.load();
			} else {
				setData();
			}
			
		}
		
		/**
		 * This method is called when the data.xml is loaded.		 
		 */
		private function onDataXMLLoaded(evt:Event):void {
			
			// Get the xml data
			var xml:XML = dataXMLLoader.getXML();
			_title = xml.title;
			_subtitle = xml.subtitle;
			_imageURL = xml.image;
			_text = xml.text;
			setData();
			dispatchEvent(evt);
						
		}
		
		/**
		 * Sets data.
		 */
		private function setData():void {
			
			titleField.text = _title;
			subtitleField.text = _subtitle;
			textFieldHolder.textField.htmlText = _text;
			scrollBar.update();
			loadImage();
			var textFormat:TextFormat = new TextFormat();
			textFormat.leading = 5;
			textFieldHolder.textField.setTextFormat(textFormat);

		}
		
		/**
		 * This method is called when the item is added to the stage.
		 */
		private function addedToStage(evt:Event):void {
			
			if (!_initialized) {
				init();
				_initialized = true;
			}
			
		}
		
		/**
		 * This method is called when the mouse is over the close button.
		 */
		private function onMouseOver(evt:MouseEvent):void {
		
			Tweener.addTween(closeButton, {_color:ConfigManager.HIGHLIGHT_COLOR, time:1});
			Tweener.addTween(closeButton, {rotation:90, time:1});
			
		}
		
		/**
		 * This method is called when the mouse leaves the close button.
		 */
		private function onMouseOut(evt:MouseEvent):void {
			
			Tweener.addTween(closeButton, {_color:null, time:1});
			Tweener.addTween(closeButton, {rotation:0, time:1});
			
		}
		
		/**
		 * Navigates to the previous page in the browser history.
		 */
		private function onMouseDownCloseButton(evt:MouseEvent):void {
			
			SWFAddress.back();
			
		}
		
		/**
		 * Starts loading the image.
		 */
		private function loadImage():void {
			
			// Display preloader
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
		 * This method is called when the loading process is complete.
		 */
		private function onLoadComplete(evt:Event):void {
			
			var bitmapData:BitmapData = new BitmapData(loader.width, loader.height, true, 0x00000000);
			bitmapData.draw(loader);
			_image = new Bitmap(bitmapData, PixelSnapping.NEVER, true);			
			_image.x = imageMask.x + (imageMask.width - _image.width) / 2;
			_image.y = imageMask.y + (imageMask.height - _image.height) / 2;			
			_image.mask = imageMask;
			_image.alpha = 0;
			addChild(_image);
			Tweener.addTween(preloader, {alpha:0, time:1});
			Tweener.addTween(_image, {alpha:1, time:1});			
			
		}
		
	}
	
}