/**
 * SwfLoader
 * SWF files loader implementation
 *
 * @version		3.0
 */
package _project.classes	{
	use namespace AS3;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	//
	import _project.classes.ITransition;
	//
	public class SwfLoader extends Sprite {
		//private constants...
		private const __KALIGN:Array = [ { id: "", x: 0.5, y: 0.5 }, { id: "T", x: 0.5, y: 0 }, { id: "B", x: 0.5, y: 1 }, { id: "L", x: 0, y: 0.5 }, { id: "R", x: 1, y: 0.5 }, 
										{ id: "TL", x: 0, y: 0 }, { id: "TR", x: 1, y: 0 }, { id: "BL", x: 0, y: 1 }, { id: "BR", x: 1, y: 1 } ];
		private const __KALIGN_INDEX:Number = 0;
		//
		//private vars...
		private var __loader:Loader;
		protected var __media:*;
		protected var __status:Object;
		private var __swfresize:String;
		private var __swfunload:String;
		private var __loadercontent:DisplayObject;
		private var __timer:Timer;
		private var __transition:ITransition;
		//
		//constructor...
		public function SwfLoader(boolAutoShow:Boolean = false, strResizeFunctionName:String = undefined, strUnloadFunctionName:String = undefined, objTransition:ITransition = undefined) {
			if (!(strResizeFunctionName is String)) strResizeFunctionName = undefined
			else if (strResizeFunctionName == "") strResizeFunctionName = undefined;
			if (!(strUnloadFunctionName is String)) strUnloadFunctionName = undefined
			else if (strUnloadFunctionName == "") strUnloadFunctionName = undefined;
			this.__loader = new Loader();
			this.__loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.__onInit);
			this.__loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.__onIoError);
			this.__loader.contentLoaderInfo.addEventListener(Event.OPEN, this.__onOpen);
			this.__loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.__onProgress);
			//
			this.__status = { align: this.__KALIGN[this.__KALIGN_INDEX], autoshow: Boolean(boolAutoShow), context: null, height: 0, mediaisavailable: false, progress: { bytesloaded: 0, bytestotal: 0 }, reset: false, smoothing: true, url: undefined, width: 0 };
			if (objTransition is ITransition) {
				this.__transition = objTransition;
				this.__transition.addEventListener(Event.CLOSE, this.__onTransitionClose);
				this.__transition.addEventListener(Event.OPEN, this.__onTransitionOpen);
			};
			//
			this.__swfresize = strResizeFunctionName;
			this.__swfunload = strUnloadFunctionName;
			//
			this.__timer = new Timer(10, 5);
			this.__timer.addEventListener(TimerEvent.TIMER, this.__onTimer);
			this.__timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__onTimerComplete);
		};
		//
		//private methods...
		protected function __onAdded(event:Event):void {
			event.currentTarget.removeEventListener(Event.ADDED, this.__onAdded);
			if (this.__loadercontent != event.currentTarget) return;
			this.__loadercontent = undefined;
			//
			this.__status.mediaisavailable = true;
			this.__status.mediatype = this.__loader.contentLoaderInfo.contentType.toUpperCase();
			if (this.__loader.contentLoaderInfo.contentType == "application/x-shockwave-flash") this.__media = MovieClip(this.__loader.content)
			else {
				this.__media = Bitmap(this.__loader.content);
				this.__media.smoothing = this.__status.smoothing;
			};
			this.__resize();
			if (this.__swfresize is String) this.__timer.start();
			this.dispatchEvent(new Event(Event.INIT));
			if (this.__status.autoshow) this.show();
		};
		private function __onInit(event:Event):void {
			try {
				this.__loadercontent.removeEventListener(Event.ADDED, this.__onAdded);
			}
			catch (_error:Error) {
				//...
			};
			this.__loadercontent = event.currentTarget.content;
			this.__loadercontent.addEventListener(Event.ADDED, this.__onAdded);
			this.addChild(this.__loadercontent);
		};
		private function __onIoError(event:IOErrorEvent):void {
			this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		};
		private function __onOpen(event:Event):void {
			this.dispatchEvent(new Event(Event.OPEN));
		};
		private function __onProgress(event:ProgressEvent):void {
			this.__status.progress.bytesloaded = event.bytesLoaded;
			this.__status.progress.bytestotal = event.bytesTotal;
			this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
		};
		public function __onTimer(event:TimerEvent):void {
			if (!(this.__swfresize is String)) this.__timer.reset()
			else if (this.__media[this.__swfresize] is Function) {
				this.__timer.reset();
				this.__resize();
			};
		};
		public function __onTimerComplete(event:TimerEvent):void {
			this.__timer.reset();
			this.__resize();
		};
		protected function __onTransitionClose(event:Event = undefined):void {
			this.visible = false;
			this.dispatchEvent(new Event(Event.DEACTIVATE));
			if (this.__status.url is String) {
				this.__reset();
				this.__loader.load(new URLRequest(this.__status.url), this.__status.context);
				delete this.__status.url;
			}
			else if (this.__status.reset) {
				this.__reset();
				delete this.__status.url;
			};
			this.__status.reset = false;
		};
		protected function __onTransitionOpen(event:Event = undefined):void {
			this.dispatchEvent(new Event(Event.ACTIVATE))
		};
		public function __reset():void {
			try {
				this.__loadercontent.removeEventListener(Event.ADDED, this.__onAdded);
			}
			catch (_error:Error) {
				//...
			};
			this.__loadercontent = undefined;
			try {
				this.__media[this.__swfunload]();
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__loader.unload();
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.removeChild(this.__media);
			}
			catch (_error:Error) {
				//...
			};
			this.__status.mediaisavailable = false;
			this.__status.progress.bytesloaded = this.__status.progress.bytestotal = 0;
		};
		public function __resize():void {
			if (!(this.__media is DisplayObject)) return;
			if (!(this.stage is Stage)) return;
			if ((this.__swfresize is String) && (this.__media[this.__swfresize] is Function)) {
				this.__media.x = this.__media.y = 0;
				try {
					this.__media[this.__swfresize](this.__status.height, this.__status.width);
				}
				catch (_error:Error) {
					//...
				};
			}
			else {
				this.__media.x = this.__status.align.x * (this.__status.width - this.__media.width);
				this.__media.y = this.__status.align.y * (this.__status.height - this.__media.height);
			};
			if (this.__transition is ITransition) this.__transition.resize();
		};
		//
		//properties...
		public function get context():* {
			return this.__status.context;
		};
		public function get durationIntro():Number {
			return ((this.__transition is ITransition) ? this.__transition.durationIntro : 0);
		};
		public function get durationOutro():Number {
			return ((this.__transition is ITransition) ? this.__transition.durationOutro : 0);
		};
		public function set context(loaderContext:*):void {
			if (loaderContext is LoaderContext) this.__status.context = loaderContext;
		};
		public override function get height():Number {
			return this.__status.height;
		};
		public override function set height(value:Number):void {
			if (isNaN(value)) return;
			if (value < 0) return;
			this.__status.height = value;
			if (this.__media.setHeight is Function) this.__media.setHeight(this.__status.height);
		};
		public override function get width():Number {
			return this.__status.width;
		};
		public override function set width(value:Number):void {
			if (isNaN(value)) return;
			if (value < 0) return;
			this.__status.width = value;
			if (this.__media.setWidth is Function) this.__media.setWidth(this.__status.width);
		};
		//
		//public methods...
		public function hide():void {
			if (this.visible && (this.__transition is ITransition)) this.__transition.outro(this)
			else this.__onTransitionClose();
		};
		public function load(strURL:String, strAlign:String = undefined):Boolean {
			if (!(strURL is String)) return false;
			if (strURL == "") return false;
			this.__timer.reset();
			this.__status.align = this.__KALIGN[this.__KALIGN_INDEX];
			if (strAlign is String) {
				strAlign = strAlign.toUpperCase();
				for (var i in this.__KALIGN) {
					if (strAlign == this.__KALIGN[i].id) {
						this.__status.align = this.__KALIGN[i];
						
						break;
					};
				};
			};
			this.__status.reset = false;
			this.__status.url = strURL;
			this.hide();
			//
			return true;
		};
		public function reset():void {
			this.__status.reset = true;
			this.hide();
		};
		public function resize(height:Number = undefined, width:Number = undefined):void {
			if (isNaN(height)) height = this.__status.height
			else if (height < 0) height = this.__status.height;
			if (isNaN(width)) width = this.__status.width
			else if (width < 0) width = this.__status.width;
			//
			this.__status.height = height;
			this.__status.width = width;
			//
			if (!(this.__media is DisplayObject)) return;
			this.__resize();
			if (this.__transition is ITransition) this.__transition.resize();
		};
		public function show():void {
			if (!this.__status.mediaisavailable) return;
			this.visible = true;
			if (this.__transition is ITransition) this.__transition.intro(this);
		};
	};
};