class mx.managers.SystemManager
{
	static var _xAddEventListener, addEventListener, __addEventListener, _xRemoveEventListener, removeEventListener, __removeEventListener, form, __screen, dispatchEvent;
	function SystemManager () {
	}
	static function init(Void) {
		if (_initialized == false) {
			_initialized = true;
			mx.events.EventDispatcher.initialize(mx.managers.SystemManager);
			Mouse.addListener(mx.managers.SystemManager);
			Stage.addListener(mx.managers.SystemManager);
			_xAddEventListener = addEventListener;
			addEventListener = __addEventListener;
			_xRemoveEventListener = removeEventListener;
			removeEventListener = __removeEventListener;
		}
	}
	static function addFocusManager(f) {
		form = f;
		f.focusManager.activate();
	}
	static function removeFocusManager(f) {
	}
	static function onMouseDown(Void) {
		var _local1 = form;
		_local1.focusManager._onMouseDown();
	}
	static function onResize(Void) {
		var _local7 = Stage.width;
		var _local6 = Stage.height;
		var _local9 = _global.origWidth;
		var _local8 = _global.origHeight;
		var _local3 = Stage.align;
		var _local5 = (_local9 - _local7) / 2;
		var _local4 = (_local8 - _local6) / 2;
		if (_local3 == "T") {
			_local4 = 0;
		} else if (_local3 == "B") {
			_local4 = _local8 - _local6;
		} else if (_local3 == "L") {
			_local5 = 0;
		} else if (_local3 == "R") {
			_local5 = _local9 - _local7;
		} else if (_local3 == "LT") {
			_local4 = 0;
			_local5 = 0;
		} else if (_local3 == "TR") {
			_local4 = 0;
			_local5 = _local9 - _local7;
		} else if (_local3 == "LB") {
			_local4 = _local8 - _local6;
			_local5 = 0;
		} else if (_local3 == "RB") {
			_local4 = _local8 - _local6;
			_local5 = _local9 - _local7;
		}
		if (__screen == undefined) {
			__screen = new Object();
		}
		__screen.x = _local5;
		__screen.y = _local4;
		__screen.width = _local7;
		__screen.height = _local6;
		_root.focusManager.relocate();
		dispatchEvent({type:"resize"});
	}
	static function get screen() {
		init();
		if (__screen == undefined) {
			mx.managers.SystemManager.onResize();
		}
		return(__screen);
	}
	static var _initialized = false;
	static var idleFrames = 0;
	static var isMouseDown = false;
	static var forms = new Array();
}
