/**
 * HInfoGallery
 * Horizontal gallery with info presentation
 *
 * @version		2.0
 */
package _project.classes	{
	use namespace AS3;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TextEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	//
	import _project.classes.GalleryEvent;
	import _project.classes.HGallery;
	import _project.classes.ITransition;
	import _project.classes.StyleSheets;
	import _project.classes.ThumbSource;
	import _project.classes.TxtField;
	//
	public class HInfoGallery extends Sprite {
		//private constants...
		protected const __KHEIGHT:Number = 340;
		private const __KHTML:Object = { thumb: { begin: "<img src='", end: "' />" }, title: { begin: "<span class='title'>", end: "</span><br /><br />" }, body: { begin: "<body>", end: "</body>" } };
		protected const __KIMG:Object = { height: 340, width: 240 };
		protected const __KOFFSET:Object = { left: 10, top: 0 };
		protected const __KWIDTH:Number = 470;
		//private vars...
		protected var __hgallery:HGallery;
		protected var __img:Bitmap;
		protected var __imgthumb:BitmapData;
		protected var __imgtransition:ITransition;
		private var __loader:Loader;
		protected var __mask:DisplayObject;
		private var __showthumb:Boolean;
		protected var __txtfield:TxtField;
		//
		//constructor...
		public function HInfoGallery(boolShowThumb:Boolean, fDrawMaskGallery:Function, fModelGallery:Function, boolTextIsEmbedded:Boolean = false, bkgGallery:* = undefined, objPaddingGallery:Object = undefined, objTransitionGallery:ITransition = undefined, arrayFiltersGallery:Array = undefined, mcBaloon:MovieClip = undefined, objThumbSource:ThumbSource = undefined, arrayThumbnails:Array = undefined,
									 mcScrollBarTxtField:MovieClip = undefined, objPaddingTxtField:Object = undefined, objBorderTxtField:Object = undefined, bkgTxtField:* = undefined, ssStyles:StyleSheet = undefined, objTransitionTxtField:ITransition = undefined, arrayFiltersTxtField:Array = undefined, 
									 imgMask:* = undefined, bdImgThumb:BitmapData = undefined, objTransitionImg:ITransition = undefined, arrayFiltersImg:Array = undefined) {
			if (!(fDrawMaskGallery is Function)) return;
			if (!(fModelGallery is Function)) return;
			if (!(arrayFiltersGallery is Array)) arrayFiltersGallery = [];
			if (!(arrayFiltersTxtField is Array)) arrayFiltersTxtField = [];
			if (!(arrayFiltersImg is Array)) arrayFiltersImg = [];
			//
			this.__showthumb = Boolean(boolShowThumb);
			this.__hgallery = HGallery(this.addChild(new HGallery(fDrawMaskGallery, fModelGallery, Boolean(boolTextIsEmbedded), bkgGallery, objPaddingGallery, objTransitionGallery, mcBaloon, objThumbSource, arrayThumbnails)));
			this.__hgallery.filters = arrayFiltersGallery;
			this.__hgallery.addEventListener(GalleryEvent.UPDATED, this.__onVGalleryUpdated);
			this.__hgallery.addEventListener(GalleryEvent.ITEM_CLICK, this.__onSelection);
			this.__txtfield = TxtField(this.addChild(new TxtField(mcScrollBarTxtField, objPaddingTxtField, objBorderTxtField, bkgTxtField, objTransitionTxtField, true)));
			this.__txtfield.multiline = true;
			this.__txtfield.wordWrap = true;
			this.__txtfield.height = this.__KHEIGHT;
			this.__txtfield.width = this.__KWIDTH;
			this.__txtfield.styleSheet = ssStyles;
			this.__txtfield.visible = false;
			this.__txtfield.filters = arrayFiltersTxtField;
			this.__txtfield.addEventListener(Event.CLOSE, this.__onTxtFieldClose);
			this.__txtfield.addEventListener(TextEvent.LINK, this.__onTxtFieldLink);
			this.__txtfield.addEventListener(Event.OPEN, this.__onTxtFieldOpen);
			this.__txtfield.addEventListener(Event.SCROLL, this.__onTxtFieldScroll);
			this.__txtfield.addEventListener(Event.INIT, this.__onTxtFieldInit);
			var _imgholder:Sprite = Sprite(this.addChild(new Sprite()));
			_imgholder.filters = arrayFiltersImg;
			_imgholder.y = this.__hgallery.y + this.__hgallery.height;
			this.__img = Bitmap(_imgholder.addChild(new Bitmap()));
			if (imgMask is DisplayObject) {
				this.__mask = _imgholder.addChild(imgMask);
				this.__img.mask = this.__mask;
				var _bounds:Rectangle = this.__mask.getBounds(this.__mask);
				this.__KIMG.height = _bounds.bottom;
				this.__KIMG.width = _bounds.right;
			}
			else if (!Boolean(imgMask)) this.__KIMG.height = this.__KIMG.width = this.__KOFFSET.left = 0;
			//
			this.__txtfield.x = _imgholder.x + this.__KIMG.width + this.__KOFFSET.left - this.__txtfield.padding.left;
			this.__txtfield.y = _imgholder.y + this.__KOFFSET.top;
			if (this.__KIMG.height > 0) {
				if (bdImgThumb is BitmapData) this.__imgthumb = bdImgThumb;
				if (objTransitionImg is ITransition) {
					this.__imgtransition = objTransitionImg;
					this.__imgtransition.outro(this.__img.parent);
				};
				this.__loader = new Loader();
				this.__loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.__onImgInit);
				this.__loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.__onImgIoError);
				this.__loader.contentLoaderInfo.addEventListener(Event.UNLOAD, this.__onImgUnload);
			};
		};
		//
		//private methods...
		private function __onImgInit(event:Event):void {
			this.__hgallery.thumbresume();
			if (this.__img is Bitmap) {
				var _bd:BitmapData = new BitmapData(this.__KIMG.width, this.__KIMG.height, true, 0x00000000);
				var _scale:Number = Math.max(this.__KIMG.width / this.__loader.content.width, this.__KIMG.height / this.__loader.content.height);
				_bd.draw(this.__loader.content, new Matrix(_scale, 0, 0, _scale), new ColorTransform(), null, null, true);
				this.__img.bitmapData = _bd;
				(this.__imgtransition is _project.classes.ITransition) ? this.__imgtransition.intro(this.__img.parent) : this.__img.parent.visible = true;
			};
		};
		private function __onImgIoError(event:IOErrorEvent):void {
			this.__hgallery.thumbresume();
			if (this.__img is Bitmap) {
				this.__img.bitmapData = this.__imgthumb;
				(this.__imgtransition is _project.classes.ITransition) ? this.__imgtransition.intro(this.__img.parent) : this.__img.parent.visible = true;
			};
		};
		private function __onImgUnload(event:Event):void {
			//...
		};
		private function __onSelection(event:Event):void {
			var _selected:Object = this.__hgallery.selected;
			var _thumb:String = _selected.target.thumb;
			var _body:String = _selected.target.attributes;
			if (!(_body is String)) _body = "";
			//
			if (this.__loader is Loader) {
				(this.__imgtransition is _project.classes.ITransition) ? this.__imgtransition.outro(this.__img.parent) : this.__img.parent.visible = false;
				if ((_thumb is String) && _thumb != "") {
					this.__hgallery.thumbsuspend();
					this.__loader.load(new URLRequest(_thumb));
				};
			};
			this.__txtfield.htmlText = this.__KHTML.body.begin + this.__KHTML.title.begin + _selected.target.info + this.__KHTML.title.end + _body + this.__KHTML.body.end;
			//external...
			this.dispatchEvent(new Event(Event.SELECT));
		};
		private function __onTxtFieldClose(event:Event):void {
			this.dispatchEvent(new Event(Event.CLOSE));
		};
		private function __onTxtFieldInit(event:Event):void {
			this.__txtfield.removeEventListener(Event.INIT, this.__onTxtFieldInit);
			this.__txtfield.height = this.__KHEIGHT;
			this.__txtfield.width = this.__KWIDTH - this.__KOFFSET.left;
			this.__txtfield.hide();
			this.dispatchEvent(new Event(Event.INIT));
		};
		private function __onTxtFieldLink(event:Event):void {
			this.dispatchEvent(new TextEvent(TextEvent.LINK));
		};
		private function __onTxtFieldOpen(event:Event):void {
			this.dispatchEvent(new Event(Event.OPEN));
		};
		private function __onTxtFieldScroll(event:Event):void {
			this.dispatchEvent(new Event(Event.SCROLL));
		};
		private function __onVGalleryUpdated(event:Event):void {
			this.__hgallery.selected = 0;
			this.dispatchEvent(new Event(Event.CHANGE));
		};
		//
		//properties...
		public override function get height():Number {
			if (!(this.__txtfield is TxtField)) return undefined;
			return (this.__txtfield.y + this.__txtfield.height);
		};
		public override function set height(value:Number):void {
			//blind...
		};
		public function get durationIntro():Number {
			return Math.max(this.__hgallery.durationIntro, this.__txtfield.durationIntro);
		};
		public function get durationOutro():Number {
			return Math.max(this.__hgallery.durationOutro, this.__txtfield.durationOutro);
		};
		public override function get width():Number {
			if (!(this.__hgallery is HGallery)) return undefined;
			return this.__hgallery.width;
		};
		public override function set width(value:Number):void {
			if (!(this.__hgallery is HGallery)) return;
			if (isNaN(value)) return;
			var _padding:Number = 0.5 * (value - this.__KIMG.width - this.__KOFFSET.left - this.__KWIDTH);
			if (this.__hgallery.width < value) {
				this.__hgallery.width = value;
				this.__hgallery.padding = { left: _padding, right: _padding };
			}
			else {
				this.__hgallery.padding = { left: _padding, right: _padding };
				this.__hgallery.width = value;
			};
			this.__img.parent.x = this.__hgallery.x + _padding;
			this.__txtfield.x = this.__img.parent.x + this.__KIMG.width + this.__KOFFSET.left;
		};
		//
		//public methods...
		public function load(arrayData:Array):Boolean {
			if (!(this.__hgallery is HGallery)) return false;
			this.__hgallery.thumbresume();
			if (this.__img is Bitmap) {
				(this.__imgtransition is _project.classes.ITransition) ? this.__imgtransition.outro(this.__img.parent) : this.__img.parent.visible = false;
			};
			return this.__hgallery.load(arrayData);
		};
		public function reset():void {
			if (this.__hgallery is HGallery) this.__hgallery.reset();
			if (this.__img is Bitmap) {
				(this.__imgtransition is _project.classes.ITransition) ? this.__imgtransition.outro(this.__img.parent) : this.__img.parent.visible = false;
			};
			if (this.__txtfield is TxtField) this.__txtfield.hide();
		};
	};
};