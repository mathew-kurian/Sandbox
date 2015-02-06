class mx.controls.RadioButton extends mx.controls.Button
{
	var setToggle, __value, selected, releaseFocus, phase, dispatchEvent, _parent, __data, setState, __state, getFocusManager;
	function RadioButton () {
		super();
	}
	function init(Void) {
		setToggle(__toggle);
		__value = this;
		super.init();
	}
	function size(Void) {
		super.size();
	}
	function onRelease() {
		if (selected) {
			return(undefined);
		}
		releaseFocus();
		phase = "up";
		setSelected(true);
		dispatchEvent({type:"click"});
		_parent[__groupName].dispatchEvent({type:"click"});
	}
	function setData(val) {
		__data = val;
	}
	function set data(val) {
		__data = val;
		//return(data);
	}
	function getData(val) {
		return(__data);
	}
	function get data() {
		return(__data);
	}
	function onUnload() {
		if (_parent[__groupName].selectedRadio == this) {
			_parent[__groupName].selectedRadio = undefined;
		}
		_parent[__groupName].radioList[indexNumber] = null;
		delete _parent[__groupName].radioList[indexNumber];
	}
	function setSelected(val) {
		var _local2 = _parent[__groupName];
		var _local5 = _local2.selectedRadio.__width;
		var _local4 = _local2.selectedRadio.__height;
		if (val) {
			_local2.selectedRadio.setState(false);
			_local2.selectedRadio = this;
		} else if (_local2.selectedRadio == this) {
			_local2.selectedRadio.setState(false);
			_local2.selectedRadio = undefined;
		}
		setState(val);
	}
	function deleteGroupObj(groupName) {
		delete _parent[groupName];
	}
	function getGroupName() {
		return(__groupName);
	}
	function get groupName() {
		return(__groupName);
	}
	function setGroupName(groupName) {
		if ((groupName == undefined) || (groupName == "")) {
			return(undefined);
		}
		delete _parent[__groupName].radioList[__data];
		addToGroup(groupName);
		__groupName = groupName;
	}
	function set groupName(groupName) {
		setGroupName(groupName);
		//return(this.groupName);
	}
	function addToGroup(groupName) {
		if ((groupName == "") || (groupName == undefined)) {
			return(undefined);
		}
		var _local2 = _parent[groupName];
		if (_local2 == undefined) {
			_local2 = (_parent[groupName] = new mx.controls.RadioButtonGroup());
			_local2.__groupName = groupName;
		}
		_local2.addInstance(this);
		if (__state) {
			_local2.selectedRadio.setState(false);
			_local2.selectedRadio = this;
		}
	}
	function get emphasized() {
		return(undefined);
	}
	function keyDown(e) {
		switch (e.code) {
			case 40 : 
				setNext();
				break;
			case 38 : 
				setPrev();
				break;
			case 37 : 
				setPrev();
				break;
			case 39 : 
				setNext();
		}
	}
	function setNext() {
		var _local2 = _parent[groupName];
		if ((_local2.selectedRadio.indexNumber + 1) == _local2.radioList.length) {
			return(undefined);
		}
		var _local4 = (_local2.selectedRadio ? (_local2.selectedRadio.indexNumber) : -1);
		var _local3 = 1;
		while (_local3 < _local2.radioList.length) {
			if ((_local2.radioList[_local4 + _local3] != undefined) && (_local2.radioList[_local4 + _local3].enabled)) {
				var _local5 = getFocusManager();
				_local2.radioList[_local4 + _local3].selected = true;
				_local5.setFocus(_local2.radioList[_local2.selectedRadio.indexNumber]);
				_local2.dispatchEvent({type:"click"});
				break;
			}
			_local3++;
		}
	}
	function setPrev() {
		var _local2 = _parent[groupName];
		if (_local2.selectedRadio.indexNumber == 0) {
			return(undefined);
		}
		var _local4 = (_local2.selectedRadio ? (_local2.selectedRadio.indexNumber) : 1);
		var _local3 = 1;
		while (_local3 < _local2.radioList.length) {
			if ((_local2.radioList[_local4 - _local3] != undefined) && (_local2.radioList[_local4 - _local3].enabled)) {
				var _local5 = getFocusManager();
				_local2.radioList[_local4 - _local3].selected = true;
				_local5.setFocus(_local2.radioList[_local2.selectedRadio.indexNumber]);
				_local2.dispatchEvent({type:"click"});
				break;
			}
			_local3++;
		}
	}
	function set toggle(v) {
		//return(toggle);
	}
	function get toggle() {
	}
	function set icon(v) {
		//return(icon);
	}
	function get icon() {
	}
	static var symbolName = "RadioButton";
	static var symbolOwner = mx.controls.RadioButton;
	static var version = "2.0.2.127";
	var className = "RadioButton";
	var btnOffset = 0;
	var __toggle = true;
	var __label = "Radio Button";
	var __labelPlacement = "right";
	var ignoreClassStyleDeclaration = {Button:1};
	var __groupName = "radioGroup";
	var indexNumber = 0;
	var offset = false;
	var falseUpSkin = "";
	var falseDownSkin = "";
	var falseOverSkin = "";
	var falseDisabledSkin = "";
	var trueUpSkin = "";
	var trueDownSkin = "";
	var trueOverSkin = "";
	var trueDisabledSkin = "";
	var falseUpIcon = "RadioFalseUp";
	var falseDownIcon = "RadioFalseDown";
	var falseOverIcon = "RadioFalseOver";
	var falseDisabledIcon = "RadioFalseDisabled";
	var trueUpIcon = "RadioTrueUp";
	var trueDownIcon = "";
	var trueOverIcon = "";
	var trueDisabledIcon = "RadioTrueDisabled";
	var centerContent = false;
	var borderW = 0;
	var clipParameters = {labelPlacement:1, data:1, label:1, groupName:1, selected:1};
	static var mergedClipParameters = mx.core.UIObject.mergeClipParameters(mx.controls.RadioButton.prototype.clipParameters, mx.controls.Button.prototype.clipParameters);
}
