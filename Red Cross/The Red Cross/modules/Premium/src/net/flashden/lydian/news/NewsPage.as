package net.flashden.lydian.news {
	
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import net.flashden.lydian.template.ConfigManager;
	import net.flashden.lydian.template.Preloader;
		
	public class NewsPage extends MovieClip {
		
		// Location of the data xml file
		private var dataXML:String;
		
		// A news menu
		private var _newsMenu:NewsMenu;

		// The name of the page
		private var _name:String;
		
		// A preloader to be displayed during loading process
		private var preloader:Preloader = new Preloader();
				
		public function NewsPage(name:String, xml:String) {
			
			this._name = name;
			this.dataXML = xml;
			init();
			
		}
		
		/**
		 * Initializes the page.
		 */
		private function init():void {
			
			// Add the preloader
			preloader.x = (ConfigManager.CONTENT_HOLDER_WIDTH / 2) - ConfigManager.CONTENT_HOLDER_LEFT_MARGIN;
			preloader.y = (ConfigManager.CONTENT_HOLDER_HEIGHT / 2) - ConfigManager.CONTENT_HOLDER_TOP_MARGIN;
			addChild(preloader);
			
			// Hide children
			_newsMenu = new NewsMenu(_name, dataXML);
			_newsMenu.x = 47;
			_newsMenu.y = 7;
			_newsMenu.addEventListener(NewsMenu.MENU_LOADED, onMenuLoaded, false, 0, true);
			_newsMenu.alpha = 0;
			addChild(_newsMenu);
						
			
		}
		
		/**
		 * Returns the news menu.
		 */
		public function get newsMenu():NewsMenu {
			
			return _newsMenu;
			
		}
		
		/**
		 * This method is called when the menu is loaded.
		 */
		public function onMenuLoaded(evt:Event):void {
			
			// Hide preloader
			Tweener.addTween(preloader, {alpha:0, time:1, onComplete:onPageLoaded});
			dispatchEvent(evt);
			
		}
		
		/**
		 * Removes preloader and fades the content in.
		 */
		public function onPageLoaded():void {
			
			// Remove preloader
			removeChild(preloader);
			Tweener.addTween(_newsMenu, {alpha:1, time:1});
			
		}
		
		/**
		 * Returns the news item with the given title.
		 */
		public function getNewsItem(title:String):NewsItem {
			
			var items:Array = _newsMenu.items;
			
			for (var i:int = 0; i < items.length; i++) {
				var newsItem:NewsItem = items[i] as NewsItem;
				
				if (newsItem.title.toLowerCase() == title) {
					return newsItem;
				}
			}
			
			return null;
			
		}
		
		/**
		 * Returns true if the menu items are loaded.
		 */
		public function get loaded():Boolean {
			
			return newsMenu.loaded;
			
		}
		
	}
	
}