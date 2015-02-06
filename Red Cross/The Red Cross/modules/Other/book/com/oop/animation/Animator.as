class com.oop.animation.Animator
{
    var tweenFormat;
    function Animator()
    {
        tweenFormat = new Object();
        this.addTweenFormat("_default");
    } // End of the function
    function tweenP()
    {
    } // End of the function
    function addTweenFormat(formatName, time, _class, _function, intervalTime)
    {
        tweenFormat[formatName] = new Object();
        tweenFormat[formatName].time = time || defaultTime;
        tweenFormat[formatName]._class = _class || defaultClass;
        tweenFormat[formatName]._function = _function || defaultFunction;
        tweenFormat[formatName].intervalTime = intervalTime || defaultIntervalTime;
    } // End of the function
    function getEaseFunction(_class, _function)
    {
        var _loc1 = com.robertpenner.easing.Linear.easeNone;
        switch (_class)
        {
            case "Back":
            {
                _loc1 = com.robertpenner.easing.Back[_function];
                break;
            } 
            case "Bounce":
            {
                _loc1 = com.robertpenner.easing.Bounce[_function];
                break;
            } 
            case "Circ":
            {
                _loc1 = com.robertpenner.easing.Circ[_function];
                break;
            } 
            case "Cubic":
            {
                _loc1 = com.robertpenner.easing.Cubic[_function];
                break;
            } 
            case "Elastic":
            {
                _loc1 = com.robertpenner.easing.Elastic[_function];
                break;
            } 
            case "Expo":
            {
                _loc1 = com.robertpenner.easing.Expo[_function];
                break;
            } 
            case "Linear":
            {
                _loc1 = com.robertpenner.easing.Linear[_function];
                break;
            } 
            case "Quad":
            {
                _loc1 = com.robertpenner.easing.Quad[_function];
                break;
            } 
            case "Quart":
            {
                _loc1 = com.robertpenner.easing.Quart[_function];
                break;
            } 
            case "Quint":
            {
                _loc1 = com.robertpenner.easing.Quint[_function];
                break;
            } 
            case "Sine":
            {
                _loc1 = com.robertpenner.easing.Sine[_function];
                break;
            } 
        } // End of switch
        return (_loc1);
    } // End of the function
    function tweenF(clip, prop, startValue, destValue, format)
    {
        if (tweenFormat[format])
        {
            this.tween(clip, prop, startValue, destValue, tweenFormat[format].time, tweenFormat[format]._class, tweenFormat[format]._function, tweenFormat[format].intervalTime);
        }
        else
        {
            this.tween(clip, prop, startValue, destValue);
        } // end else if
    } // End of the function
    function callTween(clip, path, method, startParams, destParams, time, easeClass, easeFunction, intervalTime)
    {
        var _loc2 = new Object();
        _loc2.interval = "interval" + method;
        _loc2.count = 1;
        time = time || defaultTime;
        _loc2.intervalTime = intervalTime || defaultIntervalTime;
        _loc2.totalInts = Math.floor(time / _loc2.intervalTime);
        _loc2.clip = clip;
        _loc2.path = path;
        _loc2.method = method;
        _loc2.easeFunction = this.getEaseFunction(easeClass, easeFunction);
        _loc2.startParams = startParams;
        _loc2.changeParams = new Object();
        for (var _loc5 in startParams)
        {
            _loc2.changeParams[_loc5] = destParams[_loc5] - startParams[_loc5];
        } // end of for...in
        com.oop.managers.IntervalManager.setInterval(clip, _loc2.interval, this, "runCallTween", _loc2.intervalTime, _loc2);
        this.runCallTween(_loc2);
    } // End of the function
    function runCallTween(intObj)
    {
        var _loc5 = intObj.startParams;
        var _loc2 = intObj.changeParams;
        var _loc6 = intObj.count;
        var _loc4 = intObj.totalInts;
        var _loc3 = {};
        for (var _loc7 in _loc2)
        {
            _loc3[_loc7] = intObj.easeFunction(_loc6, _loc5[_loc7], _loc2[_loc7], _loc4);
        } // end of for...in
        updateAfterEvent();
        intObj.path[intObj.method](intObj.clip, _loc3);
        if (intObj.count++ >= intObj.totalInts)
        {
            com.oop.managers.IntervalManager.clearInterval(intObj.clip, "interval" + intObj.method);
        } // end if
    } // End of the function
    function tween(clip, prop, startValue, destValue, time, easeClass, easeFunction, intervalTime)
    {
        clip[prop] = startValue;
        var _loc2 = new Object();
        _loc2.interval = "interval" + prop;
        _loc2.count = 1;
        time = time || defaultTime;
        _loc2.intervalTime = intervalTime || defaultIntervalTime;
        _loc2.totalInts = Math.floor(time / _loc2.intervalTime);
        _loc2.startProp = startValue;
        _loc2.endProp = destValue;
        _loc2.changeProp = _loc2.endProp - _loc2.startProp;
        _loc2.clip = clip;
        _loc2.prop = prop;
        _loc2.easeFunction = this.getEaseFunction(easeClass, easeFunction);
        com.oop.managers.IntervalManager.setInterval(clip, _loc2.interval, this, "runTween", _loc2.intervalTime, _loc2);
        this.runTween(_loc2);
    } // End of the function
    function runTween(intObj)
    {
        var _loc4 = intObj.startProp;
        var _loc5 = intObj.changeProp;
        var _loc3 = intObj.count;
        var _loc2 = intObj.totalInts;
        intObj.clip[intObj.prop] = intObj.easeFunction(_loc3, _loc4, _loc5, _loc2);
        if (intObj.count++ >= intObj.totalInts)
        {
            com.oop.managers.IntervalManager.clearInterval(intObj.clip, "interval" + intObj.prop);
        } // end if
    } // End of the function
    function stopTweenClip(clip)
    {
        com.oop.managers.IntervalManager.clearIntervalsConnection(clip);
    } // End of the function
    function stopAllTweens(main)
    {
        com.oop.managers.IntervalManager.clearAllIntervals(main);
    } // End of the function
    var defaultIntervalTime = 40;
    var defaultClass = "Circ";
    var defaultFunction = "easeOut";
    var defaultTime = 3000;
} // End of Class
