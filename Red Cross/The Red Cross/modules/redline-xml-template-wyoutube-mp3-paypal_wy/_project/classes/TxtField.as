/**
 * TxtField
 * Extended Text Field
 *
 * @version		2.0
 */
package _project.classes {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilter;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.utils.Timer;
	//
	import _project.classes.ITransition;
	//
	public class TxtField extends Sprite {
		//private vars...
		private var __bkg:*;
		private var __bkgpool:BitmapData;
		private var __border:Bitmap;
		private var __borderpattern:BitmapData;
		private var __scrollbar:MovieClip;
		private var __snapshot:Bitmap;
		private var __status:Object;
		private var __transition:ITransition;
		private var __textfield:TextField;
		//
		//constructor...
		public function TxtField(mcScrollBar:MovieClip = undefined, objPadding:Object = undefined, objBorder:Object = undefined, backGround:* = undefined, objTransition:ITransition = undefined, boolAutoShow:Boolean = false) {
			this.visible = false;
			this.__status = { autoshow: Boolean(boolAutoShow), borderfill: 0xFF000000, borderfilters: [], borderoffset: 0, borderthick: 0, 
							  height: 0, htmlText: undefined, padding: { bottom: 0, left: 0, right: 0, top: 0 }, 
							  ready: false, text: undefined, visible: true, width: 0 };
			if (objTransition is ITransition) {
				this.__transition = objTransition;
				this.__transition.addEventListener(Event.CLOSE, this.__onTransitionClose);
				this.__transition.addEventListener(Event.OPEN, this.__onTransitionOpen);
			};
			if (backGround is BitmapData) {
				this.__bkg = Bitmap(this.addChild(new Bitmap()));
				this.__bkgpool = this.__pattern(backGround, Capabilities.screenResolutionY, Capabilities.screenResolutionX);
			}
			else if (backGround is MovieClip) this.__bkg = MovieClip(this.addChild(backGround));
			var _offset:Number = 0;
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
				if (this.__status.borderthick > 0) {
					this.__border = Bitmap(this.addChild(new Bitmap()));
					this.__border.cacheAsBitmap = true;
					this.__border.filters = this.__status.borderfilters;
					if (this.__status.borderfill is BitmapData) this.__borderpattern = this.__pattern(this.__status.borderfill, Capabilities.screenResolutionY, Capabilities.screenResolutionX);
					//
					if (this.__bkg) {
						_offset = this.__status.borderoffset + this.__status.borderthick;
						if (_offset >= 0) this.__bkg.x = this.__bkg.y = _offset
						else this.__border.x = this.__border.y = -_offset;
					};
				}
				else this.__status.borderoffset = 0;
			};
			if (objPadding) {
				for (var j in this.__status.padding) {
					if (isNaN(objPadding[j])) continue;
					if (objPadding[j] < -_offset) continue;
					this.__status.padding[j] = objPadding[j];
				};
			};
			this.__textfield = TextField(this.addChild(new TextField()));
			this.__textfield.addEventListener(Event.CHANGE, this.__onChange);
			this.__textfield.addEventListener(TextEvent.LINK, this.__onLink);
			this.__textfield.addEventListener(Event.SCROLL, this.__onScroll);
			this.__textfield.addEventListener(TextEvent.TEXT_INPUT, this.__onTextInput);
			this.__textfield.x = _offset + this.__status.padding.left;
			this.__textfield.y = _offset + this.__status.padding.top;
			var _timer:Timer = new Timer(10);
			_timer.addEventListener(TimerEvent.TIMER, this.__onTimer);
			if (mcScrollBar is MovieClip) {
				this.__scrollbar = MovieClip(this.addChild(mcScrollBar));
				this.__scrollbar.x = this.__textfield.x;
				this.__scrollbar.y = this.__textfield.y;
			};
			this.__snapshot = Bitmap(this.addChild(new Bitmap()));
			this.__snapshot.x = this.__textfield.x;
			this.__snapshot.y = this.__textfield.y;
			//
			_timer.start();
		};
		//
		//private methods...
		private function __onChange(event:Event):void {
			this.dispatchEvent(new Event(Event.CHANGE));
		};
		private function __onLink(event:TextEvent):void {
			this.dispatchEvent(new TextEvent(TextEvent.LINK));
		};
		private function __onScroll(event:Event):void {
			try {
				this.__scrollbar.setCursorPosition((this.__textfield["scrollV"] - 1) / this.__textfield["maxScrollV"]);
			}
			catch (_error:Error) {
				//...
			};
			this.dispatchEvent(new Event(Event.SCROLL));
		};
		private function __onScrollBar(value:Number) {
			this.__textfield["scrollV"] = 1 + this.__textfield["maxScrollV"] * value;
		};
		private function __onTextInput(event:TextEvent):void {
			this.dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT));
		};
		private function __onTimer(event:TimerEvent):void {
			if (this.__scrollbar is MovieClip) {
				if (!(this.__scrollbar.getHeight is Function)) return;
				if (!(this.__scrollbar.setHeight is Function)) return;
				if (!(this.__scrollbar.getCursorHeight is Function)) return;
				if (!(this.__scrollbar.setCursorHeight is Function)) return;
				if (!(this.__scrollbar.getCursorPosition is Function)) return;
				if (!(this.__scrollbar.setCursorPosition is Function)) return;
				this.__scrollbar.y = this.__textfield.y;
				this.__scrollbar.onScroll = this.__onScrollBar;
			};
			event.target.stop();
			event.target.removeEventListener(TimerEvent.TIMER, this.__onTimer);
			this.__status.ready = true;
			this.dispatchEvent(new Event(Event.INIT));
		};
		private function __onTransitionClose(event:Event = undefined):void {
			this.visible = false;
			this.__update();
			this.dispatchEvent(new Event(Event.CLOSE));
		};
		private function __onTransitionOpen(event:Event = undefined):void {
			try {
				this.__snapshot.bitmapData.dispose();
			}
			catch (_error:Error) {
				//...
			};
			this.__textfield.visible = true;
			this.dispatchEvent(new Event(Event.OPEN));
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
		private function __resize():void {
			if (!(this.__textfield is TextField)) return;
			//
			var _offset:Number = 2 * (this.__status.borderoffset + this.__status.borderthick);
			this.__textfield.x = this.__snapshot.x = _offset + this.__status.padding.left;
			this.__textfield.y = this.__snapshot.y = _offset + this.__status.padding.top;
			if (this.__scrollbar is MovieClip) {
				this.__scrollbar.x = this.__textfield.x;
				this.__scrollbar.y = this.__textfield.y;
			};
			var _scrollbarh:Number = this.__status.height - this.__textfield.y - 0.5 * _offset - this.__status.padding.bottom;
			if (_scrollbarh < 0) _scrollbarh = 0;
			var _scrollbarw:Number = 0;
			if (this.__scrollbar is MovieClip) {
				try {
					this.__scrollbar.setHeight(_scrollbarh);
				}
				catch (_error:Error) {
					//...
				};
				_scrollbarw = this.__scrollbar.width;
				this.__scrollbar.x = this.__status.width - this.__status.padding.right - 0.5 * _offset - _scrollbarw;
				this.__scrollbarupdate();
			};
			if (this.__bkg is Bitmap) this.__bkg.bitmapData = this.__pattern(this.__bkgpool, this.__status.height - _offset, this.__status.width - _offset)
			else if (this.__bkg is MovieClip) {
				this.__bkg.height = this.__status.height - _offset;
				this.__bkg.width = this.__status.width - _offset;
			};
			if (this.__border is Bitmap) {
				try {
					this.__border.bitmapData.dispose();
				}
				catch (_error:Error) {
					//...
				};
				var _border:BitmapData;
				if (this.__status.borderfill is BitmapData) _border = this.__pattern(this.__borderpattern, this.__status.height, this.__status.width)
				else if (!isNaN(this.__status.borderfill)) {
					_border = new BitmapData(this.__status.width, this.__status.height, true, 0x00000000);
					_border.floodFill(0, 0, this.__status.borderfill);
				};
				_border.fillRect(new Rectangle(this.__status.borderthick, this.__status.borderthick, _border.width - 2 * this.__status.borderthick, _border.height - 2 * this.__status.borderthick), 0x00000000);
				this.__border.bitmapData = _border;
			};
			this.__textfield.height = _scrollbarh;
			_scrollbarw = this.__status.width - this.__textfield.x - 0.5 * _offset - this.__status.padding.right - _scrollbarw;
			if (_scrollbarw < 0) _scrollbarw = 0;
			this.__textfield.width = _scrollbarw;
			if (this.__transition is ITransition) this.__transition.resize();
		};
		private function __scrollbarupdate():void {
			if (!(this.__scrollbar is MovieClip)) return;
			if (this.__textfield is TextField) {
				var _bottomScrollV:int = this.__textfield["bottomScrollV"];
				var _numLines:int = this.__textfield["numLines"];
				if (isNaN(_bottomScrollV) || isNaN(_numLines)) this.__scrollbar.visible = false
				else {
					var _cursorh:Number = (_numLines > 0) ? _bottomScrollV / _numLines : 1;
					if (_cursorh >= 1) this.__scrollbar.visible = false
					else {
						try {
							this.__scrollbar.setCursorHeight(_cursorh);
						}
						catch (_error:Error) {
							//...
						};
						this.__scrollbar.visible = true;
					};
				};
			}
			else this.__scrollbar.visible = false;
		};
		private function __update():void {
			if (!(this.__textfield is TextField)) return;
			//
			if (this.__status.htmlText is String) this.__textfield.htmlText = this.__status.htmlText
			else if (this.__status.text is String) this.__textfield.text = this.__status.text
			else return;
			this.__textfield["scrollV"] = 1;
			this.__scrollbarupdate();
			this.__status.htmlText = this.__status.text = undefined;
			this.dispatchEvent(new Event(Event.CHANGE));
			if (this.__status.autoshow) this.show();
		};
		//
		//properties...
		public function get alwaysShowSelection():Boolean {
			return this.__textfield["alwaysShowSelection"];
		};
		public function set alwaysShowSelection(value:Boolean):void {
			this.__textfield["alwaysShowSelection"] = value;
		};
		public function get antiAliasType():String {
			return this.__textfield["antiAliasType"];
		};
		public function set antiAliasType(value:String):void {
			this.__textfield["antiAliasType"] = value;
		};
		public function get autoShow():Boolean {
			return this.__status.autoshow;
		};
		public function set autoShow(value:Boolean):void {
			this.__status.autoshow = value;
		};
		public function get autoSize():String {
			return this.__textfield["autoSize"];
		};
		public function set autoSize(value:String):void {
			this.__textfield["autoSize"] = value;
		};
		public function get bottomScrollV():int {
			return this.__textfield["bottomScrollV"];
		};
		public function get caretIndex():int {
			return this.__textfield["caretIndex"];
		};
		public function get condenseWhite():Boolean {
			return this.__textfield["condenseWhite"];
		};
		public function set condenseWhite(value:Boolean):void {
			this.__textfield["condenseWhite"] = value;
		};
		public function get defaultTextFormat():TextFormat {
			return this.__textfield["defaultTextFormat"];
		};
		public function set defaultTextFormat(value:TextFormat):void {
			this.__textfield["defaultTextFormat"] = value;
		};
		public function get displayAsPassword():Boolean {
			return this.__textfield["displayAsPassword"];
		};
		public function set displayAsPassword(value:Boolean):void {
			this.__textfield["displayAsPassword"] = value;
		};
		public function get embedFonts():Boolean {
			return this.__textfield["embedFonts"];
		};
		public function get durationIntro():Number {
			return ((this.__transition is ITransition) ? this.__transition.durationIntro : 0);
		};
		public function get durationOutro():Number {
			return ((this.__transition is ITransition) ? this.__transition.durationOutro : 0);
		};
		public function set embedFonts(value:Boolean):void {
			this.__textfield["embedFonts"] = value;
		};
		public function get gridFitType():String {
			return this.__textfield["gridFitType"];
		};
		public function set gridFitType(value:String):void {
			this.__textfield["gridFitType"] = value;
		};
		public override function get height():Number {
			try {
				return this.__status.height;
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public override function set height(value:Number):void {
			if (isNaN(value)) return;
			var _min:Number = this.__status.borderoffset + this.__status.borderthick;
			if (_min < 0) _min = 0;
			if (value < 2 * _min) return;
			this.__status.height = value;
			this.__resize();
		};
		public function get htmlText():String {
			return this.__textfield.htmlText;
		};
		public function set htmlText(value:String):void {
			this.__status.text = undefined;
			this.__status.htmlText = value;
			this.hide();
		};
		public function get length():int {
			return this.__textfield["length"];
		};
		public function get maxChars():int {
			return this.__textfield["maxChars"];
		};
		public function set maxChars(value:int):void {
			this.__textfield["maxChars"] = value;
		};
		public function get maxScrollH():int {
			return this.__textfield["maxScrollH"];
		};
		public function get maxScrollV():int {
			return this.__textfield["maxScrollV"];
		};
		public function get mouseWheelEnabled():Boolean {
			return this.__textfield["mouseWheelEnabled"];
		};
		public function set mouseWheelEnabled(value:Boolean):void {
			this.__textfield["mouseWheelEnabled"] = value;
		};
		public function get multiline():Boolean {
			return this.__textfield["multiline"];
		};
		public function set multiline(value:Boolean):void {
			this.__textfield["multiline"] = value;
		};
		public function get numLines():int {
			return this.__textfield["numLines"];
		};
		public function get padding():Object {
			return { bottom: Number(this.__status.padding.bottom), 
					 left: Number(this.__status.padding.left), 
					 right: Number(this.__status.padding.right), 
					 top: Number(this.__status.padding.top) };
		};
		public function set padding(objPadding:Object):void {
			if (!objPadding) return;
			var _resize:Boolean = false;
			for (var i in this.__status.padding) {
				if (isNaN(objPadding[i])) continue;
				if (objPadding[i] == this.__status.padding[i]) continue;
				this.__status.padding[i] = objPadding[i];
				_resize = true;
			};
			if (_resize) this.__resize();
		};
		public function get ready():Boolean {
			return this.__status.ready;
		};
		public function get restrict():String {
			return this.__textfield["restrict"];
		};
		public function set restrict(value:String):void {
			this.__textfield["restrict"] = value;
		};
		public function get scrollH():int {
			return this.__textfield["scrollH"];
		};
		public function set scrollH(value:int):void {
			this.__textfield["scrollH"] = value;
		};
		public function get scrollV():int {
			return this.__textfield["scrollV"];
		};
		public function set scrollV(value:int):void {
			this.__textfield["scrollV"] = value;
		};
		public function get selectable():Boolean {
			return this.__textfield["selectable"];
		};
		public function set selectable(value:Boolean):void {
			this.__textfield["selectable"] = value;
		};
		public function get selectionBeginIndex():int {
			return this.__textfield["selectionBeginIndex"];
		};
		public function get selectionEndIndex():int {
			return this.__textfield["selectionEndIndex"];
		};
		public function get sharpness():Number {
			return this.__textfield["sharpness"];
		};
		public function set sharpness(value:Number):void {
			this.__textfield["sharpness"] = value;
		};
		public function get styleSheet():StyleSheet {
			return this.__textfield["styleSheet"];
		};
		public function set styleSheet(value:StyleSheet):void {
			this.__textfield["styleSheet"] = value;
		};
		public function get text():String {
			return this.__textfield.text;
		};
		public function set text(value:String):void {
			this.__status.text = value;
			this.__status.htmlText = undefined;
			this.hide();
		};
		public function get textColor():uint {
			return this.__textfield["textColor"];
		};
		public function set textColor(value:uint):void {
			this.__textfield["textColor"] = value;
		};
		public function get textHeight():Number {
			return this.__textfield["textHeight"];
		};
		public function get textWidth():Number {
			return this.__textfield["textWidth"];
		};
		public function get thickness():Number {
			return this.__textfield["thickness"];
		};
		public function set thickness(value:Number):void {
			this.__textfield["thickness"] = value;
		};
		public function get type():String {
			return this.__textfield["type"];
		};
		public function set type(value:String):void {
			this.__textfield["type"] = value;
		};
		public function get useRichTextClipboard():Boolean {
			return this.__textfield["useRichTextClipboard"];
		};
		public function set useRichTextClipboard(value:Boolean):void {
			this.__textfield["useRichTextClipboard"] = value;
		};
		public override function get width():Number {
			try {
				return this.__status.width;
			}
			catch (_error:Error) {
				//...
			};
			return undefined;
		};
		public override function set width(value:Number):void {
			if (isNaN(value)) return;
			var _min:Number = this.__status.borderoffset + this.__status.borderthick;
			if (_min < 0) _min = 0;
			if (value < 2 * _min) return;
			this.__status.width = value;
			this.__resize();
		};
		public function get wordWrap():Boolean {
			return this.__textfield["wordWrap"];
		};
		public function set wordWrap(value:Boolean):void {
			this.__textfield["wordWrap"] = value;
		};
		//
		//public methods...
		public function appendText(newText:String):void {
			this.__textfield.appendText(newText);
		};
		public function getCharBoundaries(charIndex:int):Rectangle {
			return this.__textfield.getCharBoundaries(charIndex);
		};
		public function getCharIndexAtPoint(x:Number, y:Number):int {
			return this.__textfield.getCharIndexAtPoint(x, y);
		};
		public function getFirstCharInParagraph(charIndex:int):int {
			return this.__textfield.getFirstCharInParagraph(charIndex);
		};
		public function getImageReference(id:String):DisplayObject {
			return this.__textfield.getImageReference(id);
		};
		public function getLineIndexAtPoint(x:Number, y:Number):int {
			return this.__textfield.getLineIndexAtPoint(x, y);
		};
		public function getLineIndexOfChar(charIndex:int):int {
			return this.__textfield.getLineIndexOfChar(charIndex);
		};
		public function getLineLength(lineIndex:int):int {
			return this.__textfield.getLineLength(lineIndex);
		};
		public function getLineMetrics(lineIndex:int):TextLineMetrics {
			return this.__textfield.getLineMetrics(lineIndex);
		};
		public function getLineOffset(lineIndex:int):int {
			return this.__textfield.getLineOffset(lineIndex);
		};
		public function getLineText(lineIndex:int):String {
			return this.__textfield.getLineText(lineIndex);
		};
		public function getParagraphLength(charIndex:int):int {
			return this.__textfield.getParagraphLength(charIndex);
		};
		public function getTextFormat(beginIndex:int = -1, endIndex:int = -1):TextFormat {
			return this.__textfield.getTextFormat(beginIndex, endIndex);
		};
		public function hide():void {
			if (this.__status.visible) {
				this.__status.visible = false;
				if ((this.__transition is ITransition)) {
					if (this.__transition.inTransition(this) == TransitionStatus.OUTRO) return;
					if (this.visible) {
						var _snapshot:BitmapData = new BitmapData(this.__textfield.width, this.__textfield.height, true, 0x00000000);
						_snapshot.draw(this.__textfield, null, new ColorTransform(), null, new Rectangle(0, 0, this.__textfield.width, this.__textfield.height));
						this.__textfield.visible = false;
						this.__snapshot.bitmapData = _snapshot;
						this.__transition.outro(this);
					}
					else this.__onTransitionClose();
				}
				else this.__onTransitionClose();
			}
			else this.__onTransitionClose();
		};
		public function replaceSelectedText(value:String):void {
			this.__textfield.replaceSelectedText(value);
		};
		public function replaceText(beginIndex:int, endIndex:int, newText:String):void {
			this.__textfield.replaceText(beginIndex, endIndex, newText);
		};
		public function resize(floatHeight:Number, floatWidth:Number):void {
			if (isNaN(floatHeight)) return;
			if (isNaN(floatWidth)) return;
			var _min:Number = this.__status.borderoffset + this.__status.borderthick;
			if (_min < 0) _min = 0;
			if (floatHeight < _min) return;
			if (floatWidth < _min) return;
			this.__status.height = floatHeight;
			this.__status.width = floatWidth;
			this.__resize();
		};
		public function setSelection(beginIndex:int, endIndex:int):void {
			this.__textfield.setSelection(beginIndex, endIndex);
		};
		public function setTextFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1):void {
			this.__textfield.setTextFormat(format, beginIndex, endIndex);
		};
		public function show():void {
			this.__status.visible = true;
			if (this.__transition is ITransition) {
				if (this.__transition.inTransition(this) == TransitionStatus.INTRO) return;
				var _snapshot:BitmapData = new BitmapData(this.__textfield.width, this.__textfield.height, true, 0x00000000);
				_snapshot.draw(this.__textfield, null, new ColorTransform(), null, new Rectangle(0, 0, this.__textfield.width, this.__textfield.height));
				this.__textfield.visible = false;
				this.__snapshot.bitmapData = _snapshot;
				this.__transition.intro(this);
			}
			else this.visible = true;
		};
	};
};