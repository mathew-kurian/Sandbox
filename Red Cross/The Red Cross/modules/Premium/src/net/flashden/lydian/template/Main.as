package net.flashden.lydian.template {
	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import net.flashden.lydian.horizontalmenu.HorizontalMenu;
	import net.flashden.lydian.horizontalmenu.MenuItem;
	import net.flashden.lydian.news.NewsItem;
	import net.flashden.lydian.news.NewsMenu;
	import net.flashden.lydian.news.NewsPage;
	import net.flashden.lydian.photogallery.GalleryManager;
	import net.flashden.lydian.photogallery.PhotoGallery;
	import net.flashden.lydian.photogallery.PhotoStage;
		
	public class Main extends MovieClip {
		
		// A bar which is placed at the top
		private var topBar:TopBar;
		
		// A bar which is placed at the bottom
		private var bottomBar:BottomBar;
		
		// This is where all the content will be hold
		private var contentHolder:ContentHolder;
		
		// Main menu
		private var mainMenu:MainMenu;
		
		// A reference to the photo stage
		private var _photoStage:PhotoStage;
		
		// An array to hold main menu items
		private var _menuItems:Array;
		
		// An XMLLoader instance to load the main xml file to the memory
		private var mainXMLLoader:XMLLoader;
		
		// Background file
		private var background:Loader;
		
		// A preloader to be displayed during loading process
		private var preloader:MainPreloader = new MainPreloader();
	
		public function Main() {
			
			// Initialize the template
			init();
			
		}
		
		/**
		 * Initializes the template.
		 */
		private function init():void {
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			
		}
		
		/**
		 * This method is called when the main movie clip is added to the stage.
		 */
		private function addedToStage(evt:Event):void {
			
			// Set stage scale mode and align the stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// Add stage resize listener
			stage.addEventListener(Event.RESIZE, onStageResize);
			ColorShortcuts.init();
			
			// Load the configuration file
			loadConfiguration();					

			// Add an event listener for listening address changes
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onAddressChange, false, 0, true);
						
		}
		
		/**
		 * This method is called when the main xml is loaded to the memory.
		 */
		private function onMainXMLLoaded(evt:Event):void {
			
			// Get the xml data
			var data:XML = mainXMLLoader.getXML();
			_menuItems = new Array();
			
			// Create the menu items
			for each (var item:XML in data.content) {
				var name:String = item.@name;
				var type:String = item.@type;
				var xml:String = item.@xml;
				var link:String = item.@link;
				var showInMainMenu:Boolean = (item.@showInMainMenu.toLowerCase() == "true");
				var target:String = item.@target;
				var menuItem:MainMenuItem = new MainMenuItem(name, type, xml, link, showInMainMenu, target);
				_menuItems.push(menuItem);
			}
			
			// Create the main menu
			mainMenu = new MainMenu(_menuItems);
			mainMenu.addEventListener(MouseEvent.MOUSE_DOWN, onMainMenu, false, 0, true);
			
			// Add screen components
			topBar = new TopBar();
			bottomBar = new BottomBar();
			contentHolder = new ContentHolder();
			addChild(topBar);
			addChild(bottomBar);
			addChild(contentHolder);
			addChild(mainMenu);
			mainMenu.selectMenuItemByIndex(0);
			mainMenu.openMenu();
			_photoStage = PhotoStage.getInstance();
			update();
			navigateToAddress();
			
		}

		/**
		* This method is called whenever an address change occurs.
		*/
		private function onAddressChange(evt:SWFAddressEvent):void {					
			
			navigateToAddress();
			
		}
		
		/**
		 * Navigates to the address on the browser.
		 */
		private function navigateToAddress():void {
			
			// Return if menu items are not yet loaded
			if (_menuItems == null) {
				return;
			}
			
			// Get the address
			var address:String = SWFAddress.getValue();
			var menuItem:MainMenuItem = findMenuItem(address);			
			var lastSlashIndex:int = address.lastIndexOf("/");
			
			if (lastSlashIndex > 0) {
				var secondPart:String = address.substr(lastSlashIndex + 1).replace(/_/g, " ");
			} else {
				secondPart = "";
			}
			
			// Find the type of the menu item
			if (menuItem != null) {
				
				// Close photo stage if it's open and not needed anymore
				if (menuItem.type != "PhotoGallery" || (menuItem.type == "PhotoGallery" && secondPart == "")) {
					if (_photoStage.enabled) {
						_photoStage.close();
					}
				}
				
				// Handle the second level of the address
				if (lastSlashIndex > 0) {
					switch (menuItem.type) {
						case "NewsPage":
						
						var newsPage:NewsPage = menuItem.content as NewsPage;
						
						if (!newsPage.loaded) {
							newsPage.addEventListener(NewsMenu.MENU_LOADED, onNewsMenuLoaded, false, 0, true);
						} else {
							setNewsPage(newsPage);
						}

						break;
						case "PortfolioPage":
						
						var portfolioPage:PortfolioPage = menuItem.content as PortfolioPage;
						
						if (!portfolioPage.loaded) {
							portfolioPage.addEventListener(HorizontalMenu.MENU_LOADED, onHorizontalMenuLoaded, false, 0, true);
						} else {
							setPortfolioPage(portfolioPage);
						}						
						
						break;
						case "PhotoGallery":

						var photoGallery:PhotoGallery = menuItem.content as PhotoGallery;
						
						if (!photoGallery.loaded) {
							photoGallery.addEventListener(GalleryManager.DATA_READY, onGalleryReady, false, 0, true);
						} else {
							setPhoto(photoGallery);
						}
						
						break;
						
					}
				} else {
					contentHolder.content = menuItem.content;
				}
				
				// Select the menu item if it's set to be displayed at the main menu
				if (menuItem.showInMainMenu) {
					mainMenu.selectMenuItem(menuItem);
				} else {
					mainMenu.selectMenuItem(_menuItems[0]);
				}
			} else {
				// Select the first menu item in the array if our menu item is null
				contentHolder.content = _menuItems[0].content;
				mainMenu.selectMenuItem(_menuItems[0]);
			}			

		}
		
		/**
		 * Returns the second level of the given address.
		 */
		private function getSecondPart(address:String):String {
			
			var lastSlashIndex:int = address.lastIndexOf("/");
			return address.substr(lastSlashIndex + 1).replace(/_/g, " ");
			
		}
		
		/**
		 * This method is called when the portfolio page is ready.
		 */
		private function onHorizontalMenuLoaded(evt:Event):void {
			
			setPortfolioPage(PortfolioPage(evt.target));
			
		}

		/**
		 * This method is called when the news page is ready.
		 */
		private function onNewsMenuLoaded(evt:Event):void {
			
			setNewsPage(NewsPage(evt.target));
			
		}
		
		/**
		 * This method is called when the photo gallery is ready.
		 */
		private function onGalleryReady(evt:Event):void {
			
			var photoGallery:PhotoGallery = evt.target as PhotoGallery;
			contentHolder.content = photoGallery;
			setPhoto(photoGallery);
			
		}
		
		/**
		 * Sets the photo on the given photo gallery.
		 */
		private function setPhoto(photoGallery:PhotoGallery):void {

			var secondPart:String = getSecondPart(SWFAddress.getValue());
			addChild(_photoStage);
			photoGallery.selectThumbnail(secondPart);
			update();
			
		}
		
		/**
		 * Selects the item related with the given portfolio page.
		 */
		private function setPortfolioPage(portfolioPage:PortfolioPage):void {
			
			var secondPart:String = getSecondPart(SWFAddress.getValue());
			var menuItem:MenuItem = portfolioPage.getItem(secondPart);
			var page:StandartPage = new StandartPage(null, menuItem.title, menuItem.subtitle, menuItem.content, menuItem.url);
			contentHolder.content = page;
			
		}

		/**
		 * Selects the item related with the given news page.
		 */
		private function setNewsPage(newsPage:NewsPage):void {
			
			var secondPart:String = getSecondPart(SWFAddress.getValue());
			var newsItem:NewsItem = newsPage.getNewsItem(secondPart);
			var page:StandartPage = new StandartPage(null, newsItem.title, newsItem.date, newsItem.content, newsItem.imageURL);
			contentHolder.content = page;
			
		}
		
		/**
		 * This method is called when the mouse is clicked on one of the menu items.
		 */
		private function onMainMenu(evt:MouseEvent):void {
			
			var mainMenuItem:MainMenuItem = evt.target as MainMenuItem;	
			
			// Handle navigation
			if (mainMenuItem.type.toLowerCase() != "link") {
				SWFAddress.setValue(mainMenuItem.name);
			} else {
				try {
					navigateToURL(new URLRequest(mainMenuItem.link), mainMenuItem.target);
				} catch (e:Error) {
				}
			}
			
		}
		
		/**
		 * Returns the menu item with the given name.
		 */
		private function findMenuItem(address:String):MainMenuItem {
			
			// Return the first menu item if the address contains just a slash
			if (address == "/") {
				return _menuItems[0];
			}
			
			var lastSlashIndex = address.lastIndexOf("/");
			
			if (lastSlashIndex == 0) {
				var name:String = address.substr(1);
			} else {
				name = address.substr(1, lastSlashIndex - 1);
			}
			
			for (var i:int = 0; i < _menuItems.length; i++) {
				var menuItem:MainMenuItem = _menuItems[i] as MainMenuItem;
				
				if (menuItem.name == name) {
					return menuItem;
				}				
			}
			
			return null;
					
		}
		
		/**
		 * Updates the preloader.
		 */
		private function onProgress(evt:ProgressEvent):void {
			
			preloader.percent = Math.round((evt.bytesLoaded / evt.bytesTotal) * 100);
						
		}
		
		/**
		 * Hides the preloader.
		 */
		private function onBackgroundLoaded(evt:Event):void {
			
			Tweener.addTween(preloader, {alpha:0, time:1, onComplete:startTemplate});
			
		}
		
		/**
		 * Starts the template by reading the main xml file.
		 */
		private function startTemplate():void {
			
			removeChild(preloader);
			addChild(background);
			setChildIndex(background, 0);
			
			// Start reading the data.			
			mainXMLLoader = new XMLLoader(ConfigManager.MAIN_XML_URL);
			mainXMLLoader.addEventListener(XMLLoader.XML_LOADED, onMainXMLLoaded);
			mainXMLLoader.load();
			
		}
		
		/**
		 * Loads the configuration file.
		 */
		private function loadConfiguration():void {
			
			var cm:ConfigManager = ConfigManager.getInstance();
			cm.addEventListener(ConfigManager.CONFIG_LOADED, loadBackground, false, 0, false);
			cm.load();
			
		}
		
		/**
		 * Loads the background swf.
		 */
		private function loadBackground(evt:Event):void {
			
			// Add preloader
			preloader.x = stage.stageWidth / 2;
			preloader.y = stage.stageHeight / 2;
			preloader.alpha = 0;
			addChild(preloader);
			Tweener.addTween(preloader, {alpha:1, time:1});
			
			// Read the background swf
			var request:URLRequest = new URLRequest(ConfigManager.BACKGROUND_URL);
			background = new Loader();
			background.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
			background.contentLoaderInfo.addEventListener(Event.COMPLETE, onBackgroundLoaded, false, 0, true);
			background.load(request);
			
		}
		
		/**
		 * This method is called whenever the stage size is changed.
		 */
		private function onStageResize(e:Event):void {
						
			// Update everything on the stage
			update();
			
		}
		
		/**
		 * Updates everything on the stage.
		 */
		private function update():void {
						
			// Update the top bar
			topBar.x = Math.ceil(ConfigManager.LEFT_MARGIN);
			topBar.y = Math.ceil(ConfigManager.TOP_MARGIN);
			
			// Update the bottom bar
			bottomBar.x = Math.ceil(ConfigManager.LEFT_MARGIN);
			bottomBar.y = Math.ceil(stage.stageHeight - ConfigManager.BOTTOM_MARGIN);
			bottomBar.update(stage.stageWidth - ConfigManager.LEFT_MARGIN - ConfigManager.RIGHT_MARGIN);
			
			if (mainMenu != null) {
				// Update the content holder
				contentHolder.x = Math.ceil((stage.stageWidth - contentHolder.width + mainMenu.width + ConfigManager.MM_SPACING) / 2);
				contentHolder.y = Math.ceil((stage.stageHeight - contentHolder.height) / 2);
				
				// Update the main menu
				mainMenu.x = Math.ceil(contentHolder.x - mainMenu.width - ConfigManager.MM_SPACING);
				mainMenu.y = Math.ceil(contentHolder.y + (contentHolder.height - mainMenu.height) / 2);
			}
			
			// Update the photo stage
			if (_photoStage != null) {			
				_photoStage.update(stage.stageWidth, stage.stageHeight);
			}
			
			// Update the location of the preloader
			if (preloader != null) {
				preloader.x = Math.ceil(stage.stageWidth / 2);
				preloader.y = Math.ceil(stage.stageHeight / 2);
			}
			
		}
		
	}
	
}