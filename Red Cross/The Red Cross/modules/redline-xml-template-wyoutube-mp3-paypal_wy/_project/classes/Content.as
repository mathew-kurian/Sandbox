/**
 * Content
 * Content (HTML formatted text) implementation
 *
 * @version		2.0
 */
package _project.classes	{
	use namespace AS3;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.StyleSheet;
	//
	import _project.classes.GalleryEvent;
	import _project.classes.ITransition;
	import _project.classes.StyleSheets;
	import _project.classes.TxtField;
	import _project.classes.VGallery;
	//
	public class Content extends Sprite {
		//private constants...
		protected const __HEIGHT:Object = { title: 510, txtfield: 510 };
		private const __HTML:Object = { begin: "<body>", end: "</body>" };
		protected const __KOFFSET:Object = { left: 0 };
		protected const __WIDTH:Object = { title: 390, txtfield: 500 };
		//private vars...
		protected var __title:TxtField;
		protected var __txtfield:TxtField;
		//
		//constructor...
		public function Content(mcScrollBarTitle:MovieClip = undefined, objPaddingTitle:Object = undefined, objBorderTitle:Object = undefined, bkgTitle:* = undefined, ssStylesTitle:StyleSheet = undefined, objTransitionTitle:ITransition = undefined, arrayFiltersTitle:Array = undefined,
								mcScrollBarTxtField:MovieClip = undefined, objPaddingTxtField:Object = undefined, objBorderTxtField:Object = undefined, bkgTxtField:* = undefined, ssStylesTxtField:StyleSheet = undefined, objTransitionTxtField:ITransition = undefined, arrayFiltersTxtField:Array = undefined) {
			if (!(arrayFiltersTitle is Array)) arrayFiltersTitle = [];
			if (!(arrayFiltersTxtField is Array)) arrayFiltersTxtField = [];
			this.__title = TxtField(this.addChild(new TxtField(mcScrollBarTitle, objPaddingTitle, objBorderTitle, bkgTitle, objTransitionTitle, true)));
			this.__title.multiline = true;
			this.__title.wordWrap = true;
			this.__title.styleSheet = ssStylesTitle;
			this.__title.visible = false;
			this.__title.filters = arrayFiltersTitle;
			this.__txtfield = TxtField(this.addChild(new TxtField(mcScrollBarTxtField, objPaddingTxtField, objBorderTxtField, bkgTxtField, objTransitionTxtField, true)));
			this.__txtfield.multiline = true;
			this.__txtfield.wordWrap = true;
			this.__txtfield.x = this.__title.x + this.__WIDTH.title + this.__KOFFSET.left;
			this.__txtfield.styleSheet = ssStylesTxtField;
			this.__txtfield.visible = false;
			this.__txtfield.filters = arrayFiltersTxtField;
			this.__txtfield.addEventListener(Event.CLOSE, this.__onTxtFieldClose);
			this.__txtfield.addEventListener(TextEvent.LINK, this.__onTxtFieldLink);
			this.__txtfield.addEventListener(Event.OPEN, this.__onTxtFieldOpen);
			this.__txtfield.addEventListener(Event.SCROLL, this.__onTxtFieldScroll);
			this.__title.addEventListener(Event.INIT, this.__onTitleInit);
			this.__txtfield.addEventListener(Event.INIT, this.__onTxtFieldInit);
		};
		//
		//private methods...
		private function __onTitleInit(event:Event):void {
			this.__title.removeEventListener(Event.INIT, this.__onTitleInit);
			this.__title.resize(this.__HEIGHT.title, this.__WIDTH.title);
			this.__title.hide();
		};
		private function __onTxtFieldClose(event:Event):void {
			this.dispatchEvent(new Event(Event.CLOSE));
		};
		private function __onTxtFieldInit(event:Event):void {
			this.__txtfield.removeEventListener(Event.INIT, this.__onTxtFieldInit);
			this.__txtfield.resize(this.__HEIGHT.txtfield, this.__WIDTH.txtfield);
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
		//
		//properties...
		public override function get height():Number {
			return this.__title.height;
		};
		public override function set height(value:Number):void {
			if (isNaN(value)) return;
			if (value < 0) return
			var _padding:Number = 0.5 * (value - this.__HEIGHT.title);
			if (this.__title.height < value) {
				this.__title.height = value;
				this.__title.padding = { bottom: _padding + this.__txtfield.padding.bottom, top: _padding + this.__txtfield.padding.top };
			}
			else {
				this.__title.padding = { bottom: _padding + this.__txtfield.padding.bottom, top: _padding + this.__txtfield.padding.top };
				this.__title.height = value;
			};
			this.__txtfield.y = 0.5 * (this.height - this.__txtfield.height);
		};
		public function get durationIntro():Number {
			return Math.max(this.__title.durationIntro, this.__txtfield.durationIntro);
		};
		public function get durationOutro():Number {
			return Math.max(this.__title.durationOutro, this.__txtfield.durationOutro);
		};
		public override function get width():Number {
			return (this.__txtfield.x + this.__txtfield.width);
		};
		public override function set width(value:Number):void {
			//blind...
		};
		//
		//public methods...
		public function load(strTitle:String = undefined, strContent:String = undefined):void {
			if (strTitle is String) {
				if (strTitle != "") strTitle = this.__HTML.begin + strTitle + this.__HTML.end;
			};
			this.__title.htmlText = strTitle;
			if (strContent is String) {
				if (strContent != "") strContent = this.__HTML.begin + strContent + this.__HTML.end;
			};
			this.__txtfield.htmlText = strContent;
		};
		public function reset():void {
			this.__title.hide();
			this.__txtfield.hide();
		};
	};
};