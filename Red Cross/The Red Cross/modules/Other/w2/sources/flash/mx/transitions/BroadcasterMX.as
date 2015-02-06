class mx.transitions.BroadcasterMX
{
	var _listeners;
	function BroadcasterMX () {
	}
	static function initialize(o, dontCreateArray) {
		if (o.broadcastMessage != undefined) {
			delete o.broadcastMessage;
		}
		o.addListener = mx.transitions.BroadcasterMX.prototype.addListener;
		o.removeListener = mx.transitions.BroadcasterMX.prototype.removeListener;
		if (!dontCreateArray) {
			o._listeners = new Array();
		}
	}
	function addListener(o) {
		this.removeListener(o);
		if (broadcastMessage == undefined) {
			broadcastMessage = mx.transitions.BroadcasterMX.prototype.broadcastMessage;
		}
		return(_listeners.push(o));
	}
	function removeListener(o) {
		var _local2 = _listeners;
		var _local3 = _local2.length;
		while (_local3--) {
			if (_local2[_local3] == o) {
				_local2.splice(_local3, 1);
				if (!_local2.length) {
					broadcastMessage = undefined;
				}
				return(true);
			}
		}
		return(false);
	}
	function broadcastMessage() {
		var _local5 = String(arguments.shift());
		var _local4 = _listeners.concat();
		var _local6 = _local4.length;
		var _local3 = 0;
		while (_local3 < _local6) {
			_local4[_local3][_local5].apply(_local4[_local3], arguments);
			_local3++;
		}
	}
	static var version = "1.1.0.52";
}
