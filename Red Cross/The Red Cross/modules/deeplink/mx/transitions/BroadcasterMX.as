class mx.transitions.BroadcasterMX
{
    var _listeners;
    function BroadcasterMX()
    {
    } // End of the function
    static function initialize(o, dontCreateArray)
    {
        if (o.broadcastMessage != undefined)
        {
            delete o.broadcastMessage;
        } // end if
        o.addListener = mx.transitions.BroadcasterMX.prototype.addListener;
        o.removeListener = mx.transitions.BroadcasterMX.prototype.removeListener;
        if (!dontCreateArray)
        {
            o._listeners = new Array();
        } // end if
    } // End of the function
    function addListener(o)
    {
        this.removeListener(o);
        if (broadcastMessage == undefined)
        {
            broadcastMessage = mx.transitions.BroadcasterMX.prototype.broadcastMessage;
        } // end if
        return (_listeners.push(o));
    } // End of the function
    function removeListener(o)
    {
        var _loc2 = _listeners;
        var _loc3 = _loc2.length;
        while (_loc3--)
        {
            if (_loc2[_loc3] == o)
            {
                _loc2.splice(_loc3, 1);
                if (!_loc2.length)
                {
                    broadcastMessage = undefined;
                } // end if
                return (true);
            } // end if
        } // end while
        return (false);
    } // End of the function
    function broadcastMessage()
    {
        var _loc5 = String(arguments.shift());
        var _loc4 = _listeners.concat();
        var _loc6 = _loc4.length;
        for (var _loc3 = 0; _loc3 < _loc6; ++_loc3)
        {
            _loc4[_loc3][_loc5].apply(_loc4[_loc3], arguments);
        } // end of for
    } // End of the function
    static var version = "1.1.0.52";
} // End of Class
