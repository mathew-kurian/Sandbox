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
	import gT.controls.Menu;
	import gT.display.MenuItem;
	import classes.display.MonthItem;
	import classes.Global;
	import classes.CustomEvent;
	
	public class MonthsMenu extends Menu {
				
		public function MonthsMenu():void
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
			var item:MonthItem = new MonthItem(__source[index]);
			item.addEventListener(MenuItem.MENU_ITEM_CLICKED, onItemClicked);
			item.index = index;
			item.autoSize = true;
			item.padding = {left:8, right:8};
			return item;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
	}
}