/**
 * SwfPlayer
 * SWF files & Flash compatible image files player
 *
 * @version		2.0
 */
package _project.classes {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import fl.transitions.TweenEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.utils.Timer;
	//
	import _project.classes.IDecoder;
	import _project.classes.IPlayer;
	import _project.classes.XPlayerEvent;
	//
	public class SwfPlayer extends Sprite implements IPlayer {
		//constants...
		private const __KALIGN:Array = [ { id: "", x: 0.5, y: 0.5 }, { id: "T", x: 0.5, y: 0 }, { id: "B", x: 0.5, y: 1 }, { id: "L", x: 0, y: 0.5 }, { id: "R", x: 1, y: 0.5 }, 
										{ id: "TL", x: 0, y: 0 }, { id: "TR", x: 1, y: 0 }, { id: "BL", x: 0, y: 1 }, { id: "BR", x: 1, y: 1 } ];
		private const __KALIGN_MEDIA:int = 4;
		private const __KALIGN_LOGO:int = 5;
		private const __KBLEND_MODE:Object = { border: BlendMode.ADD };
		private const __KCOMPATIBLES:Array = [ "gif", "jpg", "png", "swf" ];
		private const __KFXPARAMS:Object = { duration: 2, scale: 1.5, transition: Strong.easeOut, useseconds: true };
		private const __KLOGOALPHA:Number = 0.67;
		private const __KONUNLOAD:String = "onRemove";
		private const __KVIGNETTING:Object = { distance: 0, angle: 45, strength: 1, quality: 1, inner: true, knockout: false, hideObject: true };
		private const __KWALLPAPERBKG:Boolean = true;
		private const __KWALLPAPERPARAMS:Object = { alpha: 1, color: 0x000000, duration: 3, transition: Strong.easeOut, useseconds: true };
		//private vars...
		private var __bkg:*;
		private var __bkgpattern:BitmapData;
		private var __border:Bitmap;
		private var __borderpattern:BitmapData;
		private var __controls:Object = { display: true, mute: true, pause: true, play: true, repeat: true, seekbar: true, view: true, volume: true };
		private var __cursor:DisplayObject;
		private var __fx:Object;
		private var __generic:BitmapData;
		private var __loader:Loader;
		private var __logo:Bitmap;
		private var __logodefault:BitmapData;
		private var __mask:Sprite;
		private var __media:*;
		private var __status:Object;
		private var __urldecoders:Array;
		private var __vignetting:Bitmap;
		private var __wallpaper:Object;
		private var __wallpaperbkg:Sprite;
		//
		//constructor...
		public function SwfPlayer(fCursor:Function = undefined, Bkg:* = undefined, objVignetting:Object = undefined, objBorder:Object = undefined, bdLogo:BitmapData = undefined, arrayURLDecoders:Array = undefined) {
			if (bdLogo is BitmapData) this.__logodefault = bdLogo;
			this.__fx = { refX: 1, refY: 1, scale: 1, tween: undefined };
			this.__loader = new Loader();
			this.__loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.__onInit);
			this.__loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.__onIoError);
			this.__loader.contentLoaderInfo.addEventListener(Event.OPEN, this.__onOpen);
			this.__loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.__onProgress);
			this.__loader.contentLoaderInfo.addEventListener(Event.UNLOAD, this.__onUnload);
			if ((Bkg is MovieClip) || (Bkg is BitmapData) || !isNaN(Bkg)) this.__status.bkgfill = Bkg;
			this.__wallpaper = { tweenX: undefined, tweenY: undefined };
			this.__wallpaperbkg = new Sprite();
			this.__wallpaperbkg.graphics.beginFill(this.__KWALLPAPERPARAMS.color, this.__KWALLPAPERPARAMS.alpha);
			this.__wallpaperbkg.graphics.drawRect(0, 0, 200, 200);
			this.__wallpaperbkg.graphics.endFill();
			this.__wallpaperbkg.height = 0;
			this.__wallpaperbkg.width = 0;
			this.__wallpaperbkg = Sprite(this.addChild(this.__wallpaperbkg));
			this.__mask = new Sprite();
			this.addChild(this.__mask);
			this.__generic = new BitmapData(200, 100, false, 0xFFFF0000);
			//
			this.__status = { align: this.__KALIGN[this.__KALIGN_MEDIA], alignlogo: this.__KALIGN[this.__KALIGN_LOGO], aspectratio: true, autostart: true, 
							  bkgfill: undefined, borderblendmode: BlendMode.ADD, borderfill: 0xFF000000, borderfilters: [], borderoffset: 0, borderthick: 0, 
							  context: null, cursor: (fCursor is Function) ? fCursor : undefined, decoder: undefined, end: false, frame: 0, fx: true, height: 0, hq: false, 
							  imagescale: false, mediatype: "", playing: false, progress: { bytesloaded: 0, bytestotal: 0 }, 
							  ready: false, repeat: false, reset: false, smoothing: true, source: undefined, swfscale: false, ttl: 0, _ttl: 0, url: undefined, 
							  vignettingalpha: 0.25, vignettingblur: 0, vignettingcolor: 0x000000, 
							  volume: 1, wallpaper: false, width: 0 };
			if (this.__status.bkgfill is MovieClip) this.__bkg = MovieClip(this.addChild(this.__status.bkgfill))
			else if (this.__status.bkgfill is BitmapData) {
				this.__bkg = Bitmap(new Bitmap());
				this.__bkgpattern = this.__pattern(this.__status.bkgfill, Capabilities.screenResolutionY, Capabilities.screenResolutionX);
			}
			else if (!isNaN(this.__status.bkgfill)) this.__bkg = Bitmap(new Bitmap());
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
			if (this.__status.borderthick > 0 && this.__status.borderfill is BitmapData) this.__borderpattern = this.__pattern(this.__status.borderfill, Capabilities.screenResolutionY, Capabilities.screenResolutionX);
			this.__urldecoders = new Array();
			if (arrayURLDecoders is Array) {
				for (var j:int = 0; j < arrayURLDecoders.length; j++) {
					if (arrayURLDecoders[j] is IDecoder) this.__urldecoders.push(arrayURLDecoders[j]);
				};
			};
			this.__status.decoder = this.__urldecoders.length;
			this.__status.ready = true;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.INIT));
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
		private function __align():Object {
			return ((this.__status.wallpaper) ? this.__KALIGN[0] : this.__status.align);
		};
		private function __decode(strURL:String):void {
			this.__status.reset = false;
			if (this.__status.decoder < this.__urldecoders.length) {
				this.__status.source = { fileextension: "", filename: this.__urldecoders[this.__status.decoder].mediatype, url: strURL };
			}
			else this.__status.source = this.__urlsplitter(strURL);
			this.__status.url = new URLRequest(strURL);
			this.__loader.load(this.__status.url, this.__status.context);
		};
		private function __onAdded(event:Event):void {
			this.__status.mediaisavailable = true;
			this.__removelistener(event.currentTarget, Event.ADDED, this.__onAdded);
			this.__logo = Bitmap(this.addChild(new Bitmap()));
			this.__logo.alpha = this.__KLOGOALPHA;
			this.__logo.bitmapData = (this.__status.decoder < this.__urldecoders.length) ? this.__urldecoders[this.__status.decoder].logo : this.__logodefault;
			this.__logo.visible = true;
			this.__status.mediatype = this.__loader.contentLoaderInfo.contentType.toUpperCase();
			if (this.__loader.contentLoaderInfo.contentType == "application/x-shockwave-flash") {
				this.__media = MovieClip(this.__loader.content);
				this.__media.soundTransform = new SoundTransform(this.__status.volume, 0);
				if (this.__media.totalFrames > 1) {
					if (!this.__status.autostart) this.__media.stop();
					this.__status.playing = this.__status.autostart;
					this.__addlistener(this.__mask, Event.ENTER_FRAME, this.__onEnterFrameTimeline);
				}
				else {
					this.__status.playing = true;
					this.__addlistener(this.__mask, Event.ENTER_FRAME, this.__onEnterFrame);
				};
			}
			else {
				this.__media = Bitmap(this.__loader.content);
				this.__media.smoothing = this.__status.smoothing;
				this.__addlistener(this.__mask, Event.ENTER_FRAME, this.__onEnterFrame);
			};
			var _bounds:Rectangle = this.__media.getBounds(this.__media);
			this.__mask.graphics.clear();
			this.__mask.graphics.beginFill(0x000000);
			this.__mask.graphics.drawRect(0, 0, _bounds.right, _bounds.bottom);
			this.__mask.graphics.endFill();
			this.__media.mask = this.__mask;
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
			};
			this.__wallpaperbkg.visible = true;
			if (this.__status.fx && (this.__media is Bitmap)) {
				this.__fx.tween = new Tween(this.__fx, "scale", this.__KFXPARAMS.transition, this.__KFXPARAMS.scale, 1, this.__KFXPARAMS.duration, this.__KFXPARAMS.useseconds);
				this.__addlistener(this.__fx.tween, TweenEvent.MOTION_CHANGE, this.__onFxChange);
				this.__addlistener(this.__fx.tween, TweenEvent.MOTION_FINISH, this.__onFxFinish);
			};
			if (this.__status.cursor is Function) {
				this.__cursor = this.addChild(this.__status.cursor());
				this.__cursor.visible = false;
				this.__cursor.x = this.mouseX;
				this.__cursor.y = this.mouseY;
				var _timer:Timer = new Timer(10);
				_timer.addEventListener(TimerEvent.TIMER, this.__onTimer);
				_timer.start();
			};
			this.__resize();
			if (this.__vignetting is Bitmap) this.__vignetting.visible = true;
			if (this.__border is Bitmap) this.__border.visible = true;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_READY));
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_INFO));
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
		private function __onEnterFrame(event:Event):void {
			this.__status.frame++;
			if (this.__status.frame >= this.__status.ttl) {
				this.__removelistener(this.__mask, Event.ENTER_FRAME, this.__onEnterFrame);
				if (this.__media is MovieClip) {
					if (this.__status.repeat) this.__status.frame = 0
					else {
						this.__status.end = true;
						this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_END));
					};
				}
				else {
					this.__status.end = true;
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_END));
				};
			};
		};
		private function __onEnterFrameTimeline(event:Event):void {
			if (this.__status.end) return;
			if (!this.__status.repeat) {
				if (this.__media.currentFrame == this.__media.totalFrames) {
					this.__media.stop();
					this.__status.playing = false;
					this.__status.end = true;
					this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_END));
				};
			};
		};
		private function __onFxChange(event:TweenEvent):void {
			this.__media.scaleX = this.__fx.scale * this.__fx.refX;
			this.__media.scaleY = this.__fx.scale * this.__fx.refY;
		};
		private function __onFxFinish(event:TweenEvent):void {
			this.__removelistener(this.__fx.tween, TweenEvent.MOTION_CHANGE, this.__onFxChange);
			this.__removelistener(this.__fx.tween, TweenEvent.MOTION_FINISH, this.__onFxFinish);
			if (this.__media is Bitmap) {
				this.__addlistener(this, MouseEvent.CLICK, this.__onMouseClick);
				this.__addlistener(this, MouseEvent.MOUSE_MOVE, this.__onMouseMove);
				this.buttonMode = true;
				if (this.__cursor) {
					this.__cursor.visible = true;
					this.__cursor.x = this.mouseX;
					this.__cursor.y = this.mouseY;
				};
				if (this.__status.wallpaper) {
					this.__addlistener(this, MouseEvent.MOUSE_OUT, this.__onMouseOut);
					this.__addlistener(this, MouseEvent.MOUSE_OVER, this.__onMouseOver);
				};
			};
		};
		private function __onInit(event:Event):void {
			if (this.__status.reset) return;
			this.__addlistener(event.currentTarget.content, Event.ADDED, this.__onAdded);
			this.addChild(event.currentTarget.content);
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_BUFFERING_STOP));
		};
		private function __onIoError(event:IOErrorEvent):void {
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_BUFFERING_STOP));
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
		};
		private function __onMouseClick(event:MouseEvent):void {
			if (this != event.currentTarget) return;
			if (!this.buttonMode) return;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_CLICK));
		};
		private function __onMouseMove(event:MouseEvent):void {
			if (this != event.currentTarget) return;
			if (this.__status.wallpaper) {
				var _newX:Number = this.__mask.x + (this.__mask.width - this.__media.width) * this.mouseX / this.__mask.width;
				if (_newX > this.__mask.x) _newX = this.__mask.x
				else if (_newX < this.__mask.x + this.__mask.width - this.__media.width) _newX = this.__mask.x + this.__mask.width - this.__media.width;
				var _newY:Number = this.__mask.y + (this.__mask.height - this.__media.height) * this.mouseY / this.__mask.height;
				if (_newY > this.__mask.y) _newY = this.__mask.y
				else if (_newY < this.__mask.y + this.__mask.height - this.__media.height) _newY = this.__mask.y + this.__mask.height - this.__media.height;
				if (!this.__wallpaper.tweenX) this.__wallpaper.tweenX = new Tween(this.__media, "x", this.__KWALLPAPERPARAMS.transition, this.__media.x, _newX, this.__KWALLPAPERPARAMS.duration, this.__KWALLPAPERPARAMS.useseconds)
				else this.__wallpaper.tweenX.continueTo(_newX, this.__KWALLPAPERPARAMS.duration);
				if (!this.__wallpaper.tweenY) this.__wallpaper.tweenY = new Tween(this.__media, "y", this.__KWALLPAPERPARAMS.transition, this.__media.y, _newY, this.__KWALLPAPERPARAMS.duration, this.__KWALLPAPERPARAMS.useseconds)
				else this.__wallpaper.tweenY.continueTo(_newY, this.__KWALLPAPERPARAMS.duration);
			}
			else {
				if (this.mouseX < this.__mask.x) this.buttonMode = false
				else if (this.mouseX > this.__mask.x + this.__mask.width) this.buttonMode = false
				else if (this.mouseY < this.__mask.y) this.buttonMode = false
				else if (this.mouseY > this.__mask.y + this.__mask.height) this.buttonMode = false
				else this.buttonMode = true;
			};
			if (this.__cursor) {
				this.__cursor.visible = this.buttonMode;
				if (this.__cursor.visible) {
					this.__cursor.x = this.mouseX;
					this.__cursor.y = this.mouseY;
				};
			};
		};
		private function __onMouseOut(event:MouseEvent):void {
			if (this != event.currentTarget) return;
			this.__removelistener(this, MouseEvent.MOUSE_MOVE, this.__onMouseMove);
			if (this.__cursor) this.__cursor.visible = false;
		};
		private function __onMouseOver(event:MouseEvent):void {
			if (this != event.currentTarget) return;
			this.__addlistener(this, MouseEvent.MOUSE_MOVE, this.__onMouseMove);
			if (this.__cursor) {
				this.__cursor.visible = this.buttonMode;
				this.__cursor.x = this.mouseX;
				this.__cursor.y = this.mouseY;
			};
		};
		private function __onOpen(event:Event):void {
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_BUFFERING_START));
		};
		private function __onProgress(event:ProgressEvent):void {
			this.__status.progress.bytesloaded = event.bytesLoaded;
			this.__status.progress.bytestotal = event.bytesTotal;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_BUFFERING_START));
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
		private function __onUnload(event:Event):void {
			//...
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
			this.__removelistener(this.__mask, Event.ENTER_FRAME, this.__onEnterFrame);
			this.__removelistener(this.__mask, Event.ENTER_FRAME, this.__onEnterFrameTimeline);
			this.__removelistener(this, MouseEvent.CLICK, this.__onMouseClick);
			this.__removelistener(this, MouseEvent.MOUSE_MOVE, this.__onMouseMove);
			this.__removelistener(this, MouseEvent.MOUSE_OUT, this.__onMouseOut);
			this.__removelistener(this, MouseEvent.MOUSE_OVER, this.__onMouseOver);
			try {
				this.__removelistener(this.__loader.contentLoaderInfo.content, Event.ADDED, this.__onAdded);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__media[this.__KONUNLOAD]();
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
				this.removeChild(this.__cursor);
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
			try {
				this.removeChild(this.__logo);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.removeChild(this.__vignetting);
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
				this.removeChild(this.__border);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__fx.tween.stop();
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__wallpaper.tweenX.stop();
				delete this.__wallpaper.tweenX;
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__wallpaper.tweenY.stop();
				delete this.__wallpaper.tweenY;
			}
			catch (_error:Error) {
				//...
			};
			this.__cursor = undefined;
			this.__media = undefined;
			this.__logo = undefined;
			this.__vignetting = undefined;
			this.__border = undefined;
			this.__wallpaperbkg.visible = false;
			for (var i:int = 0; i < this.__urldecoders.length; i++) {
				this.__urldecoders[i].reset();
				this.__removelistener(this.__urldecoders[i], Event.COMPLETE, this.__onDecoderComplete);
				this.__removelistener(this.__urldecoders[i], IOErrorEvent.IO_ERROR, this.__onDecoderIOError);
				this.__removelistener(this.__urldecoders[i], SecurityErrorEvent.SECURITY_ERROR, this.__onDecoderSecurityError);
			};
			this.__status.decoder = this.__urldecoders.length;
			//
			this.__fx.scale = 1;
			this.__status.decoder = undefined;
			this.__status.end = false;
			this.__status.frame = 0;
			this.__status.hq = false;
			this.__status.mediaisavailable = false;
			this.__status.mediatype = "";
			this.__status.playing = false;
			this.__status.progress.bytesloaded = this.__status.progress.bytestotal = 0;
			if (this.stage is Stage) this.__status.ttl = Math.round(this.__status._ttl * this.stage.frameRate);
			delete this.__status.source;
			delete this.__status.url;
			this.buttonMode = false;
		};
		private function __resize():void {
			if (!this.__media) return;
			try {
				this.__wallpaper.tweenX.stop();
				delete this.__wallpaper.tweenX;
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__wallpaper.tweenY.stop();
				delete this.__wallpaper.tweenY;
			}
			catch (_error:Error) {
				//...
			};
			//
			var _scaleX:Number;
			var _scaleY:Number;
			var _validborder:Boolean = (this.__border is Bitmap && (!this.__status.wallpaper || !(this.__media is Bitmap)) && !this.__KWALLPAPERBKG);
			if (_validborder) {
				if (this.__media is Bitmap) _validborder = !this.__status.wallpaper;
			};
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
			var _aspectratio:Boolean = this.__status.aspectratio || (this.__status.wallpaper && (this.__media is Bitmap))
			if (_aspectratio) {
				if ((this.__media is MovieClip) || !this.__status.wallpaper) _scaleX = _scaleY = Math.min(this.__mask.scaleY * _h / this.__mask.height, this.__mask.scaleX * _w / this.__mask.width)
				else _scaleX = _scaleY = Math.max(this.__mask.scaleY * _h / this.__mask.height, this.__mask.scaleX * _w / this.__mask.width);
				if ((this.__media is Bitmap) && this.__status.wallpaper && _scaleX < 1) _scaleX = _scaleY = 1;
			}
			else {
				_scaleX = this.__mask.scaleX * _w / this.__mask.width;
				_scaleY = this.__mask.scaleY * _h / this.__mask.height;
			};
			var _scaleup:Boolean = (this.__media is MovieClip) ? !this.__status.swfscale : !this.__status.imagescale;
			if (_scaleup) {
				if (_scaleX > 1) _scaleX = 1;
				if (_scaleY > 1) _scaleY = 1;
			};
			var _scale:Number = this.__mask.scaleX * _w / this.__mask.width;
			this.__mask.scaleX = (_scaleX > _scale) ? _scale : _scaleX;
			_scale = this.__mask.scaleY * _h / this.__mask.height;
			this.__mask.scaleY = (_scaleY > _scale) ? _scale : _scaleY;
			this.__media.x = this.__mask.x;
			this.__media.y = this.__mask.y;
			this.__media.scaleX = _scaleX;
			this.__media.scaleY = _scaleY;
			//
			if (this.__media is MovieClip) {
				this.__fx.refX = Math.max(this.__mask.scaleX, this.__mask.scaleY);
				this.__fx.refY = this.__media.scaleY * this.__fx.refX / this.__media.scaleX;
			}
			else {
				this.__fx.refX = _scaleX;
				this.__fx.refY = _scaleY;
			};
			if (this.__vignetting is Bitmap) {
				try {
					this.__vignetting.bitmapData.dispose();
				}
				catch (_error:Error) {
					//...
				};
				try {
					this.__vignetting.bitmapData = new BitmapData(this.__mask.width, this.__mask.height, false);
				}
				catch (_error:Error) {
					//...
				};
				this.__vignetting.x = this.__mask.x;
				this.__vignetting.y = this.__mask.y;
			};
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
			};
			if (this.__border is Bitmap) {
				try {
					this.__border.bitmapData.dispose();
				}
				catch (_error:Error) {
					//...
				};
				if (_validborder) {
					_h = Math.ceil(this.__mask.height + _bordert);
					_w = Math.ceil(this.__mask.width + _bordert);
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
					this.__border.x = Math.round(this.__mask.x - _bordert);
					this.__border.y = Math.round(this.__mask.y - _bordert);
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
			return this.__status.align.id;
		};
		public function set align(strAlign:String):void {
			if (!(strAlign is String)) return;
			strAlign = strAlign.toUpperCase();
			for (var i in this.__KALIGN) {
				if (strAlign == this.__KALIGN[i].id) {
					this.__status.align = this.__KALIGN[i];
					if (!this.__media) return;
					var _validborder:Boolean = (this.__border is Bitmap);
					if (_validborder) {
						if (this.__media is Bitmap) _validborder = !this.__status.wallpaper;
					};
					var _bordert:Number = ((_validborder)) ? this.__status.borderthick + this.__status.borderoffset : 0;
					if (_bordert > 0) {
						this.__media.x = this.__mask.x = _bordert + this.__align().x * (this.__status.width - this.__mask.width - 2 * _bordert);
						this.__media.y = this.__mask.y = _bordert + this.__align().y * (this.__status.height - this.__mask.height - 2 * _bordert);
					}
					else {
						this.__media.x = this.__mask.x = this.__align().x * (this.__status.width - this.__mask.width);
						this.__media.y = this.__mask.y = this.__align().y * (this.__status.height - this.__mask.height);
					};
					if (this.__logo.bitmapData is BitmapData) {
						this.__logo.x = this.__mask.x + this.__status.alignlogo.x * (this.__mask.width - this.__logo.width);
						this.__logo.y = this.__mask.y + this.__status.alignlogo.y * (this.__mask.height - this.__logo.height);
					};
					if (this.__vignetting is Bitmap) {
						this.__vignetting.x = this.__mask.x;
						this.__vignetting.y = this.__mask.y;
					};
					if (_validborder) {
						if (this.__border is Bitmap) {
							this.__border.x = Math.round(this.__mask.x - _bordert);
							this.__border.y = Math.round(this.__mask.y - _bordert);
						};
					};
					return;
				};
			};
		};
		public function get alignlogo():String {
			if (!this.__media) return undefined;
			return this.__status.logoalign.id;
		};
		public function set alignlogo(strAlign:String):void {
			if (!(strAlign is String)) return;
			strAlign = strAlign.toUpperCase();
			for (var i in this.__KALIGN) {
				if (strAlign == this.__KALIGN[i].id) {
					this.__status.alignlogo = this.__KALIGN[i];
					if (!this.__media) return;
					if (this.__logo.bitmapData is BitmapData) {
						this.__logo.x = this.__mask.x + this.__status.alignlogo.x * (this.__mask.width - this.__logo.width);
						this.__logo.y = this.__mask.y + this.__status.alignlogo.y * (this.__mask.height - this.__logo.height);
					};
					break;
				};
			};
		};
		public function get aspectRatio():Boolean {
			return this.__status.aspectratio;
		};
		public function set aspectRatio(boolAspectratio:Boolean):void {
			if (!(boolAspectratio is Boolean)) return;
			this.__status.aspectratio = boolAspectratio;
			this.__resize();
		};
		public function get autoStart():Boolean {
			return this.__status.autostart;
		};
		public function set autoStart(boolAutostart:Boolean):void {
			if (!(boolAutostart is Boolean)) return;
			this.__status.autostart = boolAutostart;
		};
		public function get buffering():Object {
			if (!this.__media) return { };
			return { bytesLoaded: this.__loader.contentLoaderInfo.bytesLoaded, bytesTotal: this.__loader.contentLoaderInfo.bytesTotal,
					 bufferLength: undefined, bufferTime: undefined };
		};
		public function get bufferTime():Number {
			return undefined;
		};
		public function set bufferTime(floatBuffer:Number):void {
			//blind...
		};
		public function get context():* {
			return this.__status.context;
		};
		public function set context(loaderContext:*):void {
			if (loaderContext is LoaderContext) this.__status.context = loaderContext;
		};
		public function get controls():Object {
			if (this.__status.mediaisavailable) {
				var _sound:Boolean = (this.__media is MovieClip) ? true : false;
				return (this.duration > 0) ? { buffer: false, display: true, mediainfo: true, btnmute: true, btnpause: true, btnplay: true, btnrepeat: true, seekbar: true, btnview: true, volumebar: true } :
											 { buffer: false, display: false, mediainfo: _sound, btnmute: _sound, btnpause: false, btnplay: false, btnrepeat: false, seekbar: false, btnview: true, volumebar: _sound };
			}
			else return { display: false, btnmute: false, btnpause: false, btnplay: false, btnrepeat: false, seekbar: false, btnview: false, volumebar: false };
		};
		public function get current():Number {
			if (isNaN(this.duration)) return undefined;
			return this.__media.currentFrame / this.__media.totalFrames;
		};
		public function set current(floatCurrent:Number):void {
			if (isNaN(this.duration)) return;
			if (isNaN(floatCurrent)) return;
			if (floatCurrent < 0) return;
			if (floatCurrent > 1) return;
			this.__status.end = false;
			floatCurrent = Math.round(floatCurrent * this.__media.totalFrames);
			if (floatCurrent < 1) floatCurrent = 1;
			(this.__status.playing) ? this.__media.gotoAndPlay(floatCurrent) : this.__media.gotoAndStop(floatCurrent);
		};
		public function get duration():Number {
			if (!(this.stage is Stage)) return undefined;
			return ((this.__media is MovieClip) ? (this.__media.totalFrames - 1) / this.stage.frameRate : 0);
		};
		public override function get height():Number {
			return this.__status.height;
		};
		public override function set height(floatHeight:Number):void {
			if (!this.__status.ready) return;
			if (isNaN(floatHeight)) return;
			if (floatHeight < 0) return;
			this.__status.height = floatHeight;
			this.__resize();
		};
		public function get loaded():Number {
			if (!this.__media) return 0;
			return 1;
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
					 height: this.__mask.height, scaleX: this.__mask.scaleX, scaleY: this.__mask.scaleY, width: this.__mask.width, x: this.__mask.x, y: this.__mask.y,
					 wallpaperHeight: this.__wallpaperbkg.height, wallpaperWidth: this.__wallpaperbkg.width, wallpaperX: this.__wallpaperbkg.x, wallpaperY: this.__wallpaperbkg.y };
		};
		public function get mediaType():String {
			return this.__status.mediatype;
		};
		public function get playing():Boolean {
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
			return this.__status.repeat;
		};
		public function set repeat(boolRepeat:Boolean):void {
			if (!(boolRepeat is Boolean)) return;
			this.__status.repeat = boolRepeat;
		};
		public function get smoothing():Boolean {
			return this.__status.smoothing;
		};
		public function set smoothing(boolSmoothing:Boolean):void {
			if (!(boolSmoothing is Boolean)) return;
			if (this.__status.smoothing != boolSmoothing) {
				this.__status.smoothing = boolSmoothing;
				if (this.__media is Bitmap) this.__media.smoothing = boolSmoothing;
			};
		};
		public function get snapshot():Object {
			if (!this.__media) return { bitmapdata: undefined, x: 0, y: 0 };
			var _snapshot:BitmapData;
			var snapX:Number = 0, snapY:Number = 0;
			if (this.__wallpaperbkg.visible) {
				_snapshot = new BitmapData(this.__wallpaperbkg.width, this.__wallpaperbkg.height, true, 0x00000000);
				_snapshot.draw(this.__wallpaperbkg, new Matrix(this.__wallpaperbkg.scaleX, 0, 0, this.__wallpaperbkg.scaleY, 0, 0));
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
			if (this.__loader.contentLoaderInfo.sameDomain) {
				var _container:BitmapData = new BitmapData(this.__status.width, this.__status.height, true, 0x00000000);
				_container.draw(this);
				_snapshot.copyPixels(_container, new Rectangle(this.__mask.x, this.__mask.y, this.__mask.width, this.__mask.height), new Point(this.__mask.x - snapX, this.__mask.y - snapY));
			}
			else {
				_snapshot.fillRect(new Rectangle(snapX, snapY, this.__mask.width, this.__mask.height), 0x00000000);
				_snapshot.copyPixels(this.__generic, new Rectangle(0, 0, this.__generic.width, this.__generic.height), new Point(this.__mask.x - snapX + 0.5 * (this.__mask.width - this.__generic.width), this.__mask.y - snapY + 0.5 * (this.__mask.height - this.__generic.height)));
			};
			return { bitmapdata: _snapshot, x: snapX, y: snapY };
		};
		public function get time():Number {
			if (!(this.stage is Stage)) return undefined;
			if (!this.__media) return undefined;
			if (this.duration <= 0) return 0;
			return (this.__media.currentFrame - 1) / this.stage.frameRate;
		};
		public function set time(floatTime:Number):void {
			if (!(this.stage is Stage)) return;
			if (!this.__media) return;
			if (isNaN(floatTime)) return;
			if (floatTime < 0) return;
			floatTime = Math.round(floatTime * this.stage.frameRate) + 1;
			if (floatTime > this.__media.totalFrames) floatTime = this.__media.totalFrames;
			(this.__status.playing) ? this.__media.gotoAndPlay(floatTime) : this.__media.gotoAndStop(floatTime);
		};
		public function get ttl():Number {
			return ((this.duration > 0) ? this.duration : this.__status._ttl);
		};
		public function set ttl(floatTTL:Number):void {
			if (isNaN(floatTTL)) return;
			if (floatTTL < 0) return;
			this.__status._ttl = floatTTL;
			if (this.stage is Stage) this.__status.ttl = Math.round(floatTTL * this.stage.frameRate);
		};
		public function get volume():Number {
			try {
				return this.__media.soundTransform.volume;
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public function set volume(floatVolume:Number):void {
			if (!(this.__media is MovieClip)) return;
			if (isNaN(floatVolume)) return;
			if (floatVolume < 0) floatVolume = 0
			if (floatVolume > 1) floatVolume = 1;
			this.__status.volume = floatVolume;
			this.__media.soundTransform = new SoundTransform(floatVolume, 0);
		};
		public function get wallpaper():Boolean {
			try {
				return (this.__status.wallpaper && !(this.__media is MovieClip));
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
			if (this.__media is Bitmap) {
				this.__removelistener(this, MouseEvent.MOUSE_MOVE, this.__onMouseMove);
				this.__removelistener(this, MouseEvent.MOUSE_OUT, this.__onMouseOut);
				this.__removelistener(this, MouseEvent.MOUSE_OVER, this.__onMouseOver);
				this.buttonMode = this.__status.wallpaper;
				try {
					MovieClip(this.__cursor).setCursor(!this.__status.wallpaper);
				}
				catch (_error:Error) {
					//...
				};
				this.__fx.tween.stop();
				this.__resize();
				this.__fx.scale = this.__KFXPARAMS.scale;
				this.__fx.tween = new Tween(this.__fx, "scale", this.__KFXPARAMS.transition, this.__KFXPARAMS.scale, 1, this.__KFXPARAMS.duration, this.__KFXPARAMS.useseconds);
				this.__addlistener(this.__fx.tween, TweenEvent.MOTION_CHANGE, this.__onFxChange);
				this.__addlistener(this.__fx.tween, TweenEvent.MOTION_FINISH, this.__onFxFinish);
			}
			else this.buttonMode = false;
			if (this.__cursor) this.__cursor.visible = false;
			this.dispatchEvent(new Event(Event.RESIZE));
		};
		public override function get width():Number {
			return this.__status.width;
		};
		public override function set width(floatWidth:Number):void {
			if (!this.__status.ready) return;
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
			if (!(strURL is String)) return false;
			if (strURL == "") return false;
			this.__status.reset = true;
			this.__reset();
			for (var i:int = 0; i < this.__urldecoders.length; i++) {
				this.__addlistener(this.__urldecoders[i], Event.COMPLETE, this.__onDecoderComplete);
				this.__addlistener(this.__urldecoders[i], IOErrorEvent.IO_ERROR, this.__onDecoderIOError);
				this.__addlistener(this.__urldecoders[i], SecurityErrorEvent.SECURITY_ERROR, this.__onDecoderSecurityError);
			};
			this.__status.hq = Boolean(boolHighQuality);
			this.__status.decoder = 0;
			while (this.__status.decoder < this.__urldecoders.length && !this.__urldecoders[this.__status.decoder].decode(strURL)) this.__status.decoder++;
			if (this.__status.decoder >= this.__urldecoders.length) this.__decode(strURL);
			return true;
		};
		public function pause():void {
			if (!this.__media) return;
			if (!this.__status.playing) return;
			var d:Number = this.duration;
			if (isNaN(d)) return;
			if (d <= 0) return;
			//
			this.__status.playing = false;
			this.__media.stop();
		};
		public function play(soundChannel:SoundChannel = undefined):void {
			if (!this.__media) return;
			if (this.__status.playing) return;
			var d:Number = this.duration;
			if (isNaN(d)) return;
			if (d <= 0) return;
			//
			this.__status.end = false;
			this.__status.playing = true;
			this.__media.play();
		};
		public function reset():void {
			this.__status.reset = true;
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