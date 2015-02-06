class mx.managers.PopUpManager
{
	var popUp, setSize, move, modalWindow, _parent, _name, _visible, owner;
	function PopUpManager () {
	}
	static function createModalWindow(parent, o, broadcastOutsideEvents) {
		var _local2 = parent.createChildAtDepth("Modal", mx.managers.DepthManager.kTopmost);
		_local2.setDepthBelow(o);
		o.modalID = _local2._name;
		_local2._alpha = _global.style.modalTransparency;
		_local2.tabEnabled = false;
		if (broadcastOutsideEvents) {
			_local2.onPress = mixins.onPress;
		} else {
			_local2.onPress = mixins.nullFunction;
		}
		_local2.onRelease = mixins.nullFunction;
		_local2.resize = mixins.resize;
		mx.managers.SystemManager.init();
		mx.managers.SystemManager.addEventListener("resize", _local2);
		_local2.resize();
		_local2.useHandCursor = false;
		_local2.popUp = o;
		o.modalWindow = _local2;
		o.deletePopUp = mixins.deletePopUp;
		o.setVisible = mixins.setVisible;
		o.getVisible = mixins.getVisible;
		o.addProperty("visible", o.getVisible, o.setVisible);
	}
	static function createPopUp(parent, className, modal, initobj, broadcastOutsideEvents) {
		if (mixins == undefined) {
			mixins = new mx.managers.PopUpManager();
		}
		if (broadcastOutsideEvents == undefined) {
			broadcastOutsideEvents = false;
		}
		var _local5 = parent._root;
		if (_local5 == undefined) {
			_local5 = _root;
		}
		while (parent != _local5) {
			parent = parent._parent;
		}
		initobj.popUp = true;
		var _local4 = parent.createClassChildAtDepth(className, ((broadcastOutsideEvents || (modal)) ? (mx.managers.DepthManager.kTopmost) : (mx.managers.DepthManager.kTop)), initobj);
		var _local2 = _root;
		var _local6 = _local2.focusManager != undefined;
		while (_local2._parent != undefined) {
			_local2 = _local2._parent._root;
			if (_local2.focusManager != undefined) {
				_local6 = true;
				break;
			}
		}
		if (_local6) {
			_local4.createObject("FocusManager", "focusManager", -1);
			if (_local4._visible == false) {
				mx.managers.SystemManager.deactivate(_local4);
			}
		}
		if (modal) {
			createModalWindow(parent, _local4, broadcastOutsideEvents);
		} else {
			if (broadcastOutsideEvents) {
				_local4.mouseListener = new Object();
				_local4.mouseListener.owner = _local4;
				_local4.mouseListener.onMouseDown = mixins.onMouseDown;
				Mouse.addListener(_local4.mouseListener);
			}
			_local4.deletePopUp = mixins.deletePopUp;
		}
		return(_local4);
	}
	function onPress(Void) {
		var _local3 = popUp._root;
		if (_local3 == undefined) {
			_local3 = _root;
		}
		if (popUp.hitTest(_local3._xmouse, _local3._ymouse, false)) {
			return(undefined);
		}
		popUp.dispatchEvent({type:"mouseDownOutside"});
	}
	function nullFunction(Void) {
	}
	function resize(Void) {
		var _local2 = mx.managers.SystemManager.__get__screen();
		setSize(_local2.width, _local2.height);
		move(_local2.x, _local2.y);
	}
	function deletePopUp(Void) {
		if (modalWindow != undefined) {
			_parent.destroyObject(modalWindow._name);
		}
		_parent.destroyObject(_name);
	}
	function setVisible(v, noEvent) {
		super.setVisible(v, noEvent);
		modalWindow._visible = v;
	}
	function getVisible(Void) {
		return(_visible);
	}
	function onMouseDown(Void) {
		var _local3 = owner._root;
		if (_local3 == undefined) {
			_local3 = _root;
		}
		var _local4 = new Object();
		_local4.x = _local3._xmouse;
		_local4.y = _local3._ymouse;
		_local3.localToGlobal(_local4);
		if (owner.hitTest(_local4.x, _local4.y, false)) {
		} else {
			owner.mouseDownOutsideHandler(owner);
		}
	}
	static var version = "2.0.2.127";
	static var mixins = undefined;
}
