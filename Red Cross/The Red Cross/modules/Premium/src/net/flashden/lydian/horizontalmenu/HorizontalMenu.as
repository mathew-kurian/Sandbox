package net.flashden.lydian.horizontalmenu {
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import com.asual.swfaddress.SWFAddress;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import net.flashden.lydian.template.ConfigManager;
	import net.flashden.lydian.template.GenericRect;
	import net.flashden.lydian.template.LeftButton;
	import net.flashden.lydian.template.RightButton;
	import net.flashden.lydian.template.XMLLoader;
		
	public class HorizontalMenu extends MovieClip {
		
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
		
		// Left navigation button
		private var leftButton:LeftButton = new LeftButton();
		
		// Right navigation button
		private var rightButton:RightButton = new RightButton();
		
		// The name of the menu
		private var _name:String;
		
		// Indicates whether the item is loaded or not
		private var _loaded:Boolean = false;
	
		public function HorizontalMenu(name:String, dataXML:String) {
			
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
		 * This method is called when the mouse is over the item.
		 */
		private function onMouseOver(evt:MouseEvent):void {
			
			var menuItem:MenuItem = evt.target as MenuItem;
			
			if (menuItem != null) {
				menuItem.playMouseOverTweens();
			}
			
		}
		
		/**
		 * This method is called when the mouse leaves the item.
		 */
		private function onMouseOut(evt:MouseEvent):void {
			
			var menuItem:MenuItem = evt.target as MenuItem;
			
			if (menuItem != null) {
				menuItem.playMouseOutTweens();
			}
			
		}
		
		/**
		 * This method is called when the mouse clicked on the item.
		 */
		private function onMouseDown(evt:MouseEvent):void {
			
			var menuItem:MenuItem = evt.target as MenuItem;
			
			// Check the type of the link and take appropriate action
			if (menuItem != null) {
				if (menuItem.link == "") {
					SWFAddress.setValue(_name.replace(/ /g, "_").toLowerCase() + "/" + menuItem.title.replace(/ /g, "_").toLowerCase());	
				} else {
					try {
						navigateToURL(new URLRequest(menuItem.link), menuItem.target);
					} catch (e:Error) {
						trace("The page cannot be load:" + menuItem.link);
					}
				}
			}
			
		}
		
		/**
		 * This method is called when the data.xml is loaded.		 
		 */
		private function onDataXMLLoaded(evt:Event):void {
			
			// Get the xml data
			var xml:XML = dataXMLLoader.getXML();
			
			// Create menu items
			var index:int = 0;
			
			for each (var item:XML in xml.item) {
				var url:String = item.@url;
				var title:String = item.title;
				var subtitle:String = item.subtitle;
				var content:String = item.content;
				var link:String = item.link;
				var target:String = item.link.@target;
				var menuItem:MenuItem = new MenuItem(url, title, subtitle, content, link, target);
				menuItem.x = index * (ConfigManager.HORIZONTAL_MENU_SPACING + 
									ConfigManager.HORIZONTAL_MENU_ITEM_BORDER_SIZE * 2 +
									ConfigManager.HORIZONTAL_MENU_ITEM_WIDTH);
				container.addChild(menuItem);
				_items.push(menuItem);
				++index;
			}
			
			_loaded = true;
			Tweener.addTween(leftButton, {alpha:0.2, time:1});
			Tweener.addTween(rightButton, {alpha:1, time:1});
			checkButtons();
			dispatchEvent(new Event(MENU_LOADED));
			
		}
		
		/**
		 * Prepares mask.
		 */
		private function prepareMask():void {
			
			var itemWidth:Number = ConfigManager.HORIZONTAL_MENU_ITEM_WIDTH; 
			var spacing:Number = ConfigManager.HORIZONTAL_MENU_SPACING;
			var pageLimit:Number = ConfigManager.HORIZONTAL_MENU_PAGE_LIMIT;
			var borderSize:Number = ConfigManager.HORIZONTAL_MENU_ITEM_BORDER_SIZE;

			menuMask.width = pageLimit * (itemWidth + borderSize * 2) + (pageLimit - 1) * spacing + 4;
			menuMask.height = ConfigManager.HORIZONTAL_MENU_HEIGHT;
			menuMask.y = menuMask.x = -borderSize - 2; 
			container.mask = menuMask;
			addChild(menuMask);
			
		}
		
		/**
		 * Prepares and adds the container.
		 */
		private function prepareContainer():void {
			
			addChild(container);
			
		}
		
		/**
		 * Prepares navigation buttons.		 
		 */
		private function prepareButtons():void {
			
			leftButton.x = menuMask.x - 50;
			leftButton.y = menuMask.y + menuMask.height / 2;
			rightButton.x = menuMask.x + menuMask.width + 50;
			rightButton.y = leftButton.y;
			leftButton.alpha = rightButton.alpha = 0;			
			addChild(leftButton);
			addChild(rightButton);
			
		}
		
		/**
		 * This method is called when the left navigation button is clicked.
		 */
		private function onLeftButton(evt:MouseEvent):void {
			
			leftButtonClicked();
			
		}
		
		/**
		 * This method is called when the right navigation button is clicked.
		 */
		private function onRightButton(evt:MouseEvent):void {
			
			rightButtonClicked();
			
		}
		
		/**
		 * Calculates new page index and updates the status of the buttons.
		 */
		private function rightButtonClicked():void {
			
			// Number of items on the right side of the mask
			var itemsLeft:int = container.numChildren - (pageIndex + ConfigManager.HORIZONTAL_MENU_PAGE_LIMIT);

			// Calculate page index
			if (itemsLeft >= ConfigManager.HORIZONTAL_MENU_PAGE_LIMIT) {
				pageIndex += ConfigManager.HORIZONTAL_MENU_PAGE_LIMIT;				
			} else {
				pageIndex += itemsLeft;
			}
			
			// Slide to given page index
			slideTo(pageIndex);
			checkButtons();
			
		}
		
		/**
		 * Calculates new page index and updates the status of the buttons.
		 */
		private function leftButtonClicked():void {
			
			if (pageIndex >= ConfigManager.HORIZONTAL_MENU_PAGE_LIMIT) {
				pageIndex -= ConfigManager.HORIZONTAL_MENU_PAGE_LIMIT;				
			} else {
				pageIndex = 0;
			}
			
			// Slide to given page index
			slideTo(pageIndex);
			checkButtons();
			
		}
		
		/**
		 * Slides container to the given index.
		 */
		private function slideTo(index:int) {
			
			// Calculate and slide to target
			var target:Number = 1 + menuMask.x + ConfigManager.HORIZONTAL_MENU_ITEM_BORDER_SIZE - index * (ConfigManager.HORIZONTAL_MENU_ITEM_WIDTH + ConfigManager.HORIZONTAL_MENU_ITEM_BORDER_SIZE * 2 + ConfigManager.HORIZONTAL_MENU_SPACING);
			Tweener.addTween(container, {x:target, time:0.95, transition:Equations.easeOutQuint});
			
		}
		
		/**
		 * Checks the status of the previous and next buttons. Updates
		 * states by calling appropriate methods.
		 */
		private function checkButtons():void {
			
			// Number of items on the right side of the mask
			var itemsLeft:int = items.length - (pageIndex + ConfigManager.HORIZONTAL_MENU_PAGE_LIMIT);
			
			if (itemsLeft > 0) {
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