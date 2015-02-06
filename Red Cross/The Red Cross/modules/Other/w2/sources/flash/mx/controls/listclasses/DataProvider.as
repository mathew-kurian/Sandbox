class mx.controls.listclasses.DataProvider extends Object
{
	var length, splice, dispatchEvent, sortOn, reverse, sort;
	function DataProvider (obj) {
		super();
	}
	static function Initialize(obj) {
		var _local4 = mixinProps;
		var _local6 = _local4.length;
		obj = obj.prototype;
		var _local3 = 0;
		while (_local3 < _local6) {
			obj[_local4[_local3]] = mixins[_local4[_local3]];
			_global.ASSetPropFlags(obj, _local4[_local3], 1);
			_local3++;
		}
		mx.events.EventDispatcher.initialize(obj);
		_global.ASSetPropFlags(obj, "addEventListener", 1);
		_global.ASSetPropFlags(obj, "removeEventListener", 1);
		_global.ASSetPropFlags(obj, "dispatchEvent", 1);
		_global.ASSetPropFlags(obj, "dispatchQueue", 1);
		Object.prototype.LargestID = 0;
		Object.prototype.getID = function () {
			if (this.__ID__ == undefined) {
				this.__ID__ = Object.prototype.LargestID++;
				_global.ASSetPropFlags(this, "__ID__", 1);
			}
			return(this.__ID__);
		};
		_global.ASSetPropFlags(Object.prototype, "LargestID", 1);
		_global.ASSetPropFlags(Object.prototype, "getID", 1);
		return(true);
	}
	function addItemAt(index, value) {
		if (index < length) {
			this.splice(index, 0, value);
		} else if (index > length) {
			trace("Cannot add an item past the end of the DataProvider");
			return(undefined);
		}
		this[index] = value;
		updateViews("addItems", index, index);
	}
	function addItem(value) {
		addItemAt(length, value);
	}
	function addItemsAt(index, newItems) {
		index = Math.min(length, index);
		newItems.unshift(index, 0);
		splice.apply(this, newItems);
		newItems.splice(0, 2);
		updateViews("addItems", index, (index + newItems.length) - 1);
	}
	function removeItemsAt(index, len) {
		var _local3 = new Array();
		var _local2 = 0;
		while (_local2 < len) {
			_local3.push(getItemID(index + _local2));
			_local2++;
		}
		var _local6 = this.splice(index, len);
		dispatchEvent({type:"modelChanged", eventName:"removeItems", firstItem:index, lastItem:(index + len) - 1, removedItems:_local6, removedIDs:_local3});
	}
	function removeItemAt(index) {
		var _local2 = this[index];
		removeItemsAt(index, 1);
		return(_local2);
	}
	function removeAll(Void) {
		this.splice(0);
		updateViews("removeItems", 0, length - 1);
	}
	function replaceItemAt(index, itemObj) {
		if ((index < 0) || (index >= length)) {
			return(undefined);
		}
		var _local3 = getItemID(index);
		this[index] = itemObj;
		this[index].__ID__ = _local3;
		updateViews("updateItems", index, index);
	}
	function getItemAt(index) {
		return(this[index]);
	}
	function getItemID(index) {
		var _local2 = this[index];
		if ((typeof(_local2) != "object") && (_local2 != undefined)) {
			return(index);
		}
		return(_local2.getID());
	}
	function sortItemsBy(fieldName, order) {
		if (typeof(order) == "string") {
			this.sortOn(fieldName);
			if (order.toUpperCase() == "DESC") {
				this.reverse();
			}
		} else {
			this.sortOn(fieldName, order);
		}
		updateViews("sort");
	}
	function sortItems(compareFunc, optionFlags) {
		this.sort(compareFunc, optionFlags);
		updateViews("sort");
	}
	function editField(index, fieldName, newData) {
		this[index][fieldName] = newData;
		dispatchEvent({type:"modelChanged", eventName:"updateField", firstItem:index, lastItem:index, fieldName:fieldName});
	}
	function getEditingData(index, fieldName) {
		return(this[index][fieldName]);
	}
	function updateViews(event, first, last) {
		dispatchEvent({type:"modelChanged", eventName:event, firstItem:first, lastItem:last});
	}
	static var mixinProps = ["addView", "addItem", "addItemAt", "removeAll", "removeItemAt", "replaceItemAt", "getItemAt", "getItemID", "sortItemsBy", "sortItems", "updateViews", "addItemsAt", "removeItemsAt", "getEditingData", "editField"];
	static var evtDipatcher = mx.events.EventDispatcher;
	static var mixins = new mx.controls.listclasses.DataProvider();
}
