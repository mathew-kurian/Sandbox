/*
Main.as
CoolTemplate

Created by Alexander Ruiz Ponce on 26/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
		
	public class ProductListPlugin extends MovieClip {
		
		private var __products:Products;
		private var __width:Number = 630;
		private var __height:Number = 385;
		private var __path:String = "";
		
		public function ProductListPlugin () {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init (e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			__products = new Products(__path);
			addChild(__products);
			resize();
		}
		
		private function resize (e:Event = null):void
		{
			if (__products) {
				__products.width = __width;
				__products.height = __height;
			}
		}
		
		override public function set width (value:Number):void
		{
			__width = value;
			resize();
		}
		
		override public function get width ():Number
		{
			return __width;
		}
		
		override public function set height (value:Number):void
		{
			__height = value;
			resize();
		}
		
		override public function get height ():Number
		{
			return __height;
		}
		
		public function set path (value:String):void
		{
			__path = value;
		}
	}
}