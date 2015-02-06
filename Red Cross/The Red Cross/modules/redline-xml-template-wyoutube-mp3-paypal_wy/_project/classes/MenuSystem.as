/**
 * MenuSystem
 * Multiple connected menus system
 *
 * @version		1.0
 */
package _project.classes	{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	//
	import _project.classes.GalleryEvent;
	import _project.classes.Menu;
	//
	public class MenuSystem extends EventDispatcher {
		//private constants...
		private const __ALIGN:Array = [ { id: "TL", x: 1, y: 0 }, { id: "TR", x: -1, y: 0 }, { id: "BL", x: 1, y: -1 }, { id: "BR", x: -1, y: -1 } ];
		private const __BASE:int = 0;
		private const __OFFSET:Object = { interX: -70, interY: -3, x: 3, y: 3 };
		//
		//private vars...
		private var __container:Sprite;
		private var __fixedheight:Number = 0;
		private var __menus:Array;
		private var __models:Array;
		private var __selections:Array;
		private var __startbutton:MovieClip;
		private var __status:Object;
		private var __transition:Function;
		//
		//constructor...
		public function MenuSystem(sContainer:Sprite, mcStartButton:MovieClip, arrayModels:Array, boolTextIsEmbedded:Boolean = false, strAlign:String = "TL", floatFixedHeight:Number = undefined, boolAutoSelect:Boolean = false, boolAutoHide:Boolean = true, fTransition:Function = undefined, arrayData:Array = undefined) {
			if (!(sContainer is Sprite)) return;
			if (!(mcStartButton is MovieClip)) return;
			if (!(arrayModels is Array)) return;
			if (arrayModels.length < 1) return;
			if (isNaN(floatFixedHeight)) floatFixedHeight = 0;
			this.__container = sContainer;
			this.__fixedheight = floatFixedHeight;
			this.__selections = [];
			this.__models = [];
			for (var m:int = 0; m < arrayModels.length; m++) {
				if (!arrayModels[m]) continue;
				if (!(arrayModels[m].drawmask is Function)) continue;
				if (!arrayModels[m].model) continue;
				this.__models.push(arrayModels[m]);
			};
			if (this.__models.length < 1) return;
			if (fTransition is Function) this.__transition = fTransition;
			this.__status = { autoselect: Boolean(boolAutoSelect), autohide: Boolean(boolAutoHide), embedded: Boolean(boolTextIsEmbedded), height: 0, items: undefined, reset: false, selected: undefined, width: 0 };
			strAlign = strAlign.toUpperCase();
			this.__status.align = 0;
			while (this.__status.align < this.__ALIGN.length && strAlign != this.__ALIGN[this.__status.align].id) this.__status.align++;
			if (this.__status.align >= this.__ALIGN.length) this.__status.align = 0;
			var _mainMenu:Menu = Menu(this.__container.addChild(new Menu(this.__models[0].drawmask, this.__models[0].model, this.__status.embedded, this.__models[0].bkg(), this.__models[0].padding, this.__transition())));
			_mainMenu.addEventListener(GalleryEvent.HIDE, this.__onHide);
			this.__menus = [_mainMenu];
			this.__startbutton = MovieClip(this.__container.addChild(mcStartButton));
			this.__startbutton.buttonMode = true;
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
			try {
				target.addEventListener(event, listener);
			}
			catch (_error:Error) {
				//...
			};
		};
		private function __hide():void {
			var _index:int = this.__menus.length - 1;
			if (this.__status.reset || !this.__menus[_index].mouseOver) {
				try {
					this.__menus[_index].removeEventListener(GalleryEvent.ITEM_CLICK, this.__onItemClick);
				}
				catch (_error:Error) {
					//...
				};
				try {
					this.__menus[_index].removeEventListener(GalleryEvent.ITEM_MOUSE_OUT, this.__onItemMouseOut);
				}
				catch (_error:Error) {
					//...
				};
				try {
					this.__menus[_index].removeEventListener(GalleryEvent.ITEM_MOUSE_OVER, this.__onItemMouseOver);
				}
				catch (_error:Error) {
					//...
				};
				try {
					this.__menus[_index].removeEventListener(GalleryEvent.ROLL_OUT, this.__onRollOut);
				}
				catch (_error:Error) {
					//...
				};
				try {
					this.__menus[_index].removeEventListener(GalleryEvent.ROLL_OVER, this.__onRollOver);
				}
				catch (_error:Error) {
					//...
				};
				if (_index == 0) {
					this.__addlistener(this.__startbutton, MouseEvent.ROLL_OVER, this.__onStartRollOver);
					this.__startbutton.setVisible(true);
					this.__menus[_index].hide();
				}
				else this.__menus[_index].reset();
			};
		};
		protected function __itemvalid(target:Menu):int {
			const _invalid:int = -1;
			//
			if (!(target is Menu)) return _invalid;
			for (var i:int = 0; i < this.__menus.length; i++ ) {
				if (this.__menus[i] == target) return i;
			};
			return _invalid;
		}
		private function __onAutoHide(event:GalleryEvent):void {
			try {
				this.__menus[0].removeEventListener(GalleryEvent.SHOW, this.__onAutoHide);
			}
			catch (_error:Error) {
				//...
			};
			var _timer:Timer = new Timer(500);
			_timer.addEventListener(TimerEvent.TIMER, this.__onTimer);
			_timer.start();
		};
		private function __onHide(event:GalleryEvent):void {
			var i:int = this.__itemvalid(Menu(event.currentTarget));
			if (i < 0) return;
			if (i > 0) {
				try {
					var _parentmenu:Menu = this.__menus[i - 1];
					if (this.__status.reset || !_parentmenu.mouseOver) {
						_parentmenu.locked = false;
						if (_parentmenu == this.__menus[0]) {
							this.__addlistener(this.__startbutton, MouseEvent.ROLL_OVER, this.__onStartRollOver);
							this.__startbutton.setVisible(true);
							_parentmenu.hide();
						}
						else _parentmenu.reset();
					};
				}
				catch (_error:Error) {
					//...
				};
			};
			if (i < this.__menus.length - 1) {
				try {
					var _childmenu:Menu = this.__menus[i + 1];
					_childmenu.locked = false;
					if (_childmenu.visible) {
						if (_childmenu == this.__menus[0]) {
							this.__addlistener(this.__startbutton, MouseEvent.ROLL_OVER, this.__onStartRollOver);
							this.__startbutton.setVisible(true);
							_childmenu.hide();
						}
						else _childmenu.reset();
					};
				}
				catch (_error:Error) {
					//...
				};
			};
		};
		private function __onItemClick(event:GalleryEvent):void {
			if (this.__status.reset) return;
			var i:int = this.__itemvalid(Menu(event.currentTarget));
			if (i < 0) return;
			this.__status.selected = this.__menus[i].selected;
			this.__selections = [];
			for (var j:int = 0; j <= i; j++) {
				try {
					this.__selections.push(this.__menus[j].rolledOver.index);
				}
				catch (_error:Error) {
					//...
				};
			};
			this.reset();
			this.dispatchEvent(new Event(Event.SELECT));
		};
		private function __onItemMouseOut(event:GalleryEvent):void {
			if (this.__status.reset) return;
			//...
		};
		private function __onItemMouseOver(event:GalleryEvent):void {
			if (this.__status.reset) return;
			var i:int = this.__itemvalid(Menu(event.currentTarget));
			if (i < 0) return;
			for (var j:int = i; j < this.__menus.length; j++) this.__menus[j].locked = false;
			if (i > 0) {
				for (var k:int = i - 1; k >= 0; k--) this.__menus[k].locked = true;
			};
			for (var r:int = i + 2; r < this.__menus.length; r++) this.__menus[r].reset();
			//
			var _node:Array = this.__menus[i].rolledOver.target.node;
			if (!(_node is Array)) _node = [];
			if (_node.length > 0) {
				if (this.__menus.length <= i + 1) {
					var _models:Object = (i + 1 >= this.__models.length) ? this.__models[this.__models.length - 1] : this.__models[i + 1];
					var _menu:Menu = Menu(this.__container.addChild(new Menu(_models.drawmask, _models.model, this.__status.embedded, _models.bkg(), _models.padding, this.__transition())));
					_menu.addEventListener(GalleryEvent.HIDE, this.__onHide);
					_menu.addEventListener(GalleryEvent.ITEM_CLICK, this.__onItemClick);
					_menu.addEventListener(GalleryEvent.SHOW, this.__onShow);
					this.__menus.push(_menu);
				};
				this.__menus[i + 1].locked = false;
				try {
					this.__menus[i + 1].removeEventListener(GalleryEvent.ROLL_OUT, this.__onRollOut);
				}
				catch (_error:Error) {
					//...
				};
				try {
					this.__addlistener(this.__menus[i + 1], GalleryEvent.UPDATED, this.__onUpdate);
				}
				catch (_error:Error) {
					//...
				};
				if (this.__fixedheight <= 0) {
					try {
						this.__menus[i + 1].y = this.__menus[i].rolledOver.y - this.__menus[i + 1].padding.top + this.__OFFSET.interY;
					}
					catch (_error:Error) {
						//...
					};
				};
				try {
					this.__menus[i + 1].load(this.__menus[i].rolledOver.target.node, this.__menus[i].rolledOver.index);
				}
				catch (_error:Error) {
					//...
				};
			}
			else if (i < this.__menus.length - 1) this.__menus[i + 1].reset();
		};
		private function __onLoadTimer(event:TimerEvent):void {
			if (!(this.__startbutton.setVisible is Function)) return;
			var _target:Timer = Timer(event.target);
			_target.removeEventListener(TimerEvent.TIMER, this.__onLoadTimer);
			_target.stop();
			//
			this.__addlistener(this.__menus[0], GalleryEvent.UPDATED, this.__onUpdateMain);
			this.__menus[0].load(this.__status.items, -1);
			this.__status.items = undefined;
		};
		private function __onRollOut(event:GalleryEvent):void {
			if (this.__status.reset) return;
			var i:int = this.__itemvalid(Menu(event.currentTarget));
			if (i < 0) return;
			var _locked:Boolean = false;
			try {
				for (var j:int = i + 1; j < this.__menus.length; j++) {
					if (this.__menus[j].mouseOver) {
						_locked = true;
						break;
					};
				};
			}
			catch (_error:Error) {
				//...
			};
			this.__menus[i].locked = _locked;
			if (!_locked) {
				try {
					if (this.__menus[i - 1].mouseOver) {
						if (this.__menus[i - 1].rolledOver.index == this.__menus[i].id) _locked = true;
					};
				}
				catch (_error:Error) {
					
				};
				if (!_locked) this.__hide();
			};
		};
		private function __onRollOver(event:GalleryEvent):void {
			if (this.__status.reset) return;
			var i:int = this.__itemvalid(Menu(event.currentTarget));
			if (i < 0) return;
			for (var j:int = i; j < this.__menus.length; j++) this.__menus[j].locked = false;
			for (var k:int = i - 1; k >= 0; k--) this.__menus[k].locked = true;
			//
			this.__hide();
		};
		private function __onShow(event:GalleryEvent = undefined):void {
			if (this.__status.reset) return;
			var i:int = this.__itemvalid(Menu(event.currentTarget));
			if (i < 0) return;
			if (i > 0) {
				var _node:Array = this.__menus[i - 1].rolledOver.target.node;
				if (!(_node is Array)) _node = [];
				if (_node.length <= 0) this.__hide();
			};
			var _target:Menu = this.__menus[i];
			this.__addlistener(_target, GalleryEvent.ROLL_OUT, this.__onRollOut);
			this.__addlistener(_target, GalleryEvent.ROLL_OVER, this.__onRollOver);
			this.__addlistener(_target, GalleryEvent.ITEM_MOUSE_OUT, this.__onItemMouseOut);
			this.__addlistener(_target, GalleryEvent.ITEM_MOUSE_OVER, this.__onItemMouseOver);
		};
		private function __onStartRollOver(event:MouseEvent):void {
			if (!(this.__startbutton.setVisible is Function)) return;
			this.__status.reset = false;
			try {
				this.__startbutton.removeEventListener(MouseEvent.ROLL_OVER, this.__onStartRollOver);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__menus[0].removeEventListener(GalleryEvent.ITEM_CLICK, this.__onItemClick);
			}
			catch (_error:Error) {
				//...
			};
			this.__startbutton.setVisible(false);
			this.__menus[0].locked = false;
			if (this.__selections.length > 0) this.__menus[0].selected = this.__selections[0];
			this.__addlistener(this.__menus[0], GalleryEvent.ITEM_CLICK, this.__onItemClick);
			this.__menus[0].show();
		};
		private function __onStartTimer(event:TimerEvent):void {
			var _target:Timer = Timer(event.target);
			_target.removeEventListener(TimerEvent.TIMER, this.__onStartTimer);
			_target.stop();
			this.__startbutton.setVisible(false);
		};
		private function __onTimer(event:TimerEvent):void {
			var _target:Timer = Timer(event.target);
			_target.removeEventListener(TimerEvent.TIMER, this.__onTimer);
			_target.stop();
			//
			this.__addlistener(this.__menus[0], GalleryEvent.ROLL_OUT, this.__onRollOut);
			this.__addlistener(this.__menus[0], GalleryEvent.ROLL_OVER, this.__onRollOver);
			this.__addlistener(this.__menus[0], GalleryEvent.ITEM_MOUSE_OUT, this.__onItemMouseOut);
			this.__addlistener(this.__menus[0], GalleryEvent.ITEM_MOUSE_OVER, this.__onItemMouseOver);
			this.__addlistener(this.__menus[0], GalleryEvent.SHOW, this.__onShow);
			//
			this.__menus[0].hide();
			//
			if (this.__startbutton is MovieClip) {
				this.__startbutton.addEventListener(MouseEvent.ROLL_OVER, this.__onStartRollOver);
				this.__startbutton.setVisible(true);
			};
		};
		private function __onUpdate(event:GalleryEvent):void {
			var i:int = this.__itemvalid(Menu(event.currentTarget));
			if (i < 0) return;
			if (!this.__status.reset) {
				var _target:Menu = this.__menus[i];
				try {
					var _parentmenu:Menu = this.__menus[i - 1];
					if (!_parentmenu.visible) return;
					this.__menus[i].x = _parentmenu.x + this.__ALIGN[this.__status.align].x * _parentmenu.width + ((this.__ALIGN[this.__status.align].x >= 0) ? 1 : -1) * this.__OFFSET.interX;
				}
				catch (_error:Error) {
					//...
				};
				try {
					var _height:Number = (this.__fixedheight > 0) ? this.__fixedheight : _target.fullHeight;
					var _stageH:Number = (this.__container.stage is Stage) ? this.__container.stage.stageHeight : 0;
					var _y:Number = this.__container.y + _target.y;
					if (_y + _height > -this.__ALIGN[this.__status.align].y * this.__container.y + (1 + this.__ALIGN[this.__status.align].y) * _stageH) _y = -this.__ALIGN[this.__status.align].y * this.__container.y + (1 + this.__ALIGN[this.__status.align].y) * _stageH - _height;
					if (_y < 0) _y = 0;
					if (_y + _height > -this.__ALIGN[this.__status.align].y * this.__container.y + (1 + this.__ALIGN[this.__status.align].y) * _stageH) _height = -this.__ALIGN[this.__status.align].y * this.__container.y + (1 + this.__ALIGN[this.__status.align].y) * _stageH - _y;
					_target.y = _y - this.__container.y;
					_target.height = _height;
				}
				catch (_error:Error) {
					//...
				};
				if (this.__selections.length > i) {
					var _valid:Boolean = true;
					for (var j:int = i - 1; j >= 0; j--) {
						try {
							if (this.__menus[j].rolledOver.index != this.__selections[j]) {
								_valid = false;
								break;
							};
						}
						catch (_error:Error) {
							//...
						};
					};
					if (_valid) {
						try {
							_target.removeEventListener(GalleryEvent.ITEM_CLICK, this.__onItemClick);
						}
						catch (_error:Error) {
							//...
						};
						_target.selected = this.__selections[i];
					};
				};
				this.__addlistener(_target, GalleryEvent.ITEM_CLICK, this.__onItemClick);
			};
		};
		private function __onUpdateMain(event:GalleryEvent):void {
			this.__status.items = undefined;
			var _target:Menu = Menu(event.target);
			try {
				_target.removeEventListener(GalleryEvent.UPDATED, this.__onUpdateMain);
			}
			catch (_error:Error) {
				//...
			};
			this.__addlistener(this.__menus[0], GalleryEvent.SHOW, (this.__status.autohide) ? this.__onAutoHide : this.__onShow);
			try {
				_target.x = ((this.__ALIGN[this.__status.align].x >= 0) ? 0 : this.__ALIGN[this.__status.align].x) * _target.width;
				var _height:Number = (this.__fixedheight > 0) ? this.__fixedheight : _target.fullHeight;
				var _y:Number = this.__ALIGN[this.__status.align].y * _height;
				if (this.__container.y + _y < 0) {
					_height = Math.abs(this.__container.y);
					_y = this.__ALIGN[this.__status.align].y * _height;
				};
				_target.y = _y;
				_target.height = _height;
			}
			catch (_error:Error) {
				//...
			};
			if (this.__startbutton.setVisible is Function) this.__startbutton.setVisible(false)
			else {
				var _timer:Timer = new Timer(10);
				_timer.addEventListener(TimerEvent.TIMER, this.__onStartTimer);
				_timer.start();
			};
			if (this.__status.autoselect) {
				this.__menus[0].selected = 0;
				this.__selections = [0];
				var _lastselected:Object = this.__menus[0].selected.target;
				var _submenus:Array = _lastselected.node;
				if (_submenus is Array) {
					if (_submenus.length < 1) _submenus = undefined;
				}
				else _submenus = undefined;
				while (_submenus) {
					_submenus = _lastselected.node;
					if (_submenus is Array) {
						if (_submenus.length < 1) _submenus = undefined
						else _lastselected = _submenus[0];
					}
					else _submenus = undefined;
					this.__selections.push(0);
				};
				//
				this.__status.selected = { index: 0, target: { attributes: { }, id: _lastselected.id, info: _lastselected.info } };
				for (var i in _lastselected.attributes) this.__status.selected.target.attributes[i] = _lastselected.attributes[i];
				this.dispatchEvent(new Event(Event.SELECT));
			};
			this.__menus[0].addEventListener(GalleryEvent.ITEM_CLICK, this.__onItemClick);
		};
		//
		//properties...
		public function get container():Sprite {
			return this.__container;
		};
		public function get selected():Object {
			return this.__status.selected;
		};
		public function get x():Number {
			return this.__container.x;
		};
		public function set x(value:Number):void {
			this.__container.x = value;
		};
		public function get y():Number {
			return this.__container.y;
		};
		public function set y(value:Number):void {
			this.__container.y = value;
		};
		//
		//public methods...
		public function load(arrayItems:Array):Boolean {
			if (this.__startbutton.setVisible is Function) {
				this.__status.items = undefined;
				this.__addlistener(this.__menus[0], GalleryEvent.UPDATED, this.__onUpdateMain);
				return this.__menus[0].load(arrayItems, -1);
			}
			else {
				this.__status.items = arrayItems;
				var _timer:Timer = new Timer(10);
				_timer.addEventListener(TimerEvent.TIMER, this.__onLoadTimer);
				_timer.start();
				return true;
			};
		};
		public function reset():void {
			this.__status.reset = true;
			this.__hide();
		};
	};
};