class SWFAddress
{
    var _value;
    static var _interval, onInit, onChange;
    function SWFAddress()
    {
    } // End of the function
    static function _initialize()
    {
        if (SWFAddress._availability)
        {
            flash.external.ExternalInterface.addCallback("getSWFAddressValue", SWFAddress, function ()
            {
                return (_value);
            });
            flash.external.ExternalInterface.addCallback("setSWFAddressValue", SWFAddress, SWFAddress._setValue);
        } // end if
        if (typeof(_level0.$swfaddress) != "undefined")
        {
            _value = _level0.$swfaddress;
        } // end if
        _interval = setInterval(SWFAddress._check, 10);
        return (true);
    } // End of the function
    static function _check()
    {
        if ((typeof(SWFAddress.onInit) == "function" || typeof(SWFAddress._dispatcher.__q_init) != "undefined") && !SWFAddress._init)
        {
            SWFAddress._setValueInit(SWFAddress._getValue());
            _init = true;
        } // end if
        if (typeof(SWFAddress.onChange) == "function" || typeof(SWFAddress._dispatcher.__q_change) != "undefined")
        {
            clearInterval(SWFAddress._interval);
            _init = true;
            SWFAddress._setValueInit(SWFAddress._getValue());
        } // end if
    } // End of the function
    static function _strictCheck(value, force)
    {
        if (SWFAddress.getStrict())
        {
            if (force)
            {
                if (value.substr(0, 1) != "/")
                {
                    value = "/" + value;
                } // end if
            }
            else if (value == "")
            {
                value = "/";
            } // end if
        } // end else if
        return (value);
    } // End of the function
    static function _getValue()
    {
        var _loc1;
        var _loc2 = "null";
        if (SWFAddress._availability)
        {
            _loc1 = String(flash.external.ExternalInterface.call("SWFAddress.getValue"));
            _loc2 = String(flash.external.ExternalInterface.call("SWFAddress.getId"));
        } // end if
        if (_loc2 == "undefined" || _loc2 == "null" || !SWFAddress._availability)
        {
            _loc1 = SWFAddress._value;
        }
        else if (_loc1 == "undefined" || _loc1 == "null")
        {
            _loc1 = "";
        } // end else if
        return (SWFAddress._strictCheck(_loc1 || "", false));
    } // End of the function
    static function _setValueInit(value)
    {
        _value = value;
        if (!SWFAddress._init)
        {
            SWFAddress._dispatchEvent("init");
        }
        else
        {
            SWFAddress._dispatchEvent("change");
        } // end else if
    } // End of the function
    static function _setValue(value)
    {
        if (value == "undefined" || value == "null")
        {
            value = "";
        } // end if
        if (SWFAddress._value == value && SWFAddress._init)
        {
            return;
        } // end if
        _value = value;
        if (!SWFAddress._init)
        {
            _init = true;
            if (typeof(SWFAddress.onInit) == "function" || typeof(SWFAddress._dispatcher.__q_init) != "undefined")
            {
                SWFAddress._dispatchEvent("init");
            } // end if
        } // end if
        SWFAddress._dispatchEvent("change");
    } // End of the function
    static function _dispatchEvent(type)
    {
        if (typeof(SWFAddress._dispatcher["__q_" + type]) != "undefined")
        {
            SWFAddress._dispatcher.dispatchEvent(new SWFAddressEvent(type));
        } // end if
        type = type.substr(0, 1).toUpperCase() + type.substring(1);
        if (typeof(SWFAddress["on" + type]) == "function")
        {
            SWFAddress["on" + type]();
        } // end if
    } // End of the function
    static function toString()
    {
        return ("[class SWFAddress]");
    } // End of the function
    static function back()
    {
        if (SWFAddress._availability)
        {
            flash.external.ExternalInterface.call("SWFAddress.back");
        } // end if
    } // End of the function
    static function forward()
    {
        if (SWFAddress._availability)
        {
            flash.external.ExternalInterface.call("SWFAddress.forward");
        } // end if
    } // End of the function
    static function go(delta)
    {
        if (SWFAddress._availability)
        {
            flash.external.ExternalInterface.call("SWFAddress.go", delta);
        } // end if
    } // End of the function
    static function href(url, target)
    {
        target = typeof(target) != "undefined" ? (target) : ("_self");
        if (SWFAddress._availability && System.capabilities.playerType == "ActiveX")
        {
            flash.external.ExternalInterface.call("SWFAddress.href", url, target);
            return;
        } // end if
        getURL(url, target);
    } // End of the function
    static function popup(url, name, options, handler)
    {
        name = typeof(name) != "undefined" ? (name) : ("popup");
        options = typeof(options) != "undefined" ? (options) : ("");
        handler = typeof(handler) != "undefined" ? (handler) : ("");
        if (SWFAddress._availability && System.capabilities.playerType == "ActiveX")
        {
            flash.external.ExternalInterface.call("SWFAddress.popup", url, name, options, handler);
            return;
        } // end if
        getURL("javascript:popup=window.open(\"" + url + "\",\"" + name + "\"," + options + ");" + handler, "");
    } // End of the function
    static function addEventListener(type, listener)
    {
        SWFAddress._dispatcher.addEventListener(type, listener);
    } // End of the function
    static function removeEventListener(type, listener)
    {
        SWFAddress._dispatcher.removeEventListener(type, listener);
    } // End of the function
    static function dispatchEvent(event)
    {
        SWFAddress._dispatcher.dispatchEvent(event);
    } // End of the function
    static function hasEventListener(type)
    {
        return (typeof(SWFAddress._dispatcher["__q_" + type]) != "undefined");
    } // End of the function
    static function getBaseURL()
    {
        var _loc1 = "null";
        if (SWFAddress._availability)
        {
            _loc1 = String(flash.external.ExternalInterface.call("SWFAddress.getBaseURL"));
        } // end if
        return (_loc1 == "undefined" || _loc1 == "null" || !SWFAddress._availability ? ("") : (_loc1));
    } // End of the function
    static function getStrict()
    {
        var _loc1 = "null";
        if (SWFAddress._availability)
        {
            _loc1 = String(flash.external.ExternalInterface.call("SWFAddress.getStrict"));
        } // end if
        return (_loc1 == "null" || _loc1 == "undefined" ? (SWFAddress._strict) : (_loc1 == "true"));
    } // End of the function
    static function setStrict(strict)
    {
        if (SWFAddress._availability)
        {
            flash.external.ExternalInterface.call("SWFAddress.setStrict", strict);
        } // end if
        _strict = strict;
    } // End of the function
    static function getHistory()
    {
        return (Boolean(SWFAddress._availability ? (flash.external.ExternalInterface.call("SWFAddress.getHistory")) : (false)));
    } // End of the function
    static function setHistory(history)
    {
        if (SWFAddress._availability)
        {
            flash.external.ExternalInterface.call("SWFAddress.setHistory", history);
        } // end if
    } // End of the function
    static function getTracker()
    {
        return (SWFAddress._availability ? (String(flash.external.ExternalInterface.call("SWFAddress.getTracker"))) : (""));
    } // End of the function
    static function setTracker(tracker)
    {
        if (SWFAddress._availability)
        {
            flash.external.ExternalInterface.call("SWFAddress.setTracker", tracker);
        } // end if
    } // End of the function
    static function getTitle()
    {
        var _loc1 = SWFAddress._availability ? (String(flash.external.ExternalInterface.call("SWFAddress.getTitle"))) : ("");
        if (_loc1 == "undefined" || _loc1 == "null")
        {
            _loc1 = "";
        } // end if
        return (_loc1);
    } // End of the function
    static function setTitle(title)
    {
        if (SWFAddress._availability)
        {
            flash.external.ExternalInterface.call("SWFAddress.setTitle", title);
        } // end if
    } // End of the function
    static function getStatus()
    {
        var _loc1 = SWFAddress._availability ? (String(flash.external.ExternalInterface.call("SWFAddress.getStatus"))) : ("");
        if (_loc1 == "undefined" || _loc1 == "null")
        {
            _loc1 = "";
        } // end if
        return (_loc1);
    } // End of the function
    static function setStatus(status)
    {
        if (SWFAddress._availability)
        {
            flash.external.ExternalInterface.call("SWFAddress.setStatus", status);
        } // end if
    } // End of the function
    static function resetStatus()
    {
        if (SWFAddress._availability)
        {
            flash.external.ExternalInterface.call("SWFAddress.resetStatus");
        } // end if
    } // End of the function
    static function getValue()
    {
        return (SWFAddress._strictCheck(SWFAddress._value || "", false));
    } // End of the function
    static function setValue(value)
    {
        if (value == "undefined" || value == "null")
        {
            value = "";
        } // end if
        value = SWFAddress._strictCheck(value, true);
        if (SWFAddress._value == value)
        {
            return;
        } // end if
        _value = value;
        if (SWFAddress._availability)
        {
            flash.external.ExternalInterface.call("SWFAddress.setValue", value);
        } // end if
        SWFAddress._dispatchEvent("change");
    } // End of the function
    static function getPath()
    {
        var _loc1 = SWFAddress.getValue();
        if (_loc1.indexOf("?") != -1)
        {
            return (_loc1.split("?")[0]);
        }
        else
        {
            return (_loc1);
        } // end else if
    } // End of the function
    static function getPathNames()
    {
        var _loc1 = SWFAddress.getPath();
        var _loc2 = _loc1.split("/");
        if (_loc1.substr(0, 1) == "/")
        {
            _loc2.splice(0, 1);
        } // end if
        if (_loc1.substr(_loc1.length - 1, 1) == "/")
        {
            _loc2.splice(_loc2.length - 1, 1);
        } // end if
        return (_loc2);
    } // End of the function
    static function getQueryString()
    {
        var _loc1 = SWFAddress.getValue();
        var _loc2 = _loc1.indexOf("?");
        if (_loc2 != -1 && _loc2 < _loc1.length)
        {
            return (_loc1.substr(_loc2 + 1));
        } // end if
        return ("");
    } // End of the function
    static function getParameter(param)
    {
        var _loc4 = SWFAddress.getValue();
        var _loc6 = _loc4.indexOf("?");
        if (_loc6 != -1)
        {
            _loc4 = _loc4.substr(_loc6 + 1);
            var _loc3 = _loc4.split("&");
            var _loc1;
            var _loc2 = _loc3.length;
            while (_loc2--)
            {
                _loc1 = _loc3[_loc2].split("=");
                if (_loc1[0] == param)
                {
                    return (_loc1[1]);
                } // end if
            } // end while
        } // end if
        return ("");
    } // End of the function
    static function getParameterNames()
    {
        var _loc4 = SWFAddress.getValue();
        var _loc5 = _loc4.indexOf("?");
        var _loc3 = new Array();
        if (_loc5 != -1)
        {
            _loc4 = _loc4.substr(_loc5 + 1);
            if (_loc4 != "" && _loc4.indexOf("=") != -1)
            {
                var _loc2 = _loc4.split("&");
                for (var _loc1 = 0; _loc1 < _loc2.length; ++_loc1)
                {
                    _loc3.push(_loc2[_loc1].split("=")[0]);
                } // end of for
            } // end if
        } // end if
        return (_loc3);
    } // End of the function
    static var _init = false;
    static var _strict = true;
    static var _value = "";
    static var _availability = flash.external.ExternalInterface.available;
    static var _dispatcher = new mx.events.EventDispatcher();
    static var _initializer = SWFAddress._initialize();
} // End of Class
