/*
Menu.as
CoolTemplate

Created by Alexander Ruiz Ponce on 2/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.controls 
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gs.TweenMax;
	import gT.display.layout.HLayout
	import gT.display.components.GenericComponent;	
	
	import classes.display.MenuItem;
	import classes.Global;
	import classes.CustomEvent;
	
	public class MainMenu extends Menu {
				
		public function MainMenu():void
		{
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		override protected function createItem(index:uint):*
		{
			var item:MainItem = new MainItem(__source[index]);
			item.addEventListener(MenuItem.MENU_ITEM_CLICKED, onItemClicked);
			item.autoSize = true;
			item.padding = {left:5, right:5};
			return item;
		}
		
		override protected function addChildren():void
		{
			// layout
			__holder = new HLayout;
			addChild(__holder);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			__width = __holder.width;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function itemHandler (e:CustomEvent):void
		{
			if (!__fireEvent) {
				__fireEvent = true;
				e.stopImmediatePropagation();
			}
			
			if (__selected) {
				__selected.enabled = true;
			}
			__selected = e.currentTarget as MenuItem;
			__selectedIndex = e.currentTarget.index;
			__selected.enabled = false;
		}
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		
		private function createItems ():void
		{
			if (!__items) return;
			
			__elements = [];
			
			for (var i:uint; i < __items.length; i++) 
			{
				var item:MenuItem = new MenuItem(__items[i]);
				item.index = i;
				__elements.push(item);
				__holder.addChild(item);
				
				item.addEventListener(CustomEvent.ITEM_MENU_CLICKED, itemHandler, false, 0, true);
			}
			
			draw();
			
			// Tween for each item
			for (var j in __elements)
			{
				var pos = (j % 2) ? 100 : -100;
				TweenMax.from(__elements[j], Global.settings.time, {alpha:0, y:pos, ease:Global.settings.easeInOut, delay:.05*j});
			}
		}
		
		private function clearItems ():void
		{
			if (!__elements) return;
			
			for (var i:uint; i < __elements.length; i++) 
			{
				__elements[i].removeEventListener(CustomEvent.ITEM_MENU_CLICKED, itemHandler);
				__holder.removeChild(__elements[i]);
			}
			
			__elements = [];
		}
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		
		public function set items (value:Array):void
		{
			__selected = null		// Reset the current selected
			__selectedIndex = NaN	// Reset the Index
			clearItems();			// Clear the elements if any
			
			__items = value;		// Set data
			createItems();			// Now create the item list
		}
		
		public function get selected ():MenuItem
		{
			return __selected;
		}
		
		public function get selectedIndex ():Number
		{
			return __selectedIndex;
		}
		
		public function get elements ():Array
		{
			return __elements;
		}
	}
}