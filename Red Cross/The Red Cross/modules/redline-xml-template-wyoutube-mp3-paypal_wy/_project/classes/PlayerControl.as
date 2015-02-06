/**
 * PlayerControl
 * Players Controller
 *
 * @version		1.0
 */
package _project.classes {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	//
	import _project.classes.IPlayer;
	import _project.classes.XPlayerEvent;
	//
	public class PlayerControl extends EventDispatcher {
		//constants...
		private const __DELAY:Number = 100;
		private const __MEDIAINFODIVIDER:String = ": ";
		private const __NAMES:Object = { buffer: "buffering", display: "display", mediainfo: "mediainfo", btnmute: "btnmute", btnpause: "btnpause", btnplay: "btnplay", 
										 btnrepeat: "btnrepeat", seekbar: "seekbar", btnview: "btnview", volumebar: "volumebar" };
		//private vars...
		private var __container:MovieClip;
		private var __controls:Object;
		private var __status:Object;
		private var __timer:Timer;
		//
		//constructor...
		public function PlayerControl(mcContainer:MovieClip) {
			if (!(mcContainer is MovieClip)) return;
			this.__container = mcContainer;
			this.__status = { buffering: false, mediainfo: undefined, mute: false, ready: false, repeat: false, target: undefined, volume: 0.9 };
			this.__timer = new Timer(this.__DELAY);
			this.__timer.start();
			this.__timer.addEventListener(TimerEvent.TIMER, this.__onTimer);
		};
		//
		//private methods...
		private function __addlistener(target:*, event:String, listener:Function):void {
			try {
				target.removeEventListener(event, listener);
			}
			catch (_error:Error) {
				//...
			};
			try {
				target.addEventListener(event, listener);
			}
			catch (_error:Error) {
				//...
			};
		};
		private function __mediainfo():void {
			if (!this.__status.target) return;
			if (!this.__status.target.ready) return;
			if (this.__status.mediainfo is String) return;
			//
			var target:IPlayer = this.__status.target;
			try {
				var _mediainfo:String = "";
				if (target.mediaInfo.artist is String) _mediainfo = target.mediaInfo.artist;
				if (target.mediaInfo.songName is String) _mediainfo += ((_mediainfo.length > 0) ? " - " : "") + target.mediaInfo.songName;
				if (_mediainfo.length > 0) {
					try {
						this.__container.setMediaInfo(target.mediaType + this.__MEDIAINFODIVIDER + _mediainfo);
					}
					catch (_error:Error) {
						//...
					};
				};
			}
			catch (_error:Error) {
				//...
			};
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_INFO));
		};
		private function __onMediaBufferingStart(event:XPlayerEvent):void {
			var target:IPlayer = IPlayer(event.target);
			if (target != this.__status.target) return;
			this.__status.buffering = !isNaN(target.buffering.bufferTime);
			if (!this.__status.buffering) {
				try {
					this.__container.stopBuffer();
				}
				catch (_error:Error) {
					//...
				};
			};
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_BUFFERING_START));
		};
		private function __onMediaBufferingStop(event:XPlayerEvent):void {
			this.__status.buffering = false;
			if (!this.__status.buffering) {
				try {
					this.__container.stopBuffer();
				}
				catch (_error:Error) {
					//...
				};
			};
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_BUFFERING_STOP));
		};
		private function __onMediaClick(event:XPlayerEvent):void {
			var target:IPlayer = IPlayer(event.target);
			if (target != this.__status.target) return;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_CLICK));
		};
		private function __onMediaEnd(event:XPlayerEvent):void {
			var target:IPlayer = IPlayer(event.target);
			if (target != this.__status.target) return;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_END));
		};
		private function __onMediaError(event:XPlayerEvent):void {
			var target:IPlayer = IPlayer(event.target);
			if (target != this.__status.target) return;
			//
			try {
				this.__container.setControls(target.controls);
			}
			catch (_error:Error) {
				//...
			};
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
		};
		private function __onMediaInfo(event:XPlayerEvent):void {
			var target:IPlayer = IPlayer(event.target);
			if (target != this.__status.target) return;
			//
			this.__mediainfo();
		};
		private function __onMediaReady(event:XPlayerEvent):void {
			var target:IPlayer = IPlayer(event.target);
			if (target != this.__status.target) return;
			//
			target.volume = (this.__status.mute) ? 0 : this.__status.volume;
			var _infovisible:Boolean = false;
			try {
				var _controls:Object = target.controls;
				this.__container.setControls(_controls);
				_infovisible = _controls.mediainfo;
				var _active:Boolean = false;
				for (var i in _controls) _active = _active || _controls[i];
				this.active = _active;
			}
			catch (_error:Error) {
				//...
			};
			if (_infovisible) {
				var _mediainfo:String = (this.__status.mediainfo is String && this.__status.mediainfo.length > 0) ? this.__status.mediainfo : target.mediaInfo.filename;
				try {
					this.__container.setMediaInfo(target.mediaType + ((_mediainfo.length > 0) ? this.__MEDIAINFODIVIDER : "") + _mediainfo);
				}
				catch (_error:Error) {
					//...
				};
			};
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_READY));
		};
		private function __onMediaResize(event:XPlayerEvent):void {
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_RESIZE));
		};
		private function __onMute(event:MouseEvent):void {
			this.__status.mute = !this.__status.mute;
			try {
				this.__status.target.volume = (this.__status.mute) ? 0 : this.__status.volume;
			}
			catch (_error:Error) {
				//...
			};
		};
		private function __onPause(event:MouseEvent):void {
			if (!this.__status.target) return;
			this.__status.target.pause();
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_PAUSE));
		};
		private function __onPlay(event:MouseEvent):void {
			if (!this.__status.target) return;
			this.__status.target.play();
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_PLAY));
		};
		private function __onRepeat(event:MouseEvent):void {
			this.__status.repeat = !this.__status.repeat;
			if (this.__status.target) this.__status.target.repeat = this.__status.repeat;
		};
		private function __onSeekMouseDown(event:MouseEvent):void {
			if (!this.__status.target) return;
			var target:DisplayObject;
			try {
				target = this.__controls[this.__NAMES.seekbar];
			}
			catch (_error:Error) {
				//...
			};
			if (target is MovieClip) {
				var _current:Number = (target.rotation == 0) ? target.mouseX / target.width : target.mouseX / target.height;
				if (_current > this.loaded) return;
				this.__status.target.current = _current;
				this.__addlistener(target, MouseEvent.MOUSE_MOVE, this.__onSeekMouseMove);
			};
		};
		private function __onSeekMouseMove(event:MouseEvent):void {
			if (!this.__status.target) return;
			var target:DisplayObject = this.__controls[this.__NAMES.seekbar];
			var mouseover:Boolean = true;
			var _xlimit:Number, _ylimit:Number;
			if (target.rotation == 0) {
				_xlimit = target.width;
				_ylimit = target.height;
			}
			else {
				_xlimit = target.height;
				_ylimit = target.width;
			};
			if (target.mouseX < 0) mouseover = false
			else if (target.mouseX > _xlimit) mouseover = false
			else if (target.mouseY < 0) mouseover = false
			else if (target.mouseY > _ylimit) mouseover = false;
			if (mouseover) {
				try {
					this.__status.target.current = target.mouseX / _xlimit;
				}
				catch (_error:Error) {
					//...
				};
			}
			else this.__removelistener(target, MouseEvent.MOUSE_MOVE, this.__onSeekMouseMove);
		};
		private function __onSeekMouseUp(event:MouseEvent):void {
			if (this.__status.target) this.__removelistener(this.__controls[this.__NAMES.seekbar], MouseEvent.MOUSE_MOVE, this.__onSeekMouseMove);
		};
		private function __onTimer(event:TimerEvent):void {
			if (!(this.__container.isReady is Function)) return;
			if (!this.__container.isReady()) return;
			event.target.stop();
			this.__removelistener(event.target, TimerEvent.TIMER, this.__onTimer);
			this.__controls = this.__container.getControls();
			this.__addlistener(this.__controls[this.__NAMES.btnmute], MouseEvent.CLICK, this.__onMute);
			this.__addlistener(this.__controls[this.__NAMES.btnpause], MouseEvent.CLICK, this.__onPause);
			this.__addlistener(this.__controls[this.__NAMES.btnplay], MouseEvent.CLICK, this.__onPlay);
			this.__addlistener(this.__controls[this.__NAMES.btnrepeat], MouseEvent.CLICK, this.__onRepeat);
			this.__addlistener(this.__controls[this.__NAMES.seekbar], MouseEvent.MOUSE_DOWN, this.__onSeekMouseDown);
			this.__addlistener(this.__controls[this.__NAMES.seekbar], MouseEvent.MOUSE_UP, this.__onSeekMouseUp);
			this.__addlistener(this.__controls[this.__NAMES.seekbar], MouseEvent.ROLL_OUT, this.__onSeekMouseUp);
			this.__addlistener(this.__controls[this.__NAMES.volumebar], MouseEvent.MOUSE_DOWN, this.__onVolumeMouseDown);
			this.__addlistener(this.__controls[this.__NAMES.volumebar], MouseEvent.MOUSE_UP, this.__onVolumeMouseUp);
			this.__addlistener(this.__controls[this.__NAMES.volumebar], MouseEvent.ROLL_OUT, this.__onVolumeMouseUp);
			event.target.start();
			this.__addlistener(event.target, TimerEvent.TIMER, this.__onUpdate);
			this.__status.ready = true;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.INIT));
		};
		private function __onUpdate(event:TimerEvent):void {
			if (!this.__status.ready) return;
			if (!this.__status.target) return;
			if (!this.__status.target.ready) return;
			if (this.__status.buffering) {
				try {
					var _buffering:Object = this.__status.target.buffering;
					this.__container.setBuffer((isNaN(_buffering.bufferLength)) ? _buffering.bufferTime + "s" : 100 * _buffering.bufferLength / _buffering.bufferTime);
				}
				catch (_error:Error) {
					//...
				};
			};
			try {
				this.__container.setCurrent(this.__status.target.current);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__container.setLoaded(this.__status.target.loaded);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__container.setMute(this.__status.mute);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__container.setPlay(this.__status.target.playing);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__container.setRepeat(this.__status.repeat);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__container.setTimeTotal(this.__status.target.duration);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__container.setTimeElapsed(this.__status.target.time);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__container.setVolume((this.__status.mute) ? 0 : this.__status.volume);
			}
			catch (_error:Error) {
				//...
			};
		};
		private function __onVolumeMouseDown(event:MouseEvent):void {
			if (!this.__status.target) return;
			var target:DisplayObject;
			try {
				target = this.__controls[this.__NAMES.volumebar];
			}
			catch (_error:Error) {
				//...
			};
			if (target is MovieClip) {
				this.__status.mute = false;
				this.__status.target.volume = this.__status.volume = (target.rotation == 0) ? target.mouseX / target.width : target.mouseX / target.height;
				this.__addlistener(target, MouseEvent.MOUSE_MOVE, this.__onVolumeMouseMove);
			};
		};
		private function __onVolumeMouseMove(event:MouseEvent):void {
			if (!this.__status.target) return;
			var target:DisplayObject = this.__controls[this.__NAMES.volumebar];
			var mouseover:Boolean = true;
			var _xlimit:Number, _ylimit:Number;
			if (target.rotation == 0) {
				_xlimit = target.width;
				_ylimit = target.height;
			}
			else {
				_xlimit = target.height;
				_ylimit = target.width;
			};
			if (target.mouseX < 0) mouseover = false
			else if (target.mouseX > _xlimit) mouseover = false
			else if (target.mouseY < 0) mouseover = false
			else if (target.mouseY > _ylimit) mouseover = false;
			if (mouseover) {
				try {
					this.__status.target.volume = this.__status.volume = target.mouseX / _xlimit;
				}
				catch (_error:Error) {
					//...
				};
			}
			else this.__removelistener(target, MouseEvent.MOUSE_MOVE, this.__onVolumeMouseMove);
		};
		private function __onVolumeMouseUp(event:MouseEvent):void {
			if (!this.__status.target) return;
			this.__removelistener(this.__controls[this.__NAMES.volumebar], MouseEvent.MOUSE_MOVE, this.__onVolumeMouseMove);
		};
		private function __removelistener(target:*, event:String, listener:Function):void {
			try {
				target.removeEventListener(event, listener);
			}
			catch (_error:Error) {
				//...
			};
		};
		//
		//properties...
		public function get active():Boolean {
			if (!this.__status.ready) return undefined;
			try {
				return this.__container.getActive();
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public function set active(boolActive:Boolean):void {
			if (!this.__status.ready) return;
			if (!(boolActive is Boolean)) return;
			try {
				this.__container.setActive(boolActive);
			}
			catch (_error:Error) {
				//...
			};
		};
		public function get alpha():Number {
			if (!this.__status.ready) return undefined;
			return this.__container.alpha;
		};
		public function set alpha(floatAlpha:Number):void {
			if (!this.__status.ready) return;
			if (isNaN(floatAlpha)) return;
			if (floatAlpha < 0) return;
			if (floatAlpha > 1) return;
			this.__container.alpha = floatAlpha;
		};
		public function get autoStart():Boolean {
			if (!this.__status.target) return undefined;
			return this.__status.target.autoStart;
		};
		public function get background():Boolean {
			try {
				return this.__container.getBackground();
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public function set background(boolBackground:Boolean):void {
			if (!this.__container) return;
			try {
				this.__container.setBackground(boolBackground);
			}
			catch (_error:Error) {
				//...
			};
		};
		public function get container():MovieClip {
			return this.__container;
		};
		public function get current():Number {
			if (!this.__status.target) return undefined;
			try {
				return this.__container.getCurrent();
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public function set current(floatCurrent:Number):void {
			if (!this.__status.target) return;
			try {
				this.__container.setCurrent(floatCurrent);
			}
			catch (_error:Error) {
				//...
			};
		};
		public function get duration():Number {
			if (!this.__status.target) return undefined;
			return this.__status.target.duration;
		};
		public function get height():Number {
			if (!this.__status.ready) return undefined;
			return this.__container.height;
		};
		public function get loaded():Number {
			if (!this.__status.ready) return undefined;
			try {
				return this.__container.getLoaded();
			}
			catch (_error:Error) {
				//...
			};
			return 0;
		};
		public function set loaded(floatLoaded:Number):void {
			if (!this.__status.target) return;
			try {
				this.__container.setLoaded(floatLoaded);
			}
			catch (_error:Error) {
				//...
			};
		};
		public function get mediaInfo():String {
			if (!this.__status.ready) return undefined;
			return this.__status.mediainfo;
		};
		public function set mediaInfo(strMediaInfo:String):void {
			if (!this.__status.ready) return;
			if (!(strMediaInfo is String)) return;
			this.__status.mediainfo = strMediaInfo;
			try {
				this.__container.setMediaInfo(this.__status.target.mediaType + ((strMediaInfo.length > 0) ? this.__MEDIAINFODIVIDER + strMediaInfo : ""));
			}
			catch (_error:Error) {
				//...
			};
		};
		public function get mediaMetrics():Object {
			if (!this.__status.ready) return undefined;
			if (!this.__status.target) return undefined;
			var _mediametrics:Object = this.__status.target.mediaMetrics;
			try {
				_mediametrics.wallpaperX += this.__status.target.x;
			}
			catch (_error:Error) {
				//...
			};
			try {
				_mediametrics.wallpaperY += this.__status.target.y;
			}
			catch (_error:Error) {
				//...
			};
			try {
				_mediametrics.x += this.__status.target.x;
			}
			catch (_error:Error) {
				//...
			};
			try {
				_mediametrics.y += this.__status.target.y;
			}
			catch (_error:Error) {
				//...
			};
			return _mediametrics;
		};
		public function get mute():Boolean {
			if (!this.__status.ready) return undefined;
			return this.__status.mute;
		};
		public function set mute(boolMute:Boolean):void {
			if (!this.__status.ready) return;
			if (!(boolMute is Boolean)) return;
			this.__status.mute = boolMute;
			try {
				this.__status.target.volume = (boolMute) ? 0 : this.__status.volume;
			}
			catch (_error:Error) {
				//...
			};
		};
		public function get playing():Boolean {
			if (!this.__status.target) return undefined;
			return this.__status.target.playing;
		};
		public function get ready():Boolean {
			return this.__status.ready;
		};
		public function get repeat():Boolean {
			if (!this.__status.ready) return false;
			return this.__status.repeat;
		};
		public function set repeat(boolRepeat:Boolean):void {
			if (!this.__status.ready) return;
			if (typeof(boolRepeat) != "boolean") return;
			this.__status.repeat = boolRepeat;
			try {
				this.__container.setRepeat(boolRepeat);
			}
			catch (_error:Error) {
				//...
			};
		};
		public function get rotation():Number {
			if (!this.__status.ready) return undefined;
			return this.__container.rotation;
		};
		public function set rotation(floatRotation:Number):void {
			if (!this.__status.ready) return;
			if (isNaN(floatRotation)) return;
			this.__container.rotation = floatRotation;
		};
		public function get snapshot():Object {
			try {
				return this.__status.target.snapshot;
			}
			catch (_error:Error) {
				//...
			};
			return { bitmapdata: undefined, x: 0, y: 0 };
		};
		public function get source():Object {
			if (!this.__status.target) return undefined;
			if (!(this.__status.target.mediaInfo.url is String)) return undefined;
			var _source:Object = { url: this.__status.target.mediaInfo.url };
			_source.filename = _source.url.substr(_source.url.substring(0, _source.url.lastIndexOf("/") + 1).length);
			var dot:Number = _source.filename.lastIndexOf(".");
			if (dot < 0) dot = _source.filename.length;
			_source.folder = _source.url.substr(0, _source.url.length - _source.filename.length - ((_source.filename.length < _source.url.length) ? 1 : 0));
			_source.name = _source.filename.substr(0, dot);
			_source.extension = _source.filename.substr(dot + 1);
			return _source;
		};
		public function get target():IPlayer {
			if (!this.__status.ready) return undefined;
			return this.__status.target;
		};
		public function set target(objTarget:IPlayer):void {
			if (!this.__status.ready) return;
			this.__status.mediainfo = undefined;
			if (this.__status.target) {
				this.__removelistener(objTarget, XPlayerEvent.MEDIA_BUFFERING_START, this.__onMediaBufferingStart);
				this.__removelistener(objTarget, XPlayerEvent.MEDIA_BUFFERING_STOP, this.__onMediaBufferingStop);
				this.__removelistener(objTarget, XPlayerEvent.MEDIA_CLICK, this.__onMediaClick);
				this.__removelistener(objTarget, XPlayerEvent.MEDIA_END, this.__onMediaEnd);
				this.__removelistener(objTarget, XPlayerEvent.MEDIA_ERROR, this.__onMediaError);
				this.__removelistener(objTarget, XPlayerEvent.MEDIA_INFO, this.__onMediaInfo);
				this.__removelistener(objTarget, XPlayerEvent.MEDIA_READY, this.__onMediaReady);
				this.__removelistener(objTarget, XPlayerEvent.MEDIA_RESIZE, this.__onMediaResize);
				this.__status.target.reset();
			};
			if (objTarget is IPlayer) {
				this.__status.target = objTarget;
				try {
					this.__container.setMediaInfo("");
				}
				catch (_error:Error) {
					//...
				};
				try {
					this.__container.setControls(objTarget.controls);
				}
				catch (_error:Error) {
					//...
				};
				try {
					this.__status.target.repeat = this.__status.repeat;
				}
				catch (_error:Error) {
					//...
				};
				this.__addlistener(objTarget, XPlayerEvent.MEDIA_BUFFERING_START, this.__onMediaBufferingStart);
				this.__addlistener(objTarget, XPlayerEvent.MEDIA_BUFFERING_STOP, this.__onMediaBufferingStop);
				this.__addlistener(objTarget, XPlayerEvent.MEDIA_CLICK, this.__onMediaClick);
				this.__addlistener(objTarget, XPlayerEvent.MEDIA_ERROR, this.__onMediaError);
				this.__addlistener(objTarget, XPlayerEvent.MEDIA_INFO, this.__onMediaInfo);
				this.__addlistener(objTarget, XPlayerEvent.MEDIA_READY, this.__onMediaReady);
				this.__addlistener(objTarget, XPlayerEvent.MEDIA_RESIZE, this.__onMediaResize);
				var _mediainfo:Object;
				try {
					_mediainfo = objTarget.mediaInfo;
				}
				catch (_error:Error) {
					//...
				};
				if (_mediainfo) this.__mediainfo();
				var _mediaend:Boolean = false;
				try {
					_mediaend = objTarget.mediaEnd;
				}
				catch (_error:Error) {
					//...
				};
				if (!_mediaend) this.__addlistener(objTarget, XPlayerEvent.MEDIA_END, this.__onMediaEnd)
				else this.__onMediaEnd(this.__status.target);
				//
				objTarget.volume = this.__status.volume;
			}
			else {
				delete this.__status.target;
				var _controls:Object = { };
				for (var j in this.__controls) _controls[j] = false;
				try {
					this.__container.setControls(_controls);
				}
				catch (_error:Error) {
					//...
				};
			};
		};
		public function get time():Number {
			if (!this.__status.ready) return undefined;
			if (!this.__status.target) return undefined;
			return this.__status.target.time;
		};
		public function set time(floatTime:Number):void {
			if (!this.__status.target) return;
			try {
				this.__container.setTimeElapsed(floatTime);
			}
			catch (_error:Error) {
				//...
			};
		};
		public function get visible():Boolean {
			if (!this.__status.ready) return false;
			return this.__container.visible;
		};
		public function set visible(boolVisible:Boolean):void {
			if (!this.__status.ready) return;
			if (typeof(boolVisible) != "boolean") return;
			this.__container.visible = boolVisible;
		};
		public function get volume():Number {
			return this.__status.volume;
		};
		public function set volume(floatVolume:Number):void {
			if (!this.__status.ready) return;
			if (isNaN(floatVolume)) return;
			if (floatVolume < 0) floatVolume = 0;
			if (floatVolume > 1) floatVolume = 1;
			this.__status.volume = floatVolume;
			this.__status.mute = (floatVolume <= 0);
		};
		public function get width():Number {
			if (!this.__status.ready) return undefined;
			return this.__container.width;
		};
		public function get x():Number {
			if (!this.__status.ready) return undefined;
			return this.__container.x;
		};
		public function set x(floatX:Number):void {
			if (!this.__status.ready) return;
			if (isNaN(floatX)) return;
			this.__container.x = floatX;
		};
		public function get y():Number {
			if (!this.__status.ready) return undefined;
			return this.__container.y;
		};
		public function set y(floatY:Number):void {
			if (!this.__status.ready) return;
			if (isNaN(floatY)) return;
			this.__container.y = floatY;
		};
		//
		//public methods...
		public function pause():void {
			if (!this.__status.ready) return;
			if (!this.__status.target) return;
			this.__status.target.pause();
			try {
				this.__container.setPlay(false);
			}
			catch (_error:Error) {
				//...
			};
		};
		public function play():void {
			if (!this.__status.ready) return;
			if (!this.__status.target) return;
			this.__status.target.play();
			try {
				this.__container.setPlay(true);
			}
			catch (_error:Error) {
				//...
			};
		};
	};
};