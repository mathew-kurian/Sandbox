class mx.events.EventDispatcher
{
	function EventDispatcher () {
	}
	static function _removeEventListener(queue, event, handler) {
		if (queue != undefined) {
			var _local4 = queue.length;
			var _local1;
			_local1 = 0;
			while (_local1 < _local4) {
				var _local2 = queue[_local1];
				if (_local2 == handler) {
					queue.splice(_local1, 1);
					return(undefined);
				}
				_local1++;
			}
		}
	}
	static function initialize(object) {
		if (_fEventDispatcher == undefined) {
			_fEventDispatcher = new mx.events.EventDispatcher();
		}
		object.addEventListener = _fEventDispatcher.addEventListener;
		object.removeEventListener = _fEventDispatcher.removeEventListener;
		object.dispatchEvent = _fEventDispatcher.dispatchEvent;
		object.dispatchQueue = _fEventDispatcher.dispatchQueue;
	}
	function dispatchQueue(queueObj, eventObj) {
		var _local7 = "__q_" + eventObj.type;
		var _local4 = queueObj[_local7];
		if (_local4 != undefined) {
			var _local5;
			for (_local5 in _local4) {
				var _local1 = _local4[_local5];
				var _local3 = typeof(_local1);
				if ((_local3 == "object") || (_local3 == "movieclip")) {
					if (_local1.handleEvent != undefined) {
						_local1.handleEvent(eventObj);
					}
					if (_local1[eventObj.type] != undefined) {
						if (exceptions[eventObj.type] == undefined) {
							_local1[eventObj.type](eventObj);
						}
					}
				} else {
					_local1.apply(queueObj, [eventObj]);
				}
			}
		}
	}
	function dispatchEvent(eventObj) {
		if (eventObj.target == undefined) {
			eventObj.target = this;
		}
		this[eventObj.type + "Handler"](eventObj);
		dispatchQueue(this, eventObj);
	}
	function addEventListener(event, handler) {
		var _local3 = "__q_" + event;
		if (this[_local3] == undefined) {
			this[_local3] = new Array();
		}
		_global.ASSetPropFlags(this, _local3, 1);
		_removeEventListener(this[_local3], event, handler);
		this[_local3].push(handler);
	}
	function removeEventListener(event, handler) {
		var _local2 = "__q_" + event;
		_removeEventListener(this[_local2], event, handler);
	}
	static var _fEventDispatcher = undefined;
	static var exceptions = {move:1, draw:1, load:1};
}
