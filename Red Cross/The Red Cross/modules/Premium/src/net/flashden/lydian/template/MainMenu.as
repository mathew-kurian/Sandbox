package net.flashden.lydian.template {
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
		
	public class MainMenu extends MovieClip {
	
		// A container to hold menu items
		private var container:Sprite = new Sprite();
		
		// The menu mask
		private var menuMask:SimpleRectangle = new SimpleRectangle();
		
		// Array of the menu items
		private var _menuItems:Array;
		
		// Holds the selected menu item
		private var _selectedItem:MainMenuItem;
		
		public function MainMenu(menuItems:Array) {
			
			this._menuItems = menuItems;
			
			// Initialize the main menu
			init();
			
		}
		
		/**
		 * Initializes the main menu.
		 */
		private function init():void {
			
			// Add necessary mouse listeners
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false , 0, true);
			var visibleMenuItems:Array = new Array();
			
			// Push visible menu items into a new array
			for (var i:int = 0; i < _menuItems.length; i++) {
				var menuItem:MainMenuItem = _menuItems[i] as MainMenuItem;
				
				if (menuItem.showInMainMenu) {
					visibleMenuItems.push(menuItem);
				}
			}
			
			// Add first menu item
			var firstMenuItem:MainMenuItem = visibleMenuItems[0] as MainMenuItem;
			Tweener.addTween(firstMenuItem.background, {_color:0xFF0000});
			firstMenuItem.x = firstMenuItem.width / 2;
			firstMenuItem.y = 0;
			container.addChild(firstMenuItem);
			
			// Add other menu items
			for (i = 1; i < visibleMenuItems.length; i++) {				
				var prevItem:MainMenuItem = visibleMenuItems[i - 1] as MainMenuItem;
				var nextItem:MainMenuItem = visibleMenuItems[i] as MainMenuItem;
				nextItem.x = prevItem.x;
				nextItem.y = prevItem.y + prevItem.height + ConfigManager.MM_SPACING;	
				Tweener.addTween(nextItem.background, {_color:ConfigManager.MM_SELECTED_MENU_BACKGROUND});			
				container.addChild(nextItem);
			}
			
			// Add container to the main movie clip
			addChild(container);
			
		}
		
		/**
		 * Plays opening animation for the main menu.
		 */
		public function openMenu():void {
						
			for (var i:int = 0; i < _menuItems.length; i++) {
				var menuItem:MainMenuItem = _menuItems[i];				
				var target:Number = menuItem.width / 2;
				menuItem.alpha = 0;
				Tweener.addTween(menuItem, {alpha:1, time:1, delay:i * 0.08, transition:Equations.easeOutQuint});
				
				if (!menuItem.selected) {
					Tweener.addTween(menuItem.background, {_color:null, time:1, delay:i * 0.08, transition:Equations.easeOutQuint});
				}
			}			
			
		}
		
		/**
		 * This method is called when the mouse is clicked on one of the menu items.
		 */
		private function onMouseDown(evt:MouseEvent):void {
			
			// Get the clicked menu item
			var mainMenuItem:MainMenuItem = evt.target as MainMenuItem;
			selectMenuItem(mainMenuItem);
			
		}
		
		/**
		 * Selects the given menu item.
		 */
		public function selectMenuItem(mainMenuItem:MainMenuItem):void {
			
			// Select menu item and remove selection from the previous item
			if (mainMenuItem != null && mainMenuItem != _selectedItem) {				
				if (_selectedItem != null) {
					_selectedItem.selected = false;
				}
				
				_selectedItem = mainMenuItem;
				mainMenuItem.selected = true;
			}
			
		}
		
		/**
		 * Selects menu item with the given index number.
		 */
		public function selectMenuItemByIndex(index:int):void {
			
			if (index >= 0 && index < _menuItems.length) {
				var mainMenuItem:MainMenuItem = _menuItems[index];
				selectMenuItem(mainMenuItem);
			}
			
		}
		
		/**
		 * Returns the actual menu width.
		 */
		public override function get width():Number {
			
			return (_menuItems[0] as MainMenuItem).width;
		
		}
			
	}
	
}