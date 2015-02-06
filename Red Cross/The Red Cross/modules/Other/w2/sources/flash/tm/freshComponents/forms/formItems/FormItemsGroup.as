class tm.freshComponents.forms.formItems.FormItemsGroup
{
	var name, _groupItemsCollection, minRequired, maxRequired, validationError;
	function FormItemsGroup (groupName, groupParameters) {
		name = groupName;
		_groupItemsCollection = new Array();
		if (groupParameters.delimiter && (groupParameters.delimiter.length > 0)) {
			delimiter = groupParameters.delimiter;
		}
		if (groupParameters.minRequired && (Number(groupParameters.minRequired) > 0)) {
			minRequired = groupParameters.minRequired;
		}
		if (groupParameters.maxRequired && (Number(groupParameters.maxRequired) > 0)) {
			maxRequired = groupParameters.maxRequired;
		}
		if (groupParameters.shouldBeEqual && (groupParameters.shouldBeEqual == "true")) {
			shouldBeEqual = true;
		}
	}
	function addNewItem(formItem) {
		if (!itemExists(formItem)) {
			_groupItemsCollection.push(formItem);
		}
	}
	function validate() {
		var _local4 = 0;
		var _local6 = true;
		var _local5 = tm.freshComponents.forms.formItems.FormItem(_groupItemsCollection[0]).getValue();
		var _local3 = 0;
		while (_local3 < _groupItemsCollection.length) {
			var _local2 = tm.freshComponents.forms.formItems.FormItem(_groupItemsCollection[_local3]);
			if (_local5 != tm.freshComponents.forms.formItems.FormItem(_groupItemsCollection[_local3]).getValue()) {
				_local6 = false;
			}
			if (_local2.__get__type() == tm.freshComponents.forms.formItems.FormItemType.RADIOBUTTON) {
				if (_local2.getValue() == "true") {
					_local4++;
				}
			} else if (_local2.__get__type() == tm.freshComponents.forms.formItems.FormItemType.CHECKBOX) {
				if (_local2.getValue() == "true") {
					_local4++;
				}
			} else if (_local2.getValue() && (_local2.getValue().length > 0)) {
				_local4++;
			}
			_local3++;
		}
		if ((minRequired && (minRequired)) && (_local4 < minRequired)) {
			validationError = minRequirementError;
			return(false);
		}
		if ((maxRequired && (maxRequired)) && (_local4 > maxRequired)) {
			validationError = maxRequirementError;
			return(false);
		}
		if ((shouldBeEqual == true) && ((!_local5) || (!_local6))) {
			validationError = shouldBeEqualError;
			return(false);
		}
		return(true);
	}
	function getData() {
		var _local5 = "";
		var _local2;
		if (((shouldBeEqual == true) && (_groupItemsCollection.length > 0)) && (_groupItemsCollection[0])) {
			_local2 = tm.freshComponents.forms.formItems.FormItem(_groupItemsCollection[0]);
			_local5 = _local2.getValue();
		} else {
			var _local6 = false;
			var _local4 = new Array();
			var _local3 = 0;
			while (_local3 < _groupItemsCollection.length) {
				_local2 = tm.freshComponents.forms.formItems.FormItem(_groupItemsCollection[_local3]);
				if (_local2.__get__type() == tm.freshComponents.forms.formItems.FormItemType.RADIOBUTTON) {
					if (_local2.getValue() == "true") {
						_local5 = _local2.label;
					}
				} else {
					_local6 = true;
					if (_local2.__get__type() == tm.freshComponents.forms.formItems.FormItemType.CHECKBOX) {
						if (_local2.getValue() == "true") {
							_local4.push(_local2.__get__label());
						}
					} else {
						_local4.push(_local2.getValue());
					}
				}
				_local3++;
			}
			if (_local6) {
				_local5 = _local4.join(delimiter);
			}
		}
		return(_local5);
	}
	function itemExists(formItem) {
		var _local2 = 0;
		while (_local2 < _groupItemsCollection.length) {
			if ((tm.freshComponents.forms.formItems.FormItem)(_groupItemsCollection[_local2]).__get__id() == formItem.__get__id()) {
				return(true);
			}
			_local2++;
		}
		return(false);
	}
	var delimiter = "";
	var shouldBeEqual = false;
	var minRequirementError = "minRequirementError";
	var maxRequirementError = "maxRequirementError";
	var shouldBeEqualError = "shouldBeEqualError";
}
