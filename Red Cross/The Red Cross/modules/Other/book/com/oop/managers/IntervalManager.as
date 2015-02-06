class com.oop.managers.IntervalManager
{
    function IntervalManager()
    {
    } // End of the function
    static function setInterval(connection, intName, path, func, time)
    {
        com.oop.managers.IntervalManager.clearInterval(connection, intName);
        if (connection instanceof MovieClip)
        {
            if (com.oop.managers.IntervalManager.__listeners[connection] == undefined)
            {
                com.oop.managers.IntervalManager.__listeners[connection] = {};
            } // end if
            com.oop.managers.IntervalManager.__listeners[connection][intName] = _global.setInterval(path, func, time, arguments[5], arguments[6], arguments[7], arguments[8], arguments[9], arguments[10]);
        }
        else
        {
            if (connection.intervalID == undefined)
            {
                __intervalID = ++com.oop.managers.IntervalManager.__intervalID;
                connection.intervalID = "int" + com.oop.managers.IntervalManager.__intervalID;
            } // end if
            com.oop.managers.IntervalManager.__listeners[connection.intervalID] = {};
            com.oop.managers.IntervalManager.__listeners[connection.intervalID][intName] = _global.setInterval(path, func, time, arguments[5], arguments[6], arguments[7], arguments[8], arguments[9], arguments[10]);
        } // end else if
    } // End of the function
    static function clearInterval(connection, intName)
    {
        if (connection instanceof MovieClip)
        {
            _global.clearInterval(com.oop.managers.IntervalManager.__listeners[connection][intName]);
        }
        else
        {
            _global.clearInterval(com.oop.managers.IntervalManager.__listeners[connection.intervalID][intName]);
        } // end else if
    } // End of the function
    static function clearAllIntervals(main)
    {
        for (var _loc4 in com.oop.managers.IntervalManager.__listeners)
        {
            for (var _loc3 in com.oop.managers.IntervalManager.__listeners[_loc4])
            {
                if (main)
                {
                    if (String(_loc4).indexOf(String(main)) != -1)
                    {
                        _global.clearInterval(com.oop.managers.IntervalManager.__listeners[_loc4][_loc3]);
                    } // end if
                    continue;
                } // end if
                _global.clearInterval(com.oop.managers.IntervalManager.__listeners[_loc4][_loc3]);
            } // end of for...in
        } // end of for...in
    } // End of the function
    static function clearIntervalsConnection(connection)
    {
        for (var _loc3 in com.oop.managers.IntervalManager.__listeners[connection])
        {
            _global.clearInterval(com.oop.managers.IntervalManager.__listeners[connection][_loc3]);
        } // end of for...in
    } // End of the function
    static var __listeners = {};
    static var __intervalID = 0;
} // End of Class
