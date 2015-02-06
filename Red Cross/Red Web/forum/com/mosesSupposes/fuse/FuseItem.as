class com.mosesSupposes.fuse.FuseItem
{
    var _nItemID, _nFuseID, _initObj, _aProfiles, _oElements, _oTemps, _sImage, _aTweens;
    static var _ZigoEngine, _aInstances;
    function FuseItem(id, o, fuseID)
    {
        _ZigoEngine = _global.com.mosesSupposes.fuse.ZigoEngine;
        _nItemID = id;
        _nFuseID = fuseID;
        _initObj = o;
        _aProfiles = [];
        _oElements = {aEvents: []};
        _oTemps = {};
        if (!(o instanceof Array))
        {
            o = [o];
        } // end if
        var _loc18 = _global.com.mosesSupposes.fuse.Fuse;
        _oTemps.outputLevel = _loc18 != undefined ? (_loc18.OUTPUT_LEVEL) : (_global.com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL);
        if (o.length == 1)
        {
            var _loc17 = o[0];
            var _loc9 = _loc17.action != undefined ? (_loc17.action) : (_loc17);
            if (_loc9.__buildMode != true && _loc9.command != undefined)
            {
                _oElements.command = _loc9.command;
                _oElements.scope = _loc9.scope;
                _oElements.args = _loc9.args;
                _sImage = " Elements:[" + ("command" + (typeof(_loc9.command) == "string" ? (":\"" + _loc9.command + "\", ") : (", ")));
                if (_loc9.label != undefined && typeof(_loc9.label) == "string")
                {
                    _sImage = _sImage + ("label:\"" + _loc9.label + "\", ");
                    _oElements.label = _loc9.label;
                } // end if
                if (_loc9.delay != undefined)
                {
                    _sImage = _sImage + "delay, ";
                    _oElements.delay = _loc9.delay;
                } // end if
                if (_loc9.func != undefined && _oTemps.outputLevel > 0)
                {
                    com.mosesSupposes.fuse.FuseKitCommon.error("113");
                } // end if
                return;
            } // end if
        } // end if
        _oTemps.sImgS = "";
        _oTemps.sImgE = "";
        _oTemps.sImgB = "";
        _oTemps.afl = 0;
        _oTemps.ael = 0;
        _oTemps.twDelayFlag = false;
        _oTemps.nActions = o.length;
        _oTemps.fuseProps = com.mosesSupposes.fuse.FuseKitCommon._fuseprops();
        _oTemps.cbProps = com.mosesSupposes.fuse.FuseKitCommon._cbprops();
        _oTemps.sUP = com.mosesSupposes.fuse.FuseKitCommon._underscoreable();
        _oTemps.sCT = com.mosesSupposes.fuse.FuseKitCommon._cts();
        _oTemps.bTriggerFound = false;
        for (var _loc16 in o)
        {
            var _loc3 = o[_loc16];
            if (_loc3.label != undefined && typeof(_loc3.label) == "string")
            {
                _oElements.label = _loc3.label;
            } // end if
            var _loc5;
            var _loc7;
            var _loc8 = Boolean(typeof(_loc3.action) == "object" && !(_loc3.action instanceof Array));
            if (_loc8 == true)
            {
                _loc5 = _loc3.action;
                _loc7 = {delay: _loc3.delay, target: _loc3.target, addTarget: _loc3.addTarget, label: _loc3.label, trigger: _loc3.trigger};
            }
            else
            {
                _loc5 = _loc3;
            } // end else if
            var _loc4 = this.parseProfile(_loc5, _loc7);
            if (_loc4 != undefined)
            {
                _aProfiles.unshift(_loc4);
            } // end if
        } // end of for...in
        _sImage = "";
        var _loc15 = "";
        if (_oElements.label != undefined)
        {
            _loc15 = _loc15 + ("label:\"" + _oElements.label + "\", ");
        } // end if
        if (_oTemps.afl > 0)
        {
            _loc15 = _loc15 + (_oTemps.afl > 1 ? (_oTemps.afl + " callbacks, ") : ("callback, "));
        } // end if
        if (_oElements.delay != undefined || _oTemps.twDelayFlag == true)
        {
            _loc15 = _loc15 + "delay, ";
        } // end if
        if (_oTemps.bTriggerFound == true)
        {
            _loc15 = _loc15 + "trigger, ";
        } // end if
        if (_oTemps.ael > 0)
        {
            _loc15 = _loc15 + (_oTemps.ael > 1 ? (_oTemps.ael + " events, ") : ("event, "));
        } // end if
        if (_loc15 != "")
        {
            _sImage = _sImage + (" Elements:[" + _loc15.slice(0, -2) + "]");
        } // end if
        if (_oTemps.sImgS != "")
        {
            _sImage = _sImage + (" StartProps:[" + _oTemps.sImgS.slice(0, -2) + "]");
        } // end if
        if (_oTemps.sImgE != "")
        {
            _sImage = _sImage + (" Props:[" + _oTemps.sImgE.slice(0, -2) + "]");
        } // end if
        if (_oTemps.sImgB != "")
        {
            _sImage = _sImage + (" Simple Syntax Props:[" + _oTemps.sImgB.slice(0, -1) + "]");
        } // end if
        delete this._oTemps;
    } // End of the function
    static function doTween()
    {
        for (var _loc3 in arguments)
        {
            if (typeof(arguments[_loc3]) == "object")
            {
                if (com.mosesSupposes.fuse.FuseItem._aInstances == undefined)
                {
                    _aInstances = new Array();
                } // end if
                var _loc2 = new com.mosesSupposes.fuse.FuseItem(com.mosesSupposes.fuse.FuseItem._aInstances.length, arguments[_loc3], -1);
                return (_loc2.startItem());
            } // end if
        } // end of for...in
    } // End of the function
    function getLabel()
    {
        return (_oElements.label);
    } // End of the function
    function hasTriggerFired()
    {
        return (_bTrigger == true);
    } // End of the function
    function getInitObj()
    {
        return (_initObj);
    } // End of the function
    function getActiveTargets(targetList)
    {
        if (_aTweens.length <= 0)
        {
            return (targetList);
        } // end if
        var _loc3 = false;
        for (var _loc5 in _aTweens)
        {
            for (var _loc4 in targetList)
            {
                if (targetList[_loc4] == _aTweens[_loc5].targ)
                {
                    _loc3 = true;
                    break;
                } // end if
            } // end of for...in
            if (_loc3 == false)
            {
                targetList.unshift(_aTweens[_loc5].targ);
            } // end if
        } // end of for...in
        return (targetList);
    } // End of the function
    function toString()
    {
        return (String(this._sID() + ":" + _sImage));
    } // End of the function
    function evalDelay(scope)
    {
        var _loc3 = _oElements.delay;
        if (_loc3 instanceof Function)
        {
            _loc3 = _loc3.apply(_oElements.delayscope != undefined ? (_oElements.delayscope) : (scope));
        } // end if
        if (typeof(_loc3) == "string")
        {
            _loc3 = this.parseClock(String(_loc3));
        } // end if
        if (_global.isNaN(Number(_loc3)) == true)
        {
            return (0);
        } // end if
        return (Number(_loc3));
    } // End of the function
    function startItem(targs, scope)
    {
        _ZigoEngine = _global.com.mosesSupposes.fuse.ZigoEngine;
        var _loc10 = _global.com.mosesSupposes.fuse.Fuse;
        var _loc5 = _loc10 != undefined ? (_loc10.OUTPUT_LEVEL) : (com.mosesSupposes.fuse.FuseItem._ZigoEngine.OUTPUT_LEVEL);
        if (_oElements.command != null)
        {
            var _loc12 = "|start|stop|pause|resume|skipTo|setStartProps|";
            var _loc11 = _oElements.scope || scope;
            var _loc8 = _oElements.command instanceof Function ? (String(_oElements.command.apply(_loc11))) : (String(_oElements.command));
            var _loc6 = _oElements.args instanceof Function ? (_oElements.args.apply(_loc11)) : (_oElements.args);
            if (_loc12.indexOf("|" + _loc8 + "|") == -1 || _loc8 == "skipTo" && _loc6 == undefined)
            {
                if (_loc5 > 0)
                {
                    com.mosesSupposes.fuse.FuseKitCommon.error("111", _loc8);
                } // end if
            }
            else
            {
                _nPlaying = 1;
                if (!(_loc6 instanceof Array))
                {
                    _loc6 = _loc6 == null ? ([]) : ([_loc6]);
                } // end if
                this.dispatchRequest(String(_loc8), _loc6);
            } // end else if
            return (null);
        } // end if
        if (_aTweens.length > 0)
        {
            this.stop();
        } // end if
        com.mosesSupposes.fuse.FuseItem._ZigoEngine.addListener(this);
        _nPlaying = 2;
        var _loc4 = null;
        if (_aProfiles.length > 0)
        {
            if (com.mosesSupposes.fuse.FuseItem._ZigoEngine == undefined)
            {
                com.mosesSupposes.fuse.FuseKitCommon.error("112");
            }
            else
            {
                _loc4 = this.doTweens(targs, scope, false);
            } // end if
        } // end else if
        _nPlaying = 1;
        var _loc3 = _oElements.aEvents;
        for (var _loc9 in _loc3)
        {
            if (_loc4 == null && _aTweens.length > 0 && _loc3[_loc9].skipLevel == 2)
            {
                continue;
            } // end if
            this.fireEvents(_loc3[_loc9], scope, _loc5);
        } // end of for...in
        if (_loc4 == null && _aTweens.length <= 0 && _nPlaying == 1)
        {
            if (_loc5 == 3)
            {
                com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " no tweens added - item done. [getTimer()=" + getTimer() + "]");
            } // end if
            this.complete();
        } // end if
        return (_loc4);
    } // End of the function
    function stop()
    {
        var _loc2 = _nPlaying > -1;
        _nPlaying = -1;
        if (_loc2 == true)
        {
            this.onStop();
        } // end if
        com.mosesSupposes.fuse.FuseItem._ZigoEngine.removeListener(this);
    } // End of the function
    static function removeInstance(id)
    {
        (com.mosesSupposes.fuse.FuseItem)(com.mosesSupposes.fuse.FuseItem._aInstances[id]).destroy();
        delete com.mosesSupposes.fuse.FuseItem._aInstances[id];
    } // End of the function
    function onStop()
    {
        _bStartSet = false;
        for (var _loc3 in _aTweens)
        {
            var _loc2 = _aTweens[_loc3];
            _loc2.targ.removeListener(this);
            com.mosesSupposes.fuse.FuseItem._ZigoEngine.removeTween(_loc2.targ, _loc2.props);
            delete _aTweens[_loc3];
        } // end of for...in
        delete this._aTweens;
        _bTrigger = false;
    } // End of the function
    function evtSetStart(o)
    {
        if (_sImage.indexOf("StartProps:") == -1 || o.curIndex == _nItemID)
        {
            return;
        } // end if
        if (o.all != true)
        {
            var _loc3 = false;
            for (var _loc4 in o.filter)
            {
                if (Number(o.filter[_loc4]) == _nItemID || String(o.filter[_loc4]) == _oElements.label)
                {
                    _loc3 = true;
                } // end if
            } // end of for...in
            if (_loc3 == false)
            {
                return;
            } // end if
        } // end if
        this.doTweens(o.targs, o.scope, true);
        _bStartSet = true;
    } // End of the function
    function pause(resume)
    {
        if (_nPlaying == -1)
        {
            return;
        } // end if
        _nPlaying = resume == true ? (1) : (0);
        for (var _loc12 in _aTweens)
        {
            var _loc4 = _aTweens[_loc12];
            var _loc2 = _loc4.targ;
            var _loc3 = _loc4.props;
            if (resume == true)
            {
                var _loc5 = [];
                var _loc6 = _aTweens.length;
                for (var _loc8 in _loc3)
                {
                    if (com.mosesSupposes.fuse.FuseItem._ZigoEngine.isTweenPaused(_loc2, _loc3[_loc8]) == false)
                    {
                        _loc5.push(_loc3[_loc8]);
                    } // end if
                } // end of for...in
                if (_loc5.length > 0)
                {
                    this.onTweenEnd({__zigoID__: _loc4.targZID, props: _loc5, isResume: true});
                } // end if
                if (_aTweens.length == _loc6)
                {
                    _loc2.addListener(this);
                    com.mosesSupposes.fuse.FuseItem._ZigoEngine.unpauseTween(_loc2, _loc4.props);
                } // end if
                continue;
            } // end if
            _loc2.removeListener(this);
            com.mosesSupposes.fuse.FuseItem._ZigoEngine.pauseTween(_loc2, _loc4.props);
        } // end of for...in
        if (resume == true && _aTweens.length <= 0)
        {
            this.complete();
        }
        else if (resume == true)
        {
            com.mosesSupposes.fuse.FuseItem._ZigoEngine.addListener(this);
        }
        else
        {
            com.mosesSupposes.fuse.FuseItem._ZigoEngine.removeListener(this);
        } // end else if
    } // End of the function
    function destroy()
    {
        var _loc3 = _nPlaying > -1;
        _nPlaying = -1;
        for (var _loc5 in _aTweens)
        {
            var _loc2 = _aTweens[_loc5];
            _loc2.targ.removeListener(this);
            if (_loc3 == true)
            {
                com.mosesSupposes.fuse.FuseItem._ZigoEngine.removeTween(_loc2.targ, _loc2.props);
            } // end if
            delete _aTweens[_loc5];
        } // end of for...in
        for (var _loc4 in this)
        {
            delete this[_loc4];
        } // end of for...in
    } // End of the function
    function dispatchRequest(type, args)
    {
        var _loc4 = _global.com.mosesSupposes.fuse.Fuse.getInstance(_nFuseID);
        if (!(args instanceof Array) && args != null)
        {
            args = new Array(args);
        } // end if
        Function(_loc4[type]).apply(_loc4, args);
    } // End of the function
    function _sID()
    {
        var _loc3;
        if (_nFuseID == -1)
        {
            _loc3 = "One-off tween ";
        }
        else
        {
            var _loc4 = _global.com.mosesSupposes.fuse.Fuse.getInstance(_nFuseID);
            _loc3 = "Fuse#" + String(_nFuseID);
            if (_loc4.label != undefined)
            {
                _loc3 = _loc3 + (":\"" + _loc4.label + "\"");
            } // end if
        } // end else if
        _loc3 = _loc3 + (">Item#" + String(_nItemID));
        if (_oElements.label != undefined)
        {
            _loc3 = _loc3 + (":\"" + _oElements.label + "\"");
        } // end if
        return (_loc3);
    } // End of the function
    function parseProfile(obj, aap)
    {
        var _loc39;
        var _loc2;
        var _loc8;
        if (obj.__buildMode == true)
        {
            if (obj.command != undefined)
            {
                if (obj.command == "delay")
                {
                    _oElements.delay = obj.commandargs;
                }
                else
                {
                    _oElements.command = obj.command;
                    _oElements.args = obj.commandargs;
                } // end if
            } // end else if
            if (obj.func != undefined)
            {
                ++_oTemps.afl;
                _oElements.aEvents.unshift({f: obj.func, s: obj.scope, a: obj.args});
            } // end if
            if (obj.tweenargs != undefined)
            {
                _oTemps.sImgB = _oTemps.sImgB + (obj.tweenargs[1].toString() + ",");
                return (obj);
            } // end if
            return (null);
        } // end if
        var _loc3 = {delay: aap.delay != undefined ? (aap.delay) : (obj.delay), ease: obj.ease, seconds: obj.seconds, event: obj.event, eventparams: obj.eventparams, skipLevel: typeof(obj.skipLevel) == "number" && obj.skipLevel >= 0 && obj.skipLevel <= 2 ? (obj.skipLevel) : (com.mosesSupposes.fuse.FuseItem._ZigoEngine.SKIP_LEVEL), oSP: {}, oEP: {}, oAFV: {}};
        var _loc22 = aap.trigger != undefined ? (aap.trigger) : (obj.trigger);
        if (_loc22 != undefined)
        {
            if (_oTemps.bTriggerFound == false)
            {
                _loc3.trigger = _loc22;
                _oTemps.bTriggerFound = true;
            }
            else if (_oTemps.outputLevel > 0)
            {
                com.mosesSupposes.fuse.FuseKitCommon.error("126", this._sID(), _loc22);
            } // end if
        } // end else if
        if (_loc3.delay == undefined)
        {
            _loc3.delay = obj.startAt;
        } // end if
        if (_loc3.ease == undefined)
        {
            _loc3.ease = obj.easing;
        } // end if
        if (_loc3.seconds == undefined)
        {
            _loc3.seconds = obj.duration != undefined ? (obj.duration) : (obj.time);
        } // end if
        if (aap.target != undefined)
        {
            _loc3.target = aap.target instanceof Array ? (aap.target) : ([aap.target]);
        }
        else if (obj.target != undefined)
        {
            _loc3.target = obj.target instanceof Array ? (obj.target) : ([obj.target]);
        } // end else if
        if (obj.addTarget != undefined)
        {
            _loc3.addTarget = obj.addTarget instanceof Array ? (obj.addTarget) : ([obj.addTarget]);
        } // end if
        if (aap.addTarget != undefined)
        {
            if (_loc3.addTarget == undefined)
            {
                _loc3.addTarget = aap.addTarget instanceof Array ? (aap.addTarget) : ([aap.addTarget]);
            }
            else
            {
                _loc3.addTarget = _loc3.addTarget instanceof Array ? (_loc3.addTarget.concat(aap.addTarget)) : (new Array(_loc3.addTarget).concat(aap.addTarget));
            } // end if
        } // end else if
        var _loc15 = false;
        for (var _loc2 in obj)
        {
            var _loc9 = obj[_loc2];
            if (_oTemps.cbProps.indexOf("|" + _loc2 + "|") > -1)
            {
                if (_loc2 != "skipLevel")
                {
                    _loc3[_loc2] = _loc9;
                } // end if
                continue;
            } // end if
            if (_oTemps.fuseProps.indexOf("|" + _loc2 + "|") > -1)
            {
                if (_loc2 == "command" && _oTemps.nActions > 1 && _oTemps.outputLevel > 0)
                {
                    com.mosesSupposes.fuse.FuseKitCommon.error("114", String(_loc9));
                } // end if
                continue;
            } // end if
            if (typeof(_loc9) == "object")
            {
                var _loc11 = _loc9 instanceof Array ? ([]) : ({});
                for (var _loc8 in _loc9)
                {
                    _loc11[_loc8] = _loc9[_loc8];
                } // end of for...in
                _loc9 = _loc11;
            } // end if
            var _loc4;
            var _loc21;
            if (_loc2.indexOf("start") == 0)
            {
                _loc2 = _loc2.slice(6);
                _loc4 = _loc3.oSP;
            }
            else
            {
                _loc4 = _loc3.oEP;
            } // end else if
            if (com.mosesSupposes.fuse.FuseItem.ADD_UNDERSCORES == true && _oTemps.sUP.indexOf("|_" + _loc2 + "|") > -1)
            {
                _loc2 = "_" + _loc2;
            } // end if
            if (_oTemps.sCT.indexOf("|" + _loc2 + "|") > -1)
            {
                var _loc13 = _loc2 == "_tintPercent" && _loc4.colorProp.p == "_tint";
                var _loc12 = _loc2 == "_tint" && _loc4.colorProp.p == "_tintPercent";
                if (_loc4.colorProp == undefined || _loc13 == true || _loc12 == true)
                {
                    if (_loc13 == true)
                    {
                        _loc4.colorProp = {p: "_tint", v: {tint: _loc4.colorProp.v, percent: _loc9}};
                    }
                    else if (_loc12 == true)
                    {
                        _loc4.colorProp = {p: "_tint", v: {tint: _loc9, percent: _loc4.colorProp.v}};
                    }
                    else
                    {
                        _loc4.colorProp = {p: _loc2, v: _loc9};
                    } // end else if
                    _loc15 = true;
                }
                else if (_oTemps.outputLevel > 0)
                {
                    com.mosesSupposes.fuse.FuseKitCommon.error("115", this._sID(), _loc2);
                } // end else if
                continue;
            } // end if
            if (_loc9 != null)
            {
                if (_loc4 == _loc3.oEP && (obj.controlX != undefined || obj.controlY != undefined) && (_loc2.indexOf("control") == 0 || _loc2 == "_x" || _loc2 == "_y"))
                {
                    if (_loc4._bezier_ == undefined)
                    {
                        _loc4._bezier_ = {};
                    } // end if
                    if (_loc2.indexOf("control") == 0)
                    {
                        _loc4._bezier_[_loc2] = _loc9;
                    }
                    else
                    {
                        _loc4._bezier_[_loc2.charAt(1)] = _loc9;
                    } // end else if
                }
                else
                {
                    _loc4[_loc2] = _loc9;
                } // end else if
                _loc15 = true;
            } // end if
        } // end of for...in
        if (_loc15 == false && (_loc3.trigger != undefined || (_loc3.delay != undefined || _loc3.seconds != undefined) && (_loc3.startfunc != undefined || _loc3.updfunc != undefined || _loc3.func != undefined && _oTemps.nActions > 1)))
        {
            if (com.mosesSupposes.fuse.FuseItem._ZigoEngine == undefined)
            {
                com.mosesSupposes.fuse.FuseKitCommon.error("116");
            }
            else
            {
                if (_loc3.func != undefined)
                {
                    ++_oTemps.afl;
                } // end if
                if (_loc3.event != undefined)
                {
                    ++_oTemps.ael;
                } // end if
                _loc3._doTimer = true;
                if (_loc3.delay != undefined)
                {
                    _oTemps.twDelayFlag = true;
                } // end if
                return (_loc3);
            } // end if
        } // end else if
        if (_loc15 == true)
        {
            var _loc17 = _loc3.oEP.colorProp != undefined;
            for (var _loc7 = 0; _loc7 < 2; ++_loc7)
            {
                _loc4 = _loc7 == 0 ? (_loc3.oSP) : (_loc3.oEP);
                var _loc6 = _loc7 == 0 ? (_oTemps.sImgS) : (_oTemps.sImgE);
                var _loc10 = _loc4.colorProp.p;
                if (_loc10 != undefined)
                {
                    _loc4[_loc10] = _loc4.colorProp.v;
                    delete _loc4.colorProp;
                } // end if
                if ((_loc4._xscale != undefined || _loc4._scale != undefined) && (_loc4._width != undefined || _loc4._size != undefined))
                {
                    var _loc14 = _loc4._xscale != undefined ? ("_xscale") : ("_scale");
                    delete _loc4[_loc14];
                    if (_oTemps.outputLevel > 0)
                    {
                        com.mosesSupposes.fuse.FuseKitCommon.error("115", this._sID(), _loc14);
                    } // end if
                } // end if
                if ((_loc4._yscale != undefined || _loc4._scale != undefined) && (_loc4._height != undefined || _loc4._size != undefined))
                {
                    _loc14 = _loc4._yscale != undefined ? ("_yscale") : ("_scale");
                    delete _loc4[_loc14];
                    if (_oTemps.outputLevel > 0)
                    {
                        com.mosesSupposes.fuse.FuseKitCommon.error("115", this._sID(), _loc14);
                    } // end if
                } // end if
                for (var _loc2 in _loc4)
                {
                    if (_loc6.indexOf(_loc2 + ", ") == -1)
                    {
                        _loc6 = _loc6 + (_loc2 + ", ");
                    } // end if
                    if (_loc4 == _loc3.oSP)
                    {
                        if (_loc3.oEP[_loc2] == undefined && !(_loc2 == _loc10 && _loc17 == true))
                        {
                            _loc3.oAFV[_loc2] = true;
                            _loc3.oEP[_loc2] = [];
                        } // end if
                    } // end if
                } // end of for...in
                _loc7 == 0 ? (_oTemps.sImgS = _loc6) : (_oTemps.sImgE = _loc6);
            } // end of for
            return (_loc3);
        } // end if
        if (_loc3.delay != undefined && _oTemps.nActions == 1)
        {
            _oElements.delay = _loc3.delay;
            _oElements.delayscope = _loc3.scope;
        } // end if
        if (_loc3.event != undefined)
        {
            ++_oTemps.ael;
            _oElements.aEvents.unshift({e: _loc3.event, s: _loc3.scope, ep: _loc3.eventparams, skipLevel: _loc3.skipLevel});
        } // end if
        var _loc23 = _oElements.aEvents.length;
        if (_loc3.easyfunc != undefined)
        {
            _oElements.aEvents.push({cb: _loc3.easyfunc, s: _loc3.scope, skipLevel: _loc3.skipLevel});
        } // end if
        if (_loc3.func != undefined)
        {
            _oElements.aEvents.push({f: _loc3.func, s: _loc3.scope, a: _loc3.args, skipLevel: _loc3.skipLevel});
        } // end if
        _oTemps.afl = _oTemps.afl + (_oElements.aEvents.length - _loc23);
        false;
        return;
    } // End of the function
    function doTweens(targs, defaultScope, setStart)
    {
        if (_aTweens == null)
        {
            _aTweens = [];
        } // end if
        var _loc66 = _global.com.mosesSupposes.fuse.Fuse;
        var _loc19 = _loc66 != undefined ? (_loc66.OUTPUT_LEVEL) : (com.mosesSupposes.fuse.FuseItem._ZigoEngine.OUTPUT_LEVEL);
        var _loc27 = "";
        var _loc65 = 0;
        var _loc7;
        var _loc6;
        var _loc4;
        if (_aProfiles[0].__buildMode == true)
        {
            for (var _loc48 = 0; _loc48 < _aProfiles.length; ++_loc48)
            {
                var _loc29 = _aProfiles[_loc48].tweenargs;
                if (_loc29[6].cycles === 0 || _loc29[6].cycles.toUpperCase() == "LOOP")
                {
                    delete _loc29[6].cycles;
                    if (_loc19 > 0)
                    {
                        com.mosesSupposes.fuse.FuseKitCommon.error("117", this._sID());
                    } // end if
                } // end if
                var _loc31 = com.mosesSupposes.fuse.FuseItem._ZigoEngine.doTween.apply(com.mosesSupposes.fuse.FuseItem._ZigoEngine, _loc29);
                var _loc15 = _loc31 == null ? ([]) : (_loc31.split(","));
                if (_loc15.length > 0)
                {
                    _aTweens.push({targ: _loc29[0], props: _loc15, targZID: _loc29[0].__zigoID__});
                    _loc29[0].addListener(this);
                    for (var _loc6 in _loc15)
                    {
                        if (_loc27.indexOf(_loc15[_loc6] + ",") == -1)
                        {
                            _loc27 = _loc27 + (_loc15[_loc6] + ",");
                        } // end if
                    } // end of for...in
                } // end if
                if (_loc19 == 3)
                {
                    com.mosesSupposes.fuse.FuseKitCommon.output("\n-" + this._sID() + " TWEEN (simple syntax)\n\ttargets:[" + _loc29[0] + "]\n\tprops sent:[" + _loc29[1] + "]");
                } // end if
            } // end of for
            return (_loc27 == "" ? (null) : (_loc27.slice(0, -1)));
        } // end if
        var _loc67 = _bStartSet != true && (setStart == true || _sImage.indexOf("StartProps:") > -1);
        for (var _loc48 = 0; _loc48 < _aProfiles.length; ++_loc48)
        {
            var _loc3 = _aProfiles[_loc48];
            var _loc9 = defaultScope;
            if (_loc3.scope != undefined)
            {
                _loc9 = _loc3.scope instanceof Function ? (_loc3.scope.apply(_loc9)) : (_loc3.scope);
            } // end if
            var _loc20;
            if (_loc3.event != undefined)
            {
                var _loc45 = _loc3.event instanceof Function ? (_loc3.event.apply(_loc9)) : (_loc3.event);
                var _loc56 = _loc3.eventparams instanceof Function ? (_loc3.eventparams.apply(_loc9)) : (_loc3.eventparams);
                if (_loc45 != undefined && _loc45.length > 0)
                {
                    _loc20 = {e: _loc45, ep: _loc56, s: _loc9};
                } // end if
            } // end if
            var _loc51 = _loc3.skipLevel instanceof Function ? (_loc3.skipLevel.apply(_loc9)) : (_loc3.skipLevel);
            var _loc33 = {skipLevel: _loc51};
            var _loc8 = {skipLevel: _loc51};
            if (_loc3.cycles != undefined)
            {
                var _loc46 = _loc3.cycles instanceof Function ? (_loc3.cycles.apply(_loc9)) : (_loc3.cycles);
                if ((Number(_loc46) == 0 || String(_loc46).toUpperCase() == "LOOP") && _loc66 != undefined)
                {
                    delete _loc3.cycles;
                    if (_loc19 > 0)
                    {
                        com.mosesSupposes.fuse.FuseKitCommon.error("117", this._sID());
                    } // end if
                }
                else
                {
                    _loc33.cycles = _loc8.cycles = _loc46;
                } // end if
            } // end else if
            var _loc37 = "";
            if (_loc3.easyfunc != undefined || _loc3.func != undefined || _loc3.startfunc != undefined || _loc3.updfunc != undefined)
            {
                for (var _loc7 in _loc3)
                {
                    if (_loc7.indexOf("func") > -1)
                    {
                        _loc8[_loc7] = _loc3[_loc7];
                        continue;
                    } // end if
                    if (_loc7 == "startscope" || _loc7 == "updscope" || _loc7.indexOf("args") > -1)
                    {
                        _loc8[_loc7] = _loc3[_loc7] instanceof Function ? (Function(_loc3[_loc7]).apply(_loc9)) : (_loc3[_loc7]);
                    } // end if
                } // end of for...in
                if (_loc9 != undefined)
                {
                    if (_loc8.func != undefined && _loc8.scope == undefined)
                    {
                        _loc8.scope = _loc9;
                    } // end if
                    if (_loc8.updfunc != undefined && _loc8.updscope == undefined)
                    {
                        _loc8.updscope = _loc9;
                    } // end if
                    if (_loc8.startfunc != undefined && _loc8.startscope == undefined)
                    {
                        _loc8.startscope = _loc9;
                    } // end if
                } // end if
            } // end if
            for (var _loc6 in _loc8)
            {
                _loc37 = _loc37 + (_loc6 + ":" + _loc8[_loc6] + "|");
            } // end of for...in
            var _loc42 = _loc3.trigger === true;
            var _loc17;
            if (_loc42 == false && _loc3.trigger != undefined)
            {
                _loc17 = _loc3.trigger instanceof Function ? (_loc3.trigger.apply(_loc9)) : (_loc3.trigger);
                if (typeof(_loc17) == "string")
                {
                    _loc17 = String(_loc17).charAt(0) == "-" ? (-this.parseClock(String(_loc17).slice(1))) : (this.parseClock(String(_loc17)));
                } // end if
                if (_global.isNaN(_loc17) == true)
                {
                    _loc17 = undefined;
                } // end if
            } // end if
            var _loc12 = [];
            var _loc43 = _loc3.target == undefined ? (targs) : (_loc3.target);
            var _loc21 = [];
            var _loc47 = false;
            for (var _loc7 in _loc43)
            {
                var _loc5 = _loc43[_loc7];
                _loc21 = _loc21.concat(_loc5 instanceof Function ? (_loc5.apply(_loc9)) : (_loc5));
            } // end of for...in
            for (var _loc7 in _loc3.addTarget)
            {
                _loc5 = _loc3.addTarget[_loc7];
                _loc21 = _loc21.concat(_loc5 instanceof Function ? (_loc5.apply(_loc9)) : (_loc5));
            } // end of for...in
            for (var _loc7 in _loc21)
            {
                _loc5 = _loc21[_loc7];
                if (_loc5 != null)
                {
                    var _loc35 = false;
                    for (var _loc6 in _loc12)
                    {
                        if (_loc12[_loc6] == _loc5)
                        {
                            _loc35 = true;
                            break;
                        } // end if
                    } // end of for...in
                    if (_loc35 == false)
                    {
                        _loc12.unshift(_loc5);
                    } // end if
                    continue;
                } // end if
                _loc47 = true;
            } // end of for...in
            var _loc52 = _loc12.length == 0 && _loc3._doTimer != true;
            var _loc49 = _loc3._doTimer == true && _loc12.length == 0;
            if (_loc47 == true || _loc52 == true)
            {
                ++_loc65;
                if (_loc52 == true)
                {
                    continue;
                } // end if
            } // end if
            if (_loc67 == true)
            {
                for (var _loc7 in _loc12)
                {
                    var _loc30 = _loc12[_loc7];
                    var _loc28 = [];
                    var _loc23 = [];
                    if (setStart == true)
                    {
                        for (var _loc57 in _loc3.oEP)
                        {
                            _global.com.mosesSupposes.fuse.FuseFMP.getFilterProp(_loc30, _loc57, true);
                        } // end of for...in
                    } // end if
                    for (var _loc58 in _loc3.oSP)
                    {
                        _loc5 = _loc3.oSP[_loc58];
                        if (_loc5 instanceof Function)
                        {
                            _loc5 = _loc5.apply(_loc9);
                        } // end if
                        if (_loc5 === true || _loc5 === false)
                        {
                            _loc30[_loc58] = _loc5;
                            if (_loc3.oAFV[_loc58] == true)
                            {
                                for (var _loc4 in _loc3.oEP[_loc58])
                                {
                                    if (_loc3.oEP[_loc58][_loc4].targ == _loc30)
                                    {
                                        _loc3.oEP[_loc58].splice(Number(_loc4), 1);
                                    } // end if
                                } // end of for...in
                                _loc3.oEP[_loc58].push({targ: _loc30, val: "IGNORE"});
                            } // end if
                            continue;
                        } // end if
                        if (_loc3.oAFV[_loc58] == true && !(_loc58 == "_colorReset" && _loc5 == 100) && !(_loc58 == "_tintPercent" && _loc5 == 0))
                        {
                            var _loc16;
                            if (_loc58 == "_tint" || _loc58 == "_colorTransform")
                            {
                                _loc16 = com.mosesSupposes.fuse.FuseItem._ZigoEngine.getColorTransObj();
                            }
                            else if ("|_alpha|_contrast|_invertColor|_tintPercent|_xscale|_yscale|_scale|".indexOf("|" + _loc58 + "|") > -1)
                            {
                                _loc16 = 100;
                            }
                            else if ("|_brightness|_brightOffset|_colorReset|_rotation|".indexOf("|" + _loc58 + "|") > -1)
                            {
                                _loc16 = 0;
                            }
                            else
                            {
                                var _loc25 = _global.com.mosesSupposes.fuse.FuseFMP.getFilterProp(_loc30, _loc58, true);
                                if (_loc25 != null)
                                {
                                    _loc16 = _loc25;
                                }
                                else
                                {
                                    _loc16 = _global.isNaN(_loc30[_loc58]) == false ? (_loc30[_loc58]) : (0);
                                } // end else if
                            } // end else if
                            for (var _loc4 in _loc3.oEP[_loc58])
                            {
                                if (_loc3.oEP[_loc58][_loc4].targ == _loc30)
                                {
                                    _loc3.oEP[_loc58].splice(Number(_loc4), 1);
                                } // end if
                            } // end of for...in
                            _loc3.oEP[_loc58].push({targ: _loc30, val: _loc16});
                        } // end if
                        if (typeof(_loc5) == "object")
                        {
                            var _loc24 = _loc5 instanceof Array ? ([]) : ({});
                            for (var _loc4 in _loc5)
                            {
                                _loc24[_loc4] = _loc5[_loc4] instanceof Function ? (Function(_loc5[_loc4]).apply(_loc9)) : (_loc5[_loc4]);
                            } // end of for...in
                            _loc5 = _loc24;
                        } // end if
                        _loc28.push(_loc58);
                        _loc23.push(_loc5);
                    } // end of for...in
                    if (_loc23.length > 0)
                    {
                        if (_loc19 == 3)
                        {
                            com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " " + _loc30 + " SET STARTS: " + ["[" + _loc28 + "]", "[" + _loc23 + "]"]);
                        } // end if
                        com.mosesSupposes.fuse.FuseItem._ZigoEngine.doTween(_loc30, _loc28, _loc23, 0);
                    } // end if
                } // end of for...in
            } // end if
            if (setStart == true)
            {
                continue;
            } // end if
            var _loc10;
            var _loc13;
            var _loc11;
            var _loc36 = false;
            var _loc44 = _loc49 == false ? (_loc12) : ([0]);
            for (var _loc7 in _loc44)
            {
                var _loc18 = _loc3.ease;
                if (_loc18 instanceof Function)
                {
                    var _loc38 = Function(_loc18);
                    if (typeof(_loc38(1, 1, 1, 1)) != "number")
                    {
                        _loc18 = _loc38.apply(_loc9);
                    } // end if
                } // end if
                _loc10 = _loc3.seconds instanceof Function ? (_loc3.seconds.apply(_loc9)) : (_loc3.seconds);
                if (_loc10 != undefined)
                {
                    if (typeof(_loc10) == "string")
                    {
                        _loc10 = this.parseClock(String(_loc10));
                    } // end if
                    if (_global.isNaN(_loc10) == true)
                    {
                        _loc10 = com.mosesSupposes.fuse.FuseItem._ZigoEngine.DURATION || 0;
                    } // end if
                } // end if
                _loc13 = _loc3.delay instanceof Function ? (_loc3.delay.apply(_loc9)) : (_loc3.delay);
                if (typeof(_loc13) == "string")
                {
                    _loc13 = this.parseClock(String(_loc13));
                } // end if
                if (_loc13 == null || _global.isNaN(_loc13) == true)
                {
                    _loc13 = 0;
                } // end if
                if (_loc49 == true)
                {
                    continue;
                } // end if
                _loc30 = _loc44[_loc7];
                var _loc22 = [];
                var _loc14 = [];
                var _loc40 = 0;
                for (var _loc58 in _loc3.oEP)
                {
                    _loc5 = _loc3.oEP[_loc58];
                    if (_loc5 instanceof Function)
                    {
                        _loc5 = _loc5.apply(_loc9);
                    } // end if
                    if (_loc5 === true || _loc5 === false)
                    {
                        if (_loc11 == undefined)
                        {
                            _loc11 = {};
                        } // end if
                        _loc11[_loc58] = _loc5;
                        ++_loc40;
                        continue;
                    } // end if
                    if (typeof(_loc5) == "object")
                    {
                        if (_loc5[0].targ != undefined)
                        {
                            for (var _loc4 in _loc5)
                            {
                                if (_loc5[_loc4].targ == _loc30)
                                {
                                    _loc5 = _loc5[_loc4].val;
                                    break;
                                } // end if
                            } // end of for...in
                        }
                        else
                        {
                            _loc24 = _loc5 instanceof Array ? ([]) : ({});
                            for (var _loc4 in _loc5)
                            {
                                _loc24[_loc4] = _loc5[_loc4] instanceof Function ? (Function(_loc5[_loc4]).apply(_loc9)) : (_loc5[_loc4]);
                            } // end of for...in
                            _loc5 = _loc24;
                        } // end if
                    } // end else if
                    if (_loc5 != "IGNORE")
                    {
                        _loc22.push(_loc58);
                        _loc14.push(_loc5);
                    } // end if
                } // end of for...in
                _loc15 = [];
                if (_loc14.length > 0)
                {
                    _loc31 = com.mosesSupposes.fuse.FuseItem._ZigoEngine.doTween(_loc30, _loc22, _loc14, _loc10, _loc18, _loc13, _loc8);
                    if (_loc31 != null)
                    {
                        _loc15 = _loc31.split(",");
                    } // end if
                    if (_loc15.length > 0)
                    {
                        var _loc32 = {targ: _loc30, props: _loc15, bools: _loc11, targZID: _loc30.__zigoID__};
                        if (_loc36 == false)
                        {
                            _loc8 = _loc33;
                            _loc32.event = _loc20;
                            _loc11 = undefined;
                            _loc20 = undefined;
                            _loc32.trigger = _loc42;
                        } // end if
                        _aTweens.push(_loc32);
                        _loc30.addListener(this);
                        _loc36 = true;
                    } // end if
                    for (var _loc6 in _loc15)
                    {
                        if (_loc27.indexOf(_loc15[_loc6] + ",") == -1)
                        {
                            _loc27 = _loc27 + (_loc15[_loc6] + ",");
                        } // end if
                    } // end of for...in
                    if (_loc19 == 3)
                    {
                        var _loc39 = _loc22.toString();
                        if (_loc15.length > _loc22.length)
                        {
                            _loc39 = _loc39 + ("\n\t[NO-CHANGE PROPS DISCARDED. KEPT:" + _loc31 + "]");
                        } // end if
                        var _loc26 = "";
                        for (var _loc6 in _loc14)
                        {
                            _loc26 = (typeof(_loc14[_loc6]) == "string" ? ("\"" + _loc14[_loc6] + "\"") : (_loc14[_loc6])) + ", " + _loc26;
                        } // end of for...in
                        com.mosesSupposes.fuse.FuseKitCommon.output("\n-" + this._sID() + " TWEEN:\n" + ["\t[getTimer():" + getTimer() + "] ", "targ: " + _loc30, "props: " + _loc39, "endVals: " + _loc26, "time: " + (_loc10 == undefined ? (com.mosesSupposes.fuse.FuseItem._ZigoEngine.DURATION) : (_loc10)), "easing: " + (_loc18 == undefined ? (com.mosesSupposes.fuse.FuseItem._ZigoEngine.EASING) : (_loc18)), "delay: " + (_loc13 == undefined ? (0) : (_loc13)), "callbacks: " + (_loc37 == "" ? ("(none)") : (_loc37))].join("\n\t"));
                    } // end if
                } // end if
            } // end of for...in
            if (_loc10 == undefined || _global.isNaN(_loc10) == true)
            {
                _loc10 = 0;
            } // end if
            var _loc34 = _loc13 + _loc10;
            if (_loc17 != undefined)
            {
                if (_loc17 < 0)
                {
                    _loc17 = _loc17 + _loc34;
                } // end if
                if (_loc17 > 0 && (_loc34 == 0 || _loc17 < _loc34))
                {
                    if (_loc34 == 0)
                    {
                        if (_loc19 == 3)
                        {
                            com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " graft a timed trigger (" + _loc17 + " sec). [has callback:" + (_loc8 != _loc33) + ", has event:" + (_loc20 != undefined) + ", has booleans:" + (_loc11 != undefined) + "]");
                        } // end if
                        this.doTimerTween(null, _loc17, 0, true, _loc11, _loc8, _loc20);
                        _loc36 = true;
                    }
                    else
                    {
                        if (_loc19 == 3)
                        {
                            com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " graft a timed trigger (" + _loc17 + " sec).");
                        } // end if
                        this.doTimerTween(null, _loc17, 0, true);
                    } // end else if
                }
                else if (_loc19 == 3)
                {
                    com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " timed trigger discarded: out of range. [" + _loc17 + "/" + _loc34 + "]");
                } // end if
            } // end else if
            if (_loc36 == false && (_loc8 != _loc33 || _loc20 != undefined || _loc11 != undefined))
            {
                if (_loc51 == 0 && _loc34 > 0)
                {
                    if (_loc19 == 3)
                    {
                        com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " no props tweened - graft a delay (" + _loc34 + " sec). [has callback:" + (_loc8 != _loc33) + ", has event:" + (_loc20 != undefined) + ", has booleans:" + (_loc11 != undefined) + "]");
                    } // end if
                    this.doTimerTween(_loc12, _loc10, _loc13, _loc42, _loc11, _loc8, _loc20);
                    continue;
                } // end if
                if (_loc19 == 3)
                {
                    com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " no props tweened, executing nontween items. [has callback:" + (_loc8 != _loc33) + ", has event:" + (_loc20 != undefined) + ", has booleans:" + (_loc11 != undefined) + "]");
                } // end if
                for (var _loc7 in _loc12)
                {
                    for (var _loc6 in _loc11)
                    {
                        _loc12[_loc7][_loc6] = _loc11[_loc6];
                    } // end of for...in
                } // end of for...in
                if (_loc51 < 2)
                {
                    if (_loc8 != undefined)
                    {
                        if (_loc8.startfunc != undefined)
                        {
                            this.fireEvents({f: _loc8.startfunc, s: _loc8.startscope, a: _loc8.startargs}, _loc9, _loc19);
                        } // end if
                        if (_loc8.updfunc != undefined)
                        {
                            this.fireEvents({f: _loc8.updfunc, s: _loc8.updscope, a: _loc8.updargs}, _loc9, _loc19);
                        } // end if
                        if (_loc8.startfunc != undefined || _loc8.easyfunc != undefined)
                        {
                            this.fireEvents({f: _loc8.func, s: _loc8.scope, a: _loc8.args, cb: _loc8.easyfunc}, _loc9, _loc19);
                        } // end if
                    } // end if
                    if (_loc20 != undefined)
                    {
                        this.fireEvents(_loc20);
                    } // end if
                } // end if
            } // end if
        } // end of for
        if (_loc65 > 0 && _loc19 > 0)
        {
            if (_loc65 == _aProfiles.length && _loc27 == "")
            {
                com.mosesSupposes.fuse.FuseKitCommon.error("118", this._sID(), setStart);
            }
            else
            {
                com.mosesSupposes.fuse.FuseKitCommon.error("119", _loc67, _loc65, this._sID());
            } // end if
        } // end else if
        return (_loc27 == "" ? (null) : (_loc27.slice(0, -1)));
    } // End of the function
    function doTimerTween(actualTargets, duration, delay, trigger, booleans, callback, event)
    {
        var _loc2 = {__TweenedDelay: 0};
        com.mosesSupposes.fuse.FuseItem._ZigoEngine.initializeTargets(_loc2);
        _aTweens.push({targ: _loc2, props: ["__TweenedDelay"], trigger: trigger, bools: booleans, event: event, actualTargs: actualTargets, targZID: _loc2.__zigoID__});
        com.mosesSupposes.fuse.FuseItem._ZigoEngine.doTween(_loc2, "__TweenedDelay", 1, duration, null, delay, callback);
        _loc2.addListener(this);
    } // End of the function
    function onTweenEnd(o)
    {
        if (_nPlaying < 1)
        {
            return;
        } // end if
        var _loc16 = _global.com.mosesSupposes.fuse.Fuse;
        var _loc7 = _loc16 != undefined ? (_loc16.OUTPUT_LEVEL) : (com.mosesSupposes.fuse.FuseItem._ZigoEngine.OUTPUT_LEVEL);
        if (_loc7 == 3)
        {
            com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " onTweenEnd: " + (typeof(o.target) == "movieclip" ? (o.target._name) : (typeof(o.target))) + "[" + o.props + "] [getTimer()=" + getTimer() + "]");
        } // end if
        var _loc14 = o.__zigoID__ !== undefined ? (o.__zigoID__) : (o.target.__zigoID__);
        for (var _loc15 in _aTweens)
        {
            var _loc3 = _aTweens[_loc15];
            if (_loc3.targZID == _loc14)
            {
                for (var _loc13 in o.props)
                {
                    var _loc4 = _loc3.props;
                    for (var _loc12 in _loc4)
                    {
                        var _loc5 = _loc4[_loc12];
                        if (_loc5 == o.props[_loc13])
                        {
                            if (_nPlaying == 2)
                            {
                                if (_loc7 > 0)
                                {
                                    com.mosesSupposes.fuse.FuseKitCommon.error("120", this._sID(), _loc5);
                                } // end if
                            } // end if
                            _loc4.splice(Number(_loc12), 1);
                            if (_loc4.length == 0)
                            {
                                if (_loc3.event != undefined)
                                {
                                    this.fireEvents(_loc3.event, _loc3.event.s, _loc7);
                                } // end if
                                if (_loc5 == "__TweenedDelay")
                                {
                                    com.mosesSupposes.fuse.FuseItem._ZigoEngine.deinitializeTargets(_loc3.targ);
                                    delete _loc3.targ;
                                    for (var _loc10 in _loc3.bools)
                                    {
                                        for (var _loc9 in _loc3.actualTargs)
                                        {
                                            _loc3.actualTargs[_loc9][_loc10] = _loc3.bools[_loc10];
                                        } // end of for...in
                                    } // end of for...in
                                }
                                else
                                {
                                    var _loc6 = false;
                                    for (var _loc10 in _loc3.bools)
                                    {
                                        _loc3.targ[_loc10] = _loc3.bools[_loc10];
                                    } // end of for...in
                                    for (var _loc11 in _aTweens)
                                    {
                                        if (_loc11 != _loc15 && _aTweens[_loc11].targ == _loc3.targ)
                                        {
                                            _loc6 = true;
                                        } // end if
                                    } // end of for...in
                                    if (_loc6 == false)
                                    {
                                        _loc3.targ.removeListener(this);
                                    } // end if
                                } // end else if
                                if (_loc3.trigger == true)
                                {
                                    if (_bTrigger == false && o.isResume != true && _aTweens.length > 1)
                                    {
                                        _bTrigger = true;
                                        if (_loc7 == 3)
                                        {
                                            com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " trigger fired!");
                                        } // end if
                                        var breakChainInt;
                                        breakChainInt = setInterval(function (fi)
                                        {
                                            clearInterval(breakChainInt);
                                            fi.dispatchRequest("advance", [false]);
                                        }, 1, this);
                                    } // end if
                                } // end if
                                _aTweens.splice(Number(_loc15), 1);
                            } // end if
                        } // end if
                    } // end of for...in
                } // end of for...in
            } // end if
        } // end of for...in
        if (_aTweens.length == 0 && _nPlaying == 1 && o.isResume != true)
        {
            this.complete(_loc7);
        } // end if
    } // End of the function
    function onTweenInterrupt(o)
    {
        if (_nPlaying == -1)
        {
            return;
        } // end if
        var _loc3 = o.__zigoID__;
        var _loc7 = _global.com.mosesSupposes.fuse.Fuse;
        var _loc6 = _loc7 != undefined ? (_loc7.OUTPUT_LEVEL) : (com.mosesSupposes.fuse.FuseItem._ZigoEngine.OUTPUT_LEVEL);
        if (_loc6 == 3)
        {
            com.mosesSupposes.fuse.FuseKitCommon.output(this._sID() + " property interrupt caught! " + o.target + ",__zigoID__:" + _loc3 + "[" + o.props + "].");
        } // end if
        if (_loc3 == undefined || typeof(o.target) != "string")
        {
            this.onTweenEnd(o);
            return;
        } // end if
        for (var _loc4 in _aTweens)
        {
            if (_aTweens[_loc4].targZID == _loc3)
            {
                _aTweens.splice(Number(_loc4), 1);
            } // end if
        } // end of for...in
        if (_aTweens.length == 0 && _nPlaying == 1)
        {
            this.complete(_loc6);
        } // end if
    } // End of the function
    function complete(outputLevel)
    {
        var trigger = _bTrigger;
        this.stop();
        if (trigger != true)
        {
            if (outputLevel == 3)
            {
                com.mosesSupposes.fuse.FuseKitCommon.output("-" + this._sID() + " complete.");
            } // end if
        } // end if
        var breakChainInt;
        breakChainInt = setInterval(function (fi)
        {
            clearInterval(breakChainInt);
            fi.dispatchRequest("advance", [trigger]);
        }, 1, this);
    } // End of the function
    function parseClock(str)
    {
        if (str.indexOf(":") != 2)
        {
            com.mosesSupposes.fuse.FuseKitCommon.error("121");
            return (com.mosesSupposes.fuse.FuseItem._ZigoEngine.DURATION || 0);
        } // end if
        var _loc4 = 0;
        var _loc3 = str.split(":");
        _loc3.reverse();
        var _loc2;
        _loc2 = Math.abs(Number(_loc3[0]));
        if (String(_loc3[0]).length == 2 && _global.isNaN(Math.abs(Number(_loc3[0]))) == false)
        {
            _loc4 = _loc4 + _loc2 / 100;
        } // end if
        _loc2 = Math.abs(Number(_loc3[1]));
        if (String(_loc3[1]).length == 2 && _global.isNaN(Math.abs(Number(_loc3[1]))) == false && _loc2 < 60)
        {
            _loc4 = _loc4 + _loc2;
        } // end if
        _loc2 = Math.abs(Number(_loc3[2]));
        if (String(_loc3[2]).length == 2 && _global.isNaN(Math.abs(Number(_loc3[2]))) == false && _loc2 < 60)
        {
            _loc4 = _loc4 + _loc2 * 60;
        } // end if
        _loc2 = Math.abs(Number(_loc3[3]));
        if (String(_loc3[3]).length == 2 && _global.isNaN(Math.abs(Number(_loc3[3]))) == false && _loc2 < 24)
        {
            _loc4 = _loc4 + _loc2 * 3600;
        } // end if
        return (_loc4);
    } // End of the function
    function fireEvents(o, scope, outputLevel)
    {
        var s = o.s != null ? (o.s) : (scope);
        if (o.e == undefined)
        {
            if (typeof(o.cb) == "string" && o.cb.length > 0)
            {
                var parsed = _global.com.mosesSupposes.fuse.Shortcuts.parseStringTypeCallback(o.cb);
                if (parsed.func != undefined)
                {
                    this.fireEvents({s: parsed.scope, f: parsed.func, a: parsed.args});
                }
                else if (outputLevel > 0)
                {
                    com.mosesSupposes.fuse.FuseKitCommon.error("122");
                } // end if
            } // end else if
            if (o.f == undefined)
            {
                return;
            } // end if
            var f = o.f;
            if (typeof(o.f) == "string" && s[o.f] == undefined)
            {
                if (_global[o.f] != undefined)
                {
                    f = _global[o.f];
                } // end if
                if (_level0[o.f] != undefined)
                {
                    f = _level0[o.f];
                } // end if
            } // end if
            if (typeof(f) != "function")
            {
                if (typeof(s[o.f]) == "function")
                {
                    f = s[o.f];
                }
                else
                {
                    f = eval(o.f);
                } // end if
            } // end else if
            if (f == undefined)
            {
                if (outputLevel > 0)
                {
                    com.mosesSupposes.fuse.FuseKitCommon.error("123");
                } // end if
            }
            else
            {
                var args = o.a instanceof Function ? (o.a.apply(s)) : (o.a);
                if (args != undefined && !(args instanceof Array))
                {
                    args = [args];
                } // end if
                f.apply(s, args);
            } // end else if
        }
        else
        {
            var type = o.e instanceof Function ? (String(o.e.apply(s))) : (String(o.e));
            if (type != "undefined" && type.length > 0)
            {
                if ("|onStart|onStop|onPause|onResume|onAdvance|onComplete|".indexOf("|" + type + "|") > -1)
                {
                    if (outputLevel > 0)
                    {
                        com.mosesSupposes.fuse.FuseKitCommon.error("124", type);
                    } // end if
                }
                else
                {
                    var fuse = _global.com.mosesSupposes.fuse.Fuse.getInstance(this._nFuseID);
                    var evObj = o.ep instanceof Function ? (o.ep.apply(s)) : (o.ep);
                    if (evObj == null || typeof(evObj) != "object")
                    {
                        evObj = {};
                    } // end if
                    evObj.target = fuse;
                    evObj.type = type;
                    fuse.dispatchEvent.call(fuse, evObj);
                } // end else if
            }
            else if (outputLevel > 0)
            {
                com.mosesSupposes.fuse.FuseKitCommon.error("125", this._sID());
            } // end else if
        } // end else if
    } // End of the function
    static var registryKey = "fuseItem";
    static var ADD_UNDERSCORES = true;
    var _nPlaying = -1;
    var _bStartSet = false;
    var _bTrigger = false;
} // End of Class
