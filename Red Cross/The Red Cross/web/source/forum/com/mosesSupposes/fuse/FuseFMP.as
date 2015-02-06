class com.mosesSupposes.fuse.FuseFMP
{
    static var $fclasses, $shortcuts, $gro, $sro;
    function FuseFMP()
    {
    } // End of the function
    static function simpleSetup()
    {
        com.mosesSupposes.fuse.FuseFMP.initialize(MovieClip.prototype, Button.prototype, TextField.prototype);
        _global.FuseFMP = com.mosesSupposes.fuse.FuseFMP;
        for (var _loc2 in com.mosesSupposes.fuse.FuseFMP.$fclasses)
        {
            _global[_loc2] = com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc2];
        } // end of for...in
    } // End of the function
    static function initialize(target)
    {
        if (com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
        {
            $shortcuts = {getFilterName: function (f)
            {
                return (com.mosesSupposes.fuse.FuseFMP.getFilterName(f));
            }, getFilterIndex: function (f)
            {
                return (com.mosesSupposes.fuse.FuseFMP.getFilterIndex(this, f));
            }, getFilter: function (f, createNew)
            {
                return (com.mosesSupposes.fuse.FuseFMP.getFilter(this, f, createNew));
            }, writeFilter: function (f, pObj)
            {
                return (com.mosesSupposes.fuse.FuseFMP.writeFilter(this, f, pObj));
            }, removeFilter: function (f)
            {
                return (com.mosesSupposes.fuse.FuseFMP.removeFilter(this, f));
            }, getFilterProp: function (prop, createNew)
            {
                return (com.mosesSupposes.fuse.FuseFMP.getFilterProp(this, prop, createNew));
            }, setFilterProp: function (prop, v)
            {
                com.mosesSupposes.fuse.FuseFMP.setFilterProp(this, prop, v);
            }, setFilterProps: function (fOrPObj, pObj)
            {
                com.mosesSupposes.fuse.FuseFMP.setFilterProps(this, fOrPObj, pObj);
            }, traceAllFilters: function ()
            {
                com.mosesSupposes.fuse.FuseFMP.traceAllFilters();
            }};
            $fclasses = {BevelFilter: flash.filters.BevelFilter, BlurFilter: flash.filters.BlurFilter, ColorMatrixFilter: flash.filters.ColorMatrixFilter, ConvolutionFilter: flash.filters.ConvolutionFilter, DisplacementMapFilter: flash.filters.DisplacementMapFilter, DropShadowFilter: flash.filters.DropShadowFilter, GlowFilter: flash.filters.GlowFilter, GradientBevelFilter: flash.filters.GradientBevelFilter, GradientGlowFilter: flash.filters.GradientGlowFilter};
            $gro = {__resolve: function (name)
            {
                var _loc4 = function ()
                {
                    var _loc3 = this;
                    if (_loc3.filters != undefined)
                    {
                        var _loc2 = name.split("_");
                        if (_loc2[1] == "blur")
                        {
                            _loc2[1] = "blurX";
                        } // end if
                        return (com.mosesSupposes.fuse.FuseFMP.getFilter(this, _loc2[0] + "Filter", false)[_loc2[1]]);
                    } // end if
                };
                return (_loc4);
            }};
            $sro = {__resolve: function (name)
            {
                var _loc3 = function (val)
                {
                    var _loc2 = this;
                    if (_loc2.filters != undefined)
                    {
                        com.mosesSupposes.fuse.FuseFMP.setFilterProp(this, name, val);
                    } // end if
                };
                return (_loc3);
            }};
        } // end if
        if (arguments[0] == null)
        {
            return;
        } // end if
        var _loc6 = [MovieClip, Button, TextField];
        for (var _loc13 in arguments)
        {
            var _loc7 = false;
            for (var _loc10 in _loc6)
            {
                if (arguments[_loc13] instanceof _loc6[_loc10] || arguments[_loc13] == Function(_loc6[_loc10]).prototype)
                {
                    _loc7 = true;
                    break;
                } // end if
            } // end of for...in
            if (!_loc7)
            {
                com.mosesSupposes.fuse.FuseKitCommon.error("201", _loc13);
                continue;
            } // end if
            for (var _loc11 in com.mosesSupposes.fuse.FuseFMP.$fclasses)
            {
                var _loc5 = new com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc11]();
                for (var _loc8 in _loc5)
                {
                    if (typeof(_loc5[_loc8]) == "function")
                    {
                        continue;
                    } // end if
                    var _loc4 = _loc11.substr(0, -6) + "_" + _loc8;
                    arguments[_loc13].addProperty(_loc4, com.mosesSupposes.fuse.FuseFMP.$gro[_loc4], com.mosesSupposes.fuse.FuseFMP.$sro[_loc4]);
                    _global.ASSetPropFlags(arguments[_loc13], _loc4, 3, 1);
                    if (_loc8 == "blurX")
                    {
                        _loc4 = _loc4.slice(0, -1);
                        arguments[_loc13].addProperty(_loc4, com.mosesSupposes.fuse.FuseFMP.$gro[_loc4], com.mosesSupposes.fuse.FuseFMP.$sro[_loc4]);
                        _global.ASSetPropFlags(arguments[_loc13], _loc4, 3, 1);
                    } // end if
                } // end of for...in
            } // end of for...in
            for (var _loc9 in com.mosesSupposes.fuse.FuseFMP.$shortcuts)
            {
                arguments[_loc13][_loc9] = com.mosesSupposes.fuse.FuseFMP.$shortcuts[_loc9];
                _global.ASSetPropFlags(arguments[_loc13], _loc9, 7, 1);
            } // end of for...in
        } // end of for...in
    } // End of the function
    static function deinitialize()
    {
        if (com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
        {
            return;
        } // end if
        if (arguments.length == 0)
        {
            arguments.push(MovieClip.prototype, Button.prototype, TextField.prototype);
        } // end if
        for (var _loc8 in arguments)
        {
            for (var _loc7 in com.mosesSupposes.fuse.FuseFMP.$fclasses)
            {
                var _loc4 = new com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc7]();
                for (var _loc5 in _loc4)
                {
                    if (typeof(_loc4[_loc5]) == "function")
                    {
                        continue;
                    } // end if
                    var _loc3 = _loc7.substr(0, -6) + "_" + _loc5;
                    _global.ASSetPropFlags(arguments[_loc8], _loc3, 0, 2);
                    arguments[_loc8].addProperty(_loc3, null, null);
                    delete arguments[_loc8][_loc3];
                } // end of for...in
            } // end of for...in
            for (var _loc6 in com.mosesSupposes.fuse.FuseFMP.$shortcuts)
            {
                _global.ASSetPropFlags(arguments[_loc8], _loc6, 0, 2);
                delete arguments[_loc8][_loc6];
            } // end of for...in
        } // end of for...in
    } // End of the function
    static function getFilterName($myFilter)
    {
        if (com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
        {
            com.mosesSupposes.fuse.FuseFMP.initialize(null);
        } // end if
        for (var _loc1 in com.mosesSupposes.fuse.FuseFMP.$fclasses)
        {
            if ($myFilter.__proto__ == Function(com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc1]).prototype)
            {
                return (_loc1);
            } // end if
        } // end of for...in
        return (null);
    } // End of the function
    static function getFilterIndex($obj, $myFilter)
    {
        if (com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
        {
            com.mosesSupposes.fuse.FuseFMP.initialize(null);
        } // end if
        $myFilter = com.mosesSupposes.fuse.FuseFMP.$getInstance($myFilter);
        if ($myFilter === null)
        {
            return (-1);
        } // end if
        var _loc2 = $obj.filters;
        for (var _loc1 = 0; _loc1 < _loc2.length; ++_loc1)
        {
            if (_loc2[_loc1].__proto__ == $myFilter.__proto__)
            {
                return (_loc1);
            } // end if
        } // end of for
        return (-1);
    } // End of the function
    static function getFilter($obj, $myFilter, $createNew)
    {
        var _loc1 = com.mosesSupposes.fuse.FuseFMP.getFilterIndex($obj, $myFilter);
        if (_loc1 == -1)
        {
            if ($createNew != true)
            {
                return (null);
            } // end if
            _loc1 = com.mosesSupposes.fuse.FuseFMP.writeFilter($obj, $myFilter);
            if (_loc1 == -1)
            {
                return (null);
            } // end if
        } // end if
        return ($obj.filters[_loc1]);
    } // End of the function
    static function writeFilter($obj, $myFilter, $propsObj)
    {
        if (com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
        {
            com.mosesSupposes.fuse.FuseFMP.initialize(null);
        } // end if
        $myFilter = com.mosesSupposes.fuse.FuseFMP.$getInstance($myFilter);
        if ($myFilter === null)
        {
            return (-1);
        } // end if
        var _loc4 = $obj.filters;
        var _loc2 = com.mosesSupposes.fuse.FuseFMP.getFilterIndex($obj, $myFilter);
        if (_loc2 == -1)
        {
            _loc4.push($myFilter);
        }
        else
        {
            _loc4[_loc2] = $myFilter;
        } // end else if
        $obj.filters = _loc4;
        if (typeof($propsObj) == "object")
        {
            com.mosesSupposes.fuse.FuseFMP.setFilterProps($obj, $myFilter, $propsObj);
        } // end if
        _loc2 = com.mosesSupposes.fuse.FuseFMP.getFilterIndex($obj, $myFilter);
        return (_loc2);
    } // End of the function
    static function removeFilter($obj, $myFilter)
    {
        if (com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
        {
            com.mosesSupposes.fuse.FuseFMP.initialize(null);
        } // end if
        $myFilter = com.mosesSupposes.fuse.FuseFMP.$getInstance($myFilter);
        var _loc2 = $obj.filters;
        var _loc1 = com.mosesSupposes.fuse.FuseFMP.getFilterIndex($obj, $myFilter);
        if (_loc1 == -1)
        {
            return (false);
        } // end if
        _loc2.splice(_loc1, 1);
        $obj.filters = _loc2;
        return (true);
    } // End of the function
    static function getFilterProp($obj, $filtername, $createNew)
    {
        var _loc1 = $filtername.split("_");
        if (_loc1[1] == "blur")
        {
            _loc1[1] = "blurX";
        } // end if
        return (com.mosesSupposes.fuse.FuseFMP.getFilter($obj, _loc1[0] + "Filter", $createNew)[_loc1[1]]);
    } // End of the function
    static function setFilterProp($obj, $propname, $val)
    {
        if (com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
        {
            com.mosesSupposes.fuse.FuseFMP.initialize(null);
        } // end if
        var _loc7 = $propname.split("_");
        var _loc8 = _loc7[0] + "Filter";
        if (com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc8] == undefined)
        {
            return;
        } // end if
        var _loc2 = new com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc8]();
        var _loc6 = _loc7[1];
        var _loc3 = $obj.filters.length || 0;
        while (--_loc3 > -1)
        {
            var _loc1 = $obj.filters[_loc3];
            if (_loc1.__proto__ == _loc2.__proto__)
            {
                _loc2 = _loc1;
                break;
            } // end if
        } // end while
        if (_loc6 == "blur")
        {
            _loc2.blurX = $val;
            _loc2.blurY = $val;
        }
        else
        {
            if (_loc6.indexOf("lor") > -1)
            {
                if (typeof($val) == "string" && _loc6.charAt(2) != "l")
                {
                    if ($val.charAt(0) == "#")
                    {
                        $val = $val.slice(1);
                    } // end if
                    $val = $val.charAt(1).toLowerCase() != "x" ? (Number("0x" + $val)) : (Number($val));
                } // end if
            } // end if
            _loc2[_loc6] = $val;
        } // end else if
        if (_loc3 == -1)
        {
            $obj.filters = [_loc2];
        }
        else
        {
            var _loc9 = $obj.filters;
            _loc9[_loc3] = _loc2;
            $obj.filters = _loc9;
        } // end else if
    } // End of the function
    static function setFilterProps($obj, $filterOrPropsObj, $propsObj)
    {
        if (com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
        {
            com.mosesSupposes.fuse.FuseFMP.initialize(null);
        } // end if
        if (!($obj instanceof Array))
        {
            $obj = [$obj];
        } // end if
        var _loc4 = new Object();
        var _loc3;
        var _loc2;
        if (arguments.length == 3)
        {
            for (var _loc12 in $obj)
            {
                var _loc5 = com.mosesSupposes.fuse.FuseFMP.getFilter($obj[_loc12], $filterOrPropsObj, true);
                if (_loc5 == null)
                {
                    continue;
                } // end if
                var _loc8 = com.mosesSupposes.fuse.FuseFMP.getFilterName(_loc5).substr(0, -6) + "_";
                for (var _loc3 in $propsObj)
                {
                    _loc4[_loc3] = $propsObj[_loc3];
                } // end of for...in
                for (var _loc3 in _loc4)
                {
                    _loc2 = _loc4[_loc3];
                    if (_loc3.indexOf(_loc8) == 0)
                    {
                        _loc3 = _loc3.slice(_loc8.length);
                    } // end if
                    if (_loc3 == "blur")
                    {
                        (flash.filters.BlurFilter)(_loc5).blurX = Number(_loc2, flash.filters.BlurFilter)(_loc5).blurY = Number(_loc2);
                        continue;
                    } // end if
                    if (_loc3.indexOf("lor") > -1 && _loc3.charAt(2) != "l" && typeof(_loc2) == "string")
                    {
                        if (_loc2.charAt(0) == "#")
                        {
                            _loc2 = _loc2.slice(1);
                        } // end if
                        _loc2 = _loc2.charAt(1).toLowerCase() != "x" ? (Number("0x" + _loc2)) : (Number(_loc2));
                        continue;
                    } // end if
                    _loc5[_loc3] = _loc2;
                } // end of for...in
                com.mosesSupposes.fuse.FuseFMP.writeFilter($obj[_loc12], _loc5);
            } // end of for...in
        }
        else if (typeof($filterOrPropsObj) == "object")
        {
            $propsObj = $filterOrPropsObj;
            for (var _loc3 in $propsObj)
            {
                var _loc9 = _loc3.split("_");
                var _loc10 = _loc9[0] + "Filter";
                if (com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc10] == undefined)
                {
                    continue;
                } // end if
                if (_loc4[_loc10] == undefined)
                {
                    _loc4[_loc10] = {};
                } // end if
                if (_loc9[1] == "blur")
                {
                    (flash.filters.BlurFilter)(_loc4[_loc10]).blurX = $propsObj[_loc3];
                    (flash.filters.BlurFilter)(_loc4[_loc10]).blurY = $propsObj[_loc3];
                    continue;
                } // end if
                _loc4[_loc10][_loc9[1]] = $propsObj[_loc3];
            } // end of for...in
            for (var _loc12 in $obj)
            {
                for (var _loc10 in _loc4)
                {
                    _loc5 = com.mosesSupposes.fuse.FuseFMP.getFilter($obj[_loc12], _loc10, true);
                    if (_loc5 == null)
                    {
                        continue;
                    } // end if
                    for (var _loc3 in _loc4[_loc10])
                    {
                        _loc2 = _loc4[_loc10][_loc3];
                        if (_loc3.indexOf("lor") > -1 && _loc3.charAt(2) != "l" && typeof(_loc2) == "string")
                        {
                            if (_loc2.charAt(0) == "#")
                            {
                                _loc2 = _loc2.slice(1);
                            } // end if
                            _loc2 = _loc2.charAt(1).toLowerCase() != "x" ? (Number("0x" + _loc2)) : (Number(_loc2));
                        } // end if
                        _loc5[_loc3] = _loc2;
                    } // end of for...in
                    com.mosesSupposes.fuse.FuseFMP.writeFilter($obj[_loc12], _loc5);
                } // end of for...in
            } // end of for...in
        } // end else if
    } // End of the function
    static function getAllShortcuts()
    {
        if (com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
        {
            com.mosesSupposes.fuse.FuseFMP.initialize(null);
        } // end if
        var _loc2 = [];
        for (var _loc4 in com.mosesSupposes.fuse.FuseFMP.$fclasses)
        {
            var _loc1 = new com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc4]();
            for (var _loc3 in _loc1)
            {
                if (typeof(_loc1[_loc3]) == "function")
                {
                    continue;
                } // end if
                _loc2.push(_loc4.substr(0, -6) + "_" + _loc3);
                if (_loc3 == "blurX")
                {
                    _loc2.push(_loc4.substr(0, -6) + "_blur");
                } // end if
            } // end of for...in
        } // end of for...in
        return (_loc2);
    } // End of the function
    static function traceAllFilters()
    {
        if (com.mosesSupposes.fuse.FuseFMP.$fclasses == undefined)
        {
            com.mosesSupposes.fuse.FuseFMP.initialize(null);
        } // end if
        var _loc1 = "------ FuseFMP filter properties ------\n";
        for (var _loc4 in com.mosesSupposes.fuse.FuseFMP.$fclasses)
        {
            _loc1 = _loc1 + _loc4;
            var _loc2 = new com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc4]();
            for (var _loc3 in _loc2)
            {
                if (typeof(_loc2[_loc3]) == "function")
                {
                    continue;
                } // end if
                _loc1 = _loc1 + ("\t- " + _loc4.substr(0, -6) + "_" + _loc3);
                if (_loc3 == "blurX")
                {
                    _loc1 = _loc1 + ("\t- " + _loc4.substr(0, -6) + "_blur");
                } // end if
            } // end of for...in
            _loc1 = _loc1 + "\n";
        } // end of for...in
        com.mosesSupposes.fuse.FuseKitCommon.output(_loc1);
    } // End of the function
    static function $getInstance($myFilter)
    {
        if ($myFilter instanceof flash.filters.BitmapFilter)
        {
            return ((flash.filters.BitmapFilter)($myFilter));
        } // end if
        if (typeof($myFilter) == "function")
        {
            for (var _loc3 in com.mosesSupposes.fuse.FuseFMP.$fclasses)
            {
                if ($myFilter == com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc3])
                {
                    return (new com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc3]());
                } // end if
            } // end of for...in
        } // end if
        if (typeof($myFilter) == "string")
        {
            var _loc2 = String($myFilter);
            if (_loc2.substr(-6) != "Filter")
            {
                _loc2 = _loc2 + "Filter";
            } // end if
            for (var _loc3 in com.mosesSupposes.fuse.FuseFMP.$fclasses)
            {
                if (_loc3 == _loc2)
                {
                    return (new com.mosesSupposes.fuse.FuseFMP.$fclasses[_loc3]());
                } // end if
            } // end of for...in
        } // end if
        return (null);
    } // End of the function
    static var registryKey = "fuseFMP";
    static var VERSION = com.mosesSupposes.fuse.FuseKitCommon.VERSION;
} // End of Class
