/**
 * SpectrumPlayer
 * Spectrum Analyzer for Audio sources...
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
	import flash.errors.EOFError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	import flash.system.Capabilities;
	import flash.system.Security;
	//
	import _project.classes.IPlayer;
	import _project.classes.XPlayerEvent;
	//
	public class SpectrumPlayer extends Sprite implements IPlayer {
		//constants...
		private const __KALIGN:Array = [ { id: "", x: 0.5, y: 0.5 }, { id: "T", x: 0.5, y: 0 }, { id: "B", x: 0.5, y: 1 }, { id: "L", x: 0, y: 0.5 }, { id: "R", x: 1, y: 0.5 }, 
										 { id: "TL", x: 0, y: 0 }, { id: "TR", x: 1, y: 0 }, { id: "BL", x: 0, y: 1 }, { id: "BR", x: 1, y: 1 } ];
		private const __KALIGN_MEDIA:int = 4;
		private const __KALIGN_LOGO:int = 5;
		private const __KBANDCORNER:Number = 4;
		private const __KBANDHEIGHT:Number = 4;
		private const __KBANDS:int = 32;
		private const __KBLEND_MODE:Object = { border: BlendMode.ADD, spectrum: BlendMode.NORMAL };
		private const __KBLURFILTER:BlurFilter = new BlurFilter(2, 4, 1);
		private const __KCMR:Number = 0.88;
		private const __KCOLORS:Object = { band: [0x04A0FD, 0xDDCCFF], peak: [0xFF4422, 0xFD04A0] };
		private const __KINTERSPACE:Number = 2;
		private const __KLOGOALPHA:Number = 0.67;
		private const __KMAX:Object = { height: 340, width: 800 };
		private const __KMEDIATYPE:String = "AUDIO SPECTRUM";
		private const __KOVERLAY:Object = { argb: 0x22000000, visible: false };
		private const __KPADDING:Number = 8;
		private const __KVIGNETTING:Object = { distance: 0, angle: 45, strength: 1, quality: 1, inner: true, knockout: false, hideObject: true };
		//private vars...
		private var __a:Number = 0;
		private var __amplitude:Number;
		private var __array:Array;
		private var __bandwidth:Number;
		private var __bkg:*;
		private var __bkgpattern:BitmapData;
		private var __border:Bitmap;
		private var __borderpattern:BitmapData;
		private var __bmp:Bitmap;
		private var __bytearray:ByteArray = new ByteArray();
		private var __colorband:uint;
		private var __colorindex:int;
		private var __colormatrix:ColorMatrixFilter;
		private var __colorpeak:uint;
		private var __count:int = 0;
		private var __cursor:MovieClip;
		private var __logo:Bitmap;
		private var __mainbmp:BitmapData;
		private var __mainrect:Rectangle;
		private var __origin:Point = new Point(0, 0);
		private var __overlay:Bitmap;
		private var __overlaypattern:BitmapData;
		private var __spectrum:Sprite;
		private var __status:Object;
		private var __vignetting:Bitmap;
		//
		//constructor...
		public function SpectrumPlayer(mcCursor:MovieClip = undefined, Bkg:* = undefined, objVignetting:Object = undefined, objBorder:Object = undefined, bdLogo:BitmapData = undefined, objColors:Object = undefined) {
			this.__amplitude = 0.5 * this.__KMAX.height - 2 * this.__KPADDING;
			this.__bandwidth = (this.__KMAX.width - 2 * this.__KPADDING - (this.__KBANDS - 1) * this.__KINTERSPACE) / this.__KBANDS;
			this.__colormatrix = new ColorMatrixFilter( [ this.__KCMR, 0, 0, 0, 2,
														  0, this.__KCMR, 0, 0, 3,
														  0, 0, this.__KCMR, 0,4,
														  0, 0, 0, 0.92, 0 ] );
			this.__status = { align: this.__KALIGN[this.__KALIGN_MEDIA], alignlogo: this.__KALIGN[this.__KALIGN_LOGO], aspectratio: true,
							  bkgfill: undefined, borderfill: 0xFF000000, borderfilters: [], borderoffset: 0, borderthick: 0, height: this.__KMAX.height, 
							  playing: false, ready: false, spectrumblendmode: BlendMode.ADD,
							  vignettingalpha: 0.25, vignettingblur: 0, vignettingcolor: 0x000000, width: this.__KMAX.width };
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
			if (this.__status.borderthick > 0 && this.__status.borderfill is BitmapData) this.__borderpattern = this.__pattern(this.__status.borderfill, Capabilities.screenResolutionY, Capabilities.screenResolutionX);
			if (objColors) {
				if (objColors.band is Array) {
					if (objColors.band.length > 0) {
						this.__KCOLORS.band = [];
						for (var j:int = 0; j < objColors.band.length; j++) this.__KCOLORS.band.push(objColors.band[j]);
					};
				};
				if (objColors.peak is Array) {
					if (objColors.peak.length > 0) {
						this.__KCOLORS.peak = [];
						for (var k:int = 0; k < this.__KCOLORS.band.length; k++) {
							if (k < objColors.band.length) this.__KCOLORS.peak.push(objColors.peak[k])
							else this.__KCOLORS.peak.push(this.__KCOLORS.peak[0]);
						};
					};
				};
			};
			this.__colorband = this.__KCOLORS.band[this.__colorindex];
			this.__colorpeak = this.__KCOLORS.peak[this.__colorindex];
			if (this.__status.bkgfill is MovieClip) this.__bkg = MovieClip(this.addChild(this.__status.bkgfill))
			else if (this.__status.bkgfill is BitmapData) {
				this.__bkg = Bitmap(new Bitmap());
				this.__bkgpattern = this.__pattern(this.__status.bkgfill, Capabilities.screenResolutionY, Capabilities.screenResolutionX);
			}
			else if (!isNaN(this.__status.bkgfill)) this.__bkg = Bitmap(new Bitmap());
			this.__spectrum = Sprite(this.addChild(new Sprite()));
			this.__spectrum.blendMode = this.__KBLEND_MODE.spectrum;
			this.__spectrum.visible = false;
			this.__spectrum.buttonMode = true;
			this.__overlay = Bitmap(this.addChild(new Bitmap()));
			this.__overlay.visible = false;
			if (this.__KOVERLAY.visible) {
				var _unit:BitmapData = new BitmapData(10, 4, true, 0x00000000);
				_unit.fillRect(new Rectangle(0, 0, 4, 1), this.__KOVERLAY.argb);
				_unit.fillRect(new Rectangle(5, 1, 1, 1), this.__KOVERLAY.argb);
				_unit.fillRect(new Rectangle(5, 3, 1, 1), this.__KOVERLAY.argb);
				_unit.fillRect(new Rectangle(6, 2, 4, 1), this.__KOVERLAY.argb);
				_unit.fillRect(new Rectangle(9, 1, 1, 1), this.__KOVERLAY.argb);
				_unit.fillRect(new Rectangle(9, 3, 1, 1), this.__KOVERLAY.argb);
				this.__overlaypattern = this.__pattern(_unit, this.__KMAX.height, this.__KMAX.width);
				_unit.dispose();
				this.__overlay.bitmapData = this.__pattern(this.__overlaypattern, this.__KMAX.height, this.__KMAX.width);
			};
			this.__logo = Bitmap(this.addChild(new Bitmap()));
			this.__logo.alpha = this.__KLOGOALPHA;
			if (bdLogo is BitmapData) this.__logo.bitmapData = bdLogo;
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
			this.__mainbmp = new BitmapData(this.__KMAX.width, this.__KMAX.height, true, 0x00000000);
			this.__bmp = new Bitmap(this.__mainbmp);
			this.__spectrum.addChildAt(this.__bmp, 0);
			this.__mainrect = new Rectangle(0, 0, this.__KMAX.width, this.__KMAX.height);
			if (mcCursor is MovieClip) {
				this.__cursor = MovieClip(this.addChild(mcCursor));
				this.__cursor.visible = false;
			};
			this.__addlistener(this.__spectrum, MouseEvent.CLICK, this.__onMouseClick);
			this.__addlistener(this.__spectrum, MouseEvent.ROLL_OUT, this.__onRollOut);
			this.__addlistener(this.__spectrum, MouseEvent.ROLL_OVER, this.__onRollOver);
			//
			this.__reset();
			this.__status.ready = true;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.INIT));
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_READY));
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
		private function __onMouseClick(event:MouseEvent):void {
			this.__colorindex++;
			if (this.__colorindex >= this.__KCOLORS.band.length) this.__colorindex = 0;
			this.__colorband = this.__KCOLORS.band[this.__colorindex];
			this.__colorpeak = this.__KCOLORS.peak[this.__colorindex];
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_CLICK));
		};
		private function __onMouseMove(event:MouseEvent):void {
			this.__cursor.x = this.mouseX;
			this.__cursor.y = this.mouseY;
		};
		private function __onRollOut(event:MouseEvent):void {
			try {
				this.__spectrum.removeEventListener(MouseEvent.MOUSE_MOVE, this.__onMouseMove);
			}
			catch (_error:Error) {
				//...
			};
			this.__cursor.visible = false;
		};
		private function __onRollOver(event:MouseEvent):void {
			this.__addlistener(this.__spectrum, MouseEvent.MOUSE_MOVE, this.__onMouseMove);
			this.__cursor.visible = true;
		};
		private function __onSpectrum(event:Event):void {
			if (++this.__count % 2 == 0) {
				try {
					SoundMixer.computeSpectrum(this.__bytearray, true, 0);
				}
				catch (_error:Error) {
					//...
				};
				this.__a = 0;
				this.__spectrum.graphics.clear();
				var _coordX:Number = this.__KPADDING;
				var _peakX:Number = _coordX;
				var _peakY:Number = this.__amplitude + this.__mainbmp.height / 2;
				var _step:int = Math.round(256 / this.__KBANDS);
				for (var i:Number = 0; i < 256; i += _step) {
					try {
						this.__a = this.__bytearray.readFloat();
					}
					catch (_error:EOFError) {
						this.__a = 0;
					};
					if (isNaN(this.__a)) this.__a = 0;
					var _y:Number = -this.__a * this.__amplitude;
					var _coordY:Number = _y + this.__amplitude + (this.__mainbmp.height / 2);
					this.__spectrum.graphics.beginFill(this.__colorband | (this.__a * 200 << 8), (_y == 0) ? Math.pow(Math.random(), 2) : 1);
					this.__spectrum.graphics.drawRoundRect(_coordX, _coordY, this.__bandwidth, this.__KBANDHEIGHT, this.__KBANDCORNER, this.__KBANDCORNER);
					if (_peakY > _coordY) {
						_peakX = _coordX;
						_peakY = _coordY;
					};
					_coordX += this.__bandwidth + this.__KINTERSPACE;
				};
				this.__spectrum.graphics.beginFill(this.__colorpeak);
				this.__spectrum.graphics.drawRoundRect(_peakX, _peakY, this.__bandwidth, this.__KBANDHEIGHT, this.__KBANDCORNER, this.__KBANDCORNER);
				this.__mainbmp.draw(this.__spectrum);
				this.__mainbmp.applyFilter(this.__mainbmp, this.__mainrect,this.__origin, this.__KBLURFILTER);
				this.__mainbmp.applyFilter(this.__mainbmp, this.__mainrect, this.__origin, this.__colormatrix);
				//
				this.__bmp = new Bitmap(this.__mainbmp);
				this.__spectrum.addChildAt(this.__bmp, 0);
				var child:DisplayObject;
				try {
					child = this.__spectrum.getChildAt(1);
				}
				catch (_error:Error) {
					//...
				};
				if (child) {
					if (this.__count > 2) this.__spectrum.removeChildAt(1);
				};
			};
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
		private function __reset():void {
			this.__status.playing = false;
			this.__spectrum.visible = false;
			this.__overlay.visible = false;
			try {
				this.__vignetting.visible = false;
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
			this.__logo.visible = false;
			this.__logo.x = this.__logo.y = 0;
		};
		private function __resize():void {
			var _scaleX:Number;
			var _scaleY:Number;
			var _bordert:Number = (this.__border is Bitmap) ? 2 * (this.__status.borderthick + this.__status.borderoffset) : 0;
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
			if (this.__status.aspectratio) _scaleX = _scaleY = Math.min(_h / this.__KMAX.height, _w / this.__KMAX.width)
			else {
				_scaleX = _w / this.__KMAX.width;
				_scaleY = _h / this.__KMAX.height;
			};
			if (_scaleX > 1) _scaleX = 1;
			if (_scaleY > 1) _scaleY = 1;
			this.__spectrum.scaleX = _scaleX;
			this.__spectrum.scaleY = _scaleY;
			try {
				this.__overlay.bitmapData.dispose();
			}
			catch (_error:Error) {
				//...
			};
			try {
				if (this.__KOVERLAY.visible) this.__overlay.bitmapData = this.__pattern(this.__overlaypattern, this.__spectrum.height, this.__spectrum.width);
			}
			catch (_error:Error) {
				//...
			};
			if (this.__vignetting is Bitmap) {
				try {
					this.__vignetting.bitmapData.dispose();
				}
				catch (_error:Error) {
					//...
				};
				try {
					this.__vignetting.bitmapData = new BitmapData(this.__spectrum.width, this.__spectrum.height, false);
				}
				catch (_error:Error) {
					//...
				};
				this.__vignetting.x = this.__spectrum.x;
				this.__vignetting.y = this.__spectrum.y;
			};
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
				try {
					this.__border.bitmapData.dispose();
				}
				catch (_error:Error) {
					//...
				};
				_h = Math.ceil(this.__spectrum.height + _bordert);
				_w = Math.ceil(this.__spectrum.width + _bordert);
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
				this.__border.x = this.__spectrum.x;
				this.__border.y = this.__spectrum.y;
			};
			this.align = this.align;
			this.dispatchEvent(new XPlayerEvent(XPlayerEvent.MEDIA_RESIZE));
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
					//
					var _bordert:Number = (this.__border is Bitmap) ? this.__status.borderthick + this.__status.borderoffset : 0;
					if (_bordert > 0) {
						this.__spectrum.x = _bordert + this.__status.align.x * (this.__status.width - this.__spectrum.width - 2 * _bordert);
						this.__spectrum.y = _bordert + this.__status.align.y * (this.__status.height - this.__spectrum.height - 2 * _bordert);
					}
					else {
						this.__spectrum.x = this.__status.align.x * (this.__status.width - this.__spectrum.width);
						this.__spectrum.y = this.__status.align.y * (this.__status.height - this.__spectrum.height);
					};
					this.__overlay.x = this.__spectrum.x;
					this.__overlay.y = this.__spectrum.y;
					if (this.__logo.bitmapData is BitmapData) {
						this.__logo.x = this.__spectrum.x + this.__status.alignlogo.x * (this.__spectrum.width - this.__logo.width);
						this.__logo.y = this.__spectrum.y + this.__status.alignlogo.y * (this.__spectrum.height - this.__logo.height);
					};
					if (this.__vignetting is Bitmap) {
						this.__vignetting.x = this.__spectrum.x;
						this.__vignetting.y = this.__spectrum.y;
					};
					if (this.__border is Bitmap) {
						this.__border.x = Math.round(this.__spectrum.x - _bordert);
						this.__border.y = Math.round(this.__spectrum.y - _bordert);
					};
					return;
				};
			};
		};
		public function get alignlogo():String {
			return this.__status.logoalign.id;
		};
		public function set alignlogo(strAlign:String):void {
			if (!(strAlign is String)) return;
			strAlign = strAlign.toUpperCase();
			for (var i in this.__KALIGN) {
				if (strAlign == this.__KALIGN[i].id) {
					this.__status.align = this.__KALIGN[i];
					if (this.__logo.bitmapData is BitmapData) {
						this.__logo.x = this.__spectrum.x + this.__status.alignlogo.x * (this.__spectrum.width - this.__logo.width);
						this.__logo.y = this.__spectrum.y + this.__status.alignlogo.y * (this.__spectrum.height - this.__logo.height);
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
			return true;
		};
		public function set autoStart(boolAutostart:Boolean):void {
			//blind...
		};
		public function get buffering():Object {
			return { };
		};
		public function get bufferTime():Number {
			return undefined;
		};
		public function set bufferTime(floatBuffer:Number):void {
			//blind...
		};
		public function get context():* {
			return null;
		};
		public function set context(loaderContext:*):void {
			//blind...
		};
		public function get controls():Object {
			return { buffer: false, display: false, mediainfo: false, btnmute: false, btnpause: false, btnplay: false, btnrepeat: false, seekbar: false, btnview: true, volumebar: false };
		};
		public function get current():Number {
			return 0;
		};
		public function set current(floatCurrent:Number):void {
			//blind...
		};
		public function get duration():Number {
			return 0;
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
			return 1;
		};
		public function get mediaEnd():Boolean {
			return false;
		};
		public function get mediaInfo():Object {
			return { fileextension: "", filename: "", url: "" };
		};
		public function get mediaMetrics():Object {
			var _borderoffset:Number;
			var _borderthick:Number;
			if (this.__border is Bitmap) {
				_borderoffset = this.__status.borderoffset;
				_borderthick = this.__status.borderthick;
			}
			else _borderoffset = _borderthick = 0;
			return { borderOffset: _borderoffset, borderThick: _borderthick, 
					 height: this.__spectrum.height, scaleX: this.__spectrum.scaleX, scaleY: this.__spectrum.scaleY, width: this.__spectrum.width, x: this.__spectrum.x, y: this.__spectrum.y,
					 wallpaperHeight: 0, wallpaperWidth: 0, wallpaperX: 0, wallpaperY: 0 };
		};
		public function get mediaType():String {
			return this.__KMEDIATYPE;
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
			return true;
		};
		public function set repeat(boolRepeat:Boolean):void {
			//blind...
		};
		public function get smoothing():Boolean {
			return this.__status.smoothing;
		};
		public function set smoothing(boolSmoothing:Boolean):void {
			//blind...
		};
		public function get snapshot():Object {
			if (!this.__spectrum) return { bitmapdata: undefined, x: 0, y: 0 };
			var _container:BitmapData = new BitmapData(this.__status.width, this.__status.height, true, 0x00000000);
			_container.draw(this);
			var snapH:Number = this.__spectrum.height / this.__spectrum.scaleY;
			var snapW:Number = this.__spectrum.width / this.__spectrum.scaleX;
			var snapX:Number = this.__spectrum.x;
			var snapY:Number = this.__spectrum.y;
			if (this.__border is Bitmap) {
				if (this.__border.bitmapData is BitmapData) {
					if (this.__border.height > snapH) {
						snapH = this.__border.height;
						snapW = this.__border.width;
						snapX = this.__border.x;
						snapY = this.__border.y;
					};
				};
			};
			var _snapshot:BitmapData = new BitmapData(snapW, snapH, true, 0x00000000);
			_snapshot.copyPixels(_container, new Rectangle(snapX, snapY, snapW, snapH), new Point(0, 0));
			return { bitmapdata: _snapshot, x: snapX, y: snapY };
		};
		public function get time():Number {
			return 0;
		};
		public function set time(floatTime:Number):void {
			//blind...
		};
		public function get ttl():Number {
			return 0;
		};
		public function set ttl(floatTTL:Number):void {
			//blind...
		};
		public function get volume():Number {
			return 1;
		};
		public function set volume(floatVolume:Number):void {
			//blind...
		};
		public function get wallpaper():Boolean {
			return false;
		};
		public function set wallpaper(boolWallpaper:Boolean):void {
			//blind...
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
			var _cornerTL:Point;
			var _cornerBR:Point;
			if (this.__bkg) {
				_cornerTL = targetCoordinateSpace.globalToLocal(this.localToGlobal(new Point(0, 0)));
				_cornerBR = targetCoordinateSpace.globalToLocal(this.localToGlobal(new Point((this.__bkg.visible) ? this.__status.width : 0, (this.__bkg.visible) ? this.__status.height : 0)));
			}
			else {
				var _offset:Number = (this.__border is Bitmap) ? this.__status.borderoffset + this.__status.borderthick : 0;
				if (_offset < 0) _offset = 0;
				//
				_cornerTL = targetCoordinateSpace.globalToLocal(this.localToGlobal(new Point(this.__spectrum.x - _offset, this.__spectrum.y - _offset)));
				_cornerBR = targetCoordinateSpace.globalToLocal(this.localToGlobal(new Point(this.__spectrum.x + this.__spectrum.width + _offset, this.__spectrum.y + this.__spectrum.height + _offset)));
			};
			//
			return new Rectangle(_cornerTL.x, _cornerTL.y, _cornerBR.x - _cornerTL.x, _cornerBR.y - _cornerTL.y);
		};
		public override function getRect(targetCoordinateSpace:DisplayObject):Rectangle {
			return this.getBounds(targetCoordinateSpace);
		};
		public function iscompatible(strURL:String):Boolean {
			return false;
		};
		public function load(strURL:String, boolHighQuality:Boolean = false):Boolean {
			return true;
		};
		public function pause():void {
			this.__status.playing = false;
		};
		public function play(soundChannel:SoundChannel = undefined):void {
			this.__status.playing = true;
			this.__addlistener(this.__spectrum, Event.ENTER_FRAME, this.__onSpectrum);
			this.__spectrum.visible = true;
			this.__overlay.visible = true;
			try {
				this.__vignetting.visible = true;
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__border.visible = true;
			}
			catch (_error:Error) {
				//...
			};
			this.__logo.visible = true;
		};
		public function reset():void {
			this.__reset();
			try {
				this.removeEventListener(Event.ENTER_FRAME, this.__onSpectrum);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__spectrum.visible = false;
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__overlay.visible = false;
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
				this.__bkg.visible = false;
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__border.visible = false;
			}
			catch (_error:Error) {
				//...
			};
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