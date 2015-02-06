/**
 * VInfoGallery
 * Vertical gallery with info presentation
 *
 * @version		2.0
 */
package _project.classes	{
	use namespace AS3;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.StyleSheet;
	//
	import _project.classes.GalleryEvent;
	import _project.classes.ITransition;
	import _project.classes.StyleSheets;
	import _project.classes.ThumbSource;
	import _project.classes.TxtField;
	import _project.classes.VGallery;
	//
	public class VInfoGallery extends Sprite {
		//private constants...
		protected const __KALIGN:String = "R";
		protected const __KHEIGHT:Number = 610;
		private const __KHTML:Object = { thumb: { begin: "<img src='", end: "' />" }, title: { begin: "<span class='title'>", end: "</span><br /><br />" }, body: { begin: "<body>", end: "</body>" } };
		protected const __KOFFSET:Object = { left: 1 };
		protected const __KWIDTH:Number = 550;
		//private vars...
		private var __showthumb:Boolean;
		protected var __txtfield:TxtField;
		protected var __vgallery:VGallery;
		//
		//constructor...
		public function VInfoGallery(boolShowThumb:Boolean, fDrawMaskGallery:Function, fModelGallery:Function, boolTextIsEmbedded:Boolean = false, bkgGallery:* = undefined, objPaddingGallery:Object = undefined, objTransitionGallery:ITransition = undefined, arrayFiltersGallery:Array = undefined, mcBaloon:MovieClip = undefined, objThumbSource:ThumbSource = undefined, arrayThumbnails:Array = undefined,
									 mcScrollBarTxtField:MovieClip = undefined, objPaddingTxtField:Object = undefined, objBorderTxtField:Object = undefined, bkgTxtField:* = undefined, ssStyles:StyleSheet = undefined, objTransitionTxtField:ITransition = undefined, arrayFiltersTxtField:Array = undefined) {
			if (!(fDrawMaskGallery is Function)) return;
			if (!(fModelGallery is Function)) return;
			if (!(arrayFiltersGallery is Array)) arrayFiltersGallery = [];
			if (!(arrayFiltersTxtField is Array)) arrayFiltersTxtField = [];
			//
			this.__showthumb = Boolean(boolShowThumb);
			this.__vgallery = VGallery(this.addChild(new VGallery(fDrawMaskGallery, fModelGallery, Boolean(boolTextIsEmbedded), this.__KALIGN, bkgGallery, objPaddingGallery, objTransitionGallery, mcBaloon, objThumbSource, arrayThumbnails)));
			this.__vgallery.height = this.__KHEIGHT;
			this.__vgallery.filters = arrayFiltersGallery;
			this.__vgallery.addEventListener(GalleryEvent.UPDATED, this.__onVGalleryUpdated);
			this.__vgallery.addEventListener(GalleryEvent.ITEM_CLICK, this.__onSelection);
			this.__txtfield = TxtField(this.addChild(new TxtField(mcScrollBarTxtField, objPaddingTxtField, objBorderTxtField, bkgTxtField, objTransitionTxtField, true)));
			this.__txtfield.multiline = true;
			this.__txtfield.wordWrap = true;
			this.__txtfield.x = this.__vgallery.x + this.__vgallery.width + this.__KOFFSET.left;
			this.__txtfield.styleSheet = ssStyles;
			this.__txtfield.visible = false;
			this.__txtfield.filters = arrayFiltersTxtField;
			this.__txtfield.addEventListener(Event.CLOSE, this.__onTxtFieldClose);
			this.__txtfield.addEventListener(TextEvent.LINK, this.__onTxtFieldLink);
			this.__txtfield.addEventListener(Event.OPEN, this.__onTxtFieldOpen);
			this.__txtfield.addEventListener(Event.SCROLL, this.__onTxtFieldScroll);
			this.__txtfield.addEventListener(Event.INIT, this.__onTxtFieldInit);
		};
		//
		//private methods...
		private function __onSelection(event:Event):void {
			var _selected:Object = this.__vgallery.selected;
			var _thumb:String = _selected.target.thumb;
			var _body:String = _selected.target.attributes;
			if (!(_body is String)) _body = "";
			this.__txtfield.htmlText = this.__KHTML.body.begin + ((this.__showthumb && (_thumb is String) && _thumb != "") ? this.__KHTML.thumb.begin + _thumb + this.__KHTML.thumb.end : "") + this.__KHTML.title.begin + _selected.target.info + this.__KHTML.title.end + _body + this.__KHTML.body.end;
			this.dispatchEvent(new Event(Event.SELECT));
		};
		private function __onTxtFieldClose(event:Event):void {
			this.dispatchEvent(new Event(Event.CLOSE));
		};
		private function __onTxtFieldInit(event:Event):void {
			this.__txtfield.removeEventListener(Event.INIT, this.__onTxtFieldInit);
			this.__txtfield.resize(this.__KHEIGHT, this.__KWIDTH);
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
			this.__vgallery.selected = 0;
			this.dispatchEvent(new Event(Event.CHANGE));
		};
		//
		//properties...
		public override function get height():Number {
			if (!(this.__vgallery is VGallery)) return undefined;
			return this.__vgallery.height;
		};
		public override function set height(value:Number):void {
			if (!(this.__vgallery is VGallery)) return;
			if (isNaN(value)) return;
			var _padding:Number = 0.5 * (value - this.__KHEIGHT + this.__txtfield.padding.bottom + this.__txtfield.padding.top);
			if (this.__vgallery.height < value) {
				this.__vgallery.height = value;
				this.__vgallery.padding = { bottom: _padding, top: _padding };
			}
			else {
				this.__vgallery.padding = { bottom: _padding, top: _padding };
				this.__vgallery.height = value;
			};
			this.__txtfield.y = this.__vgallery.y + this.__vgallery.padding.top - this.__txtfield.padding.top;
		};
		public function get durationIntro():Number {
			return Math.max(this.__vgallery.durationIntro, this.__txtfield.durationIntro);
		};
		public function get durationOutro():Number {
			return Math.max(this.__vgallery.durationOutro, this.__txtfield.durationOutro);
		};
		public override function get width():Number {
			if (!(this.__txtfield is TxtField)) return undefined;
			return (this.__txtfield.x + this.__txtfield.width);
		};
		public override function set width(value:Number):void {
			//blind...
		};
		//
		//public methods...
		public function load(arrayData:Array):Boolean {
			if (!(this.__vgallery is VGallery)) return false;
			this.__vgallery.thumbresume();
			return this.__vgallery.load(arrayData);
		};
		public function reset():void {
			if (this.__vgallery is VGallery) this.__vgallery.reset();
			if (this.__txtfield is TxtField) this.__txtfield.hide();
		};
	};
};