class com.mosesSupposes.fuse.Shortcuts
{
    var _visible, __fadeOutEnd, onTweenInterrupt, __owner, addListener, _width, _height, _xscale, _yscale, _currentframe, gotoAndStop, _totalframes;
    function Shortcuts()
    {
    } // End of the function
    static function initialize()
    {
        if (com.mosesSupposes.fuse.Shortcuts.shortcuts == null)
        {
            com.mosesSupposes.fuse.Shortcuts.initShortcuts();
        } // end if
    } // End of the function
    static function doShortcut(obj, methodName)
    {
        com.mosesSupposes.fuse.Shortcuts.initialize();
        var _loc5 = com.mosesSupposes.fuse.Shortcuts.shortcuts[methodName];
        if (_loc5 == undefined)
        {
            if (typeof(obj) == "movieclip")
            {
                _loc5 = com.mosesSupposes.fuse.Shortcuts.mcshortcuts[methodName];
            } // end if
        } // end if
        if (_loc5 == undefined)
        {
            return (null);
        } // end if
        obj = arguments.shift();
        methodName = String(arguments.shift());
        if (!(obj instanceof Array))
        {
            obj = [obj];
        } // end if
        var _loc3 = "";
        for (var _loc6 in obj)
        {
            var _loc2 = String(_loc5.apply(obj[_loc6], arguments));
            if (_loc2 != null && _loc2.length > 0)
            {
                if (_loc3.length > 0)
                {
                    _loc3 = _loc2 + "|" + _loc3;
                    continue;
                } // end if
                _loc3 = _loc2;
            } // end if
        } // end of for...in
        return (_loc3 == "" ? (null) : (_loc3));
    } // End of the function
    static function addShortcutsTo()
    {
        com.mosesSupposes.fuse.Shortcuts.initialize();
        var _loc5 = function (o, so)
        {
            for (var _loc5 in so)
            {
                var _loc2 = so[_loc5];
                if (_loc2.getter || _loc2.setter)
                {
                    o.addProperty(_loc5, _loc2.getter, _loc2.setter);
                    _global.ASSetPropFlags(o, _loc5, 3, 1);
                    continue;
                } // end if
                o[_loc5] = _loc2;
                _global.ASSetPropFlags(o, _loc5, 7, 1);
            } // end of for...in
        };
        for (var _loc7 in arguments)
        {
            var _loc4 = arguments[_loc7];
            if (_loc4 == MovieClip.prototype || typeof(_loc4) == "movieclip")
            {
                _loc5(_loc4, com.mosesSupposes.fuse.Shortcuts.mcshortcuts);
            } // end if
            _loc5(_loc4, com.mosesSupposes.fuse.Shortcuts.shortcuts);
        } // end of for...in
    } // End of the function
    static function removeShortcutsFrom()
    {
        com.mosesSupposes.fuse.Shortcuts.initialize();
        var _loc5 = function (o, so)
        {
            for (var _loc5 in so)
            {
                _global.ASSetPropFlags(o, _loc5, 0, 2);
                var _loc2 = so[_loc5];
                if (_loc2.getter || _loc2.setter)
                {
                    o.addProperty(_loc5, null, null);
                } // end if
                delete o[_loc5];
            } // end of for...in
        };
        for (var _loc7 in arguments)
        {
            var _loc3 = arguments[_loc7];
            if (_loc3 == MovieClip.prototype || typeof(_loc3) == "movieclip")
            {
                _loc5(_loc3, com.mosesSupposes.fuse.Shortcuts.mcshortcuts);
            } // end if
            _loc5(_loc3, com.mosesSupposes.fuse.Shortcuts.shortcuts);
        } // end of for...in
    } // End of the function
    static function parseStringTypeCallback(callbackStr)
    {
        var evaluate = function (val)
        {
            var first = val.charAt(0);
            if (first == val.slice(-1) && (first == "\"" || first == "\'"))
            {
                return (val.slice(1, -1));
            } // end if
            if (val == "true")
            {
                return (Object(true));
            } // end if
            if (val == "false")
            {
                return (Object(false));
            } // end if
            if (val == "null")
            {
                return (Object(null));
            } // end if
            if (_global.isNaN(Number(val)) == false)
            {
                return (Object(Number(val)));
            } // end if
            return (Object(eval(val)));
        };
        var trimWhite = function (str)
        {
            while (str.charAt(0) == " ")
            {
                str = str.slice(1);
            } // end while
            while (str.slice(-1) == " ")
            {
                str = str.slice(0, -1);
            } // end while
            return (str);
        };
        var evaluateList = function (list)
        {
            var _loc11 = [];
            for (var _loc4 = 0; _loc4 < list.length; ++_loc4)
            {
                var _loc3 = list[_loc4];
                _loc3 = trimWhite(_loc3);
                var _loc5 = _loc3.charAt(0) == "{" && (_loc3.indexOf("}") > -1 || _loc3.indexOf(":") > -1);
                var _loc10 = _loc3.charAt(0) == "[";
                if ((_loc5 || _loc10) == true)
                {
                    var _loc6 = _loc5 == true ? ({}) : ([]);
                    for (var _loc2 = _loc4; _loc2 < list.length; ++_loc2)
                    {
                        if (_loc2 == _loc4)
                        {
                            _loc3 = _loc3.slice(1);
                        } // end if
                        var _loc1;
                        var _loc8 = _loc1.slice(-1) == (_loc5 == true ? ("}") : ("]")) || _loc2 == list.length - 1;
                        if (_loc8 == true)
                        {
                            _loc1 = _loc1.slice(0, -1);
                        } // end if
                        if (_loc5 == true && _loc1.indexOf(":") > -1)
                        {
                            var _loc7 = _loc1.split(":");
                            _loc6[trimWhite(_loc7[0])] = evaluate(trimWhite(_loc7[1]));
                        }
                        else if (_loc10 == true)
                        {
                            _loc6.push(evaluate(trimWhite(_loc1)));
                        } // end else if
                        if (_loc8 == true)
                        {
                            _loc11.push(_loc6);
                            _loc4 = _loc2;
                            break;
                        } // end if
                    } // end of for
                    continue;
                } // end if
                _loc11.push(evaluate(trimWhite(_loc3)));
            } // end of for
            return (_loc11);
        };
        var parts = callbackStr.split("(");
        var p0 = parts[0];
        var p1 = parts[1];
        return ({func: p0.slice(p0.lastIndexOf(".") + 1), scope: p0.slice(0, p0.lastIndexOf(".")), args: evaluateList(p1.slice(0, p1.lastIndexOf(")")).split(","))});
    } // End of the function
    static function initShortcuts()
    {
        shortcuts = new Object();
        var methods = {alphaTo: "_alpha", scaleTo: "_scale", sizeTo: "_size", rotateTo: "_rotation", brightnessTo: "_brightness", brightOffsetTo: "_brightOffset", contrastTo: "_contrast", colorTo: "_tint", tintPercentTo: "_tintPercent", colorResetTo: "_colorReset", invertColorTo: "_invertColor"};
        var _loc4 = _global.com.mosesSupposes.fuse.FuseFMP.getAllShortcuts();
        var _loc6 = {blur: 1, blurX: 1, blurY: 1, strength: 1, shadowAlpha: 1, highlightAlpha: 1, angle: 1, distance: 1, alpha: 1, color: 1};
        for (var _loc9 in _loc4)
        {
            if (_loc6[_loc4[_loc9].split("_")[1]] === 1)
            {
                methods[_loc4[_loc9] + "To"] = _loc4[_loc9];
            } // end if
        } // end of for...in
        var _loc7 = {__resolve: function (name)
        {
            var propName = methods[name];
            return (function ()
            {
                var _loc4 = _global.com.mosesSupposes.fuse.ZigoEngine.doTween.apply(com.mosesSupposes.fuse.ZigoEngine, new Array(this, propName).concat(arguments));
                return (_loc4);
            });
        }};
        var _loc5 = {__resolve: function (name)
        {
            var prop = name.slice(1);
            var _loc3 = {getter: function ()
            {
                return (_global.com.mosesSupposes.fuse.ZigoEngine.getColorKeysObj(this)[prop]);
            }};
            if (prop == "tintString" || prop == "tint")
            {
                _loc3.setter = function (v)
                {
                    _global.com.mosesSupposes.fuse.ZigoEngine.setColorByKey(this, "tint", _global.com.mosesSupposes.fuse.ZigoEngine.getColorKeysObj(this).tintPercent || 100, v);
                };
            }
            else if (prop == "tintPercent")
            {
                _loc3.setter = function (v)
                {
                    _global.com.mosesSupposes.fuse.ZigoEngine.setColorByKey(this, "tint", v, _global.com.mosesSupposes.fuse.ZigoEngine.getColorKeysObj(this).tint);
                };
            }
            else if (prop == "colorReset")
            {
                _loc3.setter = function (v)
                {
                    var _loc3 = _global.com.mosesSupposes.fuse.ZigoEngine.getColorKeysObj(this);
                    _global.com.mosesSupposes.fuse.ZigoEngine.setColorByKey(this, "tint", Math.min(100, Math.max(0, Math.min(_loc3.tintPercent, 100 - v))), _loc3.tint);
                };
            }
            else
            {
                _loc3.setter = function (v)
                {
                    _global.com.mosesSupposes.fuse.ZigoEngine.setColorByKey(this, prop, v);
                };
            } // end else if
            return (_loc3);
        }};
        for (var _loc9 in methods)
        {
            com.mosesSupposes.fuse.Shortcuts.shortcuts[_loc9] = _loc7[_loc9];
            if (_loc9 == "colorTo")
            {
                com.mosesSupposes.fuse.Shortcuts.shortcuts._tintString = _loc5._tintString;
            } // end if
            if (_loc9.indexOf("bright") == 0 || _loc9 == "contrastTo" || _loc9 == "colorTo" || _loc9 == "invertColor" || _loc9 == "tintPercentTo" || _loc9 == "colorResetTo")
            {
                com.mosesSupposes.fuse.Shortcuts.shortcuts[methods[_loc9]] = _loc5[methods[_loc9]];
            } // end if
        } // end of for...in
        com.mosesSupposes.fuse.Shortcuts.shortcuts.tween = function (props, endVals, seconds, ease, delay, callback)
        {
            if (arguments.length == 1 && typeof(props) == "object")
            {
                return (com.mosesSupposes.fuse.ZigoEngine.doTween({target: this, action: props}));
            } // end if
            return (com.mosesSupposes.fuse.ZigoEngine.doTween(this, props, endVals, seconds, ease, delay, callback));
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.removeTween = com.mosesSupposes.fuse.Shortcuts.shortcuts.stopTween = function (props)
        {
            com.mosesSupposes.fuse.ZigoEngine.removeTween(this, props);
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.removeAllTweens = com.mosesSupposes.fuse.Shortcuts.shortcuts.stopAllTweens = function ()
        {
            com.mosesSupposes.fuse.ZigoEngine.removeTween("ALL");
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.isTweening = function (prop)
        {
            return (com.mosesSupposes.fuse.ZigoEngine.isTweening(this, prop));
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.getTweens = function ()
        {
            return (com.mosesSupposes.fuse.ZigoEngine.getTweens(this));
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.lockTween = function ()
        {
            com.mosesSupposes.fuse.ZigoEngine.lockTween(this, true);
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.unlockTween = function ()
        {
            com.mosesSupposes.fuse.ZigoEngine.lockTween(this, false);
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.isTweenLocked = function ()
        {
            return (com.mosesSupposes.fuse.ZigoEngine.isTweenLocked(this));
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.isTweenPaused = function (prop)
        {
            return (com.mosesSupposes.fuse.ZigoEngine.isTweenPaused(this, prop));
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.pauseTween = function (props)
        {
            com.mosesSupposes.fuse.ZigoEngine.pauseTween(this, props);
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.resumeTween = com.mosesSupposes.fuse.Shortcuts.shortcuts.unpauseTween = function (props)
        {
            com.mosesSupposes.fuse.ZigoEngine.unpauseTween(this, props);
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.pauseAllTweens = function ()
        {
            com.mosesSupposes.fuse.ZigoEngine.pauseTween("ALL");
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.resumeAllTweens = com.mosesSupposes.fuse.Shortcuts.shortcuts.unpauseAllTweens = function ()
        {
            com.mosesSupposes.fuse.ZigoEngine.unpauseTween("ALL");
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.ffTween = function (props)
        {
            com.mosesSupposes.fuse.ZigoEngine.ffTween(this, props);
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.rewTween = function (props, suppressStartEvents)
        {
            com.mosesSupposes.fuse.ZigoEngine.rewTween(this, props, false, suppressStartEvents);
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.rewAndPauseTween = function (props, suppressStartEvents)
        {
            com.mosesSupposes.fuse.ZigoEngine.rewTween(this, props, true, suppressStartEvents);
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.fadeIn = function (seconds, ease, delay, callback)
        {
            _visible = true;
            return (com.mosesSupposes.fuse.ZigoEngine.doTween(this, "_alpha", 100, seconds, ease, delay));
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.fadeOut = function (seconds, ease, delay, callback)
        {
            if (__fadeOutEnd == undefined)
            {
                __fadeOutEnd = {__owner: this, onTweenEnd: function (o)
                {
                    this.onTweenInterrupt(o);
                    if (String(o.props.join(",")).indexOf("_alpha") > -1 && __owner._alpha < 1)
                    {
                        o.target._visible = false;
                    } // end if
                }, onTweenInterrupt: function (o)
                {
                    if (o.target == __owner && String(o.props.join(",")).indexOf("_alpha") > -1)
                    {
                        __owner.removeListener(this);
                        com.mosesSupposes.fuse.ZigoEngine.removeListener(this);
                    } // end if
                }};
                _global.ASSetPropFlags(this, "__fadeOutEnd", 7, 1);
            } // end if
            this.addListener(__fadeOutEnd);
            var _loc3 = com.mosesSupposes.fuse.ZigoEngine.doTween(this, "_alpha", 0, seconds, ease, delay, callback);
            com.mosesSupposes.fuse.ZigoEngine.addListener(__fadeOutEnd);
            return (_loc3);
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.bezierTo = function (destX, destY, controlX, controlY, seconds, ease, delay, callback)
        {
            return (com.mosesSupposes.fuse.ZigoEngine.doTween(this, "_bezier_", {x: destX, y: destY, controlX: controlX, controlY: controlY}, seconds, ease, delay, callback));
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.colorTransformTo = function (ra, rb, ga, gb, ba, bb, aa, ab, seconds, ease, delay, callback)
        {
            return (com.mosesSupposes.fuse.ZigoEngine.doTween(this, "_colorTransform", {ra: ra, rb: rb, ga: ga, gb: gb, ba: ba, bb: bb, aa: aa, ab: ab}, seconds, ease, delay, callback));
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.tintTo = function (rgb, percent, seconds, ease, delay, callback)
        {
            var _loc3 = {};
            _loc3.rgb = arguments.shift();
            _loc3.percent = arguments.shift();
            return (com.mosesSupposes.fuse.ZigoEngine.doTween(this, "_tint", {tint: rgb, percent: percent}, seconds, ease, delay, callback));
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts.slideTo = function (destX, destY, seconds, ease, delay, callback)
        {
            return (com.mosesSupposes.fuse.ZigoEngine.doTween(this, "_x,_y", [destX, destY], seconds, ease, delay, callback));
        };
        com.mosesSupposes.fuse.Shortcuts.shortcuts._size = {getter: function ()
        {
            return (_width == _height ? (_width) : (null));
        }, setter: function (v)
        {
            com.mosesSupposes.fuse.ZigoEngine.doTween(this, "_size", v, 0);
        }};
        com.mosesSupposes.fuse.Shortcuts.shortcuts._scale = {getter: function ()
        {
            return (_xscale == _yscale ? (_xscale) : (null));
        }, setter: function (v)
        {
            com.mosesSupposes.fuse.ZigoEngine.doTween(this, "_scale", v, 0);
        }};
        mcshortcuts = new Object();
        com.mosesSupposes.fuse.Shortcuts.mcshortcuts._frame = {getter: function ()
        {
            return (_currentframe);
        }, setter: function (v)
        {
            this.gotoAndStop(Math.round(v));
        }};
        com.mosesSupposes.fuse.Shortcuts.mcshortcuts.frameTo = function (endframe, seconds, ease, delay, callback)
        {
            return (com.mosesSupposes.fuse.ZigoEngine.doTween(this, "_frame", endframe != undefined ? (endframe) : (_totalframes), seconds, ease, delay, callback));
        };
    } // End of the function
    static var registryKey = "shortcuts";
    static var shortcuts = null;
    static var mcshortcuts = null;
} // End of Class
