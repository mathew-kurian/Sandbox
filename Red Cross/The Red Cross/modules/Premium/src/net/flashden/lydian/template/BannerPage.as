package net.flashden.lydian.template {
	
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextFormat;
	
	import net.flashden.lydian.bannerrotator.Banner;
		
	public class BannerPage extends MovieClip {
		
		// Location of the data xml file
		private var dataXML:String;
		
		// An XMLLoader instance to load the data xml file to the memory
		private var dataXMLLoader:XMLLoader;
		
		// A preloader to be displayed during loading process
		private var preloader:Preloader = new Preloader();
	
		public function BannerPage(dataXML:String) {
			
			this.dataXML = dataXML;
			
			// Initialize the banner page
			init();
			
		}
		
		/**
		 * Initializes the page.
		 */
		private function init():void {
			
			// Hide children
			title.alpha = 0;
			bodyText.alpha = 0;
			bannerRotator.alpha = 0;
			
			// Add preloader
			preloader.x = (ConfigManager.CONTENT_HOLDER_WIDTH / 2) - ConfigManager.CONTENT_HOLDER_LEFT_MARGIN;
			preloader.y = (ConfigManager.CONTENT_HOLDER_HEIGHT / 2) - ConfigManager.CONTENT_HOLDER_TOP_MARGIN;
			addChild(preloader);
			
			// Clear textfields
			title.text = "";
			bodyText.text = "";
						
			// Start reading the data.			
			dataXMLLoader = new XMLLoader(dataXML);
			dataXMLLoader.addEventListener(XMLLoader.XML_LOADED, onDataXMLLoaded);
			dataXMLLoader.load();
			
		}
		
		/**
		 * This method is called when data.xml is loaded.		 
		 */
		private function onDataXMLLoaded(evt:Event):void {
			
			// Hide preloader
			Tweener.addTween(preloader, {alpha:0, time:1, onComplete:onPageLoaded});
			
			// Get the xml data
			var xml:XML = dataXMLLoader.getXML();
			title.text = xml.title;
			bodyText.htmlText = xml.text;			
			bodyText.mouseEnabled = false;
			var textFormat:TextFormat = new TextFormat();
			textFormat.leading = 5;
			bodyText.setTextFormat(textFormat);
			
			var banners:Array = new Array();
			
			for each (var item:XML in xml.banners.banner) {
				var imageURL:String = item.@image;
				var link:String = item.@link;
				var target:String = item.@target;
				var banner:Banner = new Banner(imageURL, link, target);				
				banners.push(banner);
			}
			
			bannerRotator.banners = banners;

		}
		
		/**
		 * Removes preloader and fades the content in.
		 */
		private function onPageLoaded():void {
			
			// Remove preloader
			removeChild(preloader);
			Tweener.addTween(title, {alpha:1, time:1});
			Tweener.addTween(bodyText, {alpha:1, time:1});
			Tweener.addTween(bannerRotator, {alpha:1, time:1});
			
		}
	
	}
	
}