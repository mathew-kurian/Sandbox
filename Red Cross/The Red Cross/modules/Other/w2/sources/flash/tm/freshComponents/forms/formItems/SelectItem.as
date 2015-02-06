class tm.freshComponents.forms.formItems.SelectItem extends tm.freshComponents.forms.formItems.FormItem
{
	var _type, _listeners, firstItem, dataProvider, dependence, updateGroups, _rawData, _formManager, _target, __get__required, validationError, fieldRequiredError;
	function SelectItem (formManager, id, label, required) {
		super(formManager, id, label, required);
		_type = tm.freshComponents.forms.formItems.FormItemType.SELECT;
		_listeners = new Array();
	}
	function updateParameters(data) {
		if (data.firstItem.value && (data.firstItem.value.length > 0)) {
			firstItem = data.firstItem.value;
		}
		if (data.dataProvider.value) {
			if (typeof(data.dataProvider.value) != "string") {
				dataProvider = new Array();
				if (firstItem && (firstItem.length > 0)) {
					dataProvider.push({label:firstItem, data:firstItem});
				}
				var _local2 = 0;
				while (_local2 < data.dataProvider.value.length) {
					dataProvider.push({label:data.dataProvider.value[_local2].value, data:data.dataProvider.value[_local2].value});
					_local2++;
				}
				dependanceNodeDataChanged();
			} else {
				if (data.dataProvider.depth && (Number(data.dataProvider.depth) > 1)) {
					depth = data.dataProvider.depth;
				}
				if (data.dataProvider.dependence && (Number(data.dataProvider.dependence) > 0)) {
					dependence = data.dataProvider.dependence;
				}
				dataProvider = new Array();
				if (firstItem && (firstItem.length > 0)) {
					dataProvider.push({label:firstItem, data:firstItem});
				}
				var _local4 = new tm.utils.XMLParser();
				_local4.load(data.dataProvider.value, this, onXMLDataLoaded);
			}
		}
		updateGroups(data);
	}
	function onXMLDataLoaded(success, data) {
		if (success && (data)) {
			_rawData = data;
			var _local3;
			if (dependence) {
				var _local2 = tm.freshComponents.forms.formItems.SelectItem(_formManager.getFormItem(dependence));
				_local3 = _local2.getValue();
				_local2.registerForChange(this);
			}
			dependanceNodeDataChanged(_local3);
		} else {
			mx.controls.ComboBox(_target)._editable = false;
		}
	}
	function getItemsAtDepth(dataCollection, targetDepth, dependanceNodeData) {
		var _local6 = new Array();
		if (targetDepth > 0) {
			var _local2 = 0;
			while (_local2 < dataCollection.length) {
				if (((dataCollection[_local2].value != undefined) && (typeof(dataCollection[_local2].value) == "string")) && (targetDepth == 1)) {
					_local6.push(dataCollection[_local2].value);
				} else if ((dataCollection[_local2].item && (dataCollection[_local2].item.length > 0)) && (targetDepth > 1)) {
					if ((((dependanceNodeData && (dependanceNodeData.length > 0)) && (dataCollection[_local2].data == dependanceNodeData)) || (!dependanceNodeData)) || (targetDepth != 2)) {
						_local6 = _local6.concat(getItemsAtDepth(dataCollection[_local2].item, targetDepth - 1, dependanceNodeData));
					}
				} else if (((targetDepth == 1) && (dataCollection[_local2].data)) && (dataCollection[_local2].data.length > 0)) {
					_local6.push(dataCollection[_local2].data);
				}
				_local2++;
			}
		}
		return(_local6);
	}
	function dependanceNodeDataChanged(dependanceNodeData) {
		if (_rawData) {
			dataProvider = new Array();
			if (firstItem && (firstItem.length > 0)) {
				dataProvider.push({label:firstItem, data:firstItem});
			}
			var _local3 = getItemsAtDepth(_rawData.item, depth, dependanceNodeData);
			var _local2 = 0;
			while (_local2 < _local3.length) {
				dataProvider.push({label:_local3[_local2], data:_local3[_local2]});
				_local2++;
			}
			mx.controls.ComboBox(_target).dataProvider = dataProvider;
		}
	}
	function validate() {
		if (((firstItem && (firstItem.length > 0)) && (__get__required())) && (getValue() == firstItem)) {
			validationError = fieldRequiredError;
			return(false);
		}
		return(true);
	}
	function getValue() {
		var _local2 = mx.controls.ComboBox(_target).selectedItem;
		return(_local2.data);
	}
	function init() {
		var _local3 = mx.controls.ComboBox(_target);
		var _local2 = new Object();
		_local2.change = tm.utils.Delegate.create(this, onChange);
		_local3.addEventListener("change", _local2);
	}
	function onChange() {
		var _local2 = 0;
		while (_local2 < _listeners.length) {
			tm.freshComponents.forms.formItems.SelectItem(_listeners[_local2]).dependanceNodeDataChanged(getValue());
			_local2++;
		}
	}
	function registerForChange(listener) {
		_listeners.push(listener);
	}
	function reset() {
		mx.controls.ComboBox(_target).selectedIndex = 0;
	}
	function get target() {
		return(_target);
	}
	function set target(targetObject) {
		_target = targetObject;
		dependanceNodeDataChanged();
		//return(target);
	}
	var depth = 1;
}
