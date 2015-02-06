/*
PlayList.as
JukeBox

Created by Alexander Ruiz Ponce on 22/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display.jukeBox
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import gT.display.components.GenericComponent;
	
	import classes.Global;
	
	public class PlayList extends GenericComponent {
		
		private var __lcd:LCD;
		private var __list:List;
		private var __padding:uint = 8;
		private var __header:PlayListHeader;
		private var __autoPlay:Boolean = true;
		
		public function PlayList () {
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////

		override protected function addChildren():void
		{
			// LCD
			__lcd = new LCD;
			addChild(__lcd);
			
			// Header
			__header = new PlayListHeader;
			__header.height = 36;
			__header.addEventListener(JukeBoxEvent.JUKE_BOX_SHUFFLE, headerHandler, false, 0, true);
			__header.addEventListener(JukeBoxEvent.JUKE_BOX_REPEAT, headerHandler, false, 0, true);
			__lcd.content.addChild(__header);
			
			// List
			__list = new List();
			__list.addEventListener(JukeBoxEvent.ITEM_LIST_CLICKED, listHandler, false, 0, true);
			__list.height = 108;
			__lcd.content.addChild(__list);
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			__lcd.width = __width;
			__lcd.height = __height;
			
			__header.width = __width - LCD.MARGIN * 2;
			__list.width = __header.width;
			__list.y = (__height - __list.height - LCD.MARGIN * 2) + 1;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		private function listHandler (e:JukeBoxEvent):void
		{
			//__header.ticket.stop(false, true);
			__header.ticket.text = e.params.trackInfo.name.toUpperCase();
			//trace("PLAY LIST");
			//__header.ticket.start();
		}
		
		private function headerHandler (e:JukeBoxEvent):void
		{			
			if (e.params.shuffle) {
				__list.createShuffleList();
			}
		}
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
		
		public function get list ():List
		{
			return __list;
		}
		
		public function get header ():PlayListHeader
		{
			return __header;
		}
		
		public function set data (value:Array):void
		{
			__list.data = value;
			if (__autoPlay) { __list.next(); }
		}
		
		public function set autoPlay (value:Boolean):void
		{
			__autoPlay = value;
		}
		public function get autoPlay ():Boolean
		{
			return __autoPlay;
		}
	}
}