    class mx.transitions.OnEnterFrameBeacon
    {
        function OnEnterFrameBeacon () {
        }
        static function init() {
            var _local4 = _global["MovieClip"];
            if (!_root.__OnEnterFrameBeacon) {
                mx.transitions.BroadcasterMX.initialize(_local4);
                var _local3 = _root.createEmptyMovieClip("__OnEnterFrameBeacon", 9876);
                _local3.onEnterFrame = function () {
                    _global["MovieClip"].broadcastMessage("onEnterFrame");
                };
            }
        }
        static var version = "1.1.0.52";
    }
