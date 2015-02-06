class mx.controls.ComboBox extends mx.controls.ComboBase
{
	var __set__editable, editable, __labels, data, __dropdownWidth, __width, _editable, selectedIndex, __dropdown, dataProvider, __labelFunction, createObject, border_mc, mask, text_mc, dispatchValueChangedEvent, getValue, length, selectedItem, _y, isPressed, owner, __set__visible, height, localToGlobal, __selectedIndexOnDropdown, __initialSelectedIndexOnDropdown, __get__height, getStyle, _parent, width, __dataProvider, selected, dispatchEvent;
	function ComboBox () {
		super();
	}
	function init() {
		super.init();
	}
	function createChildren() {
		super.createChildren();
		__set__editable(editable);
		if (__labels.length > 0) {
			var _local6 = new Array();
			var _local3 = 0;
			while (_local3 < labels.length) {
				_local6.addItem({label:labels[_local3], data:data[_local3]});
				_local3++;
			}
			setDataProvider(_local6);
		}
		dropdownWidth = (((typeof(__dropdownWidth) == "number") ? (__dropdownWidth) : (__width)));
		if (!_editable) {
			selectedIndex = 0;
		}
		initializing = false;
	}
	function onKillFocus(n) {
		if (_showingDropdown && (n != null)) {
			displayDropdown(false);
		}
		super.onKillFocus();
	}
	function getDropdown() {
		if (initializing) {
			return(undefined);
		}
		if (!hasDropdown()) {
			var _local3 = new Object();
			_local3.styleName = this;
			if (dropdownBorderStyle != undefined) {
				_local3.borderStyle = dropdownBorderStyle;
			}
			_local3._visible = false;
			__dropdown = mx.managers.PopUpManager.createPopUp(this, mx.controls.List, false, _local3, true);
			__dropdown.scroller.mask.removeMovieClip();
			if (dataProvider == undefined) {
				dataProvider = new Array();
			}
			__dropdown.setDataProvider(dataProvider);
			__dropdown.selectMultiple = false;
			__dropdown.rowCount = __rowCount;
			__dropdown.selectedIndex = selectedIndex;
			__dropdown.vScrollPolicy = "auto";
			__dropdown.labelField = __labelField;
			__dropdown.labelFunction = __labelFunction;
			__dropdown.owner = this;
			__dropdown.changeHandler = _changeHandler;
			__dropdown.scrollHandler = _scrollHandler;
			__dropdown.itemRollOverHandler = _itemRollOverHandler;
			__dropdown.itemRollOutHandler = _itemRollOutHandler;
			__dropdown.resizeHandler = _resizeHandler;
			__dropdown.mouseDownOutsideHandler = function (eventObj) {
				var _local3 = this.owner;
				var _local4 = new Object();
				_local4.x = _local3._root._xmouse;
				_local4.y = _local3._root._ymouse;
				_local3._root.localToGlobal(_local4);
				if (_local3.hitTest(_local4.x, _local4.y, false)) {
				} else if ((!this.wrapDownArrowButton) && (this.owner.downArrow_mc.hitTest(_root._xmouse, _root._ymouse, false))) {
				} else {
					_local3.displayDropdown(false);
				}
			};
			__dropdown.onTweenUpdate = function (v) {
				this._y = v;
			};
			__dropdown.setSize(__dropdownWidth, __dropdown.height);
			createObject("BoundingBox", "mask", 20);
			mask._y = border_mc.height;
			mask._width = __dropdownWidth;
			mask._height = __dropdown.height;
			mask._visible = false;
			__dropdown.setMask(mask);
		}
		return(__dropdown);
	}
	function setSize(w, h, noEvent) {
		super.setSize(w, h, noEvent);
		__dropdownWidth = w;
		__dropdown.rowHeight = h;
		__dropdown.setSize(__dropdownWidth, __dropdown.height);
	}
	function setEditable(e) {
		super.setEditable(e);
		if (e) {
			text_mc.setText("");
		} else {
			text_mc.setText(selectedLabel);
		}
	}
	function get labels() {
		return(__labels);
	}
	function set labels(lbls) {
		__labels = lbls;
		setDataProvider(lbls);
		//return(labels);
	}
	function getLabelField() {
		return(__labelField);
	}
	function get labelField() {
		return(getLabelField());
	}
	function setLabelField(s) {
		__dropdown.labelField = (__labelField = s);
		text_mc.setText(selectedLabel);
	}
	function set labelField(s) {
		setLabelField(s);
		//return(labelField);
	}
	function getLabelFunction() {
		return(__labelFunction);
	}
	function get labelFunction() {
		return(getLabelFunction());
	}
	function set labelFunction(f) {
		__dropdown.labelFunction = (__labelFunction = f);
		text_mc.setText(selectedLabel);
		//return(labelFunction);
	}
	function setSelectedItem(v) {
		super.setSelectedItem(v);
		__dropdown.selectedItem = v;
		text_mc.setText(selectedLabel);
	}
	function setSelectedIndex(v) {
		super.setSelectedIndex(v);
		__dropdown.selectedIndex = v;
		if (v != undefined) {
			text_mc.setText(selectedLabel);
		}
		dispatchValueChangedEvent(getValue());
	}
	function setRowCount(count) {
		if (isNaN(count)) {
			return(undefined);
		}
		__rowCount = count;
		__dropdown.setRowCount(count);
	}
	function get rowCount() {
		return(Math.max(1, Math.min(length, __rowCount)));
	}
	function set rowCount(v) {
		setRowCount(v);
		//return(rowCount);
	}
	function setDropdownWidth(w) {
		__dropdownWidth = w;
		__dropdown.setSize(w, __dropdown.height);
	}
	function get dropdownWidth() {
		return(__dropdownWidth);
	}
	function set dropdownWidth(v) {
		setDropdownWidth(v);
		//return(dropdownWidth);
	}
	function get dropdown() {
		return(getDropdown());
	}
	function setDataProvider(dp) {
		super.setDataProvider(dp);
		__dropdown.setDataProvider(dp);
		if (!_editable) {
			selectedIndex = 0;
		}
	}
	function open() {
		displayDropdown(true);
	}
	function close() {
		displayDropdown(false);
	}
	function get selectedLabel() {
		var _local2 = selectedItem;
		if (_local2 == undefined) {
			return("");
		}
		if (labelFunction != undefined) {
			return(labelFunction(_local2));
		}
		if (typeof(_local2) != "object") {
			return(_local2);
		}
		if (_local2[labelField] != undefined) {
			return(_local2[labelField]);
		}
		if (_local2.label != undefined) {
			return(_local2.label);
		}
		var _local3 = " ";
		for (var _local4 in _local2) {
			if (_local4 != "__ID__") {
				_local3 = (_local2[_local4] + ", ") + _local3;
			}
		}
		_local3 = _local3.substring(0, _local3.length - 3);
		return(_local3);
	}
	function hasDropdown() {
		return((__dropdown != undefined) && (__dropdown.valueOf() != undefined));
	}
	function tweenEndShow(value) {
		_y = value;
		isPressed = true;
		owner.dispatchEvent({type:"open", target:owner});
	}
	function tweenEndHide(value) {
		_y = value;
		__set__visible(false);
		owner.dispatchEvent({type:"close", target:owner});
	}
	function displayDropdown(show) {
		if (show == _showingDropdown) {
			return(undefined);
		}
		var _local3 = new Object();
		_local3.x = 0;
		_local3.y = height;
		this.localToGlobal(_local3);
		if (show) {
			__selectedIndexOnDropdown = selectedIndex;
			__initialSelectedIndexOnDropdown = selectedIndex;
			getDropdown();
			var _local2 = __dropdown;
			_local2.isPressed = true;
			_local2.rowCount = rowCount;
			_local2.visible = show;
			_local2._parent.globalToLocal(_local3);
			_local2.onTweenEnd = tweenEndShow;
			var _local5;
			var _local8;
			if ((_local3.y + _local2.height) > Stage.height) {
				_local5 = _local3.y - __get__height();
				_local8 = _local5 - _local2.height;
				mask._y = -_local2.height;
			} else {
				_local5 = _local3.y - _local2.height;
				_local8 = _local3.y;
				mask._y = border_mc.height;
			}
			var _local6 = _local2.selectedIndex;
			if (_local6 == undefined) {
				_local6 = 0;
			}
			var _local4 = _local2.vPosition;
			_local4 = _local6 - 1;
			_local4 = Math.min(Math.max(_local4, 0), _local2.length - _local2.rowCount);
			_local2.vPosition = _local4;
			_local2.move(_local3.x, _local5);
			_local2.tween = new mx.effects.Tween(__dropdown, _local5, _local8, getStyle("openDuration"));
		} else {
			__dropdown._parent.globalToLocal(_local3);
			delete __dropdown.dragScrolling;
			__dropdown.onTweenEnd = tweenEndHide;
			__dropdown.tween = new mx.effects.Tween(__dropdown, __dropdown._y, _local3.y - __dropdown.height, getStyle("openDuration"));
			if (__initialSelectedIndexOnDropdown != selectedIndex) {
				dispatchChangeEvent(undefined, __initialSelectedIndexOnDropdown, selectedIndex);
			}
		}
		var _local9 = getStyle("openEasing");
		if (_local9 != undefined) {
			__dropdown.tween.easingEquation = _local9;
		}
		_showingDropdown = show;
	}
	function onDownArrow() {
		_parent.displayDropdown(!_parent._showingDropdown);
	}
	function keyDown(e) {
		if (e.ctrlKey && (e.code == 40)) {
			displayDropdown(true);
		} else if (e.ctrlKey && (e.code == 38)) {
			displayDropdown(false);
			dispatchChangeEvent(undefined, __selectedIndexOnDropdown, selectedIndex);
		} else if (e.code == 27) {
			displayDropdown(false);
		} else if (e.code == 13) {
			if (_showingDropdown) {
				selectedIndex = __dropdown.selectedIndex;
				displayDropdown(false);
			}
		} else if (((((!_editable) || (e.code == 38)) || (e.code == 40)) || (e.code == 33)) || (e.code == 34)) {
			selectedIndex = 0 + selectedIndex;
			bInKeyDown = true;
			var _local3 = dropdown;
			_local3.keyDown(e);
			bInKeyDown = false;
			selectedIndex = __dropdown.selectedIndex;
		}
	}
	function invalidateStyle(styleProp) {
		__dropdown.invalidateStyle(styleProp);
		super.invalidateStyle(styleProp);
	}
	function changeTextStyleInChildren(styleProp) {
		if (dropdown.stylecache != undefined) {
			delete dropdown.stylecache[styleProp];
			delete dropdown.stylecache.tf;
		}
		__dropdown.changeTextStyleInChildren(styleProp);
		super.changeTextStyleInChildren(styleProp);
	}
	function changeColorStyleInChildren(sheetName, styleProp, newValue) {
		if (dropdown.stylecache != undefined) {
			delete dropdown.stylecache[styleProp];
			delete dropdown.stylecache.tf;
		}
		__dropdown.changeColorStyleInChildren(sheetName, styleProp, newValue);
		super.changeColorStyleInChildren(sheetName, styleProp, newValue);
	}
	function notifyStyleChangeInChildren(sheetName, styleProp, newValue) {
		if (dropdown.stylecache != undefined) {
			delete dropdown.stylecache[styleProp];
			delete dropdown.stylecache.tf;
		}
		__dropdown.notifyStyleChangeInChildren(sheetName, styleProp, newValue);
		super.notifyStyleChangeInChildren(sheetName, styleProp, newValue);
	}
	function onUnload() {
		__dropdown.removeMovieClip();
	}
	function _resizeHandler() {
		var _local2 = owner;
		_local2.mask._width = width;
		_local2.mask._height = height;
	}
	function _changeHandler(obj) {
		var _local2 = owner;
		var _local3 = _local2.selectedIndex;
		obj.target = _local2;
		if (this == owner.text_mc) {
			_local2.selectedIndex = undefined;
			_local2.dispatchChangeEvent(obj, -1, -2);
		} else {
			_local2.selectedIndex = selectedIndex;
			if (!_local2._showingDropdown) {
				_local2.dispatchChangeEvent(obj, _local3, _local2.selectedIndex);
			} else if (!_local2.bInKeyDown) {
				_local2.displayDropdown(false);
			}
		}
	}
	function _scrollHandler(obj) {
		var _local2 = owner;
		obj.target = _local2;
		_local2.dispatchEvent(obj);
	}
	function _itemRollOverHandler(obj) {
		var _local2 = owner;
		obj.target = _local2;
		_local2.dispatchEvent(obj);
	}
	function _itemRollOutHandler(obj) {
		var _local2 = owner;
		obj.target = _local2;
		_local2.dispatchEvent(obj);
	}
	function modelChanged(eventObj) {
		super.modelChanged(eventObj);
		if (0 == __dataProvider.length) {
			text_mc.setText("");
			delete selected;
		} else if ((__dataProvider.length == ((eventObj.lastItem - eventObj.firstItem) + 1)) && (eventObj.eventName == "addItems")) {
			selectedIndex = 0;
		}
	}
	function dispatchChangeEvent(obj, prevValue, newValue) {
		var _local2;
		if (prevValue != newValue) {
			if ((obj != undefined) && (obj.type == "change")) {
				_local2 = obj;
			} else {
				_local2 = {type:"change"};
			}
			dispatchEvent(_local2);
		}
	}
	static var symbolName = "ComboBox";
	static var symbolOwner = mx.controls.ComboBox;
	static var version = "2.0.2.127";
	var clipParameters = {labels:1, data:1, editable:1, rowCount:1, dropdownWidth:1};
	static var mergedClipParameters = mx.core.UIObject.mergeClipParameters(mx.controls.ComboBox.prototype.clipParameters, mx.controls.ComboBase.prototype.clipParameters);
	var className = "ComboBox";
	var _showingDropdown = false;
	var __rowCount = 5;
	var dropdownBorderStyle = undefined;
	var initializing = true;
	var __labelField = "label";
	var bInKeyDown = false;
}
