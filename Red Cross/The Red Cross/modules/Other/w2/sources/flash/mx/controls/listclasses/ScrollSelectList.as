class mx.controls.listclasses.ScrollSelectList extends mx.core.ScrollView
{
	var invLayoutContent, rows, topRowZ, listContent, __dataProvider, __vPosition, tW, layoutX, layoutY, tH, invRowHeight, invalidate, __height, invUpdateControl, __cellRenderer, __labelFunction, __iconField, __iconFunction, getLength, baseRowZ, lastPosition, propertyTable, isSelected, wasKeySelected, changeFlag, clearSelected, selectItem, lastSelected, dispatchEvent, dragScrolling, _ymouse, scrollInterval, isPressed, onMouseUp, getSelectedIndex, enabled, tabEnabled, tabChildren, createEmptyMovieClip, border_mc;
	function ScrollSelectList () {
		super();
	}
	function layoutContent(x, y, w, h) {
		delete invLayoutContent;
		var _local4 = Math.ceil(h / __rowHeight);
		roundUp = (h % __rowHeight) != 0;
		var _local12 = _local4 - __rowCount;
		if (_local12 < 0) {
			var _local3 = _local4;
			while (_local3 < __rowCount) {
				rows[_local3].removeMovieClip();
				delete rows[_local3];
				_local3++;
			}
			topRowZ = topRowZ + _local12;
		} else if (_local12 > 0) {
			if (rows == undefined) {
				rows = new Array();
			}
			var _local3 = __rowCount;
			while (_local3 < _local4) {
				var _local2 = (rows[_local3] = listContent.createObject(__rowRenderer, "listRow" + (topRowZ++), topRowZ, {owner:this, styleName:this, rowIndex:_local3}));
				_local2._x = x;
				_local2._y = Math.round((_local3 * __rowHeight) + y);
				_local2.setSize(w, __rowHeight);
				_local2.drawRow(__dataProvider.getItemAt(__vPosition + _local3), getStateAt(__vPosition + _local3));
				_local2.lastY = _local2._y;
				_local3++;
			}
		}
		if (w != tW) {
			var _local11 = ((_local12 > 0) ? (__rowCount) : (_local4));
			var _local3 = 0;
			while (_local3 < _local11) {
				rows[_local3].setSize(w, __rowHeight);
				_local3++;
			}
		}
		if ((layoutX != x) || (layoutY != y)) {
			var _local3 = 0;
			while (_local3 < _local4) {
				rows[_local3]._x = x;
				rows[_local3]._y = Math.round((_local3 * __rowHeight) + y);
				_local3++;
			}
		}
		__rowCount = _local4;
		layoutX = x;
		layoutY = y;
		tW = w;
		tH = h;
	}
	function getRowHeight(Void) {
		return(__rowHeight);
	}
	function setRowHeight(v) {
		__rowHeight = v;
		invRowHeight = true;
		invalidate();
	}
	function get rowHeight() {
		return(getRowHeight());
	}
	function set rowHeight(w) {
		setRowHeight(w);
		//return(rowHeight);
	}
	function setRowCount(v) {
		__rowCount = v;
	}
	function getRowCount(Void) {
		var _local2 = ((__rowCount == 0) ? (Math.ceil(__height / __rowHeight)) : (__rowCount));
		return(_local2);
	}
	function get rowCount() {
		return(getRowCount());
	}
	function set rowCount(w) {
		setRowCount(w);
		//return(rowCount);
	}
	function setEnabled(v) {
		super.setEnabled(v);
		invUpdateControl = true;
		invalidate();
	}
	function setCellRenderer(cR) {
		__cellRenderer = cR;
		var _local2 = 0;
		while (_local2 < rows.length) {
			rows[_local2].setCellRenderer(true);
			_local2++;
		}
		invUpdateControl = true;
		invalidate();
	}
	function set cellRenderer(cR) {
		setCellRenderer(cR);
		//return(cellRenderer);
	}
	function get cellRenderer() {
		return(__cellRenderer);
	}
	function set labelField(field) {
		setLabelField(field);
		//return(labelField);
	}
	function setLabelField(field) {
		__labelField = field;
		invUpdateControl = true;
		invalidate();
	}
	function get labelField() {
		return(__labelField);
	}
	function set labelFunction(func) {
		setLabelFunction(func);
		//return(labelFunction);
	}
	function setLabelFunction(func) {
		__labelFunction = func;
		invUpdateControl = true;
		invalidate();
	}
	function get labelFunction() {
		return(__labelFunction);
	}
	function set iconField(field) {
		setIconField(field);
		//return(iconField);
	}
	function setIconField(field) {
		__iconField = field;
		invUpdateControl = true;
		invalidate();
	}
	function get iconField() {
		return(__iconField);
	}
	function set iconFunction(func) {
		setIconFunction(func);
		//return(iconFunction);
	}
	function setIconFunction(func) {
		__iconFunction = func;
		invUpdateControl = true;
		invalidate();
	}
	function get iconFunction() {
		return(__iconFunction);
	}
	function setVPosition(pos) {
		if (pos < 0) {
			return(undefined);
		}
		if ((pos > 0) && (pos > ((getLength() - __rowCount) + roundUp))) {
			return(undefined);
		}
		var _local8 = pos - __vPosition;
		if (_local8 == 0) {
			return(undefined);
		}
		__vPosition = pos;
		var _local10 = _local8 > 0;
		_local8 = Math.abs(_local8);
		if (_local8 >= __rowCount) {
			updateControl();
		} else {
			var _local4 = new Array();
			var _local9 = __rowCount - _local8;
			var _local12 = _local8 * __rowHeight;
			var _local11 = _local9 * __rowHeight;
			var _local6 = (_local10 ? 1 : -1);
			var _local3 = 0;
			while (_local3 < __rowCount) {
				if (((_local3 < _local8) && (_local10)) || ((_local3 >= _local9) && (!_local10))) {
					rows[_local3]._y = rows[_local3]._y + Math.round(_local6 * _local11);
					var _local5 = _local3 + (_local6 * _local9);
					var _local7 = __vPosition + _local5;
					_local4[_local5] = rows[_local3];
					_local4[_local5].rowIndex = _local5;
					_local4[_local5].drawRow(__dataProvider.getItemAt(_local7), getStateAt(_local7), false);
				} else {
					rows[_local3]._y = rows[_local3]._y - Math.round(_local6 * _local12);
					var _local5 = _local3 - (_local6 * _local8);
					_local4[_local5] = rows[_local3];
					_local4[_local5].rowIndex = _local5;
				}
				_local3++;
			}
			rows = _local4;
			_local3 = 0;
			while (_local3 < __rowCount) {
				rows[_local3].swapDepths(baseRowZ + _local3);
				_local3++;
			}
		}
		lastPosition = pos;
		super.setVPosition(pos);
	}
	function setPropertiesAt(index, obj) {
		var _local2 = __dataProvider.getItemID(index);
		if (_local2 == undefined) {
			return(undefined);
		}
		if (propertyTable == undefined) {
			propertyTable = new Object();
		}
		propertyTable[_local2] = obj;
		rows[index - __vPosition].drawRow(__dataProvider.getItemAt(index), getStateAt(index));
	}
	function getPropertiesAt(index) {
		var _local2 = __dataProvider.getItemID(index);
		if (_local2 == undefined) {
			return(undefined);
		}
		return(propertyTable[_local2]);
	}
	function getPropertiesOf(obj) {
		var _local2 = obj.getID();
		if (_local2 == undefined) {
			return(undefined);
		}
		return(propertyTable[_local2]);
	}
	function getStyle(styleProp) {
		var _local2 = super.getStyle(styleProp);
		var _local3 = mx.styles.StyleManager.colorNames[_local2];
		if (_local3 != undefined) {
			_local2 = _local3;
		}
		return(_local2);
	}
	function updateControl(Void) {
		var _local2 = 0;
		while (_local2 < __rowCount) {
			rows[_local2].drawRow(__dataProvider.getItemAt(_local2 + __vPosition), getStateAt(_local2 + __vPosition));
			_local2++;
		}
		delete invUpdateControl;
	}
	function getStateAt(index) {
		return((isSelected(index) ? "selected" : "normal"));
	}
	function selectRow(rowIndex, transition, allowChangeEvent) {
		if (!selectable) {
			return(undefined);
		}
		var _local3 = __vPosition + rowIndex;
		var _local8 = __dataProvider.getItemAt(_local3);
		var _local5 = rows[rowIndex];
		if (_local8 == undefined) {
			return(undefined);
		}
		if (transition == undefined) {
			transition = true;
		}
		if (allowChangeEvent == undefined) {
			allowChangeEvent = wasKeySelected;
		}
		changeFlag = true;
		if (((!multipleSelection) && (!Key.isDown(17))) || ((!Key.isDown(16)) && (!Key.isDown(17)))) {
			clearSelected(transition);
			selectItem(_local3, true);
			lastSelected = _local3;
			_local5.drawRow(_local5.item, getStateAt(_local3), transition);
		} else if (Key.isDown(16) && (multipleSelection)) {
			if (lastSelected == undefined) {
				lastSelected = _local3;
			}
			var _local4 = ((lastSelected < _local3) ? 1 : -1);
			clearSelected(false);
			var _local2 = lastSelected;
			while (_local2 != _local3) {
				selectItem(_local2, true);
				if ((_local2 >= __vPosition) && (_local2 < (__vPosition + __rowCount))) {
					rows[_local2 - __vPosition].drawRow(rows[_local2 - __vPosition].item, "selected", false);
				}
				_local2 = _local2 + _local4;
			}
			selectItem(_local3, true);
			_local5.drawRow(_local5.item, "selected", transition);
		} else if (Key.isDown(17)) {
			var _local7 = isSelected(_local3);
			if ((!multipleSelection) || (wasKeySelected)) {
				clearSelected(transition);
			}
			if (!((!multipleSelection) && (_local7))) {
				selectItem(_local3, !_local7);
				var _local9 = ((!_local7) ? "selected" : "normal");
				_local5.drawRow(_local5.item, _local9, transition);
			}
			lastSelected = _local3;
		}
		if (allowChangeEvent) {
			dispatchEvent({type:"change"});
		}
		delete wasKeySelected;
	}
	function dragScroll(Void) {
		clearInterval(dragScrolling);
		if (_ymouse < 0) {
			setVPosition(__vPosition - 1);
			selectRow(0, false);
			var _local2 = Math.min((-_ymouse) - 30, 0);
			scrollInterval = (((0.593 * _local2) * _local2) + 1) + minScrollInterval;
			dragScrolling = setInterval(this, "dragScroll", scrollInterval);
			dispatchEvent({type:"scroll", direction:"vertical", position:__vPosition});
		} else if (_ymouse > __height) {
			var _local3 = __vPosition;
			setVPosition(__vPosition + 1);
			if (_local3 != __vPosition) {
				selectRow((__rowCount - 1) - roundUp, false);
			}
			var _local2 = Math.min((_ymouse - __height) - 30, 0);
			scrollInterval = (((0.593 * _local2) * _local2) + 1) + minScrollInterval;
			dragScrolling = setInterval(this, "dragScroll", scrollInterval);
			dispatchEvent({type:"scroll", direction:"vertical", position:__vPosition});
		} else {
			dragScrolling = setInterval(this, "dragScroll", 15);
		}
		updateAfterEvent();
	}
	function __onMouseUp(Void) {
		clearInterval(dragScrolling);
		delete dragScrolling;
		delete dragScrolling;
		delete isPressed;
		delete onMouseUp;
		if (!selectable) {
			return(undefined);
		}
		if (changeFlag) {
			dispatchEvent({type:"change"});
		}
		delete changeFlag;
	}
	function moveSelBy(incr) {
		if (!selectable) {
			setVPosition(__vPosition + incr);
			return(undefined);
		}
		var _local3 = getSelectedIndex();
		if (_local3 == undefined) {
			_local3 = -1;
		}
		var _local2 = _local3 + incr;
		_local2 = Math.max(0, _local2);
		_local2 = Math.min(getLength() - 1, _local2);
		if (_local2 == _local3) {
			return(undefined);
		}
		if ((_local3 < __vPosition) || (_local3 >= (__vPosition + __rowCount))) {
			setVPosition(_local3);
		}
		if ((_local2 >= ((__vPosition + __rowCount) - roundUp)) || (_local2 < __vPosition)) {
			setVPosition(__vPosition + incr);
		}
		wasKeySelected = true;
		selectRow(_local2 - __vPosition, false);
	}
	function keyDown(e) {
		if (selectable) {
			if (findInputText()) {
				return(undefined);
			}
		}
		if (e.code == 40) {
			moveSelBy(1);
		} else if (e.code == 38) {
			moveSelBy(-1);
		} else if (e.code == 34) {
			if (selectable) {
				var _local3 = getSelectedIndex();
				if (_local3 == undefined) {
					_local3 = 0;
				}
				setVPosition(_local3);
			}
			moveSelBy((__rowCount - 1) - roundUp);
		} else if (e.code == 33) {
			if (selectable) {
				var _local3 = getSelectedIndex();
				if (_local3 == undefined) {
					_local3 = 0;
				}
				setVPosition(_local3);
			}
			moveSelBy((1 - __rowCount) + roundUp);
		} else if (e.code == 36) {
			moveSelBy(-__dataProvider.length);
		} else if (e.code == 35) {
			moveSelBy(__dataProvider.length);
		}
	}
	function findInputText(Void) {
		var _local2 = Key.getAscii();
		if ((_local2 >= 33) && (_local2 <= 126)) {
			findString(String.fromCharCode(_local2));
			return(true);
		}
	}
	function findString(str) {
		if (__dataProvider.length == 0) {
			return(undefined);
		}
		var _local4 = getSelectedIndex();
		if (_local4 == undefined) {
			_local4 = 0;
		}
		var _local6 = 0;
		var _local3 = _local4 + 1;
		while (_local3 != _local4) {
			var _local2 = __dataProvider.getItemAt(_local3);
			if (_local2 instanceof XMLNode) {
				_local2 = _local2.attributes[__labelField];
			} else if (typeof(_local2) != "string") {
				_local2 = String(_local2[__labelField]);
			}
			_local2 = _local2.substring(0, str.length);
			if ((str == _local2) || (str.toUpperCase() == _local2.toUpperCase())) {
				_local6 = _local3 - _local4;
				break;
			}
			if (_local3 >= (getLength() - 1)) {
				_local3 = -1;
			}
			_local3++;
		}
		if (_local6 != 0) {
			moveSelBy(_local6);
		}
	}
	function onRowPress(rowIndex) {
		if (!enabled) {
			return(undefined);
		}
		isPressed = true;
		dragScrolling = setInterval(this, "dragScroll", 15);
		onMouseUp = __onMouseUp;
		if (!selectable) {
			return(undefined);
		}
		selectRow(rowIndex);
	}
	function onRowRelease(rowIndex) {
	}
	function onRowRollOver(rowIndex) {
		if (!enabled) {
			return(undefined);
		}
		var _local2 = rows[rowIndex].item;
		if (getStyle("useRollOver") && (_local2 != undefined)) {
			rows[rowIndex].drawRow(_local2, "highlighted", false);
		}
		dispatchEvent({type:"itemRollOver", index:rowIndex + __vPosition});
	}
	function onRowRollOut(rowIndex) {
		if (!enabled) {
			return(undefined);
		}
		if (getStyle("useRollOver")) {
			rows[rowIndex].drawRow(rows[rowIndex].item, getStateAt(rowIndex + __vPosition), false);
		}
		dispatchEvent({type:"itemRollOut", index:rowIndex + __vPosition});
	}
	function onRowDragOver(rowIndex) {
		if (((!enabled) || (isPressed != true)) || (!selectable)) {
			return(undefined);
		}
		if (dropEnabled) {
		} else if (dragScrolling) {
			selectRow(rowIndex, false);
		} else {
			onMouseUp = __onMouseUp;
			onRowPress(rowIndex);
		}
	}
	function onRowDragOut(rowIndex) {
		if (!enabled) {
			return(undefined);
		}
		if (dragEnabled) {
		} else {
			onRowRollOut(rowIndex);
		}
	}
	function init(Void) {
		super.init();
		tabEnabled = true;
		tabChildren = false;
		if (__dataProvider == undefined) {
			__dataProvider = new Array();
			__dataProvider.addEventListener("modelChanged", this);
		}
		baseRowZ = (topRowZ = 10);
	}
	function createChildren(Void) {
		super.createChildren();
		listContent = this.createEmptyMovieClip("content_mc", CONTENTDEPTH);
		invLayoutContent = true;
		invalidate();
	}
	function draw(Void) {
		if (invRowHeight) {
			delete invRowHeight;
			__rowCount = 0;
			listContent.removeMovieClip();
			listContent = this.createEmptyMovieClip("content_mc", CONTENTDEPTH);
		}
		if (invUpdateControl) {
			updateControl();
		}
		border_mc.draw();
	}
	function invalidateStyle(propName) {
		if (isRowStyle[propName]) {
			invUpdateControl = true;
			invalidate();
		} else {
			var _local3 = 0;
			while (_local3 < __rowCount) {
				rows[_local3].invalidateStyle(propName);
				_local3++;
			}
		}
		super.invalidateStyle(propName);
	}
	static var mixIt1 = mx.controls.listclasses.DataSelector.Initialize(mx.controls.listclasses.ScrollSelectList);
	static var mixIt2 = mx.controls.listclasses.DataProvider.Initialize(Array);
	var CONTENTDEPTH = 100;
	var __hPosition = 0;
	var __rowRenderer = "SelectableRow";
	var __rowHeight = 22;
	var __rowCount = 0;
	var __labelField = "label";
	var minScrollInterval = 30;
	var dropEnabled = false;
	var dragEnabled = false;
	var className = "ScrollSelectList";
	var isRowStyle = {styleName:true, backgroundColor:true, selectionColor:true, rollOverColor:true, selectionDisabledColor:true, backgroundDisabledColor:true, textColor:true, textSelectedColor:true, textRollOverColor:true, textDisabledColor:true, alternatingRowColors:true, defaultIcon:true};
	var roundUp = 0;
	var selectable = true;
	var multipleSelection = false;
}
