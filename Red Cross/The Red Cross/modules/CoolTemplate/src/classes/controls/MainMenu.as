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
	import classes.display.MainItem;
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
			item.padding = {left:10, right:10};
			return item;
		}
		
		override protected function createItems ():void
		{
			super.createItems();
			
			// Little animation for each item
			for (var j in __elements)
			{
				var pos = (j % 2) ? 100 : -100;
				TweenMax.from(__elements[j], Global.settings.time, {alpha:0, y:pos, ease:Global.settings.easeInOut, delay:.05*j});
			}
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