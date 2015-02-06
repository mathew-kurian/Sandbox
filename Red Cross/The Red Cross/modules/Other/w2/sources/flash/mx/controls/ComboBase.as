class mx.controls.ComboBase extends mx.core.UIComponent
{
	var getValue, tabEnabled, tabChildren, boundingBox_mc, downArrow_mc, createClassObject, onDownArrow, border_mc, __border, text_mc, focusTextField, __width, __height, getFocusManager, __get__height, height, _parent;
	function ComboBase () {
		super();
		getValue = _getValue;
	}
	function init() {
		super.init();
		tabEnabled = !_editable;
		tabChildren = _editable;
		boundingBox_mc._visible = false;
		boundingBox_mc._width = (boundingBox_mc._height = 0);
	}
	function createChildren() {
		var _local3 = new Object();
		_local3.styleName = this;
		if (downArrow_mc == undefined) {
			_local3.falseUpSkin = downArrowUpName;
			_local3.falseOverSkin = downArrowOverName;
			_local3.falseDownSkin = downArrowDownName;
			_local3.falseDisabledSkin = downArrowDisabledName;
			_local3.validateNow = true;
			_local3.tabEnabled = false;
			createClassObject(mx.controls.SimpleButton, "downArrow_mc", 19, _local3);
			downArrow_mc.buttonDownHandler = onDownArrow;
			downArrow_mc.useHandCursor = false;
			downArrow_mc.onPressWas = downArrow_mc.onPress;
			downArrow_mc.onPress = function () {
				this.trackAsMenuWas = this.trackAsMenu;
				this.trackAsMenu = true;
				if (!this._editable) {
					this._parent.text_mc.trackAsMenu = this.trackAsMenu;
				}
				this.onPressWas();
			};
			downArrow_mc.onDragOutWas = downArrow_mc.onDragOut;
			downArrow_mc.onDragOut = function () {
				this.trackAsMenuWas = this.trackAsMenu;
				this.trackAsMenu = false;
				if (!this._editable) {
					this._parent.text_mc.trackAsMenu = this.trackAsMenu;
				}
				this.onDragOutWas();
			};
			downArrow_mc.onDragOverWas = downArrow_mc.onDragOver;
			downArrow_mc.onDragOver = function () {
				this.trackAsMenu = this.trackAsMenuWas;
				if (!this._editable) {
					this._parent.text_mc.trackAsMenu = this.trackAsMenu;
				}
				this.onDragOverWas();
			};
		}
		if (border_mc == undefined) {
			_local3.tabEnabled = false;
			createClassObject(_global.styles.rectBorderClass, "border_mc", 17, _local3);
			border_mc.move(0, 0);
			__border = border_mc;
		}
		_local3.borderStyle = "none";
		_local3.readOnly = !_editable;
		_local3.tabEnabled = _editable;
		if (text_mc == undefined) {
			createClassObject(mx.controls.TextInput, "text_mc", 18, _local3);
			text_mc.move(0, 0);
			text_mc.addEnterEvents();
			text_mc.enterHandler = _enterHandler;
			text_mc.changeHandler = _changeHandler;
			text_mc.oldOnSetFocus = text_mc.onSetFocus;
			text_mc.onSetFocus = function () {
				this.oldOnSetFocus();
				this._parent.onSetFocus();
			};
			text_mc.__set__restrict("^\x1B");
			text_mc.oldOnKillFocus = text_mc.onKillFocus;
			text_mc.onKillFocus = function (n) {
				this.oldOnKillFocus(n);
				this._parent.onKillFocus(n);
			};
			text_mc.drawFocus = function (b) {
				this._parent.drawFocus(b);
			};
			delete text_mc.borderStyle;
		}
		focusTextField = text_mc;
		text_mc.owner = this;
		layoutChildren(__width, __height);
	}
	function onKillFocus() {
		super.onKillFocus();
		Key.removeListener(text_mc);
		getFocusManager().defaultPushButtonEnabled = true;
	}
	function onSetFocus() {
		super.onSetFocus();
		getFocusManager().defaultPushButtonEnabled = false;
		Key.addListener(text_mc);
	}
	function setFocus() {
		if (_editable) {
			Selection.setFocus(text_mc);
		} else {
			Selection.setFocus(this);
		}
	}
	function setSize(w, h, noEvent) {
		super.setSize(w, ((h == undefined) ? (__get__height()) : (h)), noEvent);
	}
	function setEnabled(enabledFlag) {
		super.setEnabled(enabledFlag);
		downArrow_mc.enabled = enabledFlag;
		text_mc.enabled = enabledFlag;
	}
	function setEditable(e) {
		_editable = e;
		if (wrapDownArrowButton == false) {
			if (e) {
				border_mc.borderStyle = "inset";
				text_mc.borderStyle = "inset";
				symbolName = "ComboBox";
				invalidateStyle();
			} else {
				border_mc.borderStyle = "comboNonEdit";
				text_mc.borderStyle = "dropDown";
				symbolName = "DropDown";
				invalidateStyle();
			}
		}
		tabEnabled = !e;
		tabChildren = e;
		text_mc.tabEnabled = e;
		if (e) {
			delete text_mc.onPress;
			delete text_mc.onRelease;
			delete text_mc.onReleaseOutside;
			delete text_mc.onDragOut;
			delete text_mc.onDragOver;
			delete text_mc.onRollOver;
			delete text_mc.onRollOut;
		} else {
			text_mc.onPress = function () {
				this._parent.downArrow_mc.onPress();
			};
			text_mc.onRelease = function () {
				this._parent.downArrow_mc.onRelease();
			};
			text_mc.onReleaseOutside = function () {
				this._parent.downArrow_mc.onReleaseOutside();
			};
			text_mc.onDragOut = function () {
				this._parent.downArrow_mc.onDragOut();
			};
			text_mc.onDragOver = function () {
				this._parent.downArrow_mc.onDragOver();
			};
			text_mc.onRollOver = function () {
				this._parent.downArrow_mc.onRollOver();
			};
			text_mc.onRollOut = function () {
				this._parent.downArrow_mc.onRollOut();
			};
			text_mc.useHandCursor = false;
		}
	}
	function get editable() {
		return(_editable);
	}
	function set editable(e) {
		setEditable(e);
		//return(editable);
	}
	function _getValue() {
		return((_editable ? (text_mc.getText()) : (DSgetValue())));
	}
	function draw() {
		downArrow_mc.draw();
		border_mc.draw();
	}
	function size() {
		layoutChildren(__width, __height);
	}
	function setTheme(t) {
		downArrowUpName = (t + "downArrow") + "Up_mc";
		downArrowDownName = (t + "downArrow") + "Down_mc";
		downArrowDisabledName = (t + "downArrow") + "Disabled_mc";
	}
	function get text() {
		return(text_mc.getText());
	}
	function set text(t) {
		setText(t);
		//return(text);
	}
	function setText(t) {
		text_mc.setText(t);
	}
	function get textField() {
		return(text_mc);
	}
	function get restrict() {
		return(text_mc.__get__restrict());
	}
	function set restrict(w) {
		text_mc.__set__restrict(w);
		//return(restrict);
	}
	function invalidateStyle() {
		downArrow_mc.invalidateStyle();
		text_mc.invalidateStyle();
		border_mc.invalidateStyle();
	}
	function layoutChildren(w, h) {
		if (downArrow_mc == undefined) {
			return(undefined);
		}
		if (wrapDownArrowButton) {
			var _local2 = border_mc.__get__borderMetrics();
			downArrow_mc._width = (downArrow_mc._height = (h - _local2.top) - _local2.bottom);
			downArrow_mc.move((w - downArrow_mc._width) - _local2.right, _local2.top);
			border_mc.setSize(w, h);
			text_mc.setSize(w - downArrow_mc._width, h);
		} else {
			downArrow_mc.move(w - downArrow_mc._width, 0);
			border_mc.setSize(w - downArrow_mc.width, h);
			text_mc.setSize(w - downArrow_mc._width, h);
			downArrow_mc._height = height;
		}
	}
	function _changeHandler(obj) {
	}
	function _enterHandler(obj) {
		var _local2 = _parent;
		obj.target = _local2;
		_local2.dispatchEvent(obj);
	}
	function get tabIndex() {
		return(text_mc.__get__tabIndex());
	}
	function set tabIndex(w) {
		text_mc.__set__tabIndex(w);
		//return(tabIndex);
	}
	static var mixIt1 = mx.controls.listclasses.DataSelector.Initialize(mx.controls.ComboBase);
	static var symbolName = "ComboBase";
	static var symbolOwner = mx.controls.ComboBase;
	static var version = "2.0.2.127";
	var _editable = false;
	var downArrowUpName = "ScrollDownArrowUp";
	var downArrowDownName = "ScrollDownArrowDown";
	var downArrowOverName = "ScrollDownArrowOver";
	var downArrowDisabledName = "ScrollDownArrowDisabled";
	var wrapDownArrowButton = true;
	var DSgetValue = mx.controls.listclasses.DataSelector.prototype.getValue;
	var multipleSelection = false;
}
