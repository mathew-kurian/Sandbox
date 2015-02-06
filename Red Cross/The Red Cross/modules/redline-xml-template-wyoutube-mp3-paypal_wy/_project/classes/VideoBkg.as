/**
 * VideoBkg
 * Video background loop player
 *
 * @version		1.0
 */
package _project.classes {
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.utils.Timer;
	import fl.transitions.TweenEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	//
	import _project.classes.XNetStream;
	//
	public class VideoBkg extends Sprite {
		//constants...
		private const __KFX_PARAMS:Object = { filters: [ new BlurFilter(16, 16, 3) ], alphain: 1, alphaout: 0.75, durationin: 0.5, durationout: 1.5, transitionin: Strong.easeIn, transitionout: Back.easeOut, useseconds: true };
		private const __KSLOWMOTION:Object = { pause: 800, play: 200 };
		private const __KVIDEO_PARAMS:Object = { aspectratio: false, deblocking: false, smoothing: false };
		//private vars...
		private var __count:int = 0;
		private var __fx:Tween;
		private var __netconnection:NetConnection;
		private var __media:Video;
		private var __netstream:XNetStream;
		private var __slowmotion:Object;
		private var __status:Object;
		//public vars...
		//
		//constructor...
		public function VideoBkg(strURL:String, boolAspectRatio:Boolean = undefined, boolDeblocking:Boolean = undefined, boolSmoothing:Boolean = undefined, floatAlphaOut:Number = undefined, arrayFilters:Array = undefined, intSlowMotionPause:int = undefined, intSlowMotionPlay:int = undefined) {
			if (!(strURL is String)) return;
			if (strURL == "") return;
			if (!(boolAspectRatio)) boolAspectRatio = this.__KVIDEO_PARAMS.aspectratio;
			if (!(boolDeblocking)) boolDeblocking = this.__KVIDEO_PARAMS.deblocking;
			if (!(boolSmoothing)) boolSmoothing = this.__KVIDEO_PARAMS.smoothing;
			if (isNaN(floatAlphaOut)) floatAlphaOut = this.__KFX_PARAMS.alphaout
			else if (floatAlphaOut < 0) floatAlphaOut = this.__KFX_PARAMS.alphaout
			else if (floatAlphaOut > 1) floatAlphaOut = this.__KFX_PARAMS.alphaout;
			if (!(arrayFilters is Array)) arrayFilters = this.__KFX_PARAMS.filters;
			if (isNaN(intSlowMotionPause)) intSlowMotionPause = this.__KSLOWMOTION.pause;
			if (intSlowMotionPause < 10) intSlowMotionPause = 10;
			if (isNaN(intSlowMotionPlay)) intSlowMotionPlay = this.__KSLOWMOTION.play;
			if (intSlowMotionPlay < 10) intSlowMotionPlay = 10;
			this.__KFX_PARAMS.filters = arrayFilters;
			this.__KFX_PARAMS.alphaout = floatAlphaOut;
			this.__slowmotion = { pause: new Timer(intSlowMotionPause), play: new Timer(intSlowMotionPlay) };
			this.__slowmotion.pause.addEventListener(TimerEvent.TIMER, this.__onSlowMotion);
			this.__slowmotion.play.addEventListener(TimerEvent.TIMER, this.__onSlowMotion);
			this.__status = { aspectratio: boolAspectRatio, deblocking: boolDeblocking, end: false, endstop: false, height: 0, mediaisavailable: false, repeat: true, smoothing: boolSmoothing, url: strURL, width: 0 };
			this.__media = new Video();
			this.__media.addEventListener(Event.ADDED, this.__onAdded);
			this.addChild(this.__media);
		};
		//
		//private methods...
		private function __destroytween():void {
			if (!this.__fx) return;
			try {
				this.__fx.stop();
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__fx.removeEventListener(TweenEvent.MOTION_FINISH, this.__onFxFinish);
			}
			catch (_error:Error) {
				//...
			};
			this.__fx = undefined;
		};
		private function __onAdded(event:Event):void {
			event.currentTarget.removeEventListener(Event.ADDED, this.__onAdded);
			this.__media = Video(event.currentTarget);
			//
			this.__netconnection = new NetConnection();
            this.__netconnection.addEventListener(NetStatusEvent.NET_STATUS, this.__onNetStatus);
            this.__netconnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.__onSecurityError);
			this.__netconnection.connect(null);
		};
        private function __onAsyncError(event:AsyncErrorEvent):void {
			this.dispatchEvent(new AsyncErrorEvent(AsyncErrorEvent.ASYNC_ERROR));
        };
		private function __onFxFinish(event:TweenEvent):void {
			this.__destroytween();
		};
		private function __onIoError(event:IOErrorEvent):void {
			this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		};
		private function __onMetaData(infoObject:Object):void {
			if (!this.__status) return;
			this.__netstream.onMetaData = undefined;
			var _timer:Timer = new Timer(10);
			_timer.addEventListener(TimerEvent.TIMER, this.__onTimerInit);
			_timer.start();
		};
		private function __onNetStatus(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "NetConnection.Call.BadVersion":
					this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
					break;
				case "NetConnection.Call.Failed":
					this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
					break;
				case "NetConnection.Call.Prohibited":
					this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
					break;
				case "NetConnection.Connect.Closed":
					//...
					break;
				case "NetConnection.Connect.Failed":
					this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
					break;
				case "NetConnection.Connect.Success":
					this.__netstream = new XNetStream(this.__netconnection);
					this.__netstream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.__onAsyncError);
					this.__netstream.addEventListener(IOErrorEvent.IO_ERROR, this.__onIoError);
					this.__netstream.addEventListener(NetStatusEvent.NET_STATUS, this.__onNetStatus);
					this.__netstream.onMetaData = this.__onMetaData;
					this.__media.attachNetStream(this.__netstream);
					this.__media.deblocking = this.__status.deblocking;
					this.__media.smoothing = this.__status.smoothing;
					this.__netstream.play(this.__status.url);
					break;
				case "NetConnection.Connect.Rejected":
					this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
					break;
				case "NetConnection.Connect.AppShutdown":
					this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
					break;
				case "NetConnection.Connect.InvalidApp":
					this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
					break;
				case "NetStream.Failed":
					this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
					break;
				case "NetStream.Play.Failed":
					this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
					break;
				case "NetStream.Play.Stop":
					try {
						this.__status.end = !this.__status.repeat;
						if (this.__status.repeat) this.__netstream.seek(0)
						else this.pause();
					}
					catch (_error:Error) {
						//...
					};
					break;
				case "NetStream.Play.StreamNotFound":
					this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
					break;
				case "NetStream.Publish.BadName":
					this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
					break;
				case "NetStream.Seek.Failed":
					this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
					break;
				case "NetStream.Seek.InvalidTime":
					//...
					this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
					break;
			};
		};
        private function __onSecurityError(event:SecurityErrorEvent):void {
			this.dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR));
        };
		private function __onSlowMotion(event:Event):void {
			if (++this.__count % 2 == 0) {
				this.__slowmotion.pause.reset();
				this.__slowmotion.play.start();
				try {
					if (this.__status.end) this.__netstream.seek(0);
					this.__netstream.resume();
				}
				catch (_error:Error) {
					//...
				};
			}
			else {
				this.__slowmotion.play.reset();
				this.__slowmotion.pause.start();
				this.__netstream.pause();
			};
		};
		private function __onTimerInit(event:TimerEvent):void {
			if (isNaN(this.__media.videoHeight)) return;
			if (this.__media.videoHeight <= 0) return;
			if (isNaN(this.__media.videoWidth)) return;
			if (this.__media.videoWidth <= 0) return;
			//
			event.target.stop();
			event.target.removeEventListener(TimerEvent.TIMER, this.__onTimerInit);
			//
			this.__status.mediaisavailable = true;
			this.resize(this.__status.height, this.__status.width);
		};
		//
		//properties...
		public function get context():* {
			if (!this.__netstream) return undefined;
			return this.__netstream.checkPolicyFile;
		};
		public function set context(loaderContext:*):void {
			if (!this.__netstream) return;
			if (loaderContext is Boolean) this.__netstream.checkPolicyFile = loaderContext;
		};
		public function get repeat():Boolean {
			try {
				return this.__status.repeat;
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public function set repeat(boolRepeat:Boolean):void {
			if (!this.__status) return;
			if (!(boolRepeat is Boolean)) return;
			this.__status.repeat = boolRepeat;
		};
		//
		//public methods...
		public function pause():void {
			this.__slowmotion.pause.reset();
			this.__slowmotion.play.reset();
			this.__destroytween();
			try {
				this.__netstream.pause();
			}
			catch (_error:Error) {
				//...
			};
			this.filters = this.__KFX_PARAMS.filters;
			this.__fx = new Tween(this, "alpha", this.__KFX_PARAMS.transitionout, this.alpha, this.__KFX_PARAMS.alphaout, this.__KFX_PARAMS.durationout, this.__KFX_PARAMS.useseconds);
			this.__fx.addEventListener(TweenEvent.MOTION_FINISH, this.__onFxFinish);
		};
		public function play():void {
			this.__slowmotion.pause.reset();
			this.__slowmotion.play.reset();
			this.__destroytween();
			this.filters = [];
			try {
				if (this.__status.end) this.__netstream.seek(0);
				this.__netstream.resume();
			}
			catch (_error:Error) {
				//...
			};
			this.__fx = new Tween(this, "alpha", this.__KFX_PARAMS.transitionin, this.alpha, this.__KFX_PARAMS.alphain, this.__KFX_PARAMS.durationin, this.__KFX_PARAMS.useseconds);
			this.__fx.addEventListener(TweenEvent.MOTION_FINISH, this.__onFxFinish);
		};
		public function reset():void {
			this.__slowmotion.pause.reset();
			this.__slowmotion.play.reset();
			try {
				this.__netstream.close();
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__status.url = undefined;
			}
			catch (_error:Error) {
				//...
			};
			if (this.__media is Video) this.__media.clear();
		};
		public function resize(floatHeight:Number, floatWidth:Number):void {
			if (isNaN(floatHeight)) floatHeight = this.__status.height;
			if (floatHeight < 0) floatHeight = 0;
			if (isNaN(floatWidth)) floatWidth = this.__status.width;
			if (floatWidth < 0) floatWidth = 0;
			this.__status.height = floatHeight;
			this.__status.width = floatWidth;
			if (!this.__status.mediaisavailable) return;
			if (this.__status.aspectratio) {
				var _ratio:Number = Math.max(this.__status.height / this.__media.videoHeight, this.__status.width / this.__media.videoWidth);
				this.__media.height = _ratio * this.__media.videoHeight;
				this.__media.width = _ratio * this.__media.videoWidth;
			}
			else {
				this.__media.height = this.__status.height;
				this.__media.width = this.__status.width;
			};
		};
		public function slowmotion():void {
			this.__count = 0;
			this.__slowmotion.pause.reset();
			this.__slowmotion.play.reset();
			this.__slowmotion.play.start();
		};
	};
};