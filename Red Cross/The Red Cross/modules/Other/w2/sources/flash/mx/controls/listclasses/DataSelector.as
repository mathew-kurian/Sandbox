class mx.controls.listclasses.DataSelector extends Object
{
	var __vPosition, setVPosition, __dataProvider, enabled, lastSelID, lastSelected, selected, invUpdateControl, invalidate, multipleSelection, updateControl, __rowCount, rows;
	function DataSelector () {
		super();
	}
	static function Initialize(obj) {
		var _local3 = mixinProps;
		var _local4 = _local3.length;
		obj = obj.prototype;
		var _local1 = 0;
		while (_local1 < _local4) {
			obj[_local3[_local1]] = mixins[_local3[_local1]];
			_local1++;
		}
		mixins.createProp(obj, "dataProvider", true);
		mixins.createProp(obj, "length", false);
		mixins.createProp(obj, "value", false);
		mixins.createProp(obj, "selectedIndex", true);
		mixins.createProp(obj, "selectedIndices", true);
		mixins.createProp(obj, "selectedItems", false);
		mixins.createProp(obj, "selectedItem", true);
		return(true);
	}
	function createProp(obj, propName, setter) {
		var p = (propName.charAt(0).toUpperCase() + propName.substr(1));
		var _local2 = null;
		var _local3 = function (Void) {
			return(this["get" + p]());
		};
		if (setter) {
			_local2 = function (val) {
				this["set" + p](val);
			};
		}
		obj.addProperty(propName, _local3, _local2);
	}
	function setDataProvider(dP) {
		if (__vPosition != 0) {
			setVPosition(0);
		}
		clearSelected();
		__dataProvider.removeEventListener(this);
		__dataProvider = dP;
		dP.addEventListener("modelChanged", this);
		dP.addView(this);
		modelChanged({eventName:"updateAll"});
	}
	function getDataProvider(Void) {
		return(__dataProvider);
	}
	function addItemAt(index, label, data) {
		if ((index < 0) || (!enabled)) {
			return(undefined);
		}
		var _local2 = __dataProvider;
		if (_local2 == undefined) {
			_local2 = (__dataProvider = new Array());
			_local2.addEventListener("modelChanged", this);
			index = 0;
		}
		if ((typeof(label) == "object") || (typeof(_local2.getItemAt(0)) == "string")) {
			_local2.addItemAt(index, label);
		} else {
			_local2.addItemAt(index, {label:label, data:data});
		}
	}
	function addItem(label, data) {
		addItemAt(__dataProvider.length, label, data);
	}
	function removeItemAt(index) {
		return(__dataProvider.removeItemAt(index));
	}
	function removeAll(Void) {
		__dataProvider.removeAll();
	}
	function replaceItemAt(index, newLabel, newData) {
		if (typeof(newLabel) == "object") {
			__dataProvider.replaceItemAt(index, newLabel);
		} else {
			__dataProvider.replaceItemAt(index, {label:newLabel, data:newData});
		}
	}
	function sortItemsBy(fieldName, order) {
		lastSelID = __dataProvider.getItemID(lastSelected);
		__dataProvider.sortItemsBy(fieldName, order);
	}
	function sortItems(compareFunc, order) {
		lastSelID = __dataProvider.getItemID(lastSelected);
		__dataProvider.sortItems(compareFunc, order);
	}
	function getLength(Void) {
		return(__dataProvider.length);
	}
	function getItemAt(index) {
		return(__dataProvider.getItemAt(index));
	}
	function modelChanged(eventObj) {
		var _local3 = eventObj.firstItem;
		var _local6 = eventObj.lastItem;
		var _local7 = eventObj.eventName;
		if (_local7 == undefined) {
			_local7 = eventObj.event;
			_local3 = eventObj.firstRow;
			_local6 = eventObj.lastRow;
			if (_local7 == "addRows") {
				_local7 = (eventObj.eventName = "addItems");
			} else if (_local7 == "deleteRows") {
				_local7 = (eventObj.eventName = "removeItems");
			} else if (_local7 == "updateRows") {
				_local7 = (eventObj.eventName = "updateItems");
			}
		}
		if (_local7 == "addItems") {
			for (var _local2 in selected) {
				var _local5 = selected[_local2];
				if ((_local5 != undefined) && (_local5 >= _local3)) {
					selected[_local2] = selected[_local2] + ((_local6 - _local3) + 1);
				}
			}
		} else if (_local7 == "removeItems") {
			if (__dataProvider.length == 0) {
				delete selected;
			} else {
				var _local9 = eventObj.removedIDs;
				var _local10 = _local9.length;
				var _local2 = 0;
				while (_local2 < _local10) {
					var _local4 = _local9[_local2];
					if (selected[_local4] != undefined) {
						delete selected[_local4];
					}
					_local2++;
				}
				for (_local2 in selected) {
					if (selected[_local2] >= _local3) {
						selected[_local2] = selected[_local2] - ((_local6 - _local3) + 1);
					}
				}
			}
		} else if (_local7 == "sort") {
			if (typeof(__dataProvider.getItemAt(0)) != "object") {
				delete selected;
			} else {
				var _local10 = __dataProvider.length;
				var _local2 = 0;
				while (_local2 < _local10) {
					if (isSelected(_local2)) {
						var _local4 = __dataProvider.getItemID(_local2);
						if (_local4 == lastSelID) {
							lastSelected = _local2;
						}
						selected[_local4] = _local2;
					}
					_local2++;
				}
			}
		} else if (_local7 == "filterModel") {
			setVPosition(0);
		}
		invUpdateControl = true;
		invalidate();
	}
	function getValue(Void) {
		var _local2 = getSelectedItem();
		if (typeof(_local2) != "object") {
			return(_local2);
		}
		return(((_local2.data == undefined) ? (_local2.label) : (_local2.data)));
	}
	function getSelectedIndex(Void) {
		for (var _local3 in selected) {
			var _local2 = selected[_local3];
			if (_local2 != undefined) {
				return(_local2);
			}
		}
	}
	function setSelectedIndex(index) {
		if (((index >= 0) && (index < __dataProvider.length)) && (enabled)) {
			delete selected;
			selectItem(index, true);
			lastSelected = index;
			invUpdateControl = true;
			invalidate();
		} else if (index == undefined) {
			clearSelected();
		}
	}
	function getSelectedIndices(Void) {
		var _local2 = new Array();
		for (var _local3 in selected) {
			_local2.push(selected[_local3]);
		}
		_local2.reverse();
		return(((_local2.length > 0) ? (_local2) : undefined));
	}
	function setSelectedIndices(indexArray) {
		if (multipleSelection != true) {
			return(undefined);
		}
		delete selected;
		var _local3 = 0;
		while (_local3 < indexArray.length) {
			var _local2 = indexArray[_local3];
			if ((_local2 >= 0) && (_local2 < __dataProvider.length)) {
				selectItem(_local2, true);
			}
			_local3++;
		}
		invUpdateControl = true;
		updateControl();
	}
	function getSelectedItems(Void) {
		var _local3 = getSelectedIndices();
		var _local4 = new Array();
		var _local2 = 0;
		while (_local2 < _local3.length) {
			_local4.push(getItemAt(_local3[_local2]));
			_local2++;
		}
		return(((_local4.length > 0) ? (_local4) : undefined));
	}
	function getSelectedItem(Void) {
		return(__dataProvider.getItemAt(getSelectedIndex()));
	}
	function selectItem(index, selectedFlag) {
		if (selected == undefined) {
			selected = new Object();
		}
		var _local2 = __dataProvider.getItemID(index);
		if (_local2 == undefined) {
			return(undefined);
		}
		if (selectedFlag && (!isSelected(index))) {
			selected[_local2] = index;
		} else if (!selectedFlag) {
			delete selected[_local2];
		}
	}
	function isSelected(index) {
		var _local2 = __dataProvider.getItemID(index);
		if (_local2 == undefined) {
			return(false);
		}
		return(selected[_local2] != undefined);
	}
	function clearSelected(transition) {
		var _local3 = 0;
		for (var _local4 in selected) {
			var _local2 = selected[_local4];
			if (((_local2 != undefined) && (__vPosition <= _local2)) && (_local2 < (__vPosition + __rowCount))) {
				rows[_local2 - __vPosition].drawRow(rows[_local2 - __vPosition].item, "normal", transition && ((_local3 % 3) == 0));
			}
			_local3++;
		}
		delete selected;
	}
	static var mixins = new mx.controls.listclasses.DataSelector();
	static var mixinProps = ["setDataProvider", "getDataProvider", "addItem", "addItemAt", "removeAll", "removeItemAt", "replaceItemAt", "sortItemsBy", "sortItems", "getLength", "getItemAt", "modelChanged", "calcPreferredWidthFromData", "calcPreferredHeightFromData", "getValue", "getSelectedIndex", "getSelectedItem", "getSelectedIndices", "getSelectedItems", "selectItem", "isSelected", "clearSelected", "setSelectedIndex", "setSelectedIndices"];
}
