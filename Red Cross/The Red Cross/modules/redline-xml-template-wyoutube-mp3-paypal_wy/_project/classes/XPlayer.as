/**
 * XPlayer
 * Extended Multimedia Player
 *
 * @version		3.0
 */
package _project.classes	{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundLoaderContext;
	import flash.utils.Timer;
	//
	import _project.classes.AudioPlayer;
	import _project.classes.IPlayer;
	import _project.classes.ITransition;
	import _project.classes.XPlayerEvent;
	import _project.classes.SpectrumPlayer;
	import _project.classes.SwfPlayer;
	import _project.classes.VideoPlayer;
	//
	public class XPlayer extends Sprite {
		//constants...
		private const __KALIGN:Array = [ { id: "", x: 0.5, y: 0.5 }, { id: "T", x: 0.5, y: 0 }, { id: "B", x: 0.5, y: 1 }, { id: "L", x: 0, y: 0.5 }, { id: "R", x: 1, y: 0.5 }, 
										{ id: "TL", x: 0, y: 0 }, { id: "TR", x: 1, y: 0 }, { id: "BL", x: 0, y: 1 }, { id: "BR", x: 1, y: 1 } ];
		private const __KALIGN_INDEX:Number = 8;
		private const __KPLAYERCONTROL_OFFSET:Object = { fullscrn: 0, normalscrn: 0 };
		private const __KUPDATES:Object = { ambientvolume: undefined, audiobuffer: undefined, autoplaytimer: 15, videobuffer: undefined, volume: undefined };
		//private vars...
		private var __ambient:AudioPlayer;
		private var __ambientcontrol:PlayerControl;
		private var __ambientplaylist:Object;
		private var __crtoffset:Object;
		private var __players:Object;
		private var __playercontrol:PlayerControl;
		private var __playercontroloffset:Number = 0;
		private var __status:Object;
		private var __transition:ITransition;
		//
		//constructor...
		public function XPlayer(mcPlayerControl:MovieClip, mcAmbientControl:MovieClip = undefined, objTransition:ITransition = undefined, 
								mcSpectrumCursor:MovieClip = undefined, fSwfCursor:Function = undefined, fVideoCursor:Function = undefined, 
								bdSpectrumLogo:BitmapData = undefined, bdSwfLogo:BitmapData = undefined, bdVideoLogo:BitmapData = undefined, 
								objPadding:Object = undefined, floatPlayerControlOffset:Number = undefined, 
								objBkg:Object = undefined, objVignetting:Object = undefined, objBorder:Object = undefined, objSpectrumColors:Object = undefined, 
								objAlign:Object = undefined, objURLDecoders:Object = undefined) {
			if (!(mcPlayerControl is MovieClip)) return;
			if (!objBkg) objBkg = { };
			if (!objAlign) objAlign = { }
			else if (objAlign is String) objAlign = { spectrum: objAlign, swf: objAlign, video: objAlign };
			this.__status = { align: this.__KALIGN[this.__KALIGN_INDEX], alignplayercontrol: false, ambient: true, height: 0, hq: false, mediainfo: undefined, 
							  padding: { audio: { bottom: 0, left: 0, right: 0, top: 0 }, reset: false, spectrum: { bottom: 0, left: 0, right: 0, top: 0 }, swf: { bottom: 0, left: 0, right: 0, top: 0 }, video: { bottom: 0, left: 0, right: 0, top: 0 } }, ready: false, ttl: 10, width: 0, url: undefined };
			if (objPadding) {
				for (var i in this.__status.padding) {
					if (!objPadding[i]) continue;
					for (var x in this.__status.padding[i]) {
						if (!isNaN(objPadding[i][x])) this.__status.padding[i][x] = objPadding[i][x];
					};
				};
			};
			this.__playercontroloffset = (isNaN(floatPlayerControlOffset)) ? this.__KPLAYERCONTROL_OFFSET.normalscrn : floatPlayerControlOffset;
			var _vignetting:Object = { spectrum: undefined, swf: undefined, video: undefined };
			for (var j in _vignetting) {
				try {
					_vignetting[j] = objVignetting[j];
				}
				catch (_error:Error) {
					//...
				};
			};
			var _border:Object = { spectrum: undefined, swf: undefined, video: undefined };
			for (var k in _border) {
				try {
					_border[k] = objBorder[k];
				}
				catch (_error:Error) {
					//...
				};
			};
			var _urldecoders:Object = { audio: undefined, swf: undefined, video: undefined };
			for (var l in _urldecoders) {
				try {
					_urldecoders[l] = objURLDecoders[l];
				}
				catch (_error:Error) {
					//...
				};
			};
			//
			if (objTransition is ITransition) this.__transition = objTransition;
			this.__crtoffset = { };
			for (var m in this.__status.padding) this.__crtoffset[m] = this.__status.padding[m];
			this.__ambient = new AudioPlayer(true);
			this.__ambient.addEventListener(XPlayerEvent.MEDIA_END, this.__onAmbientMediaEnd);
			this.__ambient.addEventListener(XPlayerEvent.MEDIA_ERROR, this.__onAmbientMediaError);
			this.__ambient.addEventListener(XPlayerEvent.MEDIA_INFO, this.__onAmbientMediaInfo);
			this.__ambient.addEventListener(XPlayerEvent.MEDIA_READY, this.__onAmbientMediaReady);
			this.__ambientplaylist = { index: 0, list: [ ] };
			this.__players = { audio: new AudioPlayer(false, _urldecoders.audio), 
							   spectrum: SpectrumPlayer(this.addChild(new SpectrumPlayer(mcSpectrumCursor, objBkg.spectrum, _vignetting.spectrum, _border.spectrum, bdSpectrumLogo, objSpectrumColors))), 
							   swf: SwfPlayer(this.addChild(new SwfPlayer(fSwfCursor, objBkg.swf, _vignetting.swf, _border.swf, bdSwfLogo, _urldecoders.swf ))), 
							   video: VideoPlayer(this.addChild(new VideoPlayer(fVideoCursor, objBkg.video, _vignetting.video, _border.video, bdVideoLogo, _urldecoders.video))) };
			for (var p in this.__players) this.__players[p].visible = false;
			this.__players.spectrum.align = objAlign.spectrum;
			this.__players.swf.align = objAlign.swf;
			this.__players.video.align = objAlign.video;
			this.__players.spectrum.addEventListener(XPlayerEvent.MEDIA_CLICK, this.__onMediaClickSpectrum);
			this.__players.spectrum.addEventListener(XPlayerEvent.MEDIA_RESIZE, this.__onMediaResizeSpectrum);
			if (mcAmbientControl is MovieClip) {
				this.__ambientcontrol = new PlayerControl(MovieClip(this.addChild(mcAmbientControl)));
				this.__ambientcontrol.addEventListener(XPlayerEvent.MEDIA_PAUSE, this.__onAmbientMediaPause);
				this.__ambientcontrol.addEventListener(XPlayerEvent.MEDIA_PLAY, this.__onAmbientMediaPlay);
			};
			this.__playercontrol = new PlayerControl(MovieClip(this.addChild(mcPlayerControl)));
			this.__playercontrol.addEventListener(XPlayerEvent.MEDIA_CLICK, this.__onMediaClick);
			this.__playercontrol.addEventListener(XPlayerEvent.MEDIA_BUFFERING_START, this.__onMediaBufferingStart);
			this.__playercontrol.addEventListener(XPlayerEvent.MEDIA_BUFFERING_STOP, this.__onMediaBufferingStop);
			this.__playercontrol.addEventListener(XPlayerEvent.MEDIA_END, this.__onMediaEnd);
			this.__playercontrol.addEventListener(XPlayerEvent.MEDIA_ERROR, this.__onMediaError);
			this.__playercontrol.addEventListener(XPlayerEvent.MEDIA_INFO, this.__onMediaInfo);
			this.__playercontrol.addEventListener(XPlayerEvent.MEDIA_READY, this.__onMediaReady);
			this.__playercontrol.addEventListener(XPlayerEvent.MEDIA_RESIZE, this.__onMediaResize);
			var _timer:Timer = new Timer(10);
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, this.__onTimer);
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
			target.addEventListener(event, listener);
		};
		private function __align():void {
			if (!this.__playercontrol.target) return;
			var _mediametrics:Object = this.__playercontrol.mediaMetrics;
			if (!_mediametrics) return;
			try {
				this.__playercontrol.background = (this.__playercontrol.height > _mediametrics.borderThick - 2 * this.__playercontroloffset);
			}
			catch (_error:Error) {
				//...
			};
			var finalX:Number, finalY:Number;
			if (this.__status.alignplayercontrol) {
				var _border:Number = _mediametrics.borderOffset + _mediametrics.borderThick;
				if (_border < 0) _border = 0;
				var x1:Number = _mediametrics.x - _border + this.__playercontroloffset;
				var x2:Number = x1 + _mediametrics.width + 2 * _border - 2 * this.__playercontroloffset;
				var y1:Number = _mediametrics.y - _border + this.__playercontroloffset;
				var y2:Number = y1 + _mediametrics.height + 2 * _border - 2 * this.__playercontroloffset;
				if (_mediametrics.wallpaperWidth > 0) {
					x1 = Math.min(_mediametrics.wallpaperX + this.__playercontroloffset, x1);
					x2 = Math.max(_mediametrics.wallpaperX + _mediametrics.wallpaperWidth - this.__playercontroloffset, x2);
					y1 = Math.min(_mediametrics.wallpaperY + this.__playercontroloffset, y1);
					y2 = Math.max(_mediametrics.wallpaperY + _mediametrics.wallpaperHeight - this.__playercontroloffset, y2);
				};
				finalX = x1 + this.__status.align.x * (x2 - x1 - this.__playercontrol.width);
				finalY = y1 + this.__status.align.y * (y2 - y1 - this.__playercontrol.height);
			}
			else {
				finalX = this.__status.align.x * (this.__status.width - this.__playercontrol.width) - this.__playercontroloffset;
				finalY = this.__status.align.y * (this.__status.height - this.__playercontrol.height) - this.__playercontroloffset;
			};
			if (finalX + this.__playercontrol.width > this.__status.width) finalX = this.__status.width - this.__playercontrol.width - this.__KPLAYERCONTROL_OFFSET.fullscrn;
			if (finalX < 0) finalX = this.__KPLAYERCONTROL_OFFSET.fullscrn;
			if (finalY + this.__playercontrol.height > this.__status.height) finalY = this.__status.height - this.__playercontrol.height - this.__KPLAYERCONTROL_OFFSET.fullscrn;
			if (finalY < 0) finalY = this.__KPLAYERCONTROL_OFFSET.fullscrn;
			this.__playercontrol.x = finalX;
			this.__playercontrol.y = finalY;
		};
		private function __ambientload():void {
			if (this.__ambientplaylist.list.length < 1) this.__ambientcontrol.container.visible = false
			else {
				this.__ambientcontrol.container.visible = true;
				this.__ambientcontrol.active = true;
				if (this.__ambientplaylist.list.length == 1) {
					this.__ambientcontrol.container.getNext().visible = false;
					this.__ambientcontrol.container.getPrevious().visible = false;
				};
				if (this.__ambientplaylist.index >= this.__ambientplaylist.list.length) this.__ambientplaylist.index = this.__ambientplaylist.list.length - 1;
				try {
					this.__ambient.load(this.__ambientplaylist.list[this.__ambientplaylist.index]);
				}
				catch (_error:Error) {
					//...
				};
			};
		};
		private function __load(strURL:String, boolHighQuality:Boolean = false):IPlayer {
			for (var i in this.__players) {
				if (this.__players[i].iscompatible(strURL)) {
					this.__playercontrol.target = undefined;
					this.__players[i].load(strURL, boolHighQuality);
					return this.__players[i];
				};
			};
			return undefined;
		};
		private function __mediaclick(target:IPlayer):void {
			for (var i in this.__players) {
				if (target == this.__players[i]) {
					target.wallpaper = !target.wallpaper;
					this.__crtoffset[i] = (target.wallpaper) ? { bottom: 0, left: 0, right: 0, top: 0 } : this.__status.padding[i];
					target.x = this.__crtoffset[i].left;
					target.y = this.__crtoffset[i].top;
					target.height = this.__status.height - this.__crtoffset[i].bottom - this.__crtoffset[i].top;
					target.width = this.__status.width - this.__crtoffset[i].left - this.__crtoffset[i].right;
					this.__align();
					break;
				};
			};
		};
		private function __mediaresize(target:IPlayer):void {
			for (var i in this.__players) {
				if (target == this.__players[i]) {
					this.__transition.resize();
					break;
				};
			};
		};
		private function __onAmbientMediaEnd(event:XPlayerEvent = undefined):void {
			this.__ambientplaylist.index++;
			if (this.__ambientplaylist.index >= this.__ambientplaylist.list.length) this.__ambientplaylist.index = 0;
			this.__ambient.load(this.__ambientplaylist.list[this.__ambientplaylist.index]);
		};
		private function __onAmbientMediaError(event:XPlayerEvent):void {
			if (this.__ambientplaylist.list.length < 1) return;
			try {
				this.__ambientplaylist.list.splice(this.__ambientplaylist.index, 1);
			}
			catch (_error:Error) {
				//...
			};
			this.__ambientload();
		};
		private function __onAmbientMediaInfo(event:XPlayerEvent):void {
			//...
		};
		private function __onAmbientMediaPause(event:XPlayerEvent):void {
			this.__status.ambient = false;
		};
		private function __onAmbientMediaPlay(event:XPlayerEvent):void {
			this.__ambient.autoStart = true;
			this.__status.ambient = true;
		};
		private function __onAmbientMediaReady(event:XPlayerEvent):void {
			try {
				if (this.__ambientcontrol.target != this.__ambient) this.__ambientcontrol.target = this.__ambient;
			}
			catch (_error:Error) {
				//...
			};
		};
		private function __onAmbientNext(event:MouseEvent):void {
			if (this.__ambientplaylist.list.length < 1) return;
			this.__ambientplaylist.index++;
			if (this.__ambientplaylist.index >= this.__ambientplaylist.list.length) this.__ambientplaylist.index = 0;
			this.__ambientload();
		};
		private function __onAmbientPrevious(event:MouseEvent):void {
			if (this.__ambientplaylist.list.length < 1) return;
			this.__ambientplaylist.index--;
			if (this.__ambientplaylist.index < 0) this.__ambientplaylist.index = this.__ambientplaylist.list.length - 1;
			this.__ambientload();
		};
		private function __onAmbientTimer(event:TimerEvent):void {
			if (!this.__ambient.ready) return;
			event.target.stop();
			event.target.removeEventListener(TimerEvent.TIMER, this.__onAmbientTimer);
			if (!(this.__ambientplaylist.list is Array)) return;
			this.__ambient.reset();
			this.__ambientload();
		};
		private function __onMediaBufferingStart(event:XPlayerEvent):void {
			if (this.__status.reset) return;
			//
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_BUFFERING_START));
		};
		private function __onMediaBufferingStop(event:XPlayerEvent):void {
			if (this.__status.reset) return;
			//
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_BUFFERING_STOP));
		};
		private function __onMediaClick(event:XPlayerEvent):void {
			if (this.__status.reset) return;
			//
			this.__mediaclick(IPlayer(event.target.target));
		};
		private function __onMediaClickSpectrum(event:XPlayerEvent):void {
			if (this.__status.reset) return;
			//
		};
		private function __onMediaEnd(event:XPlayerEvent):void {
			if (this.__status.reset) return;
			//
			var target:IPlayer = IPlayer(event.target.target);
			for (var i in this.__players) {
				if (target == this.__players[i]) {
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_END));
					break;
				};
			};
		};
		private function __onMediaError(event:XPlayerEvent):void {
			if (this.__status.reset) return;
			//
			var target:IPlayer = IPlayer(event.target.target);
			for (var i in this.__players) {
				if (target == this.__players[i]) {
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
					break;
				};
			};
		};
		private function __onMediaInfo(event:XPlayerEvent):void {
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_INFO));
		};
		private function __onMediaReady(event:XPlayerEvent):void {
			if (this.__status.reset) return;
			//
			var target:IPlayer = IPlayer(event.target.target);
			for (var i in this.__players) {
				if (target == this.__players[i]) {
					this.__crtoffset[i] = (target.wallpaper) ? { bottom: 0, left: 0, right: 0, top: 0 } : this.__status.padding[i];
					target.x = this.__crtoffset[i].left;
					target.y = this.__crtoffset[i].top;
					target.height = this.__status.height - this.__crtoffset[i].bottom - this.__crtoffset[i].top;
					target.width = this.__status.width - this.__crtoffset[i].left - this.__crtoffset[i].right;
					var _target:IPlayer = (target == this.__players.audio) ? target.plugin : target;
					this.__addlistener(this.__transition, Event.CLOSE, this.__onTransitionClose);
					this.__addlistener(this.__transition, Event.OPEN, this.__onTransitionOpen);
					if (!this.__transition.intro(DisplayObject(_target))) {
						this.__removelistener(this.__transition, Event.CLOSE, this.__onTransitionClose);
						this.__removelistener(this.__transition, Event.OPEN, this.__onTransitionOpen);
						this.__onTransitionOpen();
					};
					this.__align();
					if (this.__ambient.autoStart && this.__playercontrol.target == target) {
						if (target != this.__players.swf || target.mediaType.toLowerCase() == "application/x-shockwave-flash") this.__ambient.pause()
						else if (this.__status.ambient) this.__ambient.play();
					};
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_READY));
					break;
				};
			};
		};
		private function __onMediaResize(event:XPlayerEvent):void {
			this.__mediaresize(IPlayer(event.target.target));
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_RESIZE));
		};
		private function __onMediaResizeSpectrum(event:XPlayerEvent):void {
			this.__mediaresize(IPlayer(event.target));
		};
		private function __onTimer(event:TimerEvent):void {
			if (!this.__ambient.ready) return;
			if (this.__ambientcontrol is PlayerControl) {
				if (!this.__ambientcontrol.ready) return;
			};
			if (!this.__playercontrol.ready) return;
			if (!this.__players.audio.ready) return;
			if (!this.__players.spectrum.ready) return;
			if (!this.__players.swf.ready) return;
			if (!this.__players.video.ready) return;
			event.target.stop();
			event.target.removeEventListener(TimerEvent.TIMER, this.__onTimer);
			if (this.__ambientcontrol.container.getNext is Function) {
				if (this.__ambientcontrol.container.getNext() is MovieClip) this.__ambientcontrol.container.getNext().addEventListener(MouseEvent.CLICK, this.__onAmbientNext);
			};
			if (this.__ambientcontrol.container.getPrevious is Function) {
				if (this.__ambientcontrol.container.getPrevious() is MovieClip) this.__ambientcontrol.container.getPrevious().addEventListener(MouseEvent.CLICK, this.__onAmbientPrevious);
			};
			if (this.__ambientplaylist.list is Array) {
				if (this.__ambientplaylist.list.length > 0) {
					this.__ambientcontrol.visible = true;
					this.__ambient.load(this.__ambientplaylist.list[this.__ambientplaylist.index])
				}
				else this.__ambientcontrol.visible = false;
			}
			else this.__ambientcontrol.visible = false;
			this.__players.audio.plugin = this.__players.spectrum;
			this.__playercontrol.visible = false;
			//
			this.__status.ready = true;
			if (!isNaN(this.__KUPDATES.ambientvolume)) this.ambientVolume = this.__KUPDATES.ambientvolume;
			if (!isNaN(this.__KUPDATES.audiobuffer)) this.audioBuffer = this.__KUPDATES.audiobuffer;
			try {
				this.__players.swf.ttl = this.__KUPDATES.autoplaytimer;
			}
			catch (_error:Error) {
				//...
			};
			if (!isNaN(this.__KUPDATES.videobuffer)) this.videoBuffer = this.__KUPDATES.videobuffer;
			if (!isNaN(this.__KUPDATES.volume)) this.volume = this.__KUPDATES.volume;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.INIT));
		};
		private function __onTransitionOpen(event:Event = undefined):void {
			this.__removelistener(this.__status.target, Event.CLOSE, this.__onTransitionClose);
			this.__removelistener(this.__status.target, Event.OPEN, this.__onTransitionOpen);
		};
		private function __onTransitionClose(event:Event = undefined):void {
			this.__removelistener(this.__status.target, Event.CLOSE, this.__onTransitionClose);
			this.__removelistener(this.__status.target, Event.OPEN, this.__onTransitionOpen);
			var target:IPlayer = (this.__playercontrol.target == this.__players.audio) ? this.__playercontrol.target.plugin : this.__playercontrol.target;
			if (target is IPlayer) target.reset();
			if ((this.__status.url is String) && !this.__status.reset) {
				this.__playercontrol.target = this.__load(this.__status.url, this.__status.hq);
				if (this.__playercontrol.target == this.__players.audio) {
					this.__players.audio.plugin = this.__players.spectrum;
					this.__players.spectrum.load("");
				};
				this.__playercontrol.mediaInfo = this.__status.mediainfo;
				if (this.__ambient.autoStart) {
					if (this.__playercontrol.target != this.__players.swf || this.__playercontrol.target.mediaType.toLowerCase() == "application/x-shockwave-flash") this.__ambient.pause()
					else if (this.__status.ambient) this.__ambient.play();
				};
				this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_LOADING));
			}
			else {
				this.__status.reset = false;
				try {
					this.__playercontrol.target.reset();
				}
				catch (_error:Error) {
					//...
				};
			};
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
		public function get ambientAutoStart():Boolean {
			try {
				return this.__ambient.autoStart;
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public function set ambientAutoStart(boolAutostart:Boolean):void {
			if (!(boolAutostart is Boolean)) return;
			try {
				this.__ambient.autoStart = boolAutostart;
			}
			catch (_error:Error) {
				//...
			};
		};
		public function get ambientControl():MovieClip {
			try {
				return this.__ambientcontrol.container;
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public function get ambientPlaying():Boolean {
			return this.__ambientcontrol.playing;
		};
		public function get ambientPlaylist():Array {
			return this.__ambientplaylist.list;
		};
		public function set ambientPlaylist(arrayPlaylist:Array):void {
			if (!(arrayPlaylist is Array)) arrayPlaylist = [];
			this.__ambientplaylist.index = 0;
			this.__ambientplaylist.list = [];
			for (var i:int = 0; i < arrayPlaylist.length; i++) {
				if (!(arrayPlaylist[i] is String)) continue;
				if (arrayPlaylist[i] == "") continue;
				this.__ambientplaylist.list.push(arrayPlaylist[i]);
			};
			if (this.__ambient.ready) {
				this.__ambient.reset();
				this.__ambientload();
			}
			else {
				var _timer:Timer = new Timer(10);
				_timer.addEventListener(TimerEvent.TIMER, this.__onAmbientTimer);
				_timer.start();
			};
		};
		public function get ambientVolume():Number {
			try {
				return 100 * this.__ambientcontrol.volume;
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public function set ambientVolume(floatVolume:Number):void {
			if (isNaN(floatVolume)) return;
			if (floatVolume < 0) return;
			if (floatVolume > 100) return;
			if (this.__status.ready) {
				try {
					this.__ambientcontrol.volume = 0.01 * floatVolume;
				}
				catch (_error:Error) {
					//...
				};
			}
			else this.__KUPDATES.ambientvolume = floatVolume;
		};
		public function get audioBuffer():Number {
			try {
				return this.__players.audio.bufferTime;
			}
			catch (_error:Error) {
				//...
			};
			try {
				return this.__ambient.bufferTime;
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public function set audioBuffer(floatBuffer:Number):void {
			if (isNaN(floatBuffer)) return;
			if (floatBuffer < 0) return;
			if (this.__status.ready) {
				try {
					this.__ambient.bufferTime = floatBuffer;
				}
				catch (_error:Error) {
					//...
				};
				try {
					this.__players.audio.bufferTime = floatBuffer;
				}
				catch (_error:Error) {
					//...
				};
			}
			else this.__KUPDATES.audiobuffer = floatBuffer;
		};
		public function get bytes():Object {
			if (!this.__status.ready) return undefined;
			if (!this.__playercontrol.target) return undefined;
			var _buffering:Object = this.__playercontrol.target.buffering;
			return { bytesLoaded: _buffering.bytesLoaded, bytesTotal: _buffering.bytesTotal };
		};
		public function get durationIntro():Number {
			return ((this.__transition is ITransition) ? this.__transition.durationIntro : 0);
		};
		public function get durationOutro():Number {
			return ((this.__transition is ITransition) ? this.__transition.durationOutro : 0);
		};
		public function get mediaBounds():Rectangle {
			try {
				return DisplayObject(this.__playercontrol.target).getBounds(this);
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public function get mediaType():String {
			try {
				return this.__playercontrol.target.mediaType;
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public function get padding():Object {
			var _padding:Object = { };
			for (var i in this.__status.padding) {
				_padding[i] = { };
				for (var j in this.__status.padding[i]) _padding[i][j] = this.__status.padding[i][j];
			};
			return _padding;
		};
		public function set padding(objPadding:Object):void {
			if (objPadding) {
				for (var i in this.__status.padding) {
					if (!objPadding[i]) continue;
					for (var x in this.__status.padding[i]) {
						if (!isNaN(objPadding[i][x])) this.__status.padding[i][x] = objPadding[i][x];
					};
				};
			};
			this.resize(this.__status.height, this.__status.width);
		};
		public function get playing():Boolean {
			return this.__playercontrol.playing;
		};
		public function get ready():Boolean {
			return this.__status.ready;
		};
		public function get ttl():Number {
			try {
				return this.__KUPDATES.ttl;
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public function set ttl(floatTTL:Number):void {
			if (isNaN(floatTTL)) return;
			if (floatTTL < 0) return;
			this.__KUPDATES.ttl = floatTTL;
			if (this.__status.ready) {
				try {
					this.__players.swf.ttl = floatTTL;
				}
				catch (_error:Error) {
					//...
				};
			};
		};
		public function get videoBuffer():Number {
			try {
				return this.__players.video.bufferTime;
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public function set videoBuffer(floatBuffer:Number):void {
			if (isNaN(floatBuffer)) return;
			if (floatBuffer < 0) return;
			if (this.__status.ready) {
				try {
					this.__players.video.bufferTime = floatBuffer;
				}
				catch (_error:Error) {
					//...
				};
			}
			else this.__KUPDATES.videobuffer = floatBuffer;
		};
		public function get volume():Number {
			try {
				return 100 * this.__playercontrol.volume;
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public function set volume(floatVolume:Number):void {
			if (isNaN(floatVolume)) return;
			if (floatVolume < 0) return;
			if (floatVolume > 100) return;
			if (this.__status.ready) {
				try {
					this.__playercontrol.volume = 0.01 * floatVolume;
				}
				catch (_error:Error) {
					//...
				};
				try {
					this.__players.audio.volume = 0.01 * floatVolume;
				}
				catch (_error:Error) {
					//...
				};
			}
			else this.__KUPDATES.volume = floatVolume;
		};
		public function get wallpaper():Boolean {
			try {
				return this.__playercontrol.target.wallpaper;
			}
			catch (_error:Error) {
				//...
			};
			return false;
		};
		//
		//public methods...
		public function ambientPause():void {
			try {
				this.__ambient.pause();
			}
			catch (_error:Error) {
				//...
			};
		};
		public function ambientPlay():void {
			this.__ambient.autoStart = true;
			try {
				this.__ambient.play();
			}
			catch (_error:Error) {
				//...
			};
		};
		public function destroy():void {
			try {
				this.__ambient.reset();
			}
			catch (_error:Error) {
				//...
			};
			this.__status.hq = false;
			this.__status.mediainfo = undefined;
			this.__status.reset = true;
			this.__status.url = undefined;
			this.__removelistener(this.__transition, Event.CLOSE, this.__onTransitionClose);
			this.__removelistener(this.__transition, Event.OPEN, this.__onTransitionOpen);
			this.__playercontrol.active = false;
			for (var i in this.__players) {
				try {
					this.__players[i].reset();
				}
				catch (_error:Error) {
					//...
				};
			};
		};
		public function load(strURL:String, mediaInfo:String = undefined, boolHighQuality:Boolean = false):Boolean {
			if (!this.__status.ready) return false;
			if (!(strURL is String)) return false;
			if (strURL == "") return false;
			this.__playercontrol.visible = true;
			this.__status.hq = boolHighQuality;
			this.__status.mediainfo = mediaInfo;
			this.__status.url = strURL;
			this.__addlistener(this.__transition, Event.CLOSE, this.__onTransitionClose);
			this.__addlistener(this.__transition, Event.OPEN, this.__onTransitionOpen);
			var target:IPlayer = (this.__playercontrol.target == this.__players.audio) ? this.__playercontrol.target.plugin : this.__playercontrol.target;
			if (!this.__transition.outro(DisplayObject(target))) {
				this.__removelistener(this.__transition, Event.CLOSE, this.__onTransitionClose);
				this.__removelistener(this.__transition, Event.OPEN, this.__onTransitionOpen);
				this.__onTransitionClose();
			};
			this.__playercontrol.active = false;
			//
			return true;
		};
		public function pause():void {
			this.__playercontrol.pause();
		};
		public function play():void {
			this.__playercontrol.play();
		};
		public function reset():void {
			this.__status.hq = false;
			this.__status.mediainfo = undefined;
			this.__status.reset = true;
			this.__status.url = undefined;
			this.__addlistener(this.__transition, Event.CLOSE, this.__onTransitionClose);
			this.__addlistener(this.__transition, Event.OPEN, this.__onTransitionOpen);
			var target:IPlayer = (this.__playercontrol.target == this.__players.audio) ? this.__playercontrol.target.plugin : this.__playercontrol.target;
			if (this.__ambient.autoStart) {
				if (this.__status.ambient) this.__ambient.play();
			};
			if (!this.__transition.outro(DisplayObject(target))) {
				this.__removelistener(this.__transition, Event.CLOSE, this.__onTransitionClose);
				this.__removelistener(this.__transition, Event.OPEN, this.__onTransitionOpen);
				this.__onTransitionClose();
			};
			this.__playercontrol.active = false;
		};
		public function resize(floatHeight:Number, floatWidth:Number):void {
			if (!this.__status.ready) return;
			if (isNaN(floatHeight)) floatHeight = this.__status.height
			else if (floatHeight < 0) floatHeight = this.__status.height;
			if (isNaN(floatWidth)) floatWidth = this.__status.width
			else if (floatWidth < 0) floatWidth = this.__status.width;
			this.__status.height = floatHeight;
			this.__status.width = floatWidth;
			for (var i in this.__players) {
				this.__players[i].x = this.__crtoffset[i].left;
				this.__players[i].y = this.__crtoffset[i].top;
				this.__players[i].resize(this.__status.height - this.__crtoffset[i].bottom - this.__crtoffset[i].top, this.__status.width - this.__crtoffset[i].left - this.__crtoffset[i].right);
			};
			this.__align();
		};
	};
};