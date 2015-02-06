class com.oop.core.Watcher
{
    var watchNum, unwatch;
    function Watcher(obj, prop, propMatch, path, f, arg)
    {
        obj.watchNum = ++obj.watchNum || 0;
        obj["watchPath" + obj.watchNum] = path;
        obj["watchFunction" + obj.watchNum] = f;
        obj["watchArgument" + obj.watchNum] = arg;
        obj.watch(prop, mainWatcher, propMatch);
    } // End of the function
    function mainWatcher(prop, oldVal, newVal, propMatch)
    {
        if (newVal == propMatch)
        {
            this["watchPath" + watchNum][this["watchFunction" + watchNum]](this["watchArgument" + watchNum]);
            this.unwatch(prop);
        } // end if
        return (newVal);
    } // End of the function
} // End of Class
