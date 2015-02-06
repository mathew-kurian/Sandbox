package net.flashden.lydian.bannerrotator {
	
	import flash.events.Event;
		
	public class NumberButtonEvent extends Event {
		
		// A constant for selected type
		public static const SELECTED:String = "selected";
		
		// Holds the index of the number button
		public var index:int;
		
		// Holds the previous index
		public var previousIndex:int;
		
		public function NumberButtonEvent(type:String, bubbles:Boolean = false, 
					cancellable:Boolean = false, index:int = -1, previousIndex:int = -1) {
			
			super(type, bubbles, cancellable);
			this.index = index;
			this.previousIndex = previousIndex;
			
		}
		
		/**
		 * Returns a copy of the event.
		 */
		public override function clone():Event {
			
			return new NumberButtonEvent(type, bubbles, cancelable, index, previousIndex);
			
		}
		
		/**
		 * Returns the string representation of the event.
		 */
		public override function toString():String {
			
			return formatToString("NumberButtonEvent", "type", "bubbles",
				"cancellable", "eventType", "index", "previousIndex");
			
		}
		
	}
	
}