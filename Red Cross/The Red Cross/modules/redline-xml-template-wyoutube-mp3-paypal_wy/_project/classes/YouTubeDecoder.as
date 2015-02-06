/**
 * YouTubeDecoder
 * YouTube URL Decoder
 *
 * @version		1.0
 */
package _project.classes {
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	//
	public class YouTubeDecoder extends EventDispatcher implements IDecoder {
		//constants...
		private const __ARGS:Object = { swfArgs: ' swfargs', args: { fmt: '"fmt_map"', id: '"video_id"', t: '"t"' } };
		private const __DIRECTLINK:String = "directlink";
		private const __HIGHQUALITY:String = "&fmt=6";
		private const __MEDIATYPE:String = "YouTube";
		private const __PATTERN:String = "youtube.com/watch?v=";
		private const __SCRIPT:String = "youtube.php";
		private const __TAG:String = "youtube";
		private const __URL:String = "http://www.youtube.com/get_video.php?video_id=";
		//
		//private vars...
		private var __data:Object;
		private var __loader:URLLoader;
		private var __logo:BitmapData;
		private var __logohq:BitmapData;
		//
		//constructor...
		public function YouTubeDecoder(bdLogo:BitmapData = undefined, bdLogoHq:BitmapData = undefined) {
			this.__data = new Object();
			if (bdLogo is BitmapData) this.__logo = bdLogo;
			if (bdLogoHq is BitmapData) this.__logohq = bdLogoHq;
			if (!(this.__logo is BitmapData)) this.__logo = this.__logohq;
			if (!(this.__logohq is BitmapData)) this.__logohq = this.__logo;
		};
		//
		//private methods...
		private function __onComplete(event:Event):void {
			this.__data = { url: URLLoader(event.target).data[this.__DIRECTLINK] };
			this.reset();
			//external...
			this.dispatchEvent(new Event(Event.COMPLETE));
		};
		private function __onIOError(event:IOErrorEvent):void {
			this.reset();
			this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		};
		private function __onSecurityError(event:SecurityErrorEvent):void {
			this.reset();
			this.dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR));
		};
		//
		//properties...
		public function get data():Object {
			var _data:Object = { };
			try {
				for (var i in this.__data) _data[i] = this.__data[i];
			}
			catch (_error:Error) {
				//...
			};
			return _data;
		};
		public function set setLogo(bdLogo:BitmapData):void {
			if (bdLogo is BitmapData) {
				this.__logo = bdLogo;
				if (!(this.__logohq is BitmapData)) this.__logohq = this.__logo;
			};
		};
		public function set setLogoHq(bdLogoHq:BitmapData):void {
			if (bdLogoHq is BitmapData) {
				this.__logohq = bdLogoHq;
				if (!(this.__logo is BitmapData)) this.__logo = this.__logohq;
			};
		};
		public function get mediatype():String {
			return this.__MEDIATYPE;
		};
		public function get tag():String {
			return this.__TAG;
		};
		//
		//public methods...
		public function decode(strURL:String):Boolean {
			if (strURL.indexOf(this.__PATTERN) < 0) return false;
			//
			this.reset();
			//
			var _urlrequest:URLRequest = new URLRequest(this.__SCRIPT);
			_urlrequest.method = URLRequestMethod.POST;
			//
			var _urlvariables:URLVariables = new URLVariables();
			_urlvariables.url = strURL;
			_urlrequest.data = _urlvariables;
			//
			this.__loader = new URLLoader();
			this.__loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			this.__loader.addEventListener(Event.COMPLETE, this.__onComplete);
			this.__loader.addEventListener(IOErrorEvent.IO_ERROR, this.__onIOError);
			this.__loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.__onSecurityError);
			this.__loader.load(_urlrequest);
			return true;
		};
		public function iscompatible(strURL:String):Boolean {
			return (strURL.indexOf(this.__PATTERN) >= 0);
		};
		public function logo(boolHighQuality:Boolean = false):BitmapData {
			return ((boolHighQuality) ? this.__logohq : this.__logo);
		};
		public function reset():void {
			if (!(this.__loader is URLLoader)) return;
			this.__loader.close();
			try {
				this.__loader.removeEventListener(Event.COMPLETE, this.__onComplete);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__loader.removeEventListener(IOErrorEvent.IO_ERROR, this.__onIOError);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.__onSecurityError);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__loader.close();
			}
			catch (_error:Error) {
				//...
			};
			this.__loader = undefined;
		};
		public function url(boolHighQuality:Boolean = false):String {
			try {
				return (this.__data.url + ((boolHighQuality) ? this.__HIGHQUALITY : ""));
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
	};
};