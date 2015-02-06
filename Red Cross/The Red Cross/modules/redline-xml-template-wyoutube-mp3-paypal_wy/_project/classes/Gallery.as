/**
 * Gallery
 * Basic gallery implementation
 *
 * @version		3.0
 */
package _project.classes {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import fl.transitions.TweenEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.utils.Timer;
	//
	import _project.classes.GalleryEvent;
	import _project.classes.ITransition;
	import _project.classes.ThumbSource;
	import _project.classes.TransitionStatus;
	//
	public class Gallery extends Sprite {
		//private constants...
		protected const __KBALOON_OFFSET:Object = { x: 0, y: -5 };
		protected const __KBKG_FX:Object = { intro: { duration: 2, finish: 1, transition: Strong.easeOut }, outro: { duration: 2, finish: 0, transition: Strong.easeOut }, prop: "alpha", useseconds: true };
		private const __KCOMPATIBLES:Object = { audio: [ "mp3" ], swf: [ "gif", "jpg", "png", "swf" ], video: [ "f4v", "flv", "mov", "mp4", "m4a", "mp4v" ] };
		private const __KTIMER_DELAY:Object = { rollout: 20, scroll: 20 };
		private const __KTYPE:String = "youtube";
		//
		//private vars...
		private var __baloon:MovieClip;
		protected var __bkg:*;
		protected var __bkgpool:BitmapData;
		protected var __drawmask:Function;
		protected var __hitarea:Sprite;
		private var __id:*;
		protected var __items:Array;
		protected var __list:Sprite;
		protected var __mask:Sprite;
		private var __model:Function;
		protected var __status:Object;
		private var __timer:Timer;
		private var __timerrollout:Timer;
		protected var __timerscroll:Timer;
		private var __thumbnails:Array;
		private var __thumbsource:ThumbSource;
		private var __transition:ITransition;
		private var __tween:Tween;
		//
		//constructor...
		public function Gallery(fDrawMask:Function, fModel:Function, boolTextIsEmbedded:Boolean = false, backGround:* = undefined, objPadding:Object = undefined, objTransition:ITransition = undefined, mcBaloon:MovieClip = undefined, objThumbSource:ThumbSource = undefined, arrayThumbnails:Array = undefined) {
			if (!(fDrawMask is Function)) return;
			if (!(fModel is Function)) return;
			if (!(mcBaloon is MovieClip)) {
				mcBaloon = undefined;
				objThumbSource = undefined;
				arrayThumbnails = undefined;
			}
			else if (!(objThumbSource is ThumbSource) && (!(arrayThumbnails is Array) || arrayThumbnails.length <= 0)) {
				mcBaloon = undefined;
				objThumbSource = undefined;
				arrayThumbnails = undefined;
			};
			this.visible = false;
			this.__drawmask = fDrawMask;
			this.__model = fModel;
			if (mcBaloon is MovieClip) this.__baloon = mcBaloon;
			this.__items = [];
			this.__status = { embedded: Boolean(boolTextIsEmbedded), height: this.__model().height, _height: this.__model().height, items: [], padding: { bottom: 0, left: 0, right: 0, top: 0 }, 
							  reset: false, rolledover: undefined, selected: undefined, width: this.__model().width, _width: this.__model().width };//NOTE: rolledover:int, selected:MovieClip
			if (objPadding) {
				for (var j in this.__status.padding) {
					if (isNaN(objPadding[j])) continue;
					if (objPadding[j] < 0) continue;
					this.__status.padding[j] = objPadding[j];
				};
			};
			this.__status.height += this.__status.padding.bottom + this.__status.padding.top;
			this.__status.width += this.__status.padding.left + this.__status.padding.right;
			if (objTransition is ITransition) {
				this.__transition = objTransition;
				this.__transition.addEventListener(Event.CLOSE, this.__onTransitionClose);
				this.__transition.addEventListener(Event.OPEN, this.__onTransitionOpen);
			};
			if (mcBaloon is MovieClip) this.__baloon = mcBaloon;
			if (objThumbSource is ThumbSource) this.__thumbsource = objThumbSource;
			if (arrayThumbnails is Array) {
				this.__thumbnails = [];
				for (var t:int = 0; t < arrayThumbnails.length; t++) this.__thumbnails.push( { type: arrayThumbnails[t].type, thumb: arrayThumbnails[t].thumb } );
			};
			if (backGround is BitmapData) {
				this.__bkgpool = this.__pattern(backGround, Capabilities.screenResolutionY, Capabilities.screenResolutionX);
				this.__bkg = Bitmap(this.addChild(new Bitmap()));
			}
			else if (backGround is MovieClip) {
				this.__bkg = MovieClip(this.addChild(backGround));
				this.__bkg.stop();
				this.__bkg.height = this.__status.height;
				this.__bkg.width = this.__status.width;
			};
			this.__hitarea = Sprite(this.addChild(new Sprite()));
			this.__hitarea.alpha = 0;
			this.__hitarea.x = this.__status.padding.left;
			this.__hitarea.y = this.__status.padding.top;
			this.__mask = Sprite(this.addChild(new Sprite()));
			this.__mask.visible = false;
			this.__mask.x = this.__hitarea.x;
			this.__mask.y = this.__hitarea.y;
			this.__timer = new Timer(20);
			this.__timer.stop();
			this.__timerrollout = new Timer(this.__KTIMER_DELAY.rollout);
			this.__timerrollout.reset();
			this.__timerrollout.addEventListener(TimerEvent.TIMER, this.__rollout);
			this.__timerscroll = new Timer(this.__KTIMER_DELAY.scroll);
			this.__timerscroll.stop();
			this.__timerscroll.addEventListener(TimerEvent.TIMER, this.__onTimerScroll);
			//
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.__onMouseMove);
			this.addEventListener(MouseEvent.ROLL_OUT, this.__onRollOut);
			this.addEventListener(MouseEvent.ROLL_OVER, this.__onRollOver);
		};
		//
		//private methods...
		protected function __addlistener(target:EventDispatcher, event:String, listener:Function):void {
			try {
				target.removeEventListener(event, listener);
			}
			catch (_error:Error) {
				//...
			};
			target.addEventListener(event, listener);
		};
		protected function __itemvalid(target:MovieClip):int {
			const _invalid:int = -1;
			//
			if (!(target is MovieClip)) return _invalid;
			for (var i:int = 0; i < this.__items.length; i++ ) {
				if (this.__items[i].container == target) return i;
			};
			return _invalid;
		};
		private function __load():void {
			if (this.__status.items is Array) {
				this.__items = [];
				try {
					this.__list.mask = null;
				}
				catch (_error:Error) {
					//...
				};
				try {
					this.removeChild(this.__list);
				}
				catch (_error:Error) {
					//...
				};
				if (this.__status.items.length > 0) {
					this.__list = Sprite(this.addChild(new Sprite()));
					this.__list.x = this.__mask.x;
					this.__list.y = this.__mask.y;
					this.__list.mask = this.__mask;
					//
					for (var i:int = 0; i < this.__status.items.length; i++) {
						var _container:MovieClip = MovieClip(this.__list.addChild(this.__model()));
						if (!(_container is MovieClip)) break;
						var _item:Object = this.__status.items[i];
						this.__items.push( { attributes: _item.attributes, container: _container, id: (_item.id) ? _item.id : i, info: _item.info, node: _item.node, thumb: _item.thumb, type: _item.type, url: _item.url } );
					};
					if (this.__thumbsource is ThumbSource) {
						var _thumbs:Array = [];
						for (var j:int = 0; j < this.__items.length; j++) _thumbs.push(this.__items[j].thumb);
						this.__thumbsource.load(_thumbs);
					};
					this.__id = this.__status.id;
					this.__status.id = undefined;
					this.__status.items = undefined;
					this.__timer.stop();
					this.__addlistener(this.__timer, TimerEvent.TIMER, this.__onTimer);
					this.__timer.start();
				}
				else {
					this.__status.items = undefined;
					this.dispatchEvent(new GalleryEvent(GalleryEvent.UPDATED));
				};
			};
		};
		private function __onFxFinish(event:TweenEvent):void {
			if (!(this.__tween is Tween)) return;
			this.__tween.stop();
			this.__removelistener(this.__tween, TweenEvent.MOTION_FINISH, this.__onFxFinish);
			this.__tween = undefined;
		};
		protected function __onItemClick(event:MouseEvent):void {
			if (this.__status.selected == event.currentTarget) return;
			try {
				this.__status.selected.setSelected(false);
			}
			catch (_error:Error) {
				//...
			};
			try {
				event.currentTarget.setSelected(true);
			}
			catch (_error:Error) {
				//...
			};
			this.__status.selected = event.currentTarget;
			this.dispatchEvent(new GalleryEvent(GalleryEvent.ITEM_CLICK));
		};
		protected function __onItemMouseOut(target:MovieClip):void {
			var _index:int = this.__itemvalid(target);
			if (_index >= 0) this.dispatchEvent(new GalleryEvent(GalleryEvent.ITEM_MOUSE_OUT));
		};
		protected function __onItemMouseOver(target:MovieClip):void {
			var _index:int = this.__itemvalid(target);
			if (_index >= 0) {
				this.__timerrollout.stop();
				try {
					var _thumb:BitmapData = this.__thumbsource.thumb(this.__items[_index].thumb);
					if (!(_thumb is BitmapData)) {
						if (this.__thumbnails is Array) {
							var _type:String = this.__items[_index].type;
							for (var j in this.__thumbnails) {
								if (_type == this.__thumbnails[j].type) {
									_thumb = this.__thumbnails[j].thumb;
									break;
								};
							};
						};
					};
					this.__baloon.setContent(_thumb);
				}
				catch (_error:Error) {
					//...
				};
				try {
					var _coord:Point = this.__mask.localToGlobal(new Point(this.__mask.mouseX, this.__mask.mouseY));
					this.__baloon.x = _coord.x + this.__KBALOON_OFFSET.x;
					this.__baloon.y = _coord.y - this.__baloon.height + this.__KBALOON_OFFSET.y;
				}
				catch (_error:Error) {
					//...
				};
				if (this.__status.rolledover != _index) {
					this.__status.rolledover = _index;
					this.dispatchEvent(new GalleryEvent(GalleryEvent.ITEM_MOUSE_OVER));
				};
			};
		};
		private function __onMouseMove(event:MouseEvent):void {
			var _valid:Boolean = true;
			if (this.__mask.mouseX < 0) _valid = false
			else if (this.__mask.mouseX > this.__mask.width) _valid = false
			else if (this.__mask.mouseY < 0) _valid = false
			else if (this.__mask.mouseY > this.__mask.height) _valid = false;
			if (_valid) {
				if (!this.__timerscroll.running) this.__timerscroll.start();
				if (this.__baloon is MovieClip) {
					var _coord:Point = this.__mask.localToGlobal(new Point(this.__mask.mouseX, this.__mask.mouseY));
					this.__baloon.x = _coord.x + this.__KBALOON_OFFSET.x;
					this.__baloon.y = _coord.y - this.__baloon.height + this.__KBALOON_OFFSET.y;
				};
			}
			else {
				this.__timerscroll.stop();
				if (this.__baloon is MovieClip) this.__baloon.setContent();
			};
		};
		protected function __onRollOut(event:MouseEvent):void {
			this.__timerscroll.reset();
			this.__timerrollout.start();
			try {
				this.__baloon.setContent();
			}
			catch (_error:Error) {
				//...
			};
		};
		protected function __onRollOver(event:MouseEvent):void {
			this.dispatchEvent(new GalleryEvent(GalleryEvent.ROLL_OVER));
		};
		private function __onTimer(event:TimerEvent):void {
			if (this.__items is Array) {
				if (this.__items.length > 0) {
					for (var t:int = this.__items.length - 1; t >= 0; t--) {
						if (!(this.__items[t].container.setInfo is Function)) return;
						if (!(this.__items[t].container.setLocked is Function)) return;
						if (!(this.__items[t].container.setSelected is Function)) return;
					};
				};
			};
			this.__timer.removeEventListener(TimerEvent.TIMER, this.__onTimer);
			this.__timer.stop();
			var i:int;
			for (i = 0; i < this.__items.length; i++) this.__items[i].container.setInfo(this.__items[i].info);
			this.__updatepositions();
			for (i = 0; i < this.__items.length; i++) {
				var _item:MovieClip = this.__items[i].container;
				this.__addlistener(_item, MouseEvent.CLICK, this.__onItemClick);
				_item.isMouseOut = this.__onItemMouseOut;
				_item.isMouseOver = this.__onItemMouseOver;
			};
			this.height = this.__status.height;
			this.width = this.__status.width;
			this.dispatchEvent(new GalleryEvent(GalleryEvent.UPDATED));
			this.show();
		};
		protected function __onTimerScroll(event:TimerEvent):void {
			//blind...
		};
		protected function __onTransitionClose(event:Event = undefined):void {
			try {
				this.__list.visible = true;
			}
			catch (_error:Error) {
				//...
			};
			this.visible = false;
			this.__status.reset = false;
			this.__status.rolledover = undefined;
			this.__load();
			this.dispatchEvent(new GalleryEvent(GalleryEvent.HIDE));
		};
		protected function __onTransitionOpen(event:Event = undefined):void {
			try {
				this.__list.visible = true;
			}
			catch (_error:Error) {
				//...
			};
			this.dispatchEvent(new GalleryEvent(GalleryEvent.SHOW))
		};
		protected function __pattern(bmpSource:BitmapData, floatHeight:Number, floatWidth:Number):BitmapData {
			if (!(bmpSource is BitmapData)) return undefined;
			if (isNaN(floatHeight)) return undefined;
			if (floatHeight <= 0) return undefined;
			if (isNaN(floatWidth)) return undefined;
			if (floatWidth <= 0) return undefined;
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
		protected function __removelistener(target:EventDispatcher, event:String, listener:Function):void {
			try {
				target.removeEventListener(event, listener);
			}
			catch (_error:Error) {
				//...
			};
		};
		private function __rollout(event:TimerEvent):void {
			this.__timerrollout.reset();
			this.dispatchEvent(new GalleryEvent(GalleryEvent.ROLL_OUT));
		};
		protected function __showselected():void {
			//...
		};
		protected function __updatepositions():void {
			//...
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
		public function get background():* {
			return this.__bkg;
		};
		public function get durationIntro():Number {
			return ((this.__transition is ITransition) ? this.__transition.durationIntro : 0);
		};
		public function get durationOutro():Number {
			return ((this.__transition is ITransition) ? this.__transition.durationOutro : 0);
		};
		public function get fullHeight():Number {
			return undefined;
		};
		public function get fullWidth():Number {
			return undefined;
		};
		public override function get height():Number {
			return this.__status.height;
		};
		public override function set height(floatHeight:Number):void {
			//...
		};
		public function get id():* {
			return this.__id;
		};
		public function get mouseOver():Boolean {
			if (!this.visible) return false;
			if (this.__bkg.mouseX < 0) return false;
			if (this.__bkg.mouseX > this.__bkg.width / this.__bkg.scaleX) return false;
			if (this.__bkg.mouseY < 0) return false;
			if (this.__bkg.mouseY > this.__bkg.height / this.__bkg.scaleY) return false;
			return true;
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
				this.__status.padding[i] = ((objPadding[i] < 0) ? 0 : objPadding[i]);
				_resize = true;
			};
			if (_resize) {
				this.__hitarea.x = this.__status.padding.left;
				this.__hitarea.y = this.__status.padding.top;
				this.__mask.x = this.__hitarea.x;
				this.__mask.y = this.__hitarea.y;
				this.height = this.__status.height;
				this.width = this.__status.width;
			};
		};
		public function get rolledOver():Object {
			if (this.__items.length < 1) return undefined;
			if (isNaN(this.__status.rolledover)) return undefined;
			var _item:Object = this.__items[this.__status.rolledover];
			var _rolledover:Object = { index: this.__status.rolledover, target: {}, x: this.x + this.__list.x + _item.container.x, y: this.y + this.__list.y + _item.container.y };
			for (var j in _item) _rolledover.target[j] = _item[j];
			try {
				_rolledover.target.container = undefined;
			}
			catch (_error:Error) {
				//...
			};
			return _rolledover;
		};
		public function get selected():Object {
			if (!(this.__status.selected is MovieClip)) return undefined;
			if (this.__items.length < 1) return undefined;
			for (var i:int = 0; i < this.__items.length; i++) {
				if (this.__items[i].container == this.__status.selected) {
					var _item:Object = this.__items[i];
					var _selected:Object = { index: i, target: {}, x: this.x + this.__list.x + _item.container.x, y: this.y + this.__list.y + _item.container.y };
					for (var j in _item) _selected.target[j] = _item[j];
					try {
						_selected.target.container = undefined;
					}
					catch (_error:Error) {
						//...
					};
					return _selected;
				};
			};
			return undefined;
		};
		public function set selected(objSelected:Object):void {
			var _selected:int = int(objSelected);
			if (isNaN(_selected)) return;
			if (_selected < 0) return;
			if (_selected >= this.__items.length) return;
			//
			try {
				this.__status.selected.setSelected(false);
			}
			catch (_error:Error) {
				//...
			};
			this.__status.selected = this.__items[_selected].container;
			try {
				this.__status.selected.setSelected(true);
			}
			catch (_error:Error) {
				//...
			};
			this.__showselected();
			this.dispatchEvent(new GalleryEvent(GalleryEvent.ITEM_CLICK));
		};
		public override function get width():Number {
			return this.__status.width;
		};
		public override function set width(floatWidth:Number):void {
			//...
		};
		//
		//public methods...
		public function hide():void {
			if ((this.__transition is ITransition)) {
				if (this.__transition.inTransition(this) == TransitionStatus.OUTRO) return;
				if (this.visible) {
					try {
						this.__list.visible = this.__status.embedded;
					}
					catch (_error:Error) {
						//...
					};
					this.__transition.outro(this);
				}
				else this.__onTransitionClose();
			}
			else this.__onTransitionClose();
		};
		public function hideBkg():void {
			if (!(this.__bkg is DisplayObject)) return;
			if (!this.__bkg.visible) return;
			if (this.__bkg[this.__KBKG_FX.prop] != this.__KBKG_FX.outro.finish) {
				if (this.__tween is Tween) {
					this.__tween.stop();
					this.__removelistener(this.__tween, TweenEvent.MOTION_FINISH, this.__onFxFinish);
				};
				this.__tween = new Tween(this.__bkg, this.__KBKG_FX.prop, this.__KBKG_FX.outro.transition, this.__bkg[this.__KBKG_FX.prop], this.__KBKG_FX.outro.finish, this.__KBKG_FX.outro.duration, this.__KBKG_FX.useseconds);
				this.__addlistener(this.__tween, TweenEvent.MOTION_FINISH, this.__onFxFinish);
			};
		};
		public function load(arrayItems:Array, galleryId:* = undefined):Boolean {
			if (!(arrayItems is Array)) return false;
			//
			var _items:Array = [];
			for (var i:int = 0; i < arrayItems.length; i++) {
				var _item:* = arrayItems[i];
				if (!_item) continue
				else {
					var _target:Object;
					var _extension:String;
					var _valid:Boolean = false;
					var t:String, e:String;
					if (_item is String) {
						if (_item == "") continue;
						_target = this.__urlsplitter(_item);
						if (_target.filename == "") continue;
						if (_target.fileextension == "") _items.push( { info: _target.filename, thumb: (t != "swf") ? undefined : _item, type: this.__KTYPE, url: _item } )
						else {
							_extension = _target.fileextension.toLowerCase();
							for (t in this.__KCOMPATIBLES) {
								for (e in this.__KCOMPATIBLES[t]) {
									if (_extension == this.__KCOMPATIBLES[t][e]) {
										_items.push( { info: _target.filename, thumb: (t != "swf") ? undefined : _item, type: t, url: _item } );
										_valid = true;
										break;
									};
								};
								if (_valid) break;
							};
						};
					}
					else {
						var _newitem:Object = { attributes: _item.attributes, 
												info: (_item.info is String) ? _item.info : "", 
												node: _item.node,
												thumb: (_item.thumb is String) ? _item.thumb : "", 
												type: (_item.type is String) ? _item.type : "", 
												url: (_item.url is String) ? _item.url : "" };
						if (_newitem.info == "") {
							if (_newitem.url == "") continue;
							_target = this.__urlsplitter(_item.url);
							if (_target.filename == "") continue;
							_newitem.info = _target.filename;
						}
						else if (_newitem.type == "") {
							if (_newitem.url != "") _target = this.__urlsplitter(_item.url);
						};
						if (_newitem.type == "") {
							if (_target) {
								_extension = _target.fileextension.toLowerCase();
								for (t in this.__KCOMPATIBLES) {
									for (e in this.__KCOMPATIBLES[t]) {
										if (_extension == this.__KCOMPATIBLES[t][e]) {
											_newitem.type = t;
											if (!(_newitem.thumb is String) || _newitem.thumb == "") _newitem.thumb = (t != "swf") ? undefined : _newitem.url;
											_items.push(_newitem);
											_valid = true;
											break;
										};
									};
									if (_valid) break;
								};
								if (!_valid) {
									_newitem.type = this.__KTYPE;
									_items.push(_newitem);
								};
							}
							else _items.push(_newitem);
						}
						else _items.push(_newitem);
					};
				};
			};
			this.__timer.stop();
			try {
				this.__timer.removeEventListener(TimerEvent.TIMER, this.__onTimer);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__status.id = undefined;
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__status.id = galleryId;
			}
			catch (_error:Error) {
				//...
			};
			this.__items = [];
			this.__status.items = _items;
			this.__status.selected = undefined;
			this.hide();
			//
			return true;
		};
		public function reset():void {
			if (this.__status.reset) return;
			this.__status.reset = true;
			if (this.__thumbsource is _project.classes.ThumbSource) this.__thumbsource.suspend();
			this.load(new Array());
		};
		public function selectnext():Boolean {
			if (this.__items.length < 1) return false;
			if (this.__status.selected is MovieClip) {
				var _invalid:Boolean = true;
				for (var i:int = 0; i < this.__items.length; i++) {
					if (this.__items[i].container == this.__status.selected) {
						this.selected = (i < this.__items.length - 1) ? i + 1 : 0;
						_invalid = false;
						break;
					};
				};
				if (_invalid) this.selected = 0;
			}
			else this.selected = 0;
			return true;
		};
		public function selectprevious():Boolean {
			if (this.__items.length < 1) return false;
			if (this.__status.selected is MovieClip) {
				var _invalid:Boolean = true;
				for (var i:int = 0; i < this.__items.length; i++) {
					if (this.__items[i].container == this.__status.selected) {
						this.selected = (i > 0) ? i - 1 : this.__items.length - 1;
						_invalid = false;
						break;
					};
				};
				if (_invalid) this.selected = 0;
			}
			else this.selected = 0;
			return true;
		};
		public function show():void {
			if (this.__status.reset) return;
			if (this.__transition is ITransition) {
				if (this.__transition.inTransition(this) == TransitionStatus.INTRO) return;
				try {
					this.__list.visible = this.__status.embedded;
				}
				catch (_error:Error) {
					//...
				};
				this.__transition.intro(this);
			}
			else this.visible = true;
			if (this.__bkg is MovieClip) {
				if (this.__bkg.startAnimation is Function) this.__bkg.startAnimation()
				else this.__bkg.gotoAndPlay(1);
			};
		};
		public function showBkg():void {
			if (!(this.__bkg is DisplayObject)) return;
			if (!this.__bkg.visible) return;
			if (this.__bkg[this.__KBKG_FX.prop] != this.__KBKG_FX.intro.finish) {
				if (this.__tween is Tween) {
					this.__tween.stop();
					this.__removelistener(this.__tween, TweenEvent.MOTION_FINISH, this.__onFxFinish);
				};
				this.__tween = new Tween(this.__bkg, this.__KBKG_FX.prop, this.__KBKG_FX.intro.transition, this.__bkg[this.__KBKG_FX.prop], this.__KBKG_FX.intro.finish, this.__KBKG_FX.intro.duration, this.__KBKG_FX.useseconds);
				this.__addlistener(this.__tween, TweenEvent.MOTION_FINISH, this.__onFxFinish);
			};
		};
		public function thumbresume():void {
			if (!(this.__thumbsource is ThumbSource)) return;
			this.__thumbsource.resume();
		};
		public function thumbsuspend():void {
			if (!(this.__thumbsource is ThumbSource)) return;
			this.__thumbsource.suspend();
		};
	};
};