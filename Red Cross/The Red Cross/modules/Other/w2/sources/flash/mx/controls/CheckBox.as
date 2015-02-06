class mx.controls.CheckBox extends mx.controls.Button
{
	var _getTextFormat, labelPath, iconName;
	function CheckBox () {
		super();
	}
	function onRelease() {
		super.onRelease();
	}
	function init() {
		super.init();
	}
	function size() {
		super.size();
	}
	function get emphasized() {
		return(undefined);
	}
	function calcPreferredHeight() {
		var _local5 = _getTextFormat();
		var _local3 = _local5.getTextExtent2(labelPath.text).height;
		var _local4 = iconName._height;
		var _local2 = 0;
		if ((__labelPlacement == "left") || (__labelPlacement == "right")) {
			_local2 = Math.max(_local3, _local4);
		} else {
			_local2 = _local3 + _local4;
		}
		return(Math.max(14, _local2));
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
	static var symbolName = "CheckBox";
	static var symbolOwner = mx.controls.CheckBox;
	static var version = "2.0.2.127";
	var className = "CheckBox";
	var ignoreClassStyleDeclaration = {Button:1};
	var btnOffset = 0;
	var __toggle = true;
	var __selected = false;
	var __labelPlacement = "right";
	var __label = "CheckBox";
	var falseUpSkin = "";
	var falseDownSkin = "";
	var falseOverSkin = "";
	var falseDisabledSkin = "";
	var trueUpSkin = "";
	var trueDownSkin = "";
	var trueOverSkin = "";
	var trueDisabledSkin = "";
	var falseUpIcon = "CheckFalseUp";
	var falseDownIcon = "CheckFalseDown";
	var falseOverIcon = "CheckFalseOver";
	var falseDisabledIcon = "CheckFalseDisabled";
	var trueUpIcon = "CheckTrueUp";
	var trueDownIcon = "CheckTrueDown";
	var trueOverIcon = "CheckTrueOver";
	var trueDisabledIcon = "CheckTrueDisabled";
	var clipParameters = {label:1, labelPlacement:1, selected:1};
	static var mergedClipParameters = mx.core.UIObject.mergeClipParameters(mx.controls.CheckBox.prototype.clipParameters, mx.controls.Button.prototype.clipParameters);
	var centerContent = false;
	var borderW = 0;
}
