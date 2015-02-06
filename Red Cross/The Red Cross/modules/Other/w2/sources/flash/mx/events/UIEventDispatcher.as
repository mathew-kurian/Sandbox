class mx.events.UIEventDispatcher extends mx.events.EventDispatcher
{
	var dispatchQueue, owner, __sentLoadEvent, __origAddEventListener;
	function UIEventDispatcher () {
		super();
	}
	static function addKeyEvents(obj) {
		if (obj.keyHandler == undefined) {
			var _local1 = (obj.keyHandler = new Object());
			_local1.owner = obj;
			_local1.onKeyDown = _fEventDispatcher.onKeyDown;
			_local1.onKeyUp = _fEventDispatcher.onKeyUp;
		}
		Key.addListener(obj.keyHandler);
	}
	static function removeKeyEvents(obj) {
		Key.removeListener(obj.keyHandler);
	}
	static function addLoadEvents(obj) {
		if (obj.onLoad == undefined) {
			obj.onLoad = _fEventDispatcher.onLoad;
			obj.onUnload = _fEventDispatcher.onUnload;
			if (obj.getBytesTotal() == obj.getBytesLoaded()) {
				obj.doLater(obj, "onLoad");
			}
		}
	}
	static function removeLoadEvents(obj) {
		delete obj.onLoad;
		delete obj.onUnload;
	}
	static function initialize(obj) {
		if (_fEventDispatcher == undefined) {
			_fEventDispatcher = new mx.events.UIEventDispatcher();
		}
		obj.addEventListener = _fEventDispatcher.__addEventListener;
		obj.__origAddEventListener = _fEventDispatcher.addEventListener;
		obj.removeEventListener = _fEventDispatcher.removeEventListener;
		obj.dispatchEvent = _fEventDispatcher.dispatchEvent;
		obj.dispatchQueue = _fEventDispatcher.dispatchQueue;
	}
	function dispatchEvent(eventObj) {
		if (eventObj.target == undefined) {
			eventObj.target = this;
		}
		this[eventObj.type + "Handler"](eventObj);
		dispatchQueue(mx.events.EventDispatcher, eventObj);
		dispatchQueue(this, eventObj);
	}
	function onKeyDown(Void) {
		owner.dispatchEvent({type:"keyDown", code:Key.getCode(), ascii:Key.getAscii(), shiftKey:Key.isDown(16), ctrlKey:Key.isDown(17)});
	}
	function onKeyUp(Void) {
		owner.dispatchEvent({type:"keyUp", code:Key.getCode(), ascii:Key.getAscii(), shiftKey:Key.isDown(16), ctrlKey:Key.isDown(17)});
	}
	function onLoad(Void) {
		if (__sentLoadEvent != true) {
			dispatchEvent({type:"load"});
		}
		__sentLoadEvent = true;
	}
	function onUnload(Void) {
		dispatchEvent({type:"unload"});
	}
	function __addEventListener(event, handler) {
		__origAddEventListener(event, handler);
		var _local3 = lowLevelEvents;
		for (var _local5 in _local3) {
			if (mx.events.UIEventDispatcher[_local5][event] != undefined) {
				var _local2 = _local3[_local5][0];
				mx.events.UIEventDispatcher[_local2](this);
			}
		}
	}
	function removeEventListener(event, handler) {
		var _local6 = "__q_" + event;
		mx.events.EventDispatcher._removeEventListener(this[_local6], event, handler);
		if (this[_local6].length == 0) {
			var _local2 = lowLevelEvents;
			for (var _local5 in _local2) {
				if (mx.events.UIEventDispatcher[_local5][event] != undefined) {
					var _local3 = _local2[_local5][1];
					mx.events.UIEventDispatcher[_local2[_local5][1]](this);
				}
			}
		}
	}
	static var keyEvents = {keyDown:1, keyUp:1};
	static var loadEvents = {load:1, unload:1};
	static var lowLevelEvents = {keyEvents:["addKeyEvents", "removeKeyEvents"], loadEvents:["addLoadEvents", "removeLoadEvents"]};
	static var _fEventDispatcher = undefined;
}
