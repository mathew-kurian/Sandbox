class mx.controls.RadioButtonGroup
{
	var radioList, __groupName, selectedRadio;
	function RadioButtonGroup () {
		init();
		mx.events.UIEventDispatcher.initialize(this);
	}
	function init(Void) {
		radioList = new Array();
	}
	function setGroupName(groupName) {
		if ((groupName == undefined) || (groupName == "")) {
			return(undefined);
		}
		var _local6 = __groupName;
		_parent[groupName] = this;
		for (var _local5 in radioList) {
			radioList[_local5].groupName = groupName;
			var _local3 = radioList[_local5];
		}
		_local3.deleteGroupObj(_local6);
	}
	function getGroupName() {
		return(__groupName);
	}
	function addInstance(instance) {
		instance.indexNumber = indexNumber++;
		radioList.push(instance);
	}
	function getValue() {
		if (selectedRadio.data == "") {
			return(selectedRadio.label);
		}
		return(selectedRadio.__data);
	}
	function getLabelPlacement() {
		for (var _local3 in radioList) {
			var _local2 = radioList[_local3].getLabelPlacement();
		}
		return(_local2);
	}
	function setLabelPlacement(pos) {
		for (var _local3 in radioList) {
			radioList[_local3].setLabelPlacement(pos);
		}
	}
	function setEnabled(val) {
		for (var _local3 in radioList) {
			radioList[_local3].enabled = val;
		}
	}
	function setSize(val, val1) {
		for (var _local3 in radioList) {
			radioList[_local3].setSize(val, val1);
		}
	}
	function getEnabled() {
		for (var _local4 in radioList) {
			var _local2 = radioList[_local4].enabled;
			var _local3 = t + (_local2 + 0);
		}
		if (_local3 == radioList.length) {
			return(true);
		}
		if (_local3 == 0) {
			return(false);
		}
	}
	function setStyle(name, val) {
		for (var _local4 in radioList) {
			radioList[_local4].setStyle(name, val);
		}
	}
	function setInstance(val) {
		for (var _local3 in radioList) {
			if (radioList[_local3] == val) {
				radioList[_local3].selected = true;
			}
		}
	}
	function getInstance() {
		return(selectedRadio);
	}
	function setValue(val) {
		for (var _local4 in radioList) {
			if ((radioList[_local4].__data == val) || (radioList[_local4].label == val)) {
				var _local2 = _local4;
				break;
			}
		}
		if (_local2 != undefined) {
			selectedRadio.setState(false);
			selectedRadio.hitArea_mc._height = selectedRadio.__height;
			selectedRadio.hitArea_mc._width = selectedRadio.__width;
			selectedRadio = radioList[_local2];
			selectedRadio.setState(true);
			selectedRadio.hitArea_mc._height = (selectedRadio.hitArea_mc._width = 0);
		}
	}
	function set groupName(groupName) {
		if ((groupName == undefined) || (groupName == "")) {
			return;
		}
		var _local6 = __groupName;
		_parent[groupName] = this;
		for (var _local5 in radioList) {
			radioList[_local5].groupName = groupName;
			var _local3 = radioList[_local5];
		}
		_local3.deleteGroupObj(_local6);
		//return(this.groupName);
	}
	function get groupName() {
		return(__groupName);
	}
	function set selectedData(val) {
		for (var _local4 in radioList) {
			if ((radioList[_local4].__data == val) || (radioList[_local4].label == val)) {
				var _local2 = _local4;
				break;
			}
		}
		if (_local2 != undefined) {
			selectedRadio.setState(false);
			selectedRadio = radioList[_local2];
			selectedRadio.setState(true);
		}
		//return(selectedData);
	}
	function get selectedData() {
		if ((selectedRadio.data == "") || (selectedRadio.data == undefined)) {
			return(selectedRadio.label);
		}
		return(selectedRadio.__data);
	}
	function get selection() {
		return(selectedRadio);
	}
	function set selection(val) {
		for (var _local3 in radioList) {
			if (radioList[_local3] == val) {
				radioList[_local3].selected = true;
			}
		}
		//return(selection);
	}
	function set labelPlacement(pos) {
		for (var _local3 in radioList) {
			radioList[_local3].setLabelPlacement(pos);
		}
		//return(labelPlacement);
	}
	function get labelPlacement() {
		for (var _local3 in radioList) {
			var _local2 = radioList[_local3].getLabelPlacement();
		}
		return(_local2);
	}
	function set enabled(val) {
		for (var _local3 in radioList) {
			radioList[_local3].enabled = val;
		}
		//return(enabled);
	}
	function get enabled() {
		var _local2 = 0;
		for (var _local3 in radioList) {
			_local2 = _local2 + radioList[_local3].enabled;
		}
		if (_local2 == 0) {
			return(false);
		}
		if (_local2 == radioList.length) {
			return(true);
		}
	}
	static var symbolName = "RadioButtonGroup";
	static var symbolOwner = mx.controls.RadioButtonGroup;
	static var version = "2.0.2.127";
	var className = "RadioButtonGroup";
	var indexNumber = 0;
}
