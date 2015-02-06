/**
 * ThumbSource
 * Thumbnails creator
 *
 * @version		1.5
 */
package _project.classes {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.system.LoaderContext;
	import flash.net.URLRequest;
	//
	public class ThumbSource extends EventDispatcher {
		//private constants...
		private const __HEIGHT:Number = 100;
		private const __WIDTH:Number = 150;
		//private vars...
		private var __loadercontext:LoaderContext;
		private var __dimensions:Object;
		private var __loader:Loader;
		private var __status:Object;
		private var __threads:Array;
		//
		//constructor...
		public function ThumbSource(objDimensions:Object = undefined, loaderContext:LoaderContext = null) {
			this.__dimensions = { height: undefined, width: undefined };
			if (objDimensions) {
				var _valid:int = 0;
				for (var i in this.__dimensions) {
					if (isNaN(objDimensions[i])) continue;
					if (objDimensions[i] <= 0) continue;
					this.__dimensions[i] = Math.round(objDimensions[i]);
					_valid++;
				};
				if (_valid <= 0) return;
			};
			this.__status = { active: false, current: 0, finished: -1, isloading: false, suspend: false };
			this.__threads = new Array();
			this.__loader = new Loader();
			this.__loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.__onInit);
			this.__loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.__onIoError);
			this.__loadercontext = loaderContext;
		};
		//
		//private methods...
		private function __isduplicate(strURL:String):Boolean {
			if (!(strURL is String)) return true;
			if (strURL == "") return true;
			strURL = strURL.toLocaleLowerCase();
			for (var i in this.__threads) {
				if (strURL == this.__threads[i].url.toLowerCase()) return true;
			};
			return false;
		};
		private function __onInit(event:Event):void {
			this.__status.isloading = false;
			if (this.__threads.length < 1) return;
			var target:DisplayObject = DisplayObject(event.currentTarget.content);
			if (!(target is DisplayObject)) return;
			var thread:Object = this.__threads[this.__status.current];
			var scale:Number = 1;
			if (isNaN(thread.height)) {
				thread.height = target.height;
				if (!isNaN(thread.width)) {
					scale = thread.width / target.width;
					thread.height = Math.round(scale * target.height);
				}
				else thread.width = target.width;
			}
			else if (isNaN(thread.width)) {
				thread.width = target.width;
				if (!isNaN(thread.width)) {
					scale = thread.height / target.height
					thread.width = Math.round(scale * target.width);
				}
				else thread.height = target.height;
			}
			else scale = Math.max(thread.height / target.height, thread.width / target.width);
			var bd:BitmapData = new BitmapData(scale * target.width, scale * target.height, true, 0x00000000);
			bd.draw(target, new Matrix(scale, 0, 0, scale), new ColorTransform(), null, null, true);
			//
			if (bd.height != thread.height || bd.width != thread.width) {
				thread.bitmapdata = new BitmapData(thread.width, thread.height, true, 0x00000000);
				thread.bitmapdata.copyPixels(bd, thread.bitmapdata.rect, new Point(0, 0));
			}
			else thread.bitmapdata = bd;
			this.__status.finished = this.__status.current;
			this.dispatchEvent(new Event(Event.INIT));
			if (this.__status.suspend) return;
			if (this.__status.current < this.__threads.length - 1) {
				this.__status.current++;
				this.__status.isloading = true;
				this.__loader.load(new URLRequest(this.__threads[this.__status.current].url), this.__threads[this.__status.current].loadercontext)
			}
			else this.__status.active = false;
		};
		private function __onIoError(event:IOErrorEvent):void {
			this.__status.isloading = false;
			if (this.__threads.length < 1) return;
			if (this.__status.current < this.__threads.length - 1) this.__threads[this.__status.current].bitmapdata = new BitmapData((isNaN(this.__threads[this.__status.current].width)) ? this.__WIDTH : this.__threads[this.__status.current].width, (isNaN(this.__threads[this.__status.current].height)) ? this.__HEIGHT : this.__threads[this.__status.current].height, true, 0x00000000);
			this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			if (this.__status.suspend) return;
			if (this.__status.current < this.__threads.length - 1) {
				this.__status.current++;
				this.__status.isloading = true;
				this.__loader.load(new URLRequest(this.__threads[this.__status.current].url), this.__threads[this.__status.current].loadercontext)
			}
			else this.__status.active = false;
		};
		//
		//properties...
		public function get active():Boolean {
			return this.__status.active;
		};
		public function get loaderContext():LoaderContext {
			return this.__loadercontext;
		};
		public function get completedTasks():int {
			return (this.__status.finished + 1);
		};
		public function get totalTasks():int {
			return this.__threads.length;
		};
		public function set loaderContext(loaderContext:LoaderContext):void {
			if (loaderContext is LoaderContext) this.__loadercontext = loaderContext;
		};
		public function get isSuspended():Boolean {
			return this.__status.suspend;
		};
		//
		//public methods...
		public function load(arraySources:Array):Boolean {
			var _length:int = this.__threads.length;
			for (var j:int = 0; j < arraySources.length; j++) {
				if (!arraySources[j]) continue;
				if (this.__isduplicate(arraySources[j])) continue;
				this.__threads.push( { height: this.__dimensions.height, loadercontext: this.__loadercontext, width: this.__dimensions.width, url: arraySources[j] } )
			};
			if (this.__threads.length - _length < 1) return false;
			if (!this.__status.active) {
				this.__status.active = true;
				var _thumb:String = this.__threads[this.__status.current].thumb;
				if (!(_thumb is String)) _thumb = this.__threads[this.__status.current].url
				else if (_thumb == "") _thumb = this.__threads[this.__status.current].url;
				this.__status.isloading = true;
				this.__loader.load(new URLRequest(_thumb), this.__threads[this.__status.current].loadercontext);
			};
			return true;
		};
		public function resume():void {
			if (this.__status.suspend) {
				this.__status.suspend = false;
				if (this.__status.isloading) return;
				if (this.__status.current < this.__threads.length - 1) {
					this.__status.current++;
					this.__status.isloading = true;
					this.__loader.load(new URLRequest(this.__threads[this.__status.current].url), this.__threads[this.__status.current].loadercontext)
				}
				else this.__status.active = false;
			};
		};
		public function reset():void {
			this.__loader.close();
			this.__threads = new Array();
		};
		public function suspend():void {
			this.__status.suspend = true;
		};
		public function thumb(strURL:String, wipeOut:Boolean = false):BitmapData {
			if (!(strURL is String)) return undefined;
			if (this.__status.finished < 0) return undefined;
			var result:BitmapData;
			strURL = strURL.toLowerCase();
			for (var i:int = this.__status.finished; i >= 0; i--) {
				if (strURL == this.__threads[i].url.toLowerCase()) {
					result = this.__threads[i].bitmapdata;
					if (wipeOut) {
						this.__threads.splice(i, 1);
						this.__status.current--;
					};
					break;
				};
			};
			return result;
		};
	};
};