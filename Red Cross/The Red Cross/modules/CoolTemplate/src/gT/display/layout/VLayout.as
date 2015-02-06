/*
VLayout.as


Created by Alexander Ruiz Ponce on 22/10/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package gT.display.layout
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class VLayout extends Sprite {
		
		private var __gab:int;
		
		public function VLayout ():void {
			addEventListener(Event.ADDED, draw);
			addEventListener(Event.REMOVED, draw);
		}
		
		public function draw (e:Event = null):void
		{
			var i:uint = 0;
			var l:uint = numChildren;
			for (i; i < l; i++) 
			{
				var child = getChildAt(i);
				if (i) {
					var previousChild = getChildAt(i-1);
					child.y = previousChild.height + previousChild.y + __gab;
				}
			}
		}
		
		//////////////////////////////////////////////////////////
		//
		// Setters && Getters
		//
		//////////////////////////////////////////////////////////
		public function set gab (value:Number):void
		{
			__gab = value;
			draw();
		}
		
		public function get gab ():Number
		{
			return __gab;
		}
	}
}