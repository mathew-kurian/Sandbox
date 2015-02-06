/**
 * VideoPlayer
 * Video player
 *
 * @version		2.0
 */
package _project.classes {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.LocalConnection;
	import flash.net.NetConnection;
	import flash.utils.Timer;
	import flash.system.Capabilities;
	import fl.transitions.TweenEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	//
	import _project.classes.IDecoder;
	import _project.classes.IPlayer;
	import _project.classes.XPlayerEvent;
	import _project.classes.XNetStream;
	//
	public class VideoPlayer extends Sprite implements IPlayer {
		//constants...
		private const __KALIGN:Array = [ { id: "", x: 0.5, y: 0.5 }, { id: "T", x: 0.5, y: 0 }, { id: "B", x: 0.5, y: 1 }, { id: "L", x: 0, y: 0.5 }, { id: "R", x: 1, y: 0.5 }, 
										{ id: "TL", x: 0, y: 0 }, { id: "TR", x: 1, y: 0 }, { id: "BL", x: 0, y: 1 }, { id: "BR", x: 1, y: 1 } ];
		private const __KALIGN_MEDIA:int = 0;
		private const __KALIGN_LOGO:int = 5;
		private const __KBLEND_MODE:Object = { border: BlendMode.ADD };
		private const __KCOMPATIBLES:Array = [ "f4v", "flv", "mov", "mp4", "m4a", "mp4v" ];
		private const __KFXPARAMS:Object = { duration: 2, transition: Strong.easeIn, useseconds: true, volume: 0 };
		private const __KLOGOALPHA:Number = 0.67;
		private const __KMEDIATYPE:String = "VIDEO";
		private const __KVIGNETTING:Object = { distance: 0, angle: 45, strength: 1, quality: 1, inner: true, knockout: false, hideObject: true };
		private const __KWALLPAPERBKG:Boolean = false;
		private const __KWALLPAPERPARAMS:Object = { alpha: 1, color: 0x000000 };
		//private vars...
		private var __bkg:*;
		private var __bkgpattern:BitmapData;
		private var __border:Bitmap;
		private var __borderpattern:BitmapData;
		private var __controls:Object = { display: true, mute: true, pause: true, play: true, repeat: true, seekbar: true, view: true, volume: true };
		private var __cursor:DisplayObject;
		private var __fx:Object;
		private var __logo:Bitmap;
		private var __logodefault:BitmapData;
		private var __media:Video;
		private var __netconnection:NetConnection;
		private var __netstream:XNetStream;
		private var __status:Object;
		private var __urldecoders:Array;
		private var __vignetting:Bitmap;
		private var __wallpaperbkg:Sprite;
		//
		//constructor...
		public function VideoPlayer(fCursor:Function = undefined, Bkg:* = undefined, objVignetting:Object = undefined, objBorder:Object = undefined, bdLogo:BitmapData = undefined, arrayURLDecoders:Array = undefined) {
			if (bdLogo is BitmapData) this.__logodefault = bdLogo;
			//
			this.__status = { align: this.__KALIGN[this.__KALIGN_MEDIA], alignlogo: this.__KALIGN[this.__KALIGN_LOGO], aspectratio: true, autostart: true, 
							  bkgfill: undefined, borderfill: 0xFF000000, borderfilters: [], borderoffset: 0, borderthick: 0, buffertime: 1, 
							  cursor: (fCursor is Function) ? fCursor : undefined, decoder: undefined, duration: 0, end: false, error: undefined, 
							  fx: true, height: 0, hq: false, info: undefined,
							  mediaisavailable: false, newmedia: undefined, playing: false, ready: false, repeat: false, source: undefined, 
							  url: undefined, _url: undefined,
							  videodeblocking: true, videoscale: true, videosmoothing: true, 
							  vignettingalpha: 0.25, vignettingblur: 0, vignettingcolor: 0x000000, 
							  volume: 1, wallpaper: false, width: 0 };
			if ((Bkg is MovieClip) || (Bkg is BitmapData) || !isNaN(Bkg)) this.__status.bkgfill = Bkg;
			if (objVignetting) {
				if (!isNaN(objVignetting.alpha)) {
					if (objVignetting.alpha >= 0 && objVignetting.alpha <= 1) this.__status.vignettingalpha = objVignetting.alpha;
				};
				if (!isNaN(objVignetting.blur)) {
					if (objVignetting.blur >= 0 && objVignetting.blur <= 255) this.__status.vignettingblur = objVignetting.blur;
				};
				if (!isNaN(objVignetting.color)) this.__status.vignettingcolor = objVignetting.color;
			};
			if (objBorder) {
				if (objBorder.fill is BitmapData) this.__status.borderfill = objBorder.fill
				else if (!isNaN(objBorder.fill)) this.__status.borderfill = objBorder.fill;
				if (objBorder.filters is BitmapFilter) objBorder.filters = [objBorder.filters];
				if (objBorder.filters is Array) {
					for (var i:int = 0; i < objBorder.filters.length; i++) {
						if (objBorder.filters[i] is BitmapFilter) this.__status.borderfilters.push(objBorder.filters[i]);
					};
				};
				if (!isNaN(objBorder.offset)) this.__status.borderoffset = Math.ceil(objBorder.offset);
				if (!isNaN(objBorder.thickness)) {
					if (objBorder.thickness >= 0) this.__status.borderthick = Math.ceil(objBorder.thickness);
				};
			};
			this.__urldecoders = new Array();
			if (arrayURLDecoders is Array) {
				for (var j:int = 0; j < arrayURLDecoders.length; j++) {
					if (arrayURLDecoders[j] is IDecoder) this.__urldecoders.push(arrayURLDecoders[j]);
				};
			};
			this.__status.decoder = this.__urldecoders.length;
			this.__netconnection = new NetConnection();
            this.__netconnection.addEventListener(NetStatusEvent.NET_STATUS, this.__onNetStatus);
            this.__netconnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.__onSecurityError);
			this.__netconnection.connect(null);
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
		private function __decode(strURL:String):void {
			if ((this.__media is Video) && (this.__status.newmedia is Video)) return;
			this.__netinit();
			this.__media.visible = false;
			if (this.__status.decoder < this.__urldecoders.length) {
				this.__status.source = { fileextension: "", filename: this.__urldecoders[this.__status.decoder].mediatype, url: strURL };
				this.__logo.bitmapData = this.__urldecoders[this.__status.decoder].logo(this.__status.hq);
			}
			else this.__status.source = this.__urlsplitter(strURL);
			this.__netstream.soundTransform = new SoundTransform(this.__status.volume, 0);
			this.__netstream.play(strURL);
		};
		private function __align():Object {
			return ((this.__status.wallpaper) ? this.__KALIGN[0] : this.__status.align);
		};
		private function __destroytween():void {
			if (!this.__fx.tween) return;
			try {
				this.__fx.tween.stop();
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__removelistener(this.__fx.tween, TweenEvent.MOTION_CHANGE, this.__onFxChange);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__removelistener(this.__fx.tween, TweenEvent.MOTION_FINISH, this.__onFxFinish);
			}
			catch (_error:Error) {
				//...
			};
			delete this.__fx.tween;
		};
		private function __netclose():void {
			if (!(this.__netstream is XNetStream)) return;
			if (this.__media is Video) {
				this.__media.attachNetStream(null);
				this.__media.visible = false;
				this.__media.clear();
			};
			this.__removelistener(this.__netstream, AsyncErrorEvent.ASYNC_ERROR, this.__onAsyncError);
			this.__removelistener(this.__netstream, IOErrorEvent.IO_ERROR, this.__onIoError);
			this.__removelistener(this.__netstream, NetStatusEvent.NET_STATUS, this.__onNetStatus);
			this.__netstream.onCuePoint = undefined;
			this.__netstream.onMetaData = undefined;
			this.__netstream.close();
			this.__netstream = undefined;
		};
		private function __netinit():void {
			if (this.__netstream is XNetStream) this.__netclose();
			this.__netstream = new XNetStream(this.__netconnection);
			if (!isNaN(this.__status.buffertime)) {
				if (this.__status.buffertime > 0) this.__netstream.bufferTime = this.__status.buffertime;
			};
			this.__addlistener(this.__netstream, AsyncErrorEvent.ASYNC_ERROR, this.__onAsyncError);
			this.__addlistener(this.__netstream, IOErrorEvent.IO_ERROR, this.__onIoError);
			this.__addlistener(this.__netstream, NetStatusEvent.NET_STATUS, this.__onNetStatus);
			this.__netstream.onCuePoint = this.__onCuePoint;
			this.__netstream.onMetaData = this.__onMetaData;
			this.__media.attachNetStream(this.__netstream);
		};
		private function __onAdded(event:Event):void {
			this.__removelistener(event.currentTarget, Event.ADDED, this.__onAdded);
			if (!(this.__status.newmedia is Video)) return;
			this.__status.newmedia = Video(this.__status.newmedia);
			//
			if (this.__media is Video) {
				try {
					this.swapChildren(this.__media, this.__status.newmedia);
				}
				catch (_error:Error) {
					//...
				};
				this.__media.attachNetStream(null);
				this.__media.parent.removeChild(this.__media);
			};
			//
			this.__media = this.__status.newmedia;
			this.__status.newmedia = undefined;
			this.__media.visible = false;
			this.__media.attachNetStream(this.__netstream);
			this.__media.deblocking = this.__status.videodeblocking;
			this.__media.smoothing = this.__status.videosmoothing;
			this.__addlistener(this, MouseEvent.CLICK, this.__onMouseClick);
			this.__addlistener(this, MouseEvent.MOUSE_MOVE, this.__onMouseMove);
			if (this.__status.cursor is Function) {
				this.__cursor = this.addChild(this.__status.cursor());
				this.__cursor.visible = false;
				this.__cursor.x = this.mouseX;
				this.__cursor.y = this.mouseY;
				var _timer:Timer = new Timer(10);
				_timer.addEventListener(TimerEvent.TIMER, this.__onTimer);
				_timer.start();
			};
			//
			if (!(this.__status._url is String)) return;
			for (var i:int = 0; i < this.__urldecoders.length; i++) {
				this.__addlistener(this.__urldecoders[i], Event.COMPLETE, this.__onDecoderComplete);
				this.__addlistener(this.__urldecoders[i], IOErrorEvent.IO_ERROR, this.__onDecoderIOError);
				this.__addlistener(this.__urldecoders[i], SecurityErrorEvent.SECURITY_ERROR, this.__onDecoderSecurityError);
			};
			this.__status.decoder = 0;
			while (this.__status.decoder < this.__urldecoders.length && !this.__urldecoders[this.__status.decoder].decode(this.__status._url)) this.__status.decoder++;
			if (this.__status.decoder >= this.__urldecoders.length) this.__decode(this.__status._url);
			this.__status._url = undefined;
		};
        private function __onAsyncError(event:AsyncErrorEvent):void {
			this.__status.error = event;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
        };
		private function __onCuePoint(infoObject:Object):void {
			//...
		};
		private function __onDecoderComplete(event:Event):void {
			this.__decode(event.target.url(this.__status.hq));
		};
		private function __onDecoderIOError(event:IOErrorEvent):void {
			this.__status.error = event;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
		};
		private function __onDecoderSecurityError(event:SecurityErrorEvent):void {
			this.__status.error = event;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
		};
		private function __onFxChange(event:TweenEvent):void {
			this.__netstream.soundTransform = new SoundTransform(this.__fx.volume, 0);
		};
		private function __onFxFinish(event:TweenEvent):void {
			this.__removelistener(this.__fx.tween, TweenEvent.MOTION_CHANGE, this.__onFxChange);
			this.__removelistener(this.__fx.tween, TweenEvent.MOTION_FINISH, this.__onFxFinish);
		};
		private function __onIoError(event:IOErrorEvent):void {
			this.__status.error = event;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
		};
		private function __onMetaData(infoObject:Object):void {
			if (this.__status.mediaisavailable) return;
			this.__status.info = { };
			var _duration:String = "duratio";//for Amayeta SWF Encrypt!!!...
			for (var i in infoObject) {
				this.__status.info[i] = infoObject[i];
				if (String(i).indexOf(_duration) >= 0) {
					if (!isNaN(infoObject[i])) {
						this.__status.duration = infoObject[i];
						if (this.__status.duration < 0) this.__status.duration = 1;
					};
				};
			};
			if (!this.__status.autostart) this.__netstream.pause()
			else {
				if (this.__status.fx) {
					this.__destroytween();
					this.__netstream.soundTransform = new SoundTransform(0, 0);
					this.__fx.tween = new Tween(this.__fx, "volume", this.__KFXPARAMS.transition, 0, this.__status.volume, this.__KFXPARAMS.duration, this.__KFXPARAMS.useseconds);
					this.__addlistener(this.__fx.tween, TweenEvent.MOTION_CHANGE, this.__onFxChange);
					this.__addlistener(this.__fx.tween, TweenEvent.MOTION_FINISH, this.__onFxFinish);
				}
				else this.__netstream.soundTransform = new SoundTransform(this.__status.volume, 0);
			};
			this.__status.playing = this.__status.autostart;
			var _timer:Timer = new Timer(10);
			_timer.start();
			this.__addlistener(_timer, TimerEvent.TIMER, this.__onTimerInit);
		};
		private function __onMouseClick(event:MouseEvent):void {
			if (this != event.currentTarget) return;
			if (!this.buttonMode) return;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_CLICK));
		};
		private function __onMouseMove(event:MouseEvent):void {
			if (this != event.currentTarget) return;
			if (this.mouseX < this.__media.x) this.buttonMode = false
			else if (this.mouseX > this.__media.x + this.__media.width) this.buttonMode = false
			else if (this.mouseY < this.__media.y) this.buttonMode = false
			else if (this.mouseY > this.__media.y + this.__media.height) this.buttonMode = false
			else this.buttonMode = true;
			if (this.__cursor) {
				this.__cursor.visible = this.buttonMode;
				if (this.__cursor.visible) {
					this.__cursor.x = this.mouseX;
					this.__cursor.y = this.mouseY;
				};
			};
		};
		private function __onNetStatus(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "NetConnection.Call.BadVersion":
					this.__status.error = event;
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
					break;
				case "NetConnection.Call.Failed":
					this.__status.error = event;
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
					break;
				case "NetConnection.Call.Prohibited":
					this.__status.error = event;
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
					break;
				case "NetConnection.Connect.Closed":
					//
					break;
				case "NetConnection.Connect.Failed":
					this.__status.error = event;
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
					break;
				case "NetConnection.Connect.Success":
					this.__netstream = new XNetStream(this.__netconnection);
					if (!isNaN(this.__status.buffertime)) {
						if (this.__status.buffertime > 0) this.__netstream.bufferTime = this.__status.buffertime;
					};
					this.__addlistener(this.__netstream, AsyncErrorEvent.ASYNC_ERROR, this.__onAsyncError);
					this.__addlistener(this.__netstream, IOErrorEvent.IO_ERROR, this.__onIoError);
					this.__addlistener(this.__netstream, NetStatusEvent.NET_STATUS, this.__onNetStatus);
					this.__netstream.onCuePoint = this.__onCuePoint;
					this.__netstream.onMetaData = this.__onMetaData;
					if (this.__status.bkgfill is MovieClip) this.__bkg = MovieClip(this.addChild(this.__status.bkgfill))
					else if (this.__status.bkgfill is BitmapData) {
						this.__bkg = Bitmap(new Bitmap());
						this.__bkgpattern = this.__pattern(this.__status.bkgfill, Capabilities.screenResolutionY, Capabilities.screenResolutionX);
					}
					else if (!isNaN(this.__status.bkgfill)) this.__bkg = Bitmap(new Bitmap());
					this.__wallpaperbkg = new Sprite();
					this.__wallpaperbkg.visible = this.__KWALLPAPERBKG;
					this.__wallpaperbkg.graphics.beginFill(this.__KWALLPAPERPARAMS.color, this.__KWALLPAPERPARAMS.alpha);
					this.__wallpaperbkg.graphics.drawRect(0, 0, 200, 200);
					this.__wallpaperbkg.graphics.endFill();
					this.__wallpaperbkg.height = 0;
					this.__wallpaperbkg.width = 0;
					this.__wallpaperbkg = Sprite(this.addChild(this.__wallpaperbkg));
					this.__removelistener(this.__status.newmedia, Event.ADDED, this.__onAdded);
					this.__status.newmedia = new Video();
					this.__addlistener(this.__status.newmedia, Event.ADDED, this.__onAdded);
					this.addChild(this.__status.newmedia);
					this.__logo = Bitmap(this.addChild(new Bitmap()));
					this.__logo.alpha = this.__KLOGOALPHA;
					if (this.__status.vignettingalpha > 0 && this.__status.vignettingblur > 0) {
						this.__vignetting = Bitmap(this.addChild(new Bitmap()));
						this.__vignetting.visible = false;
						this.__vignetting.filters = [new DropShadowFilter(this.__KVIGNETTING.distance, 
																		  this.__KVIGNETTING.angle,
																		  this.__status.vignettingcolor,
																		  this.__status.vignettingalpha,
																		  this.__status.vignettingblur,
																		  this.__status.vignettingblur,
																		  this.__KVIGNETTING.strength,
																		  this.__KVIGNETTING.quality,
																		  this.__KVIGNETTING.inner,
																		  this.__KVIGNETTING.knockout,
																		  this.__KVIGNETTING.hideObject)];
						this.__vignetting.cacheAsBitmap = true;
					};
					if (this.__status.borderthick > 0) {
						this.__border = Bitmap(this.addChild(new Bitmap()));
						this.__border.blendMode = this.__KBLEND_MODE.border;
						this.__border.visible = false;
						this.__border.cacheAsBitmap = true;
						this.__border.filters = this.__status.borderfilters;
						if (this.__status.borderfill is BitmapData) this.__borderpattern = this.__pattern(this.__status.borderfill, Capabilities.screenResolutionY, Capabilities.screenResolutionX);
					};
					this.__netstream.soundTransform = new SoundTransform();
					this.__fx = { volume: 0, tween: undefined };
					this.__status.ready = true;
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.INIT));
					break;
				case "NetConnection.Connect.Rejected":
					this.__status.error = event;
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
					break;
				case "NetConnection.Connect.AppShutdown":
					this.__status.error = event;
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
					break;
				case "NetConnection.Connect.InvalidApp":
					this.__status.error = event;
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
					break;
				case "NetStream.Buffer.Empty":
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_BUFFERING_START));
					break;
				case "NetStream.Buffer.Full":
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_BUFFERING_STOP));
					break;
				case "NetStream.Buffer.Flush":
					//
					break;
				case "NetStream.Pause.Notify":
					//
					break;
				case "NetStream.Play.Failed":
					this.__status.error = event;
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
					break;
				case "NetStream.Play.PublishNotify":
					//
					break;
				case "NetStream.Play.Reset":
					//
					break;
				case "NetStream.Play.Start":
					//
					break;
				case "NetStream.Play.Stop":
					var _end:Boolean = true;
					if (!isNaN(this.__status.duration)) {
						if (Math.floor(this.__netstream.time) < Math.floor(this.__status.duration)) _end = false;
					};
					if (_end) {
						if (this.__status.repeat) this.__netstream.seek(0)
						else {
							this.__status.end = true;
							this.__status.playing = false;
							this.__netstream.pause();
							this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_END));
						};
					};
					break;
				case "NetStream.Play.StreamNotFound":
					this.__status.error = event;
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
					break;
				case "NetStream.Play.UnpublishNotify":
					//
					break;
				case "NetStream.Publish.Start":
					//
					break;
				case "NetStream.Publish.BadName":
					this.__status.error = event;
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
					break;
				case "NetStream.Publish.Idle":
					//
					break;
				case "NetStream.Seek.Failed":
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_BUFFERING_START));
					break;
				case "NetStream.Seek.InvalidTime":
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_BUFFERING_START));
					break;
				case "NetStream.Seek.Notify":
					if (this.__status.end && this.__status.playing) this.__netstream.resume();
					this.__status.end = false;
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_BUFFERING_STOP));
					break;
				case "NetStream.Unpause.Notify":
					//
					break;
				case "NetStream.Unpublish.Success":
					//
					break;
			};
		};
        private function __onSecurityError(event:SecurityErrorEvent):void {
			this.__status.error = event;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
        };
		private function __onTimer(event:TimerEvent):void {
			var _valid:Boolean = !(this.__cursor is MovieClip);
			if (!_valid) _valid = (MovieClip(this.__cursor).setCursor is Function);
			if (!_valid) return;
			this.__removelistener(event.target, TimerEvent.TIMER, this.__onTimer);
			try {
				event.target.stop();
			}
			catch (_error:Error) {
				//...
			};
			try {
				MovieClip(this.__cursor).setCursor(!this.__status.wallpaper);
			}
			catch (_error:Error) {
				//...
			};
		};
		private function __onTimerInit(event:TimerEvent):void {
			if (isNaN(this.__media.videoWidth)) return;
			if (this.__media.videoWidth <= 0) return;
			if (isNaN(this.__media.videoHeight)) return;
			if (this.__media.videoHeight <= 0) return;
			this.__status.mediaisavailable = true;
			event.target.stop();
			this.__removelistener(event.target, TimerEvent.TIMER, this.__onTimerInit);
			this.__resize();
			this.__logo.visible = true;
			this.__media.visible = true;
			if (this.__vignetting is Bitmap) this.__vignetting.visible = true;
			if (this.__border is Bitmap) this.__border.visible = true;
			this.__wallpaperbkg.visible = this.__status.wallpaper || this.__KWALLPAPERBKG;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_READY));
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_INFO));
		};
		private function __pattern(bmpSource:BitmapData, floatHeight:Number, floatWidth:Number):BitmapData {
			var _result:BitmapData = new BitmapData(floatWidth, floatHeight, true, 0x00000000);
			var _crtX:int = 0;
			while (_crtX < _result.width) {
				var _crtY:int = 0;
				while (_crtY < _result.height) {
					_result.copyPixels(bmpSource, new Rectangle(0, 0, bmpSource.width, bmpSource.height), new Point(_crtX, _crtY));
					_crtY += bmpSource.height;
				};
				_crtX += bmpSource.width;
			};
			return _result;
		};
		private function __removelistener(target:*, event:String, listener:Function):void {
			try {
				target.removeEventListener(event, listener);
			}
			catch (_error:Error) {
				//...
			};
		};
		private function __reset():void {
			this.__removelistener(this.__status.newmedia, Event.ADDED, this.__onAdded);
			try {
				this.removeChild(this.__status.newmedia);
			}
			catch (_error:Error) {
				//...
			};
			this.__media.attachNetStream(null);
			if (this.__status.fx) this.__destroytween();
			this.__netclose();
			try {
				this.removeChild(this.__cursor);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__vignetting.visible = false;
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__vignetting.bitmapData.dispose();
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__bkg.visible = false;
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__border.visible = false;
				this.__border.bitmapData.dispose();
			}
			catch (_error:Error) {
				//...
			};
			this.__cursor = undefined;
			this.__wallpaperbkg.visible = this.__KWALLPAPERBKG;
			this.__wallpaperbkg.height = this.__wallpaperbkg.width = 0;
			for (var i:int = 0; i < this.__urldecoders.length; i++) {
				this.__urldecoders[i].reset();
				this.__removelistener(this.__urldecoders[i], Event.COMPLETE, this.__onDecoderComplete);
				this.__removelistener(this.__urldecoders[i], IOErrorEvent.IO_ERROR, this.__onDecoderIOError);
				this.__removelistener(this.__urldecoders[i], SecurityErrorEvent.SECURITY_ERROR, this.__onDecoderSecurityError);
			};
			this.__status.decoder = this.__urldecoders.length;
			//
			this.__logo.visible = false;
			this.__logo.bitmapData = this.__logodefault;
			this.__logo.x = this.__logo.y = 0;
			//
			this.__status.newmedia = new Video();
			this.__addlistener(this.__status.newmedia, Event.ADDED, this.__onAdded);
			this.addChild(this.__status.newmedia);
			//
			this.__status.duration = 0;
			this.__status.end = false;
			this.__status.error = undefined;
			this.__status.info = undefined;
			this.__status.mediaisavailable = false;
			this.__status.playing = false;
			delete this.__status.source;
		};
		private function __resize():void {
			if (!this.__media) return;
			if (isNaN(this.__media.videoHeight)) return;
			if (this.__media.videoHeight <= 0) return;
			if (isNaN(this.__media.videoWidth)) return;
			if (this.__media.videoWidth <= 0) return;
			//
			var _scaleX:Number;
			var _scaleY:Number;
			var _validborder:Boolean = (this.__border is Bitmap) && !this.__status.wallpaper;
			var _bordert:Number = (_validborder) ? 2 * (this.__status.borderthick + this.__status.borderoffset) : 0;
			var _h:Number;
			var _w:Number;
			if (_bordert > 0) {
				_h = this.__status.height - _bordert;
				_w = this.__status.width - _bordert;
			}
			else {
				_h = this.__status.height;
				_w = this.__status.width;
			};
			if (this.__status.aspectratio) _scaleX = _scaleY = Math.min(_h / this.__media.videoHeight, _w / this.__media.videoWidth)
			else {
				_scaleX = _w / this.__media.videoWidth;
				_scaleY = _h / this.__media.videoHeight;
			};
			if (!this.__status.videoscale) {
				if (_scaleX > 1) _scaleX = 1;
				if (_scaleY > 1) _scaleY = 1;
			};
			this.__media.height = _scaleY * this.__media.videoHeight;
			this.__media.width = _scaleX * this.__media.videoWidth;
			if (this.__vignetting is Bitmap) {
				try {
					this.__vignetting.bitmapData.dispose();
				}
				catch (_error:Error) {
					//...
				};
				try {
					this.__vignetting.bitmapData = new BitmapData(this.__media.width, this.__media.height, false);
				}
				catch (_error:Error) {
					//...
				};
				this.__vignetting.x = this.__media.x;
				this.__vignetting.y = this.__media.y;
			};
			try {
				this.__border.bitmapData.dispose();
			}
			catch (_error:Error) {
				//...
			};
			//
			if (this.__status.wallpaper || this.__KWALLPAPERBKG) {
				if (this.__bkg is DisplayObject) this.__bkg.visible = false;
				this.__wallpaperbkg.height = this.__status.height;
				this.__wallpaperbkg.width = this.__status.width;
			}
			else {
				this.__wallpaperbkg.height = this.__wallpaperbkg.width = 0;
				if (this.__bkg is DisplayObject) {
					this.__bkg.visible = true;
					if (this.__bkg is MovieClip) {
						this.__bkg.height = this.__status.height;
						this.__bkg.width = this.__status.width;
					}
					else if (this.__bkg is Bitmap) {
						var _bkg:BitmapData;
						if (this.__status.bkgfill is BitmapData) _bkg = this.__pattern(this.__bkgpattern, this.__status.height, this.__status.width)
						else if (!isNaN(this.__status.borderfill)) {
							_bkg = new BitmapData(this.__status.width, this.__status.height, true, 0x00000000);
							_bkg.floodFill(0, 0, this.__status.bkgfill);
						};
						this.__bkg.bitmapData = _bkg;
					};
				};
				if (this.__border is Bitmap) {
					if (_validborder) {
						_h = Math.ceil(this.__media.height + _bordert);
						_w = Math.ceil(this.__media.width + _bordert);
						if (_h > 0 && _w > 0) {
							var _border:BitmapData;
							if (this.__status.borderfill is BitmapData) _border = this.__pattern(this.__borderpattern, _h, _w)
							else if (!isNaN(this.__status.borderfill)) {
								_border = new BitmapData(_w, _h, true, 0x00000000);
								_border.floodFill(0, 0, this.__status.borderfill);
							}
							_border.fillRect(new Rectangle(this.__status.borderthick, this.__status.borderthick, _border.width - 2 * this.__status.borderthick, _border.height - 2 * this.__status.borderthick), 0x00000000);
							this.__border.bitmapData = _border;
						};
						this.__border.x = Math.round(this.__media.x - _bordert);
						this.__border.y = Math.round(this.__media.y - _bordert);
					};
				};
			};
			this.align = this.align;
			if (this.__cursor) {
				this.__cursor.x = this.mouseX;
				this.__cursor.y = this.mouseY;
			};
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_RESIZE));
		};
		private function __urlsplitter(strURL:String):Object {
			var _result:Object = { fileextension: "", filename: "", folder: "", url: strURL };
			var _questionmark:int = strURL.lastIndexOf("?");
			if (_questionmark >= 0) strURL = strURL.substr(0, _questionmark - 1);
			_result.filename = strURL.substr(strURL.substring(0, strURL.lastIndexOf("/") + 1).length);
			var dot:int = _result.filename.lastIndexOf(".");
			if (dot < 0) dot = _result.filename.length;
			_result.folder = strURL.substr(0, strURL.length - _result.filename.length - ((_result.filename.length < strURL.length) ? 1 : 0));
			_result.fileextension = _result.filename.substr(dot + 1);
			_result.filename = _result.filename.substr(0, dot);
			return _result;
		};
		//
		//properties...
		public function get align():String {
			if (!this.__media) return undefined;
			return this.__status.align.id;
		};
		public function set align(strAlign:String):void {
			if (!(strAlign is String)) return;
			strAlign = strAlign.toUpperCase();
			for (var i in this.__KALIGN) {
				if (strAlign == this.__KALIGN[i].id) {
					this.__status.align = this.__KALIGN[i];
					if (!this.__media) return;
					var _validborder:Boolean = (this.__border is Bitmap) && !this.__status.wallpaper;
					var _bordert:Number = (_validborder) ? this.__status.borderthick + this.__status.borderoffset : 0;
					if (_bordert > 0) {
						this.__media.x = _bordert + this.__align().x * (this.__status.width - this.__media.width - 2 * _bordert);
						this.__media.y = _bordert + this.__align().y * (this.__status.height - this.__media.height - 2 * _bordert);
					}
					else {
						this.__media.x = this.__align().x * (this.__status.width - this.__media.width);
						this.__media.y = this.__align().y * (this.__status.height - this.__media.height);
					};
					if (this.__logo.bitmapData is BitmapData) {
						this.__logo.x = this.__media.x + this.__status.alignlogo.x * (this.__media.width - this.__logo.width);
						this.__logo.y = this.__media.y + this.__status.alignlogo.y * (this.__media.height - this.__logo.height);
					};
					if (this.__vignetting is Bitmap) {
						this.__vignetting.x = this.__media.x;
						this.__vignetting.y = this.__media.y;
					};
					if (_validborder) {
						this.__border.x = Math.round(this.__media.x - _bordert);
						this.__border.y = Math.round(this.__media.y - _bordert);
					};
					return;
				};
			};
		};
		public function get alignlogo():String {
			if (!this.__media) return undefined;
			return this.__status.alignlogo.id;
		};
		public function set alignlogo(strAlign:String):void {
			if (!(strAlign is String)) return;
			strAlign = strAlign.toUpperCase();
			for (var i in this.__KALIGN) {
				if (strAlign == this.__KALIGN[i].id) {
					this.__status.alignlogo = this.__KALIGN[i];
					if (!this.__media) return;
					if (this.__logo.bitmapData is BitmapData) {
						this.__logo.x = this.__media.x + this.__status.alignlogo.x * (this.__media.width - this.__logo.width);
						this.__logo.y = this.__media.y + this.__status.alignlogo.y * (this.__media.height - this.__logo.height);
					};
					break;
				};
			};
		};
		public function get aspectRatio():Boolean {
			if (!this.__media) return undefined;
			return this.__status.aspectratio;
		};
		public function set aspectRatio(boolAspectratio:Boolean):void {
			if (!this.__media) return;
			if (!(boolAspectratio is Boolean)) return;
			this.__status.aspectratio = boolAspectratio;
			this.__resize();
		};
		public function get autoStart():Boolean {
			if (!this.__media) return undefined;
			return this.__status.autostart;
		};
		public function set autoStart(boolAutostart:Boolean):void {
			if (!this.__media) return;
			if (!(boolAutostart is Boolean)) return;
			this.__status.autostart = boolAutostart;
		};
		public function get buffering():Object {
			if (!this.__media) return { };
			return { bytesLoaded: this.__netstream.bytesLoaded, bytesTotal: this.__netstream.bytesTotal,
					 bufferLength: this.__netstream.bufferLength, bufferTime: this.__netstream.bufferTime };
		};
		public function get bufferTime():Number {
			if (!this.__netstream) return undefined;
			return this.__netstream.bufferTime;
		};
		public function set bufferTime(floatBuffer:Number):void {
			if (isNaN(floatBuffer)) return;
			if (floatBuffer < 0) return;
			this.__status.buffertime = floatBuffer;
			if (this.__netstream) this.__netstream.bufferTime = floatBuffer;
		};
		public function get context():* {
			if (!this.__netstream) return undefined;
			return this.__netstream.checkPolicyFile;
		};
		public function set context(loaderContext:*):void {
			if (!this.__netstream) return;
			if (loaderContext is Boolean) this.__netstream.checkPolicyFile = loaderContext;
		};
		public function get controls():Object {
			if (!this.__media) return undefined;
			if (this.__status.mediaisavailable) return { buffer: true, display: true, mediainfo: true, btnmute: true, btnpause: true, btnplay: true, btnrepeat: true, seekbar: true, btnview: true, volumebar: true };
			return { buffer: false, display: false, mediainfo: false, btnmute: false, btnpause: false, btnplay: false, btnrepeat: false, seekbar: false, btnview: false, volumebar: false };
		};
		public function get current():Number {
			if (isNaN(this.duration)) return undefined;
			if (this.__netstream.time > this.__status.duration) this.__status.duration = this.__netstream.time;
			return this.__netstream.time / this.__status.duration;
		};
		public function set current(floatCurrent:Number):void {
			if (isNaN(this.duration)) return;
			if (isNaN(floatCurrent)) return;
			if (floatCurrent < 0) floatCurrent = 0
			else if (floatCurrent > 1) floatCurrent = 1;
			this.__netstream.seek(floatCurrent * this.__status.duration);
		};
		public function get duration():Number {
			if (!this.__media) return 0;
			return this.__status.duration;
		};
		public override function get height():Number {
			if (!this.__netstream) return undefined;
			return this.__status.height;
		};
		public override function set height(floatHeight:Number):void {
			if (!this.__status.ready) return;
			if (!this.__media) return;
			if (isNaN(floatHeight)) return;
			if (floatHeight < 0) return;
			this.__status.height = floatHeight;
			this.__resize();
		};
		public function get loaded():Number {
			if (!this.__netstream) return 0;
			return (this.__netstream.bytesLoaded / this.__netstream.bytesTotal);
		};
		public function get mediaEnd():Boolean {
			if (!this.__media) return undefined;
			return this.__status.end;
		};
		public function get mediaInfo():Object {
			if (!this.__media) return undefined;
			var _info:Object = { };
			for (var i in this.__status.source) _info[i] = this.__status.source[i];
			return _info;
		};
		public function get mediaMetrics():Object {
			if (!this.__media) return undefined;
			var _borderoffset:Number;
			var _borderthick:Number;
			if (this.__border is Bitmap) {
				_borderoffset = this.__status.borderoffset;
				_borderthick = this.__status.borderthick;
			}
			else _borderoffset = _borderthick = 0;
			if (this.__status.wallpaper) _borderoffset = _borderthick = 0;
			return { borderOffset: _borderoffset, borderThick: _borderthick, 
					 height: this.__media.height, scaleX: this.__media.scaleX, scaleY: this.__media.scaleY, width: this.__media.width, x: this.__media.x, y: this.__media.y,
					 wallpaperHeight: this.__wallpaperbkg.height, wallpaperWidth: this.__wallpaperbkg.width, wallpaperX: this.__wallpaperbkg.x, wallpaperY: this.__wallpaperbkg.y };
		};
		public function get mediaType():String {
			return ((this.__media) ? this.__KMEDIATYPE : "");
		};
		public function get playing():Boolean {
			if (!this.__media) return false;
			return this.__status.playing;
		};
		public function get plugin():IPlayer {
			return undefined;
		};
		public function set plugin(objPlugin:IPlayer):void {
			//blind...
		};
		public function get ready():Boolean {
			return this.__status.ready;
		};
		public function get repeat():Boolean {
			if (!this.__media) return undefined;
			return this.__status.repeat;
		};
		public function set repeat(boolRepeat:Boolean):void {
			if (!this.__media) return;
			if (!(boolRepeat is Boolean)) return;
			this.__status.repeat = boolRepeat;
		};
		public function get smoothing():Boolean {
			if (!this.__media) return undefined;
			return this.__status.smoothing;
		};
		public function set smoothing(boolSmoothing:Boolean):void {
			if (!this.__media) return;
			if (!(boolSmoothing is Boolean)) return;
			this.__media.smoothing = boolSmoothing;
		};
		public function get snapshot():Object {
			if (!this.__media) return { bitmapdata: undefined, x: 0, y: 0 };
			var _snapshot:BitmapData;
			var snapX:Number = 0, snapY:Number = 0;
			if (this.__wallpaperbkg.visible) {
				_snapshot = new BitmapData(this.__wallpaperbkg.width, this.__wallpaperbkg.height, true, 0x00000000);
				_snapshot.draw(this.__wallpaperbkg);
				snapX = this.__wallpaperbkg.x;
				snapY = this.__wallpaperbkg.y;
			};
			var _validborder:Boolean = (this.__border is Bitmap);
			if (_validborder) _validborder = (this.__border.bitmapData is BitmapData);
			if (_validborder) _validborder = (this.__border.height > this.__wallpaperbkg.height);
			if (_validborder) {
				if (_snapshot is BitmapData) {
					var _border:BitmapData = new BitmapData(this.__border.width, this.__border.height, true, 0x00000000);
					_snapshot.copyPixels(_border, new Rectangle(0, 0, _border.width, _border.height), new Point(this.__border.x - this.__wallpaperbkg.x, this.__border.y - this.__wallpaperbkg.y));
				}
				else {
					_snapshot = new BitmapData(this.__border.width, this.__border.height, true, 0x00000000);
					_snapshot.draw(this.__border);
					snapX = this.__border.x;
					snapY = this.__border.y;
				};
			};
			var _media:BitmapData = new BitmapData(this.__media.width, this.__media.height, false, 0x00000000);
			if (this.__logo.bitmapData is BitmapData) _media.copyPixels(this.__logo.bitmapData, new Rectangle(0, 0, this.__logo.bitmapData.width, this.__logo.bitmapData.height), new Point(0.5 * (this.__media.width - this.__logo.bitmapData.width), 0.5 * (this.__media.height - this.__logo.bitmapData.height)));
			try {
				_media.draw(this.__media, new Matrix(this.__media.scaleX, 0, 0, this.__media.scaleY, 0, 0));
			}
			catch (_error:Error) {
				//...
			};
			if (_snapshot is BitmapData) _snapshot.copyPixels(_media, new Rectangle(0, 0, _media.width, _media.height), new Point(this.__media.x - snapX, this.__media.y - snapY))
			else {
				_snapshot = _media;
				snapX = this.__media.x;
				snapY = this.__media.y;
			};
			return { bitmapdata: _snapshot, x: snapX, y: snapY };
		};
		public function get time():Number {
			if (!this.__media) return undefined;
			if (this.__netstream.time > this.__status.duration) this.__status.duration = this.__netstream.time;
			return this.__netstream.time;
		};
		public function set time(floatTime:Number):void {
			if (!this.__media) return;
			if (isNaN(floatTime)) return;
			if (floatTime < 0) floatTime = 0
			else if (floatTime > this.__status.duration) floatTime = this.__status.duration;
			this.__netstream.seek(floatTime);
		};
		public function get ttl():Number {
			return this.__status.duration;
		};
		public function set ttl(floatTTL:Number):void {
			//blind...
		};
		public function get volume():Number {
			try {
				return this.__netstream.soundTransform.volume;
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public function set volume(floatVolume:Number):void {
			if (!this.__netstream) return;
			if (isNaN(floatVolume)) return;
			if (floatVolume < 0) floatVolume = 0
			if (floatVolume > 1) floatVolume = 1;
			this.__destroytween();
			this.__status.volume = floatVolume;
			this.__netstream.soundTransform = new SoundTransform(floatVolume, 0);
		};
		public function get wallpaper():Boolean {
			try {
				return this.__status.wallpaper;
			}
			catch (_error:Error) {
				//...
			};
			return false;
		};
		public function set wallpaper(boolWallpaper:Boolean):void {
			if (!(boolWallpaper is Boolean)) return;
			if (this.__status.wallpaper == boolWallpaper) return;
			this.__status.wallpaper = boolWallpaper;
			this.__wallpaperbkg.visible = boolWallpaper || this.__KWALLPAPERBKG;
			if (!this.__status.wallpaper) this.__wallpaperbkg.height = this.__wallpaperbkg.width = 0;
			if (this.__cursor) {
				this.__cursor.visible = this.buttonMode;
				this.__cursor.x = this.mouseX;
				this.__cursor.y = this.mouseY;
				try {
					MovieClip(this.__cursor).setCursor(!this.__status.wallpaper);
				}
				catch (_error:Error) {
					//...
				};
			};
			this.__resize();
			this.dispatchEvent(new Event(Event.RESIZE));
		};
		public override function get width():Number {
			if (!this.__media) return undefined;
			return this.__status.width;
		};
		public override function set width(floatWidth:Number):void {
			if (!this.__status.ready) return;
			if (!this.__media) return;
			if (isNaN(floatWidth)) return;
			if (floatWidth < 0) return;
			this.__status.width = floatWidth;
			this.__resize();
		};
		//
		//public methods...
		public override function getBounds(targetCoordinateSpace:DisplayObject):Rectangle {
			if (!(targetCoordinateSpace is DisplayObject)) return undefined;
			if (!this.__media) return undefined;
			var _cornerTL:Point;
			var _cornerBR:Point;
			if (this.__bkg || this.__status.wallpaper || this.__KWALLPAPERBKG) {
				_cornerTL = new Point(0, 0);
				_cornerBR = new Point(this.__status.width, this.__status.height);
			}
			else {
				var _offset:Number = (this.__border is Bitmap) ? this.__status.borderoffset + this.__status.borderthick : 0;
				if (_offset < 0) _offset = 0;
				_cornerTL = new Point(this.__media.x - _offset, this.__media.y - _offset);
				_cornerBR = new Point(this.__media.x + this.__media.width + _offset, this.__media.y + this.__media.height + _offset);
			};
			_cornerTL = targetCoordinateSpace.globalToLocal(this.localToGlobal(_cornerTL));
			_cornerBR = targetCoordinateSpace.globalToLocal(this.localToGlobal(_cornerBR));
			//
			return new Rectangle(_cornerTL.x, _cornerTL.y, _cornerBR.x - _cornerTL.x, _cornerBR.y - _cornerTL.y);
		};
		public override function getRect(targetCoordinateSpace:DisplayObject):Rectangle {
			return this.getBounds(targetCoordinateSpace);
		};
		public function iscompatible(strURL:String):Boolean {
			if (!(strURL is String)) return false;
			if (strURL == "") return false;
			for (var i in this.__urldecoders) {
				if (this.__urldecoders[i].iscompatible(strURL)) return true;
			};
			strURL = this.__urlsplitter(strURL).fileextension;
			if (strURL.length > 0) {
				strURL = strURL.toLowerCase();
				for (var j in this.__KCOMPATIBLES) {
					if (strURL == this.__KCOMPATIBLES[j]) return true;
				};
			};
			return false;
		};
		public function load(strURL:String, boolHighQuality:Boolean = false):Boolean {
			if (!this.__media) return false;
			if (!(strURL is String)) return false;
			if (strURL == "") return false;
			//
			this.__status.hq = Boolean(boolHighQuality);
			this.__status._url = strURL;
			this.__reset();
			return true;
		};
		public function pause():void {
			if (!this.__media) return;
			if (this.__status.duration <= 0) return;
			if (!this.__status.playing) return;
			//
			this.__status.playing = false;
			this.__netstream.pause();
		};
		public function play(soundChannel:SoundChannel = undefined):void {
			if (!this.__media) return;
			if (this.__status.duration <= 0) return;
			if (this.__status.playing) return;
			//
			this.__status.playing = true;
			if (this.__status.fx) {
				this.__destroytween();
				this.__netstream.soundTransform = new SoundTransform(0, 0);
				this.__fx.tween = new Tween(this.__fx, "volume", this.__KFXPARAMS.transition, 0, this.__status.volume, this.__KFXPARAMS.duration, this.__KFXPARAMS.useseconds);
				this.__addlistener(this.__fx.tween, TweenEvent.MOTION_CHANGE, this.__onFxChange);
				this.__addlistener(this.__fx.tween, TweenEvent.MOTION_FINISH, this.__onFxFinish);
			}
			else this.__netstream.soundTransform = new SoundTransform(this.__status.volume, 0);
			(this.__status.end) ? this.__netstream.seek(0) : this.__netstream.resume();
		};
		public function reset():void {
			if (!this.__media) return;
			this.__status.hq = false;
			this.__reset();
		};
		public function resize(floatHeight:Number, floatWidth:Number):void {
			if (!this.__status.ready) return;
			if (isNaN(floatHeight)) return;
			if (floatHeight < 0) return;
			if (isNaN(floatWidth)) return;
			if (floatWidth < 0) return;
			this.__status.height = floatHeight;
			this.__status.width = floatWidth;
			this.__resize();
		};
	};
};