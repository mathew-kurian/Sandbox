class mx.controls.Button extends mx.controls.SimpleButton
{
	var initializing, labelPath, initIcon, getState, enabled, phase, idNames, __width, __height, setState, invalidate, iconName, refresh, createLabel, _iconLinkageName, removeIcons, hitArea_mc, createEmptyObject;
	function Button () {
		super();
	}
	function init(Void) {
		super.init();
	}
	function draw() {
		if (initializing) {
			labelPath.visible = true;
		}
		super.draw();
		if (initIcon != undefined) {
			_setIcon(initIcon);
		}
		delete initIcon;
	}
	function onRelease(Void) {
		super.onRelease();
	}
	function createChildren(Void) {
		super.createChildren();
	}
	function setSkin(tag, linkageName, initobj) {
		return(super.setSkin(tag, linkageName, initobj));
	}
	function viewSkin(varName) {
		var _local3 = (getState() ? "true" : "false");
		_local3 = _local3 + (enabled ? (phase) : "disabled");
		super.viewSkin(varName, {styleName:this, borderStyle:_local3});
	}
	function invalidateStyle(c) {
		labelPath.invalidateStyle(c);
		super.invalidateStyle(c);
	}
	function setColor(c) {
		var _local2 = 0;
		while (_local2 < 8) {
			this[idNames[_local2]].redraw(true);
			_local2++;
		}
	}
	function setEnabled(enable) {
		labelPath.enabled = enable;
		super.setEnabled(enable);
	}
	function calcSize(tag, ref) {
		if ((__width == undefined) || (__height == undefined)) {
			return(undefined);
		}
		if (tag < 7) {
			ref.setSize(__width, __height, true);
		}
	}
	function size(Void) {
		setState(getState());
		setHitArea(__width, __height);
		var _local3 = 0;
		while (_local3 < 8) {
			var _local4 = idNames[_local3];
			if (typeof(this[_local4]) == "movieclip") {
				this[_local4].setSize(__width, __height, true);
			}
			_local3++;
		}
		super.size();
	}
	function set labelPlacement(val) {
		__labelPlacement = val;
		invalidate();
		//return(labelPlacement);
	}
	function get labelPlacement() {
		return(__labelPlacement);
	}
	function getLabelPlacement(Void) {
		return(__labelPlacement);
	}
	function setLabelPlacement(val) {
		__labelPlacement = val;
		invalidate();
	}
	function getBtnOffset(Void) {
		if (getState()) {
			var _local2 = btnOffset;
		} else if (phase == "down") {
			var _local2 = btnOffset;
		} else {
			var _local2 = 0;
		}
		return(_local2);
	}
	function setView(offset) {
		var _local16 = (offset ? (btnOffset) : 0);
		var _local12 = getLabelPlacement();
		var _local7 = 0;
		var _local6 = 0;
		var _local11 = 0;
		var _local8 = 0;
		var _local5 = 0;
		var _local4 = 0;
		var _local3 = labelPath;
		var _local2 = iconName;
		var _local15 = _local3.textWidth;
		var _local14 = _local3.textHeight;
		var _local9 = (__width - borderW) - borderW;
		var _local10 = (__height - borderW) - borderW;
		if (_local2 != undefined) {
			_local7 = _local2._width;
			_local6 = _local2._height;
		}
		if ((_local12 == "left") || (_local12 == "right")) {
			if (_local3 != undefined) {
				_local11 = Math.min(_local9 - _local7, _local15 + 5);
				_local3._width = _local11;
				_local8 = Math.min(_local10, _local14 + 5);
				_local3._height = _local8;
			}
			if (_local12 == "right") {
				_local5 = _local7;
				if (centerContent) {
					_local5 = _local5 + (((_local9 - _local11) - _local7) / 2);
				}
				_local2._x = _local5 - _local7;
			} else {
				_local5 = (_local9 - _local11) - _local7;
				if (centerContent) {
					_local5 = _local5 / 2;
				}
				_local2._x = _local5 + _local11;
			}
			_local4 = 0;
			_local2._y = _local4;
			if (centerContent) {
				_local2._y = (_local10 - _local6) / 2;
				_local4 = (_local10 - _local8) / 2;
			}
			if (!centerContent) {
				_local2._y = _local2._y + Math.max(0, (_local8 - _local6) / 2);
			}
		} else {
			if (_local3 != undefined) {
				_local11 = Math.min(_local9, _local15 + 5);
				_local3._width = _local11;
				_local8 = Math.min(_local10 - _local6, _local14 + 5);
				_local3._height = _local8;
			}
			_local5 = (_local9 - _local11) / 2;
			_local2._x = (_local9 - _local7) / 2;
			if (_local12 == "top") {
				_local4 = (_local10 - _local8) - _local6;
				if (centerContent) {
					_local4 = _local4 / 2;
				}
				_local2._y = _local4 + _local8;
			} else {
				_local4 = _local6;
				if (centerContent) {
					_local4 = _local4 + (((_local10 - _local8) - _local6) / 2);
				}
				_local2._y = _local4 - _local6;
			}
		}
		var _local13 = borderW + _local16;
		_local3._x = _local5 + _local13;
		_local3._y = _local4 + _local13;
		_local2._x = _local2._x + _local13;
		_local2._y = _local2._y + _local13;
	}
	function set label(lbl) {
		setLabel(lbl);
		//return(label);
	}
	function setLabel(label) {
		if (label == "") {
			labelPath.removeTextField();
			refresh();
			return(undefined);
		}
		if (labelPath == undefined) {
			var _local2 = createLabel("labelPath", 200, label);
			_local2._width = _local2.textWidth + 5;
			_local2._height = _local2.textHeight + 5;
			if (initializing) {
				_local2.visible = false;
			}
		} else {
			delete labelPath.__text;
			labelPath.text = label;
			refresh();
		}
	}
	function getLabel(Void) {
		return(((labelPath.__text != undefined) ? (labelPath.__text) : (labelPath.text)));
	}
	function get label() {
		return(getLabel());
	}
	function _getIcon(Void) {
		return(_iconLinkageName);
	}
	function get icon() {
		if (initializing) {
			return(initIcon);
		}
		return(_iconLinkageName);
	}
	function _setIcon(linkage) {
		if (initializing) {
			if (linkage == "") {
				return(undefined);
			}
			initIcon = linkage;
		} else {
			if (linkage == "") {
				removeIcons();
				return(undefined);
			}
			super.changeIcon(0, linkage);
			super.changeIcon(1, linkage);
			super.changeIcon(3, linkage);
			super.changeIcon(4, linkage);
			super.changeIcon(5, linkage);
			_iconLinkageName = linkage;
			refresh();
		}
	}
	function set icon(linkage) {
		_setIcon(linkage);
		//return(icon);
	}
	function setHitArea(w, h) {
		if (hitArea_mc == undefined) {
			createEmptyObject("hitArea_mc", 100);
		}
		var _local2 = hitArea_mc;
		_local2.clear();
		_local2.beginFill(16711680);
		_local2.drawRect(0, 0, w, h);
		_local2.endFill();
		_local2.setVisible(false);
	}
	static var symbolName = "Button";
	static var symbolOwner = mx.controls.Button;
	var className = "Button";
	static var version = "2.0.2.127";
	var btnOffset = 0;
	var _color = "buttonColor";
	var __label = "default value";
	var __labelPlacement = "right";
	var falseUpSkin = "ButtonSkin";
	var falseDownSkin = "ButtonSkin";
	var falseOverSkin = "ButtonSkin";
	var falseDisabledSkin = "ButtonSkin";
	var trueUpSkin = "ButtonSkin";
	var trueDownSkin = "ButtonSkin";
	var trueOverSkin = "ButtonSkin";
	var trueDisabledSkin = "ButtonSkin";
	var falseUpIcon = "";
	var falseDownIcon = "";
	var falseOverIcon = "";
	var falseDisabledIcon = "";
	var trueUpIcon = "";
	var trueDownIcon = "";
	var trueOverIcon = "";
	var trueDisabledIcon = "";
	var clipParameters = {labelPlacement:1, icon:1, toggle:1, selected:1, label:1};
	static var mergedClipParameters = mx.core.UIObject.mergeClipParameters(mx.controls.Button.prototype.clipParameters, mx.controls.SimpleButton.prototype.clipParameters);
	var centerContent = true;
	var borderW = 1;
}
