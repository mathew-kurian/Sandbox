package net.flashden.lydian.template {
	
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.events.Event;	
			
	public class StandartPage extends MovieClip {
		
		// Page content
		private var pageContent:StandartPageContent;
		
		// A preloader to be displayed during loading process
		private var preloader:Preloader = new Preloader();
		
		public function StandartPage(dataXML:String = null, title:String = null, subtitle:String = null, text:String = null,
									imageURL:String = null) {
			
			// Create a new page content
			pageContent = new StandartPageContent(dataXML, title, subtitle, text, imageURL);
			
			// Add the preloader if needed
			if (dataXML != null) {
				pageContent.addEventListener(XMLLoader.XML_LOADED, onDataXMLLoaded, false, 0, true);
				pageContent.alpha = 0;
				
				// Add preloader
				preloader.x = (ConfigManager.CONTENT_HOLDER_WIDTH / 2) - ConfigManager.CONTENT_HOLDER_LEFT_MARGIN;
				preloader.y = (ConfigManager.CONTENT_HOLDER_HEIGHT / 2) - ConfigManager.CONTENT_HOLDER_TOP_MARGIN;
				addChild(preloader);
			}
			
			// Add page content
			addChild(pageContent);
			
		}
		
		/**
		 * This method is called when the data.xml is loaded.		 
		 */
		public function onDataXMLLoaded(evt:Event):void {
			
			// Hide preloader
			Tweener.addTween(preloader, {alpha:0, time:1, onComplete:onPageLoaded});
			
		}
		
		/**
		 * Removes preloader and fades the content in.
		 */
		public function onPageLoaded():void {
			
			// Remove preloader
			removeChild(preloader);
			Tweener.addTween(pageContent, {alpha:1, time:1});
			
		}
		
	}

}