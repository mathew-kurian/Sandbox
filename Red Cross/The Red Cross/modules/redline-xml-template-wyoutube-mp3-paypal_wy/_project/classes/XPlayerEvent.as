/**
 * XPlayerEvent
 * XPlayer Events
 *
 * @version		1.0
 */
package _project.classes {
	import flash.events.Event;
	//
	public class XPlayerEvent extends Event {
		//public constants...
		public static const MEDIA_BUFFERING_START:String = "media_buffering_start";
		public static const MEDIA_BUFFERING_STOP:String = "media_buffering_stop";
		public static const MEDIA_CLICK:String = "media_click";
		public static const MEDIA_END:String = "media_end";
		public static const MEDIA_ERROR:String = "media_error";
		public static const MEDIA_INFO:String = "media_info";
		public static const MEDIA_LOADING:String = "media_loading";
		public static const MEDIA_PAUSE:String = "media_pause";
		public static const MEDIA_PLAY:String = "media_play";
		public static const MEDIA_READY:String = "media_ready";
		public static const MEDIA_RESIZE:String = "media_resize";
		public static const INIT:String = "init";
		//
		//private vars...
		private var __bubbles:Boolean;
		private var __cancelable:Boolean;
		private var __type:String;
		//
		//constructor...
		public function XPlayerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.__type = type;
			this.__bubbles = bubbles;
			this.__cancelable = cancelable;
		};
		//
		//public methods...
		public override function clone():Event {
			return new XPlayerEvent(this.__type, this.__bubbles, this.__cancelable);
		};
		public override function toString():String {
			return formatToString("MenuEvent", "type", "bubbles", "cancelable", "eventPhase");
		};
	};
};