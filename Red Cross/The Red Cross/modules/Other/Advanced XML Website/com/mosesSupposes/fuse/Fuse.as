class com.mosesSupposes.fuse.Fuse extends Array
{
    var _nID, _aDefaultTargs, length, scope, _nIndex, __get__target, _oDel1, label, __get__state, dispatchEvent, __set__target, __get__currentIndex, __get__currentLabel, __get__id;
    function Fuse(action)
    {
        super();
        mx.events.EventDispatcher.initialize(this);
        _nID = com.mosesSupposes.fuse.Fuse.registerInstance(this);
        _sState = "stopped";
        _aDefaultTargs = new Array();
        if (arguments.length > 0)
        {
            splice.apply(this, new Array(0, 0).concat(arguments));
        } // end if
        var _loc4 = ["concat", "join", "sort", "sortOn"];
        for (var _loc5 in _loc4)
        {
            com.mosesSupposes.fuse.Fuse.prototype[_loc4[_loc5]] = function ()
            {
                if (com.mosesSupposes.fuse.Fuse.OUTPUT_LEVEL > 0)
                {
                    com.mosesSupposes.fuse.FuseKitCommon.error("105");
                } // end if
            };
        } // end of for...in
    } // End of the function
    function addEventListener(event, handler)
    {
    } // End of the function
    function removeEventListener(event, handler)
    {
    } // End of the function
    function destroy()
    {
        if (com.mosesSupposes.fuse.Fuse.OUTPUT_LEVEL > 1)
        {
            com.mosesSupposes.fuse.FuseKitCommon.output("-Fuse#" + String(_nID) + " destroy.");
        } // end if
        this.stop(true);
        this.splice(0, length);
        _aDefaultTargs = null;
        scope = null;
        _global.ASSetPropFlags(this, null, 0, 7);
        var _loc4 = _nID;
        for (var _loc3 in this)
        {
            delete this[_loc3];
        } // end of for...in
        com.mosesSupposes.fuse.Fuse.removeInstanceAt(_loc4, true);
        false;
        false;
    } // End of the function
    static function simpleSetup()
    {
        com.mosesSupposes.fuse.FuseKitCommon.error("101");
    } // End of the function
    static function getInstance(idOrLabel)
    {
        if (typeof(idOrLabel) == "number")
        {
            return (com.mosesSupposes.fuse.Fuse._aInstances[idOrLabel]);
        } // end if
        if (typeof(idOrLabel) == "string")
        {
            for (var _loc2 in com.mosesSupposes.fuse.Fuse._aInstances)
            {
                if ((com.mosesSupposes.fuse.Fuse)(com.mosesSupposes.fuse.Fuse._aInstances[_loc2]).label == idOrLabel)
                {
                    return (com.mosesSupposes.fuse.Fuse._aInstances[_loc2]);
                } // end if
            } // end of for...in
        } // end if
        return (null);
    } // End of the function
    static function getInstances(stateFilter, targets)
    {
        var _loc10 = stateFilter == null || stateFilter.toUpperCase() == "ALL";
        if (!(targets instanceof Array))
        {
            targets = arguments.slice(1);
        } // end if
        var _loc8 = [];
        for (var _loc11 in com.mosesSupposes.fuse.Fuse._aInstances)
        {
            var _loc5 = com.mosesSupposes.fuse.Fuse._aInstances[_loc11];
            if (com.mosesSupposes.fuse.Fuse._aInstances[_loc11] == null)
            {
                continue;
            } // end if
            if (_loc10 == false && _loc5.__get__state() != stateFilter)
            {
                continue;
            } // end if
            var _loc3 = targets.length == 0;
            if (_loc3 == false)
            {
                if (_loc3 == true)
                {
                    continue;
                } // end if
                var _loc2 = _loc5.getActiveTargets(true);
                for (var _loc7 in targets)
                {
                    for (var _loc6 in _loc2)
                    {
                        if (_loc2[_loc6] == targets[_loc7])
                        {
                            _loc3 = true;
                            break;
                        } // end if
                    } // end of for...in
                } // end of for...in
            } // end if
            if (_loc3 == true)
            {
                _loc8.unshift(_loc5);
            } // end if
        } // end of for...in
        return (_loc8);
    } // End of the function
    function get id()
    {
        return (_nID);
    } // End of the function
    function get state()
    {
        return (_sState);
    } // End of the function
    function get currentIndex()
    {
        return (_nIndex);
    } // End of the function
    function get currentLabel()
    {
        return ((com.mosesSupposes.fuse.FuseItem)(this[_nIndex]).getLabel());
    } // End of the function
    function get target()
    {
        return (_aDefaultTargs.length == 1 ? (_aDefaultTargs[0]) : (_aDefaultTargs));
    } // End of the function
    function set target(t)
    {
        delete this._aDefaultTargs;
        if (t != null)
        {
            this.addTarget(t);
        } // end if
        //return (this.target());
        null;
    } // End of the function
    function addTarget(t)
    {
        if (_aDefaultTargs == null)
        {
            _aDefaultTargs = [];
        } // end if
        if (arguments[0] instanceof Array)
        {
            arguments = arguments[0];
        } // end if
        for (var _loc5 in arguments)
        {
            var _loc3 = false;
            for (var _loc4 in _aDefaultTargs)
            {
                if (arguments[_loc5] == _aDefaultTargs[_loc4])
                {
                    _loc3 = true;
                    break;
                } // end if
            } // end of for...in
            if (_loc3 == false)
            {
                _aDefaultTargs.push(arguments[_loc5]);
            } // end if
        } // end of for...in
    } // End of the function
    function removeTarget(t)
    {
        if (_aDefaultTargs == null || _aDefaultTargs.length == 0)
        {
            return;
        } // end if
        if (arguments[0] instanceof Array)
        {
            arguments = arguments[0];
        } // end if
        for (var _loc4 in arguments)
        {
            for (var _loc3 in _aDefaultTargs)
            {
                if (arguments[_loc4] == _aDefaultTargs[_loc3])
                {
                    _aDefaultTargs.splice(Number(_loc3), 1);
                } // end if
            } // end of for...in
        } // end of for...in
    } // End of the function
    function getActiveTargets(includeDefaults)
    {
        if (_sState != "playing" && _sState != "paused")
        {
            return ([]);
        } // end if
        var _loc2;
        if (includeDefaults == true)
        {
            _loc2 = _aDefaultTargs.slice();
        }
        else
        {
            _loc2 = [];
        } // end else if
        return ((com.mosesSupposes.fuse.FuseItem)(this[_nIndex]).getActiveTargets(_loc2));
    } // End of the function
    function clone()
    {
        var _loc3 = [];
        for (var _loc2 = 0; _loc2 < length; ++_loc2)
        {
            _loc3.push((com.mosesSupposes.fuse.FuseItem)(this[_loc2]).getInitObj());
        } // end of for
        var _loc4 = new com.mosesSupposes.fuse.Fuse();
        _loc4.push.apply(_loc4, _loc3);
        _loc4.scope = scope;
        _loc4.__set__target(target);
        return (_loc4);
    } // End of the function
    function push()
    {
        splice.apply(this, new Array(length, 0).concat(arguments));
        return (length);
    } // End of the function
    function pushTween(targets, props, pEnd, seconds, ease, delay, callback)
    {
        this.push({__buildMode: true, tweenargs: arguments});
        return (length);
    } // End of the function
    function pop()
    {
        var _loc2 = (com.mosesSupposes.fuse.FuseItem)(this[length - 1]).getInitObj();
        this.splice(length - 1, 1);
        return (_loc2);
    } // End of the function
    function unshift()
    {
        splice.apply(this, new Array(0, 0).concat(arguments));
        return (length);
    } // End of the function
    function shift()
    {
        var _loc2 = (com.mosesSupposes.fuse.FuseItem)(this[0]).getInitObj();
        this.splice(0, 1);
        return (_loc2);
    } // End of the function
    function splice(startIndex, deleteCount)
    {
        this.stop(true);
        var _loc7 = Number(arguments.shift());
        if (_loc7 < 0)
        {
            _loc7 = length + _loc7;
        } // end if
        deleteCount = Number(arguments.shift());
        var _loc8 = new Array();
        for (var _loc5 = 0; _loc5 < arguments.length; ++_loc5)
        {
            var _loc6 = arguments[_loc5] instanceof com.mosesSupposes.fuse.Fuse ? (arguments[_loc5]) : (new com.mosesSupposes.fuse.FuseItem(_loc7 + _loc5, arguments[_loc5], _nID));
            this.addEventListener("onStop", _loc6);
            this.addEventListener("evtSetStart", _loc6);
            _loc8.push(_loc6);
        } // end of for
        var _loc4 = super.splice.apply(this, new Array(_loc7, deleteCount).concat(_loc8));
        for (var _loc9 in _loc4)
        {
            this.removeEventListener("onStop", _loc4[_loc9]);
            this.removeEventListener("evtSetStart", _loc4[_loc9]);
            if (_loc4[_loc9] instanceof com.mosesSupposes.fuse.Fuse)
            {
                (com.mosesSupposes.fuse.Fuse)(_loc4[_loc9]).removeEventListener("onComplete", _oDel1);
                continue;
            } // end if
            (com.mosesSupposes.fuse.FuseItem)(_loc4[_loc9]).destroy();
            delete this[(com.mosesSupposes.fuse.FuseItem)(_loc4[_loc9])._nItemID];
        } // end of for...in
        for (var _loc5 = 0; _loc5 < length; ++_loc5)
        {
            (com.mosesSupposes.fuse.FuseItem)(this[_loc5])._nItemID = _loc5;
        } // end of for
    } // End of the function
    function slice(indexA, indexB)
    {
        var _loc6 = super.slice(indexA, indexB);
        var _loc5 = new Array();
        for (var _loc4 = 0; _loc4 < arguments.length; ++_loc4)
        {
            _loc5.push((com.mosesSupposes.fuse.FuseItem)(this[_loc4]).getInitObj());
        } // end of for
        return (_loc5);
    } // End of the function
    function reverse()
    {
        this.stop(true);
        super.reverse();
        for (var _loc3 = 0; _loc3 < length; ++_loc3)
        {
            (com.mosesSupposes.fuse.FuseItem)(this[_loc3])._nItemID = _loc3;
        } // end of for
    } // End of the function
    function traceItems(indexA, indexB)
    {
        var _loc5 = "";
        var _loc4 = super.slice(indexA, indexB);
        _loc5 = _loc5 + ("-Fuse#" + String(_nID) + " traceItems:" + "\n----------\n");
        for (var _loc3 = 0; _loc3 < _loc4.length; ++_loc3)
        {
            if (_loc4[_loc3] instanceof com.mosesSupposes.fuse.Fuse)
            {
                _loc5 = _loc5 + ("-Fuse#" + String(_nID) + " #" + _nID + ">Item#" + _loc3 + ": [Nested Fuse] " + _loc4[_loc3] + "\n");
                continue;
            } // end if
            _loc5 = _loc5 + (_loc4[_loc3] + "\n");
        } // end of for
        _loc5 = _loc5 + "----------";
        com.mosesSupposes.fuse.FuseKitCommon.output(_loc5);
    } // End of the function
    function toString()
    {
        return ("Fuse#" + String(_nID) + (label != undefined ? (" \"" + label + "\"") : ("")) + " (contains " + length + " items)");
    } // End of the function
    function setStartProps(trueOrItemIDs)
    {
        var _loc8 = arguments.length == 0 || trueOrItemIDs === true || trueOrItemIDs == com.mosesSupposes.fuse.FuseKitCommon.ALL;
        this.dispatchEvent({target: this, type: "evtSetStart", all: _loc8, filter: trueOrItemIDs instanceof Array ? (trueOrItemIDs) : (arguments), curIndex: this.__get__state() == "playing" ? (_nIndex) : (-1), targs: _aDefaultTargs, scope: scope});
    } // End of the function
    function start(setStart)
    {
        com.mosesSupposes.fuse.Fuse.close();
        this.stop(true);
        _sState = "playing";
        if (length == 0)
        {
            this.advance(false, true);
        } // end if
        if (setStart != null && setStart != false)
        {
            setStartProps.apply(this, arguments);
        } // end if
        this.dispatchEvent({target: this, type: "onStart"});
        if (com.mosesSupposes.fuse.Fuse.OUTPUT_LEVEL > 1)
        {
            com.mosesSupposes.fuse.FuseKitCommon.output("-Fuse#" + String(_nID) + "  start.");
        } // end if
        this.playCurrentItem();
    } // End of the function
    function stop()
    {
        if (_sState != "stopped")
        {
            for (var _loc3 = 0; _loc3 < length; ++_loc3)
            {
                if (_loc3 == _nIndex || (com.mosesSupposes.fuse.FuseItem)(this[_loc3]).hasTriggerFired() == true)
                {
                    (com.mosesSupposes.fuse.FuseItem)(this[_loc3]).stop();
                } // end if
            } // end of for
        }
        else
        {
            arguments[0] = true;
        } // end else if
        if (this[_nIndex] instanceof com.mosesSupposes.fuse.Fuse)
        {
            (com.mosesSupposes.fuse.Fuse)(this[_nIndex]).removeEventListener("onComplete", _oDel1);
        } // end if
        _sState = "stopped";
        if (!(arguments[0] === true && _sState == "stopped"))
        {
            this.dispatchEvent({target: this, type: "onStop"});
            if (com.mosesSupposes.fuse.Fuse.OUTPUT_LEVEL > 1)
            {
                com.mosesSupposes.fuse.FuseKitCommon.output("-Fuse#" + String(_nID) + "  stop.");
            } // end if
        } // end if
        _nIndex = 0;
        clearInterval(_nDelay);
        _nTimeCache = _nDelay = -1;
    } // End of the function
    function skipTo(indexOrLabel)
    {
        com.mosesSupposes.fuse.Fuse.close();
        var _loc5;
        if (typeof(indexOrLabel) == "string")
        {
            _loc5 = -1;
            for (var _loc4 = 0; _loc4 < length; ++_loc4)
            {
                if ((com.mosesSupposes.fuse.FuseItem)(this[_loc4]).getLabel() == String(indexOrLabel))
                {
                    _loc5 = _loc4;
                    break;
                } // end if
            } // end of for
            if (_loc5 == -1)
            {
                if (com.mosesSupposes.fuse.Fuse.OUTPUT_LEVEL > 0)
                {
                    com.mosesSupposes.fuse.FuseKitCommon.error("102", String(indexOrLabel));
                } // end if
            } // end if
        }
        else
        {
            _loc5 = Number(indexOrLabel);
        } // end else if
        if (_global.isNaN(_loc5) == true || Math.abs(_loc5) >= length)
        {
            if (com.mosesSupposes.fuse.Fuse.OUTPUT_LEVEL > 0)
            {
                com.mosesSupposes.fuse.FuseKitCommon.error("103", String(indexOrLabel));
            } // end if
        } // end if
        if (_loc5 < 0)
        {
            _loc5 = Math.max(0, length + _loc5);
        } // end if
        if (_loc5 == _nIndex && arguments[1] === true)
        {
            if (com.mosesSupposes.fuse.Fuse.OUTPUT_LEVEL > 0)
            {
                com.mosesSupposes.fuse.FuseKitCommon.error("104", String(indexOrLabel), _nIndex);
            } // end if
        } // end if
        if (this[_nIndex] instanceof com.mosesSupposes.fuse.Fuse)
        {
            (com.mosesSupposes.fuse.Fuse)(this[_nIndex]).removeEventListener("onComplete", _oDel1);
        } // end if
        (com.mosesSupposes.fuse.FuseItem)(this[_nIndex]).stop();
        _nIndex = _loc5;
        var _loc7 = _sState;
        _sState = "playing";
        if (_loc7 == "stopped")
        {
            this.dispatchEvent({target: this, type: "onStart"});
        } // end if
        this.playCurrentItem();
        if (com.mosesSupposes.fuse.Fuse.OUTPUT_LEVEL > 1)
        {
            com.mosesSupposes.fuse.FuseKitCommon.output("skipTo:" + _loc5);
        } // end if
    } // End of the function
    function pause()
    {
        if (_sState == "playing")
        {
            (com.mosesSupposes.fuse.FuseItem)(this[_nIndex]).pause();
            if (_nTimeCache != -1)
            {
                _nTimeCache = _nTimeCache - getTimer();
                clearInterval(_nDelay);
            } // end if
            _sState = "paused";
            if (com.mosesSupposes.fuse.Fuse.OUTPUT_LEVEL > 1)
            {
                com.mosesSupposes.fuse.FuseKitCommon.output("-Fuse#" + String(_nID) + "  pause.");
            } // end if
            this.dispatchEvent({target: this, type: "onPause"});
        } // end if
    } // End of the function
    function resume()
    {
        if (_sState != "paused")
        {
            return;
        } // end if
        com.mosesSupposes.fuse.Fuse.close();
        _sState = "playing";
        if (com.mosesSupposes.fuse.Fuse.OUTPUT_LEVEL > 1)
        {
            com.mosesSupposes.fuse.FuseKitCommon.output("-Fuse#" + String(_nID) + "  resume.");
        } // end if
        this.dispatchEvent({target: this, type: "onResume"});
        if (_nTimeCache != -1)
        {
            clearInterval(_nDelay);
            _nTimeCache = getTimer() + _nTimeCache;
            _nDelay = setInterval(mx.utils.Delegate.create(this, playCurrentItem), _nTimeCache, true);
        } // end if
        (com.mosesSupposes.fuse.FuseItem)(this[_nIndex]).pause(true);
    } // End of the function
    function advance(wasTriggered, silentStop)
    {
        var _loc3 = false;
        if (_nIndex == length - 1)
        {
            for (var _loc2 = length - 1; _loc2 > -1; --_loc2)
            {
                if ((com.mosesSupposes.fuse.FuseItem)(this[_loc2])._nPlaying > -1)
                {
                    return;
                } // end if
            } // end of for
            _loc3 = true;
        } // end if
        if (wasTriggered == true && _loc3 == false)
        {
            return;
        } // end if
        if (this[_nIndex] instanceof com.mosesSupposes.fuse.Fuse)
        {
            (com.mosesSupposes.fuse.Fuse)(this[_nIndex]).removeEventListener("onComplete", _oDel1);
        } // end if
        if (++_nIndex >= length)
        {
            this.stop(silentStop);
            if (com.mosesSupposes.fuse.Fuse.OUTPUT_LEVEL > 1)
            {
                com.mosesSupposes.fuse.FuseKitCommon.output("-Fuse#" + String(_nID) + " complete.");
            } // end if
            this.dispatchEvent({target: this, type: "onComplete"});
            if (autoClear == true || autoClear !== false && com.mosesSupposes.fuse.Fuse.AUTOCLEAR == true)
            {
                this.destroy();
            } // end if
            return;
        } // end if
        if (com.mosesSupposes.fuse.Fuse.OUTPUT_LEVEL > 1)
        {
            com.mosesSupposes.fuse.FuseKitCommon.output("-Fuse#" + String(_nID) + " advance: " + _nIndex);
        } // end if
        this.dispatchEvent({target: this, type: "onAdvance"});
        this.playCurrentItem();
    } // End of the function
    function playCurrentItem(postDelay)
    {
        clearInterval(_nDelay);
        if (postDelay !== true)
        {
            var _loc2 = (com.mosesSupposes.fuse.FuseItem)(this[_nIndex]).evalDelay(scope) || 0;
            if (_loc2 > 0)
            {
                _nTimeCache = getTimer() + _loc2 * 1000;
                _nDelay = setInterval(mx.utils.Delegate.create(this, playCurrentItem), _loc2 * 1000, true);
                return;
            } // end if
        } // end if
        _nTimeCache = _nDelay = -1;
        if (this[_nIndex] instanceof com.mosesSupposes.fuse.Fuse)
        {
            if (_oDel1 == null)
            {
                _oDel1 = mx.utils.Delegate.create(this, advance);
            } // end if
            (com.mosesSupposes.fuse.Fuse)(this[_nIndex]).addEventListener("onComplete", _oDel1);
        } // end if
        var _loc3 = (com.mosesSupposes.fuse.FuseItem)(this[_nIndex]).startItem(_aDefaultTargs, scope);
        if (com.mosesSupposes.fuse.Fuse.OUTPUT_LEVEL > 1)
        {
            com.mosesSupposes.fuse.FuseKitCommon.output("-Fuse#" + String(_nID) + " props tweened: " + _loc3);
        } // end if
    } // End of the function
    function evtSetStart(o)
    {
        setStartProps.apply(this, o.filter);
    } // End of the function
    function startItem(targs, scope)
    {
        if (this.__get__target() == null)
        {
            this.__set__target(targs);
        } // end if
        if (scope == null)
        {
            scope = scope;
        } // end if
        this.start();
    } // End of the function
    static function open(fuseOrID)
    {
        var _loc3 = _global.com.mosesSupposes.fuse.ZigoEngine;
        if (_loc3 == undefined)
        {
            com.mosesSupposes.fuse.FuseKitCommon.error("106");
            return (null);
        }
        else
        {
            _loc3.register(com.mosesSupposes.fuse.Fuse, com.mosesSupposes.fuse.FuseItem);
        } // end else if
        if (com.mosesSupposes.fuse.Fuse._oBuildMode == null)
        {
            _oBuildMode = {curID: -1, prevID: -1, curGroup: null};
        }
        else if (com.mosesSupposes.fuse.Fuse._oBuildMode != null && com.mosesSupposes.fuse.Fuse._oBuildMode.curID > -1)
        {
            com.mosesSupposes.fuse.Fuse.close();
        } // end else if
        if (fuseOrID != null)
        {
            if (fuseOrID instanceof com.mosesSupposes.fuse.Fuse)
            {
                com.mosesSupposes.fuse.Fuse._oBuildMode.curID = fuseOrID.id;
            }
            else if (com.mosesSupposes.fuse.Fuse.getInstance(fuseOrID) != null)
            {
                com.mosesSupposes.fuse.Fuse._oBuildMode.curID = com.mosesSupposes.fuse.Fuse.getInstance(fuseOrID).id;
            }
            else
            {
                com.mosesSupposes.fuse.FuseKitCommon.error("107");
                return (null);
            } // end else if
        }
        else
        {
            com.mosesSupposes.fuse.Fuse._oBuildMode.curID = new com.mosesSupposes.fuse.Fuse().id;
        } // end else if
        com.mosesSupposes.fuse.Fuse._oBuildMode.prevID = com.mosesSupposes.fuse.Fuse._oBuildMode.curID;
        return (com.mosesSupposes.fuse.Fuse.getInstance(com.mosesSupposes.fuse.Fuse._oBuildMode.curID));
    } // End of the function
    static function openGroup(fuseOrID)
    {
        if (!(com.mosesSupposes.fuse.Fuse._oBuildMode != null && com.mosesSupposes.fuse.Fuse._oBuildMode.curID > -1))
        {
            com.mosesSupposes.fuse.Fuse.open(fuseOrID);
        }
        else if (com.mosesSupposes.fuse.Fuse._oBuildMode.curGroup != null)
        {
            com.mosesSupposes.fuse.Fuse.closeGroup();
        } // end else if
        com.mosesSupposes.fuse.Fuse._oBuildMode.curGroup = new Array();
        return (com.mosesSupposes.fuse.Fuse.getInstance(com.mosesSupposes.fuse.Fuse._oBuildMode.curID));
    } // End of the function
    static function closeGroup()
    {
        if (com.mosesSupposes.fuse.Fuse._oBuildMode.curGroup == null || !(com.mosesSupposes.fuse.Fuse._oBuildMode != null && com.mosesSupposes.fuse.Fuse._oBuildMode.curID > -1))
        {
            return;
        } // end if
        com.mosesSupposes.fuse.Fuse.getInstance(com.mosesSupposes.fuse.Fuse._oBuildMode.curID).push(com.mosesSupposes.fuse.Fuse._oBuildMode.curGroup);
        com.mosesSupposes.fuse.Fuse._oBuildMode.curGroup = null;
    } // End of the function
    static function close()
    {
        if (!(com.mosesSupposes.fuse.Fuse._oBuildMode != null && com.mosesSupposes.fuse.Fuse._oBuildMode.curID > -1))
        {
            return;
        } // end if
        if (com.mosesSupposes.fuse.Fuse._oBuildMode.curGroup != null)
        {
            com.mosesSupposes.fuse.Fuse.closeGroup();
        } // end if
        com.mosesSupposes.fuse.Fuse._oBuildMode.curID = -1;
    } // End of the function
    static function closeAndStart(setStart)
    {
        if (!(com.mosesSupposes.fuse.Fuse._oBuildMode != null && com.mosesSupposes.fuse.Fuse._oBuildMode.curID > -1))
        {
            return;
        } // end if
        var _loc2 = com.mosesSupposes.fuse.Fuse.getInstance(com.mosesSupposes.fuse.Fuse._oBuildMode.curID);
        com.mosesSupposes.fuse.Fuse.close();
        _loc2.start.apply(_loc2, arguments);
    } // End of the function
    static function startRecent(setStart)
    {
        var _loc2 = com.mosesSupposes.fuse.Fuse.getInstance(com.mosesSupposes.fuse.Fuse._oBuildMode.prevID);
        if (_loc2 != null)
        {
            _loc2.start.apply(_loc2, arguments);
        }
        else
        {
            com.mosesSupposes.fuse.FuseKitCommon.error("108");
        } // end else if
    } // End of the function
    static function addCommand(commandOrScope, indexOrFunc, argument)
    {
        if (!(com.mosesSupposes.fuse.Fuse._oBuildMode != null && com.mosesSupposes.fuse.Fuse._oBuildMode.curID > -1))
        {
            return;
        } // end if
        var _loc3 = com.mosesSupposes.fuse.Fuse._oBuildMode.curGroup != null ? (com.mosesSupposes.fuse.Fuse._oBuildMode.curGroup) : (com.mosesSupposes.fuse.Fuse.getInstance(com.mosesSupposes.fuse.Fuse._oBuildMode.curID));
        if (typeof(commandOrScope) == "string")
        {
            if (com.mosesSupposes.fuse.Fuse._oBuildMode.curGroup != null && commandOrScope != "delay")
            {
                com.mosesSupposes.fuse.FuseKitCommon.error("109", String(commandOrScope));
                return;
            } // end if
            var _loc4 = "|delay|start|stop|pause|resume|skipTo|setStartProps|";
            if (_loc4.indexOf("|" + commandOrScope + "|") == -1 || (commandOrScope == "skipTo" || commandOrScope == "delay") && indexOrFunc == undefined)
            {
                if (com.mosesSupposes.fuse.Fuse.OUTPUT_LEVEL > 0)
                {
                    com.mosesSupposes.fuse.FuseKitCommon.error("110", String(commandOrScope));
                } // end if
            }
            else
            {
                _loc3.push({__buildMode: true, command: commandOrScope, commandargs: indexOrFunc});
            } // end else if
        }
        else
        {
            _loc3.push({__buildMode: true, scope: commandOrScope, func: indexOrFunc, args: arguments.slice(2)});
        } // end else if
    } // End of the function
    static function addBuildItem(args)
    {
        if (!(com.mosesSupposes.fuse.Fuse._oBuildMode != null && com.mosesSupposes.fuse.Fuse._oBuildMode.curID > -1))
        {
            return (false);
        } // end if
        var _loc1 = com.mosesSupposes.fuse.Fuse._oBuildMode.curGroup != null ? (com.mosesSupposes.fuse.Fuse._oBuildMode.curGroup) : (com.mosesSupposes.fuse.Fuse.getInstance(com.mosesSupposes.fuse.Fuse._oBuildMode.curID));
        if (args.length == 1 && typeof(args[0]) == "object")
        {
            _loc1.push(args[0]);
        }
        else
        {
            _loc1.push({__buildMode: true, tweenargs: args});
        } // end else if
        return (true);
    } // End of the function
    static function registerInstance(s)
    {
        if (com.mosesSupposes.fuse.Fuse._aInstances == null)
        {
            _aInstances = new Array();
        } // end if
        return (com.mosesSupposes.fuse.Fuse._aInstances.push(s) - 1);
    } // End of the function
    static function removeInstanceAt(id, isDestroyCall)
    {
        if (isDestroyCall != true)
        {
            (com.mosesSupposes.fuse.Fuse)(com.mosesSupposes.fuse.Fuse._aInstances[id]).destroy();
        } // end if
        delete com.mosesSupposes.fuse.Fuse._aInstances[id];
    } // End of the function
    static var registryKey = "fuse";
    static var VERSION = com.mosesSupposes.fuse.FuseKitCommon.VERSION;
    static var OUTPUT_LEVEL = 1;
    static var AUTOCLEAR = false;
    var autoClear = false;
    var _sState = "stopped";
    var _nDelay = -1;
    var _nTimeCache = -1;
    static var _aInstances = null;
    static var _oBuildMode = null;
} // End of Class
