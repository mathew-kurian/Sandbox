/**
 * AudioPlayer
 * MP3 Audio player
 *
 * @version		3.0
 */
package _project.classes {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import fl.transitions.TweenEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	//
	import _project.classes.IDecoder;
	import _project.classes.IPlayer;
	import _project.classes.XPlayerEvent;
	//
	public class AudioPlayer extends Sprite implements IPlayer {
		//constants...
		private const __COMPATIBLES:Array = [ "mp3" ];
		private const __FADEOUTPARAMS:Object = { duration: 5, transition: Strong.easeOut, useseconds: true, volume: 0 };
		private const __FXPARAMS:Object = { duration: 2, transition: Strong.easeIn, useseconds: true, volume: 0 };
		private const __MEDIATYPE:String = "AUDIO MP3";
		//private vars...
		private var __controls:Object = { display: true, mute: true, pause: true, play: true, repeat: true, seekbar: true, view: true, volume: true };
		private var __fx:Object;
		private var __media:Sound;
		private var __status:Object;
		private var __timer:Timer;
		private var __urldecoders:Array;
		//
		//constructor...
		public function AudioPlayer(boolFadeOut:Boolean = false, arrayURLDecoders:Array = undefined) {
			this.__status = { autostart: true, context: new SoundLoaderContext(1000, false), decoder: undefined, duration: 0, end: false, fadeout: Boolean(boolFadeOut), fx: true, 
							  hq: false, id3: undefined, mediaisavailable: false, playing: false, plugin: undefined, progress: { bytesloaded: 0, bytestotal: 0 }, 
							  position: 0, ready: false, repeat: false, soundchannel: undefined, source: undefined, url: undefined, volume: 1 };
			this.__timer = new Timer(10);
			this.__urldecoders = new Array();
			if (arrayURLDecoders is Array) {
				for (var j:int = 0; j < arrayURLDecoders.length; j++) {
					if (arrayURLDecoders[j] is IDecoder) this.__urldecoders.push(arrayURLDecoders[j]);
				};
			};
			this.__status.decoder = this.__urldecoders.length;
			this.__fx = { volume: 0, tween: undefined };
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
		private function __decode(strURL:String):void {
			this.__status.source = (this.__status.decoder < this.__urldecoders.length) ? { fileextension: "", filename: this.__urldecoders[this.__status.decoder].mediatype, url: strURL } : this.__urlsplitter(strURL);
			this.__status.url = new URLRequest(strURL);
			this.__media = new Sound();
			this.__media.addEventListener(Event.COMPLETE, this.__onComplete);
			this.__media.addEventListener(Event.ID3, this.__onId3);
			this.__media.addEventListener(IOErrorEvent.IO_ERROR, this.__onIoError);
			this.__media.addEventListener(Event.OPEN, this.__onOpen);
			this.__media.addEventListener(ProgressEvent.PROGRESS, this.__onProgress);
			this.__media.load(this.__status.url, this.__status.context);
			try {
				this.__status.plugin.load("");
			}
			catch (_error:Error) {
				//...
			};
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
				this.__fx.tween.removeEventListener(TweenEvent.MOTION_CHANGE, this.__onFxChange);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__fx.tween.removeEventListener(TweenEvent.MOTION_FINISH, this.__onFxFinish);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__fx.tween.removeEventListener(TweenEvent.MOTION_FINISH, this.__onFadeOutFinish);
			}
			catch (_error:Error) {
				//...
			};
			delete this.__fx.tween;
		};
		private function __onComplete(event:Event):void {
			this.__status.duration = this.__media.length;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_BUFFERING_STOP));
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
		private function __onFadeOutFinish(event:TweenEvent):void {
			this.__destroytween();
			this.__pause();
		};
		private function __onFxChange(event:TweenEvent):void {
			this.__status.soundchannel.soundTransform = new SoundTransform(this.__fx.volume, 0);
		};
		private function __onFxFinish(event:TweenEvent):void {
			this.__destroytween();
		};
		private function __onId3(event:Event):void {
			try {
				this.__status.id3 = { };
				for (var i in this.__media.id3) {
					this.__status.id3[i] = this.__media.id3[i];
				};
				this.__status.id3.comment = (this.__status.id3.COMM) ? this.__status.id3.COMM : "";
				this.__status.id3.album = (this.__status.id3.TALB) ? this.__status.id3.TALB : "";
				this.__status.id3.genre = (this.__status.id3.TCON) ? this.__status.id3.TCON : "";
				this.__status.id3.songName = (this.__status.id3.TIT2) ? this.__status.id3.TIT2 : "";
				this.__status.id3.artist = (this.__status.id3.TPE1) ? this.__status.id3.TPE1 : "";
				this.__status.id3.track = (this.__status.id3.TRCK) ? this.__status.id3.TRCK : "";
				this.__status.id3.year = (this.__status.id3.TYER) ? this.__status.id3.TYER : "";
			}
			catch (_error:Error) {
				//...
			};
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_INFO));
		};
		private function __onIoError(event:IOErrorEvent):void {
			this.__status.error = event;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_BUFFERING_STOP));
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_ERROR));
		};
		private function __onOpen(event:Event):void {
			this.__status.mediaisavailable = true;
			try {
				this.__status.plugin.resize(this.__status.plugin.height, this.__status.plugin.width);
			}
			catch (_error:Error) {
				//...
			};
			if (this.__status.autostart) this.play();
			this.__addlistener(this.__timer, TimerEvent.TIMER, this.__onTimer);
			this.__timer.start();
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_BUFFERING_START));
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_READY));
		};
		private function __onProgress(event:ProgressEvent):void {
			this.__status.progress.bytesloaded = event.bytesLoaded;
			this.__status.progress.bytestotal = event.bytesTotal;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_BUFFERING_START));
		};
		private function __onSoundComplete(event:Event):void {
			this.__destroytween();
			if (this.__status.repeat) {
				if (this.__status.playing) this.__play(0)
				else {
					this.__status.end = true;
					this.__pause();
				};
			}
			else {
				this.__status.end = true;
				this.__pause();
				this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_END));
			};
		};
		
		private function __onTimer(event:TimerEvent):void {
			if (this.__status.duration > 0) {
				try {
					this.__timer.stop();
					this.__timer.removeEventListener(TimerEvent.TIMER, this.__onTimer);
				}
				catch (_error:Error) {
					//...
				};
			}
			else {
				if (!this.__status.context) return;
				if (isNaN(this.__status.context.bufferTime)) return;
				if (this.__media.bytesLoaded <= 0) return;
				if (!this.__status.soundchannel) return;
				this.__status.position = this.__status.soundchannel.position;
				if (this.__status.position > 0) {
					this.__status.duration = this.__status.context.bufferTime * this.__media.bytesTotal / this.__media.bytesLoaded;
				};
			};
		};
		private function __pause():void {
			this.__status.playing = false;
			this.__status.soundchannel.stop();
			try {
				this.__status.plugin.pause();
			}
			catch (_error:Error) {
				//...
			};
		};
		private function __play(floatStart:Number):void {
			if (this.__status.soundchannel) {
				this.__status.soundchannel.stop();
				this.__removelistener(this.__status.soundchannel, Event.SOUND_COMPLETE, this.__onSoundComplete);
				delete this.__status.soundchannel;
			};
			this.__status.position = floatStart;
			if (this.__status.playing) {
				var _volume:Number = (this.__status.soundchannel is SoundChannel) ? this.__status.soundchannel.soundTransform.volume : 0;
				try {
					this.__status.soundchannel = this.__media.play(floatStart);
					this.__addlistener(this.__status.soundchannel, Event.SOUND_COMPLETE, this.__onSoundComplete);
					if (this.__status.fx) {
						this.__destroytween();
						this.__status.soundchannel.soundTransform = new SoundTransform(_volume, 0);
						this.__fx.tween = new Tween(this.__fx, "volume", this.__FXPARAMS.transition, _volume, this.__status.volume, this.__FXPARAMS.duration, this.__FXPARAMS.useseconds);
						this.__addlistener(this.__fx.tween, TweenEvent.MOTION_CHANGE, this.__onFxChange);
						this.__addlistener(this.__fx.tween, TweenEvent.MOTION_FINISH, this.__onFxFinish);
					}
					else this.__status.soundchannel.soundTransform = new SoundTransform(this.__status.volume, 0);
				}
				catch (_error:Error) {
					//...
				};
				try {
					this.__status.plugin.play(this.__status.soundchannel);
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
		private function __reset():void {
			if (!this.__status) return;
			if (this.__status.fx) this.__destroytween();
			try {
				this.__status.soundchannel.stop();
			}
			catch (_error:Error) {
				//...
			};
			this.__removelistener(this.__media, Event.COMPLETE, this.__onComplete);
			this.__removelistener(this.__media, Event.ID3, this.__onId3);
			this.__removelistener(this.__media, IOErrorEvent.IO_ERROR, this.__onIoError);
			this.__removelistener(this.__media, Event.OPEN, this.__onOpen);
			this.__removelistener(this.__media, ProgressEvent.PROGRESS, this.__onProgress);
			try {
				this.__media.close();
			}
			catch (_error:Error) {
				//...
			};
			for (var i:int = 0; i < this.__urldecoders.length; i++) {
				this.__urldecoders[i].reset();
				this.__removelistener(this.__urldecoders[i], Event.COMPLETE, this.__onDecoderComplete);
				this.__removelistener(this.__urldecoders[i], IOErrorEvent.IO_ERROR, this.__onDecoderIOError);
				this.__removelistener(this.__urldecoders[i], SecurityErrorEvent.SECURITY_ERROR, this.__onDecoderSecurityError);
			};
			this.__status.decoder = this.__urldecoders.length;
			//
			this.__status.duration = 0;
			this.__status.end = false;
			this.__status.hq = false;
			this.__status.id3 = undefined;
			this.__status.mediaisavailable = false;
			this.__status.playing = false;
			this.__status.position = 0;
			delete this.__status.soundchannel;
			delete this.__status.source;
			delete this.__status.url;
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
			if (!this.__status.plugin) return undefined;
			return this.__status.plugin.align;
		};
		public function set align(strAlign:String):void {
			try {
				this.__status.plugin.align = strAlign;
			}
			catch (_error:Error) {
				//...
			};
		};
		public function get alignlogo():String {
			if (!this.__media) return undefined;
			if (!this.__status.plugin) return undefined;
			return this.__status.plugin.logoalign.id;
		};
		public function set alignlogo(strAlign:String):void {
			if (!this.__media) return;
			if (!this.__status.plugin) return;
			this.__status.plugin.logoalign = strAlign;
		};
		public override function get alpha():Number {
			if (!this.__status.plugin) return undefined;
			return this.__status.plugin.alpha;
		};
		public override function set alpha(floatAlpha:Number):void {
			try {
				this.__status.plugin.alpha = floatAlpha;
			}
			catch (_error:Error) {
				//...
			};
		};
		public function get aspectRatio():Boolean {
			if (!this.__status.plugin) return undefined;
			return this.__status.plugin.aspectRatio;
		};
		public function set aspectRatio(boolAspectratio:Boolean):void {
			try {
				this.__status.plugin.aspectRatio = boolAspectratio;
			}
			catch (_error:Error) {
				//...
			};
		};
		public function get autoStart():Boolean {
			if (!this.__status) return undefined;
			return this.__status.autostart;
		};
		public function set autoStart(boolAutostart:Boolean):void {
			if (!this.__status) return;
			if (!(boolAutostart is Boolean)) return;
			this.__status.autostart = boolAutostart;
		};
		public function get buffering():Object {
			if (!this.__media) return { };
			return { bytesLoaded: this.__media.bytesLoaded, bytesTotal: this.__media.bytesTotal,
					 bufferLength: undefined, bufferTime: 0.001 * this.__status.context.bufferTime };
		};
		public function get bufferTime():Number {
			if (!this.__status) return undefined;
			try {
				return 0.001 * this.__status.context.bufferTime;
			}
			catch (_error) {
				//...
			};
			return undefined;
		};
		public function set bufferTime(floatBuffer:Number):void {
			if (!this.__status) return;
			if (isNaN(floatBuffer)) return;
			if (floatBuffer < 0) return;
			var _check:Boolean = (this.__status.context is SoundLoaderContext) ? this.__status.context.checkPolicyFile : false;
			this.__status.context = new SoundLoaderContext(1000 * floatBuffer, _check);
		};
		public override function get cacheAsBitmap():Boolean {
			try {
				return this.__status.plugin.cacheAsBitmap;
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public override function set cacheAsBitmap(boolCacheAsBitmap:Boolean):void {
			try {
				this.__status.plugin.cacheAsBitmap = boolCacheAsBitmap;
			}
			catch (_error:Error) {
				//...
			};
		};
		public function get context():* {
			return this.__status.context;
		};
		public function set context(loaderContext:*):void {
			if (!this.__status) return;
			if (loaderContext is SoundLoaderContext) this.__status.context = loaderContext;
		};
		public function get controls():Object {
			if (!this.__status) return undefined;
			if (!this.__status) return undefined;
			if (this.__status.mediaisavailable) return { buffer: true, display: true, mediainfo: true, btnmute: true, btnpause: true, btnplay: true, btnrepeat: true, seekbar: true, btnview: true, volumebar: true };
			return { buffer: false, display: false, mediainfo: false, btnmute: false, btnpause: false, btnplay: false, btnrepeat: false, seekbar: false, btnview: false, volumebar: false };
		};
		public function get current():Number {
			if (!this.__media) return undefined;
			if (this.__status.soundchannel) {
				if (this.__status.playing) this.__status.position = this.__status.soundchannel.position;
			};
			if (!this.__timer.running) {
				if (this.__status.position > this.__status.duration) this.__status.duration = this.__status.position;
			};
			return this.__status.position / this.__status.duration;
		};
		public function set current(floatCurrent:Number):void {
			if (!this.__media) return;
			if (isNaN(floatCurrent)) return;
			if (floatCurrent < 0) return;
			if (floatCurrent > this.__media.bytesLoaded / this.__media.bytesTotal) floatCurrent = this.__media.bytesLoaded / this.__media.bytesTotal;
			this.__status.end = false;
			this.__play(floatCurrent * this.__status.duration);
			if (this.__status.plugin) {
				//...
			};
		};
		public function get duration():Number {
			if (!this.__media) return 0;
			return 0.001 * this.__status.duration;
		};
		public override function get height():Number {
			if (!this.__status.plugin) return undefined;
			return this.__status.height;
		};
		public override function set height(floatHeight:Number):void {
			//blind...
		};
		public function get loaded():Number {
			if (!this.__media) return 0;
			return this.__media.bytesLoaded / this.__media.bytesTotal;
		};
		public override function get mask():DisplayObject {
			try {
				return this.__status.plugin.mask;
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public override function set mask(objMask:DisplayObject):void {
			if (!this.__status.plugin) return;
			this.__status.plugin.mask = objMask;
		};
		public function get mediaEnd():Boolean {
			if (!this.__media) return undefined;
			return this.__status.end;
		};
		public function get mediaInfo():Object {
			if (!this.__media) return undefined;
			var _info:Object = { };
			for (var i in this.__status.source) _info[i] = this.__status.source[i];
			if (this.__status.id3) {
				for (var j in this.__status.id3) _info[j] = this.__status.id3[j];
			};
			return _info;
		};
		public function get mediaMetrics():Object {
			if (!this.__status.plugin) return undefined;
			return this.__status.plugin.mediaMetrics;
		};
		public function get mediaType():String {
			return ((this.__media) ? this.__MEDIATYPE : "");
		};
		public function get playing():Boolean {
			if (!this.__media) return false;
			return this.__status.playing;
		};
		public function get plugin():IPlayer {
			if (!this.__status) return undefined;
			return this.__status.plugin;
		};
		public function set plugin(objPlugin:IPlayer):void {
			if (!this.__status) return;
			this.__status.plugin = objPlugin;
			if (this.__status.playing) {
				//.......................................
			};
		};
		public function get ready():Boolean {
			return this.__status.ready;
		};
		public function get repeat():Boolean {
			if (!this.__status) return undefined;
			return this.__status.repeat;
		};
		public function set repeat(boolRepeat:Boolean):void {
			if (!this.__status) return;
			if (!(boolRepeat is Boolean)) return;
			this.__status.repeat = boolRepeat;
		};
		public override function get rotation():Number {
			if (!this.__status.plugin) return undefined;
			return this.__status.plugin.rotation;
		};
		public override function set rotation(floatRotation:Number):void {
			//blind...
		};
		public override function get scaleX():Number {
			if (!this.__status.plugin) return undefined;
			return this.__status.plugin.scaleX;
		};
		public override function set scaleX(floatScaleX:Number):void {
			//blind...
		};
		public override function get scaleY():Number {
			if (!this.__status.plugin) return undefined;
			return this.__status.plugin.scaleY;
		};
		public override function set scaleY(floatScaleY:Number):void {
			//blind...
		};
		public function get smoothing():Boolean {
			if (!this.__status.plugin) return undefined;
			return this.__status.plugin.smoothing;
		};
		public function set smoothing(boolSmoothing:Boolean):void {
			try {
				this.__status.plugin.smoothing = boolSmoothing;
			}
			catch (_error:Error) {
				//...
			};
		};
		public function get snapshot():Object {
			try {
				return this.__status.plugin.snapshot;
			}
			catch (_error:Error) {
				//...
			};
			return { bitmapdata: undefined, x: 0, y: 0 };
		};
		public function get time():Number {
			if (!this.__media) return undefined;
			if (this.__status.soundchannel) {
				if (this.__status.playing) this.__status.position = this.__status.soundchannel.position;
			};
			if (!this.__timer.running) {
				if (this.__status.position > this.__status.duration) this.__status.duration = this.__status.position;
			};
			return 0.001 * this.__status.position;
		};
		public function set time(floatTime:Number):void {
			if (!this.__media) return;
			if (isNaN(floatTime)) return;
			if (floatTime < 0) return;
			floatTime *= 1000;
			if (floatTime > this.__status.duration) floatTime = this.__status.duration;
			this.__status.end = false;
			this.__play(floatTime);
			if (!this.__status.plugin) return;
			//...
		};
		public function get ttl():Number {
			if (!this.__media) return undefined;
			return 0.001 * this.__status.duration;
		};
		public function set ttl(floatTTL:Number):void {
			//blind...
		};
		public override function get visible():Boolean {
			if (!this.__status.plugin) return undefined;
			return this.__status.plugin.visible;
		};
		public override function set visible(boolVisible:Boolean):void {
			try {
				this.__status.plugin.visible = boolVisible;
			}
			catch (_error:Error) {
				//...
			};
		};
		public function get volume():Number {
			try {
				return this.__status.soundchannel.soundTransform.volume;
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public function set volume(floatVolume:Number):void {
			if (isNaN(floatVolume)) return;
			if (floatVolume < 0) floatVolume = 0
			if (floatVolume > 1) floatVolume = 1;
			this.__destroytween();
			this.__status.volume = floatVolume;
			if (this.__status.soundchannel) this.__status.soundchannel.soundTransform = new SoundTransform(floatVolume, 0);
		};
		public function get wallpaper():Boolean {
			if (this.__status.plugin) {
				try {
					return this.__status.plugin.wallpaper;
				}
				catch (_error:Error) {
					//...
				};
			};
			return false;
		};
		public function set wallpaper(boolWallpaper:Boolean):void {
			//blind...
		};
		public override function get width():Number {
			if (!this.__status.plugin) return undefined;
			return this.__status.plugin.width;
		};
		public override function set width(floatWidth:Number):void {
			//blind...
		};
		public override function get x():Number {
			if (!this.__status.plugin) return undefined;
			return this.__status.plugin.x;
		};
		public override function set x(floatX:Number):void {
			//blind...
		};
		public override function get y():Number {
			if (!this.__status.plugin) return undefined;
			return this.__status.plugin.y;
		};
		public override function set y(floatY:Number):void {
			//blind...
		};
		//
		//public methods...
		public override function getBounds(targetCoordinateSpace:DisplayObject):Rectangle {
			if (!this.__status.plugin) return undefined;
			return this.__status.plugin.getBounds(targetCoordinateSpace);
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
				for (var j in this.__COMPATIBLES) {
					if (strURL == this.__COMPATIBLES[j]) return true;
				};
			};
			return false;
		};
		public function load(strURL:String, boolHighQuality:Boolean = false):Boolean {
			if (!(strURL is String)) return false;
			if (strURL == "") return false;
			this.__reset();
			for (var i:int = 0; i < this.__urldecoders.length; i++) {
				this.__addlistener(this.__urldecoders[i], Event.COMPLETE, this.__onDecoderComplete);
				this.__addlistener(this.__urldecoders[i], IOErrorEvent.IO_ERROR, this.__onDecoderIOError);
				this.__addlistener(this.__urldecoders[i], SecurityErrorEvent.SECURITY_ERROR, this.__onDecoderSecurityError);
			};
			this.__status.decoder = 0;
			this.__status.hq = boolHighQuality;
			while (this.__status.decoder < this.__urldecoders.length && !this.__urldecoders[this.__status.decoder].decode(strURL)) this.__status.decoder++;
			if (this.__status.decoder >= this.__urldecoders.length) this.__decode(strURL);
			return true;
		};
		public function pause():void {
			if (!this.__status.soundchannel) return;
			if (!this.__status.playing) return;
			//
			if (this.__status.fadeout) {
				this.__destroytween();
				var _duration:Number = 0.001 * (this.__status.duration - this.__status.soundchannel.position);
				if (this.__FADEOUTPARAMS.duration < _duration) _duration = this.__FADEOUTPARAMS.duration;
				if (_duration > 0) {
					this.__fx.tween = new Tween(this.__fx, "volume", this.__FADEOUTPARAMS.transition, this.__status.soundchannel.soundTransform.volume, 0, _duration, this.__FADEOUTPARAMS.useseconds);
					this.__addlistener(this.__fx.tween, TweenEvent.MOTION_CHANGE, this.__onFxChange);
					this.__addlistener(this.__fx.tween, TweenEvent.MOTION_FINISH, this.__onFadeOutFinish);
				}
				else this.__pause();
			}
			else this.__pause();
		};
		public function play(soundChannel:SoundChannel = undefined):void {
			if (!this.__media) return;
			if (this.__fx.tween) {
				this.__destroytween();
				this.__status.playing = false;
			};
			if (this.__status.playing) return;
			this.__status.playing = true;
			this.__play((this.__status.end) ? 0 : this.__status.position);
			this.__status.end = false;
		};
		public function reset():void {
			if (!this.__media) return;
			this.__reset();
			try {
				this.__status.plugin.reset();
			}
			catch (_error:Error) {
				//...
			};
			delete this.__status.plugin;
		};
		public function resize(floatHeight:Number, floatWidth:Number):void {
			//blind...
		};
	};
};