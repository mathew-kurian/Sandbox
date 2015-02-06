/**
 * GalleryEvent
 * Gallery's Events implementation
 *
 * @version		1.0
 */
package _project.classes {
	import flash.events.Event;
	//
	public class GalleryEvent extends Event {
		//public constants...
		public static const HIDE:String = "hide";
		public static const ITEM_CLICK:String = "item_click";
		public static const ITEM_MOUSE_OUT:String = "item_mouse_out";
		public static const ITEM_MOUSE_OVER:String = "item_mouse_over";
		public static const UPDATED:String = "updated";
		public static const ROLL_OUT:String = "roll_out";
		public static const ROLL_OVER:String = "roll_over";
		public static const SHOW:String = "show";
		//
		//private vars...
		private var __bubbles:Boolean;
		private var __cancelable:Boolean;
		private var __type:String;
		//
		//constructor...
		public function GalleryEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.__type = type;
			this.__bubbles = bubbles;
			this.__cancelable = cancelable;
		};
		//
		//public methods...
		public override function clone():Event {
			return new GalleryEvent(this.__type, this.__bubbles, this.__cancelable);
		};
		public override function toString():String {
			return formatToString("MenuEvent", "type", "bubbles", "cancelable", "eventPhase");
		};
	};
};