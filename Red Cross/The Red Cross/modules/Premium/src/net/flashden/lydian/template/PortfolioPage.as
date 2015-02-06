package net.flashden.lydian.template {
	
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import net.flashden.lydian.horizontalmenu.HorizontalMenu;
	import net.flashden.lydian.horizontalmenu.MenuItem;
		
	public class PortfolioPage extends MovieClip {
		
		// Location of the data xml file
		private var dataXML:String;
		
		// A horizontal menu
		private var horizontalMenu:HorizontalMenu;
		
		// The name of the page
		private var _name:String;
		
		// A preloader to be displayed during loading process
		private var preloader:Preloader = new Preloader();
		
		public function PortfolioPage(name:String, xml:String) {
			
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
			
			// Create the menu
			horizontalMenu = new HorizontalMenu(_name, dataXML);
			horizontalMenu.x = 51;
			horizontalMenu.y = 83;
			horizontalMenu.alpha = 0;
			horizontalMenu.addEventListener(HorizontalMenu.MENU_LOADED, onMenuLoaded, false, 0, true);
			addChild(horizontalMenu);
			
		}
		
		/**
		 * Returns the menu item with the given title.
		 */
		public function getItem(title:String):MenuItem {
			
			var items:Array = horizontalMenu.items;
			
			for (var i:int = 0; i < items.length; i++) {
				var menuItem:MenuItem = items[i] as MenuItem;
				
				if (menuItem.title.toLowerCase() == title) {
					return menuItem;
				}
			}
			
			return null;
			
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
			Tweener.addTween(horizontalMenu, {alpha:1, time:1});
			
		}
		
		/**
		 * Returns true if the menu items are loaded.
		 */
		public function get loaded():Boolean {
			
			return horizontalMenu.loaded;
			
		}
		
	}
	
}