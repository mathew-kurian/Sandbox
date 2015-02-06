package net.flashden.lydian.news {
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import com.asual.swfaddress.SWFAddress;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.flashden.lydian.template.ConfigManager;
	import net.flashden.lydian.template.GenericRect;
	import net.flashden.lydian.template.LeftButton;
	import net.flashden.lydian.template.RightButton;
	import net.flashden.lydian.template.XMLLoader;	
	
	public class NewsMenu extends MovieClip {
		
		// The name of the event to be fired when loading is completed
		public static const MENU_LOADED:String = "menuLoaded";
		
		// Location of the data xml file
		private var dataXML:String;
		
		// An XMLLoader instance to load the data xml file to the memory
		private var dataXMLLoader:XMLLoader;

		// A container sprite to hold menu items
		private var container:Sprite = new Sprite();
		
		// The menu mask
		private var menuMask:GenericRect = new GenericRect();
		
		// An array of menu items
		private var _items:Array = new Array();
		
		// Current page index
		private var pageIndex:int = 0;
		
		// Number of total pages
		private var pageCount:uint;
		
		// Left navigation button
		private var leftButton:LeftButton = new LeftButton();
		
		// Right navigation button
		private var rightButton:RightButton = new RightButton();
		
		// The name of the menu
		private var _name:String;
		
		// Indicates whether the item is loaded or not
		private var _loaded:Boolean = false;
		
		public function NewsMenu(name:String, dataXML:String) {
			
			this.dataXML = dataXML;
			this._name = name;
			
			// Initialize the menu
			init();				
			
		}			
		
		/**
		 * Initializes the menu.
		 */
		private function init():void {
			
			// Prepare components
			prepareMask();
			prepareContainer();
			prepareButtons();
			
			// Start reading the data.			
			dataXMLLoader = new XMLLoader(dataXML);
			dataXMLLoader.addEventListener(XMLLoader.XML_LOADED, onDataXMLLoaded);
			dataXMLLoader.load();
			
			// Add necessary event listeners
			leftButton.addEventListener(MouseEvent.MOUSE_DOWN, onLeftButton, false, 0, true);
			rightButton.addEventListener(MouseEvent.MOUSE_DOWN, onRightButton, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
						
		}
		
		/**
		 * Prepares the mask.
		 */
		private function prepareMask():void {
			
			var itemWidth:Number = ConfigManager.NEWS_MENU_ITEM_WIDTH;
			var itemHeight:Number = ConfigManager.NEWS_MENU_ITEM_HEIGHT;
			var spacing:Number = ConfigManager.NEWS_MENU_SPACING;
			var pageLimit:Number = ConfigManager.NEWS_MENU_PAGE_LIMIT;
			
			menuMask.width = itemWidth;
			menuMask.height = pageLimit * itemHeight + (pageLimit - 1) * spacing;			
			container.mask = menuMask;
			addChild(menuMask);			
			
		}
		
		/**
		 * Prepares and adds the container.
		 */
		private function prepareContainer():void {
			
			// Prepare container
			addChild(container);
			
		}
		
		/**
		 * Prepares the buttons.
		 */
		private function prepareButtons():void {
			
			leftButton.x = menuMask.x - 50;
			leftButton.y = menuMask.y + menuMask.height / 2;
			rightButton.x = menuMask.x + menuMask.width + 50;
			rightButton.y = leftButton.y;
			addChild(leftButton);
			addChild(rightButton);
			
		}
		
		/**
		 * This method is called when the mouse is over the item.
		 */
		private function onMouseOver(evt:MouseEvent):void {
			
			var newsItem:NewsItem = evt.target as NewsItem;
			
			if (newsItem != null) {
				newsItem.playMouseOverTweens();
			}
			
		}
		
		/**
		 * This method is called when the mouse leaves the item.
		 */
		private function onMouseOut(evt:MouseEvent):void {
			
			var newsItem:NewsItem = evt.target as NewsItem;
			
			if (newsItem != null) {
				newsItem.playMouseOutTweens();
			}
			
		}
		
		/**
		 * This method is called when the left navigation button is clicked.
		 */
		private function onLeftButton(evt:MouseEvent):void {
			
			if (pageIndex != 0) {
				leftButtonClicked();
				checkButtons();
			}
			
		}
		
		/**
		 * This method is called when the right navigation button is clicked.
		 */
		private function onRightButton(evt:MouseEvent):void {
			
			if (pageIndex != pageCount - 1) {
				rightButtonClicked();
				checkButtons();
			}
			
		}
		
		/**
		 * This method is called when the item is clicked.
		 */
		private function onMouseDown(evt:MouseEvent):void {
			
			var newsItem:NewsItem = evt.target as NewsItem;
			
			if (newsItem != null) {
				SWFAddress.setValue(_name.replace(/ /g, "_").toLowerCase() + "/" + newsItem.title.replace(/ /g, "_").toLowerCase());
			}
			
		}
		
		/**
		 * This method is called when the data.xml is loaded.		 
		 */
		private function onDataXMLLoaded(evt:Event):void {
			
			var pageLimit:uint = ConfigManager.NEWS_MENU_PAGE_LIMIT;
			var spacing:Number = ConfigManager.NEWS_MENU_SPACING;
			
			// Get the xml data
			var xml:XML = dataXMLLoader.getXML();			
			
			// Create news items
			var index:int = 0;
			
			for each (var item:XML in xml.item) {
				var image:String = item.@image;
				var date:String = item.@date;
				var title:String = item.title;
				var summary:String = item.summary;
				var content:String = item.content;
				
				var newsItem:NewsItem = new NewsItem(image, date, title, summary, content);				
				newsItem.x = Math.floor(index / pageLimit) * (newsItem.width + spacing);				
				newsItem.y = (index % pageLimit) * (newsItem.height + spacing);				
				container.addChild(newsItem);
				_items.push(newsItem);
				++index;
			}
			
			pageCount = Math.ceil(index / pageLimit);
			_loaded = true;
			checkButtons();
			dispatchEvent(new Event(MENU_LOADED));

		}
		
		/**
		 * Calculates new page index and updates the status of the buttons.
		 */
		private function leftButtonClicked():void {
			
			// Slide to given page index
			slideTo(--pageIndex);
			
		}
		
		/**
		 * Calculates new page index and updates the status of the buttons.
		 */
		private function rightButtonClicked():void {
				
			// Slide to given page index
			slideTo(++pageIndex);
			
		}
		
		/**
		 * Slides container to the given index.
		 */
		private function slideTo(index:int) {
			
			var itemWidth:Number = ConfigManager.NEWS_MENU_ITEM_WIDTH;			
			var spacing:Number = ConfigManager.NEWS_MENU_SPACING;			
			
			// Calculate and slide to target
			var target:Number = menuMask.x - index * (itemWidth + spacing);
			Tweener.addTween(container, {x:target, time:0.95, transition:Equations.easeOutQuint});
			
		}
		
		/**
		 * Checks the status of the previous and next buttons. Updates
		 * states by calling appropriate methods.
		 */
		private function checkButtons():void {
			
			if (pageIndex < pageCount - 1) {
				rightButton.mouseEnabled = true;
				rightButton.alpha = 1;
			} else {
				rightButton.mouseEnabled = false;
				rightButton.alpha = 0.2;
			}
			
			if (pageIndex == 0) {
				leftButton.mouseEnabled = false;
				leftButton.alpha = 0.2;
			} else {
				leftButton.mouseEnabled = true;
				leftButton.alpha = 1;
			}

		}
		
		/**
		 * Returns menu items.
		 */
		public function get items():Array {
			
			return _items;
			
		}
		
		/**
		 * Returns true if the menu items are loaded.
		 */
		public function get loaded():Boolean {
			
			return _loaded;
			
		}
		
	}
	
}