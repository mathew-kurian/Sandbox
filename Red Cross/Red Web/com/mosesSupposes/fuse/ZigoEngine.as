class com.mosesSupposes.fuse.ZigoEngine
{
    var __zigoID__, oldAddListener;
    static var extensions, updateTime, tweenHolder, instance, updateIntId;
    function ZigoEngine()
    {
    } // End of the function
    static function addListener(handler)
    {
        AsBroadcaster.initialize(com.mosesSupposes.fuse.ZigoEngine);
        com.mosesSupposes.fuse.ZigoEngine.addListener(handler);
    } // End of the function
    static function removeListener(handler)
    {
    } // End of the function
    static function isPlaying()
    {
        return (com.mosesSupposes.fuse.ZigoEngine._playing);
    } // End of the function
    static function simpleSetup(shortcutsClass)
    {
        if (arguments.length > 0)
        {
            com.mosesSupposes.fuse.ZigoEngine.register.apply(com.mosesSupposes.fuse.ZigoEngine, arguments);
        } // end if
        _global.ZigoEngine = com.mosesSupposes.fuse.ZigoEngine;
        if (com.mosesSupposes.fuse.ZigoEngine.extensions.fuse != undefined)
        {
            _global.Fuse = com.mosesSupposes.fuse.ZigoEngine.extensions.fuse;
        } // end if
        if (com.mosesSupposes.fuse.ZigoEngine.extensions.fuseFMP != undefined)
        {
            com.mosesSupposes.fuse.ZigoEngine.extensions.fuseFMP.simpleSetup();
        } // end if
        com.mosesSupposes.fuse.ZigoEngine.initialize(MovieClip.prototype, Button.prototype, TextField.prototype);
        if (com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts == undefined)
        {
            com.mosesSupposes.fuse.FuseKitCommon.error("001");
        } // end if
    } // End of the function
    static function register(classReference)
    {
        if (com.mosesSupposes.fuse.ZigoEngine.extensions == undefined)
        {
            extensions = {};
        } // end if
        var _loc3 = "|fuse|fuseItem|fuseFMP|shortcuts|pennerEasing|";
        for (var _loc4 in arguments)
        {
            var _loc2 = arguments[_loc4].registryKey;
            if (com.mosesSupposes.fuse.ZigoEngine.extensions[_loc2] == undefined && _loc3.indexOf("|" + _loc2 + "|") > -1)
            {
                com.mosesSupposes.fuse.ZigoEngine.extensions[_loc2] = arguments[_loc4];
                if (_loc2 == "fuseFMP" || _loc2 == "shortcuts")
                {
                    Object(com.mosesSupposes.fuse.ZigoEngine.extensions[_loc2]).initialize();
                } // end if
            } // end if
        } // end of for...in
    } // End of the function
    static function initialize(target)
    {
        if (arguments.length > 0)
        {
            com.mosesSupposes.fuse.ZigoEngine.initializeTargets.apply(com.mosesSupposes.fuse.ZigoEngine, arguments);
            if (com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts != undefined)
            {
                com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts.addShortcutsTo.apply(com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts, arguments);
            } // end if
        } // end if
    } // End of the function
    static function deinitialize(target)
    {
        if (arguments.length == 0 || target == null)
        {
            arguments.push(MovieClip.prototype, Button.prototype, TextField.prototype);
        } // end if
        com.mosesSupposes.fuse.ZigoEngine.deinitializeTargets.apply(com.mosesSupposes.fuse.ZigoEngine, arguments);
        if (com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts != undefined)
        {
            com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts.removeShortcutsFrom.apply(com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts, arguments);
        } // end if
    } // End of the function
    static function getUpdateInterval()
    {
        return (com.mosesSupposes.fuse.ZigoEngine.updateTime);
    } // End of the function
    static function setUpdateInterval(time)
    {
        if (com.mosesSupposes.fuse.ZigoEngine._playing)
        {
            com.mosesSupposes.fuse.ZigoEngine.setup(true);
            updateTime = time;
            com.mosesSupposes.fuse.ZigoEngine.setup();
        }
        else
        {
            updateTime = time;
        } // end else if
    } // End of the function
    static function getControllerDepth()
    {
        return (com.mosesSupposes.fuse.ZigoEngine.tweenHolder.getDepth());
    } // End of the function
    static function setControllerDepth(depth)
    {
        if (depth == null || _global.isNaN(depth) == true)
        {
            depth = 6789;
        } // end if
        if (Object(com.mosesSupposes.fuse.ZigoEngine.tweenHolder).proof != null)
        {
            com.mosesSupposes.fuse.ZigoEngine.tweenHolder.swapDepths(depth);
        }
        else
        {
            tweenHolder = _root.createEmptyMovieClip("ZigoEnginePulse", depth);
        } // end else if
    } // End of the function
    static function doShortcut(targets, methodName)
    {
        if (com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts == undefined)
        {
            if (com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL > 0)
            {
                com.mosesSupposes.fuse.FuseKitCommon.error("002");
            } // end if
            return (null);
        } // end if
        return (com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts.doShortcut.apply(com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts, arguments));
    } // End of the function
    static function doTween(targets, props, endvals, seconds, ease, delay, callback)
    {
        if (com.mosesSupposes.fuse.ZigoEngine.extensions.fuse.addBuildItem(arguments) == true)
        {
            return (null);
        } // end if
        if (com.mosesSupposes.fuse.ZigoEngine.instance == undefined || Object(com.mosesSupposes.fuse.ZigoEngine.tweenHolder).proof == undefined && com.mosesSupposes.fuse.ZigoEngine.updateTime == undefined)
        {
            if (MovieClip.prototype.tween != null && typeof(_global.$tweenManager) == "object")
            {
                com.mosesSupposes.fuse.FuseKitCommon.error("003");
            } // end if
            instance = new com.mosesSupposes.fuse.ZManager();
            _playing = false;
        } // end if
        var _loc4 = com.mosesSupposes.fuse.ZigoEngine.instance.paramsObj(targets, props, endvals);
        var _loc7 = _loc4.tg[0] == null || _loc4.tg.length == 0 ? (undefined) : (_loc4.tg);
        if (_loc4.pa == undefined || _loc7 == undefined || arguments.length < 3)
        {
            if (com.mosesSupposes.fuse.ZigoEngine.extensions.fuseItem != null && typeof(_loc7[0]) == "object")
            {
                return (com.mosesSupposes.fuse.ZigoEngine.extensions.fuseItem.doTween(arguments[0]));
            } // end if
            if (com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL > 0)
            {
                if (arguments.length < 3)
                {
                    com.mosesSupposes.fuse.FuseKitCommon.error("004", String(arguments.length));
                }
                else
                {
                    com.mosesSupposes.fuse.FuseKitCommon.error("005", _loc7.toString(), _loc4.pa.toString());
                } // end if
            } // end else if
            return (null);
        } // end if
        if (com.mosesSupposes.fuse.ZigoEngine._playing != true)
        {
            com.mosesSupposes.fuse.ZigoEngine.setup();
        } // end if
        if (seconds == null || _global.isNaN(seconds) == true)
        {
            seconds = com.mosesSupposes.fuse.ZigoEngine.DURATION || 1;
        }
        else if (seconds < 1.000000E-002)
        {
            seconds = 0;
        } // end else if
        if (delay < 1.000000E-002 || delay == null || _global.isNaN(delay) == true)
        {
            delay = 0;
        } // end if
        var _loc12 = com.mosesSupposes.fuse.ZigoEngine.parseCallback(callback, _loc7);
        var _loc9;
        if (typeof(ease) == "function")
        {
            if (typeof(Function(ease).call(null, 1, 1, 1, 1)) == "number")
            {
                _loc9 = Function(ease);
            }
            else if (com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL > 0)
            {
                com.mosesSupposes.fuse.FuseKitCommon.error("014", ease);
            } // end else if
        }
        else if (ease == null || ease == "")
        {
            if (com.mosesSupposes.fuse.ZigoEngine.EASING instanceof Function)
            {
                _loc9 = Function(com.mosesSupposes.fuse.ZigoEngine.EASING);
            }
            else if (com.mosesSupposes.fuse.ZigoEngine.extensions.pennerEasing != undefined)
            {
                ease = com.mosesSupposes.fuse.ZigoEngine.EASING;
            } // end else if
        } // end else if
        if (typeof(ease) == "string" && ease != "")
        {
            if (com.mosesSupposes.fuse.ZigoEngine.extensions.pennerEasing[ease] != undefined)
            {
                _loc9 = com.mosesSupposes.fuse.ZigoEngine.extensions.pennerEasing[ease];
            }
            else if (com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL > 0)
            {
                com.mosesSupposes.fuse.FuseKitCommon.error("006", ease);
            } // end else if
        }
        else if (typeof(ease) == "object" && ease.ease != null && ease.pts != null)
        {
            _loc9 = Function(ease.ease);
            _loc12.extra1 = ease.pts;
        } // end else if
        if (typeof(_loc9) != "function")
        {
            _loc9 = function (t, b, c, d)
            {
                t = t / d - 1;
                return (c * ((t) * t * t * t * t + 1) + b);
            };
        } // end if
        var _loc6 = "";
        for (var _loc13 in _loc7)
        {
            var _loc3 = _loc7[_loc13];
            if (_loc3.__zigoID__ == null)
            {
                com.mosesSupposes.fuse.ZigoEngine.initializeTargets(_loc3);
            }
            else if (com.mosesSupposes.fuse.ZigoEngine.instance.getStatus("locked", _loc3) == true)
            {
                if (com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL > 0)
                {
                    com.mosesSupposes.fuse.FuseKitCommon.error("007", _loc3._name != undefined ? (_loc3._name) : (_loc3.toString()), _loc4.pa.toString());
                } // end if
                continue;
            } // end else if
            var _loc5 = com.mosesSupposes.fuse.ZigoEngine.instance.addTween(_loc3, _loc4.pa, _loc4.va, seconds, _loc9, delay, _loc12);
            _loc6 = (_loc5 == null ? ("|") : (_loc5 + "|")) + _loc6;
        } // end of for...in
        _loc6 = _loc6.slice(0, -1);
        return (_loc6 == "" || _loc6 == "|" ? (null) : (_loc6));
    } // End of the function
    static function removeTween(targs, props)
    {
        com.mosesSupposes.fuse.ZigoEngine.instance.removeTween(targs, props);
    } // End of the function
    static function isTweening(targ, prop)
    {
        return (Boolean(com.mosesSupposes.fuse.ZigoEngine.instance.getStatus("active", targ, prop)));
    } // End of the function
    static function getTweens(targ)
    {
        return (Number(com.mosesSupposes.fuse.ZigoEngine.instance.getStatus("count", targ)));
    } // End of the function
    static function lockTween(targ, setLocked)
    {
        com.mosesSupposes.fuse.ZigoEngine.instance.alterTweens("lock", targ, setLocked);
    } // End of the function
    static function isTweenLocked(targ)
    {
        return (Boolean(com.mosesSupposes.fuse.ZigoEngine.instance.getStatus("locked", targ)));
    } // End of the function
    static function ffTween(targs, props)
    {
        com.mosesSupposes.fuse.ZigoEngine.instance.alterTweens("ff", targs, props);
    } // End of the function
    static function rewTween(targs, props, pauseFlag, suppressStartEvents)
    {
        com.mosesSupposes.fuse.ZigoEngine.instance.alterTweens("rewind", targs, props, pauseFlag, suppressStartEvents);
    } // End of the function
    static function isTweenPaused(targ, prop)
    {
        return (Boolean(com.mosesSupposes.fuse.ZigoEngine.instance.getStatus("paused", targ, prop)));
    } // End of the function
    static function pauseTween(targs, props)
    {
        com.mosesSupposes.fuse.ZigoEngine.instance.alterTweens("pause", targs, props);
    } // End of the function
    static function unpauseTween(targs, props)
    {
        com.mosesSupposes.fuse.ZigoEngine.instance.alterTweens("unpause", targs, props);
    } // End of the function
    static function resumeTween(targs, props)
    {
        com.mosesSupposes.fuse.ZigoEngine.instance.alterTweens("unpause", targs, props);
    } // End of the function
    static function setColorByKey(targetObj, type, amt, rgb)
    {
        new Color(targetObj).setTransform(com.mosesSupposes.fuse.ZigoEngine.getColorTransObj(type, amt, rgb));
    } // End of the function
    static function getColorTransObj(type, amt, rgb)
    {
        switch (type)
        {
            case "brightness":
            {
                var _loc3 = 100 - Math.abs(amt);
                var _loc4 = amt > 0 ? (255 * (amt / 100)) : (0);
                return ({ra: _loc3, rb: _loc4, ga: _loc3, gb: _loc4, ba: _loc3, bb: _loc4});
            } 
            case "brightOffset":
            {
                return ({ra: 100, rb: 255 * (amt / 100), ga: 100, gb: 255 * (amt / 100), ba: 100, bb: 255 * (amt / 100)});
            } 
            case "contrast":
            {
                return ({ra: amt, rb: 128 - 1.280000E+000 * amt, ga: amt, gb: 128 - 1.280000E+000 * amt, ba: amt, bb: 128 - 1.280000E+000 * amt});
            } 
            case "invertColor":
            {
                return ({ra: 100 - 2 * amt, rb: amt * 2.550000E+000, ga: 100 - 2 * amt, gb: amt * 2.550000E+000, ba: 100 - 2 * amt, bb: amt * 2.550000E+000});
            } 
            case "tint":
            {
                if (rgb != null)
                {
                    var _loc5;
                    if (typeof(rgb) == "string")
                    {
                        if (rgb.charAt(0) == "#")
                        {
                            rgb = rgb.slice(1);
                        } // end if
                        rgb = rgb.charAt(1).toLowerCase() != "x" ? ("0x" + rgb) : (rgb);
                    } // end if
                    _loc5 = Number(rgb);
                    return ({ra: 100 - amt, rb: (_loc5 >> 16) * (amt / 100), ga: 100 - amt, gb: (_loc5 >> 8 & 255) * (amt / 100), ba: 100 - amt, bb: (_loc5 & 255) * (amt / 100)});
                } // end if
            } 
        } // End of switch
        return ({rb: 0, ra: 100, gb: 0, ga: 100, bb: 0, ba: 100});
    } // End of the function
    static function getColorKeysObj(targOrTransObj)
    {
        var _loc1 = targOrTransObj.ra != undefined ? (targOrTransObj) : (new Color(targOrTransObj).getTransform());
        var _loc3 = {};
        var _loc7 = _loc1.ra == _loc1.ga && _loc1.ga == _loc1.ba;
        var _loc9 = _loc1.rb == _loc1.gb && _loc1.gb == _loc1.bb;
        var _loc5 = _loc7 == true ? (100 - _loc1.ra) : (0);
        if (_loc5 != 0)
        {
            var _loc6 = 100 / _loc5;
            _loc3.tint = _loc1.rb * _loc6 << 16 | _loc1.gb * _loc6 << 8 | _loc1.bb * _loc6;
            _loc3.tintPercent = _loc5;
            var _loc2 = _loc3.tint.toString(16);
            var _loc4 = 6 - _loc2.length;
            while (_loc4-- > 0)
            {
                _loc2 = "0" + _loc2;
            } // end while
            _loc3.tintString = "0x" + _loc2.toUpperCase();
        } // end if
        if (_loc7 == true && _loc9 == true)
        {
            if (_loc1.ra < 0)
            {
                _loc3.invertColor = _loc1.rb * 3.921569E-001;
            }
            else if (_loc1.ra == 100 && _loc1.rb != 0)
            {
                _loc3.brightOffset = _loc1.rb * 3.921569E-001;
            } // end else if
            if (_loc1.ra != 100)
            {
                if (_loc1.rb == 0 || _loc1.rb != 0 && 255 * ((100 - _loc1.ra) / 100) - _loc1.rb <= 1)
                {
                    _loc3.brightness = _loc1.rb != 0 ? (100 - _loc1.ra) : (_loc1.ra - 100);
                } // end if
                if (128 - 1.280000E+000 * _loc1.ra - _loc1.rb <= 1)
                {
                    _loc3.contrast = _loc1.ra;
                } // end if
            } // end if
        } // end if
        return (_loc3);
    } // End of the function
    static function initializeTargets()
    {
        for (var _loc5 in arguments)
        {
            var _loc4 = arguments[_loc5];
            if (_loc4 == MovieClip.prototype || _loc4 == Button.prototype || _loc4 == TextField.prototype || _loc4 == Object.prototype)
            {
                if (_loc4.oldAddListener == undefined)
                {
                    if (_loc4 == TextField.prototype)
                    {
                        _loc4.oldAddListener = _loc4.addListener;
                        _global.ASSetPropFlags(_loc4, "oldAddListener", 7, 1);
                    } // end if
                    _loc4.addListener = function (o)
                    {
                        if (__zigoID__ == undefined)
                        {
                            com.mosesSupposes.fuse.ZigoEngine.initializeTargets(this);
                        } // end if
                        if (this instanceof TextField)
                        {
                            Function(oldAddListener).call(this, o);
                        }
                        else
                        {
                            this.addListener(o);
                        } // end else if
                    };
                    if (_loc4 == MovieClip.prototype)
                    {
                        _global.ASSetPropFlags(_loc4, "addListener", 7, 1);
                    } // end if
                } // end if
                continue;
            } // end if
            if (_loc4.__zigoID__ == undefined)
            {
                _loc4.__zigoID__ = com.mosesSupposes.fuse.ZigoEngine.zigoIDs;
                _global.ASSetPropFlags(_loc4, "__zigoID__", 7, 1);
                zigoIDs = ++com.mosesSupposes.fuse.ZigoEngine.zigoIDs;
                if (_loc4._listeners == null || _loc4.addListener == null)
                {
                    AsBroadcaster.initialize(_loc4);
                } // end if
            } // end if
        } // end of for...in
    } // End of the function
    static function deinitializeTargets()
    {
        for (var _loc4 in arguments)
        {
            var _loc3 = arguments[_loc4];
            if (_loc3.__zigoID__ != undefined)
            {
                _global.ASSetPropFlags(_loc3, "__zigoID__,_listeners,broadcastMessage,addListener,removeListener", 0, 2);
                delete _loc3.__zigoID__;
                delete _loc3._listeners;
                delete _loc3.broadcastMessage;
                delete _loc3.addListener;
                delete _loc3.removeListener;
            } // end if
            if (_loc3.oldAddListener != undefined)
            {
                _global.ASSetPropFlags(_loc3, "oldAddListener", 0, 2);
                _loc3.addListener = _loc3.oldAddListener;
                delete _loc3.oldAddListener;
            } // end if
        } // end of for...in
    } // End of the function
    static function __mgrRelay(inst, method, args)
    {
        if (inst == com.mosesSupposes.fuse.ZigoEngine.instance)
        {
            Function(com.mosesSupposes.fuse.ZigoEngine[method]).apply(com.mosesSupposes.fuse.ZigoEngine, args);
        } // end if
    } // End of the function
    static function setup(deinitFlag)
    {
        if (deinitFlag == true)
        {
            _playing = false;
            clearInterval(com.mosesSupposes.fuse.ZigoEngine.updateIntId);
            delete com.mosesSupposes.fuse.ZigoEngine.tweenHolder.onEnterFrame;
            return;
        } // end if
        com.mosesSupposes.fuse.ZigoEngine.instance.cleanUp();
        clearInterval(com.mosesSupposes.fuse.ZigoEngine.updateIntId);
        delete com.mosesSupposes.fuse.ZigoEngine.updateIntId;
        if (com.mosesSupposes.fuse.ZigoEngine.updateTime != null && com.mosesSupposes.fuse.ZigoEngine.updateTime > 0)
        {
            updateIntId = setInterval(com.mosesSupposes.fuse.ZigoEngine.instance, "update", com.mosesSupposes.fuse.ZigoEngine.updateTime);
        }
        else
        {
            if (Object(com.mosesSupposes.fuse.ZigoEngine.tweenHolder).proof == null)
            {
                com.mosesSupposes.fuse.ZigoEngine.setControllerDepth(6789);
                Object(com.mosesSupposes.fuse.ZigoEngine.tweenHolder).proof = 1;
            } // end if
            var _inst = com.mosesSupposes.fuse.ZigoEngine.instance;
            com.mosesSupposes.fuse.ZigoEngine.tweenHolder.onEnterFrame = function ()
            {
                _inst.update.call(_inst);
            };
        } // end else if
        _playing = true;
        com.mosesSupposes.fuse.ZigoEngine.instance.now = getTimer();
    } // End of the function
    static function parseCallback(callback, targets)
    {
        var validCBs = {skipLevel: com.mosesSupposes.fuse.ZigoEngine.SKIP_LEVEL, cycles: 1};
        if (callback.skipLevel != undefined && typeof(callback.skipLevel) == "number" && callback.skipLevel != com.mosesSupposes.fuse.ZigoEngine.SKIP_LEVEL)
        {
            if (callback.skipLevel >= 0 && callback.skipLevel <= 2)
            {
                validCBs.skipLevel = callback.skipLevel;
            } // end if
        } // end if
        if (callback.cycles != undefined)
        {
            if (typeof(callback.cycles) == "number" && callback.cycles > -1)
            {
                validCBs.cycles = callback.cycles;
            }
            else if (callback.cycles.toUpperCase() == "LOOP")
            {
                validCBs.cycles = 0;
            } // end if
        } // end else if
        if (callback.extra1 != undefined)
        {
            validCBs.extra1 = callback.extra1;
        } // end if
        if (callback.extra2 != undefined)
        {
            validCBs.extra2 = callback.extra2;
        } // end if
        if (callback == undefined)
        {
            return (validCBs);
        } // end if
        var cbErrors = [];
        var ezf;
        if (typeof(callback) == "string")
        {
            ezf = String(callback);
        }
        else if (typeof(callback.easyfunc) == "string")
        {
            ezf = callback.easyfunc;
        } // end else if
        if (ezf != undefined && ezf.indexOf("(") > -1 && ezf.indexOf(")") > -1)
        {
            if (com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts != undefined)
            {
                callback = com.mosesSupposes.fuse.ZigoEngine.extensions.shortcuts.parseStringTypeCallback(ezf);
            }
            else if (com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL > 0)
            {
                com.mosesSupposes.fuse.FuseKitCommon.error("008");
            } // end else if
        }
        else if (typeof(callback) == "function" || typeof(callback) == "string")
        {
            callback = {func: callback};
        } // end else if
        for (var i in callback)
        {
            var fi = i.toLowerCase().indexOf("func");
            if (fi > -1)
            {
                var prefix = i.slice(0, fi);
                var func = callback[i];
                var args = callback[prefix + "args"];
                var scope = callback[prefix + "scope"];
                if (typeof(func) == "string" && scope[func] == undefined)
                {
                    for (var j in targets)
                    {
                        var targ = targets[j];
                        if (typeof(targ[func]) == "function")
                        {
                            scope = targ;
                            break;
                        } // end if
                        if (typeof(targ._parent[func]) == "function")
                        {
                            scope = targ._parent;
                            break;
                        } // end if
                    } // end of for...in
                    if (scope == undefined && _level0[func] != undefined)
                    {
                        scope = _level0;
                    } // end if
                    if (scope == undefined && _global[func] != undefined)
                    {
                        scope = _global;
                    } // end if
                } // end if
                if (typeof(func) != "function")
                {
                    if (typeof(scope[String(func)]) == "function")
                    {
                        func = scope[String(func)];
                    }
                    else
                    {
                        func = String(func);
                    } // end if
                } // end else if
                if (func == undefined)
                {
                    cbErrors.push(String(i + ":" + (typeof(callback[i]) == "string" ? ("\"" + callback[i] + "\"") : (callback[i])) + "/" + prefix + "scope:" + scope));
                }
                else
                {
                    if (args != undefined && !(args instanceof Array))
                    {
                        args = [args];
                    } // end if
                    if (prefix == "")
                    {
                        prefix = "end";
                    } // end if
                    cbTicker = ++com.mosesSupposes.fuse.ZigoEngine.cbTicker;
                    validCBs[prefix] = {s: scope, f: func, a: args, id: com.mosesSupposes.fuse.ZigoEngine.cbTicker};
                    if (prefix == "start")
                    {
                        validCBs.start.fired = false;
                    } // end if
                } // end else if
                continue;
            } // end if
            if (com.mosesSupposes.fuse.FuseKitCommon._cbprops().indexOf("|" + i + "|") == -1)
            {
                com.mosesSupposes.fuse.FuseKitCommon.error("009", i);
            } // end if
        } // end of for...in
        if (cbErrors.length > 0 && com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL > 0)
        {
            if (com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL > 0)
            {
                com.mosesSupposes.fuse.FuseKitCommon.error("010", cbErrors.length, cbErrors.toString());
            } // end if
        } // end if
        return (validCBs);
    } // End of the function
    static var VERSION = com.mosesSupposes.fuse.FuseKitCommon.VERSION + ", ZigoEngine based on concepts by Ladislav Zigo, laco.wz.cz/tween";
    static var EASING = "easeOutQuint";
    static var DURATION = 1;
    static var ROUND_RESULTS = false;
    static var OUTPUT_LEVEL = 1;
    static var AUTOSTOP = false;
    static var SKIP_LEVEL = 0;
    static var _playing = false;
    static var zigoIDs = 0;
    static var cbTicker = 0;
} // End of Class
