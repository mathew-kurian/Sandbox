class mx.controls.SimpleButton extends mx.core.UIComponent
{
	static var emphasizedStyleDeclaration;
	var preset, boundingBox_mc, useHandCursor, skinName, linkLength, iconName, destroyObject, __width, _width, __height, _height, __emphaticStyleName, styleName, enabled, invalidate, pressFocus, dispatchEvent, autoRepeat, interval, getStyle, releaseFocus, createLabel, invalidateStyle;
	function SimpleButton () {
		super();
	}
	function init(Void) {
		super.init();
		if (preset == undefined) {
			boundingBox_mc._visible = false;
			boundingBox_mc._width = (boundingBox_mc._height = 0);
		}
		useHandCursor = false;
	}
	function createChildren(Void) {
		if (preset != undefined) {
			var _local2 = this[idNames[preset]];
			this[refNames[preset]] = _local2;
			skinName = _local2;
			if (falseOverSkin.length == 0) {
				rolloverSkin = fus;
			}
			if (falseOverIcon.length == 0) {
				rolloverIcon = fui;
			}
			initializing = false;
		} else if (__state == true) {
			setStateVar(true);
		} else {
			if (falseOverSkin.length == 0) {
				rolloverSkin = fus;
			}
			if (falseOverIcon.length == 0) {
				rolloverIcon = fui;
			}
		}
	}
	function setIcon(tag, linkageName) {
		return(setSkin(tag + 8, linkageName));
	}
	function changeIcon(tag, linkageName) {
		linkLength = linkageName.length;
		var _local2 = stateNames[tag] + "Icon";
		this[_local2] = linkageName;
		this[idNames[tag + 8]] = _local2;
		setStateVar(getState());
	}
	function changeSkin(tag, linkageName) {
		var _local2 = stateNames[tag] + "Skin";
		this[_local2] = linkageName;
		this[idNames[tag]] = _local2;
		setStateVar(getState());
	}
	function viewIcon(varName) {
		var _local4 = varName + "Icon";
		var _local3 = this[_local4];
		if (typeof(_local3) == "string") {
			var _local5 = _local3;
			if (__emphasized) {
				if (this[_local3 + "Emphasized"].length > 0) {
					_local3 = _local3 + "Emphasized";
				}
			}
			if (this[_local3].length == 0) {
				return(undefined);
			}
			_local3 = setIcon(tagMap[_local5], this[_local3]);
			if ((_local3 == undefined) && (_global.isLivePreview)) {
				_local3 = setIcon(0, "ButtonIcon");
			}
			this[_local4] = _local3;
		}
		iconName._visible = false;
		iconName = _local3;
		iconName._visible = true;
	}
	function removeIcons() {
		var _local3 = 0;
		while (_local3 < 2) {
			var _local2 = 8;
			while (_local2 < 16) {
				destroyObject(idNames[_local2]);
				this[stateNames[_local2 - 8] + "Icon"] = "";
				_local2++;
			}
			_local3++;
		}
		refresh();
	}
	function setSkin(tag, linkageName, initobj) {
		var _local3 = super.setSkin(tag, linkageName, ((initobj != undefined) ? (initobj) : ({styleName:this})));
		calcSize(tag, _local3);
		return(_local3);
	}
	function calcSize(Void) {
		__width = _width;
		__height = _height;
	}
	function viewSkin(varName, initObj) {
		var _local3 = varName + "Skin";
		var _local2 = this[_local3];
		if (typeof(_local2) == "string") {
			var _local4 = _local2;
			if (__emphasized) {
				if (this[_local2 + "Emphasized"].length > 0) {
					_local2 = _local2 + "Emphasized";
				}
			}
			if (this[_local2].length == 0) {
				return(undefined);
			}
			_local2 = setSkin(tagMap[_local4], this[_local2], ((initObj != undefined) ? (initObj) : ({styleName:this})));
			this[_local3] = _local2;
		}
		skinName._visible = false;
		skinName = _local2;
		skinName._visible = true;
	}
	function showEmphasized(e) {
		if (e && (!__emphatic)) {
			if (emphasizedStyleDeclaration != undefined) {
				__emphaticStyleName = styleName;
				styleName = emphasizedStyleDeclaration;
			}
			__emphatic = true;
		} else {
			if (__emphatic) {
				styleName = __emphaticStyleName;
			}
			__emphatic = false;
		}
	}
	function refresh(Void) {
		var _local2 = getState();
		if (enabled == false) {
			viewIcon("disabled");
			viewSkin("disabled");
		} else {
			viewSkin(phase);
			viewIcon(phase);
		}
		setView(phase == "down");
		iconName.enabled = enabled;
	}
	function setView(offset) {
		if (iconName == undefined) {
			return(undefined);
		}
		var _local2 = (offset ? (btnOffset) : 0);
		iconName._x = ((__width - iconName._width) / 2) + _local2;
		iconName._y = ((__height - iconName._height) / 2) + _local2;
	}
	function setStateVar(state) {
		if (state) {
			if (trueOverSkin.length == 0) {
				rolloverSkin = tus;
			} else {
				rolloverSkin = trs;
			}
			if (trueOverIcon.length == 0) {
				rolloverIcon = tui;
			} else {
				rolloverIcon = tri;
			}
			upSkin = tus;
			downSkin = tds;
			disabledSkin = dts;
			upIcon = tui;
			downIcon = tdi;
			disabledIcon = dti;
		} else {
			if (falseOverSkin.length == 0) {
				rolloverSkin = fus;
			} else {
				rolloverSkin = frs;
			}
			if (falseOverIcon.length == 0) {
				rolloverIcon = fui;
			} else {
				rolloverIcon = fri;
			}
			upSkin = fus;
			downSkin = fds;
			disabledSkin = dfs;
			upIcon = fui;
			downIcon = fdi;
			disabledIcon = dfi;
		}
		__state = state;
	}
	function setState(state) {
		if (state != __state) {
			setStateVar(state);
			invalidate();
		}
	}
	function size(Void) {
		refresh();
	}
	function draw(Void) {
		if (initializing) {
			initializing = false;
			skinName.visible = true;
			iconName.visible = true;
		}
		this.size();
	}
	function getState(Void) {
		return(__state);
	}
	function setToggle(val) {
		__toggle = val;
		if (__toggle == false) {
			setState(false);
		}
	}
	function getToggle(Void) {
		return(__toggle);
	}
	function set toggle(val) {
		setToggle(val);
		//return(toggle);
	}
	function get toggle() {
		return(getToggle());
	}
	function set value(val) {
		setSelected(val);
		//return(value);
	}
	function get value() {
		return(getSelected());
	}
	function set selected(val) {
		setSelected(val);
		//return(selected);
	}
	function get selected() {
		return(getSelected());
	}
	function setSelected(val) {
		if (__toggle) {
			setState(val);
		} else {
			setState((initializing ? (val) : (__state)));
		}
	}
	function getSelected() {
		return(__state);
	}
	function setEnabled(val) {
		if (enabled != val) {
			super.setEnabled(val);
			invalidate();
		}
	}
	function onPress(Void) {
		pressFocus();
		phase = "down";
		refresh();
		dispatchEvent({type:"buttonDown"});
		if (autoRepeat) {
			interval = setInterval(this, "onPressDelay", getStyle("repeatDelay"));
		}
	}
	function onPressDelay(Void) {
		dispatchEvent({type:"buttonDown"});
		if (autoRepeat) {
			clearInterval(interval);
			interval = setInterval(this, "onPressRepeat", getStyle("repeatInterval"));
		}
	}
	function onPressRepeat(Void) {
		dispatchEvent({type:"buttonDown"});
		updateAfterEvent();
	}
	function onRelease(Void) {
		releaseFocus();
		phase = "rollover";
		if (interval != undefined) {
			clearInterval(interval);
			delete interval;
		}
		if (getToggle()) {
			setState(!getState());
		} else {
			refresh();
		}
		dispatchEvent({type:"click"});
	}
	function onDragOut(Void) {
		phase = "up";
		refresh();
		dispatchEvent({type:"buttonDragOut"});
	}
	function onDragOver(Void) {
		if (phase != "up") {
			this.onPress();
			return(undefined);
		}
		phase = "down";
		refresh();
	}
	function onReleaseOutside(Void) {
		releaseFocus();
		phase = "up";
		if (interval != undefined) {
			clearInterval(interval);
			delete interval;
		}
	}
	function onRollOver(Void) {
		phase = "rollover";
		refresh();
	}
	function onRollOut(Void) {
		phase = "up";
		refresh();
	}
	function getLabel(Void) {
		return(fui.text);
	}
	function setLabel(val) {
		if (typeof(fui) == "string") {
			createLabel("fui", 8, val);
			fui.styleName = this;
		} else {
			fui.text = val;
		}
		var _local4 = fui._getTextFormat();
		var _local2 = _local4.getTextExtent2(val);
		fui._width = _local2.width + 5;
		fui._height = _local2.height + 5;
		iconName = fui;
		setView(__state);
	}
	function get emphasized() {
		return(__emphasized);
	}
	function set emphasized(val) {
		__emphasized = val;
		var _local2 = 0;
		while (_local2 < 8) {
			this[idNames[_local2]] = stateNames[_local2] + "Skin";
			if (typeof(this[idNames[_local2 + 8]]) == "movieclip") {
				this[idNames[_local2 + 8]] = stateNames[_local2] + "Icon";
			}
			_local2++;
		}
		showEmphasized(__emphasized);
		setStateVar(__state);
		invalidateStyle();
		//return(emphasized);
	}
	function keyDown(e) {
		if (e.code == 32) {
			this.onPress();
		}
	}
	function keyUp(e) {
		if (e.code == 32) {
			this.onRelease();
		}
	}
	function onKillFocus(newFocus) {
		super.onKillFocus();
		if (phase != "up") {
			phase = "up";
			refresh();
		}
	}
	static var symbolName = "SimpleButton";
	static var symbolOwner = mx.controls.SimpleButton;
	static var version = "2.0.2.127";
	var className = "SimpleButton";
	var style3dInset = 4;
	var btnOffset = 1;
	var __toggle = false;
	var __state = false;
	var __emphasized = false;
	var __emphatic = false;
	static var falseUp = 0;
	static var falseDown = 1;
	static var falseOver = 2;
	static var falseDisabled = 3;
	static var trueUp = 4;
	static var trueDown = 5;
	static var trueOver = 6;
	static var trueDisabled = 7;
	var falseUpSkin = "SimpleButtonUp";
	var falseDownSkin = "SimpleButtonIn";
	var falseOverSkin = "";
	var falseDisabledSkin = "SimpleButtonUp";
	var trueUpSkin = "SimpleButtonIn";
	var trueDownSkin = "";
	var trueOverSkin = "";
	var trueDisabledSkin = "SimpleButtonIn";
	var falseUpIcon = "";
	var falseDownIcon = "";
	var falseOverIcon = "";
	var falseDisabledIcon = "";
	var trueUpIcon = "";
	var trueDownIcon = "";
	var trueOverIcon = "";
	var trueDisabledIcon = "";
	var phase = "up";
	var fui = "falseUpIcon";
	var fus = "falseUpSkin";
	var fdi = "falseDownIcon";
	var fds = "falseDownSkin";
	var frs = "falseOverSkin";
	var fri = "falseOverIcon";
	var dfi = "falseDisabledIcon";
	var dfs = "falseDisabledSkin";
	var tui = "trueUpIcon";
	var tus = "trueUpSkin";
	var tdi = "trueDownIcon";
	var tds = "trueDownSkin";
	var trs = "trueOverSkin";
	var tri = "trueOverIcon";
	var dts = "trueDisabledSkin";
	var dti = "trueDisabledIcon";
	var rolloverSkin = mx.controls.SimpleButton.prototype.frs;
	var rolloverIcon = mx.controls.SimpleButton.prototype.fri;
	var upSkin = mx.controls.SimpleButton.prototype.fus;
	var downSkin = mx.controls.SimpleButton.prototype.fds;
	var disabledSkin = mx.controls.SimpleButton.prototype.dfs;
	var upIcon = mx.controls.SimpleButton.prototype.fui;
	var downIcon = mx.controls.SimpleButton.prototype.fdi;
	var disabledIcon = mx.controls.SimpleButton.prototype.dfi;
	var initializing = true;
	var idNames = ["fus", "fds", "frs", "dfs", "tus", "tds", "trs", "dts", "fui", "fdi", "fri", "dfi", "tui", "tdi", "tri", "dti"];
	var stateNames = ["falseUp", "falseDown", "falseOver", "falseDisabled", "trueUp", "trueDown", "trueOver", "trueDisabled"];
	var refNames = ["upSkin", "downSkin", "rolloverSkin", "disabledSkin"];
	var tagMap = {falseUpSkin:0, falseDownSkin:1, falseOverSkin:2, falseDisabledSkin:3, trueUpSkin:4, trueDownSkin:5, trueOverSkin:6, trueDisabledSkin:7, falseUpIcon:0, falseDownIcon:1, falseOverIcon:2, falseDisabledIcon:3, trueUpIcon:4, trueDownIcon:5, trueOverIcon:6, trueDisabledIcon:7};
}
