    class mx.transitions.BroadcasterMX
    {
        var _listeners;
        function BroadcasterMX () {
        }
        static function initialize(_arg1, _arg2) {
            if (_arg1.broadcastMessage != undefined) {
                delete _arg1.broadcastMessage;
            }
            _arg1.addListener = mx.transitions.BroadcasterMX.prototype.addListener;
            _arg1.removeListener = mx.transitions.BroadcasterMX.prototype.removeListener;
            if (!_arg2) {
                _arg1._listeners = new Array();
            }
        }
        function addListener(_arg2) {
            this.removeListener(_arg2);
            if (broadcastMessage == undefined) {
                broadcastMessage = mx.transitions.BroadcasterMX.prototype.broadcastMessage;
            }
            return(_listeners.push(_arg2));
        }
        function removeListener(_arg4) {
            var _local2 = _listeners;
            var _local3 = _local2.length;
            while (_local3--) {
                if (_local2[_local3] == _arg4) {
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
