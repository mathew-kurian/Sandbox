/*
List.as
JukeBox

Created by Alexander Ruiz Ponce on 22/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes.display.jukeBox
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	import gs.TweenLite;
	import gT.display.components.GenericComponent;
	import gT.display.layout.VLayout
	import gT.display.Draw;
	import gT.utils.ArrayUtils;
	import gT.utils.ObjectUtils;
	import gT.utils.NumberUtils;
	
	import classes.Global;
	import classes.CustomEvent;
	
	public class List extends GenericComponent 
	{
		private var __mask:Sprite;
		private var __elements:Array;
		private var __data:Array;
		private var __holder:VLayout;
		private var __background:Sprite;
		private var __in:Boolean;
		private var __selected:ListItem;
		private var __selectedIndex:Number;
		private var __timeOutId:uint;
		private var __ym:Number = 0;
		private var __offset:Number = 27;
		private var __shuffleArray:Array;
		private var __hasListener:Boolean;
		public function List () {
			super();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		//////////////////////////////////////////////////////////
		
		
		override protected function init ():void
		{
			setMinSize(100, 50);
			super.init();
			
			addEventListener(MouseEvent.ROLL_OVER, mouseHandler, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, mouseHandler, false, 0, true);
		}
		
		/*
		override protected function onStage():void
		{
		}
		 */
		
		override protected function addChildren():void
		{
			// Background
			__background = Draw.rectangle(__minWidth, __minHeight, 0xff0000, 0);
			addChild(__background);
			
			// mask
			__mask = Draw.rectangle(__minWidth, __minHeight, 0xff0000, 0);
			addChild(__mask);
			mask = __mask;
			
			// layout
			__holder = new VLayout;
			addChild(__holder);
			
			// items
			//createItems();
		}
		
		//////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		//////////////////////////////////////////////////////////
		
		override public function draw ():void
		{
			__mask.width = __width;
			__mask.height = __height;
			
			__background.width = __width;
			__background.height = __height;
			
			if (__elements) {
				for (var i:uint; i < __elements.length; i++) 
				{
					__elements[i].width = __width;
				}
			}
		}

		public function click (index:uint):void
		{
			if (!__elements) return;
			
			__elements[index].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
			__elements[index].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			
			clearElement(__data[index]);
		}
		
		public function next ():void
		{
			if (!Global.shuffle) {
				if (isNaN(__selectedIndex)) {
					__selectedIndex = 0;
					click(__selectedIndex);
					return;
				}
				
				if (__selectedIndex < __data.length - 1) {
					__selectedIndex ++;
				} else {
					__selectedIndex = 0;
				}
			} else {
				__selectedIndex = getShuffleIndex();
			}
			
			click(__selectedIndex);
		}
		
		public function back ():void
		{
			if (!Global.shuffle) {
				if (isNaN(__selectedIndex)) {
					__selectedIndex = __data.length - 1;
					click(__selectedIndex);
					return;
				}
				
				if (__selectedIndex > 0) {
					__selectedIndex --;
				} else {
					__selectedIndex = __data.length - 1;
				}
				
			} else {
				__selectedIndex = getShuffleIndex();
			}
			
			click(__selectedIndex);
		}
		
		public function createShuffleList ():void
		{
			__shuffleArray = ArrayUtils.unsortArray(ArrayUtils.copy(__data));
		}
		
		//////////////////////////////////////////////////////////
		//
		// Events Handler
		//
		//////////////////////////////////////////////////////////
		
		private function panning(e:CustomEvent) 
		{	
			if (__in) {
				__ym = mouseY - (__offset/2);
			}
			
			var yEnd = -((((__holder.height + __offset * 2) - __height) / __height) * __ym);
			
			if (yEnd > 0) { 
				yEnd = 0 
			} else if (Math.abs(yEnd) > __holder.height - __height) {
				yEnd = -(__holder.height - __height);
			}
			
			var tween = (yEnd - __holder.y) / 15;
			__holder.y += tween;
			
			if (Math.abs(tween) < 0.1) {
				__holder.y = Math.round(__holder.y);
				//removeEventListener(Event.ENTER_FRAME, panning);
				__hasListener = false;
				Global.removeEventListener(CustomEvent.GLOBAL_RENDER, panning);
			}
		}
		
		private function mouseHandler (e:MouseEvent):void
		{
			switch (e.type) {
				case MouseEvent.ROLL_OVER:
					__in = true;
					clearTimeout(__timeOutId);
					
					if (__height < __holder.height) {
						addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
					}
					
					break;
				case MouseEvent.ROLL_OUT:
					__in = false;
					removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
					__timeOutId = setTimeout(snap, 1000);
					break;
			}
			
			function snap () {
				__hasListener = false;
				Global.removeEventListener(CustomEvent.GLOBAL_RENDER, panning);
				//removeEventListener(Event.ENTER_FRAME, panning);
				var dif = Math.abs(__holder.y) % 27;
				if (dif > Math.round(27 / 2)) {
					dif = (27 - dif) * -1;
				}
				
				TweenLite.to(__holder, .3, {y:String(dif)});
			}
		}
		
		private function mouseMoveHandler (e:MouseEvent):void
		{
			
			if (!__hasListener) {
				__hasListener = true;
				Global.addEventListener(CustomEvent.GLOBAL_RENDER, panning, false, 0, true);
				//addEventListener(Event.ENTER_FRAME, panning, false, 0, true);
			}
			
			e.updateAfterEvent();
		}
		
		private function itemHandler (e:JukeBoxEvent):void
		{
			if (__selected) {
				__selected.enabled = true;
			}
			__selected = e.currentTarget as ListItem;
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
			if (!__data) return;
			
			__elements = [];
			
			for (var i:uint; i < __data.length; i++) 
			{
				var item:ListItem = new ListItem;
				item.trackInfo = __data[i];
				item.label = __data[i].name;
				item.index = i;
				item.height = 27;
				item.addEventListener(JukeBoxEvent.ITEM_LIST_CLICKED, itemHandler, false, 0, true);
				__elements.push(item);
				__holder.addChild(item);
			}
			
			draw();
		}
		
		private function clearItems ():void
		{
			if (!__elements) return;
			
			for (var i:uint; i < __elements.length; i++) 
			{
				__elements[i].removeEventListener(JukeBoxEvent.ITEM_LIST_CLICKED, itemHandler);
				__holder.removeChild(__elements[i]);
			}
			
			__elements = [];
		}

		
		private function clearElement (element:Object):void
		{
			for (var i in __shuffleArray)
			{
				if (ObjectUtils.compare(element, __shuffleArray[i]))
				{
					__shuffleArray.splice(i, 1);
					break;
				}
			}
		}
		
		private function findElement (element:Object):Number
		{
			for (var i in __data)
			{			
				if (ObjectUtils.compare(element, __data[i]))
				{
					return i;
				}
			}
			
			
			return -1;
		}
		
		private function getShuffleIndex ():uint
		{
			var randomInt = NumberUtils.randomInt(0, __shuffleArray.length-1);
			var elementToFind = __shuffleArray[randomInt];
			var index = findElement(elementToFind);
			
			if (index == -1)
			{
				createShuffleList()
				return getShuffleIndex();
			}
			
			return index;
		}
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		public function get selected ():ListItem
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
		
		public function set data (value:Array):void
		{
			__selected = null		// Reset the current selected
			__selectedIndex = NaN	// Reset the Index
			__holder.y = 0;			// Reset the holder position
			clearItems();			// Clear the elements if any
			
			__data = value;			// Set data
			
			createShuffleList();	// Create the Shuffle List
			createItems();			// Now create the item list
		}
	}
}